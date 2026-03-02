# AI Understanding Document
## Trans Book — AI Agent Layer Specification
**Version:** 1.0.0 | **Date:** March 2026  
*This document is written FOR AI coding agents (Antigravity/Vibe Coding) to deeply understand Trans Book before writing any code.*

---

## 0. Read This First

You are building **Trans Book**, a Windows desktop application (Flutter/Dart) for an Indian transportation firm. This document explains the domain, business rules, data relationships, and AI integration so you can write correct, contextually-aware code.

**Never build generic accounting software. Build specifically for Indian road freight transportation.**

---

## 1. Domain Understanding

### 1.1 What This Firm Does
The firm (e.g., Jai Shri Vaishno Truck Tempo Co.) owns or manages trucks/tempos. Companies like **Hero Motors Limited** hire them to transport goods from one place to another. For each trip:
- A truck goes from a **Loading Place** (e.g., GB Nagar factory) to an **Unloading Place** (e.g., HMCL 2nd plant)
- The firm charges a **Freight Amount** for this trip
- A **G.R. (Goods Receipt) Number** is generated per trip
- At month-end, all trips for a company are billed in a single **Tax Invoice**

### 1.2 The Two Invoice Types (Critical for GST)

| Type | When Used | GST Structure | Example |
|------|-----------|---------------|---------|
| **State Invoice** | Both Loading & Unloading in same state (e.g., both in Uttar Pradesh) | SGST 2.5% + CGST 2.5% = 5% total | GB Nagar → HMCL Gurgaon (both UP) |
| **Inter-State Invoice** | Loading and Unloading in different states | IGST 5% only (no split) | GB Nagar (UP) → Haridwar (Uttarakhand) |

**CRITICAL RULE**: The invoice type is determined by the company's consignor/consignee state relationship. It is **stored per company** when their record is created. The user is asked at that moment. This cannot be changed mid-invoice.

**CRITICAL RULE**: In this transportation domain, GST is paid under **Reverse Charge Mechanism (RCM)** — meaning the consignor/consignee pays GST, not the transporter. The invoice must show: GST amounts calculated, RCM disclaimer footer, "GST PAYABLE BY CONSIGNOR/CONSIGNEE UNDER REVERSE CHARGE MECHANISM (RCM)".

### 1.3 TDS (Tax Deducted at Source)
- Companies deduct **TDS @ 2%** from the payable amount before paying the firm
- This is statutory under Indian Income Tax Act Section 194C
- Example: Invoice ₹9,500 → Company pays ₹9,310 (₹190 TDS deducted)
- The firm must track TDS deducted to claim credit in their Income Tax return via Form 26AS

### 1.4 Invoice Number Format
- Format: `PREFIX/FY-SHORT/SEQUENCE`
- Example: `JSV/25-26/100` means: Firm prefix "JSV", FY 2025-26, 100th invoice
- **Sequence resets to 1 on April 1 every year** (Indian Financial Year start)
- **FY short format**: 2025-26 → "25-26"
- The invoice shown (JSV/25-26/100) is the 100th invoice of FY 2025-26

### 1.5 Financial Year Rules
- Indian FY: **April 1 to March 31**
- On April 1: auto-update FY short code, reset invoice sequence
- All date filters, TDS distribution, and summaries use Indian FY boundaries

---

## 2. Invoice Data Flow

```
User opens "New Invoice"
  ↓
Select Company → Auto-loads:
  - Default Loading Place
  - Invoice Type (STATE or INTER_STATE)
  - Company GSTIN, Address, PAN
  ↓
Add rows:
  Each row = one truck trip on one date
  Select Unloading Place → Auto-fills Freight Amount from Rate Card
  Enter: GR Number, Vehicle No, optional Fastag
  ↓
System Auto-Calculates:
  Row Amount = Freight + Fastag
  Total = Σ Row Amounts
  If STATE: SGST = Total × 2.5%, CGST = Total × 2.5%
  If INTER_STATE: IGST = Total × 5%
  GST on RCM = SGST + CGST (or IGST)
  TDS = Total × 2%
  Amount in Words = IndianWords(Total)
  ↓
Save → Generate PDF → Optional Email
```

---

## 3. Summary Bill Flow

