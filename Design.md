# Design Document
## Trans Book — UI/UX & Visual Design Specification
**Version:** 1.0.0 | **Platform:** Flutter (Windows Desktop)

---

## 1. Design Philosophy

Trans Book follows a **"Professional Clarity"** design philosophy — clean, data-dense, fast to navigate. It is a power-user tool, not a consumer app. The interface must:
- Minimize clicks for repetitive billing tasks
- Surface the most important data prominently
- Feel like a premium Indian enterprise desktop application
- Avoid clutter while supporting complex data entry workflows

**Primary Design Principles:**
1. **Speed First** — keyboard-driven workflows, no unnecessary dialogs
2. **Data Density** — tables, grids, and numbers are the heroes
3. **Contextual Intelligence** — AI sidebar always available, never intrusive
4. **Trust & Formality** — professional color palette, clear typography

---

## 2. Color System

### Primary Palette
| Token | Hex | Usage |
|-------|-----|-------|
| `brand-primary` | `#1A3C8F` | App bar, primary buttons, active nav |
| `brand-secondary` | `#F7A800` | Accent, highlights, badges, invoice type tag |
| `brand-dark` | `#0D2255` | Sidebar background, dark headers |
| `surface-white` | `#FFFFFF` | Main content area, cards |
| `surface-light` | `#F4F6FB` | Page backgrounds, alternating table rows |
| `surface-card` | `#FFFFFF` | Invoice cards, form panels |

### Status Colors
| Token | Hex | Usage |
|-------|-----|-------|
| `status-draft` | `#9E9E9E` | Draft invoice badge |
| `status-submitted` | `#2196F3` | Submitted to company |
| `status-acknowledged` | `#FF9800` | Acknowledged by company |
| `status-paid` | `#4CAF50` | Fully paid |
| `status-partial` | `#FF5722` | Partially paid |
| `status-overdue` | `#F44336` | Past due date |

### Text Colors
| Token | Hex | Usage |
|-------|-----|-------|
| `text-primary` | `#1A1A2E` | Main content text |
| `text-secondary` | `#5A6A7A` | Labels, subtitles |
| `text-muted` | `#9EAAB8` | Placeholder, hints |
| `text-on-dark` | `#FFFFFF` | Text on dark backgrounds |
| `text-amount` | `#1A3C8F` | Currency amounts |

---

## 3. Typography

| Role | Font | Size | Weight |
|------|------|------|--------|
| App Title | Inter | 20px | Bold |
| Section Heading | Inter | 16px | SemiBold |
| Card Title | Inter | 14px | SemiBold |
| Body Text | Inter | 13px | Regular |
| Table Header | Inter | 12px | SemiBold |
| Table Cell | Inter | 12px | Regular |
| Amount Display | Roboto Mono | 14px | Medium |
| Invoice Amount | Roboto Mono | 18px | Bold |
| Caption/Label | Inter | 11px | Regular |
| Amount in Words | Georgia (serif) | 12px | Italic |

---

## 4. Layout & Navigation Structure

### 4.1 Application Shell
```
┌──────────────────────────────────────────────────────────────────┐
│  [Logo] Trans Book              [Search] [Notifications] [User]  │  ← Top Bar (48px)
├──────────┬───────────────────────────────────────┬───────────────┤
│          │                                       │               │
│  LEFT    │         MAIN CONTENT AREA             │   AI SIDEBAR  │
│  NAV     │         (Dynamic per module)          │  (Collapsible)│
│  (200px) │                                       │   (320px)     │
│          │                                       │               │
└──────────┴───────────────────────────────────────┴───────────────┘
│  Status Bar: Connection Status | Sync Status | Current FY        │  ← Bottom Bar (28px)
└──────────────────────────────────────────────────────────────────┘
```

### 4.2 Left Navigation Panel (200px, collapsible to 60px)
```
┌──────────────────────┐
│  📄 Dashboard        │  ← Home overview
│  🧾 Invoicing        │
│    ├ New Invoice      │
│    └ All Invoices    │
│  📋 Billing Mgmt     │
│    ├ Bills           │
│    └ Summary Bills   │
│  💰 Payments         │
│    ├ TDS             │
│    └ Distribution    │
│  📁 Record Book      │
│  🏢 Master Data      │
│    ├ Companies       │
│    ├ Vehicles        │
│    └ Partners        │
│  📊 Ledger           │
│  🔁 PDF ↔ Excel      │
│  ✉️  Email           │
│  🔔 Reminders        │
│  ⚙️  Settings        │
└──────────────────────┘
```

