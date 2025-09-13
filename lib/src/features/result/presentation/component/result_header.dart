import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';

class ResultHeader extends StatelessWidget {
  final String? fileName;
  final VoidCallback onBackPressed;
  final VoidCallback onNewAnalysis;
  final bool isDesktop;

  const ResultHeader({
    super.key,
    this.fileName,
    required this.onBackPressed,
    required this.onNewAnalysis,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    if (isDesktop) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ColorsPalette.primary.withOpacity(0.1), ColorsPalette.secondary.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorsPalette.border.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorsPalette.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(PhosphorIcons.fileText(PhosphorIconsStyle.duotone), size: 32, color: ColorsPalette.primary),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contract Analysis Complete',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorsPalette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        fileName ?? 'Document Analysis',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: ColorsPalette.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorsPalette.surface.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorsPalette.border.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(PhosphorIcons.info(PhosphorIconsStyle.regular), size: 20, color: ColorsPalette.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'AI-powered analysis has identified key contract elements. Review each section for detailed insights.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: ColorsPalette.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [ColorsPalette.primary.withOpacity(0.1), ColorsPalette.secondary.withOpacity(0.05)],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: ColorsPalette.border.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: ColorsPalette.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(PhosphorIcons.fileText(PhosphorIconsStyle.duotone), size: 32, color: ColorsPalette.primary),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contract Analysis Complete',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: ColorsPalette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        fileName ?? 'Document Analysis',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: ColorsPalette.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
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
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ColorsPalette.surface.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ColorsPalette.border.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(PhosphorIcons.info(PhosphorIconsStyle.regular), size: 20, color: ColorsPalette.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'AI-powered analysis has identified key contract elements. Review each section for detailed insights.',
                      style: theme.textTheme.bodyMedium?.copyWith(color: ColorsPalette.textSecondary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
}
