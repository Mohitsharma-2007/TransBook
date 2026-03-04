import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum InvoiceTemplateStyle {
  modern,
  classic,
  compact,
  luxury,
  minimalist,
}

class PdfTemplateConfig {
  final InvoiceTemplateStyle style;
  final int primaryColorHex;
  final bool showVehicleNo;
  final bool showTripDate;
  final bool showRate;
  final String? footerText;

  PdfTemplateConfig({
    required this.style,
    required this.primaryColorHex,
    required this.showVehicleNo,
    required this.showTripDate,
    required this.showRate,
    this.footerText,
  });

  factory PdfTemplateConfig.defaultConfig() {
    return PdfTemplateConfig(
      style: InvoiceTemplateStyle.modern,
      primaryColorHex: 0xFF1A73E8, // Brand Primary
      showVehicleNo: true,
      showTripDate: true,
      showRate: true,
      footerText: 'Thank you for your business!',
    );
  }

  PdfTemplateConfig copyWith({
    InvoiceTemplateStyle? style,
    int? primaryColorHex,
    bool? showVehicleNo,
    bool? showTripDate,
    bool? showRate,
    String? footerText,
  }) {
    return PdfTemplateConfig(
      style: style ?? this.style,
      primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      showVehicleNo: showVehicleNo ?? this.showVehicleNo,
      showTripDate: showTripDate ?? this.showTripDate,
      showRate: showRate ?? this.showRate,
      footerText: footerText ?? this.footerText,
    );
  }
}

final pdfTemplateConfigProvider = StateNotifierProvider<PdfTemplateNotifier, PdfTemplateConfig>((ref) {
  return PdfTemplateNotifier();
});

class PdfTemplateNotifier extends StateNotifier<PdfTemplateConfig> {
  PdfTemplateNotifier() : super(PdfTemplateConfig.defaultConfig()) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final styleIndex = prefs.getInt('pdf_template_style') ?? 0;
    final color = prefs.getInt('pdf_template_primary_color') ?? 0xFF1A73E8;
    final showVehicle = prefs.getBool('pdf_template_show_vehicle') ?? true;
    final showTripDate = prefs.getBool('pdf_template_show_trip_date') ?? true;
    final showRate = prefs.getBool('pdf_template_show_rate') ?? true;
    final footer = prefs.getString('pdf_template_footer');

    state = PdfTemplateConfig(
      style: InvoiceTemplateStyle.values[styleIndex],
      primaryColorHex: color,
      showVehicleNo: showVehicle,
      showTripDate: showTripDate,
      showRate: showRate,
      footerText: footer,
    );
  }

  Future<void> updateConfig(PdfTemplateConfig config) async {
    state = config;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pdf_template_style', config.style.index);
    await prefs.setInt('pdf_template_primary_color', config.primaryColorHex);
    await prefs.setBool('pdf_template_show_vehicle', config.showVehicleNo);
    await prefs.setBool('pdf_template_show_trip_date', config.showTripDate);
    await prefs.setBool('pdf_template_show_rate', config.showRate);
    if (config.footerText != null) {
      await prefs.setString('pdf_template_footer', config.footerText!);
    }
  }
}
