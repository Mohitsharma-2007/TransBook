import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/database/database.dart';
import '../../../core/di/database_provider.dart';
import '../../ai/data/openrouter_client.dart';
import '../../cloud/data/gmail_service.dart';
import 'ai_context_builder.dart';

part 'ai_agent.g.dart';

class AIAgent {
  final OpenRouterClient _client;
  final AIContextBuilder _contextBuilder;
  final AppDatabase _db;
  final GmailService _gmailService;

  AIAgent(this._client, this._contextBuilder, this._db, this._gmailService);

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
            'invoice_number': {'type': 'string', 'description': 'The invoice number'}
          },
          'required': ['invoice_number']
        }
      }
    },
    {
      'type': 'function',
      'function': {
        'name': 'search_invoices',
        'description': 'Search for invoices by company name or partial invoice number.',
        'parameters': {
          'type': 'object',
          'properties': {
            'query': {'type': 'string', 'description': 'Search query (company name or number)'}
          },
          'required': ['query']
        }
      }
    },
    {
      'type': 'function',
      'function': {
        'name': 'get_company_details',
        'description': 'Get details about a company including GSTIN and address.',
        'parameters': {
          'type': 'object',
          'properties': {
            'name': {'type': 'string', 'description': 'Exact or partial company name'}
          },
          'required': ['name']
        }
      }
    },
    {
      'type': 'function',
      'function': {
        'name': 'get_pending_balance',
        'description': 'Calculate the total unpaid/pending balance for a company.',
        'parameters': {
          'type': 'object',
          'properties': {
            'company_name': {'type': 'string', 'description': 'Name of the company'}
          },
          'required': ['company_name']
        }
      }
    },
    {
      'type': 'function',
      'function': {
        'name': 'list_gmail_threads',
        'description': 'List recent Gmail email threads. Use this when the user asks about emails received, recent correspondence, or to check their inbox.',
        'parameters': {
          'type': 'object',
          'properties': {
            'max_results': {'type': 'integer', 'description': 'Maximum threads to return (1-20)', 'default': 10}
          },
          'required': []
        }
      }
    },
    {
      'type': 'function',
      'function': {
        'name': 'fetch_gmail_thread',
        'description': 'Fetch the full subject and snippet of a specific Gmail thread by its ID.',
        'parameters': {
          'type': 'object',
          'properties': {
            'thread_id': {'type': 'string', 'description': 'The Gmail thread ID'}
          },
          'required': ['thread_id']
        }
      }
    },
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
        return "Invoice ID: ${invoice.id}, Date: ${invoice.invoiceDate}, Total: ₹${invoice.payableAmount}, Status: ${invoice.status}";

      case 'search_invoices':
        final query = args['query'] as String;
        final allInvoices = await _db.select(_db.invoices).get();
        final results = allInvoices.where((i) => i.invoiceNumber.toLowerCase().contains(query.toLowerCase())).toList();
        if (results.isEmpty) return "No invoices found matching '$query'.";
        return results.map((i) => "Invoice #${i.invoiceNumber} (\u20b9${i.payableAmount}) on ${i.invoiceDate}").join("\n");

      case 'get_company_details':
        final name = args['name'] as String;
        final allCompanies = await _db.select(_db.companies).get();
        final company = allCompanies.where((c) => c.name.toLowerCase().contains(name.toLowerCase())).firstOrNull;
        if (company == null) return "Company '$name' not found in database.";
        return "Company: ${company.name}, GSTIN: ${company.gstin}, Address: ${company.address}, Type: ${company.invoiceType}";

      case 'get_pending_balance':
        final name = args['company_name'] as String;
        final allCompanies2 = await _db.select(_db.companies).get();
        final company = allCompanies2.where((c) => c.name.toLowerCase().contains(name.toLowerCase())).firstOrNull;
        if (company == null) return "Company not found.";
        
        final allInvoices2 = await (_db.select(_db.invoices)..where((t) => t.companyId.equals(company.id))).get();
        final unpaidInvoices = allInvoices2.where((i) => i.status == 'DRAFT').toList();
        final total = unpaidInvoices.fold<double>(0, (sum, i) => sum + (i.payableAmount ?? 0));
        return "Total Pending/Draft balance for ${company.name} is \u20b9$total across ${unpaidInvoices.length} invoices.";

      case 'list_gmail_threads':
        if (!_gmailService.isAuthenticated) {
          return "Not connected to Gmail. Please sign in with Google in Settings first.";
        }
        final maxResults = (args['max_results'] as int?) ?? 10;
        final threads = await _gmailService.fetchThreads(maxResults: maxResults);
        if (threads.isEmpty) return "No Gmail threads found.";
        return threads.asMap().entries.map((e) => "${e.key + 1}. Thread ID: ${e.value.id} — Snippet: ${e.value.snippet ?? '(no snippet)'}" ).join("\n");

      case 'fetch_gmail_thread':
        if (!_gmailService.isAuthenticated) {
          return "Not connected to Gmail. Please sign in with Google in Settings first.";
        }
        final threadId = args['thread_id'] as String;
        final thread = await _gmailService.getThreadDetail(threadId);
        if (thread == null) return "Thread not found.";
        final messages = thread.messages ?? [];
        if (messages.isEmpty) return "Thread is empty.";
        final summary = messages.map((m) {
          final headers = <String, String>{};
          for (final h in m.payload?.headers ?? []) {
            if (h.name != null && h.value != null) headers[h.name!.toLowerCase()] = h.value!;
          }
          return "From: ${headers['from'] ?? 'Unknown'} | Subject: ${headers['subject'] ?? 'N/A'} | Snippet: ${m.snippet ?? ''}".trim();
        }).join("\n---\n");
        return summary;
        
      default:
        return "Unknown tool";
    }
  }
}

@riverpod
AIAgent aiAgent(AiAgentRef ref) {
  final client = ref.watch(openRouterClientProvider);
  final db = ref.watch(appDatabaseProvider);
  final gmailService = ref.watch(gmailServiceProvider);
  return AIAgent(client, AIContextBuilder(), db, gmailService);
}
