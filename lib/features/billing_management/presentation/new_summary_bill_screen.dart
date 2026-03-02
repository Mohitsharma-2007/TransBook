import 'package:flutter/material.dart';

class NewSummaryBillScreen extends StatelessWidget {
  const NewSummaryBillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Summary Bill')),
      body: const Center(
        child: Text('Summary Bill Builder - Coming in Wave 3'),
      ),
    );
  }
}
