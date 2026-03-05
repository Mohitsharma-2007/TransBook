import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/database.dart';
import '../../ai/data/openrouter_client.dart';
import 'ai_context_builder.dart';

part 'ai_email_generator.g.dart';

class AIEmailGenerator {
  final OpenRouterClient _client;
  final AIContextBuilder _contextBuilder;

  AIEmailGenerator(this._client, this._contextBuilder);

  /// Generate a professional HTML email body for sending an invoice.
  Future<String> generateInvoiceEmail(Invoice invoice, Company company) async {
    final invoiceContext = _contextBuilder.buildInvoiceContext(invoice, company);

    final messages = [
      {
        'role': 'system',
        'content': '''You are a professional billing assistant for a transportation/logistics company.
Generate a COMPLETE, beautifully formatted HTML email for submitting an invoice to a client.

CRITICAL: You must wrap your HTML in the following branded shell template — replace [CONTENT] with the email body:

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
  body { font-family: Arial, sans-serif; background:#f5f5f5; margin:0; padding:0; }
  .wrapper { max-width:620px; margin:0 auto; background:#fff; border-radius:8px; overflow:hidden; box-shadow:0 2px 12px rgba(0,0,0,0.08); }
  .header { background:linear-gradient(135deg,#1a3c6e,#2d6bc4); color:#fff; padding:32px 40px; }
  .header h1 { margin:0; font-size:24px; font-weight:700; }
  .header p { margin:6px 0 0; font-size:13px; opacity:0.85; }
  .body { padding:32px 40px; color:#333; }
  .greeting { font-size:16px; margin-bottom:20px; }
  .invoice-table { width:100%; border-collapse:collapse; margin:24px 0; }
  .invoice-table th { background:#f0f4fb; color:#1a3c6e; padding:10px 14px; text-align:left; font-size:13px; border-bottom:2px solid #d0ddef; }
  .invoice-table td { padding:10px 14px; font-size:14px; border-bottom:1px solid #eaecf0; }
  .invoice-table tr:last-child td { border-bottom:none; }
  .total-row td { font-weight:bold; background:#f6f9ff; color:#1a3c6e; font-size:15px; }
  .cta-box { background:#f0f4fb; border-left:4px solid #2d6bc4; padding:16px 20px; border-radius:4px; margin:24px 0; }
  .cta-box p { margin:0; font-size:14px; color:#2a4d8f; }
  .footer { background:#f5f7fa; padding:20px 40px; text-align:center; font-size:12px; color:#888; border-top:1px solid #eaecf0; }
  .footer a { color:#2d6bc4; text-decoration:none; }
  .badge { display:inline-block; background:#e0edff; color:#1a3c6e; border-radius:4px; padding:3px 10px; font-size:12px; font-weight:bold; }
</style>
</head>
<body>
<div class="wrapper">
  <div class="header">
    <h1>Invoice Statement</h1>
    <p>TransBook — Powered by JSV Technologies</p>
  </div>
  <div class="body">
    [CONTENT]
  </div>
  <div class="footer">
    <p>This email was sent via TransBook ERP &bull; <a href="mailto:support@jsvtech.com">support@jsvtech.com</a></p>
    <p style="margin-top:6px;">Please do not reply directly to this automated email.</p>
  </div>
</div>
</body>
</html>

The [CONTENT] section should include:
1. A warm but professional greeting using the company name
2. A clear statement of the invoice being submitted
3. An invoice-table with columns: Invoice No | Date | Description | Amount (INR)
4. A total/payable row with GST breakdown if applicable
5. A cta-box with payment request and due date
6. A polite closing paragraph

Return ONLY the complete HTML (starting with <!DOCTYPE html>), no code fences, no explanation.''',
      },
      {
        'role': 'user',
        'content': 'Generate the email for this invoice:\n\n$invoiceContext',
      },
    ];

    final response = await _client.chat(messages);

    // Ensure the response is actual HTML — if AI returns markdown fenced code, strip it
    final cleaned = response
        .replaceAll(RegExp(r'^```html\s*', multiLine: false), '')
        .replaceAll(RegExp(r'^```\s*', multiLine: false), '')
        .replaceAll(RegExp(r'```$', multiLine: false), '')
        .trim();

    return cleaned.isNotEmpty ? cleaned : _fallbackHtml(invoice, company);
  }

  /// Simple fallback HTML in case AI fails
  String _fallbackHtml(Invoice invoice, Company company) {
    return '''<!DOCTYPE html>
<html><head><meta charset="UTF-8"><style>
  body{font-family:Arial,sans-serif;background:#f5f5f5;margin:0;padding:0;}
  .wrapper{max-width:620px;margin:0 auto;background:#fff;border-radius:8px;overflow:hidden;}
  .header{background:linear-gradient(135deg,#1a3c6e,#2d6bc4);color:#fff;padding:32px 40px;}
  .body{padding:32px 40px;color:#333;}
  table{width:100%;border-collapse:collapse;margin:20px 0;}
  th{background:#f0f4fb;color:#1a3c6e;padding:10px;text-align:left;}
  td{padding:10px;border-bottom:1px solid #eee;}
  .footer{background:#f5f7fa;padding:16px 40px;text-align:center;font-size:12px;color:#888;}
</style></head><body>
<div class="wrapper">
  <div class="header"><h1 style="margin:0">Invoice #${invoice.invoiceNumber}</h1></div>
  <div class="body">
    <p>Dear ${company.name},</p>
    <p>Please find below the details of Invoice <strong>#${invoice.invoiceNumber}</strong> dated ${invoice.invoiceDate}.</p>
    <table>
      <tr><th>Invoice No</th><th>Date</th><th>Amount (₹)</th></tr>
      <tr><td>${invoice.invoiceNumber}</td><td>${invoice.invoiceDate}</td><td><strong>₹${invoice.payableAmount?.toStringAsFixed(2) ?? '0.00'}</strong></td></tr>
    </table>
    <p>Kindly process the payment at your earliest convenience. The PDF invoice is attached to this email.</p>
    <p>Thank you for your continued business.</p>
  </div>
  <div class="footer">Sent via TransBook ERP</div>
</div>
</body></html>''';
  }

  /// Generate an AI reply based on the email thread context.
  Future<String> generateEmailReply(String threadContext, String subject) async {
    final messages = [
      {
        'role': 'system',
        'content': '''You are a professional business assistant for a transportation company.
Analyze the email thread and write a professional, concise reply.
Subject: $subject
Tone: Professional, solution-oriented, and courteous.
Return complete HTML (no code fences) using a simple body-only format (no full page wrapping needed).''',
      },
      {
        'role': 'user',
        'content': 'Email thread:\n\n$threadContext\n\nPlease draft a professional reply.',
      },
    ];

    final response = await _client.chat(messages);
    return response
        .replaceAll(RegExp(r'^```html\s*', multiLine: false), '')
        .replaceAll(RegExp(r'^```\s*', multiLine: false), '')
        .replaceAll(RegExp(r'```$'), '')
        .trim();
  }
}

@riverpod
AIEmailGenerator aiEmailGenerator(AiEmailGeneratorRef ref) {
  final client = ref.watch(openRouterClientProvider);
  final contextBuilder = AIContextBuilder();
  return AIEmailGenerator(client, contextBuilder);
}
