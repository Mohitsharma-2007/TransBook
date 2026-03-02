# Product Requirements Document (PRD)
## Trans Book — AI-Powered Transportation Billing & Management System
**Version:** 1.0.0 | **Date:** March 2026 | **Platform:** Windows Desktop (Flutter) | **Installer:** Inno Setup

---

## 1. Product Overview

### 1.1 Purpose
Trans Book is a Windows desktop application built for transportation firms to automate and manage the full lifecycle of GST-compliant tax invoicing, payment distribution, TDS management, partner settlements, and document archiving — enhanced by an AI agentic layer.

### 1.2 Target User
- Transportation firm owners/partners
- Billing clerks and accountants
- Indian GST regime — Reverse Charge Mechanism (RCM) applicable
- Indian Financial Year: April–March

### 1.3 Business Context
- Bills raised against companies (e.g., Hero Motors Limited)
- Vehicles assigned per trip per company
- **State Invoice**: SGST @ 2.5% + CGST @ 2.5%
- **Inter-State Invoice**: IGST @ 5%
- TDS @ 2% deducted by consignee companies
- Payment distributed to truck partners by vehicle count and trips

---

## 2. Goals & Success Metrics

| Goal | Metric |
|------|--------|
| Reduce billing time | Invoice creation < 3 minutes |
| Eliminate GST errors | 100% auto-calculated tax fields |
| Automate TDS distribution | Zero manual calculation errors |
| Partner payment clarity | One-click distribution report |
| AI context awareness | Chatbot responds in < 5 seconds |

---

## 3. Core Features & Requirements

---

### FEATURE 1 — Smart GST-Based Tax Invoicing System

#### Invoice Types
- **State Invoice** → SGST @ 2.5% + CGST @ 2.5%
- **Inter-State Invoice** → IGST @ 5% only
- Invoice type saved **per consignee/consignor** profile at time of saving
- Tax section on invoice auto-switches based on invoice type

#### Invoice Number System
- Custom prefix format: `JSV/YY-YY/NNN` (e.g., `JSV/25-26/100`)
- Financial year auto-detected and prefix auto-updates on April 1
- Memory system: auto-increments from last used number
- User can override prefix and starting number

#### Invoice Table Fields (Per Row)
| Field | Behaviour |
|-------|-----------|
| S.No | Auto-incremented |
| Date | Date picker, default today |
| G.R. No. | Manual number entry |
| Vehicle No. | Dropdown from vehicle master |
| Freight Charge | **Auto-filled** from Unloading Place rate card |
| Fastag Charge | Optional, manual |
| Invoice No. | Reference text |
| Loading Place | **Pre-filled** from company/consignor default |
| Unloading Place | Dropdown → triggers freight auto-fill |
| Amount | Auto = Freight + Fastag |

#### Fast Data Entry
- Tab-through row navigation
- `Ctrl+Enter` adds new row
- Duplicate row button for same-route repeat trips
- Loading Place and Freight Rate pre-loaded from company profile

#### Invoice Footer Calculations
- Total Amount (sum all rows)
- SGST + CGST or IGST auto-applied per invoice type
- GST on Reverse Charge (displayed separately)
- Amount in Words (Indian number system — Lakhs, Crores)
- RCM disclaimer footer line auto-added

#### Multi-Format Layout System
- Multiple saved invoice templates
- Template editor: drag-and-drop field placement
- Logo, color theme, font selection
- Custom field add/remove with node-hooked functionality

#### Invoice Output
- Print-ready PDF generation with preview
- Save as PDF and/or Excel
- Email directly from invoice screen

---

### FEATURE 2 — Billing Management

#### Bill Dashboard
- Current month bills grid (Invoice No., Company, Date, Amount, Status)
- Filters: company, date range, status (Draft / Submitted / Paid / Partial)
- Search by invoice no., company name, vehicle no.

#### Consignor / Consignee Master
- Fields: Name, Address, PAN, GSTIN, State Code, **Invoice Type preference**, Loading Place default, Rate Card
- When saving a new consignee/consignor: **system prompts to select Invoice Type** (State or Inter-State)
- Edit / Delete / Archive capability

#### Summary Bill Generation (Image 2 Reference)
- Select multiple invoices → auto-generate summary sheet
- Columns: Sr. No, Date, Pickup, Drop, Invoice No., TDS 2%, Invoice Amount
- Footer: Total Amount, TDS 2%, Payable Amount
- Amount in Words auto-generated
- User selects which companies appear in summary

