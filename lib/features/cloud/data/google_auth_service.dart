import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

/// Minimal representation of the signed-in Google user.
class GoogleUser {
  final String email;
  final String? displayName;
  final String? photoUrl;
  GoogleUser({required this.email, this.displayName, this.photoUrl});
}

final googleAuthServiceProvider = Provider((ref) => GoogleAuthService());

class GoogleAuthService {
  static const _keyClientId = 'google_client_id';
  static const _keyClientSecret = 'google_client_secret';
  static const _keyFolderId = 'google_drive_folder_id';
  static const _keyAccessToken = 'google_access_token';
  static const _keyRefreshToken = 'google_refresh_token';
  static const _keyTokenExpiry = 'google_token_expiry';
  static const _keyUserEmail = 'google_user_email';

  final _scopes = [
    drive.DriveApi.driveFileScope,
    gmail.GmailApi.gmailSendScope,
    gmail.GmailApi.gmailReadonlyScope,
    'https://www.googleapis.com/auth/userinfo.email',
  ];

  final _userController = StreamController<GoogleUser?>.broadcast();
  GoogleUser? _currentUser;
  auth.AccessCredentials? _credentials;

  String? _clientId;
  String? _clientSecret;
  String? _targetFolderId;

  GoogleAuthService() {
    _restoreSession();
  }

  GoogleUser? get currentUser => _currentUser;
  Stream<GoogleUser?> get onCurrentUserChanged => _userController.stream;
  String? get targetFolderId => _targetFolderId;

  // ── Persistence ─────────────────────────────────────────────────────────

  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    _clientId = prefs.getString(_keyClientId);
    _clientSecret = prefs.getString(_keyClientSecret);
    _targetFolderId = prefs.getString(_keyFolderId);

    final accessToken = prefs.getString(_keyAccessToken);
    final refreshToken = prefs.getString(_keyRefreshToken);
    final expiryStr = prefs.getString(_keyTokenExpiry);
    final email = prefs.getString(_keyUserEmail);

