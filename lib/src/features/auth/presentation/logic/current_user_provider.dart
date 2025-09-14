import 'package:deal_insights_assistant/src/features/auth/domain/entity/user_entity.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/logic/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider = Provider<UserEntity?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.user;
});
