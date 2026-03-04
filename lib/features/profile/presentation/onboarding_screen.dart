import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/constants/app_theme.dart';
import '../data/user_profile_repository.dart';
import '../../../main.dart'; 

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _companyNameController = TextEditingController();
  final _gstinController = TextEditingController();
  final _addressController = TextEditingController();
  final _bankDetailsController = TextEditingController();
  String _logoPath = '';

  @override
  void dispose() {
    _companyNameController.dispose();
    _gstinController.dispose();
    _addressController.dispose();
    _bankDetailsController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png', 'jpeg'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _logoPath = result.files.single.path!;
      });
    }
  }

  Future<void> _completeOnboarding() async {
    if (_companyNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Company name is required')));
      return;
    }

    final profile = UserProfile(
      companyName: _companyNameController.text.trim(),
      logoPath: _logoPath,
      gstin: _gstinController.text.trim(),
      address: _addressController.text.trim(),
      bankDetails: _bankDetailsController.text.trim(),
    );

    await ref.read(userProfileRepositoryProvider).saveProfile(profile);
    ref.read(userProfileProvider.notifier).state = profile;

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceLight,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.rocket_launch, size: 64, color: AppTheme.brandPrimary),
                const SizedBox(height: 24),
                Text(
                  'Welcome to TransBook',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: AppTheme.brandPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Let\'s set up your company profile. These details will be printed on your invoices.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _companyNameController,
                  decoration: const InputDecoration(labelText: 'Company Name*', border: OutlineInputBorder(), prefixIcon: Icon(Icons.business)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _gstinController,
                  decoration: const InputDecoration(labelText: 'GSTIN', border: OutlineInputBorder(), prefixIcon: Icon(Icons.confirmation_number)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _addressController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Company Address', border: OutlineInputBorder(), prefixIcon: Icon(Icons.location_on)),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _bankDetailsController,
                  maxLines: 2,
                  decoration: const InputDecoration(labelText: 'Bank Account Details (A/C, IFSC, Bank Name)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.account_balance)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _pickLogo,
                      icon: const Icon(Icons.image),
                      label: const Text('Select Company Logo'),
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.surfaceLight, foregroundColor: AppTheme.textPrimary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(_logoPath.isNotEmpty ? 'Logo Selected' : 'No Logo Selected', style: TextStyle(color: _logoPath.isNotEmpty ? AppTheme.statusTextPaid : AppTheme.textMuted)),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _completeOnboarding,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brandPrimary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  child: const Text('Get Started'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
