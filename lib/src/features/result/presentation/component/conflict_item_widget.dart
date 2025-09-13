import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/model/contract_analysis_result.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/severity_badge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ConflictItemWidget extends StatelessWidget {
  final ConflictOrContrast conflict;

  const ConflictItemWidget({
    super.key,
    required this.conflict,
  });

  @override
  Widget build(BuildContext context) {
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
}
