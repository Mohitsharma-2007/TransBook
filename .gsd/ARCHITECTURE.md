# ARCHITECTURE.md

## Technology Stack
- **Framework**: Flutter (Windows Desktop) + Dart
- **Local DB**: Drift (SQLite)
- **State Management**: Riverpod (`flutter_riverpod`, `riverpod_annotation`)
- **PDF Generation**: `pdf` + `printing`
- **Excel**: `excel`
- **Cloud Storage**: Google Drive API + MSAL (OneDrive)
- **AI**: OpenRouter API (`dio` client)
- **Installer**: Inno Setup

## Folder Structure
- `lib/core/`: constants, database, di, errors, services, utils
- `lib/features/`: invoicing, master_data, tds, payment_distribution, record_book, ledger, pdf_excel, email, reminders, ai_chat, settings
  - Each feature follows Clean Architecture: `data/`, `domain/`, `presentation/`

## Core Patterns
- Offline-first: Read/Write to Drift. Sync async to cloud via background queue.
- Repository Pattern for data access.
- AI Context builder injected into OpenRouter API dynamically based on open screens.
