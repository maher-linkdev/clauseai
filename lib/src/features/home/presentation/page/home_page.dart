import 'package:deal_insights_assistant/src/core/constants/app_constants.dart';
import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/logic/auth_provider.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/logic/current_user_provider.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/pages/login_page.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/component/error_display.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/component/file_upload_section.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/component/selected_file_display.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/component/text_input_section.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/logic/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';

class HomePage extends ConsumerWidget {
  static const routeName = '/home';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeStateProvider);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);
    final currentUser = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.appName,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: ColorsPalette.textPrimary),
        ),
        actions: [
          if (isDesktop) const SizedBox(width: 8),
          if (authState.isAuthenticated && currentUser != null)
            PopupMenuButton<void>(
              icon: CircleAvatar(
                radius: 16,
                backgroundColor: ColorsPalette.primary,
                backgroundImage: currentUser.photoURL != null ? NetworkImage(currentUser.photoURL!) : null,
                child: currentUser.photoURL == null
                    ? Icon(PhosphorIcons.user(PhosphorIconsStyle.regular), size: 16, color: Colors.white)
                    : null,
              ),
              itemBuilder: (context) => <PopupMenuEntry<void>>[
                PopupMenuItem<void>(
                  enabled: false,
                  child: ListTile(
                    leading: Icon(PhosphorIcons.user(PhosphorIconsStyle.regular), size: 20),
                    title: Text(currentUser.displayName ?? currentUser.email ?? 'User'),
                    subtitle: currentUser.email != null ? Text(currentUser.email!) : null,
                  ),
                ),
                const PopupMenuDivider(),
                PopupMenuItem<void>(
                  child: ListTile(
                    leading: Icon(PhosphorIcons.signOut(PhosphorIconsStyle.regular), size: 20),
                    title: const Text('Sign Out'),
                    onTap: () {
                      Navigator.of(context).pop(); // closes the popup menu
                      // Delay the sign-out to ensure popup menu is fully closed
                      Future.delayed(const Duration(milliseconds: 200), () {
                        ref.read(authStateProvider.notifier).signOut();
                      });
                    },
                  ),
                ),
              ],
            )
          else
            TextButton.icon(
              icon: Icon(PhosphorIcons.signIn(PhosphorIconsStyle.regular), size: 20),
              label: isDesktop ? const Text('Sign In') : const SizedBox.shrink(),
              onPressed: () {
                // Navigation handled by redirect mechanism
              },
            ),
          const SizedBox(width: 16),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [theme.colorScheme.background, ColorsPalette.primary.withOpacity(0.02)],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      'Upload Your Document',
                      style: theme.textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: ColorsPalette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Upload a PDF or paste text to analyze contracts and get AI-powered insights',
                      style: theme.textTheme.bodyLarge?.copyWith(color: ColorsPalette.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),

                    // Error Display
                    const ErrorDisplay(),

                    // Upload Options - Responsive Layout
                    homeState.hasInput
                        ? const SelectedFileDisplay()
                        : LayoutBuilder(
                            builder: (context, constraints) {
                              final isWideScreen = ResponsiveBreakpoints.of(context).largerThan(TABLET);

                              if (isWideScreen) {
                                // Horizontal layout for wide screens
                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // File Upload Section
                                    const Expanded(child: FileUploadSection()),
                                    // Vertical Divider
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 32),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const SizedBox(height: 180),
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: theme.cardTheme.color,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: ColorsPalette.grey300, width: 1.5),
                                            ),
                                            child: Text(
                                              'OR',
                                              style: TextStyle(
                                                color: ColorsPalette.textSecondary,
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Text Input Section
                                    const Expanded(child: TextInputSection()),
                                  ],
                                );
                              } else {
                                // Vertical layout for narrow screens
                                return Column(
                                  children: [
                                    // File Upload Section
                                    const FileUploadSection(),

                                    const SizedBox(height: 32),

                                    // Horizontal Divider with OR
                                    Row(
                                      children: [
                                        Expanded(child: Divider(color: ColorsPalette.grey300, thickness: 1)),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 24),
                                          child: Text(
                                            'OR',
                                            style: TextStyle(
                                              color: ColorsPalette.textSecondary,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(child: Divider(color: ColorsPalette.grey300, thickness: 1)),
                                      ],
                                    ),

                                    const SizedBox(height: 32),

                                    // Text Input Section (Mobile version)
                                    Card(
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      child: const Padding(padding: EdgeInsets.all(24), child: TextInputSection()),
                                    ),
                                  ],
                                );
                              }
                            },
                          ),
                    //TODO: Add recent documents section
                    // Recent Documents Section
                    // if (isDesktop && !homeState.hasInput) const RecentDocuments(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
