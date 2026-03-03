---
phase: 5
plan: 3
wave: 3
---

# Plan 5.3: Gmail Integration

## Objective
Implement Gmail API email sending with PDF attachment support and AI-generated email body.

## Context
- `e:\TransBook\TRD.md` -> Section 8.1, 8.2

## Tasks

<task type="auto">
  <name>Gmail Service</name>
  <files>
    - `e:\TransBook\lib\features\cloud\data\gmail_service.dart`
  </files>
  <action>
    - Create `GmailService` class.
    - Implement `Future<void> sendInvoiceEmail({required String to, required String subject, required String htmlBody, required Uint8List pdfAttachment, required String attachmentName})`.
    - Build MIME message with HTML body + base64-encoded PDF attachment.
    - Stubbed Gmail API call (POST /gmail/v1/users/me/messages/send) behind `isAuthenticated` check.
    - Create riverpod `gmailServiceProvider`.
  </action>
  <verify>dart analyze lib/features/cloud/data/gmail_service.dart</verify>
  <done>GmailService has email-sending method with MIME construction logic.</done>
</task>

<task type="auto">
  <name>AI Email Generator</name>
  <files>
    - `e:\TransBook\lib\features\ai\domain\ai_email_generator.dart`
  </files>
  <action>
    - Create `AIEmailGenerator` that uses `OpenRouterClient` and `AIContextBuilder`.
    - Implement `Future<String> generateInvoiceEmail(Invoice invoice, Company company)`.
    - Uses a system prompt for professional billing email generation.
    - Returns HTML email body string.
    - Create riverpod `aiEmailGeneratorProvider`.
  </action>
  <verify>dart analyze lib/features/ai/domain/ai_email_generator.dart</verify>
  <done>AI email generator produces HTML email bodies.</done>
</task>

## Success Criteria
- [ ] `GmailService` constructs MIME messages with PDF attachments.
- [ ] `AIEmailGenerator` uses OpenRouter to produce email drafts.
- [ ] Code passes static analysis.
