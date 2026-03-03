---
phase: 5
plan: 1
wave: 1
---

# Plan 5.1: OpenRouter AI Client & Context Builder

## Objective
Implement the OpenRouter REST API client with model fallback chain, and an `AIContextBuilder` that assembles invoice/firm data into AI prompts.

## Context
- `e:\TransBook\TRD.md` -> Section 5.1, 5.2, 5.3
- `e:\TransBook\pubspec.yaml` (dio dependency)

## Tasks

<task type="auto">
  <name>OpenRouter Client</name>
  <files>
    - `e:\TransBook\lib\features\ai\data\openrouter_client.dart`
  </files>
  <action>
    - Create `OpenRouterClient` using `dio` for HTTP.
    - Define model priority list: gpt-4o, mistral-large, gemini-pro, llama-3.1 fallback.
    - Implement `Future<String> chat(List<Map<String,String>> messages, {String? preferredModel})`.
    - Loop through models; on rate limit or quota exhaustion, fall back to next model.
    - Store API key via a simple config provider (can be upgraded to secure storage in Phase 6).
    - Create riverpod `openRouterClientProvider`.
  </action>
  <verify>dart analyze lib/features/ai/data/</verify>
  <done>Client compiles and supports model fallback chain.</done>
</task>

<task type="auto">
  <name>AI Context Builder</name>
  <files>
    - `e:\TransBook\lib\features\ai\domain\ai_context_builder.dart`
  </files>
  <action>
    - Create `AIContextBuilder` with methods:
      - `String buildInvoiceContext(Invoice invoice, Company company)` — assembles key invoice fields into a structured prompt string.
      - `String buildGlobalContext(List<Invoice> recentInvoices)` — summary stats for general queries.
    - Keep context compact to minimize token usage.
  </action>
  <verify>dart analyze lib/features/ai/domain/</verify>
  <done>Context builder produces formatted prompt strings from invoice data.</done>
</task>

## Success Criteria
- [ ] `OpenRouterClient` sends requests to OpenRouter API with model fallback.
- [ ] `AIContextBuilder` produces context strings from invoice data.
- [ ] Code passes static analysis.
