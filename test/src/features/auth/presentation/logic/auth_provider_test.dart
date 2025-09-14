import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/logic/auth_provider.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/logic/auth_state.dart';
import 'package:deal_insights_assistant/src/features/auth/domain/service/auth_service.dart';
import 'package:deal_insights_assistant/src/features/auth/domain/entity/user_entity.dart';
import 'package:deal_insights_assistant/src/features/auth/domain/model/user_model.dart';

// Mock class for AuthService
class MockAuthService extends Mock implements AuthService {}

void main() {
  group('AuthNotifier', () {
    late MockAuthService mockAuthService;
    late AuthNotifier authNotifier;
    late ProviderContainer container;

    setUp(() {
      mockAuthService = MockAuthService();
      
      // Mock the auth state changes stream
      when(() => mockAuthService.authStateChanges).thenAnswer(
        (_) => Stream<UserEntity?>.empty(),
      );
      
      authNotifier = AuthNotifier(mockAuthService);
      
      container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(mockAuthService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('Initial State', () {
      test('should start with initial state', () {
        expect(authNotifier.state.status, equals(AuthStatus.initial));
        expect(authNotifier.state.user, isNull);
        expect(authNotifier.state.errorMessage, isNull);
      });
    });

    group('signInWithGoogle', () {
      test('should update state to loading then authenticated on success', () async {
        // Arrange
        const testUser = UserEntity(id: 'test-id', isAnonymous: false);
        when(() => mockAuthService.signInWithGoogle()).thenAnswer((_) async => testUser);

        // Act
        final future = authNotifier.signInWithGoogle();
        
        // Assert loading state
        expect(authNotifier.state.status, equals(AuthStatus.loading));
        
        await future;
        
        // Assert authenticated state
        expect(authNotifier.state.status, equals(AuthStatus.authenticated));
        expect(authNotifier.state.user, equals(testUser));
        expect(authNotifier.state.errorMessage, isNull);
      });

      test('should update state to unauthenticated when sign in returns null', () async {
        // Arrange
        when(() => mockAuthService.signInWithGoogle()).thenAnswer((_) async => null);

        // Act
        await authNotifier.signInWithGoogle();
        
        // Assert
        expect(authNotifier.state.status, equals(AuthStatus.unauthenticated));
        expect(authNotifier.state.user, isNull);
        expect(authNotifier.state.errorMessage, isNull);
      });

      test('should update state to error on exception', () async {
        // Arrange
        final exception = Exception('Google sign-in failed');
        when(() => mockAuthService.signInWithGoogle()).thenThrow(exception);

        // Act
        await authNotifier.signInWithGoogle();
        
        // Assert
        expect(authNotifier.state.status, equals(AuthStatus.error));
        expect(authNotifier.state.user, isNull);
        expect(authNotifier.state.errorMessage, isNotNull);
      });
    });

    group('signInAnonymously', () {
      test('should update state to authenticated on success', () async {
        // Arrange
        const testUser = UserModel(id: 'anonymous-id', isAnonymous: true);
        when(() => mockAuthService.signInAnonymously()).thenAnswer((_) async => testUser);

        // Act
        await authNotifier.signInAnonymously();
        
        // Assert
        expect(authNotifier.state.status, equals(AuthStatus.authenticated));
        expect(authNotifier.state.user, equals(testUser));
        expect(authNotifier.state.errorMessage, isNull);
      });

      test('should update state to error when sign in returns null', () async {
        // Arrange
        when(() => mockAuthService.signInAnonymously()).thenAnswer((_) async => null);

        // Act
        await authNotifier.signInAnonymously();
        
        // Assert
        expect(authNotifier.state.status, equals(AuthStatus.error));
        expect(authNotifier.state.errorMessage, equals('Failed to sign in anonymously'));
      });

      test('should handle exceptions', () async {
        // Arrange
        final exception = Exception('Anonymous sign-in failed');
        when(() => mockAuthService.signInAnonymously()).thenThrow(exception);

        // Act
        await authNotifier.signInAnonymously();
        
        // Assert
        expect(authNotifier.state.status, equals(AuthStatus.error));
        expect(authNotifier.state.errorMessage, isNotNull);
      });
    });

    group('signInWithEmailAndPassword', () {
      test('should update state to authenticated on success', () async {
        // Arrange
        const testUser = UserEntity(
          id: 'test-id',
          email: 'test@example.com',
          isAnonymous: false,
        );
        when(() => mockAuthService.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        )).thenAnswer((_) async => testUser);

        // Act
        await authNotifier.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        );
        
        // Assert
        expect(authNotifier.state.status, equals(AuthStatus.authenticated));
        expect(authNotifier.state.user, equals(testUser));
        expect(authNotifier.state.errorMessage, isNull);
      });

      test('should handle invalid credentials by rethrowing', () async {
        // Arrange
        final firebaseException = FirebaseAuthException(
          code: 'invalid-credential',
          message: 'Invalid credentials',
        );
        when(() => mockAuthService.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'wrongpassword',
        )).thenThrow(firebaseException);

        // Act & Assert
        expect(
          () => authNotifier.signInWithEmailAndPassword(
            email: 'test@example.com',
            password: 'wrongpassword',
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
        
        expect(authNotifier.state.status, equals(AuthStatus.unauthenticated));
      });

      test('should handle other Firebase exceptions', () async {
        // Arrange
        final firebaseException = FirebaseAuthException(
          code: 'too-many-requests',
          message: 'Too many requests',
        );
        when(() => mockAuthService.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        )).thenThrow(firebaseException);

        // Act
        await authNotifier.signInWithEmailAndPassword(
          email: 'test@example.com',
          password: 'password123',
        );
        
        // Assert
        expect(authNotifier.state.status, equals(AuthStatus.error));
        expect(authNotifier.state.errorMessage, contains('Too many failed attempts'));
      });
    });

    group('createUserWithEmailAndPassword', () {
      test('should update state to authenticated on success', () async {
        // Arrange
        const testUser = UserEntity(
          id: 'new-user-id',
          email: 'newuser@example.com',
          displayName: 'New User',
          isAnonymous: false,
        );
        when(() => mockAuthService.createUserWithEmailAndPassword(
          email: 'newuser@example.com',
          password: 'password123',
          displayName: 'New User',
        )).thenAnswer((_) async => testUser);

        // Act
        await authNotifier.createUserWithEmailAndPassword(
          email: 'newuser@example.com',
          password: 'password123',
          displayName: 'New User',
        );
        
        // Assert
        expect(authNotifier.state.status, equals(AuthStatus.authenticated));
        expect(authNotifier.state.user, equals(testUser));
        expect(authNotifier.state.errorMessage, isNull);
      });

      test('should handle email already in use error', () async {
        // Arrange
        final firebaseException = FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'Email already in use',
        );
        when(() => mockAuthService.createUserWithEmailAndPassword(
          email: 'existing@example.com',
          password: 'password123',
        )).thenThrow(firebaseException);

        // Act
        await authNotifier.createUserWithEmailAndPassword(
          email: 'existing@example.com',
          password: 'password123',
        );
        
        // Assert
        expect(authNotifier.state.status, equals(AuthStatus.error));
        expect(authNotifier.state.errorMessage, contains('already exists'));
      });
    });

    group('signOut', () {
      test('should update state to unauthenticated on success', () async {
        // Arrange
        when(() => mockAuthService.signOut()).thenAnswer((_) async {});

        // Act
        await authNotifier.signOut();
        
        // Assert
        expect(authNotifier.state.status, equals(AuthStatus.unauthenticated));
        expect(authNotifier.state.user, isNull);
        expect(authNotifier.state.errorMessage, isNull);
      });

      test('should handle sign out errors', () async {
        // Arrange
        final exception = Exception('Sign out failed');
        when(() => mockAuthService.signOut()).thenThrow(exception);

        // Act
        await authNotifier.signOut();
        
        // Assert
        expect(authNotifier.state.status, equals(AuthStatus.error));
        expect(authNotifier.state.errorMessage, isNotNull);
      });
    });

    group('sendPasswordResetEmail', () {
      test('should send password reset email successfully', () async {
        // Arrange
        when(() => mockAuthService.sendPasswordResetEmail('test@example.com'))
            .thenAnswer((_) async {});

        // Act
        await authNotifier.sendPasswordResetEmail('test@example.com');
        
        // Assert
        verify(() => mockAuthService.sendPasswordResetEmail('test@example.com')).called(1);
      });

      test('should handle password reset email errors', () async {
        // Arrange
        final exception = Exception('Failed to send email');
        when(() => mockAuthService.sendPasswordResetEmail('test@example.com'))
            .thenThrow(exception);

        // Act
        await authNotifier.sendPasswordResetEmail('test@example.com');
        
        // Assert
        expect(authNotifier.state.status, equals(AuthStatus.error));
        expect(authNotifier.state.errorMessage, isNotNull);
      });
    });

    group('clearError', () {
      test('should clear error state', () {
        // Arrange - Set error state
        authNotifier.state = AuthState.error('Test error');
        
        // Act
        authNotifier.clearError();
        
        // Assert
        expect(authNotifier.state.status, equals(AuthStatus.unauthenticated));
        expect(authNotifier.state.errorMessage, isNull);
      });

      test('should not change state if not in error', () {
        // Arrange - Set authenticated state
        const testUser = UserEntity(id: 'test-id', isAnonymous: false);
        authNotifier.state = AuthState.authenticated(testUser);
        
        // Act
        authNotifier.clearError();
        
        // Assert
        expect(authNotifier.state.status, equals(AuthStatus.authenticated));
        expect(authNotifier.state.user, equals(testUser));
      });
    });

    group('Error Message Handling', () {
      test('should return correct error messages for Firebase exceptions', () async {
        final testCases = {
          'user-not-found': 'No user found with this email address.',
          'wrong-password': 'Incorrect password. Please try again.',
          'email-already-in-use': 'An account already exists with this email address.',
          'weak-password': 'Password is too weak. Please choose a stronger password.',
          'invalid-email': 'Please enter a valid email address.',
          'user-disabled': 'This account has been disabled. Please contact support.',
          'too-many-requests': 'Too many failed attempts. Please try again later.',
          'operation-not-allowed': 'This sign-in method is not enabled. Please contact support.',
          'network-request-failed': 'Network error. Please check your internet connection.',
        };

        for (final entry in testCases.entries) {
          // Arrange
          final firebaseException = FirebaseAuthException(
            code: entry.key,
            message: 'Firebase error',
          );
          when(() => mockAuthService.signInWithGoogle()).thenThrow(firebaseException);

          // Act
          await authNotifier.signInWithGoogle();
          
          // Assert
          expect(authNotifier.state.errorMessage, equals(entry.value));
        }
      });

      test('should return default error message for unknown Firebase exceptions', () async {
        // Arrange
        final firebaseException = FirebaseAuthException(
          code: 'unknown-error',
          message: 'Unknown error',
        );
        when(() => mockAuthService.signInWithGoogle()).thenThrow(firebaseException);

        // Act
        await authNotifier.signInWithGoogle();
        
        // Assert
        expect(authNotifier.state.errorMessage, equals('Authentication failed. Please try again.'));
      });

      test('should return generic error message for non-Firebase exceptions', () async {
        // Arrange
        final exception = Exception('Generic error');
        when(() => mockAuthService.signInWithGoogle()).thenThrow(exception);

        // Act
        await authNotifier.signInWithGoogle();
        
        // Assert
        expect(authNotifier.state.errorMessage, equals('An unexpected error occurred. Please try again.'));
      });
    });

    group('Provider Integration', () {
      test('should create AuthNotifier with authStateProvider', () {
        final notifier = container.read(authStateProvider.notifier);
        expect(notifier, isA<AuthNotifier>());
      });

      test('should provide initial auth state', () {
        final state = container.read(authStateProvider);
        expect(state.status, equals(AuthStatus.initial));
      });
    });
  });
}
