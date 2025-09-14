import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:deal_insights_assistant/src/features/auth/domain/service/auth_service.dart';
import 'package:deal_insights_assistant/src/features/auth/domain/entity/user_entity.dart';

// Mock classes using mocktail
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockUser extends Mock implements User {}
class MockUserCredential extends Mock implements UserCredential {}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {
  @override
  String? get accessToken => super.noSuchMethod(Invocation.getter(#accessToken));
  
  @override
  String? get idToken => super.noSuchMethod(Invocation.getter(#idToken));
}
class MockUserMetadata extends Mock implements UserMetadata {}

void main() {
  group('AuthService', () {
    late AuthService authService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockGoogleSignIn mockGoogleSignIn;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;
    late MockGoogleSignInAccount mockGoogleSignInAccount;
    late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;

    setUpAll(() {
      // Register fallback values for mocktail
      registerFallbackValue(const AuthCredential(providerId: 'test', signInMethod: 'test'));
      registerFallbackValue('');
    });

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockGoogleSignIn = MockGoogleSignIn();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();
      mockGoogleSignInAccount = MockGoogleSignInAccount();
      mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();

      authService = AuthService(
        firebaseAuth: mockFirebaseAuth,
        googleSignIn: mockGoogleSignIn,
      );

      // Setup default mock behaviors
      when(() => mockUser.uid).thenReturn('test-uid');
      when(() => mockUser.email).thenReturn('test@example.com');
      when(() => mockUser.displayName).thenReturn('Test User');
      when(() => mockUser.photoURL).thenReturn('https://example.com/photo.jpg');
      when(() => mockUser.emailVerified).thenReturn(true);
      when(() => mockUser.isAnonymous).thenReturn(false);
      when(() => mockUser.phoneNumber).thenReturn(null);
      when(() => mockUser.metadata).thenReturn(MockUserMetadata());

      when(() => mockUserCredential.user).thenReturn(mockUser);
      when(() => mockGoogleSignIn.initialize(clientId: any(named: 'clientId'))).thenAnswer((_) async {});
      
      // Setup Google Sign-In mocks
      when(() => mockGoogleSignIn.authenticate()).thenAnswer((_) async => mockGoogleSignInAccount);
      when(() => mockGoogleSignInAccount.authentication).thenReturn(mockGoogleSignInAuthentication);
      when(() => mockGoogleSignInAuthentication.accessToken).thenReturn('access-token');
      when(() => mockGoogleSignInAuthentication.idToken).thenReturn('id-token');
      when(() => mockFirebaseAuth.signInWithCredential(any())).thenAnswer((_) async => mockUserCredential);
    });

    group('Constructor', () {
      test('should create AuthService with custom dependencies', () {
        final service = AuthService(
          firebaseAuth: mockFirebaseAuth,
          googleSignIn: mockGoogleSignIn,
        );
        expect(service, isA<AuthService>());
      });
    });

    group('currentUser', () {
      test('should return null when no user is signed in', () {
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        final currentUser = authService.currentUser;

        expect(currentUser, isNull);
      });

      test('should return UserEntity when user is signed in', () {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);

        final currentUser = authService.currentUser;

        expect(currentUser, isA<UserEntity>());
        expect(currentUser?.id, equals('test-uid'));
        expect(currentUser?.email, equals('test@example.com'));
        expect(currentUser?.displayName, equals('Test User'));
      });
    });

    group('signInAnonymously', () {
      test('should sign in anonymously successfully', () async {
        when(() => mockUser.isAnonymous).thenReturn(true);
        when(() => mockFirebaseAuth.signInAnonymously())
            .thenAnswer((_) async => mockUserCredential);

        final result = await authService.signInAnonymously();

        expect(result, isA<UserEntity>());
        expect(result?.id, equals('test-uid'));
        verify(() => mockFirebaseAuth.signInAnonymously()).called(1);
      });

      test('should handle anonymous sign-in failure', () async {
        when(() => mockFirebaseAuth.signInAnonymously())
            .thenThrow(FirebaseAuthException(code: 'operation-not-allowed'));

        expect(
          () => authService.signInAnonymously(),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('should return null when user credential is null', () async {
        when(() => mockUserCredential.user).thenReturn(null);
        when(() => mockFirebaseAuth.signInAnonymously())
            .thenAnswer((_) async => mockUserCredential);

        final result = await authService.signInAnonymously();

        expect(result, isNull);
      });
    });

    group('signInWithEmailAndPassword', () {
      test('should sign in with email and password successfully', () async {
        const email = 'test@example.com';
        const password = 'password123';

        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            )).thenAnswer((_) async => mockUserCredential);

        final result = await authService.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        expect(result, isA<UserEntity>());
        expect(result?.email, equals(email));
        verify(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            )).called(1);
      });

      test('should handle invalid email error', () async {
        const email = 'invalid-email';
        const password = 'password123';

        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            )).thenThrow(FirebaseAuthException(code: 'invalid-email'));

        expect(
          () => authService.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('should handle wrong password error', () async {
        const email = 'test@example.com';
        const password = 'wrong-password';

        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

        expect(
          () => authService.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('should handle user not found error', () async {
        const email = 'nonexistent@example.com';
        const password = 'password123';

        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

        expect(
          () => authService.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('should return null when user credential is null', () async {
        const email = 'test@example.com';
        const password = 'password123';

        when(() => mockUserCredential.user).thenReturn(null);
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            )).thenAnswer((_) async => mockUserCredential);

        final result = await authService.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        expect(result, isNull);
      });
    });

    group('createUserWithEmailAndPassword', () {
      test('should create user with email and password successfully', () async {
        const email = 'newuser@example.com';
        const password = 'password123';
        const displayName = 'New User';

        // Create a separate mock user for this test with the correct email
        final mockNewUser = MockUser();
        final mockNewUserCredential = MockUserCredential();
        
        when(() => mockNewUser.uid).thenReturn('new-test-uid');
        when(() => mockNewUser.email).thenReturn(email);
        when(() => mockNewUser.displayName).thenReturn(displayName);
        when(() => mockNewUser.photoURL).thenReturn(null);
        when(() => mockNewUser.emailVerified).thenReturn(true);
        when(() => mockNewUser.isAnonymous).thenReturn(false);
        when(() => mockNewUser.phoneNumber).thenReturn(null);
        when(() => mockNewUser.metadata).thenReturn(MockUserMetadata());
        when(() => mockNewUser.updateDisplayName(displayName)).thenAnswer((_) async {});
        when(() => mockNewUser.reload()).thenAnswer((_) async {});
        
        when(() => mockNewUserCredential.user).thenReturn(mockNewUser);
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            )).thenAnswer((_) async => mockNewUserCredential);

        final result = await authService.createUserWithEmailAndPassword(
          email: email,
          password: password,
          displayName: displayName,
        );

        expect(result, isA<UserEntity>());
        expect(result?.email, equals(email));
        verify(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            )).called(1);
        verify(() => mockNewUser.updateDisplayName(displayName)).called(1);
        verify(() => mockNewUser.reload()).called(1);
      });

      test('should create user without display name', () async {
        const email = 'newuser@example.com';
        const password = 'password123';

        // Create a separate mock user for this test with the correct email
        final mockNewUser2 = MockUser();
        final mockNewUserCredential2 = MockUserCredential();
        
        when(() => mockNewUser2.uid).thenReturn('new-test-uid-2');
        when(() => mockNewUser2.email).thenReturn(email);
        when(() => mockNewUser2.displayName).thenReturn(null);
        when(() => mockNewUser2.photoURL).thenReturn(null);
        when(() => mockNewUser2.emailVerified).thenReturn(true);
        when(() => mockNewUser2.isAnonymous).thenReturn(false);
        when(() => mockNewUser2.phoneNumber).thenReturn(null);
        when(() => mockNewUser2.metadata).thenReturn(MockUserMetadata());
        
        when(() => mockNewUserCredential2.user).thenReturn(mockNewUser2);
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            )).thenAnswer((_) async => mockNewUserCredential2);

        final result = await authService.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        expect(result, isA<UserEntity>());
        expect(result?.email, equals(email));
        verifyNever(() => mockNewUser2.updateDisplayName(any()));
        verifyNever(() => mockNewUser2.reload());
      });

      test('should handle email already in use error', () async {
        const email = 'existing@example.com';
        const password = 'password123';

        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

        expect(
          () => authService.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('should handle weak password error', () async {
        const email = 'newuser@example.com';
        const password = '123';

        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            )).thenThrow(FirebaseAuthException(code: 'weak-password'));

        expect(
          () => authService.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('should return null when user credential is null', () async {
        const email = 'newuser@example.com';
        const password = 'password123';

        when(() => mockUserCredential.user).thenReturn(null);
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            )).thenAnswer((_) async => mockUserCredential);

        final result = await authService.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        expect(result, isNull);
      });
    });

    group('signOut', () {
      test('should sign out successfully', () async {
        when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        await authService.signOut();

        verify(() => mockFirebaseAuth.signOut()).called(1);
      });

      test('should handle sign out failure', () async {
        when(() => mockFirebaseAuth.signOut())
            .thenThrow(FirebaseAuthException(code: 'network-request-failed'));

        expect(
          () => authService.signOut(),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('should sign out from Google when initialized', () async {
        // First initialize Google Sign-In
        await authService.signInWithGoogle();
        
        when(() => mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        await authService.signOut();

        verify(() => mockGoogleSignIn.signOut()).called(1);
        verify(() => mockFirebaseAuth.signOut()).called(1);
      });
    });

    group('sendPasswordResetEmail', () {
      test('should send password reset email successfully', () async {
        const email = 'test@example.com';

        when(() => mockFirebaseAuth.sendPasswordResetEmail(email: email))
            .thenAnswer((_) async {});

        await authService.sendPasswordResetEmail(email);

        verify(() => mockFirebaseAuth.sendPasswordResetEmail(email: email)).called(1);
      });

      test('should handle invalid email error', () async {
        const email = 'invalid-email';

        when(() => mockFirebaseAuth.sendPasswordResetEmail(email: email))
            .thenThrow(FirebaseAuthException(code: 'invalid-email'));

        expect(
          () => authService.sendPasswordResetEmail(email),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('should handle user not found error', () async {
        const email = 'nonexistent@example.com';

        when(() => mockFirebaseAuth.sendPasswordResetEmail(email: email))
            .thenThrow(FirebaseAuthException(code: 'user-not-found'));

        expect(
          () => authService.sendPasswordResetEmail(email),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('deleteAccount', () {
      test('should delete account successfully', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.delete()).thenAnswer((_) async {});

        await authService.deleteAccount();

        verify(() => mockUser.delete()).called(1);
      });

      test('should handle no current user', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(null);

        await authService.deleteAccount();

        verifyNever(() => mockUser.delete());
      });

      test('should handle delete account failure', () async {
        when(() => mockFirebaseAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.delete())
            .thenThrow(FirebaseAuthException(code: 'requires-recent-login'));

        expect(
          () => authService.deleteAccount(),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('getCurrentGoogleUser', () {
      test('should get current Google user successfully', () async {
        when(() => mockGoogleSignIn.attemptLightweightAuthentication())
            .thenAnswer((_) async => mockGoogleSignInAccount);

        final result = await authService.getCurrentGoogleUser();

        expect(result, equals(mockGoogleSignInAccount));
        verify(() => mockGoogleSignIn.attemptLightweightAuthentication()).called(1);
      });

      test('should return null when no Google user is signed in', () async {
        when(() => mockGoogleSignIn.attemptLightweightAuthentication())
            .thenAnswer((_) async => null);

        final result = await authService.getCurrentGoogleUser();

        expect(result, isNull);
      });

      test('should handle Google Sign-In errors gracefully', () async {
        when(() => mockGoogleSignIn.attemptLightweightAuthentication())
            .thenThrow(Exception('Google Sign-In error'));

        final result = await authService.getCurrentGoogleUser();

        expect(result, isNull);
      });
    });

    group('Error Handling', () {
      test('should handle network errors gracefully', () async {
        const email = 'test@example.com';
        const password = 'password123';

        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            )).thenThrow(FirebaseAuthException(code: 'network-request-failed'));

        expect(
          () => authService.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('should handle too many requests error', () async {
        const email = 'test@example.com';
        const password = 'password123';

        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            )).thenThrow(FirebaseAuthException(code: 'too-many-requests'));

        expect(
          () => authService.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('should handle operation not allowed error', () async {
        when(() => mockFirebaseAuth.signInAnonymously())
            .thenThrow(FirebaseAuthException(code: 'operation-not-allowed'));

        expect(
          () => authService.signInAnonymously(),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('Edge Cases', () {
      test('should handle empty email and password', () async {
        const email = '';
        const password = '';

        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            )).thenThrow(FirebaseAuthException(code: 'invalid-email'));

        expect(
          () => authService.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
          throwsA(isA<FirebaseAuthException>()),
        );
      });

      test('should handle null display name in user creation', () async {
        const email = 'test@example.com';
        const password = 'password123';

        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            )).thenAnswer((_) async => mockUserCredential);

        final result = await authService.createUserWithEmailAndPassword(
          email: email,
          password: password,
          displayName: null,
        );

        expect(result, isA<UserEntity>());
        verifyNever(() => mockUser.updateDisplayName(any()));
      });

      test('should handle empty display name in user creation', () async {
        const email = 'test@example.com';
        const password = 'password123';
        const displayName = '';

        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            )).thenAnswer((_) async => mockUserCredential);
        when(() => mockUser.updateDisplayName(displayName)).thenAnswer((_) async {});
        when(() => mockUser.reload()).thenAnswer((_) async {});

        final result = await authService.createUserWithEmailAndPassword(
          email: email,
          password: password,
          displayName: displayName,
        );

        expect(result, isA<UserEntity>());
        verify(() => mockUser.updateDisplayName(displayName)).called(1);
      });
    });

    group('Integration', () {
      test('should handle complete authentication flow', () async {
        const email = 'test@example.com';
        const password = 'password123';

        // Create user
        when(() => mockFirebaseAuth.createUserWithEmailAndPassword(
              email: email,
              password: password,
            )).thenAnswer((_) async => mockUserCredential);

        final createdUser = await authService.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        expect(createdUser, isA<UserEntity>());

        // Sign out
        when(() => mockFirebaseAuth.signOut()).thenAnswer((_) async {});
        await authService.signOut();

        // Sign in again
        when(() => mockFirebaseAuth.signInWithEmailAndPassword(
              email: email,
              password: password,
            )).thenAnswer((_) async => mockUserCredential);

        final signedInUser = await authService.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        expect(signedInUser, isA<UserEntity>());
        expect(signedInUser?.email, equals(email));
      });
    });
  });
}

