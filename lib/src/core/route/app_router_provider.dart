import 'package:deal_insights_assistant/src/core/route/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//provider holds GoRouter obj.
final routerProvider = Provider<GoRouter>((ref) {
  final appRouter = AppRouter(ref);
  return appRouter.getRoutes();
});