```
End of billing period:
  ↓
User selects company + selects multiple invoices
  ↓
Summary sheet shows each invoice as one row:
  Date | Pickup (Loading) | Drop (Unloading) | Invoice No. | TDS 2% | Invoice Amount
  ↓
Footer:
  Total Amount = Σ Invoice Amounts
  TDS 2% = Σ TDS per invoice
  Payable Amount = Total - TDS
  Amount in Words (on payable amount)
  ↓
This summary is physically couriered to the company for payment processing
```

---

## 4. Understanding the Provided Invoice Images

### Image 1 — Tax Invoice Analysis
```
Firm: Jai Shri Vaishno Truck Tempo Co. (JSV)
  PAN: AAJFJ6952H | GSTIN: 09AAJFJ6952H1ZX | State: UP (09)

Bill To: Hero Motors Limited
  PAN: AAACH8459F | GSTIN: 09AAACH8459F2ZB | State: UP

Invoice Type: STATE (both parties in UP/State 09)
Invoice Date: 28-Feb-26 | Invoice No: JSV/25-26/100

Table Row:
  Date: 26 Feb 2026 | GR: 1639 | Vehicle: 7555
  Freight: 9500 | Loading: GB Nagar | Unloading: HMCL 2nd | Amount: 9500

Total: ₹9,500
SGST @ 2.5%: ₹237.50
CGST @ 2.5%: ₹237.50
GST on Reverse Charge: ₹475.00 (= SGST + CGST)

Note: The ₹475 GST is SHOWN but NOT added to payable — it is RCM, paid by Hero Motors directly.
```

### Image 2 — Summary Bill Analysis
```
Summary of 5 invoices for Hero Motors (all dated 28-Feb-2026)

JSV/25-26/96  | Hero GZB → Aman     | TDS: 420    | Amount: 21,000
JSV/25-26/97  | Hero GZB → Haridwar | TDS: 10,350 | Amount: 5,17,500
JSV/25-26/99  | Hero GZB → Manesar  | TDS: 368    | Amount: 18,400
JSV/25-26/98  | Hero GZB → Autofit  | TDS: 3,496  | Amount: 1,74,800
JSV/25-26/100 | Hero GZB → Gurgaon  | TDS: 190    | Amount: 9,500

Total: ₹7,41,200 | TDS 2%: ₹14,824 | Payable: ₹7,26,376

Note: Invoice nos are NOT sequential in summary (96,97,99,98,100) — user manually selected them.
Note: "Hero GZB" = Hero Ghaziabad plant (loading place abbreviation).
Note: TDS per invoice = Amount × 2% (verify: 9500 × 2% = 190 ✓, 21000 × 2% = 420 ✓)
Note: Amount in words covers Payable (₹7,26,376): "Seven Lakh Twenty Six Thousand Three Hundred Seventy Six Only"
```

---

## 5. Key Business Rules — Never Get These Wrong

```
RULE 1: GST Rate for Transport = 5% total (2.5%+2.5% or 5% IGST)
         HSN/SAC Code = 996791 (Road transport, freight)

RULE 2: RCM applies — transporter does NOT collect GST from client.
         Show GST amounts on invoice but mark as "GST on Reverse Charge".
         The client (Hero Motors) pays this directly to government.

RULE 3: TDS @ 2% is deducted by the CLIENT company, not the firm.
         Payable Amount = Invoice Amount - TDS
         This is shown only in SUMMARY, not on individual tax invoice.

RULE 4: State Invoice when BOTH consignor & consignee are in same state.
         The state is determined by GSTIN prefix (e.g. 09 = Uttar Pradesh).

RULE 5: Invoice sequence resets every April 1.
         FY format: 2025-26 written as "25-26" in invoice number.

RULE 6: Loading Place is the firm's client's factory/warehouse (where goods come from).
         Unloading Place is the delivery destination.
         These are specific named locations, not full addresses.
         Different unloading places have different freight rates (per company).

RULE 7: "Amount in Words" must use Indian number system:
         ₹7,26,376 = "Seven Lakh Twenty Six Thousand Three Hundred Seventy Six Only"
         NOT "Seven Hundred Twenty Six Thousand..." (that's Western system)

RULE 8: A single invoice can have MULTIPLE rows (multiple trips/vehicles).
         Each row = one trip (one vehicle, one GR, one date, one route).

RULE 9: HSN/SAC Code 996791 is for road freight transport services.
         This must appear in the "Detail of Party" section of every invoice.

RULE 10: The firm's bank details appear at bottom of EVERY invoice and summary.
          This is required for the company to make payment.
```

---

## 6. AI Chatbot — How It Must Behave

