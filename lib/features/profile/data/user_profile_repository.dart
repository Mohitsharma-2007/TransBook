import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/theme_provider.dart';

class UserProfile {
  final String companyName;
  final String logoPath;
  final String gstin;
  final String address;
  final String bankDetails;

  UserProfile({
    this.companyName = '',
    this.logoPath = '',
    this.gstin = '',
    this.address = '',
    this.bankDetails = '',
  });

  bool get isComplete => companyName.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'logoPath': logoPath,
      'gstin': gstin,
      'address': address,
      'bankDetails': bankDetails,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      companyName: json['companyName'] ?? '',
      logoPath: json['logoPath'] ?? '',
      gstin: json['gstin'] ?? '',
      address: json['address'] ?? '',
      bankDetails: json['bankDetails'] ?? '',
    );
  }
}

class UserProfileRepository {
  final SharedPreferences _prefs;
  static const _key = 'user_profile_data';

  UserProfileRepository(this._prefs);

  UserProfile getProfile() {
    final str = _prefs.getString(_key);
    if (str != null && str.isNotEmpty) {
      try {
        return UserProfile.fromJson(jsonDecode(str));
      } catch (e) {
        return UserProfile();
      }
    }
    return UserProfile();
  }

  Future<void> saveProfile(UserProfile profile) async {
    await _prefs.setString(_key, jsonEncode(profile.toJson()));
  }
  
  Future<void> clearProfile() async {
    await _prefs.remove(_key);
  }
}

final userProfileRepositoryProvider = Provider<UserProfileRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return UserProfileRepository(prefs);
});

final userProfileProvider = StateProvider<UserProfile>((ref) {
  final repo = ref.watch(userProfileRepositoryProvider);
  return repo.getProfile();
});