### 4.3 AI Sidebar (320px, toggleable with `Ctrl+Shift+A`)
```
┌──────────────────────────────────┐
│  🤖 Trans Book AI     [×] [—]   │
│  ─────────────────────────────   │
│  Context: Invoice JSV/25-26/100  │
│  Company: Hero Motors Limited    │
│  ─────────────────────────────   │
│                                  │
│  [AI Chat Messages Area]         │
│  Scrollable conversation         │
│                                  │
│                                  │
│  ─────────────────────────────   │
│  [Type a message...        ] [▶] │
│  [📎] [🎤] Model: GPT-4o [v]   │
└──────────────────────────────────┘
```

---

## 5. Screen Designs

### 5.1 Dashboard / Home Screen
```
┌─────────────────────────────────────────────────────┐
│  Good Morning, JSV!          February 2026          │
│  ─────────────────────────────────────────────────  │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌────────┐ │
│  │ This     │ │ Pending  │ │ TDS This │ │ Bills  │ │
│  │ Month    │ │ Payments │ │ Month    │ │Overdue │ │
│  │ ₹7,41,200│ │ ₹3,22,000│ │ ₹14,824  │ │   3    │ │
│  └──────────┘ └──────────┘ └──────────┘ └────────┘ │
│  ─────────────────────────────────────────────────  │
│  Recent Invoices                    [View All →]    │
│  ┌────────────────────────────────────────────────┐ │
│  │ JSV/25-26/100 │ Hero Motors │ ₹9,500  │ PAID  │ │
│  │ JSV/25-26/99  │ Hero Motors │ ₹18,400 │ PEND  │ │
│  │ JSV/25-26/98  │ Hero Motors │ ₹1,74,800│SUBM  │ │
│  └────────────────────────────────────────────────┘ │
│  ─────────────────────────────────────────────────  │
│  [+ New Invoice]  [Generate Summary]  [📧 Email]   │
│  ─────────────────────────────────────────────────  │
│  🔔 Reminders                                       │
│  • GST filing due in 5 days                         │
│  • Hero Motors payment overdue by 3 days            │
└─────────────────────────────────────────────────────┘
```

---

### 5.2 New Invoice Screen

```
┌─────────────────────────────────────────────────────────────────┐
│  New Tax Invoice                    [Draft] [Preview] [Save PDF]│
│  ─────────────────────────────────────────────────────────────  │
│  BILL TO: [Hero Motors Limited ▼]        Invoice Date: [28-Feb] │
│  Address: 10TH KM STONE GT ROAD...       Invoice No: JSV/25-26/101│
│  PAN: AAACH8459F  GSTIN: 09AAACH8...    Invoice Type: [STATE ▼]│
│  ─────────────────────────────────────────────────────────────  │
│  Loading Place: [GB Nagar    ] (pre-filled)                     │
│  ─────────────────────────────────────────────────────────────  │
│  ┌──┬────────────┬──────┬──────┬────────┬────────┬───────────┐  │
│  │# │ Date       │ G.R. │ Veh. │ Fright │Unload  │ Amount    │  │
│  ├──┼────────────┼──────┼──────┼────────┼────────┼───────────┤  │
│  │1 │ 26-Feb     │ 1639 │ 7555 │  9500  │HMCL 2nd│ 9500      │  │
│  │+ │ [Add Row]  │      │      │        │        │           │  │
│  └──┴────────────┴──────┴──────┴────────┴────────┴───────────┘  │
│  ─────────────────────────────────────────────────────────────  │
│                                    Total Amount:  ₹ 9,500.00    │
│                                    SGST @ 2.50%:  ₹   237.50   │
│                                    CGST @ 2.50%:  ₹   237.50   │
│                                    GST on RCM:    ₹   475.00   │
│  Amount in Words: Rupees Nine Thousand Five Hundred Only        │
│  ─────────────────────────────────────────────────────────────  │
│  [Bank Details Section]                                         │
│  GST PAYABLE BY CONSIGNOR/CONSIGNEE UNDER REVERSE CHARGE       │
└─────────────────────────────────────────────────────────────────┘
```

**Invoice Type Toggle Behaviour:**
- State → Shows SGST + CGST rows
- Inter-State → Replaces both with single IGST row
- Toggle is prominent (blue pill toggle in header)

---

### 5.3 Summary Bill Screen

