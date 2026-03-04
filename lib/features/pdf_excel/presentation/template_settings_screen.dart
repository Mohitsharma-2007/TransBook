import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_theme.dart';
import '../domain/pdf_template_config.dart';

class TemplateSettingsScreen extends ConsumerWidget {
  const TemplateSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(pdfTemplateConfigProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Template Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDesignPreview(config),
                const SizedBox(height: 32),
                _buildStyleSelector(context, ref, config),
                const SizedBox(height: 24),
                _buildColorSelector(ref, config),
                const SizedBox(height: 24),
                _buildFieldToggles(ref, config),
                const SizedBox(height: 24),
                _buildFooterEditor(ref, config),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesignPreview(PdfTemplateConfig config) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        height: 200,
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Color(config.primaryColorHex), Color(config.primaryColorHex).withOpacity(0.8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.picture_as_pdf, size: 48, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              '${config.style.name.toUpperCase()} PREVIEW',
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
            ),
            const SizedBox(height: 4),
            const Text(
              'Your invoices will look like this professional template.',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleSelector(BuildContext context, WidgetRef ref, PdfTemplateConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Template Style', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: InvoiceTemplateStyle.values.map((style) {
            final isSelected = config.style == style;
            return ChoiceChip(
              label: Text(style.name.toUpperCase()),
              selected: isSelected,
              onSelected: (val) {
                if (val) ref.read(pdfTemplateConfigProvider.notifier).updateConfig(config.copyWith(style: style));
              },
              selectedColor: AppTheme.brandPrimary,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildColorSelector(WidgetRef ref, PdfTemplateConfig config) {
    final colors = [
      0xFF1A73E8, // Google Blue
      0xFFD32F2F, // Red
      0xFF388E3C, // Green
      0xFF7B1FA2, // Purple
      0xFFF57C00, // Orange
      0xFF455A64, // Blue Grey
      0xFF000000, // Black
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Primary Branding Color', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          children: colors.map((color) {
            final isSelected = config.primaryColorHex == color;
            return GestureDetector(
              onTap: () => ref.read(pdfTemplateConfigProvider.notifier).updateConfig(config.copyWith(primaryColorHex: color)),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Color(color),
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: Colors.black, width: 3) : null,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                ),
                child: isSelected ? const Icon(Icons.check, color: Colors.white) : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildFieldToggles(WidgetRef ref, PdfTemplateConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Invoice Fields Visibility', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SwitchListTile(
          title: const Text('Show Vehicle Number'),
          subtitle: const Text('Include vehicle registration in the data table'),
          value: config.showVehicleNo,
          onChanged: (val) => ref.read(pdfTemplateConfigProvider.notifier).updateConfig(config.copyWith(showVehicleNo: val)),
        ),
        SwitchListTile(
          title: const Text('Show Trip/GR Date'),
          subtitle: const Text('Include the specific date of each entry'),
          value: config.showTripDate,
          onChanged: (val) => ref.read(pdfTemplateConfigProvider.notifier).updateConfig(config.copyWith(showTripDate: val)),
        ),
        SwitchListTile(
          title: const Text('Show Individual Rates'),
          subtitle: const Text('Display rate per weight/trip in the table'),
          value: config.showRate,
          onChanged: (val) => ref.read(pdfTemplateConfigProvider.notifier).updateConfig(config.copyWith(showRate: val)),
        ),
      ],
    );
  }

  Widget _buildFooterEditor(WidgetRef ref, PdfTemplateConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Custom Footer Message', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter a custom thank you note or legal disclaimer...',
          ),
          onChanged: (val) => ref.read(pdfTemplateConfigProvider.notifier).updateConfig(config.copyWith(footerText: val)),
          controller: TextEditingController(text: config.footerText)..selection = TextSelection.collapsed(offset: config.footerText?.length ?? 0),
        ),
      ],
    );
  }
}
