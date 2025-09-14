import 'package:deal_insights_assistant/src/features/auth/domain/entity/user_entity.dart';
import 'package:flutter/foundation.dart';

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

@immutable
class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final bool isLoading;

  const AuthState({this.status = AuthStatus.initial, this.user, this.errorMessage, this.isLoading = false});

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
    bool? isLoading,
    bool clearErrorMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      isLoading: isLoading ?? this.isLoading,
    );
  }

  // Factory constructors for common states
  factory AuthState.initial() {
    return const AuthState(status: AuthStatus.initial);
  }

  factory AuthState.loading() {
    return const AuthState(status: AuthStatus.loading, isLoading: true);
  }

  factory AuthState.authenticated(UserEntity user) {
    return AuthState(status: AuthStatus.authenticated, user: user, isLoading: false);
  }

  factory AuthState.unauthenticated() {
    return const AuthState(status: AuthStatus.unauthenticated, user: null, isLoading: false);
  }

  factory AuthState.error(String message) {
    return AuthState(status: AuthStatus.error, errorMessage: message, isLoading: false);
  }

  // Convenience getters
  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;

  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  bool get hasError => status == AuthStatus.error;

  bool get isInitial => status == AuthStatus.initial;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthState &&
        other.status == status &&
        other.user == user &&
        other.errorMessage == errorMessage &&
        other.isLoading == isLoading;
  }

  @override
  int get hashCode {
    return Object.hash(status, user, errorMessage, isLoading);
  }

  @override
  String toString() {
    return 'AuthState(status: $status, user: $user, errorMessage: $errorMessage, isLoading: $isLoading)';
  }
}
