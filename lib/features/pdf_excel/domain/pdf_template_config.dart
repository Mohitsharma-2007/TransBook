import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Full 50-template enum. Each value is a unique named style.
enum InvoiceTemplateStyle {
  // ── Group 1: Corporate (10) ──
  modernBlue,
  navyExecutive,
  corporateGrey,
  steelPro,
  slateEdge,
  midnightBusiness,
  cobaltClean,
  oceanProfessional,
  royalBlue,
  azureMoment,

  // ── Group 2: Premium (5) ──
  goldLuxury,
  emeraldElite,
  rubyPremium,
  sapphireBold,
  onyxDark,

  // ── Group 3: Minimal (5) ──
  cleanWhite,
  monoLine,
  pureSimple,
  lightTouch,
  ghostGrey,

  // ── Group 4: Bold & Vivid (5) ──
  deepTeal,
  amberBright,
  coralFire,
  forestGreen,
  indigoPop,

  // ── Group 5: Classic (5) ──
  traditionalBlack,
  vintageSepia,
  oldLedger,
  bankerStyle,
  heritage,

  // ── Group 6: Transport / Industry (5) ──
  fleetBlue,
  logisticsOrange,
  roadGrey,
  cargoDark,
  expressRed,

  // ── Group 7: GST-Focused (5) ──
  gstStandard,
  gstCompact,
  gstMultiRate,
  gstExport,
  gstService,

  // ── Group 8: Summary Bills (5) ──
  summaryClassic,
  summaryModern,
  summaryPremium,
  summaryTally,
  summaryPro,

  // ── Group 9: Letterhead (5) ──
  letterheadBlue,
  letterheadPro,
  letterheadMinimal,
  letterheadBold,
  letterheadClean,

  // ── Backward compat aliases ──
  modern,
  classic,
  compact,
  luxury,
  minimalist,
}

/// Layout variant — determines the visual structure of the PDF invoice.
enum PdfLayoutVariant {
  singleBorder,   // Standard box with single border lines
  doubleBorder,   // Nested double-border box  
  headerBand,     // Full-width colored header band
  stripedRows,    // Alternating row colours
  zebra,          // Zebra table rows
  letterheadTop,  // Tall letterhead-style header
  compact,        // Dense single-page layout
  gstCompliant,   // Two-column GST layout with CGST/SGST breakdown visible
}

/// Page orientation for the PDF output.
enum PdfPageOrientation { portrait, landscape }

class PdfTemplateConfig {
  final InvoiceTemplateStyle style;
  final int primaryColorHex;
  final bool showVehicleNo;
  final bool showTripDate;
  final bool showRate;
  final String? footerText;

  // Extended fields for 50-template system
  final String templateName;
  final String templateDescription;
  final String templateGroup;
  final PdfLayoutVariant layoutVariant;
  final int accentColorHex;
  final int headerTextColorHex;
  final bool showWatermark;
  final bool showCompanyLogo;
  final PdfPageOrientation pageOrientation;

  const PdfTemplateConfig({
    required this.style,
    required this.primaryColorHex,
    required this.showVehicleNo,
    required this.showTripDate,
    required this.showRate,
    this.footerText,
    this.templateName = 'Modern Blue',
    this.templateDescription = 'Default professional invoice',
    this.templateGroup = 'Corporate',
    this.layoutVariant = PdfLayoutVariant.singleBorder,
    this.accentColorHex = 0xFF1565C0,
    this.headerTextColorHex = 0xFFFFFFFF,
    this.showWatermark = false,
    this.showCompanyLogo = true,
    this.pageOrientation = PdfPageOrientation.portrait,
  });

  PdfTemplateConfig copyWithOrientation(PdfPageOrientation orientation) {
    return PdfTemplateConfig(
      style: style, primaryColorHex: primaryColorHex,
      showVehicleNo: showVehicleNo, showTripDate: showTripDate, showRate: showRate,
      footerText: footerText, templateName: templateName, templateDescription: templateDescription,
      templateGroup: templateGroup, layoutVariant: layoutVariant,
      accentColorHex: accentColorHex, headerTextColorHex: headerTextColorHex,
      showWatermark: showWatermark, showCompanyLogo: showCompanyLogo,
      pageOrientation: orientation,
    );
  }

