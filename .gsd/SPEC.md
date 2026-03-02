# SPEC.md — Project Specification

> **Status**: `FINALIZED`

## Vision
Trans Book is a Windows desktop application built in Flutter for Indian transportation firms to automate and manage the full lifecycle of GST-compliant tax invoicing, payment distribution, TDS management, partner settlements, and document archiving — enhanced by an integrated AI agentic layer.

## Goals
1. Reduce billing time: Invoice creation < 3 minutes
2. Eliminate GST errors: 100% auto-calculated tax fields
3. Automate TDS distribution: Zero manual calculation errors
4. Partner payment clarity: One-click distribution report
5. AI context awareness: Chatbot responds in < 8 seconds

## Non-Goals (Out of Scope)
- Generic accounting functionality (Not a full ERP)
- Web or Mobile versions (Platform constraint: Windows only)
- Online payment gateway processing
- Payroll or employee management

## Users
- Transportation firm owners/partners
- Billing clerks and accountants
- Operating under Indian GST regime (RCM applicable)
- Following Indian Financial Year (April–March)

## Constraints
- **Platform**: Windows 10 / 11 (64-bit) via Flutter Desktop
- **Architecture**: Offline First (Full core functionality without internet)
- **Security**: AES-256 local DB encryption
- **Performance**: Startup < 5s; Queries < 200ms
- **Dependencies**: Native PDF engine (no third-party driver installations), SQLite (Drift)

## Success Criteria
- [ ] MVP with Invoicing, Company Master, PDF Export, and Summary built.
- [ ] Reverse Charge Mechanism (RCM) logic accurately applying to final invoices.
- [ ] Generated PDF matches the exact layout specification.
- [ ] Sequence rolling correctly handles Financial Year logic.
