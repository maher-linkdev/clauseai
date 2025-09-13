import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../analytics/domain/model/contract_analysis_result.dart';

class SeverityBadge extends StatelessWidget {
  final Severity severity;

  const SeverityBadge({
    super.key,
    required this.severity,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getSeverityColor(severity).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: _getSeverityColor(severity).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        severity.name.toUpperCase(),
        style: GoogleFonts.lato(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: _getSeverityColor(severity),
        ),
      ),
    );
  }

  Color _getSeverityColor(Severity severity) {
    switch (severity) {
      case Severity.low:
        return ColorsPalette.success;
      case Severity.medium:
        return ColorsPalette.warning;
      case Severity.high:
        return ColorsPalette.error;
      case Severity.critical:
        return ColorsPalette.error.withRed(200); // Darker red for critical
    }
  }
}