    if (_clientId != null && _clientSecret != null && refreshToken != null && email != null) {
      final expiry = expiryStr != null ? DateTime.tryParse(expiryStr) : null;
      final token = auth.AccessToken(
        'Bearer',
        accessToken ?? '',
        expiry ?? DateTime.now().add(const Duration(seconds: 1)),
      );
      _credentials = auth.AccessCredentials(
        token,
        refreshToken,
        _scopes,
      );
      _currentUser = GoogleUser(email: email);
      _userController.add(_currentUser);
      // Attempt silent refresh
      _trySilentRefresh();
    }
  }

  Future<void> _trySilentRefresh() async {
    try {
      final client = await getAuthenticatedClient();
      client?.close();
    } catch (_) {
      // Silently fail — user will need to re-sign-in
    }
  }

  Future<void> _saveSession(auth.AccessCredentials creds, String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccessToken, creds.accessToken.data);
    if (creds.refreshToken != null) {
      await prefs.setString(_keyRefreshToken, creds.refreshToken!);
    }
    await prefs.setString(_keyTokenExpiry, creds.accessToken.expiry.toIso8601String());
    await prefs.setString(_keyUserEmail, email);
  }

  Future<void> _clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccessToken);
    await prefs.remove(_keyRefreshToken);
    await prefs.remove(_keyTokenExpiry);
    await prefs.remove(_keyUserEmail);
  }

  // ── Credential Management ────────────────────────────────────────────────

  Future<void> saveCustomCredentials(String jsonString) async {
    final json = jsonDecode(jsonString);
    final installed = json['installed'] ?? json['web'];
    if (installed == null) {
      throw Exception('Invalid credentials.json: missing "installed" or "web" key.');
    }
    _clientId = installed['client_id'] as String?;
    _clientSecret = installed['client_secret'] as String?;
    if (_clientId == null || _clientSecret == null) {
      throw Exception('credentials.json is missing client_id or client_secret.');
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyClientId, _clientId!);
    await prefs.setString(_keyClientSecret, _clientSecret!);
  }

  Future<void> saveTargetFolderId(String folderId) async {
    _targetFolderId = folderId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFolderId, folderId);
  }

  // Used to signal cancellation of an in-progress OAuth flow
  Completer<void>? _cancelCompleter;

  /// Initiates OAuth 2.0 browser flow.
  /// [onUrlReady] is called with the auth URL so the caller can show it
  /// in a dialog as a fallback if the browser doesn't open automatically.
  Future<GoogleUser?> signIn({void Function(String url)? onUrlReady}) async {
    if (_clientId == null || _clientSecret == null) {
      throw Exception('No credentials found. Please upload credentials.json in Settings first.');
    }

    _cancelCompleter = Completer<void>();
    final clientId = auth.ClientId(_clientId!, _clientSecret!);

    auth.AuthClient? client;
    try {
      // Race OAuth against 3-minute timeout and cancel signal
      client = await Future.any([
        _obtainClientInBackground(clientId, onUrlReady: onUrlReady),
        _cancelCompleter!.future.then((_) => null),
        Future.delayed(const Duration(minutes: 3)).then((_) {
          print('[GoogleAuth] Sign-in timed out after 3 minutes.');
          return null;
        }),
      ]);
    } finally {
      _cancelCompleter = null;
    }

    if (client == null) return null;

    _credentials = client.credentials;

    // Fetch the user's email via userinfo API
    String email = 'user@google.com';
    try {
      final resp = await client.get(Uri.parse('https://www.googleapis.com/oauth2/v1/userinfo?alt=json'));
      final info = jsonDecode(resp.body) as Map<String, dynamic>;
      email = info['email'] as String? ?? email;
    } catch (_) {}

    await _saveSession(_credentials!, email);
    _currentUser = GoogleUser(email: email, displayName: email.split('@').first);
    _userController.add(_currentUser);
    client.close();
    return _currentUser;
  }

  /// Cancel an in-progress sign-in. Safe to call even if not signing in.
  void cancelSignIn() {
    if (_cancelCompleter != null && !_cancelCompleter!.isCompleted) {
      _cancelCompleter!.complete();
    }
  }

  /// Wrapper that runs `clientViaUserConsent`.
  Future<auth.AuthClient?> _obtainClientInBackground(
    auth.ClientId clientId, {
    void Function(String url)? onUrlReady,
  }) async {
    try {
      final client = await auth.clientViaUserConsent(
        clientId,
        _scopes,
        (url) async {
          // Notify caller so they can show the URL
          onUrlReady?.call(url);
          // Use Windows native shell start command — most reliable method on Windows
          try {
            final result = await Process.run('cmd', ['/c', 'start', '', url]);
            if (result.exitCode != 0) {
              // Fallback: try explorer.exe directly
              await Process.run('explorer.exe', [url]);
            }
          } catch (_) {
            // Last fallback: url_launcher
            try {
              await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
            } catch (e) {
              print('[GoogleAuth] All browser launch methods failed: $e');
            }
          }
        },
      );
      return client;
    } on SocketException catch (e) {
      print('[GoogleAuth] Network error during OAuth: $e');
      return null;
    } catch (e) {
      print('[GoogleAuth] OAuth error: $e');
      return null;
    }
  }

  Future<GoogleUser?> signInSilently() async {
    return _currentUser;
  }

  Future<void> signOut() async {
    _currentUser = null;
    _credentials = null;
    await _clearSession();
    _userController.add(null);
  }

  // ── Authenticated Client ─────────────────────────────────────────────────

  Future<auth.AuthClient?> getAuthenticatedClient() async {
    if (_credentials == null) return null;

    if (_clientId == null || _clientSecret == null) return null;

    final baseClient = http.Client();
    final clientId = auth.ClientId(_clientId!, _clientSecret!);

    try {
      // Auto-refresh if expired
      final refreshed = await auth.refreshCredentials(clientId, _credentials!, baseClient);
      _credentials = refreshed;
      // Persist refreshed tokens
      if (_currentUser != null) {
        await _saveSession(refreshed, _currentUser!.email);
      }
      return auth.authenticatedClient(baseClient, refreshed);
    } catch (e) {
      print('Token refresh failed: $e');
      baseClient.close();
      return null;
    }
  }
}
