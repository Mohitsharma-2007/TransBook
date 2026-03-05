import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/theme_provider.dart';
import '../../../core/constants/app_theme.dart';
import '../../ai/data/openrouter_client.dart';
import '../../profile/data/user_profile_repository.dart';
import '../../cloud/data/google_auth_service.dart';
import '../../pdf_excel/presentation/template_settings_screen.dart';
import '../../profile/presentation/profile_editor_screen.dart';

// A provider to manage the API key synchronously after it is loaded
final apiKeyProvider = StateProvider<String>((ref) => '');

// Provider to trigger auth state rebuilds
final googleAuthStateProvider = ChangeNotifierProvider<_GoogleAuthNotifier>((ref) {
  return _GoogleAuthNotifier(ref.read(googleAuthServiceProvider));
});

class _GoogleAuthNotifier extends ChangeNotifier {
  final GoogleAuthService _authService;
  _GoogleAuthNotifier(this._authService) {
    _authService.onCurrentUserChanged.listen((_) => notifyListeners());
  }
  GoogleAuthService get authService => _authService;
}

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _apiKeyController = TextEditingController();
  bool _isLoading = true;
  bool _credentialsUploaded = false;
  bool _isSigningIn = false;
  String? _credentialStatus;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('openrouter_api_key') ?? '';
    final hasClientId = prefs.getString('google_client_id') != null;
    if (mounted) {
      setState(() {
        _apiKeyController.text = key;
        _credentialsUploaded = hasClientId;
        _credentialStatus = hasClientId ? 'credentials.json loaded ✓' : null;
        _isLoading = false;
      });
      ref.read(apiKeyProvider.notifier).state = key;
    }
  }

  Future<void> _saveApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final key = _apiKeyController.text.trim();
    await prefs.setString('openrouter_api_key', key);
    ref.read(apiKeyProvider.notifier).state = key;
    ref.read(openRouterClientProvider).setApiKey(key);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('API key saved!')));
    }
  }

  Future<void> _uploadCredentialsJson() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
      dialogTitle: 'Select your Google credentials.json',
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      try {
        final authService = ref.read(googleAuthServiceProvider);
        await authService.saveCustomCredentials(content);
        if (mounted) {
          setState(() {
            _credentialsUploaded = true;
            _credentialStatus = '${result.files.single.name} loaded ✓';
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credentials saved! You can now Sign In.'), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid JSON: $e'), backgroundColor: AppTheme.errorColor),
          );
        }
      }
    }
  }

  Future<void> _signIn() async {
    if (!_credentialsUploaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload your credentials.json first ↑'), backgroundColor: AppTheme.errorColor),
      );
      return;
    }

    final authService = ref.read(googleAuthServiceProvider);

    // Show waiting dialog BEFORE starting OAuth so user can see what's happening
    String? authUrl;
    bool dialogDismissed = false;

    // Start OAuth — it will call onUrlReady once the local server is ready
    final signInFuture = authService.signIn(
      onUrlReady: (url) {
        authUrl = url;
        // Show the dialog now that we have the URL
        if (mounted && !dialogDismissed) {
          showDialog<void>(
            context: context,
            barrierDismissible: false,
            builder: (ctx) => _OAuthWaitingDialog(
              url: url,
              onCancel: () {
                authService.cancelSignIn();
                dialogDismissed = true;
                Navigator.of(ctx).pop();
              },
            ),
          );
        }
      },
    );

    setState(() => _isSigningIn = true);

    try {
      final user = await signInFuture;

      // Close the waiting dialog if still open
      if (mounted && !dialogDismissed) {
        Navigator.of(context, rootNavigator: true).popUntil((r) => r.isFirst || r.settings.name == '/');
      }

      if (mounted) {
        setState(() => _isSigningIn = false);
        if (user != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('✅ Signed in as ${user.email}'), backgroundColor: Colors.green),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign in was cancelled or timed out.'), backgroundColor: Colors.orange),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSigningIn = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign in error: $e'), backgroundColor: AppTheme.errorColor),
        );
      }
    }
  }

  Future<void> _signOut() async {
    final authService = ref.read(googleAuthServiceProvider);
    await authService.signOut();
    if (mounted) setState(() {});
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
    final authService = ref.read(googleAuthServiceProvider);
    final isSignedIn = authService.currentUser != null;
    final googleUser = authService.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Profile Card ──
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
                        Text(userProfile.companyName.isNotEmpty ? userProfile.companyName : 'Administrator',
                            style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 4),
                        Text(userProfile.gstin.isNotEmpty ? 'GSTIN: ${userProfile.gstin}' : 'Please configure your profile',
                            style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(color: AppTheme.statusBgPaid, borderRadius: BorderRadius.circular(16)),
                              child: const Text('PRO License Active',
                                  style: TextStyle(color: AppTheme.statusTextPaid, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                            const SizedBox(width: 16),
                            OutlinedButton.icon(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileEditorScreen()));
                              },
                              icon: const Icon(Icons.edit, size: 16),
                              label: const Text('Edit Firm Profile'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                minimumSize: const Size(0, 32),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ── Invoice Templates ──
            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TemplateSettingsScreen())),
              borderRadius: BorderRadius.circular(12),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppTheme.brandPrimary.withAlpha(60)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.brandPrimary.withAlpha(20),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.picture_as_pdf_outlined, color: AppTheme.brandPrimary, size: 28),
                    ),
                    const SizedBox(width: 20),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Invoice Templates', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text('Choose from 50+ beautiful invoice PDF templates, portrait or landscape',
                          style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                    ])),
                    const Icon(Icons.chevron_right, color: AppTheme.textSecondary),
                  ]),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── Google Cloud Integration ──
            Text('Google Integration (Gmail & Drive)', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('Connect Google services to send invoices via Gmail and back up data to Drive.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppTheme.textSecondary)),
            const SizedBox(height: 16),

            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step 1: Upload credentials
                    _SectionHeader(
                      icon: Icons.upload_file_outlined,
                      title: 'Step 1 — Upload credentials.json',
                      subtitle: 'Download your OAuth 2.0 credentials (Desktop app) from Google Cloud Console.',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _uploadCredentialsJson,
                          icon: const Icon(Icons.file_upload_outlined),
                          label: const Text('Choose credentials.json'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.brandSecondary, foregroundColor: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        if (_credentialStatus != null)
                          Chip(
                            avatar: const Icon(Icons.check_circle, color: Colors.green, size: 18),
                            label: Text(_credentialStatus!, style: const TextStyle(fontSize: 12)),
                            backgroundColor: Colors.green.withAlpha(20),
                          ),
                      ],
                    ),

                    const Divider(height: 32),

                    // Step 2: Sign In
                    _SectionHeader(
                      icon: Icons.login_outlined,
                      title: 'Step 2 — Sign In with Google',
                      subtitle: isSignedIn
                          ? 'Signed in as ${googleUser?.email ?? 'Unknown'}. Your app can now send Gmail and sync Drive.'
                          : 'After uploading credentials, click Sign In. A browser will open to authorise TransBook.',
                    ),
                    const SizedBox(height: 12),
                    if (!isSignedIn)
                      ElevatedButton.icon(
                        onPressed: _isSigningIn ? null : _signIn,
                        icon: _isSigningIn
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : const Icon(Icons.login),
                        label: Text(_isSigningIn ? 'Opening browser...' : 'Sign In with Google'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      )
                    else
                      Row(
                        children: [
                          const Icon(Icons.verified_user, color: Colors.green, size: 20),
                          const SizedBox(width: 8),
                          Text('Connected — Gmail & Drive active', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.green[700], fontWeight: FontWeight.bold)),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _signOut,
                            icon: const Icon(Icons.logout, size: 16),
                            label: const Text('Sign Out'),
                            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
                          ),
                        ],
                      ),

                    const Divider(height: 32),

                    // Setup Guide
                    ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: const Text('How to set up Google Cloud (step-by-step)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      children: const [
                        _GuideStep(number: '1', title: 'Create Project', description: 'Go to console.cloud.google.com → New Project → name it "TransBook"'),
                        _GuideStep(number: '2', title: 'Enable APIs', description: 'API Library → Enable "Gmail API" and "Google Drive API"'),
                        _GuideStep(number: '3', title: 'OAuth Consent Screen', description: 'Credentials → OAuth consent screen → External → Add your email as test user'),
                        _GuideStep(number: '4', title: 'Create Credentials', description: 'Credentials → Create → OAuth Client ID → Desktop application → Download JSON'),
                        _GuideStep(number: '5', title: 'Upload Here', description: 'Use the "Choose credentials.json" button above, then click Sign In'),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── Appearance ──
            Text('Appearance', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Consumer(
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
                  },
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ── AI Configuration ──
            Text('AI Assistant', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('OpenRouter API Key', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Powers the AI assistant with ChatGPT, Claude & Gemini. Get your key at openrouter.ai.',
                        style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _apiKeyController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'API Key (starts with sk-or-...)',
                        prefixIcon: Icon(Icons.vpn_key_outlined),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton.icon(
                        onPressed: _saveApiKey,
                        icon: const Icon(Icons.save),
                        label: const Text('Save Key'),
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

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _SectionHeader({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppTheme.brandPrimary, size: 22),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              const SizedBox(height: 4),
              Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
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
      padding: const EdgeInsets.only(left: 16, bottom: 12, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 11, backgroundColor: AppTheme.brandPrimary,
              child: Text(number, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(description, style: Theme.of(context).textTheme.bodySmall),
            ],
          )),
        ],
      ),
    );
  }
}

/// Shown while waiting for the user to complete OAuth in the browser.
class _OAuthWaitingDialog extends StatelessWidget {
  final String url;
  final VoidCallback onCancel;

  const _OAuthWaitingDialog({required this.url, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.open_in_browser, color: AppTheme.brandPrimary),
          SizedBox(width: 12),
          Text('Complete Sign-In in Browser'),
        ],
      ),
      content: SizedBox(
        width: 520,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LinearProgressIndicator(),
            const SizedBox(height: 20),
            const Text(
              'A browser window should have opened. Please:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('1. Sign in with your Google account'),
            const Text('2. Click "Allow" on the permissions screen'),
            const Text('3. Come back here — the dialog will close automatically'),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('If browser did not open, copy this URL and open it manually:',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 6),
                  SelectableText(
                    url,
                    style: const TextStyle(fontSize: 11, fontFamily: 'monospace', color: Colors.blue),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'This dialog will auto-close after you approve access. Timeout: 3 minutes.',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
          child: const Text('Cancel Sign-In'),
        ),
      ],
    );
  }
}
