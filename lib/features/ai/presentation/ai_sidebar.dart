import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_theme.dart';
import '../domain/ai_context_builder.dart';
import '../domain/ai_agent.dart';
import '../../../core/di/database_provider.dart';

class AISidebar extends ConsumerStatefulWidget {
  const AISidebar({super.key});

  @override
  ConsumerState<AISidebar> createState() => _AISidebarState();
}

class _AISidebarState extends ConsumerState<AISidebar> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(role: 'user', content: text));
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final agent = ref.read(aiAgentProvider);
      final db = ref.read(appDatabaseProvider);
      final invoices = await db.select(db.invoices).get();
      final contextBuilder = AIContextBuilder();
      final globalContext = contextBuilder.buildGlobalContext(invoices);

      final chatMessages = <Map<String, dynamic>>[
        {'role': 'system', 'content': '$globalContext\nYou are a helpful AI agent. Use tools when needed to fetch details or draft emails.'},
        ..._messages.map((m) => {'role': m.role, 'content': m.content}),
      ];

      final response = await agent.processMessage(chatMessages);

      setState(() {
        _messages.add(_ChatMessage(role: 'assistant', content: response));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(_ChatMessage(role: 'assistant', content: 'Error: $e'));
        _isLoading = false;
      });
    }
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildQuickActions() {
    final actions = [
      'Show pending balance',
      'Search invoice #123',
      'Summarize billing',
    ];

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 8,
      runSpacing: 8,
      children: actions.map((a) => ActionChip(
        label: Text(a.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
        onPressed: () {
          _controller.text = a;
          _sendMessage();
        },
      )).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      child: Drawer(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.brandPrimary,
                border: Border(bottom: BorderSide(color: AppTheme.borderLight)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.smart_toy, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'AI Assistant',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Messages
            Expanded(
              child: _messages.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, size: 48, color: AppTheme.brandPrimary.withAlpha(100)),
                          const SizedBox(height: 16),
                          const Text('TransBook Intelligence Center', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32),
                            child: Text(
                              'Ask me to find pendency, draft emails, or summarize your billing cycle.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildQuickActions(),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(12),
                      itemCount: _messages.length,
                      itemBuilder: (context, index) {
                        final msg = _messages[index];
                        final isUser = msg.role == 'user';
                        return Align(
                          alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 300),
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isUser ? AppTheme.brandSecondary : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              msg.content,
                              style: TextStyle(color: isUser ? Colors.white : AppTheme.textPrimary),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Loading indicator
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
              ),

            // Input
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppTheme.borderLight))),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ask anything...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppTheme.brandSecondary),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String role;
  final String content;

  _ChatMessage({required this.role, required this.content});
}
