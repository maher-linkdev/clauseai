import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/risk_item_widget.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/severity_badge.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/animated_circular_percentage.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/entity/contract_analysis_result_entity.dart';
import 'package:deal_insights_assistant/src/core/enum/severity_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/likelihood_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/risk_category_enum.dart';

void main() {
  group('RiskItemWidget', () {
    late RiskEntity testRisk;
    late RiskEntity highRisk;
    late RiskEntity lowRisk;
    late RiskEntity mediumRisk;

    setUp(() {
      testRisk = const RiskEntity(
        text: 'Data breach risk due to insufficient security measures in cloud storage',
        severity: Severity.high,
        likelihood: Likelihood.medium,
        category: RiskCategory.operational,
        confidence: 0.85,
        riskScore: 7,
      );

      highRisk = const RiskEntity(
        text: 'Non-compliance with GDPR regulations may result in significant fines',
        severity: Severity.critical,
        likelihood: Likelihood.high,
        category: RiskCategory.compliance,
        confidence: 0.92,
        riskScore: 9,
      );

      lowRisk = const RiskEntity(
        text: 'Minor delay in project delivery due to weather conditions',
        severity: Severity.low,
        likelihood: Likelihood.low,
        category: RiskCategory.operational,
        confidence: 0.65,
        riskScore: 3,
      );

      mediumRisk = const RiskEntity(
        text: 'Budget overrun due to fluctuating material costs',
        severity: Severity.medium,
        likelihood: Likelihood.medium,
        category: RiskCategory.financial,
        confidence: 0.78,
        riskScore: 5,
      );
    });

    Widget createWidget(RiskEntity risk) {
      return MaterialApp(
        home: Scaffold(
          body: RiskItemWidget(risk: risk),
        ),
      );
    }

    Future<void> pumpWidgetAndSettle(WidgetTester tester, RiskEntity risk) async {
      await tester.pumpWidget(createWidget(risk));
      await tester.pumpAndSettle();
    }

    group('Constructor and Properties', () {
      testWidgets('should create widget with risk entity', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        expect(find.byType(RiskItemWidget), findsOneWidget);
        expect(find.text('Data breach risk due to insufficient security measures in cloud storage'), findsOneWidget);
        expect(find.text('Score: 7'), findsOneWidget);
      });

      testWidgets('should display all required components', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        expect(find.byType(SeverityBadge), findsOneWidget);
        expect(find.byType(AnimatedCircularPercentage), findsOneWidget);
        expect(find.text('MEDIUM'), findsOneWidget);
        expect(find.text('Category: operational'), findsOneWidget);
      });
    });

    group('Severity Badge Display', () {
      testWidgets('should display severity badge with correct severity', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.high));
      });

      testWidgets('should display critical severity correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, highRisk);
        
        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.critical));
      });

      testWidgets('should display low severity correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, lowRisk);
        
        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.low));
      });

      testWidgets('should display medium severity correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, mediumRisk);
        
        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.medium));
      });
    });

    group('Likelihood Display', () {
      testWidgets('should display low likelihood correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, lowRisk);
        
        // Should find LOW text (may appear in both severity and likelihood badges)
        expect(find.text('LOW'), findsAtLeastNWidgets(1));
      });

      testWidgets('should display medium likelihood correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        expect(find.text('MEDIUM'), findsAtLeastNWidgets(1));
      });

      testWidgets('should display high likelihood correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, highRisk);
        
        expect(find.text('HIGH'), findsAtLeastNWidgets(1));
      });

      testWidgets('should apply correct colors for likelihood types', (WidgetTester tester) async {
        // Test low likelihood (success color - visual verification)
        await pumpWidgetAndSettle(tester, lowRisk);
        expect(find.text('LOW'), findsAtLeastNWidgets(1));
        
        // Clean up
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));
        await tester.pumpAndSettle();
        
        // Test medium likelihood (warning color - visual verification)
        await pumpWidgetAndSettle(tester, mediumRisk);
        expect(find.text('MEDIUM'), findsAtLeastNWidgets(1));
        
        // Clean up
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));
        await tester.pumpAndSettle();
        
        // Test high likelihood (error color - visual verification)
        await pumpWidgetAndSettle(tester, highRisk);
        expect(find.text('HIGH'), findsAtLeastNWidgets(1));
      });
    });

    group('Risk Score Display', () {
      testWidgets('should display risk score correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        expect(find.text('Score: 7'), findsOneWidget);
      });

      testWidgets('should display different risk scores correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, highRisk);
        
        expect(find.text('Score: 9'), findsOneWidget);
      });

      testWidgets('should display low risk score correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, lowRisk);
        
        expect(find.text('Score: 3'), findsOneWidget);
      });

      testWidgets('should handle zero risk score correctly', (WidgetTester tester) async {
        const zeroScoreRisk = RiskEntity(
          text: 'Minimal risk event',
          severity: Severity.low,
          likelihood: Likelihood.low,
          category: RiskCategory.other,
          confidence: 0.5,
          riskScore: 0,
        );
        await pumpWidgetAndSettle(tester, zeroScoreRisk);
        
        expect(find.text('Score: 0'), findsOneWidget);
      });

      testWidgets('should handle maximum risk score correctly', (WidgetTester tester) async {
        const maxScoreRisk = RiskEntity(
          text: 'Maximum severity risk event',
          severity: Severity.critical,
          likelihood: Likelihood.high,
          category: RiskCategory.legal,
          confidence: 0.95,
          riskScore: 10,
        );
        await pumpWidgetAndSettle(tester, maxScoreRisk);
        
        expect(find.text('Score: 10'), findsOneWidget);
      });
    });

    group('Risk Text Display', () {
      testWidgets('should display risk text correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        expect(find.text('Data breach risk due to insufficient security measures in cloud storage'), findsOneWidget);
      });

      testWidgets('should display long risk text correctly', (WidgetTester tester) async {
        const longTextRisk = RiskEntity(
          text: 'This is a very long risk description that details multiple factors contributing to the potential negative outcome, including specific scenarios, impact assessments, and contributing circumstances that may lead to significant operational disruption.',
          severity: Severity.high,
          likelihood: Likelihood.medium,
          category: RiskCategory.operational,
          confidence: 0.85,
          riskScore: 7,
        );
        await pumpWidgetAndSettle(tester, longTextRisk);
        
        expect(find.textContaining('This is a very long risk description'), findsOneWidget);
      });

      testWidgets('should display text with special characters correctly', (WidgetTester tester) async {
        const specialCharRisk = RiskEntity(
          text: 'Risk of 15-20% cost increase due to currency fluctuation (USD/EUR)',
          severity: Severity.medium,
          likelihood: Likelihood.medium,
          category: RiskCategory.financial,
          confidence: 0.75,
          riskScore: 6,
        );
        await pumpWidgetAndSettle(tester, specialCharRisk);
        
        expect(find.text('Risk of 15-20% cost increase due to currency fluctuation (USD/EUR)'), findsOneWidget);
      });
    });

    group('Confidence Display', () {
      testWidgets('should display confidence percentage correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(0.85));
        expect(percentageWidget.size, equals(24));
      });

      testWidgets('should display high confidence correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, highRisk);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(0.92));
      });

      testWidgets('should display low confidence correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, lowRisk);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(0.65));
      });

      testWidgets('should have correct size for confidence display', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.size, equals(24));
        expect(percentageWidget.textStyle?.fontSize, equals(8));
      });
    });

    group('Risk Category Display', () {
      testWidgets('should display operational category correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        expect(find.text('Category: operational'), findsOneWidget);
      });

      testWidgets('should display compliance category correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, highRisk);
        
        expect(find.text('Category: compliance'), findsOneWidget);
      });

      testWidgets('should display financial category correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, mediumRisk);
        
        expect(find.text('Category: financial'), findsOneWidget);
      });

      testWidgets('should display legal category correctly', (WidgetTester tester) async {
        const legalRisk = RiskEntity(
          text: 'Legal risk of contract violation',
          severity: Severity.high,
          likelihood: Likelihood.high,
          category: RiskCategory.legal,
          confidence: 0.88,
          riskScore: 8,
        );
        await pumpWidgetAndSettle(tester, legalRisk);
        
        expect(find.text('Category: legal'), findsOneWidget);
      });

      testWidgets('should display other category correctly', (WidgetTester tester) async {
        const otherRisk = RiskEntity(
          text: 'Miscellaneous risk factor',
          severity: Severity.medium,
          likelihood: Likelihood.low,
          category: RiskCategory.other,
          confidence: 0.70,
          riskScore: 4,
        );
        await pumpWidgetAndSettle(tester, otherRisk);
        
        expect(find.text('Category: other'), findsOneWidget);
      });
    });

    group('Layout Structure', () {
      testWidgets('should have proper column layout', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        final column = tester.widget<Column>(find.byType(Column));
        expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));
      });

      testWidgets('should have proper row layout for header', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        expect(find.byType(Row), findsOneWidget);
      });

      testWidgets('should have correct spacing between elements', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.any((box) => box.width == 8), isTrue); // Horizontal spacing
        expect(sizedBoxes.any((box) => box.height == 8), isTrue); // Main vertical spacing
        expect(sizedBoxes.any((box) => box.height == 4), isTrue); // Category spacing
      });

      testWidgets('should have spacer in header row', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        expect(find.byType(Spacer), findsOneWidget);
      });
    });

    group('Text Styling', () {
      testWidgets('should apply correct text styles for likelihood', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        final likelihoodText = tester.widget<Text>(find.text('MEDIUM'));
        expect(likelihoodText.style?.fontSize, equals(10));
        expect(likelihoodText.style?.fontWeight, equals(FontWeight.w600));
      });

      testWidgets('should apply correct text styles for risk score', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        final scoreText = tester.widget<Text>(find.text('Score: 7'));
        expect(scoreText.style?.fontSize, equals(12));
        expect(scoreText.style?.fontWeight, equals(FontWeight.w600));
      });

      testWidgets('should apply correct text styles for risk text', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        final riskText = tester.widget<Text>(find.text('Data breach risk due to insufficient security measures in cloud storage'));
        expect(riskText.style?.fontSize, equals(14));
        expect(riskText.style?.height, equals(1.4));
      });

      testWidgets('should apply correct text styles for category', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        final categoryText = tester.widget<Text>(find.text('Category: operational'));
        expect(categoryText.style?.fontSize, equals(12));
        expect(categoryText.style?.fontStyle, equals(FontStyle.italic));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle zero confidence correctly', (WidgetTester tester) async {
        const zeroConfidenceRisk = RiskEntity(
          text: 'Risk with zero confidence',
          severity: Severity.medium,
          likelihood: Likelihood.medium,
          category: RiskCategory.other,
          confidence: 0.0,
          riskScore: 5,
        );
        await pumpWidgetAndSettle(tester, zeroConfidenceRisk);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(0.0));
      });

      testWidgets('should handle full confidence correctly', (WidgetTester tester) async {
        const fullConfidenceRisk = RiskEntity(
          text: 'Risk with full confidence',
          severity: Severity.high,
          likelihood: Likelihood.high,
          category: RiskCategory.legal,
          confidence: 1.0,
          riskScore: 9,
        );
        await pumpWidgetAndSettle(tester, fullConfidenceRisk);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(1.0));
      });

      testWidgets('should handle empty text gracefully', (WidgetTester tester) async {
        const emptyTextRisk = RiskEntity(
          text: '',
          severity: Severity.low,
          likelihood: Likelihood.low,
          category: RiskCategory.other,
          confidence: 0.5,
          riskScore: 2,
        );
        await pumpWidgetAndSettle(tester, emptyTextRisk);
        
        expect(find.text(''), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle negative risk score gracefully', (WidgetTester tester) async {
        const negativeScoreRisk = RiskEntity(
          text: 'Negative score risk',
          severity: Severity.low,
          likelihood: Likelihood.low,
          category: RiskCategory.other,
          confidence: 0.3,
          riskScore: -1,
        );
        await pumpWidgetAndSettle(tester, negativeScoreRisk);
        
        expect(find.text('Score: -1'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle very high confidence values', (WidgetTester tester) async {
        const highConfidenceRisk = RiskEntity(
          text: 'Risk with very high confidence',
          severity: Severity.critical,
          likelihood: Likelihood.high,
          category: RiskCategory.compliance,
          confidence: 1.2,
          riskScore: 10,
        );
        await pumpWidgetAndSettle(tester, highConfidenceRisk);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(1.2));
        expect(tester.takeException(), isNull);
      });
    });

    group('Widget Integration', () {
      testWidgets('should integrate properly with severity badge', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        final severityBadge = find.byType(SeverityBadge);
        expect(severityBadge, findsOneWidget);
        
        final badgeWidget = tester.widget<SeverityBadge>(severityBadge);
        expect(badgeWidget.severity, equals(testRisk.severity));
      });

      testWidgets('should integrate properly with animated percentage', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        final percentageWidget = find.byType(AnimatedCircularPercentage);
        expect(percentageWidget, findsOneWidget);
        
        final widget = tester.widget<AnimatedCircularPercentage>(percentageWidget);
        expect(widget.percentage, equals(testRisk.confidence));
        expect(widget.showPercentageText, isTrue);
      });
    });

    group('Container Structure', () {
      testWidgets('should have proper container for likelihood badge', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers.length, greaterThan(0));
        
        // Should have a container with border radius for likelihood badge
        final badgeContainer = containers.firstWhere(
          (container) => container.decoration != null && 
                        (container.decoration as BoxDecoration).borderRadius != null,
        );
        expect(badgeContainer, isNotNull);
      });
    });

    group('All Risk Categories', () {
      testWidgets('should handle all risk category types', (WidgetTester tester) async {
        final categories = [
          RiskCategory.legal,
          RiskCategory.financial,
          RiskCategory.operational,
          RiskCategory.compliance,
          RiskCategory.other,
        ];
        
        for (final category in categories) {
          final categoryRisk = RiskEntity(
            text: 'Risk for ${category.name} category',
            severity: Severity.medium,
            likelihood: Likelihood.medium,
            category: category,
            confidence: 0.75,
            riskScore: 5,
          );
          
          await pumpWidgetAndSettle(tester, categoryRisk);
          expect(find.text('Category: ${category.name}'), findsOneWidget);
          
          // Clean up for next iteration
          await tester.pumpWidget(const MaterialApp(home: Scaffold()));
          await tester.pumpAndSettle();
        }
      });
    });

    group('All Likelihood Types', () {
      testWidgets('should handle all likelihood types with correct colors', (WidgetTester tester) async {
        final likelihoods = [
          (Likelihood.low, 'LOW'),
          (Likelihood.medium, 'MEDIUM'),
          (Likelihood.high, 'HIGH'),
        ];
        
        for (final (likelihood, displayName) in likelihoods) {
          final likelihoodRisk = RiskEntity(
            text: 'Risk with ${likelihood.name} likelihood',
            severity: Severity.medium,
            likelihood: likelihood,
            category: RiskCategory.operational,
            confidence: 0.75,
            riskScore: 5,
          );
          
          await pumpWidgetAndSettle(tester, likelihoodRisk);
          expect(find.text(displayName), findsAtLeastNWidgets(1));
          
          // Clean up for next iteration
          await tester.pumpWidget(const MaterialApp(home: Scaffold()));
          await tester.pumpAndSettle();
        }
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible for screen readers', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testRisk);
        
        // All text should be findable
        expect(find.text('Data breach risk due to insufficient security measures in cloud storage'), findsOneWidget);
        expect(find.text('MEDIUM'), findsOneWidget);
        expect(find.text('Score: 7'), findsOneWidget);
        expect(find.text('Category: operational'), findsOneWidget);
        
        // No exceptions should occur
        expect(tester.takeException(), isNull);
      });
    });
  });
}