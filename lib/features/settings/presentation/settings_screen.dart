import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/theme_provider.dart';
import '../../../core/constants/app_theme.dart';
import '../../ai/data/openrouter_client.dart';
import '../../profile/data/user_profile_repository.dart';

// A provider to manage the API key synchronously after it is loaded
final apiKeyProvider = StateProvider<String>((ref) => '');

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('openrouter_api_key') ?? '';
    if (mounted) {
      setState(() {
        _apiKeyController.text = key;
        _isLoading = false;
      });
      ref.read(apiKeyProvider.notifier).state = key;
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final key = _apiKeyController.text.trim();
    await prefs.setString('openrouter_api_key', key);
    
    // Update Riverpod state and inject into OpenRouter client
    ref.read(apiKeyProvider.notifier).state = key;
    ref.read(openRouterClientProvider).setApiKey(key);
    
    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings saved successfully!')));
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final userProfile = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundColor: AppTheme.brandSecondary.withAlpha(25),
                      child: const Icon(Icons.person, size: 36, color: AppTheme.brandSecondary),
                    ),
                    const SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(userProfile.companyName.isNotEmpty ? userProfile.companyName : 'Administrator', style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 4),
                        Text(userProfile.gstin.isNotEmpty ? 'GSTIN: ${userProfile.gstin}' : 'Please configure your profile', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.statusBgPaid,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text('PRO License Active', style: TextStyle(color: AppTheme.statusTextPaid, fontWeight: FontWeight.bold, fontSize: 12)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Theme Configuration Section
            Text('Appearance', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Select Theme', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Choose the aesthetic of TransBook that fits your business style.', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 16),
                    Consumer(
                      builder: (context, ref, child) {
                        final currentTheme = ref.watch(themeProvider).mode;
                        return SegmentedButton<AppThemeMode>(
                          segments: const [
                            ButtonSegment(value: AppThemeMode.light, label: Text('Light'), icon: Icon(Icons.light_mode)),
                            ButtonSegment(value: AppThemeMode.dark, label: Text('Dark'), icon: Icon(Icons.dark_mode)),
                            ButtonSegment(value: AppThemeMode.modernBusiness, label: Text('Modern'), icon: Icon(Icons.business_center)),
                            ButtonSegment(value: AppThemeMode.minimalist, label: Text('Minimal'), icon: Icon(Icons.architecture)),
                          ],
                          selected: {currentTheme},
                          onSelectionChanged: (Set<AppThemeMode> newSelection) {
                            ref.read(themeProvider.notifier).setTheme(newSelection.first);
                          },
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            // AI Configuration Section
            Text('AI Assistant Configuration', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('OpenRouter API Key', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('TransBook uses OpenRouter to access ChatGPT, Claude, and Gemini. You need your own API key to use the AI Assistant.', style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _apiKeyController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'API Key (starts with sk-or)',
                        prefixIcon: Icon(Icons.vpn_key_outlined),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _saveSettings,
                        icon: const Icon(Icons.save),
                        label: const Text('Save Settings'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Cloud API Guide section
            Text('Cloud API Configuration Guide', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _GuideStep(
                      number: '1',
                      title: 'Google Cloud Console',
                      description: 'Go to console.cloud.google.com and create a new project named "TransBook".',
                    ),
                    const _GuideStep(
                      number: '2',
                      title: 'Enable APIs',
                      description: 'Enable "Gmail API" and "Google Drive API" in the API Library.',
                    ),
                    const _GuideStep(
                      number: '3',
                      title: 'OAuth Consent Screen',
                      description: 'Configure the Consent Screen as "External". Add "user@jsvtech.com" as a test user if in testing.',
                    ),
                    const _GuideStep(
                      number: '4',
                      title: 'Create Credentials',
                      description: 'Create OAuth 2.0 Client IDs for "Desktop application". Download the JSON file.',
                    ),
                    const _GuideStep(
                      number: '5',
                      title: 'Configure in App',
                      description: 'Place the `client_secrets.json` in the root of TransBook or use the Sync button to trigger authentication.',
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(20),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.withAlpha(40)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline, color: Colors.blue),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your authentication tokens are stored securely in the system keychain.',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.blue[800]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GuideStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _GuideStep({required this.number, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: AppTheme.brandPrimary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(description, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
