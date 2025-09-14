import 'package:deal_insights_assistant/src/core/constants/app_constants.dart';
import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/entity/contract_analysis_result_entity.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/model/contract_analysis_result_model.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/logic/auth_provider.dart';
import 'package:deal_insights_assistant/src/features/auth/presentation/logic/current_user_provider.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/logic/home_provider.dart';
import 'package:deal_insights_assistant/src/features/result/domain/service/export_service.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/analysis_section.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/conflict_item_widget.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/intellectual_property_item_widget.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/liability_item_widget.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/obligation_item_widget.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/payment_term_item_widget.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/result_header.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/result_summary_cards.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/risk_item_widget.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/security_requirement_item_widget.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/service_level_item_widget.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/user_requirement_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class ResultPage extends ConsumerWidget {
  static const routeName = '/result';

  final ContractAnalysisResult contractAnalysisResult;
  final String extractedText;
  final String? fileName;

  const ResultPage({super.key, required this.contractAnalysisResult, required this.extractedText, this.fileName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 768;
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);
    final currentUser = ref.watch(currentUserProvider);

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        // Delay provider modification until after widget tree is built
        Future.microtask(() {
          ref.read(homeStateProvider.notifier).clearSelection();
        });
        // Navigation handled by redirect mechanism
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(PhosphorIcons.chartLineUp(PhosphorIconsStyle.duotone), size: 28, color: ColorsPalette.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  "${AppConstants.appName}: Analysis Results",
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: ColorsPalette.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: Icon(PhosphorIcons.arrowLeft(PhosphorIconsStyle.regular)),
            onPressed: () => context.pop(),
          ),
          actions: [
            if (isDesktop) const SizedBox(width: 8),
            TextButton.icon(
              icon: Icon(PhosphorIcons.filePdf(PhosphorIconsStyle.regular), size: 20),
              label: isDesktop ? const Text('Export PDF') : const SizedBox.shrink(),
              onPressed: () async {
                final exportService = ref.read(exportServiceProvider);
                await exportService.exportToPdf(
                  analysisResult: contractAnalysisResult,
                  fileName: fileName,
                  extractedText: extractedText,
                );
              },
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              icon: Icon(PhosphorIcons.house(PhosphorIconsStyle.regular), size: 20),
              label: isDesktop ? const Text('New Analysis') : const SizedBox.shrink(),
              onPressed: () {
                Future.microtask(() {
                  ref.read(homeStateProvider.notifier).clearSelection();
                  Navigator.of(context).pop();
                });
                // Navigation handled by redirect mechanism
              },
            ),
            const SizedBox(width: 8),
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
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 32 : 24),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isDesktop ? 1200 : double.infinity),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section
                    ResultHeader(fileName: fileName, onBackPressed: () {}, onNewAnalysis: () {}, isDesktop: isDesktop),

                    const SizedBox(height: 32),

                    ...[
                      // Summary Cards
                      ResultSummaryCards(contractAnalysisResult: contractAnalysisResult),

                      const SizedBox(height: 32),

                      // Analysis Sections
                      if (contractAnalysisResult.obligations?.isNotEmpty == true)
                        AnalysisSection<ObligationEntity>(
                          title: 'Obligations',
                          icon: PhosphorIcons.userCheck(),
                          items: contractAnalysisResult.obligations!,
                          itemBuilder: (obligation) => ObligationItemWidget(obligation: obligation),
                        ),

                      if (contractAnalysisResult.risks?.isNotEmpty == true)
                        AnalysisSection<RiskEntity>(
                          title: 'Risks',
                          icon: PhosphorIcons.warning(),
                          items: contractAnalysisResult.risks!,
                          itemBuilder: (risk) => RiskItemWidget(risk: risk),
                        ),

                      if (contractAnalysisResult.paymentTerms?.isNotEmpty == true)
                        AnalysisSection<PaymentTermEntity>(
                          title: 'Payment Terms',
                          icon: PhosphorIcons.creditCard(),
                          items: contractAnalysisResult.paymentTerms!,
                          itemBuilder: (paymentTerm) => PaymentTermItemWidget(paymentTerm: paymentTerm),
                        ),

                      if (contractAnalysisResult.liabilities?.isNotEmpty == true)
                        AnalysisSection<LiabilityEntity>(
                          title: 'Liabilities',
                          icon: PhosphorIcons.shield(),
                          items: contractAnalysisResult.liabilities!,
                          itemBuilder: (liability) => LiabilityItemWidget(liability: liability),
                        ),

                      if (contractAnalysisResult.serviceLevels?.isNotEmpty == true)
                        AnalysisSection<ServiceLevelEntity>(
                          title: 'Service Levels',
                          icon: PhosphorIcons.gauge(),
                          items: contractAnalysisResult.serviceLevels!,
                          itemBuilder: (serviceLevel) => ServiceLevelItemWidget(serviceLevel: serviceLevel),
                        ),

                      if (contractAnalysisResult.intellectualProperty?.isNotEmpty == true)
                        AnalysisSection<IntellectualPropertyEntity>(
                          title: 'Intellectual Property',
                          icon: PhosphorIcons.lightbulb(),
                          items: contractAnalysisResult.intellectualProperty!,
                          itemBuilder: (ip) => IntellectualPropertyItemWidget(intellectualProperty: ip),
                        ),

                      if (contractAnalysisResult.securityRequirements?.isNotEmpty == true)
                        AnalysisSection<SecurityRequirementEntity>(
                          title: 'Security Requirements',
                          icon: PhosphorIcons.lock(),
                          items: contractAnalysisResult.securityRequirements!,
                          itemBuilder: (security) => SecurityRequirementItemWidget(securityRequirement: security),
                        ),

                      if (contractAnalysisResult.userRequirements?.isNotEmpty == true)
                        AnalysisSection<UserRequirementEntity>(
                          title: 'User Requirements',
                          icon: PhosphorIcons.user(),
                          items: contractAnalysisResult.userRequirements!,
                          itemBuilder: (userReq) => UserRequirementItemWidget(userRequirement: userReq),
                        ),

                      if (contractAnalysisResult.conflictsOrContrasts?.isNotEmpty == true)
                        AnalysisSection<ConflictOrContrastEntity>(
                          title: 'Conflicts & Contrasts',
                          icon: PhosphorIcons.warning(),
                          items: contractAnalysisResult.conflictsOrContrasts!,
                          itemBuilder: (conflict) => ConflictItemWidget(conflict: conflict),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
