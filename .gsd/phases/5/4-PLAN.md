---
phase: 5
plan: 4
wave: 4
---

# Plan 5.4: AI Sidebar UI

## Objective
Build a sliding AI sidebar panel accessible from the app shell, allowing users to chat with the AI assistant about invoices, rates, and billing queries.

## Context
- `e:\TransBook\lib\main.dart`
- `e:\TransBook\lib\features\ai\data\openrouter_client.dart`
- `e:\TransBook\lib\features\ai\domain\ai_context_builder.dart`

## Tasks

<task type="auto">
  <name>AI Chat Sidebar</name>
  <files>
    - `e:\TransBook\lib\features\ai\presentation\ai_sidebar.dart`
  </files>
  <action>
    - Create `AISidebar` as a `ConsumerStatefulWidget`.
    - Chat-style UI: message list (user + AI bubbles), text input at the bottom, send button.
    - On send: build context via `AIContextBuilder.buildGlobalContext`, call `OpenRouterClient.chat`, display response.
    - Show loading indicator during AI response.
    - Support scrolling message history within the session.
  </action>
  <verify>dart analyze lib/features/ai/presentation/ai_sidebar.dart</verify>
  <done>AI sidebar renders chat interface with send/receive flow.</done>
</task>

<task type="auto">
  <name>Integrate AI Sidebar into Main Shell</name>
  <files>
    - `e:\TransBook\lib\main.dart`
  </files>
  <action>
    - Add a FAB or AppBar icon button that toggles an `endDrawer` containing `AISidebar`.
    - Use `Scaffold.endDrawer` for the sliding panel behavior.
  </action>
  <verify>dart analyze lib/main.dart</verify>
  <done>AI sidebar toggles from the app bar.</done>
</task>

## Success Criteria
- [ ] AI chat sidebar is functional with message input and response display.
- [ ] Sidebar is accessible from the main app shell.
