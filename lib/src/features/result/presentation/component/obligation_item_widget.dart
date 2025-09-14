import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/entity/contract_analysis_result_entity.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/animated_circular_percentage.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/severity_badge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ObligationItemWidget extends StatelessWidget {
  final ObligationEntity obligation;

  const ObligationItemWidget({super.key, required this.obligation});

  @override
  Widget build(BuildContext context) {
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
            AnimatedCircularPercentage(
              percentage: obligation.confidence,
              size: 24,
              textStyle: GoogleFonts.lato(fontSize: 8, fontWeight: FontWeight.w600, color: ColorsPalette.textSecondary),
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
}
