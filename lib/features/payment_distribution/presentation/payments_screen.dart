import 'package:flutter/material.dart';
import '../../../core/constants/app_theme.dart';
import 'customer_payments_tab.dart';
import 'payment_distribution_screen.dart';
import 'partner_ledger_screen.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Container(
            color: AppTheme.surfaceWhite,
            child: const TabBar(
              labelColor: AppTheme.brandSecondary,
              unselectedLabelColor: AppTheme.textSecondary,
              indicatorColor: AppTheme.brandSecondary,
              tabs: [
                Tab(text: 'Customer Payments', icon: Icon(Icons.account_balance_wallet)),
                Tab(text: 'Distribution Engine', icon: Icon(Icons.calculate)),
                Tab(text: 'Partner Ledger', icon: Icon(Icons.handshake_outlined)),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                CustomerPaymentsTab(),
                PaymentDistributionScreen(),
                PartnerLedgerScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
