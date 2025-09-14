import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/core/enum/severity_enum.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../analytics/domain/model/contract_analysis_result_model.dart';

class ResultSummaryCards extends StatelessWidget {
  final ContractAnalysisResult contractAnalysisResult;

  const ResultSummaryCards({super.key, required this.contractAnalysisResult});

  @override
  Widget build(BuildContext context) {
    final totalItems = _getTotalItems();
    final highSeverityItems = _getHighSeverityItems();
    final averageConfidence = _getAverageConfidence();

    return ResponsiveRowColumn(
      layout: ResponsiveBreakpoints.of(context).largerThan(TABLET)
          ? ResponsiveRowColumnType.ROW
          : ResponsiveRowColumnType.COLUMN,
      rowSpacing: 16,
      columnSpacing: 16,
      children: [
        ResponsiveRowColumnItem(
          rowFlex: 1,
          child: _buildSummaryCard(
            'Total Items',
            totalItems.toString(),
            PhosphorIcons.listChecks(),
            ColorsPalette.primary,
          ),
        ),
        ResponsiveRowColumnItem(
          rowFlex: 1,
          child: _buildSummaryCard(
            'High Priority',
            highSeverityItems.toString(),
            PhosphorIcons.warning(),
            ColorsPalette.error,
          ),
        ),
        ResponsiveRowColumnItem(
          rowFlex: 1,
          child: _buildSummaryCard(
            'Avg Confidence',
            '${(averageConfidence * 100).toInt()}%',
            PhosphorIcons.chartLine(),
            ColorsPalette.success,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: ColorsPalette.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorsPalette.border.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(color: ColorsPalette.primary.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: ColorsPalette.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.lato(fontSize: 28, fontWeight: FontWeight.bold, color: ColorsPalette.textPrimary),
          ),
        ],
      ),
    );
  }

  // Helper methods for calculating summary statistics
  int _getTotalItems() {
    int count = 0;
    count += contractAnalysisResult.obligations?.length ?? 0;
    count += contractAnalysisResult.paymentTerms?.length ?? 0;
    count += contractAnalysisResult.liabilities?.length ?? 0;
    count += contractAnalysisResult.risks?.length ?? 0;
    count += contractAnalysisResult.serviceLevels?.length ?? 0;
    count += contractAnalysisResult.intellectualProperty?.length ?? 0;
    count += contractAnalysisResult.securityRequirements?.length ?? 0;
    count += contractAnalysisResult.userRequirements?.length ?? 0;
    count += contractAnalysisResult.conflictsOrContrasts?.length ?? 0;
    return count;
  }

  int _getHighSeverityItems() {
    int count = 0;

    contractAnalysisResult.obligations?.forEach((item) {
      if (item.severity == Severity.high || item.severity == Severity.critical) count++;
    });
    contractAnalysisResult.paymentTerms?.forEach((item) {
      if (item.severity == Severity.high || item.severity == Severity.critical) count++;
    });
    contractAnalysisResult.liabilities?.forEach((item) {
      if (item.severity == Severity.high || item.severity == Severity.critical) count++;
    });
    contractAnalysisResult.risks?.forEach((item) {
      if (item.severity == Severity.high || item.severity == Severity.critical) count++;
    });
    contractAnalysisResult.serviceLevels?.forEach((item) {
      if (item.severity == Severity.high || item.severity == Severity.critical) count++;
    });
    contractAnalysisResult.intellectualProperty?.forEach((item) {
      if (item.severity == Severity.high || item.severity == Severity.critical) count++;
    });
    contractAnalysisResult.securityRequirements?.forEach((item) {
      if (item.severity == Severity.high || item.severity == Severity.critical) count++;
    });
    contractAnalysisResult.userRequirements?.forEach((item) {
      if (item.severity == Severity.high || item.severity == Severity.critical) count++;
    });
    contractAnalysisResult.conflictsOrContrasts?.forEach((item) {
      if (item.severity == Severity.high || item.severity == Severity.critical) count++;
    });

    return count;
  }

  double _getAverageConfidence() {
    double totalConfidence = 0;
    int itemsWithConfidence = 0;

    contractAnalysisResult.obligations?.forEach((item) {
      totalConfidence += item.confidence;
      itemsWithConfidence++;
    });
    contractAnalysisResult.paymentTerms?.forEach((item) {
      totalConfidence += item.confidence;
      itemsWithConfidence++;
    });
    contractAnalysisResult.liabilities?.forEach((item) {
      totalConfidence += item.confidence;
      itemsWithConfidence++;
    });
    contractAnalysisResult.risks?.forEach((item) {
      totalConfidence += item.confidence;
      itemsWithConfidence++;
    });

    return itemsWithConfidence > 0 ? totalConfidence / itemsWithConfidence : 0;
  }
}
