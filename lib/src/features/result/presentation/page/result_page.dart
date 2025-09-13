import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

import '../../../analytics/domain/model/contract_analysis_result.dart';
import '../component/analysis_section.dart';
import '../component/result_header.dart';
import '../component/severity_badge.dart';

class ResultPage extends ConsumerWidget {
  static const String routeName = '/result';

  final ContractAnalysisResult contractAnalysisResult;
  final String extractedText;
  final String? fileName;

  const ResultPage({super.key, required this.contractAnalysisResult, required this.extractedText, this.fileName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: ColorsPalette.background,
      body: SafeArea(
        child: ResponsiveScaledBox(
          width: ResponsiveValue<double>(
            context,
            conditionalValues: [
              const Condition.equals(name: MOBILE, value: 375),
              const Condition.equals(name: TABLET, value: 768),
              const Condition.equals(name: DESKTOP, value: 1440),
            ],
          ).value,
          child: Column(
            children: [
              // Header
              ResultHeader(
                fileName: fileName,
                onBackPressed: () => context.pop(),
                onNewAnalysis: () => context.pushReplacementNamed('home'),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Cards
                      _buildSummaryCards(),

                      const SizedBox(height: 32),

                      // Analysis Sections
                      _buildAnalysisSections(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final totalItems = _getTotalItemsCount();
    final highSeverityItems = _getHighSeverityItemsCount();
    final averageConfidence = _getAverageConfidence();

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard('Total Items', totalItems.toString(), PhosphorIcons.listChecks(), ColorsPalette.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard(
            'High Priority',
            highSeverityItems.toString(),
            PhosphorIcons.warning(),
            ColorsPalette.error,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorsPalette.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsPalette.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w500, color: ColorsPalette.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold, color: ColorsPalette.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (contractAnalysisResult.obligations?.isNotEmpty ?? false)
          AnalysisSection<Obligation>(
            title: 'Obligations',
            icon: PhosphorIcons.userCheck(),
            items: contractAnalysisResult.obligations!,
            itemBuilder: (obligation) => _buildObligationItem(obligation),
          ),

        if (contractAnalysisResult.risks?.isNotEmpty ?? false)
          AnalysisSection<Risk>(
            title: 'Risks',
            icon: PhosphorIcons.warning(),
            items: contractAnalysisResult.risks!,
            itemBuilder: (risk) => _buildRiskItem(risk),
          ),

        if (contractAnalysisResult.paymentTerms?.isNotEmpty ?? false)
          AnalysisSection<PaymentTerm>(
            title: 'Payment Terms',
            icon: PhosphorIcons.currencyDollar(),
            items: contractAnalysisResult.paymentTerms!,
            itemBuilder: (paymentTerm) => _buildPaymentTermItem(paymentTerm),
          ),

        if (contractAnalysisResult.liabilities?.isNotEmpty ?? false)
          AnalysisSection<Liability>(
            title: 'Liabilities',
            icon: PhosphorIcons.shield(),
            items: contractAnalysisResult.liabilities!,
            itemBuilder: (liability) => _buildLiabilityItem(liability),
          ),

        if (contractAnalysisResult.serviceLevels?.isNotEmpty ?? false)
          AnalysisSection<ServiceLevel>(
            title: 'Service Levels',
            icon: PhosphorIcons.chartBar(),
            items: contractAnalysisResult.serviceLevels!,
            itemBuilder: (serviceLevel) => _buildServiceLevelItem(serviceLevel),
          ),

        if (contractAnalysisResult.intellectualProperty?.isNotEmpty ?? false)
          AnalysisSection<IntellectualProperty>(
            title: 'Intellectual Property',
            icon: PhosphorIcons.copyright(),
            items: contractAnalysisResult.intellectualProperty!,
            itemBuilder: (ip) => _buildIntellectualPropertyItem(ip),
          ),

        if (contractAnalysisResult.securityRequirements?.isNotEmpty ?? false)
          AnalysisSection<SecurityRequirement>(
            title: 'Security Requirements',
            icon: PhosphorIcons.lock(),
            items: contractAnalysisResult.securityRequirements!,
            itemBuilder: (security) => _buildSecurityRequirementItem(security),
          ),

        if (contractAnalysisResult.userRequirements?.isNotEmpty ?? false)
          AnalysisSection<UserRequirement>(
            title: 'User Requirements',
            icon: PhosphorIcons.user(),
            items: contractAnalysisResult.userRequirements!,
            itemBuilder: (userReq) => _buildUserRequirementItem(userReq),
          ),

        if (contractAnalysisResult.conflictsOrContrasts?.isNotEmpty ?? false)
          AnalysisSection<ConflictOrContrast>(
            title: 'Conflicts & Contrasts',
            icon: PhosphorIcons.warning(),
            items: contractAnalysisResult.conflictsOrContrasts!,
            itemBuilder: (conflict) => _buildConflictItem(conflict),
          ),
      ],
    );
  }

  Widget _buildObligationItem(Obligation obligation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SeverityBadge(severity: obligation.severity),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                obligation.party,
                style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600, color: ColorsPalette.textPrimary),
              ),
            ),
            Text(
              '${(obligation.confidence * 100).toInt()}%',
              style: GoogleFonts.lato(fontSize: 12, color: ColorsPalette.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(obligation.text, style: GoogleFonts.lato(fontSize: 14, color: ColorsPalette.textSecondary, height: 1.4)),
        if (obligation.timeframe != null) ...[
          const SizedBox(height: 4),
          Text(
            'Timeframe: ${obligation.timeframe}',
            style: GoogleFonts.lato(fontSize: 12, color: ColorsPalette.textSecondary, fontStyle: FontStyle.italic),
          ),
        ],
      ],
    );
  }

  Widget _buildRiskItem(Risk risk) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SeverityBadge(severity: risk.severity),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getLikelihoodColor(risk.likelihood).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                risk.likelihood.name.toUpperCase(),
                style: GoogleFonts.lato(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _getLikelihoodColor(risk.likelihood),
                ),
              ),
            ),
            const Spacer(),
            Text(
              'Score: ${risk.riskScore}',
              style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w600, color: ColorsPalette.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(risk.text, style: GoogleFonts.lato(fontSize: 14, color: ColorsPalette.textSecondary, height: 1.4)),
        const SizedBox(height: 4),
        Text(
          'Category: ${risk.category.name} • Confidence: ${(risk.confidence * 100).toInt()}%',
          style: GoogleFonts.lato(fontSize: 12, color: ColorsPalette.textSecondary, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _buildPaymentTermItem(PaymentTerm paymentTerm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SeverityBadge(severity: paymentTerm.severity),
            const Spacer(),
            if (paymentTerm.amount != null && paymentTerm.currency != null)
              Text(
                '${paymentTerm.currency} ${paymentTerm.amount?.toStringAsFixed(2)}',
                style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600, color: ColorsPalette.textPrimary),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(paymentTerm.text, style: GoogleFonts.lato(fontSize: 14, color: ColorsPalette.textSecondary, height: 1.4)),
        if (paymentTerm.dueInDays != null) ...[
          const SizedBox(height: 4),
          Text(
            'Due in ${paymentTerm.dueInDays} days • Confidence: ${(paymentTerm.confidence * 100).toInt()}%',
            style: GoogleFonts.lato(fontSize: 12, color: ColorsPalette.textSecondary, fontStyle: FontStyle.italic),
          ),
        ],
      ],
    );
  }

  Widget _buildLiabilityItem(Liability liability) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SeverityBadge(severity: liability.severity),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getCapTypeColor(liability.capType).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                liability.capType.name.toUpperCase(),
                style: GoogleFonts.lato(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _getCapTypeColor(liability.capType),
                ),
              ),
            ),
            const Spacer(),
            Text(
              liability.party,
              style: GoogleFonts.lato(fontSize: 12, fontWeight: FontWeight.w600, color: ColorsPalette.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(liability.text, style: GoogleFonts.lato(fontSize: 14, color: ColorsPalette.textSecondary, height: 1.4)),
        if (liability.capValue != null) ...[
          const SizedBox(height: 4),
          Text(
            'Cap Value: ${liability.capValue} • Confidence: ${(liability.confidence * 100).toInt()}%',
            style: GoogleFonts.lato(fontSize: 12, color: ColorsPalette.textSecondary, fontStyle: FontStyle.italic),
          ),
        ],
      ],
    );
  }