### 6.1 Context Injection Protocol
The AI chatbot receives different context based on what screen the user has open:

```
[GLOBAL CONTEXT - Always Included]
Firm: {firm_name}, GSTIN: {firm_gstin}, State: {firm_state}
Current FY: {fy}
Current Date: {date}
This Month Bills: Count={n}, Total=₹{x}
Pending Payments: ₹{y} from {z} companies

[INVOICE CONTEXT - When invoice is open]
Invoice: {number}, Date: {date}
Company: {name}, Invoice Type: {STATE|INTER_STATE}
Status: {status}
Total: ₹{amount}, GST: ₹{gst}, Rows: {count}
Rows Summary: [{date, vehicle, route, amount}, ...]

[COMPANY CONTEXT - When company profile is open]
Company: {name}, GSTIN: {gstin}
Total Billed This FY: ₹{x}
Pending Amount: ₹{y}
Last Invoice: {number} on {date}
TDS Deducted This FY: ₹{z}

[PAYMENT CONTEXT - When payment screen is open]
{period} Distribution
Partners: [{name, vehicles, trips, amount}]
Total Distributable: ₹{x}
```

### 6.2 Sample AI Queries & Expected Behavior

```
User: "How much is pending from Hero Motors?"
AI Action: Query invoices table WHERE company=Hero Motors AND status IN ('SUBMITTED','PARTIAL','ACKNOWLEDGED')
AI Response: "Hero Motors has ₹3,22,000 pending across 4 invoices: JSV/25-26/97 (₹2,07,000), ..."

User: "Generate an email to send this invoice"
AI Action: Use current invoice context + company email
AI Output: Professional HTML email with embedded invoice summary table

User: "What's the freight rate for HMCL 2nd?"
AI Action: Query freight_rate_cards for current company + unloading place
AI Response: "For Hero Motors, HMCL 2nd rate is ₹9,500 per trip (set on {date})"

User: "Distribute payment for February"
AI Action: Trigger PaymentDistributor for February range → show result as table

User: "This invoice seems wrong, the total should be higher"
AI Action: Re-calculate from rows → compare → identify discrepancy → explain

User: "GST filing is due, what do I need?"
AI Action: Query this month's invoices → summarize SGST, CGST, IGST totals → format for accountant
```

### 6.3 What AI Should NOT Do
- Never auto-save or auto-submit invoices without explicit user confirmation
- Never share or expose API keys, OAuth tokens
- Never make assumptions about freight rates — always query rate card
- Never generate invoice numbers — always use InvoiceNumberService
- Never modify historical/submitted invoices (read-only for AI)

### 6.4 Model Fallback Chain
```
Request comes in
  ↓
Try: gpt-4o (via OpenRouter)
  → Success → Return response
  → Rate limited → Try next
Try: mistral-large
  → Success → Return response
  → Rate limited → Try next
Try: gemini-pro
  → Success → Return response
  → Rate limited → Try next
Try: llama-3.1-8b-instruct (always available, lower quality)
  → Success → Return response
  → Failed → Show error: "AI temporarily unavailable"
```

Log model used per response for debugging and cost tracking.

---

## 7. PDF Generation Rules

### 7.1 Invoice PDF Must Match Exact Layout (from Image 1)
```
SECTION 1: Firm Header (Left) + Logo (Right)
  - Firm name: Large bold
  - Address, Phone, Email, PAN, GSTIN, State
  - Logo: Top right corner
  - Invoice Type tag: Top right ("State Invoice" or "Inter-State Invoice")
  - Blue separator line: Full width

SECTION 2: "TAX INVOICE" centered title

SECTION 3: Bill To (Left) + Invoice Details (Right)
  Bill To:
    Company name (bold, large)
    Full address
    PAN, GSTIN, State
  Right Column:
    Invoice Date | Invoice No.
    State Code | Detail of Party header
    Place of Supply | State Code | HSN/SAC Code

SECTION 4: Data Table
  Header row: Blue background, white text, centered
  Columns: S.NO | DATE | G.R. NO. | VEHICLE NO. | FRIGHT CHARGE | FASTAG CHARGE | INVOICE .NO | LOADING PLACE | UNLOADING PLACE | AMOUNT
  Data rows: Alternating white/light gray
  Total row: Bold, spanning, right-aligned amounts

SECTION 5: Amounts Footer (Right-aligned block)
  Total Amount: ₹ {x}
  SGST @ 2.50%: ₹ {y}   [Only if STATE invoice]
  CGST @ 2.50%: ₹ {z}   [Only if STATE invoice]
  IGST @ 5.00%: ₹ {w}   [Only if INTER_STATE invoice]
  GST on Reverse Charge: ₹ {total_gst}
  
  Amount in Words (Left-aligned):
    "Rupees [words] Only"

SECTION 6: Bank Details (Left) + Authorized Signatory (Right)
  Bank Details box with all firm bank info
  Signature space with "Authorized Signatory" text

SECTION 7: Full-width footer
  "GST PAYABLE BY CONSIGNOR/CONSIGNEE UNDER REVERSE CHARGE MECHANISM (RCM)"
```

