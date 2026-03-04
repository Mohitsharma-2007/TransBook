import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_theme.dart';
import '../../ai/domain/ai_email_generator.dart';
import '../data/invoice_repository.dart';

import 'dart:io';
import '../../pdf_excel/domain/invoice_pdf_generator.dart';
import '../../profile/data/user_profile_repository.dart';
import '../../../core/services/file_storage_service.dart';
import '../../cloud/data/gmail_service.dart';

class EmailPreviewDialog extends ConsumerStatefulWidget {
  final List<InvoiceWithCompany> invoices;

  const EmailPreviewDialog({super.key, required this.invoices});

  @override
  ConsumerState<EmailPreviewDialog> createState() => _EmailPreviewDialogState();
}

class _EmailPreviewDialogState extends ConsumerState<EmailPreviewDialog> {
  String? _htmlContent;
  bool _isLoading = true;
  String? _error;
  List<EmailAttachment> _attachments = [];

  @override
  void initState() {
    super.initState();
    _generateEmail();
  }

  Future<void> _generateEmail() async {
    if (widget.invoices.isEmpty) return;

    try {
      final generator = ref.read(aiEmailGeneratorProvider);
      final profile = ref.read(userProfileProvider);
      
      final firstInvoice = widget.invoices.first;
      if (firstInvoice.company == null) {
        throw Exception('Company data is missing.');
      }
      
      String content;
      if (widget.invoices.length == 1) {
        content = await generator.generateInvoiceEmail(
          firstInvoice.invoice,
          firstInvoice.company!,
        );
      } else {
        // Simple combined message for multiple invoices
        // In a real scenario, the AI generator could handle this better
        final sb = StringBuffer();
        sb.writeln('<h2>Multiple Invoices for ${firstInvoice.company!.name}</h2>');
        sb.writeln('<p>Please find attached the following invoices:</p><ul>');
        for (final inv in widget.invoices) {
          sb.writeln('<li>Invoice: ${inv.invoice.invoiceNumber} (Amount: ₹${inv.invoice.totalAmount})</li>');
        }
        sb.writeln('</ul>');
        sb.writeln('<p>Thank you for your business!</p>');
        content = sb.toString();
      }

      // Prepare attachments
      final storage = ref.read(fileStorageServiceProvider);
      final pdfGen = InvoicePdfGenerator();
      
      final List<EmailAttachment> attachments = [];
      for (final inv in widget.invoices) {
        final fullInv = await ref.read(invoiceRepositoryProvider).getInvoiceWithRows(inv.invoice.id);
        if (fullInv != null) {
          final bytes = await InvoicePdfGenerator.generate(fullInv, profile);
          attachments.add(EmailAttachment(
            bytes: bytes,
            fileName: '${inv.invoice.invoiceNumber.replaceAll('/', '_')}.pdf',
          ));
        }
      }

      if (mounted) {
        setState(() {
          _htmlContent = content;
          _attachments = attachments;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _sendViaGmailService() async {
    final gmail = ref.read(gmailServiceProvider);
    if (!gmail.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in with Google in Settings first.'))
      );
      return;
    }

    final firstInvoice = widget.invoices.first;
    final companyEmail = firstInvoice.company?.contactEmail ?? '';
    final subject = widget.invoices.length == 1 
        ? 'Invoice ${firstInvoice.invoice.invoiceNumber}'
        : 'Multiple Invoices - ${widget.invoices.length} items';

    setState(() => _isLoading = true);

    final success = await gmail.sendEmail(
      to: companyEmail,
      subject: subject,
      htmlBody: _htmlContent ?? '',
      attachments: _attachments,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email sent successfully!')));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to send email via Gmail.')));
      }
    }
  }

  Future<void> _sendViaGmail() async {
    final firstInvoice = widget.invoices.first;
    final companyEmail = firstInvoice.company?.contactEmail ?? '';
    final subject = 'Invoice ${firstInvoice.invoice.invoiceNumber} from ${ref.read(userProfileProvider).companyName.toUpperCase()}';
    
    // We launch the default mail client using mailto. The HTML content cannot be perfectly passed to mailto body across all clients, so we pass a clean stripped down version.
    final body = 'Dear ${firstInvoice.company?.name ?? 'Client'},\n\nPlease find attached Invoice ${firstInvoice.invoice.invoiceNumber} for your review and processing.\n\nAdditionally, here is a summary:\n\n${_stripHtml(_htmlContent ?? '')}\n\nThank you,\n${ref.read(userProfileProvider).companyName}';
    
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: companyEmail,
      query: _encodeQueryParameters(<String, String>{
        'subject': subject,
        'body': body,
      }),
    );

    try {
      if (!await launchUrl(emailLaunchUri)) {
        throw Exception('Could not launch email client');
      }
      if (mounted) {
        Navigator.pop(context, true); // True indicating success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to launch email: $e')));
      }
    }
  }
  
  String _stripHtml(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').trim();
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 800,
        height: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Live Email Preview', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const Divider(),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _error != null 
                  ? Center(child: Text('Error generating email: \n$_error', style: const TextStyle(color: AppTheme.errorColor)))
                  : Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: AppTheme.borderLight),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: SingleChildScrollView(
                        child: HtmlWidget(_htmlContent ?? ''),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Note: Attach the printed PDF manually in your mail client.', style: TextStyle(color: AppTheme.textSecondary, fontStyle: FontStyle.italic)),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _isLoading || _error != null ? null : _sendViaGmailService,
                      icon: const Icon(Icons.send),
                      label: const Text('Send via Gmail API'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.brandPrimary,
                        foregroundColor: AppTheme.surfaceWhite,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: _isLoading || _error != null ? null : _sendViaGmail,
                      icon: const Icon(Icons.open_in_new),
                      tooltip: 'Open in External Mail Client',
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
