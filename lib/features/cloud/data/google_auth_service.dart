import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Standalone class to mimic GoogleSignInAccount for UI compatibility
class GoogleUser {
  final String email;
  final String? displayName;
  final String? photoUrl;
  GoogleUser({required this.email, this.displayName, this.photoUrl});
}

final googleAuthServiceProvider = Provider((ref) => GoogleAuthService());

class GoogleAuthService {
  final _scopes = [
    drive.DriveApi.driveFileScope,
    gmail.GmailApi.gmailSendScope,
  ];

  final _userController = StreamController<GoogleUser?>.broadcast();
  GoogleUser? _currentUser;
  auth.AccessCredentials? _credentials;

  GoogleAuthService() {
    _loadStoredCredentials();
  }

  GoogleUser? get currentUser => _currentUser;
  Stream<GoogleUser?> get onCurrentUserChanged => _userController.stream;

  Future<void> _loadStoredCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    _clientId = prefs.getString('google_client_id');
    _clientSecret = prefs.getString('google_client_secret');
    _targetFolderId = prefs.getString('google_drive_folder_id');
  }

  Future<void> saveCustomCredentials(String jsonString) async {
    try {
      final json = jsonDecode(jsonString);
      final installed = json['installed'] ?? json['web'];
      if (installed == null) throw Exception('Invalid JSON format: missing "installed" or "web" key');
      
      _clientId = installed['client_id'];
      _clientSecret = installed['client_secret'];
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('google_client_id', _clientId!);
      await prefs.setString('google_client_secret', _clientSecret!);
    } catch (e) {
      print('Error saving credentials: $e');
      rethrow;
    }
  }

  Future<void> saveTargetFolderId(String folderId) async {
    _targetFolderId = folderId;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('google_drive_folder_id', folderId);
  }

  String? get targetFolderId => _targetFolderId;

  Future<GoogleUser?> signIn() async {
    try {
      if (_clientId == null || _clientSecret == null) {
        throw Exception('Custom credentials not found. Please upload your credentials.json in Settings.');
      }

      final clientId = auth.ClientId(_clientId!, _clientSecret!);

      final client = await auth.clientViaUserConsent(clientId, _scopes, (url) {
        launchUrl(Uri.parse(url));
      });

      _credentials = client.credentials;
      _currentUser = GoogleUser(email: 'user@example.com'); // Placeholder until we fetch profile
      _userController.add(_currentUser);
      return _currentUser;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  Future<GoogleUser?> signInSilently() async {
    return _currentUser;
  }

  Future<void> signOut() async {
    _currentUser = null;
    _credentials = null;
    _userController.add(null);
  }

  Future<auth.AuthClient?> getAuthenticatedClient() async {
    if (_credentials == null) await signInSilently();
    if (_credentials == null) return null;

    final clientId = auth.ClientId(_clientId!, _clientSecret!);
    return auth.authenticatedClient(http.Client(), _credentials!);
  }
}
