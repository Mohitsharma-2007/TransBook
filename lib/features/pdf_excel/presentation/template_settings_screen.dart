import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_theme.dart';
import '../domain/pdf_template_config.dart';

class TemplateSettingsScreen extends ConsumerStatefulWidget {
  const TemplateSettingsScreen({super.key});

  @override
  ConsumerState<TemplateSettingsScreen> createState() => _TemplateSettingsScreenState();
}

class _TemplateSettingsScreenState extends ConsumerState<TemplateSettingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _groups = PdfTemplateConfig.templateGroups;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _groups.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTemplate = ref.watch(pdfTemplateConfigProvider);
    final isLandscape = currentTemplate.pageOrientation == PdfPageOrientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Templates'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: _groups.map((g) => Tab(text: g)).toList(),
        ),
        actions: [
          // Portrait/Landscape toggle
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            child: SegmentedButton<PdfPageOrientation>(
              segments: const [
                ButtonSegment(value: PdfPageOrientation.portrait, icon: Icon(Icons.crop_portrait, size: 16), label: Text('Portrait')),
                ButtonSegment(value: PdfPageOrientation.landscape, icon: Icon(Icons.crop_landscape, size: 16), label: Text('Landscape')),
              ],
              selected: {currentTemplate.pageOrientation},
              onSelectionChanged: (s) async {
                final newTemplate = currentTemplate.copyWithOrientation(s.first);
                await ref.read(pdfTemplateConfigProvider.notifier).updateConfig(newTemplate);
              },
              style: ButtonStyle(
                padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 8)),
                textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 12)),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Chip(
            avatar: const Icon(Icons.check_circle, size: 16, color: AppTheme.brandPrimary),
            label: Text(
              '${currentTemplate.templateName} · ${isLandscape ? "L" : "P"}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            backgroundColor: AppTheme.brandPrimary.withAlpha(15),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: _groups.map((group) {
          final templates = PdfTemplateConfig.templatesByGroup(group);
          return _TemplateGroupGrid(
            templates: templates,
            selectedTemplate: currentTemplate,
            onSelect: (template) async {
              final withOrientation = template.copyWithOrientation(currentTemplate.pageOrientation);
              await ref.read(pdfTemplateConfigProvider.notifier).updateConfig(withOrientation);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Template: "${template.templateName}" · ${isLandscape ? "Landscape" : "Portrait"}'),
                    behavior: SnackBarBehavior.floating,
                    duration: const Duration(seconds: 2),
                  ),
                );
              }
            },
          );
        }).toList(),
      ),
    );
  }
}

class _TemplateGroupGrid extends StatelessWidget {
  final List<PdfTemplateConfig> templates;
  final PdfTemplateConfig selectedTemplate;
  final void Function(PdfTemplateConfig) onSelect;

  const _TemplateGroupGrid({
    required this.templates,
    required this.selectedTemplate,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 280,
        childAspectRatio: 0.85,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: templates.length,
      itemBuilder: (context, index) {
        final template = templates[index];
        final isSelected = template.style == selectedTemplate.style;
        return _TemplateCard(
          template: template,
          isSelected: isSelected,
          onSelect: () => onSelect(template),
        );
      },
    );
  }
}

class _TemplateCard extends StatelessWidget {
  final PdfTemplateConfig template;
  final bool isSelected;
  final VoidCallback onSelect;

