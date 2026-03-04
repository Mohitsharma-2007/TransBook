import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import '../data/gmail_service.dart';
import '../../../core/constants/app_theme.dart';
import '../../ai/domain/ai_email_generator.dart';

class EmailThreadDetailScreen extends ConsumerStatefulWidget {
  final String threadId;
  final String subject;

  const EmailThreadDetailScreen({
    super.key,
    required this.threadId,
    required this.subject,
  });

  @override
  ConsumerState<EmailThreadDetailScreen> createState() => _EmailThreadDetailScreenState();
}

class _EmailThreadDetailScreenState extends ConsumerState<EmailThreadDetailScreen> {
  bool _isLoading = true;
  dynamic _threadDetails;

  @override
  void initState() {
    super.initState();
    _loadThread();
  }

  Future<void> _loadThread() async {
    final gmail = ref.read(gmailServiceProvider);
    final detail = await gmail.getThreadDetail(widget.threadId);
    if (mounted) {
      setState(() {
        _threadDetails = detail;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subject, style: const TextStyle(fontSize: 16)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _threadDetails == null
              ? const Center(child: Text('Failed to load thread details.'))
              : _buildThreadView(),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildThreadView() {
    final messages = _threadDetails.messages ?? [];
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[index];
        final headers = ref.read(gmailServiceProvider).parseHeaders(msg);
        final from = headers['from'] ?? 'Unknown';
        final date = headers['date'] ?? '';
        final body = _getMessageBody(msg);

        final isMe = from.contains('me');

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: AppTheme.borderLight),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(from, style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.brandPrimary)),
                    Text(date, style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const Divider(height: 24),
                HtmlWidget(body),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getMessageBody(dynamic message) {
    // Simple logic to extract body from Gmail message payload
    // Gmail returns complex nested parts; this is a simplified version
    if (message.payload?.body?.data != null) {
      return _decodeBase64(message.payload!.body!.data!);
    }
    if (message.payload?.parts != null) {
      for (final part in message.payload!.parts!) {
        if (part.mimeType == 'text/html' && part.body?.data != null) {
          return _decodeBase64(part.body!.data!);
        }
      }
      // Fallback to text/plain if no html
      for (final part in message.payload!.parts!) {
        if (part.mimeType == 'text/plain' && part.body?.data != null) {
          return _decodeBase64(part.body!.data!);
        }
      }
    }
    return message.snippet ?? '';
  }

  String _decodeBase64(String input) {
    try {
      // Gmail uses base64url encoding
      String normalized = input.replaceAll('-', '+').replaceAll('_', '/');
      while (normalized.length % 4 != 0) {
        normalized += '=';
      }
      return utf8.decode(base64.decode(normalized));
    } catch (e) {
      return 'Error decoding message body.';
    }
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isLoading || _threadDetails == null ? null : _generateAIReply,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('AI Reply Suggestion'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.brandSecondary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // Future implementation: Manual Reply Composer
              },
              icon: const Icon(Icons.reply),
              label: const Text('Manual Reply'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.brandPrimary,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateAIReply() async {
    setState(() => _isLoading = true);
    try {
      final generator = ref.read(aiEmailGeneratorProvider);
      final threadContext = _getThreadContext();
      
      final suggestion = await generator.generateEmailReply(threadContext, widget.subject);
      
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.auto_awesome, color: AppTheme.brandSecondary),
                SizedBox(width: 8),
                Text('AI Reply Suggestion'),
              ],
            ),
            content: SingleChildScrollView(
              child: HtmlWidget(suggestion),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
              ElevatedButton(
                onPressed: () {
                  // Future: Copy to clipboard or set as draft
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reply suggested. Integration with composer coming soon!')));
                },
                child: const Text('Use this Reply'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to generate AI reply: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _getThreadContext() {
    final messages = _threadDetails?.messages ?? [];
    final sb = StringBuffer();
    for (var msg in messages) {
      final headers = ref.read(gmailServiceProvider).parseHeaders(msg);
      final from = headers['from'] ?? 'Unknown';
      final body = _getMessageBody(msg);
      sb.writeln('From: $from');
      sb.writeln('Body: $body\n---\n');
    }
    return sb.toString();
  }
}
