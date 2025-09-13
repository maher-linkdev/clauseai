import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';

class ResultHeader extends StatelessWidget {
  final String? fileName;
  final VoidCallback onBackPressed;
  final VoidCallback onNewAnalysis;

  const ResultHeader({
    super.key,
    this.fileName,
    required this.onBackPressed,
    required this.onNewAnalysis,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? ColorsPalette.surfaceLight,
        border: Border(
          bottom: BorderSide(color: ColorsPalette.grey300),
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: onBackPressed,
            icon: Icon(
              PhosphorIcons.arrowLeft(),
              color: ColorsPalette.textPrimary,
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: ColorsPalette.backgroundLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
                side: BorderSide(color: ColorsPalette.grey300),
              ),
              padding: const EdgeInsets.all(12),
            ),
          ),

          const SizedBox(width: 16),

          // Title and file name
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contract Analysis Results',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: ColorsPalette.textPrimary,
                  ),
                ),
                if (fileName != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        PhosphorIcons.file(),
                        size: 14,
                        color: ColorsPalette.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          fileName!,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: ColorsPalette.textSecondary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          // New analysis button
          ElevatedButton.icon(
            onPressed: onNewAnalysis,
            icon: Icon(
              PhosphorIcons.plus(),
              size: 16,
            ),
            label: Text(
              'New Analysis',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsPalette.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
