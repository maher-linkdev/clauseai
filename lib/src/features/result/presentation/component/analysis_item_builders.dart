import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/core/enum/cap_type_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/likelihood_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/ownership_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/security_type_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/user_requirements_category.dart';
import 'package:deal_insights_assistant/src/features/analytics/data/model/contract_analysis_result_model.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/severity_badge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnalysisItemBuilders {
  static Widget buildObligationItem(Obligation obligation) {
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

  static Widget buildRiskItem(Risk risk) {
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

  static Widget buildPaymentTermItem(PaymentTerm paymentTerm) {
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

  static Widget buildLiabilityItem(Liability liability) {
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

  static Widget buildServiceLevelItem(ServiceLevel serviceLevel) {
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

  static Widget buildIntellectualPropertyItem(IntellectualProperty ip) {
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

  static Widget buildSecurityRequirementItem(SecurityRequirement security) {
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

  static Widget buildUserRequirementItem(UserRequirement userReq) {
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

  static Widget buildConflictItem(ConflictOrContrast conflict) {
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
  static Color _getLikelihoodColor(Likelihood likelihood) {
    switch (likelihood) {
      case Likelihood.low:
        return ColorsPalette.success;
      case Likelihood.medium:
        return ColorsPalette.warning;
      case Likelihood.high:
        return ColorsPalette.error;
    }
  }

  static Color _getCapTypeColor(CapType capType) {
    switch (capType) {
      case CapType.capped:
        return ColorsPalette.success;
      case CapType.uncapped:
        return ColorsPalette.error;
      case CapType.excluded:
        return ColorsPalette.warning;
    }
  }

  static Color _getOwnershipColor(Ownership ownership) {
    switch (ownership) {
      case Ownership.client:
        return ColorsPalette.primary;
      case Ownership.vendor:
        return ColorsPalette.accent;
      case Ownership.shared:
        return ColorsPalette.warning;
    }
  }

  static String _getSecurityTypeDisplayName(SecurityType type) {
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

  static String _getUserRequirementCategoryDisplayName(UserRequirementCategory category) {
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
