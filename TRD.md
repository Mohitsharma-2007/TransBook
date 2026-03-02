# Technical Requirements Document (TRD)
## Trans Book — AI-Powered Transportation Billing & Management System
**Version:** 1.0.0 | **Date:** March 2026 | **Stack:** Flutter (Windows) + Dart

---

## 1. Technology Stack

| Layer | Technology | Reason |
|-------|------------|--------|
| **UI Framework** | Flutter (Windows Desktop) | Single codebase, rich widgets, performance |
| **Language** | Dart | Flutter-native, strong typing |
| **Local Database** | Drift (SQLite wrapper for Dart) | Type-safe, reactive, offline-first |
| **State Management** | Riverpod | Scalable, testable, async-friendly |
| **PDF Generation** | `pdf` (dart) + `printing` | Native Dart PDF engine |
| **Excel Generation** | `excel` dart package | XLSX read/write |
| **Cloud Storage** | Google Drive API v3 + OneDrive API | OAuth2 via `google_sign_in` / MSAL |
| **AI Layer** | OpenRouter API (REST) | Multi-model, free tier available |
| **Email** | Gmail API v1 (OAuth2) | Professional email from app |
| **Installer** | Inno Setup 6.x | Windows EXE installer |
| **HTTP Client** | `dio` dart package | Interceptors, retry, cancel |
| **Encryption** | `encrypt` package (AES-256) | Local DB + file encryption |
| **Notifications** | `local_notifier` + Windows toast | In-app + OS notifications |
| **File Dialogs** | `file_picker` | Native Windows file dialogs |
| **Logging** | `logger` package | Structured logging |
| **Config** | `shared_preferences` | App settings, non-sensitive config |
| **Secrets** | Windows Credential Manager via FFI | Secure key/token storage |

---

## 2. Project Architecture

### 2.1 Architecture Pattern: Clean Architecture + Feature-First

```
lib/
├── core/
│   ├── constants/          # App constants, GST rates, FY rules
│   ├── database/           # Drift DB definition, tables, DAOs
│   ├── di/                 # Dependency injection (Riverpod providers)
│   ├── errors/             # Custom exceptions, failure classes
│   ├── extensions/         # Dart extensions (currency, dates)
│   ├── services/           # Cross-cutting: cloud, email, notifications
│   └── utils/              # Indian number formatter, amount in words
│
├── features/
│   ├── invoicing/
│   │   ├── data/           # Repos, DTOs, local data sources
│   │   ├── domain/         # Entities, use cases, repo interfaces
│   │   └── presentation/   # Screens, widgets, controllers
│   │
│   ├── billing_management/
│   ├── tds/
│   ├── payment_distribution/
│   ├── record_book/
│   ├── master_data/        # Companies, Vehicles, Partners
│   ├── ledger/
│   ├── pdf_excel/
│   ├── email/
│   ├── reminders/
│   ├── ai_chat/
│   └── settings/
│
└── main.dart
```

---

## 3. Database Schema (Drift / SQLite)

### 3.1 Core Tables

#### `firms` (Single firm per installation)
```sql
CREATE TABLE firms (
  id          INTEGER PRIMARY KEY,
  name        TEXT NOT NULL,
  address     TEXT,
  phone       TEXT,
  email       TEXT,
  pan         TEXT,
  gstin       TEXT,
  state       TEXT,
  state_code  TEXT,
  logo_path   TEXT,
  bank_name   TEXT,
  bank_account TEXT,
  bank_ifsc   TEXT,
  beneficiary_name TEXT,
  invoice_prefix TEXT DEFAULT 'JSV',
  current_invoice_seq INTEGER DEFAULT 1,
  financial_year_start TEXT,  -- e.g. "2025-04-01"
  created_at  TEXT
);
```

#### `companies`
```sql
CREATE TABLE companies (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  name          TEXT NOT NULL,
  address       TEXT,
  pan           TEXT,
  gstin         TEXT,
  state         TEXT,
  state_code    TEXT,
  hsn_sac       TEXT DEFAULT '996791',
  invoice_type  TEXT CHECK(invoice_type IN ('STATE','INTER_STATE')) NOT NULL,
  default_loading_place TEXT,
  contact_name  TEXT,
  contact_email TEXT,
  contact_phone TEXT,
  is_active     INTEGER DEFAULT 1,
  created_at    TEXT,
  updated_at    TEXT
);
```

