import 'package:deal_insights_assistant/src/core/route/app_router.dart';
import 'package:deal_insights_assistant/src/core/route/router_refresh_stream.dart';
import 'package:deal_insights_assistant/src/features/auth/domain/service/auth_service.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//provider holds GoRouter obj.
final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.read(authServiceProvider);
  final appRouter = AppRouter(ref);

  return GoRouter(
    navigatorKey: globalNavigatorKey,
    initialLocation: LoginPage.routeName,
    // This listenable will automatically trigger the redirect function
    // whenever the user's authentication state changes, ensuring proper route replacement
    refreshListenable: GoRouterRefreshStream(authService.authStateChanges),
    redirect: appRouter.redirect,
    routes: appRouter.routes,
  );
});
