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
  final String pan;
  final String email;
  final String phone;
  final String website;
  final String stateCode;
  final String invoicePrefix;
  final int nextInvoiceNumber;

  UserProfile({
    this.companyName = '',
    this.logoPath = '',
    this.gstin = '',
    this.address = '',
    this.bankDetails = '',
    this.pan = '',
    this.email = '',
    this.phone = '',
    this.website = '',
    this.stateCode = '',
    this.invoicePrefix = 'JSV/25-26/',
    this.nextInvoiceNumber = 1,
  });

  bool get isComplete => companyName.isNotEmpty;

  UserProfile copyWith({
    String? companyName,
    String? logoPath,
    String? gstin,
    String? address,
    String? bankDetails,
    String? pan,
    String? email,
    String? phone,
    String? website,
    String? stateCode,
    String? invoicePrefix,
    int? nextInvoiceNumber,
  }) {
    return UserProfile(
      companyName: companyName ?? this.companyName,
      logoPath: logoPath ?? this.logoPath,
      gstin: gstin ?? this.gstin,
      address: address ?? this.address,
      bankDetails: bankDetails ?? this.bankDetails,
      pan: pan ?? this.pan,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
      stateCode: stateCode ?? this.stateCode,
      invoicePrefix: invoicePrefix ?? this.invoicePrefix,
      nextInvoiceNumber: nextInvoiceNumber ?? this.nextInvoiceNumber,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'companyName': companyName,
      'logoPath': logoPath,
      'gstin': gstin,
      'address': address,
      'bankDetails': bankDetails,
      'pan': pan,
      'email': email,
      'phone': phone,
      'website': website,
      'stateCode': stateCode,
      'invoicePrefix': invoicePrefix,
      'nextInvoiceNumber': nextInvoiceNumber,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      companyName: json['companyName'] ?? '',
      logoPath: json['logoPath'] ?? '',
      gstin: json['gstin'] ?? '',
      address: json['address'] ?? '',
      bankDetails: json['bankDetails'] ?? '',
      pan: json['pan'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      website: json['website'] ?? '',
      stateCode: json['stateCode'] ?? '',
      invoicePrefix: json['invoicePrefix'] ?? 'JSV/25-26/',
      nextInvoiceNumber: json['nextInvoiceNumber'] as int? ?? 1,
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
