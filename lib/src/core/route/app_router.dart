import 'package:deal_insights_assistant/src/core/enum/slide_direction_enum.dart';
import 'package:deal_insights_assistant/src/core/utils/animation_util.dart';
import 'package:deal_insights_assistant/src/features/analytics/data/model/contract_analysis_result_model.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/logic/auth_provider.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/pages/login_page.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/page/home_page.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/page/result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  final Ref ref;

  AppRouter(this.ref);

  /// The redirect logic for the application.
  /// This handles authentication-based navigation and ensures proper route replacement.
  String? redirect(BuildContext context, GoRouterState state) {
    final authState = ref.watch(authStateProvider);
    final isAuthenticated = authState.isAuthenticated;
    final isLoggingIn = state.matchedLocation == LoginPage.routeName;

    // If user is not authenticated and is not already on the login page,
    // redirect them to the login page (this replaces the current route)
    if (!isAuthenticated && !isLoggingIn) {
      return LoginPage.routeName;
    }

    // If the user is authenticated and tries to go to the login page,
    // redirect them to the home page (this replaces the current route)
    if (isAuthenticated && isLoggingIn) {
      return HomePage.routeName;
    }

    // In all other cases, no redirect is necessary
    return null;
  }

  /// The list of routes for the application.
  List<GoRoute> get routes => [
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
      name: ResultPage.routeName,
      path: ResultPage.routeName,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra == null) {
          return _buildPageWithTransition<void>(
            context: context,
            state: state,
            child: const HomePage(),
            name: HomePage.routeName,
            fadeIn: true,
          );
        }

        final contractAnalysisResultData = extra['contractAnalysisResult'];
        final ContractAnalysisResultModel contractAnalysisResult;

        if (contractAnalysisResultData is ContractAnalysisResultModel) {
          contractAnalysisResult = contractAnalysisResultData;
        } else if (contractAnalysisResultData is Map<String, dynamic>) {
          contractAnalysisResult = ContractAnalysisResultModel.fromJson(contractAnalysisResultData);
        } else {
          return _buildPageWithTransition<void>(
            context: context,
            state: state,
            child: const HomePage(),
            name: HomePage.routeName,
            fadeIn: true,
          );
        }

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
          name: ResultPage.routeName,
          fadeIn: true,
        );
      },
    ),
  ];

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