#### `freight_rate_cards`
```sql
CREATE TABLE freight_rate_cards (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  company_id      INTEGER REFERENCES companies(id),
  loading_place   TEXT,
  unloading_place TEXT NOT NULL,
  rate_amount     REAL NOT NULL,
  effective_from  TEXT,
  is_active       INTEGER DEFAULT 1
);
```

#### `vehicles`
```sql
CREATE TABLE vehicles (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  vehicle_no      TEXT NOT NULL UNIQUE,
  partner_id      INTEGER REFERENCES partners(id),
  vehicle_type    TEXT,
  fitness_expiry  TEXT,
  insurance_expiry TEXT,
  is_active       INTEGER DEFAULT 1,
  notes           TEXT
);
```

#### `partners`
```sql
CREATE TABLE partners (
  id           INTEGER PRIMARY KEY AUTOINCREMENT,
  name         TEXT NOT NULL,
  phone        TEXT,
  pan          TEXT,
  bank_name    TEXT,
  bank_account TEXT,
  bank_ifsc    TEXT,
  share_percent REAL,
  is_active    INTEGER DEFAULT 1
);
```

#### `invoices`
```sql
CREATE TABLE invoices (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  invoice_number  TEXT NOT NULL UNIQUE,   -- e.g. JSV/25-26/100
  invoice_date    TEXT NOT NULL,
  company_id      INTEGER REFERENCES companies(id),
  invoice_type    TEXT CHECK(invoice_type IN ('STATE','INTER_STATE')),
  total_freight   REAL DEFAULT 0,
  total_fastag    REAL DEFAULT 0,
  total_amount    REAL DEFAULT 0,
  sgst_rate       REAL DEFAULT 2.5,
  cgst_rate       REAL DEFAULT 2.5,
  igst_rate       REAL DEFAULT 5.0,
  sgst_amount     REAL DEFAULT 0,
  cgst_amount     REAL DEFAULT 0,
  igst_amount     REAL DEFAULT 0,
  gst_rcm_total   REAL DEFAULT 0,
  tds_rate        REAL DEFAULT 2.0,
  tds_amount      REAL DEFAULT 0,
  payable_amount  REAL DEFAULT 0,
  amount_in_words TEXT,
  status          TEXT DEFAULT 'DRAFT',  -- DRAFT|SUBMITTED|ACKNOWLEDGED|PAID|PARTIAL
  submission_date TEXT,
  payment_received REAL DEFAULT 0,
  payment_date    TEXT,
  pdf_path        TEXT,
  cloud_synced    INTEGER DEFAULT 0,
  template_id     INTEGER,
  notes           TEXT,
  financial_year  TEXT,                  -- e.g. "2025-26"
  created_at      TEXT,
  updated_at      TEXT
);
```

#### `invoice_rows`
```sql
CREATE TABLE invoice_rows (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  invoice_id      INTEGER REFERENCES invoices(id) ON DELETE CASCADE,
  row_order       INTEGER,
  trip_date       TEXT,
  gr_number       TEXT,
  vehicle_id      INTEGER REFERENCES vehicles(id),
  vehicle_no_text TEXT,  -- Stored flat for PDF
  freight_charge  REAL DEFAULT 0,
  fastag_charge   REAL DEFAULT 0,
  invoice_ref_no  TEXT,
  loading_place   TEXT,
  unloading_place TEXT,
  row_amount      REAL DEFAULT 0
);
```

#### `summary_bills`
```sql
CREATE TABLE summary_bills (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  summary_number  TEXT,
  company_id      INTEGER REFERENCES companies(id),
  period_from     TEXT,
  period_to       TEXT,
  total_amount    REAL,
  tds_amount      REAL,
  payable_amount  REAL,
  amount_in_words TEXT,
  status          TEXT DEFAULT 'DRAFT',
  created_at      TEXT
);

CREATE TABLE summary_bill_invoices (
  summary_id  INTEGER REFERENCES summary_bills(id),
  invoice_id  INTEGER REFERENCES invoices(id),
  PRIMARY KEY (summary_id, invoice_id)
);
```

