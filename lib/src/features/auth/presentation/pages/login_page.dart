import 'package:deal_insights_assistant/src/core/constants/app_constants.dart';
import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/core/utils/app_snack_bar.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/logic/auth_provider.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/logic/auth_state.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/page/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LoginPage extends ConsumerStatefulWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);
    final authNotifier = ref.read(authStateProvider.notifier);

    // Listen to authentication state changes
    ref.listen<AuthState>(authStateProvider, (previous, next) {
      if (next.isAuthenticated) {
        // Navigation handled by redirect mechanism
      } else if (next.hasError) {
        // Show error message
        AppSnackBar.error(context, next.errorMessage ?? 'Authentication failed');
        // Clear error after showing
        Future.delayed(const Duration(seconds: 3), () {
          authNotifier.clearError();
        });
      }
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [ColorsPalette.primary.withOpacity(0.1), ColorsPalette.secondary.withOpacity(0.05)],
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isDesktop ? 500 : double.infinity),
                child: Card(
                  elevation: isDesktop ? 8 : 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  child: Padding(
                    padding: EdgeInsets.all(isDesktop ? 48 : 32),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Icon(
                            PhosphorIcons.fileText(PhosphorIconsStyle.duotone),
                            size: 64,
                            color: ColorsPalette.primary,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            AppConstants.appName,
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: ColorsPalette.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Analyze contracts with AI-powered insights',
                            style: theme.textTheme.bodyLarge?.copyWith(color: ColorsPalette.textSecondary),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 48),
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'Enter your email',
                              prefixIcon: Icon(
                                PhosphorIcons.envelope(PhosphorIconsStyle.regular),
                                color: ColorsPalette.grey600,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              prefixIcon: Icon(
                                PhosphorIcons.lock(PhosphorIconsStyle.regular),
                                color: ColorsPalette.grey600,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? PhosphorIcons.eye(PhosphorIconsStyle.regular)
                                      : PhosphorIcons.eyeSlash(PhosphorIconsStyle.regular),
                                  color: ColorsPalette.grey600,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: authState.isLoading
                                  ? null
                                  : () {
                                      if (_emailController.text.isNotEmpty) {
                                        authNotifier.sendPasswordResetEmail(_emailController.text);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Password reset email sent!'),
                                            backgroundColor: Colors.green,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Please enter your email first'),
                                            backgroundColor: Colors.orange,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(color: ColorsPalette.primary, fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: authState.isLoading
                                ? null
                                : () async {
                                    if (_formKey.currentState!.validate()) {
                                      try {
                                        await authNotifier.signInWithEmailAndPassword(
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text,
                                        );
                                      } on FirebaseAuthException catch (e) {
                                        // If credentials are not valid, offer to create an account
                                        if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
                                          if (context.mounted) {
                                            _showCreateAccountDialog(context, authNotifier);
                                          }
                                        } else {
                                          // For other Firebase errors, show a snackbar
                                          if (context.mounted) {
                                            AppSnackBar.error(context, e.message ?? 'An unknown error occurred.');
                                          }
                                        }
                                      } catch (error) {
                                        // For any other generic errors
                                        if (context.mounted) {
                                          AppSnackBar.error(context, 'An unexpected error occurred. Please try again.');
                                        }
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18)),
                            child: authState.isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(PhosphorIcons.signIn(PhosphorIconsStyle.regular), size: 20),
                                      const SizedBox(width: 8),
                                      const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(child: Divider(color: ColorsPalette.grey300, thickness: 1)),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'OR',
                                  style: TextStyle(color: ColorsPalette.textSecondary, fontWeight: FontWeight.w500),
                                ),
                              ),
                              Expanded(child: Divider(color: ColorsPalette.grey300, thickness: 1)),
                            ],
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: authState.isLoading
                                ? null
                                : () {
                                    authNotifier.signInWithGoogle();
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black87,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              side: BorderSide(color: ColorsPalette.grey300, width: 1.5),
                              elevation: 2,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(PhosphorIcons.googleLogo(PhosphorIconsStyle.regular), size: 20, color: Colors.red),
                                const SizedBox(width: 12),
                                const Text(
                                  'Continue with Google',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: authState.isLoading
                                ? null
                                : () {
                                    authNotifier.signInAnonymously();
                                  },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  PhosphorIcons.userCircle(PhosphorIconsStyle.regular),
                                  size: 20,
                                  color: ColorsPalette.textSecondary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Continue as Guest',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: ColorsPalette.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateAccountDialog(BuildContext context, dynamic authNotifier) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final theme = Theme.of(context);
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 8,
          child: Container(
            width: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [ColorsPalette.primary.withOpacity(0.05), ColorsPalette.secondary.withOpacity(0.02)],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: ColorsPalette.primary.withOpacity(0.1), shape: BoxShape.circle),
                    child: Icon(
                      PhosphorIcons.userPlus(PhosphorIconsStyle.duotone),
                      size: 48,
                      color: ColorsPalette.primary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title
                  Text(
                    'Account Not Found',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: ColorsPalette.textPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Content
                  Text(
                    'No account exists with this email address. Would you like to create a new account with these credentials?',
                    style: theme.textTheme.bodyLarge?.copyWith(color: ColorsPalette.textSecondary, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),

                  // Buttons
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(color: ColorsPalette.grey400, width: 1.5),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                PhosphorIcons.x(PhosphorIconsStyle.regular),
                                size: 18,
                                color: ColorsPalette.textSecondary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ColorsPalette.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Create Account Button
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            try {
                              await authNotifier.createUserWithEmailAndPassword(
                                email: _emailController.text.trim(),
                                password: _passwordController.text,
                              );
                            } catch (error) {
                              if (context.mounted) {
                                AppSnackBar.error(context, 'Failed to create account: ${error.toString()}');
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsPalette.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(PhosphorIcons.userPlus(PhosphorIconsStyle.regular), size: 18, color: Colors.white),
                              const SizedBox(width: 8),
                              const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
