import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/model/contract_analysis_result.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/severity_badge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceLevelItemWidget extends StatelessWidget {
  final ServiceLevel serviceLevel;

  const ServiceLevelItemWidget({
    super.key,
    required this.serviceLevel,
  });

  @override
  Widget build(BuildContext context) {
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
}
