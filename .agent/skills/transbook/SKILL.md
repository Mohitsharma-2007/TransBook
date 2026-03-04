---
name: TransBook Developer Guidelines
description: Core architecture patterns and guidelines for developing the TransBook application.
---
# TransBook Developer SKILL

This application is named **TransBook**, built natively for Windows Desktop using Flutter.

## Architecture Guidelines
- **State Management**: Deeply integrated with `Riverpod`, specifically using `@riverpod` code-generations (`part 'filename.g.dart';`).
- **Database Architecture**: Uses `Drift` for local SQLite databases. All tables must be defined in `core/database/tables.dart` and the main AppDatabase registered in `core/database/database.dart`.
- **UI & Theme Constraints**: All UI must strictly adhere to `AppTheme` colors located in `core/constants/app_theme.dart`. DO NOT hardcode colors (e.g. avoid `Colors.red`, `Colors.blue`). Always use variants like `AppTheme.brandSecondary`, `AppTheme.textPrimary`, `AppTheme.statusError`, etc.
- **Design Language**: Use the 'Inter' font uniformly, apply rounded borders (e.g., `BorderRadius.circular(12)`), and hook into `flutter_animate` (e.g. `.animate().fadeIn().slideY()`) for smooth entrance interactions. Prefer `DataTable2` for table representations.

## Database Migrations (CRITICAL)
If you add a new table to `tables.dart`, you MUST perform the following or the app will crash at startup for existing users (`no such table`):
1. Include it in the `tables: [...]` array of the `@DriftDatabase` annotation inside `database.dart`.
2. Increment the `schemaVersion` number in `database.dart`.
3. Provide an `onUpgrade` migration strategy path inside `database.dart` utilizing `await m.createTable(myNewTable);`.
4. Run `dart run build_runner build -d` to regenerate the mapping layer.

## AI Client Configuration
The TransBook platform contains an embedded AI Assistant relying on `OpenRouterClient`. Ensure prompt context constructions strictly maintain token-efficient groupings (mapping to dictionaries only the essentials like `invoiceId` and `totalAmt` vs dumping entire Drift objects) before invoking HTTP calls.
