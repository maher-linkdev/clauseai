import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/model/contract_analysis_result.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/severity_badge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityRequirementItemWidget extends StatelessWidget {
  final SecurityRequirement securityRequirement;

  const SecurityRequirementItemWidget({
    super.key,
    required this.securityRequirement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SeverityBadge(severity: securityRequirement.severity),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: ColorsPalette.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getSecurityTypeDisplayName(securityRequirement.type),
                style: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.w600, color: ColorsPalette.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(securityRequirement.text, style: GoogleFonts.lato(fontSize: 14, color: ColorsPalette.textSecondary, height: 1.4)),
      ],
    );
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
}
