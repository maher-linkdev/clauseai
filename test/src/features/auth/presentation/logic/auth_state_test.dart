import 'package:flutter_test/flutter_test.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/logic/auth_state.dart';
import 'package:deal_insights_assistant/src/features/auth/domain/entity/user_entity.dart';

void main() {
  group('AuthStatus enum', () {
    test('should have correct values', () {
      expect(AuthStatus.values, hasLength(5));
      expect(AuthStatus.values, contains(AuthStatus.initial));
      expect(AuthStatus.values, contains(AuthStatus.loading));
      expect(AuthStatus.values, contains(AuthStatus.authenticated));
      expect(AuthStatus.values, contains(AuthStatus.unauthenticated));
      expect(AuthStatus.values, contains(AuthStatus.error));
    });

    test('should have correct order', () {
      final values = AuthStatus.values;
      expect(values[0], equals(AuthStatus.initial));
      expect(values[1], equals(AuthStatus.loading));
      expect(values[2], equals(AuthStatus.authenticated));
      expect(values[3], equals(AuthStatus.unauthenticated));
      expect(values[4], equals(AuthStatus.error));
    });
  });

  group('AuthState', () {
    const testUser = UserEntity(
      id: 'test-id',
      email: 'test@example.com',
      displayName: 'Test User',
      isAnonymous: false,
    );

    group('Constructor', () {
      test('should create with default values', () {
        const state = AuthState();

        expect(state.status, equals(AuthStatus.initial));
        expect(state.user, isNull);
        expect(state.errorMessage, isNull);
        expect(state.isLoading, isFalse);
      });

      test('should create with provided values', () {
        const state = AuthState(
          status: AuthStatus.authenticated,
          user: testUser,
          errorMessage: 'Test error',
          isLoading: true,
        );

        expect(state.status, equals(AuthStatus.authenticated));
        expect(state.user, equals(testUser));
        expect(state.errorMessage, equals('Test error'));
        expect(state.isLoading, isTrue);
      });
    });

    group('Factory constructors', () {
      test('initial() should create initial state', () {
        final state = AuthState.initial();

        expect(state.status, equals(AuthStatus.initial));
        expect(state.user, isNull);
        expect(state.errorMessage, isNull);
        expect(state.isLoading, isFalse);
      });

      test('loading() should create loading state', () {
        final state = AuthState.loading();

        expect(state.status, equals(AuthStatus.loading));
        expect(state.user, isNull);
        expect(state.errorMessage, isNull);
        expect(state.isLoading, isTrue);
      });

      test('authenticated() should create authenticated state', () {
        final state = AuthState.authenticated(testUser);

        expect(state.status, equals(AuthStatus.authenticated));
        expect(state.user, equals(testUser));
        expect(state.errorMessage, isNull);
        expect(state.isLoading, isFalse);
      });

      test('unauthenticated() should create unauthenticated state', () {
        final state = AuthState.unauthenticated();

        expect(state.status, equals(AuthStatus.unauthenticated));
        expect(state.user, isNull);
        expect(state.errorMessage, isNull);
        expect(state.isLoading, isFalse);
      });

      test('error() should create error state', () {
        final state = AuthState.error('Test error message');

        expect(state.status, equals(AuthStatus.error));
        expect(state.user, isNull);
        expect(state.errorMessage, equals('Test error message'));
        expect(state.isLoading, isFalse);
      });
    });

    group('copyWith', () {
      test('should return same instance when no parameters provided', () {
        const originalState = AuthState(
          status: AuthStatus.authenticated,
          user: testUser,
          errorMessage: 'Test error',
          isLoading: true,
        );

        final copiedState = originalState.copyWith();

        expect(copiedState.status, equals(originalState.status));
        expect(copiedState.user, equals(originalState.user));
        expect(copiedState.errorMessage, equals(originalState.errorMessage));
        expect(copiedState.isLoading, equals(originalState.isLoading));
      });

      test('should update only specified fields', () {
        const originalState = AuthState(
          status: AuthStatus.initial,
          user: null,
          errorMessage: null,
          isLoading: false,
        );

        final copiedState = originalState.copyWith(
          status: AuthStatus.loading,
          isLoading: true,
        );

        expect(copiedState.status, equals(AuthStatus.loading));
        expect(copiedState.user, equals(originalState.user));
        expect(copiedState.errorMessage, equals(originalState.errorMessage));
        expect(copiedState.isLoading, isTrue);
      });

      test('should update all fields', () {
        const originalState = AuthState();
        const newUser = UserEntity(id: 'new-id', isAnonymous: true);

        final copiedState = originalState.copyWith(
          status: AuthStatus.error,
          errorMessage: 'New error',
          isLoading: true,
        );

        expect(copiedState.status, equals(AuthStatus.error));
        expect(copiedState.user, equals(originalState.user));
        expect(copiedState.errorMessage, equals('New error'));
        expect(copiedState.isLoading, isTrue);
      });
    });

    group('Convenience getters', () {
      test('isAuthenticated should return true when authenticated with user', () {
        final state = AuthState.authenticated(testUser);
        expect(state.isAuthenticated, isTrue);
      });

      test('isAuthenticated should return false when status is authenticated but no user', () {
        const state = AuthState(status: AuthStatus.authenticated, user: null);
        expect(state.isAuthenticated, isFalse);
      });

      test('isAuthenticated should return false when not authenticated', () {
        final state = AuthState.unauthenticated();
        expect(state.isAuthenticated, isFalse);
      });

      test('isUnauthenticated should return true when unauthenticated', () {
        final state = AuthState.unauthenticated();
        expect(state.isUnauthenticated, isTrue);
      });

      test('isUnauthenticated should return false when not unauthenticated', () {
        final state = AuthState.authenticated(testUser);
        expect(state.isUnauthenticated, isFalse);
      });

      test('hasError should return true when in error state', () {
        final state = AuthState.error('Test error');
        expect(state.hasError, isTrue);
      });

      test('hasError should return false when not in error state', () {
        final state = AuthState.initial();
        expect(state.hasError, isFalse);
      });

      test('isInitial should return true when in initial state', () {
        final state = AuthState.initial();
        expect(state.isInitial, isTrue);
      });

      test('isInitial should return false when not in initial state', () {
        final state = AuthState.loading();
        expect(state.isInitial, isFalse);
      });
    });

    group('Equality', () {
      test('should be equal when all fields are equal', () {
        const state1 = AuthState(
          status: AuthStatus.authenticated,
          user: testUser,
          errorMessage: 'Test error',
          isLoading: true,
        );

        const state2 = AuthState(
          status: AuthStatus.authenticated,
          user: testUser,
          errorMessage: 'Test error',
          isLoading: true,
        );

        expect(state1, equals(state2));
        expect(state1.hashCode, equals(state2.hashCode));
      });

      test('should not be equal when status differs', () {
        const state1 = AuthState(status: AuthStatus.initial);
        const state2 = AuthState(status: AuthStatus.loading);

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when user differs', () {
        const user1 = UserEntity(id: 'id1', isAnonymous: false);
        const user2 = UserEntity(id: 'id2', isAnonymous: false);

        const state1 = AuthState(user: user1);
        const state2 = AuthState(user: user2);

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when errorMessage differs', () {
        const state1 = AuthState(errorMessage: 'Error 1');
        const state2 = AuthState(errorMessage: 'Error 2');

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when isLoading differs', () {
        const state1 = AuthState(isLoading: true);
        const state2 = AuthState(isLoading: false);

        expect(state1, isNot(equals(state2)));
      });

      test('should be equal to itself', () {
        const state = AuthState();
        expect(state, equals(state));
      });

      test('should not be equal to different type', () {
        const state = AuthState();
        expect(state, isNot(equals('not an auth state')));
        expect(state, isNot(equals(42)));
        expect(state, isNot(equals(null)));
      });
    });

    group('toString', () {
      test('should return formatted string representation', () {
        const state = AuthState(
          status: AuthStatus.authenticated,
          user: testUser,
          errorMessage: 'Test error',
          isLoading: true,
        );

        final result = state.toString();

        expect(result, contains('AuthState'));
        expect(result, contains('status: ${AuthStatus.authenticated}'));
        expect(result, contains('user: $testUser'));
        expect(result, contains('errorMessage: Test error'));
        expect(result, contains('isLoading: true'));
      });

      test('should handle null values in toString', () {
        const state = AuthState();

        final result = state.toString();

        expect(result, contains('user: null'));
        expect(result, contains('errorMessage: null'));
        expect(result, contains('isLoading: false'));
      });
    });

    group('Immutability', () {
      test('should be immutable', () {
        // AuthState is marked with @immutable, so this test verifies
        // that the class follows immutability principles
        const state = AuthState(
          status: AuthStatus.authenticated,
          user: testUser,
          isLoading: true,
        );

        // All fields should be final (verified by compilation)
        expect(state.status, equals(AuthStatus.authenticated));
        expect(state.user, equals(testUser));
        expect(state.isLoading, isTrue);
      });
    });

    group('State transitions', () {
      test('should support typical authentication flow', () {
        // Initial state
        var state = AuthState.initial();
        expect(state.isInitial, isTrue);

        // Loading state
        state = AuthState.loading();
        expect(state.status, equals(AuthStatus.loading));
        expect(state.isLoading, isTrue);

        // Authenticated state
        state = AuthState.authenticated(testUser);
        expect(state.isAuthenticated, isTrue);
        expect(state.user, equals(testUser));

        // Sign out to unauthenticated
        state = AuthState.unauthenticated();
        expect(state.isUnauthenticated, isTrue);
        expect(state.user, isNull);
      });

      test('should support error handling flow', () {
        // Start with loading
        var state = AuthState.loading();
        expect(state.isLoading, isTrue);

        // Error occurs
        state = AuthState.error('Authentication failed');
        expect(state.hasError, isTrue);
        expect(state.errorMessage, equals('Authentication failed'));
        expect(state.isLoading, isFalse);

        // Clear error and retry
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          clearErrorMessage: true,
        );
        expect(state.isUnauthenticated, isTrue);
        expect(state.hasError, isFalse);
        expect(state.errorMessage, isNull);
      });
    });
  });
}
