import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/master_data/presentation/companies_screen.dart';
import 'features/master_data/presentation/vehicles_screen.dart';
import 'features/master_data/presentation/partners_screen.dart';
import 'features/master_data/presentation/rate_card_screen.dart';
import 'features/invoicing/presentation/invoices_screen.dart';
import 'features/billing_management/presentation/summary_bills_screen.dart';
import 'features/payment_distribution/presentation/payments_screen.dart';
import 'features/reminders/presentation/reminders_screen.dart';
import 'features/record_book/presentation/record_book_screen.dart';
import 'features/cloud/presentation/cloud_sync_screen.dart';
import 'features/cloud/presentation/emails_screen.dart';
import 'features/settings/presentation/settings_screen.dart';
import 'features/search/presentation/global_search_dialog.dart';
import 'features/labels/presentation/labels_screen.dart';
import 'features/ai/presentation/ai_sidebar.dart';
import 'features/profile/presentation/onboarding_screen.dart';
import 'features/profile/data/user_profile_repository.dart';
import 'core/constants/app_theme.dart';
import 'core/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const TransBookApp(),
    ),
  );
}

class TransBookApp extends ConsumerWidget {
  const TransBookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final userProfile = ref.watch(userProfileProvider);

    return MaterialApp(
      title: 'Trans Book',
      theme: themeState.themeData,
      home: userProfile.isComplete ? const MainShell() : const OnboardingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const InvoicesScreen(),
    const SummaryBillsScreen(),
    const PaymentsScreen(),
    const RemindersScreen(),
    const RecordBookScreen(),
    const CloudSyncScreen(),
    const EmailsScreen(),
    const CompaniesScreen(),
    const VehiclesScreen(),
    const PartnersScreen(),
    const RateCardScreen(),
    const LabelsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.brandSecondary.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.local_shipping, color: AppTheme.brandSecondary),
            ),
            const SizedBox(width: 12),
            const Text(
              'TransBook',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: AppTheme.borderLight, height: 1),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () async {
              final result = await showDialog(
                context: context,
                builder: (context) => const GlobalSearchDialog(),
              );
              // Result handling could navigate to specific screens
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            tooltip: 'Notifications',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notifications coming soon!')));
            },
          ),
          Builder(
            builder: (context) {
              return IconButton(
                icon: const Icon(Icons.smart_toy_outlined),
                tooltip: 'AI Assistant',
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              );
            }
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 8.0),
            child: CircleAvatar(
              backgroundColor: AppTheme.brandSecondary.withAlpha(25),
              child: IconButton(
                icon: const Icon(Icons.person_outline, color: AppTheme.brandSecondary),
                tooltip: 'Profile & Settings',
                onPressed: () => setState(() => _selectedIndex = 12),
              ),
            ),
          ),
        ],
      ),
      endDrawer: const AISidebar(),
      body: Row(
        children: [
          // Left Navigation
          Container(
            width: 240,
            color: AppTheme.surfaceWhite,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              children: [
                _NavHeader('Start'),
                _NavItem(Icons.space_dashboard_outlined, Icons.space_dashboard_rounded, 'Dashboard', selected: _selectedIndex == 0, onTap: () => setState(() => _selectedIndex = 0)),
                _NavItem(Icons.summarize_outlined, Icons.summarize_rounded, 'Summary Bills', selected: _selectedIndex == 1, onTap: () => setState(() => _selectedIndex = 1)),
                _NavItem(Icons.account_balance_wallet_outlined, Icons.account_balance_wallet_rounded, 'Payments', selected: _selectedIndex == 2, onTap: () => setState(() => _selectedIndex = 2)),
                _NavItem(Icons.notifications_active_outlined, Icons.notifications_active, 'Reminders', selected: _selectedIndex == 3, onTap: () => setState(() => _selectedIndex = 3)),
                _NavItem(Icons.menu_book_outlined, Icons.menu_book_rounded, 'Record Book', selected: _selectedIndex == 4, onTap: () => setState(() => _selectedIndex = 4)),
                _NavItem(Icons.cloud_sync_outlined, Icons.cloud_sync_rounded, 'Cloud Sync', selected: _selectedIndex == 5, onTap: () => setState(() => _selectedIndex = 5)),
                _NavItem(Icons.mail_outline, Icons.mail_rounded, 'Email Hub', selected: _selectedIndex == 6, onTap: () => setState(() => _selectedIndex = 6)),
                const SizedBox(height: 16),
                _NavHeader('Master Data'),
                _NavItem(Icons.business_outlined, Icons.business_rounded, 'Companies', selected: _selectedIndex == 7, onTap: () => setState(() => _selectedIndex = 7)),
                _NavItem(Icons.local_shipping_outlined, Icons.local_shipping_rounded, 'Vehicles', selected: _selectedIndex == 8, onTap: () => setState(() => _selectedIndex = 8)),
                _NavItem(Icons.handshake_outlined, Icons.handshake_rounded, 'Partners', selected: _selectedIndex == 9, onTap: () => setState(() => _selectedIndex = 9)),
                _NavItem(Icons.monetization_on_outlined, Icons.monetization_on_rounded, 'Rate Cards', selected: _selectedIndex == 10, onTap: () => setState(() => _selectedIndex = 10)),
                _NavItem(Icons.label_outline, Icons.label_rounded, 'Labels', selected: _selectedIndex == 11, onTap: () => setState(() => _selectedIndex = 11)),
                const SizedBox(height: 16),
                const Divider(color: AppTheme.borderLight),
                _NavItem(Icons.settings_outlined, Icons.settings, 'Settings', selected: _selectedIndex == 12, onTap: () => setState(() => _selectedIndex = 12)),
              ],
            ),
          ),
          const VerticalDivider(width: 1, color: AppTheme.borderLight),
          // Main Content Area
          Expanded(
            child: Container(
              color: AppTheme.surfaceLight,
              child: _screens[_selectedIndex]
                  .animate(key: ValueKey(_selectedIndex)) // Key forces re-animation on switch
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.05, end: 0, duration: 300.ms, curve: Curves.easeOutCubic),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavHeader extends StatelessWidget {
  final String title;
  const _NavHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, top: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData defaultIcon;
  final IconData selectedIcon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem(this.defaultIcon, this.selectedIcon, this.title, {this.selected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppTheme.brandSecondary.withAlpha(20) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                selected ? selectedIcon : defaultIcon,
                color: selected ? AppTheme.brandSecondary : AppTheme.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selected ? AppTheme.brandSecondary : AppTheme.textPrimary,
                      fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