### 7.2 Summary PDF Layout (from Image 2)
```
SECTION 1: Same firm header as invoice

SECTION 2: "Summary" centered title (colored, larger font)

SECTION 3: Data Table
  Columns: Sr. No | Date | PickUP | Drop | Invoice No. | Tds (2%) | Invoice Amount
  Same styling as invoice table

SECTION 4: Totals
  Row: Total | | | | | {total_tds} | {total_amount}
  Below table:
    Total Amount: ₹ {x}
    Tds 2%: ₹ {y}
    Payable amount: ₹ {z}
  Amount in Words (covers Billing Amount, not payable):
    "Billing Amount Rupees - [words] Only"

SECTION 5: Bank Details + Authorized Signatory (same as invoice)

SECTION 6: RCM disclaimer footer (same as invoice)
```

---

## 8. Data Validation Rules

```dart
// Invoice Validation
- Company must be selected (cannot save without company)
- Invoice date is required (cannot be future date more than 7 days)
- At least 1 invoice row required
- Each row: date, vehicle, freight amount > 0, unloading place required
- GR number: must be unique per company per financial year (warn if duplicate)
- If invoice type = STATE: both parties must be in same state (validate by GSTIN prefix)
- Invoice number cannot be manually changed after first save

// Company Validation
- GSTIN format: 2-digit state code + 10-char PAN + 1 char + 1 char + 1 char = 15 chars total
- PAN format: 5 letters + 4 digits + 1 letter = 10 chars
- State code must match GSTIN prefix

// Amount Validation
- All amounts: max 2 decimal places
- Freight amount: must be positive, max ₹10,00,000 per row (flag if exceeded)
- Fastag: optional, must be non-negative

// Invoice Number Validation
- Format regex: /^[A-Z]+\/\d{2}-\d{2}\/\d+$/
- Sequence must be strictly incremental (warn if gap detected)
```

---

## 9. Riverpod State Architecture

```dart
// Key Providers
final firmProvider = AsyncNotifierProvider<FirmNotifier, Firm>(...);
final companiesProvider = AsyncNotifierProvider<CompaniesNotifier, List<Company>>(...);
final currentInvoiceProvider = StateNotifierProvider<InvoiceNotifier, InvoiceState>(...);
final billsProvider = AsyncNotifierProvider.family<BillsNotifier, List<Invoice>, BillsFilter>(...);
final aiChatProvider = StateNotifierProvider.family<AIChatNotifier, AIChatState, AIChatContext>(...);
final cloudSyncProvider = AsyncNotifierProvider<CloudSyncNotifier, SyncStatus>(...);

// Derived Providers
final currentMonthSummaryProvider = Provider<MonthSummary>((ref) {
  final bills = ref.watch(billsProvider(BillsFilter.currentMonth));
  return MonthSummary.fromBills(bills);
});

final pendingPaymentsProvider = Provider<List<Invoice>>((ref) {
  final bills = ref.watch(billsProvider(BillsFilter.all));
  return bills.where((b) => b.status.isPending).toList();
});
```

---

## 10. Folder / File Structure (Windows AppData)

```
%AppData%\TransBook\
├── transbook.db                    # Encrypted SQLite database
├── settings.json                   # Non-sensitive app settings
├── PDFs\
│   ├── Invoices\
│   │   ├── JSV-25-26-100.pdf
│   │   └── ...
│   ├── Summaries\
│   └── Labels\
├── Excel\
│   └── exports\
├── Backups\
│   ├── backup_2026-02-28.tbk
│   └── ...
├── Logs\
│   ├── app_2026-02.log
│   └── ...
└── Templates\
    ├── default_invoice.json
    └── custom_1.json
```

---

## 11. Coding Conventions for AI Agents