```
┌──────────────────────────────────────────────────────┐
│  Generate Summary Bill          [Date: Feb 2026 ▼]  │
│  Company: [Hero Motors Limited ▼]                    │
│  ────────────────────────────────────────────────    │
│  ☑ JSV/25-26/96  │ Hero GZB → Aman    │ ₹21,000    │
│  ☑ JSV/25-26/97  │ Hero GZB → Haridwar│ ₹5,17,500  │
│  ☑ JSV/25-26/98  │ Hero GZB → Autofit │ ₹1,74,800  │
│  ☑ JSV/25-26/99  │ Hero GZB → Manesar │ ₹18,400    │
│  ☑ JSV/25-26/100 │ Hero GZB → Gurgaon │ ₹9,500     │
│  ────────────────────────────────────────────────    │
│                       Total:      ₹ 7,41,200.00      │
│                       TDS 2%:     ₹    14,824.00     │
│                       Payable:    ₹ 7,26,376.00      │
│  ────────────────────────────────────────────────    │
│    [Preview]    [Save PDF]    [📧 Email to Company]  │
└──────────────────────────────────────────────────────┘
```

---

### 5.4 Company Master Screen

```
┌─────────────────────────────────────────────────────┐
│  Companies                         [+ Add Company]  │
│  ─────────────────────────────────────────────────  │
│  Search: [________________]   Filter: [All ▼]       │
│  ─────────────────────────────────────────────────  │
│  ┌──────────────────────┬──────────┬──────────────┐  │
│  │ Hero Motors Limited  │ UP-09    │ State Invoice │  │
│  │ GSTIN: 09AAACH...   │ Active   │ [Edit] [→]   │  │
│  ├──────────────────────┼──────────┼──────────────┤  │
│  │ Autofit Industries   │ HR-06    │ Inter-State   │  │
│  │ GSTIN: 06XXXXX...   │ Active   │ [Edit] [→]   │  │
│  └──────────────────────┴──────────┴──────────────┘  │
└─────────────────────────────────────────────────────┘
```

**Add/Edit Company Dialog:**
```
┌──────────────────────────────────────────────────┐
│  Add New Company                            [×]  │
│  Name: [                              ]          │
│  Address: [                           ]          │
│  PAN: [          ] GSTIN: [           ]          │
│  State: [Uttar Pradesh ▼]  State Code: [09]      │
│  HSN/SAC: [996791]                               │
│  Invoice Type: ( ) State  ( ) Inter-State  ← ASK│
│  Default Loading Place: [                 ]      │
│  ── Rate Card ────────────────────────────────── │
│  Unloading Place     │ Freight Rate              │
│  [             ]     │ [        ]    [+ Add]     │
│  HMCL 2nd            │ 9500          [Edit][Del] │
│  ────────────────────────────────────────────── │
│  [Cancel]                         [Save Company] │
└──────────────────────────────────────────────────┘
```

---

### 5.5 TDS Distribution Screen

```
┌────────────────────────────────────────────────────┐
│  TDS Distribution                                  │
│  FY: [2025-26 ▼]  From: [Apr 2025] To: [Feb 2026] │
│  Company: [All Companies ▼]                        │
│  ─────────────────────────────────────────────     │
│  Total Invoiced:     ₹ 45,23,000                   │
│  Total TDS (2%):     ₹  90,460                     │
│  ─────────────────────────────────────────────     │
│  Vehicle  │ Trips │ Freight │ TDS Share            │
│  7555      │  48   │ ₹4,56,000│ ₹9,120            │
│  UP14AT..  │  36   │ ₹3,42,000│ ₹6,840            │
│  ─────────────────────────────────────────────     │
│  [Export Excel]  [Export PDF]  [Distribute Now]    │
└────────────────────────────────────────────────────┘
```

---

### 5.6 AI Sidebar Interaction States

**Idle State:**
- Shows firm-level summary: "This month: ₹7,41,200 billed | ₹14,824 TDS"

**Invoice Open State:**
- Shows: Invoice No., Company, Amount, Status, quick actions
- Suggestions: "This is a State Invoice — SGST+CGST applied"

**Chat State:**
- Full conversation view with message bubbles
- User messages: right-aligned, dark blue
- AI messages: left-aligned, white card with subtle shadow
- Code/numbers in monospace font
- Thinking indicator: animated dots

---

## 6. Invoice PDF Template Design

### Layout Reference (Based on Provided Images)

