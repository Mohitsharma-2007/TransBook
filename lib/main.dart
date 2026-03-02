import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/master_data/presentation/companies_screen.dart';
import 'features/master_data/presentation/vehicles_screen.dart';
import 'features/master_data/presentation/rate_card_screen.dart';
import 'core/constants/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: TransBookApp()));
}

class TransBookApp extends StatelessWidget {
  const TransBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trans Book',
      theme: AppTheme.lightTheme,
      home: const MainShell(),
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
    const Center(child: Text('Dashboard Coming Soon', style: TextStyle(fontSize: 24, color: AppTheme.textSecondary))),
    const CompaniesScreen(),
    const VehiclesScreen(),
    const RateCardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trans Book'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications), onPressed: () {}),
          IconButton(icon: const Icon(Icons.person), onPressed: () {}),
        ],
      ),
      body: Row(
        children: [
          // Left Navigation
          Container(
            width: 200,
            color: AppTheme.surfaceWhite,
            child: ListView(
              children: [
                _NavHeader('Start'),
                _NavItem(Icons.dashboard, 'Dashboard', selected: _selectedIndex == 0, onTap: () => setState(() => _selectedIndex = 0)),
                _NavHeader('Master Data'),
                _NavItem(Icons.business, 'Companies', selected: _selectedIndex == 1, onTap: () => setState(() => _selectedIndex = 1)),
                _NavItem(Icons.local_shipping, 'Vehicles', selected: _selectedIndex == 2, onTap: () => setState(() => _selectedIndex = 2)),
                _NavItem(Icons.monetization_on, 'Rate Cards', selected: _selectedIndex == 3, onTap: () => setState(() => _selectedIndex = 3)),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          // Main Content Area
          Expanded(
            child: Container(
              color: AppTheme.surfaceLight,
              child: _screens[_selectedIndex],
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
      padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem(this.icon, this.title, {this.selected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected ? AppTheme.brandPrimary.withOpacity(0.1) : Colors.transparent,
      child: ListTile(
        leading: Icon(icon, color: selected ? AppTheme.brandPrimary : AppTheme.textSecondary, size: 20),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: selected ? AppTheme.brandPrimary : AppTheme.textPrimary,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              ),
        ),
        dense: true,
        onTap: onTap,
      ),
    );
  }
}
