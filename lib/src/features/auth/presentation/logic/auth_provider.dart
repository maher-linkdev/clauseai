import 'package:deal_insights_assistant/src/features/auth/domain/entity/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/logging_service.dart';
import '../../domain/service/auth_service.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState.initial()) {
    _initializeAuthState();
  }

  // Initialize authentication state by listening to auth changes
  void _initializeAuthState() {
    loggingService.methodEntry('AuthNotifier', '_initializeAuthState');

    _authService.authStateChanges.listen(
      (UserEntity? user) {
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = AuthState.unauthenticated();
        }
      },
      onError: (error) {
        loggingService.error('Auth state stream error', error);
        state = AuthState.error('Authentication error occurred');
      },
    );
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      loggingService.methodEntry('AuthNotifier', 'signInWithGoogle');
      state = AuthState.loading();

      final user = await _authService.signInWithGoogle();

      if (user != null) {
        state = AuthState.authenticated(user);
        loggingService.info('Google sign-in completed successfully');
      } else {
        state = AuthState.unauthenticated();
        loggingService.info('Google sign-in was cancelled');
      }
    } catch (error, stackTrace) {
      loggingService.error('Google sign-in failed in provider', error, stackTrace);
      state = AuthState.error(_getErrorMessage(error));
    } finally {
      loggingService.methodExit('AuthNotifier', 'signInWithGoogle');
    }
  }

  // Sign in anonymously
  Future<void> signInAnonymously() async {
    try {
      loggingService.methodEntry('AuthNotifier', 'signInAnonymously');
      state = AuthState.loading();

      final user = await _authService.signInAnonymously();

      if (user != null) {
        state = AuthState.authenticated(user);
        loggingService.info('Anonymous sign-in completed successfully');
      } else {
        state = AuthState.error('Failed to sign in anonymously');
      }
    } catch (error, stackTrace) {
      loggingService.error('Anonymous sign-in failed in provider', error, stackTrace);
      state = AuthState.error(_getErrorMessage(error));
    } finally {
      loggingService.methodExit('AuthNotifier', 'signInAnonymously');
    }
  }

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      loggingService.methodEntry('AuthNotifier', 'signInWithEmailAndPassword', {'email': email});
      state = AuthState.loading();

      final user = await _authService.signInWithEmailAndPassword(email: email, password: password);

      if (user != null) {
        state = AuthState.authenticated(user);
        loggingService.info('Email/password sign-in completed successfully');
      } else {
        state = AuthState.error('Failed to sign in with email and password');
      }
    } catch (error, stackTrace) {
      loggingService.error('Email/password sign-in failed in provider', error, stackTrace);

      if (error is FirebaseAuthException) {
        // For 'invalid-credential' or 'user-not-found', we let the UI decide what to do
        // (e.g., show create account dialog). We rethrow the exception for the UI to catch.
        if (error.code == 'invalid-credential' || error.code == 'user-not-found') {
          state = AuthState.unauthenticated(); // Reset state to allow UI interaction
          rethrow; // Let the UI handle this specific error
        }
      }

      state = AuthState.error(_getErrorMessage(error));
    } finally {
      loggingService.methodExit('AuthNotifier', 'signInWithEmailAndPassword');
    }
  }

  // Create user with email and password
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      loggingService.methodEntry('AuthNotifier', 'createUserWithEmailAndPassword', {
        'email': email,
        'displayName': displayName,
      });
      state = AuthState.loading();

      final user = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );

      if (user != null) {
        state = AuthState.authenticated(user);
        loggingService.info('User creation completed successfully');
      } else {
        state = AuthState.error('Failed to create user account');
      }
    } catch (error, stackTrace) {
      loggingService.error('User creation failed in provider', error, stackTrace);
      state = AuthState.error(_getErrorMessage(error));
    } finally {
      loggingService.methodExit('AuthNotifier', 'createUserWithEmailAndPassword');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      loggingService.methodEntry('AuthNotifier', 'signOut');
      state = AuthState.loading();

      await _authService.signOut();
      state = AuthState.unauthenticated();

      loggingService.info('Sign out completed successfully');
    } catch (error, stackTrace) {
      loggingService.error('Sign out failed in provider', error, stackTrace);
      state = AuthState.error(_getErrorMessage(error));
    } finally {
      loggingService.methodExit('AuthNotifier', 'signOut');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      loggingService.methodEntry('AuthNotifier', 'sendPasswordResetEmail', {'email': email});

      await _authService.sendPasswordResetEmail(email);

      loggingService.info('Password reset email sent successfully');
    } catch (error, stackTrace) {
      loggingService.error('Failed to send password reset email in provider', error, stackTrace);
      state = AuthState.error(_getErrorMessage(error));
    } finally {
      loggingService.methodExit('AuthNotifier', 'sendPasswordResetEmail');
    }
  }

  // Clear error state
  void clearError() {
    if (state.hasError) {
      state = state.copyWith(status: AuthStatus.unauthenticated, errorMessage: null);
    }
  }

  // Get user-friendly error message
  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email address.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'email-already-in-use':
          return 'An account already exists with this email address.';
        case 'weak-password':
          return 'Password is too weak. Please choose a stronger password.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'too-many-requests':
          return 'Too many failed attempts. Please try again later.';
        case 'operation-not-allowed':
          return 'This sign-in method is not enabled. Please contact support.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        default:
          return 'Authentication failed. Please try again.';
      }
    }
    return 'An unexpected error occurred. Please try again.';
  }
}

// Providers

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.read(authServiceProvider);
  return AuthNotifier(authService);
});
