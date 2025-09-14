import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/logic/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SelectedTextDisplay extends ConsumerWidget {
  const SelectedTextDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeStateProvider);
    final homeNotifier = ref.read(homeStateProvider.notifier);
    final theme = Theme.of(context);

    if (!homeState.hasSelectedText) {
      return const SizedBox.shrink();
    }

    // Get text preview (first 100 characters)
    final textPreview = homeState.selectedText!.length > 100 
        ? '${homeState.selectedText!.substring(0, 100)}...'
        : homeState.selectedText!;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              PhosphorIcons.textAa(PhosphorIconsStyle.bold), 
              size: 64, 
              color: ColorsPalette.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Contract Text Ready',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColorsPalette.grey100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                textPreview,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: ColorsPalette.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${homeState.selectedText!.length} characters',
              style: theme.textTheme.bodySmall?.copyWith(color: ColorsPalette.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              homeState.isProcessing
                  ? 'Analyzing...'
                  : homeState.uploadStatus.name == 'completed'
                  ? 'Analysis completed'
                  : 'Ready to analyze',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: homeState.isProcessing
                    ? ColorsPalette.primary
                    : homeState.uploadStatus.name == 'completed'
                    ? ColorsPalette.success
                    : ColorsPalette.success,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton.icon(
                  onPressed: homeState.isAnalyzing ? null : () => homeNotifier.clearSelection(),
                  icon: Icon(PhosphorIcons.x(PhosphorIconsStyle.regular), size: 20),
                  label: const Text('Remove'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: homeState.isProcessing ? null : () => homeNotifier.analyzeDocument(GoRouter.of(context)),
                  icon: homeState.isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(PhosphorIcons.magnifyingGlass(PhosphorIconsStyle.regular), size: 20),
                  label: Text(homeState.isProcessing ? 'Analyzing...' : 'Analyze Text'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}