  factory PdfTemplateConfig.defaultConfig() => allTemplates[0];

  /// All 50 templates as a static list
  static List<PdfTemplateConfig> get allTemplates => [
    // ─── Group 1: Corporate ───────────────────────────────────────────────
    PdfTemplateConfig(style: InvoiceTemplateStyle.modernBlue, primaryColorHex: 0xFF1A73E8,
      accentColorHex: 0xFF1565C0, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Modern Blue', templateGroup: 'Corporate', templateDescription: 'Clean blue with white header text',
      layoutVariant: PdfLayoutVariant.headerBand, footerText: 'Thank you for your business!'),

    PdfTemplateConfig(style: InvoiceTemplateStyle.navyExecutive, primaryColorHex: 0xFF003366,
      accentColorHex: 0xFF001F4D, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Navy Executive', templateGroup: 'Corporate', templateDescription: 'Deep navy for premium correspondence',
      layoutVariant: PdfLayoutVariant.doubleBorder, footerText: 'Payment due within 30 days'),

    PdfTemplateConfig(style: InvoiceTemplateStyle.corporateGrey, primaryColorHex: 0xFF455A64,
      accentColorHex: 0xFF263238, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Corporate Grey', templateGroup: 'Corporate', templateDescription: 'Professional slate grey',
      layoutVariant: PdfLayoutVariant.headerBand, footerText: 'E. & O. E.'),

    PdfTemplateConfig(style: InvoiceTemplateStyle.steelPro, primaryColorHex: 0xFF546E7A,
      accentColorHex: 0xFF37474F, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: false, showRate: true,
      templateName: 'Steel Pro', templateGroup: 'Corporate', templateDescription: 'Steel blue minimalist corporate',
      layoutVariant: PdfLayoutVariant.singleBorder),

    PdfTemplateConfig(style: InvoiceTemplateStyle.slateEdge, primaryColorHex: 0xFF607D8B,
      accentColorHex: 0xFF455A64, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: false, showTripDate: true, showRate: true,
      templateName: 'Slate Edge', templateGroup: 'Corporate', templateDescription: 'Slate blue edge design',
      layoutVariant: PdfLayoutVariant.stripedRows),

    PdfTemplateConfig(style: InvoiceTemplateStyle.midnightBusiness, primaryColorHex: 0xFF1A237E,
      accentColorHex: 0xFF0D1B6E, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Midnight Business', templateGroup: 'Corporate', templateDescription: 'Midnight indigo with bold header',
      layoutVariant: PdfLayoutVariant.headerBand),

    PdfTemplateConfig(style: InvoiceTemplateStyle.cobaltClean, primaryColorHex: 0xFF0039CB,
      accentColorHex: 0xFF0030B0, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: false,
      templateName: 'Cobalt Clean', templateGroup: 'Corporate', templateDescription: 'Vivid cobalt with clean zebra rows',
      layoutVariant: PdfLayoutVariant.zebra),

    PdfTemplateConfig(style: InvoiceTemplateStyle.oceanProfessional, primaryColorHex: 0xFF006064,
      accentColorHex: 0xFF00474B, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Ocean Professional', templateGroup: 'Corporate', templateDescription: 'Deep ocean teal with double border',
      layoutVariant: PdfLayoutVariant.doubleBorder),

    PdfTemplateConfig(style: InvoiceTemplateStyle.royalBlue, primaryColorHex: 0xFF3F51B5,
      accentColorHex: 0xFF303F9F, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Royal Blue', templateGroup: 'Corporate', templateDescription: 'Classic royal blue standard invoice',
      layoutVariant: PdfLayoutVariant.singleBorder),

    PdfTemplateConfig(style: InvoiceTemplateStyle.azureMoment, primaryColorHex: 0xFF0288D1,
      accentColorHex: 0xFF0277BD, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: false, showTripDate: true, showRate: true,
      templateName: 'Azure Moment', templateGroup: 'Corporate', templateDescription: 'Light azure with striped table',
      layoutVariant: PdfLayoutVariant.stripedRows),

    // ─── Group 2: Premium ─────────────────────────────────────────────────
    PdfTemplateConfig(style: InvoiceTemplateStyle.goldLuxury, primaryColorHex: 0xFFB8860B,
      accentColorHex: 0xFF9A7209, headerTextColorHex: 0xFF1A1A1A, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Gold Luxury', templateGroup: 'Premium', templateDescription: 'Elegant gold on white — prestige class',
      layoutVariant: PdfLayoutVariant.doubleBorder, showWatermark: false),

    PdfTemplateConfig(style: InvoiceTemplateStyle.emeraldElite, primaryColorHex: 0xFF00695C,
      accentColorHex: 0xFF004D40, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Emerald Elite', templateGroup: 'Premium', templateDescription: 'Rich emerald green premium design',
      layoutVariant: PdfLayoutVariant.headerBand),

    PdfTemplateConfig(style: InvoiceTemplateStyle.rubyPremium, primaryColorHex: 0xFFC62828,
      accentColorHex: 0xFFB71C1C, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Ruby Premium', templateGroup: 'Premium', templateDescription: 'Deep ruby red with striped rows',
      layoutVariant: PdfLayoutVariant.stripedRows),

    PdfTemplateConfig(style: InvoiceTemplateStyle.sapphireBold, primaryColorHex: 0xFF283593,
      accentColorHex: 0xFF1A237E, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Sapphire Bold', templateGroup: 'Premium', templateDescription: 'Bold sapphire blue letterhead style',
      layoutVariant: PdfLayoutVariant.letterheadTop),

    PdfTemplateConfig(style: InvoiceTemplateStyle.onyxDark, primaryColorHex: 0xFF212121,
      accentColorHex: 0xFF000000, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Onyx Dark', templateGroup: 'Premium', templateDescription: 'Premium dark onyx with gold accents',
      layoutVariant: PdfLayoutVariant.doubleBorder),

    // ─── Group 3: Minimal ─────────────────────────────────────────────────
    PdfTemplateConfig(style: InvoiceTemplateStyle.cleanWhite, primaryColorHex: 0xFF9E9E9E,
      accentColorHex: 0xFF757575, headerTextColorHex: 0xFF212121, showVehicleNo: false, showTripDate: true, showRate: true,
      templateName: 'Clean White', templateGroup: 'Minimal', templateDescription: 'Ultra-clean white with grey accents',
      layoutVariant: PdfLayoutVariant.singleBorder),

    PdfTemplateConfig(style: InvoiceTemplateStyle.monoLine, primaryColorHex: 0xFF424242,
      accentColorHex: 0xFF212121, headerTextColorHex: 0xFF000000, showVehicleNo: false, showTripDate: false, showRate: true,
      templateName: 'Mono Line', templateGroup: 'Minimal', templateDescription: 'Monochrome lines only, no fills',
      layoutVariant: PdfLayoutVariant.singleBorder),

    PdfTemplateConfig(style: InvoiceTemplateStyle.pureSimple, primaryColorHex: 0xFF78909C,
      accentColorHex: 0xFF546E7A, headerTextColorHex: 0xFF212121, showVehicleNo: false, showTripDate: false, showRate: false,
      templateName: 'Pure Simple', templateGroup: 'Minimal', templateDescription: 'Absolute minimum — text and amounts only',
      layoutVariant: PdfLayoutVariant.compact),

    PdfTemplateConfig(style: InvoiceTemplateStyle.lightTouch, primaryColorHex: 0xFFB0BEC5,
      accentColorHex: 0xFF90A4AE, headerTextColorHex: 0xFF37474F, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Light Touch', templateGroup: 'Minimal', templateDescription: 'Soft grey light styling',
      layoutVariant: PdfLayoutVariant.headerBand),

    PdfTemplateConfig(style: InvoiceTemplateStyle.ghostGrey, primaryColorHex: 0xFFEEEEEE,
      accentColorHex: 0xFFCFD8DC, headerTextColorHex: 0xFF37474F, showVehicleNo: false, showTripDate: true, showRate: true,
      templateName: 'Ghost Grey', templateGroup: 'Minimal', templateDescription: 'Near-invisible grey — very minimal',
      layoutVariant: PdfLayoutVariant.zebra),

    // ─── Group 4: Bold & Vivid ────────────────────────────────────────────
    PdfTemplateConfig(style: InvoiceTemplateStyle.deepTeal, primaryColorHex: 0xFF00695C,
      accentColorHex: 0xFF004D40, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Deep Teal', templateGroup: 'Bold', templateDescription: 'Bold deep teal with zebra rows',
      layoutVariant: PdfLayoutVariant.zebra),

    PdfTemplateConfig(style: InvoiceTemplateStyle.amberBright, primaryColorHex: 0xFFF57F17,
      accentColorHex: 0xFFE65100, headerTextColorHex: 0xFF212121, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Amber Bright', templateGroup: 'Bold', templateDescription: 'Vibrant amber/orange striped',
      layoutVariant: PdfLayoutVariant.stripedRows),

    PdfTemplateConfig(style: InvoiceTemplateStyle.coralFire, primaryColorHex: 0xFFE64A19,
      accentColorHex: 0xFFBF360C, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Coral Fire', templateGroup: 'Bold', templateDescription: 'Coral-red with bold header band',
      layoutVariant: PdfLayoutVariant.headerBand),

    PdfTemplateConfig(style: InvoiceTemplateStyle.forestGreen, primaryColorHex: 0xFF388E3C,
      accentColorHex: 0xFF2E7D32, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Forest Green', templateGroup: 'Bold', templateDescription: 'Crisp forest green professional',
      layoutVariant: PdfLayoutVariant.singleBorder),

    PdfTemplateConfig(style: InvoiceTemplateStyle.indigoPop, primaryColorHex: 0xFF512DA8,
      accentColorHex: 0xFF4527A0, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Indigo Pop', templateGroup: 'Bold', templateDescription: 'Deep purple-indigo with double border',
      layoutVariant: PdfLayoutVariant.doubleBorder),

    // ─── Group 5: Classic ─────────────────────────────────────────────────
    PdfTemplateConfig(style: InvoiceTemplateStyle.traditionalBlack, primaryColorHex: 0xFF000000,
      accentColorHex: 0xFF212121, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Traditional Black', templateGroup: 'Classic', templateDescription: 'Timeless black and white invoice',
      layoutVariant: PdfLayoutVariant.doubleBorder),

    PdfTemplateConfig(style: InvoiceTemplateStyle.vintageSepia, primaryColorHex: 0xFF6D4C41,
      accentColorHex: 0xFF4E342E, headerTextColorHex: 0xFFFFF8E1, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Vintage Sepia', templateGroup: 'Classic', templateDescription: 'Warm sepia tones — classic charm',
      layoutVariant: PdfLayoutVariant.singleBorder),

    PdfTemplateConfig(style: InvoiceTemplateStyle.oldLedger, primaryColorHex: 0xFF5D4037,
      accentColorHex: 0xFF4E342E, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Old Ledger', templateGroup: 'Classic', templateDescription: 'Ledger-book accounting style',
      layoutVariant: PdfLayoutVariant.singleBorder),

    PdfTemplateConfig(style: InvoiceTemplateStyle.bankerStyle, primaryColorHex: 0xFF37474F,
      accentColorHex: 0xFF263238, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: false, showTripDate: true, showRate: true,
      templateName: 'Banker Style', templateGroup: 'Classic', templateDescription: 'Conservative banking-style invoice',
      layoutVariant: PdfLayoutVariant.compact),

    PdfTemplateConfig(style: InvoiceTemplateStyle.heritage, primaryColorHex: 0xFF4A148C,
      accentColorHex: 0xFF38006B, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Heritage', templateGroup: 'Classic', templateDescription: 'Deep purple heritage style',
      layoutVariant: PdfLayoutVariant.doubleBorder),

    // ─── Group 6: Transport / Industry ───────────────────────────────────
    PdfTemplateConfig(style: InvoiceTemplateStyle.fleetBlue, primaryColorHex: 0xFF1565C0,
      accentColorHex: 0xFF0D47A1, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Fleet Blue', templateGroup: 'Transport', templateDescription: 'Fleet management blue — shows vehicle & trip date',
      layoutVariant: PdfLayoutVariant.headerBand),

    PdfTemplateConfig(style: InvoiceTemplateStyle.logisticsOrange, primaryColorHex: 0xFFE65100,
      accentColorHex: 0xFFBF360C, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Logistics Orange', templateGroup: 'Transport', templateDescription: 'Bold orange for logistics companies',
      layoutVariant: PdfLayoutVariant.stripedRows),

    PdfTemplateConfig(style: InvoiceTemplateStyle.roadGrey, primaryColorHex: 0xFF616161,
      accentColorHex: 0xFF424242, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Road Grey', templateGroup: 'Transport', templateDescription: 'Sturdy grey transport invoice',
      layoutVariant: PdfLayoutVariant.singleBorder),

    PdfTemplateConfig(style: InvoiceTemplateStyle.cargoDark, primaryColorHex: 0xFF263238,
      accentColorHex: 0xFF1C262B, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Cargo Dark', templateGroup: 'Transport', templateDescription: 'Dark freight/cargo industry style',
      layoutVariant: PdfLayoutVariant.headerBand),

    PdfTemplateConfig(style: InvoiceTemplateStyle.expressRed, primaryColorHex: 0xFFD32F2F,
      accentColorHex: 0xFFC62828, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Express Red', templateGroup: 'Transport', templateDescription: 'High-urgency express transport red',
      layoutVariant: PdfLayoutVariant.zebra),

    // ─── Group 7: GST-Focused ─────────────────────────────────────────────
    PdfTemplateConfig(style: InvoiceTemplateStyle.gstStandard, primaryColorHex: 0xFF1B5E20,
      accentColorHex: 0xFF155215, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'GST Standard', templateGroup: 'GST Focus', templateDescription: 'CGST/SGST breakdown visible, standard layout',
      layoutVariant: PdfLayoutVariant.gstCompliant),

    PdfTemplateConfig(style: InvoiceTemplateStyle.gstCompact, primaryColorHex: 0xFF2E7D32,
      accentColorHex: 0xFF1B5E20, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: false, showTripDate: false, showRate: true,
      templateName: 'GST Compact', templateGroup: 'GST Focus', templateDescription: 'Single-page compact GST invoice',
      layoutVariant: PdfLayoutVariant.compact),

    PdfTemplateConfig(style: InvoiceTemplateStyle.gstMultiRate, primaryColorHex: 0xFF00600F,
      accentColorHex: 0xFF004D00, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'GST Multi-Rate', templateGroup: 'GST Focus', templateDescription: 'Multiple tax rate columns support',
      layoutVariant: PdfLayoutVariant.gstCompliant),

    PdfTemplateConfig(style: InvoiceTemplateStyle.gstExport, primaryColorHex: 0xFF01579B,
      accentColorHex: 0xFF01427A, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'GST Export', templateGroup: 'GST Focus', templateDescription: 'Export invoice with LUT/Bond number field',
      layoutVariant: PdfLayoutVariant.gstCompliant),

    PdfTemplateConfig(style: InvoiceTemplateStyle.gstService, primaryColorHex: 0xFF006064,
      accentColorHex: 0xFF004D52, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: false, showTripDate: false, showRate: true,
      templateName: 'GST Service', templateGroup: 'GST Focus', templateDescription: 'Service industry GST tax invoice',
      layoutVariant: PdfLayoutVariant.headerBand),

    // ─── Group 8: Summary Bills ───────────────────────────────────────────
    PdfTemplateConfig(style: InvoiceTemplateStyle.summaryClassic, primaryColorHex: 0xFF37474F,
      accentColorHex: 0xFF263238, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Summary Classic', templateGroup: 'Summary', templateDescription: 'Classic style for summary bill PDFs',
      layoutVariant: PdfLayoutVariant.singleBorder),

    PdfTemplateConfig(style: InvoiceTemplateStyle.summaryModern, primaryColorHex: 0xFF1A73E8,
      accentColorHex: 0xFF1565C0, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Summary Modern', templateGroup: 'Summary', templateDescription: 'Modern blue summary invoice style',
      layoutVariant: PdfLayoutVariant.headerBand),

    PdfTemplateConfig(style: InvoiceTemplateStyle.summaryPremium, primaryColorHex: 0xFF880E4F,
      accentColorHex: 0xFF6A0040, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Summary Premium', templateGroup: 'Summary', templateDescription: 'Premium magenta summary design',
      layoutVariant: PdfLayoutVariant.doubleBorder),

    PdfTemplateConfig(style: InvoiceTemplateStyle.summaryTally, primaryColorHex: 0xFF1565C0,
      accentColorHex: 0xFF0D47A1, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: false, showTripDate: true, showRate: true,
      templateName: 'Summary Tally', templateGroup: 'Summary', templateDescription: 'Tally-style compact summary',
      layoutVariant: PdfLayoutVariant.compact),

    PdfTemplateConfig(style: InvoiceTemplateStyle.summaryPro, primaryColorHex: 0xFF00695C,
      accentColorHex: 0xFF004D40, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Summary Pro', templateGroup: 'Summary', templateDescription: 'Pro teal for multi-invoice summaries',
      layoutVariant: PdfLayoutVariant.stripedRows),

    // ─── Group 9: Letterhead ──────────────────────────────────────────────
    PdfTemplateConfig(style: InvoiceTemplateStyle.letterheadBlue, primaryColorHex: 0xFF1565C0,
      accentColorHex: 0xFF0D47A1, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Letterhead Blue', templateGroup: 'Letterhead', templateDescription: 'Full letterhead with blue company header',
      layoutVariant: PdfLayoutVariant.letterheadTop, showCompanyLogo: true),

    PdfTemplateConfig(style: InvoiceTemplateStyle.letterheadPro, primaryColorHex: 0xFF212121,
      accentColorHex: 0xFF000000, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Letterhead Pro', templateGroup: 'Letterhead', templateDescription: 'Premium black letterhead style',
      layoutVariant: PdfLayoutVariant.letterheadTop, showCompanyLogo: true),

    PdfTemplateConfig(style: InvoiceTemplateStyle.letterheadMinimal, primaryColorHex: 0xFF9E9E9E,
      accentColorHex: 0xFF757575, headerTextColorHex: 0xFF212121, showVehicleNo: false, showTripDate: true, showRate: true,
      templateName: 'Letterhead Minimal', templateGroup: 'Letterhead', templateDescription: 'Light grey minimal letterhead',
      layoutVariant: PdfLayoutVariant.letterheadTop),

    PdfTemplateConfig(style: InvoiceTemplateStyle.letterheadBold, primaryColorHex: 0xFF6A1B9A,
      accentColorHex: 0xFF4A148C, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Letterhead Bold', templateGroup: 'Letterhead', templateDescription: 'Bold purple letterhead choice',
      layoutVariant: PdfLayoutVariant.letterheadTop, showCompanyLogo: true),

    PdfTemplateConfig(style: InvoiceTemplateStyle.letterheadClean, primaryColorHex: 0xFF00897B,
      accentColorHex: 0xFF00695C, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Letterhead Clean', templateGroup: 'Letterhead', templateDescription: 'Clean teal letterhead design',
      layoutVariant: PdfLayoutVariant.letterheadTop, showCompanyLogo: true),

    // ─── Backward-compat aliases ──────────────────────────────────────────
    PdfTemplateConfig(style: InvoiceTemplateStyle.modern, primaryColorHex: 0xFF1A73E8,
      accentColorHex: 0xFF1565C0, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Modern', templateGroup: 'Corporate', templateDescription: 'Alias for Modern Blue',
      layoutVariant: PdfLayoutVariant.headerBand),

    PdfTemplateConfig(style: InvoiceTemplateStyle.classic, primaryColorHex: 0xFF000000,
      accentColorHex: 0xFF212121, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Classic', templateGroup: 'Classic', templateDescription: 'Classic B&W invoice',
      layoutVariant: PdfLayoutVariant.singleBorder),

    PdfTemplateConfig(style: InvoiceTemplateStyle.compact, primaryColorHex: 0xFF455A64,
      accentColorHex: 0xFF263238, headerTextColorHex: 0xFFFFFFFF, showVehicleNo: false, showTripDate: false, showRate: true,
      templateName: 'Compact', templateGroup: 'Minimal', templateDescription: 'Dense single-page layout',
      layoutVariant: PdfLayoutVariant.compact),

    PdfTemplateConfig(style: InvoiceTemplateStyle.luxury, primaryColorHex: 0xFFB8860B,
      accentColorHex: 0xFF9A7209, headerTextColorHex: 0xFF1A1A1A, showVehicleNo: true, showTripDate: true, showRate: true,
      templateName: 'Luxury', templateGroup: 'Premium', templateDescription: 'Alias for Gold Luxury',
      layoutVariant: PdfLayoutVariant.doubleBorder),

    PdfTemplateConfig(style: InvoiceTemplateStyle.minimalist, primaryColorHex: 0xFF9E9E9E,
      accentColorHex: 0xFF757575, headerTextColorHex: 0xFF212121, showVehicleNo: false, showTripDate: false, showRate: true,
      templateName: 'Minimalist', templateGroup: 'Minimal', templateDescription: 'Alias for Clean White',
      layoutVariant: PdfLayoutVariant.singleBorder),
  ];

