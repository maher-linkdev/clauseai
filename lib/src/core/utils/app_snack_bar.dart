import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:flutter/material.dart';

class AppSnackBar {
  static void show(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          if (icon != null) Icon(icon, color: Colors.white),
          if (icon != null) const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: backgroundColor ?? Theme.of(context).snackBarTheme.backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void success(BuildContext context, String message) {
    show(context, message: message, backgroundColor: ColorsPalette.success, icon: Icons.check_circle);
  }

  static void error(BuildContext context, String message) {
    show(context, message: message, backgroundColor: ColorsPalette.error, icon: Icons.error);
  }

  static void info(BuildContext context, String message) {
    show(context, message: message, backgroundColor: ColorsPalette.info, icon: Icons.info);
  }

  static void warning(BuildContext context, String message) {
    show(context, message: message, backgroundColor: ColorsPalette.warning, icon: Icons.warning);
  }
}
