import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/constants/app_theme.dart';
import '../data/user_profile_repository.dart';

class ProfileEditorScreen extends ConsumerStatefulWidget {
  const ProfileEditorScreen({super.key});

  @override
  ConsumerState<ProfileEditorScreen> createState() => _ProfileEditorScreenState();
}

class _ProfileEditorScreenState extends ConsumerState<ProfileEditorScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _companyController;
  late TextEditingController _addressController;
  late TextEditingController _gstinController;
  late TextEditingController _panController;
  late TextEditingController _stateCodeController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _websiteController;
  late TextEditingController _bankController;
  late TextEditingController _prefixController;
  late TextEditingController _nextNumController;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileProvider);
    _companyController = TextEditingController(text: profile.companyName);
    _addressController = TextEditingController(text: profile.address);
    _gstinController = TextEditingController(text: profile.gstin);
    _panController = TextEditingController(text: profile.pan);
    _stateCodeController = TextEditingController(text: profile.stateCode);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
    _websiteController = TextEditingController(text: profile.website);
    _bankController = TextEditingController(text: profile.bankDetails);
    _prefixController = TextEditingController(text: profile.invoicePrefix);
    _nextNumController = TextEditingController(text: profile.nextInvoiceNumber.toString());
  }

  @override
  void dispose() {
    _companyController.dispose();
    _addressController.dispose();
    _gstinController.dispose();
    _panController.dispose();
    _stateCodeController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _websiteController.dispose();
    _bankController.dispose();
    _prefixController.dispose();
    _nextNumController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final repo = ref.read(userProfileRepositoryProvider);
      
      final nextNum = int.tryParse(_nextNumController.text) ?? 1;

      final updatedProfile = UserProfile(
        companyName: _companyController.text.trim(),
        address: _addressController.text.trim(),
        gstin: _gstinController.text.trim().toUpperCase(),
        pan: _panController.text.trim().toUpperCase(),
        stateCode: _stateCodeController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        website: _websiteController.text.trim(),
        bankDetails: _bankController.text.trim(),
        invoicePrefix: _prefixController.text.trim(),
        nextInvoiceNumber: nextNum,
      );

      await repo.saveProfile(updatedProfile);
      
      // Update state
      ref.read(userProfileProvider.notifier).state = updatedProfile;

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Firm Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: _saveProfile,
              icon: const Icon(Icons.save),
              label: const Text('Save Profile'),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.business, color: AppTheme.brandPrimary, size: 28),
                          const SizedBox(width: 12),
                          Text('Basic Details', style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _companyController,
                              decoration: const InputDecoration(labelText: 'Company / Firm Name*', prefixIcon: Icon(Icons.business_outlined)),
                              validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _stateCodeController,
                              decoration: const InputDecoration(labelText: 'State Code (e.g., 07)', prefixIcon: Icon(Icons.map_outlined)),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: 'Full Address*', prefixIcon: Icon(Icons.location_on_outlined)),
                        maxLines: 2,
                        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.receipt_long, color: AppTheme.brandPrimary, size: 28),
                          const SizedBox(width: 12),
                          Text('Tax & Registration', style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _gstinController,
                              decoration: const InputDecoration(labelText: 'GSTIN', prefixIcon: Icon(Icons.numbers)),
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _panController,
                              decoration: const InputDecoration(labelText: 'PAN', prefixIcon: Icon(Icons.credit_card)),
                              textCapitalization: TextCapitalization.characters,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.contacts, color: AppTheme.brandPrimary, size: 28),
                          const SizedBox(width: 12),
                          Text('Contact Info', style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                      const Divider(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined)),
                              keyboardType: TextInputType.emailAddress,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined)),
                              keyboardType: TextInputType.phone,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _websiteController,
                              decoration: const InputDecoration(labelText: 'Website', prefixIcon: Icon(Icons.language)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.numbers, color: AppTheme.brandSecondary, size: 28),
                          const SizedBox(width: 12),
                          Text('Invoice Numbering', style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Configure how your invoices are numbered automatically.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary)),
                      const Divider(height: 32),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: _prefixController,
                              decoration: const InputDecoration(labelText: 'Invoice Prefix (e.g. JSV/25-26/ )', prefixIcon: Icon(Icons.short_text)),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _nextNumController,
                              decoration: const InputDecoration(labelText: 'Next Number (e.g. 101)', prefixIcon: Icon(Icons.pin)),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            flex: 2,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppTheme.brandSecondary.withAlpha(20),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.brandSecondary.withAlpha(50)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Preview', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                                  const SizedBox(height: 4),
                                  ValueListenableBuilder(
                                    valueListenable: _prefixController,
                                    builder: (context, prefixVal, _) {
                                      return ValueListenableBuilder(
                                        valueListenable: _nextNumController,
                                        builder: (context, numVal, _) {
                                          return Text(
                                            '${prefixVal.text}${numVal.text.isEmpty ? '1' : numVal.text}',
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.brandSecondary),
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.account_balance, color: AppTheme.brandPrimary, size: 28),
                          const SizedBox(width: 12),
                          Text('Bank Details', style: Theme.of(context).textTheme.titleLarge),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('This will be printed on your invoices for payment collection.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary)),
                      const Divider(height: 32),
                      TextFormField(
                        controller: _bankController,
                        decoration: const InputDecoration(
                          labelText: 'Bank Account Information',
                          hintText: 'Bank Name: HDFC\nA/C No: 1234567890\nIFSC: HDFC0001234\nBranch: New Delhi',
                          alignLabelWithHint: true,
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 60),
                            child: Icon(Icons.account_balance_wallet_outlined),
                          ),
                        ),
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
