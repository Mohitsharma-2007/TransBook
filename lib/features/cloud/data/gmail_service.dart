import 'dart:convert';
import 'dart:typed_data';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;

import 'google_auth_service.dart';

// part 'gmail_service.g.dart';

class EmailAttachment {
  final Uint8List bytes;
  final String fileName;
  final String contentType;

  EmailAttachment({
    required this.bytes,
    required this.fileName,
    this.contentType = 'application/pdf',
  });
}

class GmailService {
  final GoogleAuthService _authService;

  GmailService(this._authService);

  bool get isAuthenticated => _authService.currentUser != null;

  /// Send an email with HTML body and multiple attachments.
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String htmlBody,
    List<EmailAttachment>? attachments,
  }) async {
    final client = await _authService.getAuthenticatedClient();
    if (client == null) return false;

    final gmailApi = gmail.GmailApi(client);

    try {
      final mimeMessage = _buildMimeMessage(
        to: to,
        subject: subject,
        htmlBody: htmlBody,
        attachments: attachments,
      );

      final encodedMessage = base64Url.encode(utf8.encode(mimeMessage));

      final message = gmail.Message()..raw = encodedMessage;

      await gmailApi.users.messages.send(message, 'me');

      return true;
    } catch (e) {
      print('Gmail Error: $e');
      return false;
    } finally {
      client.close();
    }
  }

  /// Fetch Recent Threads from Gmail.
  Future<List<gmail.Thread>> fetchThreads({int maxResults = 20}) async {
    final client = await _authService.getAuthenticatedClient();
    if (client == null) return [];

    final gmailApi = gmail.GmailApi(client);

    try {
      final response = await gmailApi.users.threads.list('me', maxResults: maxResults);
      return response.threads ?? [];
    } catch (e) {
      print('Gmail Fetch Error: $e');
      return [];
    } finally {
      client.close();
    }
  }

  /// Get Details for a specific Thread.
  Future<gmail.Thread?> getThreadDetail(String threadId) async {
    final client = await _authService.getAuthenticatedClient();
    if (client == null) return null;

    final gmailApi = gmail.GmailApi(client);

    try {
      return await gmailApi.users.threads.get('me', threadId);
    } catch (e) {
      print('Gmail Thread Detail Error: $e');
      return null;
    } finally {
      client.close();
    }
  }

  /// Parse headers from a Gmail message.
  Map<String, String> parseHeaders(gmail.Message message) {
    final headers = <String, String>{};
    if (message.payload?.headers != null) {
      for (final header in message.payload!.headers!) {
        if (header.name != null && header.value != null) {
          headers[header.name!.toLowerCase()] = header.value!;
        }
      }
    }
    return headers;
  }

  String _buildMimeMessage({
    required String to,
    required String subject,
    required String htmlBody,
    List<EmailAttachment>? attachments,
  }) {
    const boundary = '----TransBookBoundary';

    final buffer = StringBuffer();
    buffer.writeln('To: $to');
    buffer.writeln('Subject: $subject');
    buffer.writeln('Content-Type: multipart/mixed; boundary="$boundary"');
    buffer.writeln('MIME-Version: 1.0');
    buffer.writeln();

    buffer.writeln('--$boundary');
    buffer.writeln('Content-Type: text/html; charset="UTF-8"');
    buffer.writeln();
    buffer.writeln(htmlBody);
    buffer.writeln();

    if (attachments != null && attachments.isNotEmpty) {
      for (final attachment in attachments) {
        buffer.writeln('--$boundary');
        buffer.writeln('Content-Type: ${attachment.contentType}; name="${attachment.fileName}"');
        buffer.writeln('Content-Disposition: attachment; filename="${attachment.fileName}"');
        buffer.writeln('Content-Transfer-Encoding: base64');
        buffer.writeln();
        buffer.writeln(base64.encode(attachment.bytes));
        buffer.writeln();
      }
    }

    buffer.writeln('--$boundary--');

    return buffer.toString();
  }
}

final gmailServiceProvider = Provider((ref) {
  final authService = ref.watch(googleAuthServiceProvider);
  return GmailService(authService);
});