  Widget _buildServiceLevelItem(ServiceLevel serviceLevel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SeverityBadge(severity: serviceLevel.severity),
            const Spacer(),
            Text(
              serviceLevel.target,
              style: GoogleFonts.lato(fontSize: 14, fontWeight: FontWeight.w600, color: ColorsPalette.textPrimary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(serviceLevel.text, style: GoogleFonts.lato(fontSize: 14, color: ColorsPalette.textSecondary, height: 1.4)),
        const SizedBox(height: 4),
        Text(
          'Metric: ${serviceLevel.metric}',
          style: GoogleFonts.lato(fontSize: 12, color: ColorsPalette.textSecondary, fontStyle: FontStyle.italic),
        ),
      ],
    );
  }

  Widget _buildIntellectualPropertyItem(IntellectualProperty ip) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SeverityBadge(severity: ip.severity),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getOwnershipColor(ip.ownership).withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                ip.ownership.name.toUpperCase(),
                style: GoogleFonts.lato(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: _getOwnershipColor(ip.ownership),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(ip.text, style: GoogleFonts.lato(fontSize: 14, color: ColorsPalette.textSecondary, height: 1.4)),
      ],
    );
  }

  Widget _buildSecurityRequirementItem(SecurityRequirement security) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SeverityBadge(severity: security.severity),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: ColorsPalette.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getSecurityTypeDisplayName(security.type),
                style: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.w600, color: ColorsPalette.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(security.text, style: GoogleFonts.lato(fontSize: 14, color: ColorsPalette.textSecondary, height: 1.4)),
      ],
    );
  }

  Widget _buildUserRequirementItem(UserRequirement userReq) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SeverityBadge(severity: userReq.severity),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: ColorsPalette.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getUserRequirementCategoryDisplayName(userReq.category),
                style: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.w600, color: ColorsPalette.accent),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(userReq.text, style: GoogleFonts.lato(fontSize: 14, color: ColorsPalette.textSecondary, height: 1.4)),
      ],
    );
  }

  Widget _buildConflictItem(ConflictOrContrast conflict) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SeverityBadge(severity: conflict.severity),
        const SizedBox(height: 8),
        Text(conflict.text, style: GoogleFonts.lato(fontSize: 14, color: ColorsPalette.textSecondary, height: 1.4)),
        if (conflict.conflictWith != null) ...[
          const SizedBox(height: 4),
          Text(
            'Conflicts with: ${conflict.conflictWith}',
            style: GoogleFonts.lato(fontSize: 12, color: ColorsPalette.error, fontStyle: FontStyle.italic),
          ),
        ],
      ],
    );
  }

  // Helper methods
  int _getTotalItemsCount() {
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

  int _getHighSeverityItemsCount() {
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

  Color _getLikelihoodColor(Likelihood likelihood) {
    switch (likelihood) {
      case Likelihood.low:
        return ColorsPalette.success;
      case Likelihood.medium:
        return ColorsPalette.warning;
      case Likelihood.high:
        return ColorsPalette.error;
    }
  }

  Color _getCapTypeColor(CapType capType) {
    switch (capType) {
      case CapType.capped:
        return ColorsPalette.success;
      case CapType.uncapped:
        return ColorsPalette.error;
      case CapType.excluded:
        return ColorsPalette.warning;
    }
  }

  Color _getOwnershipColor(Ownership ownership) {
    switch (ownership) {
      case Ownership.client:
        return ColorsPalette.primary;
      case Ownership.vendor:
        return ColorsPalette.accent;
      case Ownership.shared:
        return ColorsPalette.warning;
    }
  }

  String _getSecurityTypeDisplayName(SecurityType type) {
    switch (type) {
      case SecurityType.dataProtection:
        return 'DATA PROTECTION';
      case SecurityType.compliance:
        return 'COMPLIANCE';
      case SecurityType.accessControl:
        return 'ACCESS CONTROL';
      case SecurityType.audit:
        return 'AUDIT';
      case SecurityType.other:
        return 'OTHER';
    }
  }

  String _getUserRequirementCategoryDisplayName(UserRequirementCategory category) {
    switch (category) {
      case UserRequirementCategory.functional:
        return 'FUNCTIONAL';
      case UserRequirementCategory.nonFunctional:
        return 'NON-FUNCTIONAL';
      case UserRequirementCategory.compliance:
        return 'COMPLIANCE';
      case UserRequirementCategory.integration:
        return 'INTEGRATION';
      case UserRequirementCategory.other:
        return 'OTHER';
    }
  }
}
