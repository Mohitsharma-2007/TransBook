import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'gmail_service.g.dart';

class GmailService {
  final Dio _dio;
  String? _accessToken;
  bool _isAuthenticated = false;

  GmailService({Dio? dio}) : _dio = dio ?? Dio();

  bool get isAuthenticated => _isAuthenticated;

  void setAccessToken(String token) {
    _accessToken = token;
    _isAuthenticated = true;
  }

  /// Send an email with HTML body and optional PDF attachment via Gmail API.
  Future<bool> sendInvoiceEmail({
    required String to,
    required String subject,
    required String htmlBody,
    Uint8List? pdfAttachment,
    String? attachmentName,
  }) async {
    if (!_isAuthenticated || _accessToken == null) return false;

    try {
      final mimeMessage = _buildMimeMessage(
        to: to,
        subject: subject,
        htmlBody: htmlBody,
        pdfAttachment: pdfAttachment,
        attachmentName: attachmentName,
      );

      final encodedMessage = base64Url.encode(utf8.encode(mimeMessage));

      await _dio.post(
        'https://gmail.googleapis.com/gmail/v1/users/me/messages/send',
        data: {'raw': encodedMessage},
        options: Options(
          headers: {
            'Authorization': 'Bearer $_accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      return true;
    } catch (_) {
      return false;
    }
  }

  String _buildMimeMessage({
    required String to,
    required String subject,
    required String htmlBody,
    Uint8List? pdfAttachment,
    String? attachmentName,
  }) {
    const boundary = '----TransBookBoundary';

    final buffer = StringBuffer();
    buffer.writeln('To: $to');
    buffer.writeln('Subject: $subject');
    buffer.writeln('MIME-Version: 1.0');

    if (pdfAttachment != null && attachmentName != null) {
      buffer.writeln('Content-Type: multipart/mixed; boundary="$boundary"');
      buffer.writeln();
      buffer.writeln('--$boundary');
      buffer.writeln('Content-Type: text/html; charset="UTF-8"');
      buffer.writeln();
      buffer.writeln(htmlBody);
      buffer.writeln();
      buffer.writeln('--$boundary');
      buffer.writeln('Content-Type: application/pdf; name="$attachmentName"');
      buffer.writeln('Content-Disposition: attachment; filename="$attachmentName"');
      buffer.writeln('Content-Transfer-Encoding: base64');
      buffer.writeln();
      buffer.writeln(base64.encode(pdfAttachment));
      buffer.writeln('--$boundary--');
    } else {
      buffer.writeln('Content-Type: text/html; charset="UTF-8"');
      buffer.writeln();
      buffer.writeln(htmlBody);
    }

    return buffer.toString();
  }
}

@riverpod
GmailService gmailService(GmailServiceRef ref) {
  return GmailService();
}
