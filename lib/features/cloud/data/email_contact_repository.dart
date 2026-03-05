import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/theme_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Model
// ─────────────────────────────────────────────────────────────────────────────

class EmailContact {
  final String id;
  final String name;
  final String email;
  final String? company;
  final String? phone;
  final bool isAutoImported; // from Companies master data

  const EmailContact({
    required this.id,
    required this.name,
    required this.email,
    this.company,
    this.phone,
    this.isAutoImported = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'email': email,
    'company': company, 'phone': phone, 'isAutoImported': isAutoImported,
  };

  factory EmailContact.fromJson(Map<String, dynamic> j) => EmailContact(
    id: j['id'] as String,
    name: j['name'] as String,
    email: j['email'] as String,
    company: j['company'] as String?,
    phone: j['phone'] as String?,
    isAutoImported: j['isAutoImported'] as bool? ?? false,
  );

  EmailContact copyWith({String? name, String? email, String? company, String? phone}) =>
    EmailContact(id: id, name: name ?? this.name, email: email ?? this.email,
        company: company ?? this.company, phone: phone ?? this.phone,
        isAutoImported: isAutoImported);
}

// ─────────────────────────────────────────────────────────────────────────────
// Repository — SharedPreferences storage
// ─────────────────────────────────────────────────────────────────────────────

class EmailContactRepository {
  final SharedPreferences _prefs;
  static const _key = 'email_contacts_v1';

  EmailContactRepository(this._prefs);

  List<EmailContact> getAll() {
    final raw = _prefs.getString(_key);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => EmailContact.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) { return []; }
  }

  Future<void> saveAll(List<EmailContact> contacts) async {
    await _prefs.setString(_key, jsonEncode(contacts.map((c) => c.toJson()).toList()));
  }

  Future<void> add(EmailContact contact) async {
    final all = getAll();
    if (!all.any((c) => c.email.toLowerCase() == contact.email.toLowerCase())) {
      all.add(contact);
      await saveAll(all);
    }
  }

  Future<void> update(EmailContact contact) async {
    final all = getAll();
    final idx = all.indexWhere((c) => c.id == contact.id);
    if (idx >= 0) { all[idx] = contact; await saveAll(all); }
  }

  Future<void> delete(String id) async {
    final all = getAll()..removeWhere((c) => c.id == id);
    await saveAll(all);
  }

  /// Merge a list of auto-imported contacts (from Companies) without overwriting manual ones
  Future<void> mergeAutoImported(List<EmailContact> imported) async {
    final all = getAll();
    for (final imp in imported) {
      if (!all.any((c) => c.email.toLowerCase() == imp.email.toLowerCase())) {
        all.add(imp);
      }
    }
    await saveAll(all);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────────────────────────────────────

final emailContactRepositoryProvider = Provider<EmailContactRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return EmailContactRepository(prefs);
});

final emailContactsProvider = StateNotifierProvider<EmailContactsNotifier, List<EmailContact>>((ref) {
  final repo = ref.watch(emailContactRepositoryProvider);
  return EmailContactsNotifier(repo);
});

class EmailContactsNotifier extends StateNotifier<List<EmailContact>> {
  final EmailContactRepository _repo;
  EmailContactsNotifier(this._repo) : super(_repo.getAll());

  Future<void> add(EmailContact c) async {
    await _repo.add(c);
    state = _repo.getAll();
  }

  Future<void> update(EmailContact c) async {
    await _repo.update(c);
    state = _repo.getAll();
  }

  Future<void> delete(String id) async {
    await _repo.delete(id);
    state = _repo.getAll();
  }

  Future<void> mergeAutoImported(List<EmailContact> imported) async {
    await _repo.mergeAutoImported(imported);
    state = _repo.getAll();
  }
}