  static List<String> get templateGroups =>
      allTemplates.map((t) => t.templateGroup).toSet().toList();

  static List<PdfTemplateConfig> templatesByGroup(String group) =>
      allTemplates.where((t) => t.templateGroup == group).toList();

  static PdfTemplateConfig? byStyle(InvoiceTemplateStyle style) {
    try { return allTemplates.firstWhere((t) => t.style == style); } catch (_) { return null; }
  }

  PdfTemplateConfig copyWith({
    InvoiceTemplateStyle? style, int? primaryColorHex, bool? showVehicleNo,
    bool? showTripDate, bool? showRate, String? footerText, String? templateName,
    String? templateDescription, String? templateGroup, PdfLayoutVariant? layoutVariant,
    int? accentColorHex, int? headerTextColorHex, bool? showWatermark, bool? showCompanyLogo,
  }) {
    return PdfTemplateConfig(
      style: style ?? this.style, primaryColorHex: primaryColorHex ?? this.primaryColorHex,
      showVehicleNo: showVehicleNo ?? this.showVehicleNo, showTripDate: showTripDate ?? this.showTripDate,
      showRate: showRate ?? this.showRate, footerText: footerText ?? this.footerText,
      templateName: templateName ?? this.templateName, templateDescription: templateDescription ?? this.templateDescription,
      templateGroup: templateGroup ?? this.templateGroup, layoutVariant: layoutVariant ?? this.layoutVariant,
      accentColorHex: accentColorHex ?? this.accentColorHex, headerTextColorHex: headerTextColorHex ?? this.headerTextColorHex,
      showWatermark: showWatermark ?? this.showWatermark, showCompanyLogo: showCompanyLogo ?? this.showCompanyLogo,
    );
  }
}

final pdfTemplateConfigProvider = StateNotifierProvider<PdfTemplateNotifier, PdfTemplateConfig>((ref) {
  return PdfTemplateNotifier();
});

class PdfTemplateNotifier extends StateNotifier<PdfTemplateConfig> {
  PdfTemplateNotifier() : super(PdfTemplateConfig.defaultConfig()) { _load(); }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final styleIndex = prefs.getInt('pdf_template_style') ?? 0;
    if (styleIndex < PdfTemplateConfig.allTemplates.length) {
      state = PdfTemplateConfig.allTemplates[styleIndex];
    }
  }

  Future<void> updateConfig(PdfTemplateConfig config) async {
    state = config;
    final prefs = await SharedPreferences.getInstance();
    final idx = PdfTemplateConfig.allTemplates.indexWhere((t) => t.style == config.style);
    await prefs.setInt('pdf_template_style', idx >= 0 ? idx : 0);
  }
}