#### `payments`
```sql
CREATE TABLE payments (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  invoice_id    INTEGER REFERENCES invoices(id),
  payment_date  TEXT,
  amount        REAL,
  payment_mode  TEXT,   -- NEFT|RTGS|CHEQUE|CASH
  reference_no  TEXT,
  tds_deducted  REAL DEFAULT 0,
  notes         TEXT,
  created_at    TEXT
);
```

#### `partner_distributions`
```sql
CREATE TABLE partner_distributions (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  period_from   TEXT,
  period_to     TEXT,
  partner_id    INTEGER REFERENCES partners(id),
  vehicle_id    INTEGER REFERENCES vehicles(id),
  trips         INTEGER,
  freight_amount REAL,
  tds_share     REAL,
  net_amount    REAL,
  paid_amount   REAL DEFAULT 0,
  paid_date     TEXT,
  created_at    TEXT
);
```

#### `reminders`
```sql
CREATE TABLE reminders (
  id              INTEGER PRIMARY KEY AUTOINCREMENT,
  type            TEXT,  -- PAYMENT|SUBMISSION|GST|TDS_CERT
  reference_id    INTEGER,
  reference_type  TEXT,
  due_date        TEXT,
  escalation_level INTEGER DEFAULT 0,
  is_resolved     INTEGER DEFAULT 0,
  last_notified   TEXT,
  notes           TEXT
);
```

#### `email_logs`
```sql
CREATE TABLE email_logs (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  invoice_id    INTEGER REFERENCES invoices(id),
  direction     TEXT,  -- SENT|RECEIVED
  subject       TEXT,
  body          TEXT,
  sent_at       TEXT,
  gmail_message_id TEXT,
  status        TEXT
);
```

#### `ai_chat_sessions`
```sql
CREATE TABLE ai_chat_sessions (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  context_type  TEXT,   -- INVOICE|COMPANY|GLOBAL
  context_id    INTEGER,
  model_used    TEXT,
  created_at    TEXT
);

CREATE TABLE ai_chat_messages (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  session_id    INTEGER REFERENCES ai_chat_sessions(id),
  role          TEXT,   -- user|assistant
  content       TEXT,
  created_at    TEXT
);
```

#### `audit_log`
```sql
CREATE TABLE audit_log (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  entity_type TEXT,
  entity_id   INTEGER,
  action      TEXT,   -- CREATE|UPDATE|DELETE|EXPORT|EMAIL
  old_value   TEXT,   -- JSON
  new_value   TEXT,   -- JSON
  user_note   TEXT,
  created_at  TEXT
);
```

#### `invoice_templates`
```sql
CREATE TABLE invoice_templates (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  name        TEXT,
  config_json TEXT,   -- Layout config as JSON
  is_default  INTEGER DEFAULT 0,
  created_at  TEXT
);
```

---

## 4. Business Logic Rules

### 4.1 GST Calculation Engine
```dart
class GSTCalculator {
  static const double stateRate = 2.5;     // Each: SGST + CGST
  static const double interStateRate = 5.0; // IGST
  
  static GSTResult calculate(double baseAmount, InvoiceType type) {
    if (type == InvoiceType.state) {
      final sgst = baseAmount * stateRate / 100;
      final cgst = baseAmount * stateRate / 100;
      return GSTResult(sgst: sgst, cgst: cgst, igst: 0, total: sgst + cgst);
    } else {
      final igst = baseAmount * interStateRate / 100;
      return GSTResult(sgst: 0, cgst: 0, igst: igst, total: igst);
    }
  }
}
```

