import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/model/contract_analysis_result.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/severity_badge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserRequirementItemWidget extends StatelessWidget {
  final UserRequirement userRequirement;

  const UserRequirementItemWidget({
    super.key,
    required this.userRequirement,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SeverityBadge(severity: userRequirement.severity),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: ColorsPalette.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _getUserRequirementCategoryDisplayName(userRequirement.category),
                style: GoogleFonts.lato(fontSize: 10, fontWeight: FontWeight.w600, color: ColorsPalette.accent),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(userRequirement.text, style: GoogleFonts.lato(fontSize: 14, color: ColorsPalette.textSecondary, height: 1.4)),
      ],
    );
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
