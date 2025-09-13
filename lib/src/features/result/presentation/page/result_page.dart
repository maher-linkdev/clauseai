import 'package:deal_insights_assistant/src/core/constants/app_constants.dart';
import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/model/contract_analysis_result.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/logic/home_provider.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/page/home_page.dart';
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

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        ref.read(homeStateProvider.notifier).clearSelection();
        context.goNamed(HomePage.routeName);
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
                // try {
                final exportService = ref.read(exportServiceProvider);
                await exportService.exportToPdf(
                  analysisResult: contractAnalysisResult,
                  fileName: fileName,
                  extractedText: extractedText,
                );
                // } catch (e) {
                //   if (context.mounted) {
                //     ScaffoldMessenger.of(context).showSnackBar(
                //       SnackBar(
                //         content: Text('Failed to export PDF: ${e.toString()}'),
                //         backgroundColor: ColorsPalette.error,
                //       ),
                //     );
                //   }
                //}
              },
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              icon: Icon(PhosphorIcons.house(PhosphorIconsStyle.regular), size: 20),
              label: isDesktop ? const Text('New Analysis') : const SizedBox.shrink(),
              onPressed: () {
                ref.read(homeStateProvider.notifier).clearSelection();
                context.goNamed(HomePage.routeName);
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
                        AnalysisSection<Obligation>(
                          title: 'Obligations',
                          icon: PhosphorIcons.userCheck(),
                          items: contractAnalysisResult.obligations!,
                          itemBuilder: (obligation) => ObligationItemWidget(obligation: obligation),
                        ),

                      if (contractAnalysisResult.risks?.isNotEmpty == true)
                        AnalysisSection<Risk>(
                          title: 'Risks',
                          icon: PhosphorIcons.warning(),
                          items: contractAnalysisResult.risks!,
                          itemBuilder: (risk) => RiskItemWidget(risk: risk),
                        ),

                      if (contractAnalysisResult.paymentTerms?.isNotEmpty == true)
                        AnalysisSection<PaymentTerm>(
                          title: 'Payment Terms',
                          icon: PhosphorIcons.creditCard(),
                          items: contractAnalysisResult.paymentTerms!,
                          itemBuilder: (paymentTerm) => PaymentTermItemWidget(paymentTerm: paymentTerm),
                        ),

                      if (contractAnalysisResult.liabilities?.isNotEmpty == true)
                        AnalysisSection<Liability>(
                          title: 'Liabilities',
                          icon: PhosphorIcons.shield(),
                          items: contractAnalysisResult.liabilities!,
                          itemBuilder: (liability) => LiabilityItemWidget(liability: liability),
                        ),

                      if (contractAnalysisResult.serviceLevels?.isNotEmpty == true)
                        AnalysisSection<ServiceLevel>(
                          title: 'Service Levels',
                          icon: PhosphorIcons.gauge(),
                          items: contractAnalysisResult.serviceLevels!,
                          itemBuilder: (serviceLevel) => ServiceLevelItemWidget(serviceLevel: serviceLevel),
                        ),

                      if (contractAnalysisResult.intellectualProperty?.isNotEmpty == true)
                        AnalysisSection<IntellectualProperty>(
                          title: 'Intellectual Property',
                          icon: PhosphorIcons.lightbulb(),
                          items: contractAnalysisResult.intellectualProperty!,
                          itemBuilder: (ip) => IntellectualPropertyItemWidget(intellectualProperty: ip),
                        ),

                      if (contractAnalysisResult.securityRequirements?.isNotEmpty == true)
                        AnalysisSection<SecurityRequirement>(
                          title: 'Security Requirements',
                          icon: PhosphorIcons.lock(),
                          items: contractAnalysisResult.securityRequirements!,
                          itemBuilder: (security) => SecurityRequirementItemWidget(securityRequirement: security),
                        ),

                      if (contractAnalysisResult.userRequirements?.isNotEmpty == true)
                        AnalysisSection<UserRequirement>(
                          title: 'User Requirements',
                          icon: PhosphorIcons.user(),
                          items: contractAnalysisResult.userRequirements!,
                          itemBuilder: (userReq) => UserRequirementItemWidget(userRequirement: userReq),
                        ),

                      if (contractAnalysisResult.conflictsOrContrasts?.isNotEmpty == true)
                        AnalysisSection<ConflictOrContrast>(
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
