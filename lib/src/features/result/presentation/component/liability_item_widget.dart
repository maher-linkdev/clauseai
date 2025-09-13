import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/model/contract_analysis_result.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/animated_circular_percentage.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/severity_badge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LiabilityItemWidget extends StatelessWidget {
  final Liability liability;

  const LiabilityItemWidget({super.key, required this.liability});

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(width: 8),
            AnimatedCircularPercentage(
              percentage: liability.confidence,
              size: 24,
              textStyle: GoogleFonts.lato(fontSize: 8, fontWeight: FontWeight.w600, color: ColorsPalette.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(liability.text, style: GoogleFonts.lato(fontSize: 14, color: ColorsPalette.textSecondary, height: 1.4)),
        if (liability.capValue != null) ...[
          const SizedBox(height: 4),
          Text(
            'Cap Value: ${liability.capValue}',
            style: GoogleFonts.lato(fontSize: 12, color: ColorsPalette.textSecondary, fontStyle: FontStyle.italic),
          ),
        ],
      ],
    );
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
}
