import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/entity/contract_analysis_result_entity.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/animated_circular_percentage.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/severity_badge.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentTermItemWidget extends StatelessWidget {
  final PaymentTermEntity paymentTerm;

  const PaymentTermItemWidget({super.key, required this.paymentTerm});

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(width: 8),
            AnimatedCircularPercentage(
              percentage: paymentTerm.confidence,
              size: 24,
              textStyle: GoogleFonts.lato(fontSize: 8, fontWeight: FontWeight.w600, color: ColorsPalette.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(paymentTerm.text, style: GoogleFonts.lato(fontSize: 14, color: ColorsPalette.textSecondary, height: 1.4)),
        if (paymentTerm.dueInDays != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Due in ${paymentTerm.dueInDays} days • ',
                style: GoogleFonts.lato(fontSize: 12, color: ColorsPalette.textSecondary, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
