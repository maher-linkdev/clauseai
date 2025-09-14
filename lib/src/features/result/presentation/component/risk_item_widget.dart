import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/core/enum/likelihood_enum.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/entity/contract_analysis_result_entity.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/animated_circular_percentage.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/severity_badge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RiskItemWidget extends StatelessWidget {
  final RiskEntity risk;

  const RiskItemWidget({super.key, required this.risk});

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(width: 8),
            AnimatedCircularPercentage(
              percentage: risk.confidence,
              size: 24,
              textStyle: GoogleFonts.lato(fontSize: 8, fontWeight: FontWeight.w600, color: ColorsPalette.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(risk.text, style: GoogleFonts.lato(fontSize: 14, color: ColorsPalette.textSecondary, height: 1.4)),
        const SizedBox(height: 4),
        Text(
          'Category: ${risk.category.name}',
          style: GoogleFonts.lato(fontSize: 12, color: ColorsPalette.textSecondary, fontStyle: FontStyle.italic),
        ),
      ],
    );
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
}
