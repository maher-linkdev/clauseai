import 'package:flutter/material.dart';
import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';

class LoadingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final String label;
  final bool isLoading;
  final String loadingText;
  final bool isElevated;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const LoadingButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.isLoading = false,
    this.loadingText = "Loading...",
    this.isElevated = true,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
  });

  const LoadingButton.outlined({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
    this.isLoading = false,
    this.loadingText = "Loading...",
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
  }) : isElevated = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isElevated)
          ElevatedButton.icon(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              foregroundColor: foregroundColor,
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: _buildIcon(),
            label: Text(
              isLoading ? '' : label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        else
          OutlinedButton.icon(
            onPressed: isLoading ? null : onPressed,
            style: OutlinedButton.styleFrom(
              foregroundColor: foregroundColor ?? ColorsPalette.primary,
              side: BorderSide(
                color: foregroundColor ?? ColorsPalette.primary,
                width: 2,
              ),
              padding: padding ?? const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: _buildIcon(),
            label: Text(
              isLoading ? '' : label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        
        // Loading text
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: isLoading
              ? Padding(
                  key: const ValueKey('loading'),
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.brightness == Brightness.dark
                                ? ColorsPalette.primaryLight
                                : ColorsPalette.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        loadingText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: ColorsPalette.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('empty')),
        ),
      ],
    );
  }

  Widget _buildIcon() {
    if (isLoading) {
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    return icon;
  }
}