#### Bill Status Tracking
- Draft → Submitted → Acknowledged → Paid → Partially Paid
- Date of submission recorded
- Payment received date and amount tracked per invoice

---

### FEATURE 3 — TDS Distribution

#### TDS Ledger
- TDS deducted per invoice @ 2%
- Filter by: FY, date range, company, vehicle
- Running total: TDS deducted vs. Form 16A received

#### TDS Distribution Engine
- Input: Date range or full Financial Year
- Per-vehicle TDS formula:
  ```
  Vehicle TDS = (Vehicle Trips / Total Trips) × Total TDS Deducted
  ```
- Output: Per-vehicle TDS statement
- Export: Excel + PDF

---

### FEATURE 4 — Payment Distribution (Partner Management)

#### Partner Master
- Partner Name, Contact, PAN, Bank Details
- Vehicles assigned to each partner

#### Distribution Engine
- Input: Invoice(s) or date range
- Formula:
  ```
  Partner Share = Σ (Partner's Vehicle Trips × Rate per Trip)
  ```
- Handles partial ownership
- Output: Partner-wise payment statement with trip breakdown

#### Payment Ledger
- Track paid vs. pending per partner
- Payment history with dates and amounts
- Generate payment voucher PDF

---

### FEATURE 5 — Record Book

#### Document Archive
- All bills stored locally (SQLite/Drift)
- Cloud-synced to Google Drive / OneDrive
- Searchable: invoice no., date, company, vehicle, amount

#### Export Formats
- Individual bill: PDF, Excel
- Batch export: merged PDF, Excel workbook
- Bulk export with date/company filter

#### Version History
- Track edits to saved bills
- Restore previous version

---

### FEATURE 6 — PDF ↔ Excel Conversion

#### PDF to Excel
- Upload invoice PDF → AI field extraction
- Extract: invoice no., amounts, dates, party names
- Map to Trans Book schema → export clean Excel

#### Excel to PDF
- Upload Excel invoice/summary
- Apply Trans Book template + firm letterhead
- Output professional PDF

---

### FEATURE 7 — Address Book & Envelope Labels

#### Label Generation
- Standard sizes: A4 sheet with 2/4/6 labels per sheet
- Auto-pulls consignee address from master
- Firm return address auto-filled
- Print-ready PDF output

#### Label Templates
- Courier label, speed post, normal post formats
- Optional QR code linking to invoice record

---

### FEATURE 8 — Company / Consignee / Consignor Master

#### Company Master Fields
- Name, Address, State, PAN, GSTIN, State Code, HSN/SAC Code
- Bank details (for payment reference)
- **Default Invoice Type** (State / Inter-State) — prompted on first save
- **Default Loading Place**
- **Rate Card**: Unloading Place → Freight Amount mapping table
- Contact persons, email IDs

---

### FEATURE 9 — Cloud Document Sync

#### Google Drive Integration
- OAuth2 authentication
- Auto-sync bills on save/export
- Folder structure: `TransBook/FY-25-26/CompanyName/InvoiceNo.pdf`

#### MS OneDrive Integration
- Microsoft OAuth2 login
- Same folder structure

#### Sync Settings
- Choose sync scope (bills only / all data)
- Offline queue — sync on reconnect
- Conflict resolution: latest write wins

---

### FEATURE 10 — AI Integration & Smart Documenting

#### Sidebar AI Chatbot
- Collapsible sidebar visible from any screen
- **Context-aware**: knows which bill/screen is active
- Access: current invoice, company master, past bills, payment records

#### OpenRouter API — Multi-Model Layer
- Primary model → Fallback 1 → Fallback 2 (e.g., GPT-4o → Mistral → Gemini)
- Automatic switching on rate limit or quota exceeded
- User configures model priority in settings

#### AI Capabilities
- Draft invoice from text or voice description
- Suggest freight rates from history
- Flag duplicate invoices
- Summarize payment status per company
- Auto-generate email body for bill submission
- Answer TDS / payment queries
- Detect billing pattern anomalies

#### AI Memory / Context System
- Session context per open document
- Long-term memory: company-specific billing history, rate trends

---

### FEATURE 11 — Smart Email Integration

#### Gmail OAuth2
- Link firm Gmail account
- Send invoices/summaries directly from Trans Book

#### AI-Drafted Emails
- AI generates professional email body based on bill context, company history
- User reviews and edits before sending

