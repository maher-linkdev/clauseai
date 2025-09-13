import 'dart:io';
import 'dart:typed_data';
import 'package:deal_insights_assistant/src/core/constants/app_constants.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/model/contract_analysis_result.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

// Service provider
final exportServiceProvider = Provider<ExportService>((ref) {
  return ExportService();
});

class ExportService {
  /// Generate and save a professional PDF report of the contract analysis results
  Future<void> exportToPdf({
    required ContractAnalysisResult analysisResult,
    required String? fileName,
    String? extractedText,
  }) async {
    try {
      final pdf = pw.Document();

      // Load custom font for better typography
      final font = await PdfGoogleFonts.latoRegular();
      final fontBold = await PdfGoogleFonts.latoBold();

      // Generate PDF pages
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            _buildHeader(fontBold, fileName),
            pw.SizedBox(height: 20),
            _buildSummarySection(font, fontBold, analysisResult),
            pw.SizedBox(height: 20),
            ..._buildAnalysisSections(font, fontBold, analysisResult),
            pw.SizedBox(height: 20),
            _buildFooter(font),
          ],
        ),
      );

      // Save and open the PDF
      await Printing.layoutPdf(
        onLayout: (format) async => pdf.save(),
        name: 'Contract_Analysis_Report_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );
    } catch (e) {
      throw Exception('Failed to generate PDF: ${e.toString()}');
    }
  }

  /// Build the professional header section
  pw.Widget _buildHeader(pw.Font fontBold, String? fileName) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        gradient: const pw.LinearGradient(
          colors: [PdfColor.fromInt(0xFF2563EB), PdfColor.fromInt(0xFF3B82F6)],
        ),
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            AppConstants.appName,
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 24,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'Contract Analysis Report',
            style: pw.TextStyle(
              font: fontBold,
              fontSize: 18,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            fileName ?? 'Document Analysis',
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Generated on ${DateTime.now().toString().split('.')[0]}',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.white,
            ),
          ),
        ],
      ),
    );
  }

  /// Build the summary statistics section
  pw.Widget _buildSummarySection(pw.Font font, pw.Font fontBold, ContractAnalysisResult result) {
    final totalItems = _getTotalItems(result);
    final highSeverityItems = _getHighSeverityItems(result);
    final averageConfidence = _getAverageConfidence(result);

    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Analysis Summary',
            style: pw.TextStyle(font: fontBold, fontSize: 16),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryCard(font, fontBold, 'Total Items', totalItems.toString()),
              _buildSummaryCard(font, fontBold, 'High Priority', highSeverityItems.toString()),
              _buildSummaryCard(font, fontBold, 'Avg Confidence', '${(averageConfidence * 100).round()}%'),
            ],
          ),
        ],
      ),
    );
  }

  /// Build individual summary cards
  pw.Widget _buildSummaryCard(pw.Font font, pw.Font fontBold, String title, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey300),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            value,
            style: pw.TextStyle(font: fontBold, fontSize: 18, color: PdfColor.fromInt(0xFF2563EB)),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            title,
            style: pw.TextStyle(font: font, fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  /// Build all analysis sections
  List<pw.Widget> _buildAnalysisSections(pw.Font font, pw.Font fontBold, ContractAnalysisResult result) {
    final sections = <pw.Widget>[];

    if (result.obligations?.isNotEmpty == true) {
      sections.add(_buildAnalysisSection(font, fontBold, 'Obligations', result.obligations!));
      sections.add(pw.SizedBox(height: 16));
    }

    if (result.risks?.isNotEmpty == true) {
      sections.add(_buildAnalysisSection(font, fontBold, 'Risks', result.risks!));
      sections.add(pw.SizedBox(height: 16));
    }

    if (result.paymentTerms?.isNotEmpty == true) {
      sections.add(_buildAnalysisSection(font, fontBold, 'Payment Terms', result.paymentTerms!));
      sections.add(pw.SizedBox(height: 16));
    }

    if (result.liabilities?.isNotEmpty == true) {
      sections.add(_buildAnalysisSection(font, fontBold, 'Liabilities', result.liabilities!));
      sections.add(pw.SizedBox(height: 16));
    }

    if (result.serviceLevels?.isNotEmpty == true) {
      sections.add(_buildAnalysisSection(font, fontBold, 'Service Levels', result.serviceLevels!));
      sections.add(pw.SizedBox(height: 16));
    }

    if (result.intellectualProperty?.isNotEmpty == true) {
      sections.add(_buildAnalysisSection(font, fontBold, 'Intellectual Property', result.intellectualProperty!));
      sections.add(pw.SizedBox(height: 16));
    }

    if (result.securityRequirements?.isNotEmpty == true) {
      sections.add(_buildAnalysisSection(font, fontBold, 'Security Requirements', result.securityRequirements!));
      sections.add(pw.SizedBox(height: 16));
    }

    if (result.userRequirements?.isNotEmpty == true) {
      sections.add(_buildAnalysisSection(font, fontBold, 'User Requirements', result.userRequirements!));
      sections.add(pw.SizedBox(height: 16));
    }

    if (result.conflictsOrContrasts?.isNotEmpty == true) {
      sections.add(_buildAnalysisSection(font, fontBold, 'Conflicts & Contrasts', result.conflictsOrContrasts!));
    }

    return sections;
  }

  /// Build individual analysis section
  pw.Widget _buildAnalysisSection(pw.Font font, pw.Font fontBold, String title, List<dynamic> items) {
    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Section header
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromInt(0xFF2563EB).shade(0.1),
              borderRadius: const pw.BorderRadius.only(
                topLeft: pw.Radius.circular(8),
                topRight: pw.Radius.circular(8),
              ),
            ),
            child: pw.Row(
              children: [
                pw.Text(
                  title,
                  style: pw.TextStyle(font: fontBold, fontSize: 14),
                ),
                pw.Spacer(),
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFF2563EB),
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    items.length.toString(),
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 10,
                      color: PdfColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Section items
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            color: PdfColors.white,
            child: pw.Column(
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 8),
                  decoration: pw.BoxDecoration(
                    border: index < items.length - 1
                        ? pw.Border(bottom: pw.BorderSide(color: PdfColors.grey200))
                        : null,
                  ),
                  child: _buildAnalysisItem(font, fontBold, item),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  /// Build analysis item widget for PDF
  pw.Widget _buildAnalysisItem(pw.Font font, pw.Font fontBold, dynamic item) {
    // Determine if the item has a confidence property
    bool hasConfidence = false;
    double confidence = 0.0;
    
    // Check if the item has confidence property
    try {
      if (item is Obligation || item is Risk || item is PaymentTerm || item is Liability) {
        hasConfidence = true;
        confidence = item.confidence;
      }
    } catch (e) {
      hasConfidence = false;
    }

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 8),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildSeverityBadge(font, item.severity),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      item.text ?? 'No description available',
                      style: pw.TextStyle(
                        font: font,
                        fontSize: 10,
                        color: PdfColors.grey800,
                      ),
                    ),
                  ],
                ),
              ),
              // Only show confidence badge if the item has confidence property
              if (hasConfidence) _buildConfidenceBadge(font, confidence),
            ],
          ),
        ],
      ),
    );
  }

  /// Build severity badge
  pw.Widget _buildSeverityBadge(pw.Font font, Severity severity) {
    final severityName = _getSeverityName(severity);
    PdfColor color;

    switch (severityName) {
      case 'LOW':
        color = PdfColor.fromInt(0xFF10B981);
        break;
      case 'MEDIUM':
        color = PdfColor.fromInt(0xFFF59E0B);
        break;
      case 'HIGH':
        color = PdfColor.fromInt(0xFFEF4444);
        break;
      case 'CRITICAL':
        color = PdfColor.fromInt(0xFFDC2626);
        break;
      default:
        color = PdfColors.grey;
    }

    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: pw.BoxDecoration(
        color: color.shade(0.1),
        borderRadius: pw.BorderRadius.circular(4),
        border: pw.Border.all(color: color.shade(0.3)),
      ),
      child: pw.Text(
        severityName,
        style: pw.TextStyle(
          font: font,
          fontSize: 8,
          color: color,
        ),
      ),
    );
  }

  /// Helper method to get severity name as string
  String _getSeverityName(Severity severity) {
    switch (severity) {
      case Severity.low:
        return 'LOW';
      case Severity.medium:
        return 'MEDIUM';
      case Severity.high:
        return 'HIGH';
      case Severity.critical:
        return 'CRITICAL';
    }
  }

  /// Build confidence percentage badge
  pw.Widget _buildConfidenceBadge(pw.Font font, double confidence) {
    final percentage = (confidence * 100).round();
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        '$percentage%',
        style: pw.TextStyle(
          font: font,
          fontSize: 8,
          color: PdfColors.grey700,
        ),
      ),
    );
  }

  /// Build footer section
  pw.Widget _buildFooter(pw.Font font) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Center(
        child: pw.Text(
          'Generated by ${AppConstants.appName} • ${AppConstants.appPracticalName}',
          style: pw.TextStyle(
            font: font,
            fontSize: 8,
            color: PdfColors.grey600,
          ),
        ),
      ),
    );
  }

  // Helper methods for calculations
  int _getTotalItems(ContractAnalysisResult result) {
    return (result.obligations?.length ?? 0) +
           (result.risks?.length ?? 0) +
           (result.paymentTerms?.length ?? 0) +
           (result.liabilities?.length ?? 0) +
           (result.serviceLevels?.length ?? 0) +
           (result.intellectualProperty?.length ?? 0) +
           (result.securityRequirements?.length ?? 0) +
           (result.userRequirements?.length ?? 0) +
           (result.conflictsOrContrasts?.length ?? 0);
  }

  int _getHighSeverityItems(ContractAnalysisResult result) {
    int count = 0;
    result.obligations?.forEach((item) {
      if (item.severity.name == 'high' || item.severity.name == 'critical') count++;
    });
    result.risks?.forEach((item) {
      if (item.severity.name == 'high' || item.severity.name == 'critical') count++;
    });
    result.paymentTerms?.forEach((item) {
      if (item.severity.name == 'high' || item.severity.name == 'critical') count++;
    });
    result.liabilities?.forEach((item) {
      if (item.severity.name == 'high' || item.severity.name == 'critical') count++;
    });
    result.serviceLevels?.forEach((item) {
      if (item.severity.name == 'high' || item.severity.name == 'critical') count++;
    });
    result.intellectualProperty?.forEach((item) {
      if (item.severity.name == 'high' || item.severity.name == 'critical') count++;
    });
    result.securityRequirements?.forEach((item) {
      if (item.severity.name == 'high' || item.severity.name == 'critical') count++;
    });
    result.userRequirements?.forEach((item) {
      if (item.severity.name == 'high' || item.severity.name == 'critical') count++;
    });
    result.conflictsOrContrasts?.forEach((item) {
      if (item.severity.name == 'high' || item.severity.name == 'critical') count++;
    });
    return count;
  }

  double _getAverageConfidence(ContractAnalysisResult result) {
    double totalConfidence = 0.0;
    int totalItems = 0;

    // Only calculate confidence for items that have confidence property
    result.obligations?.forEach((item) {
      totalConfidence += item.confidence;
      totalItems++;
    });
    result.risks?.forEach((item) {
      totalConfidence += item.confidence;
      totalItems++;
    });
    result.paymentTerms?.forEach((item) {
      totalConfidence += item.confidence;
      totalItems++;
    });
    result.liabilities?.forEach((item) {
      totalConfidence += item.confidence;
      totalItems++;
    });
    
    // Skip items without confidence property:
    // - serviceLevels, intellectualProperty, securityRequirements, 
    // - userRequirements, conflictsOrContrasts

    return totalItems > 0 ? totalConfidence / totalItems : 0.0;
  }
}