### 4.2 Invoice Number Generation
```dart
class InvoiceNumberService {
  // Format: PREFIX/YY-YY/SEQ (e.g. JSV/25-26/100)
  String generate(String prefix, int seq, String fy) {
    final fyShort = _shortFY(fy); // "2025-26" → "25-26"
    return '$prefix/$fyShort/${seq.toString()}';
  }
  
  // Auto-detect current financial year
  String currentFY() {
    final now = DateTime.now();
    final year = now.month >= 4 ? now.year : now.year - 1;
    return '$year-${(year + 1).toString().substring(2)}';
  }
  
  // On April 1: reset seq to 1, update FY
  Future<void> checkAndRollFY();
}
```

### 4.3 Amount in Words (Indian System)
```dart
class IndianAmountWords {
  static String convert(double amount);
  // Supports: Lakhs, Crores, Rupees, Paise
  // Output: "Rupees Seven Lakh Twenty Six Thousand Three Hundred Seventy Six Only"
}
```

### 4.4 TDS Distribution
```dart
class TDSDistributor {
  Future<List<VehicleTDSShare>> distribute({
    required DateRange period,
    required int? companyId,
  }) async {
    // 1. Fetch all invoice_rows in period (optionally filtered by company)
    // 2. Group by vehicle_id
    // 3. Fetch total TDS deducted in period
    // 4. Vehicle TDS = (vehicle_trips / total_trips) * total_tds
    // 5. Return per-vehicle breakdown
  }
}
```

### 4.5 Payment Distribution
```dart
class PaymentDistributor {
  Future<List<PartnerShare>> distribute(List<int> invoiceIds) async {
    // 1. Get all invoice_rows from given invoices
    // 2. Group rows by vehicle_id
    // 3. Map vehicle_id → partner_id
    // 4. Sum freight per partner's vehicles
    // 5. Apply TDS proportionally
    // 6. Return net payable per partner
  }
}
```

---

## 5. AI Integration Architecture

### 5.1 OpenRouter API Client
```dart
class OpenRouterClient {
  static const String baseUrl = 'https://openrouter.ai/api/v1/chat/completions';
  
  final List<AIModel> modelPriority = [
    AIModel('openai/gpt-4o', rateLimit: 200),
    AIModel('mistralai/mistral-large', rateLimit: 100),
    AIModel('google/gemini-pro', rateLimit: 60),
    AIModel('meta-llama/llama-3.1-8b-instruct', rateLimit: 1000), // fast fallback
  ];
  
  Future<String> chat(List<Message> messages, {String? preferredModel}) async {
    for (final model in modelPriority) {
      try {
        final response = await _callModel(model.id, messages);
        return response;
      } on RateLimitException {
        continue; // Try next model
      } on QuotaExceededException {
        continue;
      }
    }
    throw AllModelsExhaustedException();
  }
}
```

### 5.2 Context Building
```dart
class AIContextBuilder {
  String buildInvoiceContext(Invoice invoice, Company company) {
    return '''
You are a billing assistant for a transportation firm.
CURRENT CONTEXT:
- Invoice Number: ${invoice.invoiceNumber}
- Invoice Date: ${invoice.invoiceDate}
- Company: ${company.name}
- Invoice Type: ${invoice.invoiceType.name}
- Total Amount: ₹${invoice.totalAmount}
- Status: ${invoice.status}
- GST Applied: ${invoice.gstDetails}
- Rows: ${invoice.rows.map((r) => r.toContextString()).join('\n')}

Firm: ${firmDetails}
Current Financial Year: ${currentFY}
''';
  }
  
  String buildGlobalContext() {
    // Includes: current month summary, pending payments, upcoming reminders
  }
}
```

### 5.3 AI Features Implementation
| Feature | Implementation |
|---------|---------------|
| Invoice Draft from Text | Structured JSON output from AI → parse to Invoice entity |
| Freight Rate Suggestion | Pass historical rates in context → AI suggests |
| Duplicate Detection | AI flag + local hash check on GR number + vehicle + date |
| Email Generation | Context-aware prompt → AI generates HTML email body |
| Query Answering | RAG-lite: relevant DB data included in prompt |

---

## 6. PDF Generation

