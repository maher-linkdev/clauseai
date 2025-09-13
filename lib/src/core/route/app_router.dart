import 'package:deal_insights_assistant/src/core/enum/slide_direction_enum.dart';
import 'package:deal_insights_assistant/src/core/utils/animation_util.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/page/home_page.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/pages/login_page.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/page/result_page.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/model/contract_analysis_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';



final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final Ref<GoRouter> ref;

  AppRouter(this.ref);

  getRoutes() => GoRouter(
    navigatorKey: globalNavigatorKey,
    initialLocation: HomePage.routeName,

    routes: [
      GoRoute(
        name: LoginPage.routeName,
        path: LoginPage.routeName,
        pageBuilder: (context, state) {
          return _buildPageWithTransition<void>(
            context: context,
            state: state,
            child: const LoginPage(),
            name: LoginPage.routeName,
            fadeIn: true,
            transitionDuration: const Duration(milliseconds: 500),
          );
        },
      ),
      GoRoute(
        name: HomePage.routeName,
        path: HomePage.routeName,
        pageBuilder: (context, state) {
          return _buildPageWithTransition<void>(
            context: context,
            state: state,
            child: const HomePage(),
            name: HomePage.routeName,
            fadeIn: true,
            transitionDuration: const Duration(milliseconds: 500),
          );
        },
      ),
      GoRoute(
        name: 'result',
        path: ResultPage.routeName,
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            // If no extra data, redirect to home
            return _buildPageWithTransition<void>(
              context: context,
              state: state,
              child: const HomePage(),
              name: HomePage.routeName,
              fadeIn: true,
              transitionDuration: const Duration(milliseconds: 500),
            );
          }
          
          final contractAnalysisResult = extra['contractAnalysisResult'] as ContractAnalysisResult;
          final extractedText = extra['extractedText'] as String;
          final fileName = extra['fileName'] as String?;
          
          return _buildPageWithTransition<void>(
            context: context,
            state: state,
            child: ResultPage(
              contractAnalysisResult: contractAnalysisResult,
              extractedText: extractedText,
              fileName: fileName,
            ),
            name: 'result',
            fadeIn: true,
            transitionDuration: const Duration(milliseconds: 500),
          );
        },
      ),

    ],
  );

  static CustomTransitionPage _buildPageWithTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
    required String name,
    SlideFromDirection direction = SlideFromDirection.bottom,
    Duration? transitionDuration,
    bool fadeIn = false,
    bool opaque = true,
  }) {
    return CustomTransitionPage<T>(
      key: state.pageKey,
      child: child,
      name: name,
      transitionDuration: transitionDuration ?? const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final transition = SlideTransition(
          position: Tween<Offset>(begin: AnimationUtil.getBeginOffset(direction), end: Offset.zero).animate(animation),
          child: child,
        );
        return fadeIn ? FadeTransition(opacity: animation, child: transition) : transition;
      },
      opaque: opaque,
    );
  }
}
