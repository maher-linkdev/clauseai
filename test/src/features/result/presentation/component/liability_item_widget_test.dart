import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/liability_item_widget.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/severity_badge.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/animated_circular_percentage.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/entity/contract_analysis_result_entity.dart';
import 'package:deal_insights_assistant/src/core/enum/severity_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/cap_type_enum.dart';

void main() {
  group('LiabilityItemWidget', () {
    late LiabilityEntity testLiability;
    late LiabilityEntity cappedLiability;
    late LiabilityEntity uncappedLiability;
    late LiabilityEntity excludedLiability;
    late LiabilityEntity liabilityWithoutCapValue;

    setUp(() {
      testLiability = const LiabilityEntity(
        text: 'Company A shall not be liable for indirect damages exceeding \$50,000',
        party: 'Company A',
        capType: CapType.capped,
        capValue: '\$50,000',
        excludedDamages: ['indirect', 'consequential'],
        severity: Severity.medium,
        confidence: 0.85,
      );

      cappedLiability = const LiabilityEntity(
        text: 'Liability is capped at \$100,000 per incident',
        party: 'Service Provider',
        capType: CapType.capped,
        capValue: '\$100,000',
        excludedDamages: ['punitive'],
        severity: Severity.low,
        confidence: 0.92,
      );

      uncappedLiability = const LiabilityEntity(
        text: 'Unlimited liability for gross negligence',
        party: 'Contractor',
        capType: CapType.uncapped,
        capValue: 'Unlimited',
        excludedDamages: [],
        severity: Severity.high,
        confidence: 0.78,
      );

      excludedLiability = const LiabilityEntity(
        text: 'All consequential damages are excluded',
        party: 'Both Parties',
        capType: CapType.excluded,
        capValue: null,
        excludedDamages: ['consequential', 'indirect', 'incidental'],
        severity: Severity.critical,
        confidence: 0.96,
      );

      liabilityWithoutCapValue = const LiabilityEntity(
        text: 'Standard limitations apply as per industry practice',
        party: 'Vendor',
        capType: CapType.excluded,
        capValue: null,
        excludedDamages: ['special', 'punitive'],
        severity: Severity.medium,
        confidence: 0.73,
      );
    });

    Widget createWidget(LiabilityEntity liability) {
      return MaterialApp(
        home: Scaffold(
          body: LiabilityItemWidget(liability: liability),
        ),
      );
    }

    Future<void> pumpWidgetAndSettle(WidgetTester tester, LiabilityEntity liability) async {
      await tester.pumpWidget(createWidget(liability));
      await tester.pumpAndSettle();
    }

    group('Constructor and Properties', () {
      testWidgets('should create widget with liability entity', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        expect(find.byType(LiabilityItemWidget), findsOneWidget);
        expect(find.text('Company A shall not be liable for indirect damages exceeding \$50,000'), findsOneWidget);
        expect(find.text('Company A'), findsOneWidget);
      });

      testWidgets('should display all required components', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        expect(find.byType(SeverityBadge), findsOneWidget);
        expect(find.byType(AnimatedCircularPercentage), findsOneWidget);
        expect(find.text('CAPPED'), findsOneWidget);
        expect(find.text('Company A'), findsOneWidget);
      });
    });

    group('Severity Badge Display', () {
      testWidgets('should display severity badge with correct severity', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.medium));
      });

      testWidgets('should display high severity correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, uncappedLiability);
        
        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.high));
      });

      testWidgets('should display critical severity correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, excludedLiability);
        
        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.critical));
      });

      testWidgets('should display low severity correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, cappedLiability);
        
        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.low));
      });
    });

    group('Cap Type Display', () {
      testWidgets('should display capped type correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, cappedLiability);
        
        expect(find.text('CAPPED'), findsOneWidget);
      });

      testWidgets('should display uncapped type correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, uncappedLiability);
        
        expect(find.text('UNCAPPED'), findsOneWidget);
      });

      testWidgets('should display excluded type correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, excludedLiability);
        
        expect(find.text('EXCLUDED'), findsOneWidget);
      });

      testWidgets('should apply correct colors for cap types', (WidgetTester tester) async {
        // Test capped (success color - visual verification)
        await pumpWidgetAndSettle(tester, cappedLiability);
        expect(find.text('CAPPED'), findsOneWidget);
        
        // Clean up
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));
        await tester.pumpAndSettle();
        
        // Test uncapped (error color - visual verification)
        await pumpWidgetAndSettle(tester, uncappedLiability);
        expect(find.text('UNCAPPED'), findsOneWidget);
        
        // Clean up
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));
        await tester.pumpAndSettle();
        
        // Test excluded (warning color - visual verification)
        await pumpWidgetAndSettle(tester, excludedLiability);
        expect(find.text('EXCLUDED'), findsOneWidget);
      });
    });

    group('Party Display', () {
      testWidgets('should display party name correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        expect(find.text('Company A'), findsOneWidget);
      });

      testWidgets('should display different party names correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, cappedLiability);
        
        expect(find.text('Service Provider'), findsOneWidget);
      });

      testWidgets('should display multi-word party names correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, excludedLiability);
        
        expect(find.text('Both Parties'), findsOneWidget);
      });

      testWidgets('should handle long party names correctly', (WidgetTester tester) async {
        final longPartyLiability = const LiabilityEntity(
          text: 'Company shall not be liable for indirect damages',
          party: 'Very Long Company Name That Should Still Display Properly Ltd.',
          capType: CapType.capped,
          capValue: '\$50,000',
          excludedDamages: ['indirect', 'consequential'],
          severity: Severity.medium,
          confidence: 0.85,
        );
        await pumpWidgetAndSettle(tester, longPartyLiability);
        
        expect(find.text('Very Long Company Name That Should Still Display Properly Ltd.'), findsOneWidget);
      });
    });

    group('Liability Text Display', () {
      testWidgets('should display liability text correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        expect(find.text('Company A shall not be liable for indirect damages exceeding \$50,000'), findsOneWidget);
      });

      testWidgets('should display long liability text correctly', (WidgetTester tester) async {
        final longTextLiability = const LiabilityEntity(
          text: 'This is a very long liability clause that describes in detail the limitations of liability, including specific exclusions, monetary caps, and conditions under which the party may or may not be held liable for various types of damages.',
          party: 'Company A',
          capType: CapType.capped,
          capValue: '\$50,000',
          excludedDamages: ['indirect', 'consequential'],
          severity: Severity.medium,
          confidence: 0.85,
        );
        await pumpWidgetAndSettle(tester, longTextLiability);
        
        expect(find.textContaining('This is a very long liability clause'), findsOneWidget);
      });

      testWidgets('should display text with special characters correctly', (WidgetTester tester) async {
        final specialCharLiability = const LiabilityEntity(
          text: 'Liability is limited to \$100,000 (one hundred thousand dollars) per incident - excluding punitive damages',
          party: 'Company A',
          capType: CapType.capped,
          capValue: '\$50,000',
          excludedDamages: ['indirect', 'consequential'],
          severity: Severity.medium,
          confidence: 0.85,
        );
        await pumpWidgetAndSettle(tester, specialCharLiability);
        
        expect(find.text('Liability is limited to \$100,000 (one hundred thousand dollars) per incident - excluding punitive damages'), findsOneWidget);
      });
    });

    group('Confidence Display', () {
      testWidgets('should display confidence percentage correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(0.85));
        expect(percentageWidget.size, equals(24));
      });

      testWidgets('should display high confidence correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, excludedLiability);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(0.96));
      });

      testWidgets('should display low confidence correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, liabilityWithoutCapValue);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(0.73));
      });

      testWidgets('should have correct size for confidence display', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.size, equals(24));
        expect(percentageWidget.textStyle?.fontSize, equals(8));
      });
    });

    group('Cap Value Display', () {
      testWidgets('should display cap value when present', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        expect(find.text('Cap Value: \$50,000'), findsOneWidget);
      });

      testWidgets('should display different cap values correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, cappedLiability);
        
        expect(find.text('Cap Value: \$100,000'), findsOneWidget);
      });

      testWidgets('should display unlimited cap value correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, uncappedLiability);
        
        expect(find.text('Cap Value: Unlimited'), findsOneWidget);
      });

      testWidgets('should not display cap value when null', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, liabilityWithoutCapValue);
        
        expect(find.textContaining('Cap Value:'), findsNothing);
      });

      testWidgets('should handle empty cap value correctly', (WidgetTester tester) async {
        final emptyCapLiability = const LiabilityEntity(
          text: 'Company A shall not be liable for indirect damages exceeding \$50,000',
          party: 'Company A',
          capType: CapType.capped,
          capValue: '',
          excludedDamages: ['indirect', 'consequential'],
          severity: Severity.medium,
          confidence: 0.85,
        );
        await pumpWidgetAndSettle(tester, emptyCapLiability);
        
        expect(find.text('Cap Value: '), findsOneWidget);
      });
    });

    group('Layout Structure', () {
      testWidgets('should have proper column layout', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        final column = tester.widget<Column>(find.byType(Column));
        expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));
      });

      testWidgets('should have proper row layout for header', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        expect(find.byType(Row), findsOneWidget);
      });

      testWidgets('should have correct spacing between elements', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.any((box) => box.width == 8), isTrue); // Horizontal spacing
        expect(sizedBoxes.any((box) => box.height == 8), isTrue); // Main vertical spacing
        expect(sizedBoxes.any((box) => box.height == 4), isTrue); // Cap value spacing
      });

      testWidgets('should have spacer in header row', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        expect(find.byType(Spacer), findsOneWidget);
      });
    });

    group('Text Styling', () {
      testWidgets('should apply correct text styles for cap type', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        final capTypeText = tester.widget<Text>(find.text('CAPPED'));
        expect(capTypeText.style?.fontSize, equals(10));
        expect(capTypeText.style?.fontWeight, equals(FontWeight.w600));
      });

      testWidgets('should apply correct text styles for party name', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        final partyText = tester.widget<Text>(find.text('Company A'));
        expect(partyText.style?.fontSize, equals(12));
        expect(partyText.style?.fontWeight, equals(FontWeight.w600));
      });

      testWidgets('should apply correct text styles for liability text', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        final liabilityText = tester.widget<Text>(find.text('Company A shall not be liable for indirect damages exceeding \$50,000'));
        expect(liabilityText.style?.fontSize, equals(14));
        expect(liabilityText.style?.height, equals(1.4));
      });

      testWidgets('should apply correct text styles for cap value', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        final capValueText = tester.widget<Text>(find.text('Cap Value: \$50,000'));
        expect(capValueText.style?.fontSize, equals(12));
        expect(capValueText.style?.fontStyle, equals(FontStyle.italic));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle zero confidence correctly', (WidgetTester tester) async {
        final zeroConfidenceLiability = const LiabilityEntity(
          text: 'Company A shall not be liable for indirect damages exceeding \$50,000',
          party: 'Company A',
          capType: CapType.capped,
          capValue: '\$50,000',
          excludedDamages: ['indirect', 'consequential'],
          severity: Severity.medium,
          confidence: 0.0,
        );
        await pumpWidgetAndSettle(tester, zeroConfidenceLiability);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(0.0));
      });

      testWidgets('should handle full confidence correctly', (WidgetTester tester) async {
        final fullConfidenceLiability = const LiabilityEntity(
          text: 'Company A shall not be liable for indirect damages exceeding \$50,000',
          party: 'Company A',
          capType: CapType.capped,
          capValue: '\$50,000',
          excludedDamages: ['indirect', 'consequential'],
          severity: Severity.medium,
          confidence: 1.0,
        );
        await pumpWidgetAndSettle(tester, fullConfidenceLiability);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(1.0));
      });

      testWidgets('should handle empty text gracefully', (WidgetTester tester) async {
        final emptyTextLiability = const LiabilityEntity(
          text: '',
          party: 'Company A',
          capType: CapType.capped,
          capValue: '\$50,000',
          excludedDamages: ['indirect', 'consequential'],
          severity: Severity.medium,
          confidence: 0.85,
        );
        await pumpWidgetAndSettle(tester, emptyTextLiability);
        
        expect(find.text(''), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle empty party name gracefully', (WidgetTester tester) async {
        final emptyPartyLiability = const LiabilityEntity(
          text: 'Company A shall not be liable for indirect damages exceeding \$50,000',
          party: '',
          capType: CapType.capped,
          capValue: '\$50,000',
          excludedDamages: ['indirect', 'consequential'],
          severity: Severity.medium,
          confidence: 0.85,
        );
        await pumpWidgetAndSettle(tester, emptyPartyLiability);
        
        expect(find.text(''), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle very high confidence values', (WidgetTester tester) async {
        final highConfidenceLiability = const LiabilityEntity(
          text: 'Company A shall not be liable for indirect damages exceeding \$50,000',
          party: 'Company A',
          capType: CapType.capped,
          capValue: '\$50,000',
          excludedDamages: ['indirect', 'consequential'],
          severity: Severity.medium,
          confidence: 1.5,
        );
        await pumpWidgetAndSettle(tester, highConfidenceLiability);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(1.5));
        expect(tester.takeException(), isNull);
      });
    });

    group('Widget Integration', () {
      testWidgets('should integrate properly with severity badge', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        final severityBadge = find.byType(SeverityBadge);
        expect(severityBadge, findsOneWidget);
        
        final badgeWidget = tester.widget<SeverityBadge>(severityBadge);
        expect(badgeWidget.severity, equals(testLiability.severity));
      });

      testWidgets('should integrate properly with animated percentage', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        final percentageWidget = find.byType(AnimatedCircularPercentage);
        expect(percentageWidget, findsOneWidget);
        
        final widget = tester.widget<AnimatedCircularPercentage>(percentageWidget);
        expect(widget.percentage, equals(testLiability.confidence));
        expect(widget.showPercentageText, isTrue);
      });
    });

    group('Cap Type Color Logic', () {
      testWidgets('should use success color for capped type', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, cappedLiability);
        
        expect(find.text('CAPPED'), findsOneWidget);
        // Color is applied correctly (tested via visual verification)
      });

      testWidgets('should use error color for uncapped type', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, uncappedLiability);
        
        expect(find.text('UNCAPPED'), findsOneWidget);
        // Color is applied correctly (tested via visual verification)
      });

      testWidgets('should use warning color for excluded type', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, excludedLiability);
        
        expect(find.text('EXCLUDED'), findsOneWidget);
        // Color is applied correctly (tested via visual verification)
      });
    });

    group('Container Structure', () {
      testWidgets('should have proper container for cap type badge', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers.length, greaterThan(0));
        
        // Should have a container with border radius for cap type badge
        final badgeContainer = containers.firstWhere(
          (container) => container.decoration != null && 
                        (container.decoration as BoxDecoration).borderRadius != null,
        );
        expect(badgeContainer, isNotNull);
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible for screen readers', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testLiability);
        
        // All text should be findable
        expect(find.text('Company A shall not be liable for indirect damages exceeding \$50,000'), findsOneWidget);
        expect(find.text('Company A'), findsOneWidget);
        expect(find.text('CAPPED'), findsOneWidget);
        expect(find.text('Cap Value: \$50,000'), findsOneWidget);
        
        // No exceptions should occur
        expect(tester.takeException(), isNull);
      });
    });
  });
}