import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import '../../../core/constants/app_theme.dart';
import '../../../core/di/database_provider.dart';
import '../data/google_drive_service.dart';
import '../data/google_auth_service.dart';

class CloudSyncScreen extends ConsumerStatefulWidget {
  const CloudSyncScreen({super.key});

  @override
  ConsumerState<CloudSyncScreen> createState() => _CloudSyncScreenState();
}

class _CloudSyncScreenState extends ConsumerState<CloudSyncScreen> {
  bool _isSyncing = false;
  final _folderIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _folderIdController.text = ref.read(googleAuthServiceProvider).targetFolderId ?? '';
    });
  }

  @override
  void dispose() {
    _folderIdController.dispose();
    super.dispose();
  }

  Future<void> _manualSync() async {
    final driveService = ref.read(googleDriveServiceProvider);
    
    if (!driveService.isAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please connect Google Drive first.')),
      );
      return;
    }

    setState(() => _isSyncing = true);
    await driveService.processQueue();
    await Future.delayed(const Duration(seconds: 1)); // Simulate visual delay
    if (mounted) {
      setState(() => _isSyncing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sync completed successfully.')),
      );
    }
  }

  void _handleGoogleSignIn() async {
    final authService = ref.read(googleAuthServiceProvider);
    try {
      await authService.signIn();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-in failed: ${e.toString()}'), backgroundColor: AppTheme.errorColor),
        );
      }
    }
  }

  Future<void> _uploadJson() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      try {
        await ref.read(googleAuthServiceProvider).saveCustomCredentials(content);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credentials updated successfully!'), backgroundColor: Colors.green),
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

  Future<void> _saveFolderId() async {
    final folderId = _folderIdController.text.trim();
    await ref.read(googleAuthServiceProvider).saveTargetFolderId(folderId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Folder ID saved!'), backgroundColor: Colors.green),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(appDatabaseProvider);
    final syncQueueStream = db.select(db.syncQueue).watch();
    final driveService = ref.watch(googleDriveServiceProvider);

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Cloud File System', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold))
                  .animate().fadeIn().slideX(begin: -0.1),
              Row(
                children: [
                  if (!driveService.isAuthenticated)
                    ElevatedButton.icon(
                      onPressed: _handleGoogleSignIn,
                      icon: const Icon(Icons.cloud_upload_outlined, size: 18),
                      label: const Text('Connect Google Drive'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.brandPrimary,
                        foregroundColor: Colors.white,
                      ),
                    ).animate().fadeIn().slideX(begin: 0.1)
                  else
                    ElevatedButton.icon(
                      onPressed: _isSyncing ? null : _manualSync,
                      icon: _isSyncing 
                        ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.sync, size: 18),
                      label: Text(_isSyncing ? 'Syncing...' : 'Sync Now'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.statusBgPaid,
                        foregroundColor: AppTheme.statusTextPaid,
                      ),
                    ).animate().fadeIn().slideX(begin: 0.1),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Configuration Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppTheme.borderLight),
            ),
            child: ExpansionTile(
              title: const Text('Cloud Connection Settings', style: TextStyle(fontWeight: FontWeight.bold)),
              leading: const Icon(Icons.settings_suggest_outlined),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Google Cloud Credentials', style: TextStyle(fontWeight: FontWeight.w500)),
                                Text('Upload your credentials.json file from the Google Cloud Console.', style: Theme.of(context).textTheme.bodySmall),
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: _uploadJson,
                            icon: const Icon(Icons.upload_file),
                            label: const Text('Upload JSON'),
                            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.surfaceLight, foregroundColor: AppTheme.textPrimary),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _folderIdController,
                              decoration: const InputDecoration(
                                labelText: 'Target Drive Folder ID (Optional)',
                                hintText: 'Enter folder ID from URL',
                                border: OutlineInputBorder(),
                                helperText: 'If empty, a "TransBook" folder will be created in root.',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton.filled(
                            onPressed: _saveFolderId,
                            icon: const Icon(Icons.save),
                            tooltip: 'Save Folder ID',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 100.ms),
          
          const SizedBox(height: 24),
          
          Expanded(
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppTheme.borderLight),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: StreamBuilder(
                  stream: syncQueueStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final queueItems = snapshot.data ?? [];
                    
                    if (queueItems.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cloud_done_outlined, size: 80, color: AppTheme.statusAcknowledged),
                            const SizedBox(height: 16),
                            Text('All files are synced!', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: AppTheme.statusAcknowledged)),
                            const SizedBox(height: 8),
                            Text('Your Google Drive is fully up to date.', style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ).animate().fadeIn(delay: 300.ms).scale(),
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: queueItems.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final item = queueItems[index];
                        return ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.brandSecondary.withAlpha(25),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.picture_as_pdf, color: AppTheme.brandSecondary),
                          ),
                          title: Text('${item.entityType} #${item.entityId} - ${item.action}'),
                          subtitle: Text('Queued on: ${DateFormat('dd MMM yyyy, hh:mm a').format(DateTime.parse(item.createdAt!))}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Attempts: ${item.attempts}'),
                              if (item.lastAttempt != null)
                                Text('Last: ${DateFormat('hh:mm a').format(DateTime.parse(item.lastAttempt!))}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                            ],
                          ),
                        );
                      },
                    ).animate().fadeIn(duration: 400.ms, delay: 200.ms);
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
