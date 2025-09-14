import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/obligation_item_widget.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/severity_badge.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/animated_circular_percentage.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/entity/contract_analysis_result_entity.dart';
import 'package:deal_insights_assistant/src/core/enum/severity_enum.dart';

void main() {
  group('ObligationItemWidget', () {
    late ObligationEntity testObligation;
    late ObligationEntity obligationWithTimeframe;
    late ObligationEntity obligationWithoutTimeframe;

    setUp(() {
      testObligation = const ObligationEntity(
        text: 'The contractor must deliver the software within 30 days',
        party: 'Contractor',
        severity: Severity.medium,
        timeframe: '30 days',
        confidence: 0.85,
      );

      obligationWithTimeframe = const ObligationEntity(
        text: 'Complete system testing before deployment',
        party: 'Development Team',
        severity: Severity.high,
        timeframe: 'Before deployment',
        confidence: 0.92,
      );

      obligationWithoutTimeframe = const ObligationEntity(
        text: 'Maintain code quality standards',
        party: 'All Developers',
        severity: Severity.low,
        timeframe: null,
        confidence: 0.78,
      );
    });

    Widget createWidget(ObligationEntity obligation) {
      return MaterialApp(
        home: Scaffold(
          body: ObligationItemWidget(obligation: obligation),
        ),
      );
    }

    Future<void> pumpWidgetAndSettle(WidgetTester tester, ObligationEntity obligation) async {
      await tester.pumpWidget(createWidget(obligation));
      await tester.pumpAndSettle();
    }

    group('Constructor and Properties', () {
      testWidgets('should create widget with obligation entity', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        expect(find.byType(ObligationItemWidget), findsOneWidget);
        expect(find.text('Contractor'), findsOneWidget);
        expect(find.text('The contractor must deliver the software within 30 days'), findsOneWidget);
      });

      testWidgets('should display all required components', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        expect(find.byType(SeverityBadge), findsOneWidget);
        expect(find.byType(AnimatedCircularPercentage), findsOneWidget);
        expect(find.text('Contractor'), findsOneWidget);
        expect(find.text('The contractor must deliver the software within 30 days'), findsOneWidget);
      });
    });

    group('Severity Badge Display', () {
      testWidgets('should display severity badge with correct severity', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.medium));
      });

      testWidgets('should display high severity correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, obligationWithTimeframe);
        
        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.high));
      });

      testWidgets('should display low severity correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, obligationWithoutTimeframe);
        
        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.low));
      });

      testWidgets('should display critical severity correctly', (WidgetTester tester) async {
        final criticalObligation = testObligation.copyWith(severity: Severity.critical);
        await pumpWidgetAndSettle(tester, criticalObligation);
        
        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.critical));
      });
    });

    group('Party Display', () {
      testWidgets('should display party name correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        expect(find.text('Contractor'), findsOneWidget);
      });

      testWidgets('should display long party names correctly', (WidgetTester tester) async {
        final longPartyObligation = testObligation.copyWith(
          party: 'Very Long Party Name That Should Still Display Properly',
        );
        await pumpWidgetAndSettle(tester, longPartyObligation);
        
        expect(find.text('Very Long Party Name That Should Still Display Properly'), findsOneWidget);
      });

      testWidgets('should display party with special characters', (WidgetTester tester) async {
        final specialCharObligation = testObligation.copyWith(
          party: 'ABC Corp & Associates Ltd.',
        );
        await pumpWidgetAndSettle(tester, specialCharObligation);
        
        expect(find.text('ABC Corp & Associates Ltd.'), findsOneWidget);
      });
    });

    group('Obligation Text Display', () {
      testWidgets('should display obligation text correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        expect(find.text('The contractor must deliver the software within 30 days'), findsOneWidget);
      });

      testWidgets('should display long obligation text correctly', (WidgetTester tester) async {
        final longTextObligation = testObligation.copyWith(
          text: 'This is a very long obligation text that describes in detail what the party must do, including specific requirements, deadlines, and deliverables that need to be met according to the contract terms and conditions.',
        );
        await pumpWidgetAndSettle(tester, longTextObligation);
        
        expect(find.textContaining('This is a very long obligation text'), findsOneWidget);
      });

      testWidgets('should display text with line breaks correctly', (WidgetTester tester) async {
        final multilineObligation = testObligation.copyWith(
          text: 'First requirement\nSecond requirement\nThird requirement',
        );
        await pumpWidgetAndSettle(tester, multilineObligation);
        
        expect(find.text('First requirement\nSecond requirement\nThird requirement'), findsOneWidget);
      });
    });

    group('Confidence Display', () {
      testWidgets('should display confidence percentage correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(0.85));
        expect(percentageWidget.size, equals(24));
      });

      testWidgets('should display high confidence correctly', (WidgetTester tester) async {
        final highConfidenceObligation = testObligation.copyWith(confidence: 0.95);
        await pumpWidgetAndSettle(tester, highConfidenceObligation);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(0.95));
      });

      testWidgets('should display low confidence correctly', (WidgetTester tester) async {
        final lowConfidenceObligation = testObligation.copyWith(confidence: 0.45);
        await pumpWidgetAndSettle(tester, lowConfidenceObligation);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(0.45));
      });

      testWidgets('should have correct size for confidence display', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.size, equals(24));
        expect(percentageWidget.textStyle?.fontSize, equals(8));
      });
    });

    group('Timeframe Display', () {
      testWidgets('should display timeframe when present', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        expect(find.text('Timeframe: 30 days'), findsOneWidget);
      });

      testWidgets('should not display timeframe when null', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, obligationWithoutTimeframe);
        
        expect(find.textContaining('Timeframe:'), findsNothing);
      });

      testWidgets('should display complex timeframes correctly', (WidgetTester tester) async {
        final complexTimeframeObligation = testObligation.copyWith(
          timeframe: 'Within 5 business days after contract execution',
        );
        await pumpWidgetAndSettle(tester, complexTimeframeObligation);
        
        expect(find.text('Timeframe: Within 5 business days after contract execution'), findsOneWidget);
      });

      testWidgets('should display empty timeframe correctly', (WidgetTester tester) async {
        final emptyTimeframeObligation = testObligation.copyWith(timeframe: '');
        await pumpWidgetAndSettle(tester, emptyTimeframeObligation);
        
        expect(find.text('Timeframe: '), findsOneWidget);
      });
    });

    group('Layout Structure', () {
      testWidgets('should have proper column layout', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        final column = tester.widget<Column>(find.byType(Column));
        expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));
      });

      testWidgets('should have proper row layout for header', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        expect(find.byType(Row), findsOneWidget);
      });

      testWidgets('should have correct spacing between elements', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.any((box) => box.width == 8), isTrue); // Horizontal spacing
        expect(sizedBoxes.any((box) => box.height == 8), isTrue); // Vertical spacing
      });

      testWidgets('should have proper expanded widget for party text', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        expect(find.byType(Expanded), findsOneWidget);
      });
    });

    group('Text Styling', () {
      testWidgets('should apply correct text styles', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        // Check party name style
        final partyText = tester.widget<Text>(find.text('Contractor'));
        expect(partyText.style?.fontSize, equals(14));
        expect(partyText.style?.fontWeight, equals(FontWeight.w600));
        
        // Check obligation text style  
        final obligationText = tester.widget<Text>(find.text('The contractor must deliver the software within 30 days'));
        expect(obligationText.style?.fontSize, equals(14));
        expect(obligationText.style?.height, equals(1.4));
      });

      testWidgets('should apply correct timeframe text style', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        final timeframeText = tester.widget<Text>(find.text('Timeframe: 30 days'));
        expect(timeframeText.style?.fontSize, equals(12));
        expect(timeframeText.style?.fontStyle, equals(FontStyle.italic));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle zero confidence correctly', (WidgetTester tester) async {
        final zeroConfidenceObligation = testObligation.copyWith(confidence: 0.0);
        await pumpWidgetAndSettle(tester, zeroConfidenceObligation);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(0.0));
      });

      testWidgets('should handle full confidence correctly', (WidgetTester tester) async {
        final fullConfidenceObligation = testObligation.copyWith(confidence: 1.0);
        await pumpWidgetAndSettle(tester, fullConfidenceObligation);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(1.0));
      });

      testWidgets('should handle empty text gracefully', (WidgetTester tester) async {
        final emptyTextObligation = testObligation.copyWith(text: '');
        await pumpWidgetAndSettle(tester, emptyTextObligation);
        
        expect(find.text(''), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle empty party name gracefully', (WidgetTester tester) async {
        final emptyPartyObligation = testObligation.copyWith(party: '');
        await pumpWidgetAndSettle(tester, emptyPartyObligation);
        
        expect(find.text(''), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle very high confidence values', (WidgetTester tester) async {
        final highConfidenceObligation = testObligation.copyWith(confidence: 1.5);
        await pumpWidgetAndSettle(tester, highConfidenceObligation);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(1.5));
        expect(tester.takeException(), isNull);
      });
    });

    group('Widget Integration', () {
      testWidgets('should integrate properly with severity badge', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        final severityBadge = find.byType(SeverityBadge);
        expect(severityBadge, findsOneWidget);
        
        final badgeWidget = tester.widget<SeverityBadge>(severityBadge);
        expect(badgeWidget.severity, equals(testObligation.severity));
      });

      testWidgets('should integrate properly with animated percentage', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        final percentageWidget = find.byType(AnimatedCircularPercentage);
        expect(percentageWidget, findsOneWidget);
        
        final widget = tester.widget<AnimatedCircularPercentage>(percentageWidget);
        expect(widget.percentage, equals(testObligation.confidence));
        expect(widget.showPercentageText, isTrue);
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible for screen readers', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testObligation);
        
        // All text should be findable
        expect(find.text('Contractor'), findsOneWidget);
        expect(find.text('The contractor must deliver the software within 30 days'), findsOneWidget);
        expect(find.text('Timeframe: 30 days'), findsOneWidget);
        
        // No exceptions should occur
        expect(tester.takeException(), isNull);
      });
    });
  });
}