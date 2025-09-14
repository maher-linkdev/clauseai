import 'package:deal_insights_assistant/src/core/enum/ownership_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/severity_enum.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/entity/contract_analysis_result_entity.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/intellectual_property_item_widget.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/severity_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IntellectualPropertyItemWidget', () {
    late IntellectualPropertyEntity testIP;

    setUp(() {
      testIP = const IntellectualPropertyEntity(
        text: 'Test intellectual property description',
        ownership: Ownership.client,
        severity: Severity.medium,
      );
    });

    Widget createWidget(IntellectualPropertyEntity intellectualProperty) {
      return MaterialApp(
        home: Scaffold(body: IntellectualPropertyItemWidget(intellectualProperty: intellectualProperty)),
      );
    }

    group('Constructor and Properties', () {
      testWidgets('should create widget with required parameters', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testIP));

        expect(find.byType(IntellectualPropertyItemWidget), findsOneWidget);
        expect(find.byType(SeverityBadge), findsOneWidget);
      });

      testWidgets('should display intellectual property text', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testIP));

        expect(find.text('Test intellectual property description'), findsOneWidget);
      });

      testWidgets('should display severity badge', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testIP));

        final severityBadge = find.byType(SeverityBadge);
        expect(severityBadge, findsOneWidget);

        final severityBadgeWidget = tester.widget<SeverityBadge>(severityBadge);
        expect(severityBadgeWidget.severity, equals(Severity.medium));
      });
    });

    group('Ownership Display', () {
      testWidgets('should display client ownership badge', (WidgetTester tester) async {
        final clientIP = IntellectualPropertyEntity(
          text: 'Client owned IP',
          ownership: Ownership.client,
          severity: Severity.low,
        );

        await tester.pumpWidget(createWidget(clientIP));

        expect(find.text('CLIENT'), findsOneWidget);
      });

      testWidgets('should display vendor ownership badge', (WidgetTester tester) async {
        final vendorIP = IntellectualPropertyEntity(
          text: 'Vendor owned IP',
          ownership: Ownership.vendor,
          severity: Severity.medium,
        );

        await tester.pumpWidget(createWidget(vendorIP));

        expect(find.text('VENDOR'), findsOneWidget);
      });

      testWidgets('should display shared ownership badge', (WidgetTester tester) async {
        final sharedIP = IntellectualPropertyEntity(
          text: 'Shared IP',
          ownership: Ownership.shared,
          severity: Severity.high,
        );

        await tester.pumpWidget(createWidget(sharedIP));

        expect(find.text('SHARED'), findsOneWidget);
      });
    });

    group('Ownership Badge Styling', () {
      testWidgets('should apply correct styling to ownership badge', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testIP));

        final ownershipContainer = find.byType(Container).last;
        expect(ownershipContainer, findsOneWidget);

        final containerWidget = tester.widget<Container>(ownershipContainer);
        final decoration = containerWidget.decoration as BoxDecoration;
        expect(decoration.borderRadius, equals(BorderRadius.circular(4)));
      });

      testWidgets('should display ownership text in uppercase', (WidgetTester tester) async {
        final vendorIP = IntellectualPropertyEntity(
          text: 'Test IP',
          ownership: Ownership.vendor,
          severity: Severity.low,
        );

        await tester.pumpWidget(createWidget(vendorIP));

        expect(find.text('VENDOR'), findsOneWidget);
        expect(find.text('vendor'), findsNothing);
        expect(find.text('Vendor'), findsNothing);
      });
    });

    group('Severity Variations', () {
      testWidgets('should display low severity badge', (WidgetTester tester) async {
        final lowSeverityIP = IntellectualPropertyEntity(
          text: 'Low severity IP',
          ownership: Ownership.client,
          severity: Severity.low,
        );

        await tester.pumpWidget(createWidget(lowSeverityIP));

        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.low));
      });

      testWidgets('should display medium severity badge', (WidgetTester tester) async {
        final mediumSeverityIP = IntellectualPropertyEntity(
          text: 'Medium severity IP',
          ownership: Ownership.vendor,
          severity: Severity.medium,
        );

        await tester.pumpWidget(createWidget(mediumSeverityIP));

        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.medium));
      });

      testWidgets('should display high severity badge', (WidgetTester tester) async {
        final highSeverityIP = IntellectualPropertyEntity(
          text: 'High severity IP',
          ownership: Ownership.shared,
          severity: Severity.high,
        );

        await tester.pumpWidget(createWidget(highSeverityIP));

        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.high));
      });

      testWidgets('should display critical severity badge', (WidgetTester tester) async {
        final criticalSeverityIP = IntellectualPropertyEntity(
          text: 'Critical severity IP',
          ownership: Ownership.client,
          severity: Severity.critical,
        );

        await tester.pumpWidget(createWidget(criticalSeverityIP));

        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.critical));
      });
    });

    group('Layout Structure', () {
      testWidgets('should have correct layout structure', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testIP));

        final column = find.byType(Column);
        expect(column, findsOneWidget);

        final columnWidget = tester.widget<Column>(column);
        expect(columnWidget.crossAxisAlignment, equals(CrossAxisAlignment.start));
      });

      testWidgets('should have row for badges', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testIP));

        final row = find.byType(Row);
        expect(row, findsOneWidget);
      });

      testWidgets('should have proper spacing between elements', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testIP));

        final sizedBoxes = find.byType(SizedBox);
        expect(sizedBoxes, findsNWidgets(2)); // One in row, one between row and text
      });
    });

    group('Text Styling', () {
      testWidgets('should apply correct styling to main text', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testIP));

        final mainTextWidget = find.text('Test intellectual property description');
        expect(mainTextWidget, findsOneWidget);

        final textWidget = tester.widget<Text>(mainTextWidget);
        expect(textWidget.style?.fontSize, equals(14));
        expect(textWidget.style?.height, equals(1.4));
      });

      testWidgets('should apply correct styling to ownership badge text', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testIP));

        final ownershipTextWidget = find.text('CLIENT');
        expect(ownershipTextWidget, findsOneWidget);

        final textWidget = tester.widget<Text>(ownershipTextWidget);
        expect(textWidget.style?.fontSize, equals(10));
        expect(textWidget.style?.fontWeight, equals(FontWeight.w600));
      });
    });

    group('Ownership Color Mapping', () {
      testWidgets('should use correct color for client ownership', (WidgetTester tester) async {
        final clientIP = IntellectualPropertyEntity(
          text: 'Client IP',
          ownership: Ownership.client,
          severity: Severity.low,
        );

        await tester.pumpWidget(createWidget(clientIP));

        // Widget should render without errors
        expect(find.text('CLIENT'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should use correct color for vendor ownership', (WidgetTester tester) async {
        final vendorIP = IntellectualPropertyEntity(
          text: 'Vendor IP',
          ownership: Ownership.vendor,
          severity: Severity.medium,
        );

        await tester.pumpWidget(createWidget(vendorIP));

        expect(find.text('VENDOR'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should use correct color for shared ownership', (WidgetTester tester) async {
        final sharedIP = IntellectualPropertyEntity(
          text: 'Shared IP',
          ownership: Ownership.shared,
          severity: Severity.high,
        );

        await tester.pumpWidget(createWidget(sharedIP));

        expect(find.text('SHARED'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle very long IP text', (WidgetTester tester) async {
        final longTextIP = IntellectualPropertyEntity(
          text:
              'This is a very long intellectual property description that should still be displayed properly within the widget layout without causing any overflow issues or rendering problems',
          ownership: Ownership.client,
          severity: Severity.high,
        );

        await tester.pumpWidget(createWidget(longTextIP));

        expect(find.textContaining('This is a very long intellectual'), findsOneWidget);
        expect(find.byType(SeverityBadge), findsOneWidget);
        expect(find.text('CLIENT'), findsOneWidget);
      });

      testWidgets('should handle empty IP text', (WidgetTester tester) async {
        final emptyTextIP = IntellectualPropertyEntity(text: '', ownership: Ownership.vendor, severity: Severity.low);

        await tester.pumpWidget(createWidget(emptyTextIP));

        expect(find.text(''), findsOneWidget);
        expect(find.text('VENDOR'), findsOneWidget);
        expect(find.byType(SeverityBadge), findsOneWidget);
      });

      testWidgets('should handle special characters in text', (WidgetTester tester) async {
        final specialCharIP = IntellectualPropertyEntity(
          text: 'IP with special chars: @#\$%^&*()_+-={}[]|\\:";\'<>?,./`~',
          ownership: Ownership.shared,
          severity: Severity.critical,
        );

        await tester.pumpWidget(createWidget(specialCharIP));

        expect(find.textContaining('special chars: @#\$%'), findsOneWidget);
        expect(find.text('SHARED'), findsOneWidget);
      });

      testWidgets('should handle single word text', (WidgetTester tester) async {
        final singleWordIP = IntellectualPropertyEntity(
          text: 'Patent',
          ownership: Ownership.client,
          severity: Severity.medium,
        );

        await tester.pumpWidget(createWidget(singleWordIP));

        expect(find.text('Patent'), findsOneWidget);
        expect(find.text('CLIENT'), findsOneWidget);
      });
    });

    group('Widget Integration', () {
      testWidgets('should integrate properly with SeverityBadge', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testIP));

        final severityBadge = find.byType(SeverityBadge);
        expect(severityBadge, findsOneWidget);

        final severityBadgeWidget = tester.widget<SeverityBadge>(severityBadge);
        expect(severityBadgeWidget.severity, equals(testIP.severity));
      });

      testWidgets('should render without errors', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testIP));
        expect(tester.takeException(), isNull);
      });
    });

    group('Comprehensive Ownership Testing', () {
      testWidgets('should display all ownership types correctly', (WidgetTester tester) async {
        final ownershipVariations = [
          (Ownership.client, 'CLIENT'),
          (Ownership.vendor, 'VENDOR'),
          (Ownership.shared, 'SHARED'),
        ];

        for (final (ownership, expectedText) in ownershipVariations) {
          final ipEntity = IntellectualPropertyEntity(
            text: 'Test IP for $expectedText',
            ownership: ownership,
            severity: Severity.medium,
          );

          await tester.pumpWidget(createWidget(ipEntity));

          expect(find.text(expectedText), findsOneWidget);
          expect(find.text('Test IP for $expectedText'), findsOneWidget);
        }
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible to screen readers', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testIP));

        expect(find.text('Test intellectual property description'), findsOneWidget);
        expect(find.text('CLIENT'), findsOneWidget);
      });
    });

    group('State Management', () {
      testWidgets('should handle entity updates correctly', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testIP));

        expect(find.text('Test intellectual property description'), findsOneWidget);
        expect(find.text('CLIENT'), findsOneWidget);

        final newIP = IntellectualPropertyEntity(
          text: 'Updated IP text',
          ownership: Ownership.vendor,
          severity: Severity.high,
        );

        await tester.pumpWidget(createWidget(newIP));

        expect(find.text('Updated IP text'), findsOneWidget);
        expect(find.text('VENDOR'), findsOneWidget);
        expect(find.text('Test intellectual property description'), findsNothing);
        expect(find.text('CLIENT'), findsNothing);
      });
    });

    group('Visual Appearance', () {
      testWidgets('should maintain consistent layout with different combinations', (WidgetTester tester) async {
        final variations = [
          (Ownership.client, Severity.low),
          (Ownership.vendor, Severity.medium),
          (Ownership.shared, Severity.high),
          (Ownership.client, Severity.critical),
        ];

        for (final (ownership, severity) in variations) {
          final ipEntity = IntellectualPropertyEntity(
            text: 'IP for $ownership with $severity',
            ownership: ownership,
            severity: severity,
          );

          await tester.pumpWidget(createWidget(ipEntity));

          expect(find.byType(IntellectualPropertyItemWidget), findsOneWidget);
          expect(find.byType(SeverityBadge), findsOneWidget);
          expect(find.text(ownership.name.toUpperCase()), findsOneWidget);
          expect(tester.takeException(), isNull);
        }
      });
    });
  });
}