### 6.1 PDF Engine
```dart
// Using 'pdf' dart package
class InvoicePDFGenerator {
  Future<Uint8List> generate(Invoice invoice, InvoiceTemplate template) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => _buildInvoicePage(context, invoice, template),
      ),
    );
    return pdf.save();
  }
  
  pw.Widget _buildInvoicePage(...) {
    // Firm header with logo
    // Bill To section + invoice details right
    // Data table (freight rows)
    // GST calculation footer
    // Amount in words
    // Bank details + signatory
    // RCM disclaimer
  }
}
```

### 6.2 Template System
- Templates stored as JSON config in DB
- Config defines: field positions, font sizes, colors, which fields shown
- Default template matches provided invoice images exactly
- Additional templates: Summary format, Compact format

---

## 7. Cloud Sync Architecture

### 7.1 Google Drive Sync
```dart
class GoogleDriveSync {
  static const String folderName = 'TransBook';
  
  Future<void> syncInvoice(Invoice invoice, Uint8List pdfBytes) async {
    // 1. Ensure folder: TransBook/FY-25-26/CompanyName/
    // 2. Upload PDF as: JSV-25-26-100.pdf
    // 3. Mark invoice.cloudSynced = true in local DB
    // 4. Store Drive file ID for future updates
  }
  
  Future<void> syncAll() async {
    // Background isolate sync for all unsynced docs
  }
}
```

### 7.2 Sync Queue
```sql
CREATE TABLE sync_queue (
  id            INTEGER PRIMARY KEY AUTOINCREMENT,
  entity_type   TEXT,
  entity_id     INTEGER,
  action        TEXT,   -- UPLOAD|UPDATE|DELETE
  attempts      INTEGER DEFAULT 0,
  last_attempt  TEXT,
  created_at    TEXT
);
```

- Background timer: check queue every 5 minutes when online
- Max retries: 5, then mark as failed and alert user
- Conflict: last-write-wins with timestamp comparison

---

## 8. Email Integration

### 8.1 Gmail API Flow
```dart
class GmailService {
  Future<void> sendInvoiceEmail({
    required String to,
    required String subject,
    required String htmlBody,
    required Uint8List pdfAttachment,
    required String attachmentName,
  }) async {
    // Build MIME message with HTML body + PDF attachment
    // Send via Gmail API POST /gmail/v1/users/me/messages/send
    // Log in email_logs table
    // Link to invoice record
  }
}
```

### 8.2 AI Email Generation Prompt
```
System: You are a professional billing assistant for a transportation company.
Generate a formal, professional email in HTML format for submitting an invoice.
Include: greeting, invoice summary table, payment request, firm contact info.
Keep tone: formal, polite, concise.

Context: {invoice_context}
Recipient: {company_contact}
```

---

## 9. Security

| Concern | Solution |
|---------|----------|
| Local DB Encryption | AES-256 via `encrypt` package, key in Windows Credential Manager |
| OAuth Tokens | Stored in Windows Credential Manager via FFI / `flutter_secure_storage` |
| OpenRouter API Key | Windows Credential Manager |
| PDF Files | Stored in `%AppData%\TransBook\PDFs\` with restricted permissions |
| Audit Trail | Every write operation logged to `audit_log` table |
| Backup Encryption | Backup ZIP encrypted with user-set password |

---

## 10. Installer — Inno Setup

### 10.1 Installer Specification
```inno
[Setup]
AppName=Trans Book
AppVersion=1.0.0
AppPublisher=JSV Technologies
DefaultDirName={autopf}\TransBook
DefaultGroupName=Trans Book
OutputBaseFilename=TransBook_Setup_v1.0.0
Compression=lzma2/ultra64
SetupIconFile=assets\app_icon.ico
LicenseFile=LICENSE.txt
MinVersion=10.0.19041   ; Windows 10 2004+
ArchitecturesAllowed=x64

[Files]
Source: "build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs

[Icons]
Name: "{group}\Trans Book"; Filename: "{app}\trans_book.exe"
Name: "{commondesktop}\Trans Book"; Filename: "{app}\trans_book.exe"

[Run]
Filename: "{app}\trans_book.exe"; Description: "Launch Trans Book"; Flags: postinstall