#### Professional HTML Email Template
- Firm logo header
- Embedded invoice summary table
- Attached PDF bill
- Digital signature block

#### Email Inbox Link
- Receive/view replies linked to invoice threads
- AI summarizes incoming emails

---

### FEATURE 12 — Reminder System

| Type | Detail |
|------|--------|
| Payment Reminder | X days before/after expected payment date |
| Bill Submission | Remind to submit by target date |
| GST Filing | Monthly GSTR-1 / GSTR-3B deadline |
| TDS Certificate | Quarterly Form 16A collection reminder |

- Escalation levels: Gentle → Firm → Urgent
- Channels: in-app notification + optional email

---

### FEATURE 13 — Company-Specific Ledger

#### Ledger View (Per Company)
- Timeline: Bills Raised → Submitted → TDS Deducted → Amount Received
- Running balance: Total Billed vs. Total Received vs. Pending

#### Ledger Export
- PDF + Excel with date range filter
- Professional format with firm letterhead

---

### FEATURE 14 — WhatsApp Integration (Future Phase)
- Send bill PDFs via WhatsApp Business API
- Payment reminders via WhatsApp
- Delivery status tracking

---

## 4. User Roles & Permissions

| Role | Access |
|------|--------|
| Owner/Admin | Full access, partner management, cloud config, AI settings |
| Billing Clerk | Create/edit invoices, view records |
| Accountant | TDS, payment distribution, ledger |
| Read Only | View and export only |

---

## 5. Non-Functional Requirements

| Requirement | Specification |
|-------------|---------------|
| OS Support | Windows 10 / 11 (64-bit) |
| Offline First | Full core functionality without internet |
| Data Security | AES-256 local DB encryption |
| Startup Time | < 5 seconds on mid-range hardware |
| PDF Engine | Native (no third-party install dependency) |
| Backup | Auto daily local + cloud backup |
| Installer | Inno Setup — single EXE installer |
| Language | English (Hindi optional in future) |

---

## 6. Release Phases

| Phase | Features | Target |
|-------|----------|--------|
| MVP (Phase 1) | Invoicing, Company Master, PDF Export, Summary | Month 1–2 |
| Phase 2 | TDS, Payment Distribution, Record Book, Cloud Sync | Month 3–4 |
| Phase 3 | AI Integration, Email, Reminders, Ledger | Month 5–6 |
| Phase 4 | PDF↔Excel, Label Printing, Address Book | Month 7–8 |
| Phase 5 | WhatsApp, Advanced AI, Form 26AS Reconciliation | Future |

---

## 7. Suggested Additional Features

### 7.1 Vehicle Master & Trip Log *(HIGH PRIORITY)*
- Maintain vehicle database: vehicle no., owner partner, fitness cert expiry, insurance expiry
- Daily trip entry log per vehicle
- Required for accurate TDS distribution and partner payment

### 7.2 Freight Rate Card Master *(HIGH PRIORITY)*
- Per company + per route (Loading → Unloading) freight rate table
- Auto-populates invoice row on Unloading Place selection
- Massive time saver, prevents pricing errors

### 7.3 GST Return Helper *(HIGH PRIORITY)*
- Monthly summary: SGST, CGST, IGST collected under RCM
- Ready-made data for accountant to file GSTR-1 / GSTR-3B

### 7.4 Digital Signature & Stamp Overlay *(MEDIUM PRIORITY)*
- Scanned signature + rubber stamp image overlay on PDF output
- Required for physical bill couriers

### 7.5 Bill Courier Tracker *(MEDIUM PRIORITY)*
- Log courier AWB number against each bill submission
- Track delivery status
- Proof of submission for dispute resolution

### 7.6 Shortage / Damage Claims Tracking *(MEDIUM PRIORITY)*
- Record deductions made by companies (shortage, damage, breakage)
- Dispute tracking with status resolution

### 7.7 Audit Trail / Activity Log *(HIGH PRIORITY)*
- Every change logged with user + timestamp
- Accountability and dispute resolution

### 7.8 Offline AI with Local LLM *(LOW PRIORITY)*
- Small local model (e.g., Phi-3 Mini) for basic queries when offline

### 7.9 Profitability Dashboard *(LOW PRIORITY)*
- Revenue per route, per vehicle, per partner
- Compare freight collected vs. fuel + operational costs

### 7.10 SMS Notifications *(MEDIUM PRIORITY)*
- Send payment reminders and invoice notifications via SMS gateway
