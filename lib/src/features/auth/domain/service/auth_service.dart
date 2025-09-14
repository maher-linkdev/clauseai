import 'package:deal_insights_assistant/src/features/auth/domain/entity/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/services/logging_service.dart';
import '../model/user_model.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  bool _isInitialized = false;

  AuthService({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  /// Initialize GoogleSignIn - must be called before using Google Sign-In
  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isInitialized) {
      try {
        await _googleSignIn.initialize(
          clientId: '969900702891-7u9bffcag2l0vcb1vrb4b92bsg16bp0q.apps.googleusercontent.com',
        );
        _isInitialized = true;
        loggingService.info('GoogleSignIn initialized successfully');
      } catch (error, stackTrace) {
        loggingService.error('Failed to initialize GoogleSignIn', error, stackTrace);
        rethrow;
      }
    }
  }

  // Stream of authentication state changes
  Stream<UserEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((User? user) {
      if (user != null) {
        loggingService.info('Auth state changed: User signed in', {'userId': user.uid});
        return UserModel.fromFirebaseUser(user);
      } else {
        loggingService.info('Auth state changed: User signed out');
        return null;
      }
    });
  }

  // Get current user
  UserEntity? get currentUser {
    final user = _firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  // Sign in with Google
  Future<UserEntity?> signInWithGoogle() async {
    try {
      loggingService.methodEntry('AuthService', 'signInWithGoogle');

      // Ensure GoogleSignIn is initialized
      await _ensureGoogleSignInInitialized();

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser;
      if (kIsWeb) {
        googleUser = await _googleSignIn.attemptLightweightAuthentication();
      } else {
        googleUser = await _googleSignIn.authenticate();
      }

      // Check if user cancelled the sign-in
      if (googleUser == null) {
        loggingService.info('Google sign-in was cancelled by user');
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final userModel = UserModel.fromFirebaseUser(userCredential.user!);
        loggingService.info('Google sign-in successful', {
          'userId': userModel.id,
          'email': userModel.email,
          'displayName': userModel.displayName,
        });
        return userModel;
      }

      return null;
    } on GoogleSignInException catch (error, stackTrace) {
      loggingService.error('Google sign-in failed with GoogleSignInException', error, stackTrace);

      // Handle specific Google Sign-In exceptions
      switch (error.code) {
        case GoogleSignInExceptionCode.canceled:
          loggingService.info('Google sign-in was cancelled by user');
          return null;
        case GoogleSignInExceptionCode.interrupted:
          loggingService.info('Google sign-in was interrupted');
          return null;
        case GoogleSignInExceptionCode.clientConfigurationError:
          throw Exception(
            'Google Sign-In client configuration error. Please check your setup: ${error.description ?? error.toString()}',
          );
        case GoogleSignInExceptionCode.providerConfigurationError:
          throw Exception(
            'Google Sign-In provider configuration error. Please check your Firebase setup: ${error.description ?? error.toString()}',
          );
        case GoogleSignInExceptionCode.uiUnavailable:
          throw Exception('Google Sign-In UI is unavailable. Please try again later.');
        case GoogleSignInExceptionCode.userMismatch:
          throw Exception('User mismatch error during Google Sign-In. Please try signing out and signing in again.');
        case GoogleSignInExceptionCode.unknownError:
        default:
          throw Exception('Google sign-in failed: ${error.description ?? error.toString()}');
      }
    } catch (error, stackTrace) {
      loggingService.error('Google sign-in failed', error, stackTrace);
      rethrow;
    } finally {
      loggingService.methodExit('AuthService', 'signInWithGoogle');
    }
  }

  // Sign in anonymously
  Future<UserModel?> signInAnonymously() async {
    try {
      loggingService.methodEntry('AuthService', 'signInAnonymously');

      final UserCredential userCredential = await _firebaseAuth.signInAnonymously();

      if (userCredential.user != null) {
        final userModel = UserModel.fromFirebaseUser(userCredential.user!);
        loggingService.info('Anonymous sign-in successful', {'userId': userModel.id});
        return userModel;
      }

      return null;
    } catch (error, stackTrace) {
      loggingService.error('Anonymous sign-in failed', error, stackTrace);
      rethrow;
    } finally {
      loggingService.methodExit('AuthService', 'signInAnonymously');
    }
  }

  // Sign in with email and password
  Future<UserEntity?> signInWithEmailAndPassword({required String email, required String password}) async {
    try {
      loggingService.methodEntry('AuthService', 'signInWithEmailAndPassword', {'email': email});

      final UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        final userModel = UserModel.fromFirebaseUser(userCredential.user!);
        loggingService.info('Email/password sign-in successful', {'userId': userModel.id, 'email': userModel.email});
        return userModel;
      }

      return null;
    } catch (error, stackTrace) {
      loggingService.error('Email/password sign-in failed', error, stackTrace);
      rethrow;
    } finally {
      loggingService.methodExit('AuthService', 'signInWithEmailAndPassword');
    }
  }

  // Create user with email and password
  Future<UserEntity?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      loggingService.methodEntry('AuthService', 'createUserWithEmailAndPassword', {
        'email': email,
        'displayName': displayName,
      });

      final UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null && displayName != null) {
        await userCredential.user!.updateDisplayName(displayName);
        await userCredential.user!.reload();
      }

      if (userCredential.user != null) {
        final userModel = UserModel.fromFirebaseUser(userCredential.user!);
        loggingService.info('User creation successful', {
          'userId': userModel.id,
          'email': userModel.email,
          'displayName': userModel.displayName,
        });
        return userModel;
      }

      return null;
    } catch (error, stackTrace) {
      loggingService.error('User creation failed', error, stackTrace);
      rethrow;
    } finally {
      loggingService.methodExit('AuthService', 'createUserWithEmailAndPassword');
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      loggingService.methodEntry('AuthService', 'signOut');

      // Sign out from Google if initialized
      if (_isInitialized) {
        await _googleSignIn.signOut();
      }

      // Sign out from Firebase
      await _firebaseAuth.signOut();

      loggingService.info('User signed out successfully');
    } catch (error, stackTrace) {
      loggingService.error('Sign out failed', error, stackTrace);
      rethrow;
    } finally {
      loggingService.methodExit('AuthService', 'signOut');
    }
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      loggingService.methodEntry('AuthService', 'sendPasswordResetEmail', {'email': email});

      await _firebaseAuth.sendPasswordResetEmail(email: email);

      loggingService.info('Password reset email sent', {'email': email});
    } catch (error, stackTrace) {
      loggingService.error('Failed to send password reset email', error, stackTrace);
      rethrow;
    } finally {
      loggingService.methodExit('AuthService', 'sendPasswordResetEmail');
    }
  }

  // Delete current user account
  Future<void> deleteAccount() async {
    try {
      loggingService.methodEntry('AuthService', 'deleteAccount');

      final user = _firebaseAuth.currentUser;
      if (user != null) {
        await user.delete();
        loggingService.info('User account deleted', {'userId': user.uid});
      }
    } catch (error, stackTrace) {
      loggingService.error('Failed to delete user account', error, stackTrace);
      rethrow;
    } finally {
      loggingService.methodExit('AuthService', 'deleteAccount');
    }
  }

  // Check if user is currently signed in with Google (lightweight check)
  Future<GoogleSignInAccount?> getCurrentGoogleUser() async {
    try {
      await _ensureGoogleSignInInitialized();
      return await _googleSignIn.attemptLightweightAuthentication();
    } catch (error, stackTrace) {
      loggingService.error('Failed to get current Google user', error, stackTrace);
      return null;
    }
  }
}
