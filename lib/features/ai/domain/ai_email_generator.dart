import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/database.dart';
import '../../ai/data/openrouter_client.dart';
import 'ai_context_builder.dart';

part 'ai_email_generator.g.dart';

class AIEmailGenerator {
  final OpenRouterClient _client;
  final AIContextBuilder _contextBuilder;

  AIEmailGenerator(this._client, this._contextBuilder);

  /// Generate an HTML email body for sending an invoice to a company.
  Future<String> generateInvoiceEmail(Invoice invoice, Company company) async {
    final invoiceContext = _contextBuilder.buildInvoiceContext(invoice, company);

    final messages = [
      {
        'role': 'system',
        'content': '''You are a professional billing assistant for a transportation company.
Generate a formal, professional email in HTML format for submitting an invoice.
Include:
- A polite greeting addressed to the company
- A brief summary table with invoice number, date, and total amount
- A payment request with due details
- Contact information footer
Keep the tone formal, polite, and concise.
Return ONLY the HTML content, no explanation.''',
      },
      {
        'role': 'user',
        'content': 'Generate an email for the following invoice:\n\n$invoiceContext',
      },
    ];

    final response = await _client.chat(messages);
    return response;
  }
}

@riverpod
AIEmailGenerator aiEmailGenerator(AiEmailGeneratorRef ref) {
  final client = ref.watch(openRouterClientProvider);
  final contextBuilder = AIContextBuilder();
  return AIEmailGenerator(client, contextBuilder);
}