  const _TemplateCard({required this.template, required this.isSelected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final primary = Color(template.primaryColorHex);
    final accent = Color(template.accentColorHex);
    final headerText = Color(template.headerTextColorHex);

    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primary : Colors.grey.shade200,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [BoxShadow(color: primary.withAlpha(60), blurRadius: 12, offset: const Offset(0, 4))]
              : [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── PDF Preview mockup ──
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: _InvoiceMockup(
                    primary: primary,
                    accent: accent,
                    headerText: headerText,
                    layoutVariant: template.layoutVariant,
                    templateName: template.templateName,
                  ),
                ),
              ),
              // ── Info strip ──
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? primary.withAlpha(15) : Colors.grey.shade50,
                  border: Border(top: BorderSide(color: Colors.grey.shade200)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(template.templateName,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: isSelected ? primary : AppTheme.textPrimary)),
                          Text(template.templateDescription,
                              style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: primary, size: 20)
                    else
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Renders a mini mock-up of the PDF layout inside the card
class _InvoiceMockup extends StatelessWidget {
  final Color primary;
  final Color accent;
  final Color headerText;
  final PdfLayoutVariant layoutVariant;
  final String templateName;

  const _InvoiceMockup({
    required this.primary, required this.accent, required this.headerText,
    required this.layoutVariant, required this.templateName,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          const SizedBox(height: 4),
          _buildTable(),
          const SizedBox(height: 4),
          _buildTotalsRow(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    switch (layoutVariant) {
      case PdfLayoutVariant.letterheadTop:
        return Container(
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [primary, accent]),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 60, height: 4, color: headerText.withAlpha(180)),
              const SizedBox(height: 3),
              Container(width: 80, height: 3, color: headerText.withAlpha(120)),
              const SizedBox(height: 2),
              Container(width: 50, height: 2, color: headerText.withAlpha(80)),
            ],
          ),
        );
      case PdfLayoutVariant.doubleBorder:
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(color: primary, width: 1.5),
          ),
          child: Container(
            height: 30,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              border: Border.all(color: primary.withAlpha(100), width: 0.5),
              color: primary.withAlpha(25),
            ),
            child: Row(children: [
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 50, height: 3, color: primary),
                  const SizedBox(height: 2),
                  Container(width: 70, height: 2, color: primary.withAlpha(120)),
                ],
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                color: primary,
                child: Text('TAX INVOICE', style: TextStyle(color: headerText, fontSize: 6, fontWeight: FontWeight.bold)),
              ),
            ]),
          ),
        );
      default: // headerBand, singleBorder, etc.
        return Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: primary,
            borderRadius: layoutVariant == PdfLayoutVariant.headerBand
                ? BorderRadius.circular(3)
                : BorderRadius.zero,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(width: 50, height: 4, color: headerText.withAlpha(200)),
                const SizedBox(height: 2),
                Container(width: 65, height: 2, color: headerText.withAlpha(130)),
              ]),
              Text('INVOICE', style: TextStyle(color: headerText, fontSize: 7, fontWeight: FontWeight.bold, letterSpacing: 1)),
            ],
          ),
        );
    }
  }

  Widget _buildTable() {
    final isZebra = layoutVariant == PdfLayoutVariant.zebra;
    final isStripe = layoutVariant == PdfLayoutVariant.stripedRows;
    return Expanded(
      child: Column(
        children: [
          // Header row
          Container(
            height: 10,
            color: primary.withAlpha(30),
            child: Row(children: [
              Expanded(flex: 3, child: Container(margin: const EdgeInsets.all(2), color: primary.withAlpha(80))),
              Expanded(flex: 1, child: Container(margin: const EdgeInsets.all(2), color: primary.withAlpha(80))),
              Expanded(flex: 1, child: Container(margin: const EdgeInsets.all(2), color: primary.withAlpha(80))),
            ]),
          ),
          // Data rows
          ...List.generate(4, (i) {
            Color? rowBg = isZebra
                ? (i.isEven ? primary.withAlpha(12) : null)
                : isStripe
                    ? (i.isEven ? primary.withAlpha(8) : null)
                    : null;
            return Container(
              height: 9,
              color: rowBg,
              child: Row(children: [
                Expanded(flex: 3, child: Container(margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2.5), color: Colors.grey.shade300)),
                Expanded(flex: 1, child: Container(margin: const EdgeInsets.all(2), color: Colors.grey.shade200)),
                Expanded(flex: 1, child: Container(margin: const EdgeInsets.all(2), color: Colors.grey.shade200)),
              ]),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTotalsRow() {
    return Container(
      height: 16,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: primary.withAlpha(20),
        border: Border(top: BorderSide(color: primary, width: 1)),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(width: 40, height: 4, color: Colors.grey.shade300),
        Container(width: 30, height: 5, color: primary),
      ]),
    );
  }
}