### 11.1 Naming Conventions
- Dart files: `snake_case.dart`
- Classes: `PascalCase`
- Riverpod providers: `camelCaseProvider`
- DB tables: `snake_case` (Drift table classes: `PascalCase`)
- Constants: `kConstantName` prefix
- INR amounts: always use `double`, format with `IndianCurrencyFormatter`

### 11.2 Formatters to Always Use
```dart
// Always format amounts as Indian currency
final formatted = IndianCurrencyFormatter.format(9500.0); // "₹9,500.00"

// Always use Indian number system (not Western commas)
// 741200 → "7,41,200" (Indian) NOT "741,200" (Western)

// Dates in India format for display
final display = DateFormat('dd-MMM-yy').format(date); // "26-Feb-26"
final display2 = DateFormat('dd MMMM yyyy').format(date); // "26 February 2026"
```

### 11.3 File Naming for PDFs
```dart
// Invoice PDF: JSV-25-26-100.pdf (forward slashes replaced with dashes)
String invoicePDFName(String invoiceNo) => invoiceNo.replaceAll('/', '-') + '.pdf';

// Summary PDF: Summary-HeroMotors-Feb2026.pdf
String summaryPDFName(String company, DateTime date) =>
    'Summary-${company.replaceAll(' ', '')}-${DateFormat('MMMyyy').format(date)}.pdf';
```

### 11.4 Always Implement
- Every DB write → audit_log entry
- Every invoice status change → reminder system check
- Every new company saved → prompt for invoice type if not set
- Every invoice number generated → verify no collision in DB
- Every AI call → log model used + token count

---

## 12. Screen Navigation Flow

```
Splash/Loading
  ↓ (first launch)
Onboarding Setup (5 steps)
  ↓
Dashboard
  ├── [Ctrl+N] → New Invoice Screen
  │     ├── Select Company → Auto-fill
  │     ├── Add Rows → Auto-calculate
  │     ├── Save → PDF Generated → Optional Email
  │     └── Preview → PDF viewer
  │
  ├── Billing Management → Bills Grid
  │     ├── Filter/Search
  │     ├── Click invoice → Invoice Detail (read-only if submitted)
  │     └── Generate Summary → Summary Builder → Summary PDF
  │
  ├── Payments → TDS Distribution
  │     └── Payment Distribution → Partner Reports
  │
  ├── Record Book → Archive Search → Export
  │
  ├── Master Data
  │     ├── Companies → Add/Edit → Rate Card
  │     ├── Vehicles → Add/Edit → Assign Partner
  │     └── Partners → Add/Edit → View Share
  │
  ├── Ledger → Company Ledger → Export
  │
  └── Settings
        ├── Firm Profile
        ├── Invoice Settings (prefix, seq, FY)
        ├── Cloud Sync (Google Drive / OneDrive)
        ├── Email (Gmail OAuth)
        ├── AI Settings (API Key, Model Priority)
        └── Backup & Restore
```

---

## 13. Priority Build Order for Vibe Coding

Build in this exact sequence for a functional, testable system:

```
SPRINT 1 (Week 1-2): Core Foundation
  1. Drift DB schema + migrations
  2. Firm setup + onboarding screen
  3. Company master (CRUD + invoice type prompt)
  4. Vehicle master
  5. Freight rate card

SPRINT 2 (Week 3-4): Invoicing Heart
  6. New Invoice screen (full with auto-fill)
  7. GST calculator + Indian amount words
  8. Invoice number generator (with FY logic)
  9. PDF generation (match Image 1 exactly)
  10. Invoice save, status tracking

SPRINT 3 (Week 5-6): Billing Management
  11. Bills dashboard + grid
  12. Summary bill builder + PDF (match Image 2)
  13. Bill status workflow
  14. Basic search and filter

SPRINT 4 (Week 7-8): Payments & Distribution
  15. TDS distribution engine
  16. Partner payment distributor
  17. Payment ledger
  18. Export (Excel + PDF)

SPRINT 5 (Week 9-10): Cloud + Email + AI
  19. Google Drive OAuth + sync
  20. Gmail integration + AI email drafting
  21. AI sidebar + OpenRouter multi-model
  22. Context injection system

SPRINT 6 (Week 11-12): Polish & Extras
  23. Reminder system
  24. Company-specific ledger
  25. Record book archive
  26. PDF↔Excel conversion
  27. Address labels
  28. Inno Setup installer build
```
