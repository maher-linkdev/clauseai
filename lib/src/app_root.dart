import 'package:deal_insights_assistant/src/core/constants/app_constants.dart';
import 'package:deal_insights_assistant/src/core/route/app_router_provider.dart';
import 'package:deal_insights_assistant/src/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AppRoot extends ConsumerStatefulWidget {
  const AppRoot({super.key});

  @override
  ConsumerState<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends ConsumerState<AppRoot> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      builder: (context, child) {
        return ResponsiveBreakpoints.builder(
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
          child: Builder(
            builder: (context) {
              return ResponsiveScaledBox(
                width: ResponsiveValue<double>(
                  context,
                  defaultValue: 380,
                  conditionalValues: [
                    const Condition.equals(name: MOBILE, value: 420),
                    const Condition.between(start: 450, end: 800, value: 680),
                    const Condition.between(start: 800, end: 1100, value: 720),
                    const Condition.between(start: 1100, end: 1400, value: 1080),
                    const Condition.largerThan(breakpoint: 1400, value: 1200),
                  ],
                ).value,
                child: child!,
              );
            },
          ),
        );
      },
      routerConfig: ref.watch(routerProvider),
    );
  }
}
