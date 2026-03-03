// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reminderRepositoryHash() =>
    r'6db03ae4b34ee2d671fdcad320162747e47e7896';

/// See also [reminderRepository].
@ProviderFor(reminderRepository)
final reminderRepositoryProvider =
    AutoDisposeProvider<ReminderRepository>.internal(
      reminderRepository,
      name: r'reminderRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reminderRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReminderRepositoryRef = AutoDisposeProviderRef<ReminderRepository>;
String _$pendingRemindersHash() => r'8fc16b3cb9343d8402f6b47e0ba27e6c31e9c42f';

/// See also [pendingReminders].
@ProviderFor(pendingReminders)
final pendingRemindersProvider =
    AutoDisposeStreamProvider<List<Reminder>>.internal(
      pendingReminders,
      name: r'pendingRemindersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pendingRemindersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PendingRemindersRef = AutoDisposeStreamProviderRef<List<Reminder>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