[Registry]
; Register app for file associations (.tbk backup files)
Root: HKCR; Subkey: ".tbk"; ValueType: string; ValueData: "TransBookBackup"
```

### 10.2 Update Mechanism
- Check GitHub Releases or custom update server on startup
- Background download of new installer
- Prompt user to install update at convenient time

---

## 11. Excel Generation

```dart
class ExcelGenerator {
  Future<Uint8List> generateInvoiceExcel(Invoice invoice) async {
    final excel = Excel.createExcel();
    final sheet = excel['Invoice'];
    
    // Build sheet matching invoice layout
    // Proper column widths, merged cells, bold headers
    // Currency format cells for amounts
    // Return as bytes
    
    return Uint8List.fromList(excel.save()!);
  }
  
  Future<Invoice?> extractFromPDF(Uint8List pdfBytes) async {
    // Use AI API to extract fields from PDF text
    // Parse response → Invoice entity
    // Return for user confirmation
  }
}
```

---

## 12. Performance Requirements

| Operation | Target Time |
|-----------|-------------|
| App cold start | < 5 seconds |
| Invoice save + PDF generate | < 2 seconds |
| DB query (1000 invoices) | < 200ms |
| AI response (chat) | < 8 seconds |
| Cloud sync (single doc) | < 5 seconds |
| Excel export (50 invoices) | < 3 seconds |
| Search (full text) | < 500ms |

---

## 13. Data Backup & Recovery

### Local Backup
- Daily auto-backup: `%AppData%\TransBook\Backups\backup_YYYY-MM-DD.tbk`
- Keep last 30 days of backups
- `.tbk` = AES-256 encrypted ZIP of SQLite DB + PDFs manifest

### Manual Backup
- User can export full backup to any path
- Backup includes: DB, PDF index, settings

### Restore
- Select `.tbk` file → decrypt → restore DB → re-sync cloud

---

## 14. Error Handling Strategy

```dart
// Global error types
sealed class AppFailure {
  const AppFailure(this.message, [this.stackTrace]);
  final String message;
  final StackTrace? stackTrace;
}

class DatabaseFailure extends AppFailure {...}
class NetworkFailure extends AppFailure {...}
class AIRateLimitFailure extends AppFailure {...}
class PDFGenerationFailure extends AppFailure {...}
class CloudSyncFailure extends AppFailure {...}
class ValidationFailure extends AppFailure {
  final Map<String, String> fieldErrors;
}
```

- All failures surfaced to user via dismissible snackbar (non-critical) or dialog (critical)
- All failures logged to structured log file: `%AppData%\TransBook\logs\app.log`
- AI failures: silent model fallback, user notified only if all models fail

---

## 15. Testing Strategy

| Type | Tools | Coverage Target |
|------|-------|-----------------|
| Unit Tests | `flutter_test` | Business logic, calculators, formatters: 90% |
| Widget Tests | `flutter_test` | Key screens: 70% |
| Integration Tests | `integration_test` | Core billing flows: 100% |
| PDF Snapshot Tests | Custom comparator | Invoice layout regression |

---

## 16. Flutter Package Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0
  
  # Database
  drift: ^2.18.0
  drift_flutter: ^0.2.0
  sqlite3_flutter_libs: ^0.5.0
  
  # PDF & Printing
  pdf: ^3.11.0
  printing: ^5.13.0
  
  # Excel
  excel: ^4.0.2
  
  # HTTP
  dio: ^5.4.0
  
  # Google/Microsoft OAuth
  google_sign_in: ^6.2.0
  
  # Secure Storage
  flutter_secure_storage: ^9.0.0
  
  # Encryption
  encrypt: ^5.0.3
  
  # File Picker
  file_picker: ^8.0.0
  
  # Local Notifications
  local_notifier: ^0.1.6
  
  # Navigation
  go_router: ^13.0.0
  
  # UI Components
  data_table_2: ^2.5.12
  intl: ^0.19.0
  
  # Logging
  logger: ^2.3.0
  
  # JSON
  json_annotation: ^4.9.0

dev_dependencies:
  build_runner: ^2.4.0
  drift_dev: ^2.18.0
  riverpod_generator: ^2.4.0
  json_serializable: ^6.8.0
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
```
