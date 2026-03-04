import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/database.dart';
import '../../../core/di/database_provider.dart';
import '../../ai/data/openrouter_client.dart';
import 'ai_context_builder.dart';

part 'ai_agent.g.dart';

class AIAgent {
  final OpenRouterClient _client;
  final AIContextBuilder _contextBuilder;
  final AppDatabase _db;

  AIAgent(this._client, this._contextBuilder, this._db);

  final List<Map<String, dynamic>> tools = [
    {
      'type': 'function',
      'function': {
        'name': 'draft_invoice_email',
        'description': 'Drafts an email for a specific invoice to send to a client.',
        'parameters': {
          'type': 'object',
          'properties': {
            'invoice_number': {
              'type': 'string',
              'description': 'The invoice number, e.g., INV-001 or INV-2024-001',
            }
          },
          'required': ['invoice_number']
        }
      }
    },
    {
      'type': 'function',
      'function': {
        'name': 'get_invoice_details',
        'description': 'Retrieves full details of an invoice by its exact invoice number',
        'parameters': {
          'type': 'object',
          'properties': {
            'invoice_number': {
              'type': 'string',
              'description': 'The invoice number'
            }
          },
          'required': ['invoice_number']
        }
      }
    }
  ];

  Future<String> processMessage(List<Map<String, dynamic>> chatMessages) async {
    int maxLoops = 5;
    List<Map<String, dynamic>> currentMessages = List.from(chatMessages);

    while (maxLoops > 0) {
      maxLoops--;
      final response = await _client.chatWithTools(currentMessages, tools);

      if (response.containsKey('tool_calls')) {
        // Add the assistant's action to history
        currentMessages.add({
          'role': 'assistant',
          'tool_calls': response['tool_calls'],
          if (response['content'] != null) 'content': response['content'],
        });

        final toolCalls = response['tool_calls'] as List;
        
        for (var toolCall in toolCalls) {
          final function = toolCall['function'];
          final args = jsonDecode(function['arguments']);
          final resultString = await _executeTool(function['name'], args);
          
          currentMessages.add({
            'role': 'tool',
            'tool_call_id': toolCall['id'],
            'name': function['name'],
            'content': resultString,
          });
        }
        // Let the AI use the tool results to form a reply
        continue;
      } else {
        return response['content'] as String? ?? 'No response generated.';
      }
    }
    
    return "Agent loop exceeded maximum iterations. Please simplify your request.";
  }

  Future<String> _executeTool(String name, Map<String, dynamic> args) async {
    switch (name) {
      case 'draft_invoice_email':
        final invNum = args['invoice_number'];
        final invoice = await (_db.select(_db.invoices)..where((t) => t.invoiceNumber.equals(invNum))).getSingleOrNull();
        if (invoice == null) return "Invoice not found. Tell user the invoice number is invalid.";
        return "System Notification: A draft email for $invNum has been prepared in the background. Tell the user to click the mail icon on the Invoices screen to preview and edit before sending it.";
        
      case 'get_invoice_details':
        final invNum = args['invoice_number'];
        final invoice = await (_db.select(_db.invoices)..where((t) => t.invoiceNumber.equals(invNum))).getSingleOrNull();
        if (invoice == null) return "Invoice not found.";
        return "Invoice ID: ${invoice.id}, Date: ${invoice.invoiceDate}, Total: ₹${invoice.totalAmount}, Status: ${invoice.status}";
        
      default:
        return "Unknown tool";
    }
  }
}

@riverpod
AIAgent aiAgent(AiAgentRef ref) {
  final client = ref.watch(openRouterClientProvider);
  final db = ref.watch(appDatabaseProvider);
  return AIAgent(client, AIContextBuilder(), db);
}
