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
import '../../cloud/data/google_auth_service.dart';

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

  // Editable email fields
  final _toController = TextEditingController();
  final _ccController = TextEditingController();
  final _subjectController = TextEditingController();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill from company data
    final first = widget.invoices.first;
    _toController.text = first.company?.contactEmail ?? '';
    _subjectController.text = widget.invoices.length == 1
        ? 'Invoice ${first.invoice.invoiceNumber}'
        : 'Invoices from ${first.company?.name ?? "Us"}';
    _generateEmail();
  }

  @override
  void dispose() {
    _toController.dispose();
    _ccController.dispose();
    _subjectController.dispose();
    super.dispose();
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
    final to = _toController.text.trim();
    if (to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a recipient email address in the To: field.'), backgroundColor: AppTheme.errorColor)
      );
      return;
    }

    final gmail = ref.read(gmailServiceProvider);
    if (!gmail.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in with Google in Settings first.'))
      );
      return;
    }

    setState(() => _isSending = true);

    final success = await gmail.sendEmail(
      to: to,
      subject: _subjectController.text.trim().isNotEmpty
          ? _subjectController.text.trim()
          : 'Invoice from TransBook',
      htmlBody: _htmlContent ?? '',
      attachments: _attachments,
    );

    if (mounted) {
      setState(() => _isSending = false);
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
        width: 860,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title bar ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(children: [
                  Icon(Icons.email_outlined, color: AppTheme.brandPrimary),
                  SizedBox(width: 10),
                  Text('Compose & Send Email', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ]),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const Divider(height: 20),

            // ── Compose header fields ──
            _EmailField(label: 'To *', controller: _toController, hint: 'recipient@company.com'),
            const SizedBox(height: 6),
            _EmailField(label: 'CC', controller: _ccController, hint: 'cc@address.com (optional)'),
            const SizedBox(height: 6),
            _EmailField(label: 'Subject', controller: _subjectController, hint: 'Email subject line'),
            const Divider(height: 20),

            // ── Email body preview ──
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
            // Auth status banner
            Consumer(
              builder: (context, ref, _) {
                final authService = ref.read(googleAuthServiceProvider);
                if (authService.currentUser == null) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      border: Border.all(color: Colors.orange.shade300),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber_rounded, color: Colors.orange.shade700, size: 20),
                        const SizedBox(width: 10),
                        Expanded(child: Text(
                          'Not signed in to Google. Open Settings → "Sign In with Google" to enable Gmail sending.',
                          style: TextStyle(color: Colors.orange.shade800, fontSize: 13),
                        )),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Attachment info
                if (_attachments.isNotEmpty)
                  Row(
                    children: [
                      const Icon(Icons.attach_file, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 4),
                      Text('${_attachments.length} PDF${_attachments.length > 1 ? 's' : ''} attached',
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                    ],
                  )
                else
                  const SizedBox.shrink(),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _isLoading || _isSending || _error != null ? null : _sendViaGmailService,
                      icon: _isSending
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.send),
                      label: Text(_isSending ? 'Sending...' : 'Send with PDF via Gmail'),
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
            ),
          ],
        ),
      ),
    );
  }
}

/// Compact labeled email field for the composer header
class _EmailField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;

  const _EmailField({required this.label, required this.controller, this.hint = ''});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 62,
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textSecondary)),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
          ),
        ),
      ],
    );
  }
}