```
┌──────────────────────────────────────────────────────────────┐
│  [Firm Name Bold Large]                    [LOGO]            │
│  Address | Phone | Email | PAN | GSTIN | State               │
│  ────────────────────────────────── Invoice Type: STATE/IGST │
│                      TAX INVOICE                             │
│  ──────────────────────────────────────────────────────────  │
│  BILL TO:                        │ Invoice Date:             │
│  [COMPANY NAME BOLD]             │ Invoice No.:              │
│  [Address]                       │ State Code:               │
│  PAN: | GSTIN: | State:          │ Place of Supply:          │
│                                  │ HSN/SAC Code:             │
│  ──────────────────────────────────────────────────────────  │
│  [DATA TABLE — alternating row colors, bold header]          │
│  ──────────────────────────────────────────────────────────  │
│  Amount in Words: [              ]   Total:      ₹           │
│                                      SGST 2.5%:  ₹           │
│                                      CGST 2.5%:  ₹           │
│                                      GST on RCM: ₹           │
│  ──────────────────────────────────────────────────────────  │
│  BANK DETAILS                          Authorized Signatory  │
│  [Bank Info]                           [Signature + Stamp]   │
│  GST PAYABLE BY CONSIGNOR/CONSIGNEE UNDER REVERSE CHARGE    │
└──────────────────────────────────────────────────────────────┘
```

### PDF Color Scheme
- Header background: `#1A3C8F` (dark blue) with white text
- Table header: `#2D5BE3` (medium blue) with white text
- Alternate rows: `#F4F6FB` / white
- Total row: bold, `#1A3C8F` text
- Accent line: `#F7A800` (gold) border under firm header

---

## 7. Component Library

### 7.1 Buttons
| Type | Style |
|------|-------|
| Primary | Filled, `brand-primary`, white text, 8px radius |
| Secondary | Outlined, `brand-primary` border |
| Danger | Filled `#F44336` |
| Ghost | Text only, `brand-primary` color |
| Icon Button | 36px circle, icon center |

### 7.2 Form Fields
- Height: 38px
- Border: 1px `#CBD5E0`, focus: 2px `brand-primary`
- Radius: 6px
- Label: above field, 11px, `text-secondary`
- Error: red border + red text below

### 7.3 Data Table
- Header: `#1A3C8F` background, white bold text, 12px
- Row height: 36px
- Alternate row: `#F4F6FB`
- Hover: `#EBF0FF`
- Selected: `#D6E4FF`
- Amount columns: right-aligned, monospace

### 7.4 Status Badges
- Pill shape, 20px height, 8px horizontal padding
- Colors per status token defined in Section 2

### 7.5 Cards
- White background, 4px radius, shadow: `0 1px 4px rgba(0,0,0,0.1)`
- Padding: 16px

### 7.6 Invoice Row (in-app entry)
- Inline editable cells
- Last column shows delete icon on hover
- Bottom of table: `[+ Add Row]` ghost button spanning full width

---

## 8. Navigation & Keyboard Shortcuts

| Action | Shortcut |
|--------|----------|
| New Invoice | `Ctrl+N` |
| Save Invoice | `Ctrl+S` |
| Preview PDF | `Ctrl+P` |
| Open AI Sidebar | `Ctrl+Shift+A` |
| Add Invoice Row | `Ctrl+Enter` |
| Search | `Ctrl+F` |
| Go to Dashboard | `Ctrl+Home` |
| Go to Companies | `Ctrl+M` |
| Toggle Dark Mode | `Ctrl+D` |
| Open Settings | `Ctrl+,` |

---

## 9. Theme Support

### Light Theme (Default)
- Background: `#F4F6FB`
- Surface: `#FFFFFF`
- Nav: `#1A3C8F`

### Dark Theme (Optional)
- Background: `#0F1923`
- Surface: `#1C2B3A`
- Nav: `#0D2255`
- Text: `#E8F0FE`
- Accents: `#F7A800`

---

## 10. Responsive Layout Rules

Since this is a Windows desktop app:
- **Minimum supported resolution**: 1280×720
- **Recommended**: 1920×1080
- AI Sidebar auto-collapses below 1440px width
- Left nav collapses to icon-only below 1280px

---

## 11. Onboarding Flow (First Launch)

```
Step 1: Welcome Screen
  → Firm name, address, PAN, GSTIN, State setup

Step 2: Bank Details
  → Add bank account for invoice footer

Step 3: Invoice Settings
  → Starting invoice number, prefix format, FY start

Step 4: Cloud Sync (Optional)
  → Connect Google Drive / OneDrive or skip

Step 5: AI Setup (Optional)
  → Enter OpenRouter API key or skip for later

Step 6: Done → Dashboard
```

---

## 12. Accessibility
- Minimum contrast ratio: 4.5:1 (WCAG AA)
- All interactive elements keyboard-accessible
- Focus indicators visible on all inputs
- Error messages associated with form fields (not just color)
- Table columns sortable via keyboard
