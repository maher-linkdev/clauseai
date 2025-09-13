import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/logic/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ErrorDisplay extends ConsumerWidget {
  const ErrorDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeStateProvider);
    final homeNotifier = ref.read(homeStateProvider.notifier);
    final theme = Theme.of(context);

    if (!homeState.hasError) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ColorsPalette.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsPalette.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            PhosphorIcons.warning(PhosphorIconsStyle.regular),
            color: ColorsPalette.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              homeState.errorMessage!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: ColorsPalette.error,
              ),
            ),
          ),
          IconButton(
            onPressed: () => homeNotifier.clearError(),
            icon: Icon(
              PhosphorIcons.x(PhosphorIconsStyle.regular),
              color: ColorsPalette.error,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
