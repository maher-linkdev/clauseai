import 'package:deal_insights_assistant/src/core/enum/severity_enum.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/entity/contract_analysis_result_entity.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/conflict_item_widget.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/severity_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConflictItemWidget', () {
    late ConflictOrContrastEntity testConflict;

    setUp(() {
      testConflict = const ConflictOrContrastEntity(
        text: 'Test conflict description',
        conflictWith: 'Another clause',
        severity: Severity.medium,
      );
    });

    Widget createWidget(ConflictOrContrastEntity conflict) {
      return MaterialApp(
        home: Scaffold(body: ConflictItemWidget(conflict: conflict)),
      );
    }

    group('Constructor and Properties', () {
      testWidgets('should create widget with required parameters', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testConflict));

        expect(find.byType(ConflictItemWidget), findsOneWidget);
        expect(find.byType(SeverityBadge), findsOneWidget);
      });

      testWidgets('should display conflict text', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testConflict));

        expect(find.text('Test conflict description'), findsOneWidget);
      });

      testWidgets('should display severity badge', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testConflict));

        final severityBadge = find.byType(SeverityBadge);
        expect(severityBadge, findsOneWidget);

        final severityBadgeWidget = tester.widget<SeverityBadge>(severityBadge);
        expect(severityBadgeWidget.severity, equals(Severity.medium));
      });
    });

    group('ConflictWith Display', () {
      testWidgets('should display conflict with text when provided', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testConflict));

        expect(find.text('Conflicts with: Another clause'), findsOneWidget);
      });

      testWidgets('should not display conflict with text when null', (WidgetTester tester) async {
        final conflictWithoutRef = ConflictOrContrastEntity(
          text: 'Test conflict',
          conflictWith: null,
          severity: Severity.low,
        );

        await tester.pumpWidget(createWidget(conflictWithoutRef));

        expect(find.textContaining('Conflicts with:'), findsNothing);
        expect(find.text('Test conflict'), findsOneWidget);
      });

      testWidgets('should handle empty conflict with text', (WidgetTester tester) async {
        final conflictWithEmptyRef = ConflictOrContrastEntity(
          text: 'Test conflict',
          conflictWith: '',
          severity: Severity.low,
        );

        await tester.pumpWidget(createWidget(conflictWithEmptyRef));

        expect(find.text('Conflicts with: '), findsOneWidget);
      });
    });

    group('Severity Variations', () {
      testWidgets('should display low severity badge', (WidgetTester tester) async {
        final lowSeverityConflict = ConflictOrContrastEntity(text: 'Low severity conflict', severity: Severity.low);

        await tester.pumpWidget(createWidget(lowSeverityConflict));

        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.low));
      });

      testWidgets('should display medium severity badge', (WidgetTester tester) async {
        final mediumSeverityConflict = ConflictOrContrastEntity(
          text: 'Medium severity conflict',
          severity: Severity.medium,
        );

        await tester.pumpWidget(createWidget(mediumSeverityConflict));

        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.medium));
      });

      testWidgets('should display high severity badge', (WidgetTester tester) async {
        final highSeverityConflict = ConflictOrContrastEntity(text: 'High severity conflict', severity: Severity.high);

        await tester.pumpWidget(createWidget(highSeverityConflict));

        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.high));
      });

      testWidgets('should display critical severity badge', (WidgetTester tester) async {
        final criticalSeverityConflict = ConflictOrContrastEntity(
          text: 'Critical severity conflict',
          severity: Severity.critical,
        );

        await tester.pumpWidget(createWidget(criticalSeverityConflict));

        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.critical));
      });
    });

    group('Layout Structure', () {
      testWidgets('should have correct layout structure', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testConflict));

        final column = find.byType(Column);
        expect(column, findsOneWidget);

        final columnWidget = tester.widget<Column>(column);
        expect(columnWidget.crossAxisAlignment, equals(CrossAxisAlignment.start));
      });

      testWidgets('should have proper spacing between elements', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testConflict));

        final sizedBoxes = find.byType(SizedBox);
        expect(sizedBoxes, findsNWidgets(2)); // One after severity badge, one before conflict with
      });

      testWidgets('should have only one SizedBox when conflictWith is null', (WidgetTester tester) async {
        final conflictWithoutRef = ConflictOrContrastEntity(
          text: 'Test conflict',
          conflictWith: null,
          severity: Severity.low,
        );

        await tester.pumpWidget(createWidget(conflictWithoutRef));

        final sizedBoxes = find.byType(SizedBox);
        expect(sizedBoxes, findsOneWidget); // Only after severity badge
      });
    });

    group('Text Styling', () {
      testWidgets('should apply correct styling to main text', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testConflict));

        final mainTextWidget = find.text('Test conflict description');
        expect(mainTextWidget, findsOneWidget);

        final textWidget = tester.widget<Text>(mainTextWidget);
        expect(textWidget.style?.fontSize, equals(14));
        expect(textWidget.style?.height, equals(1.4));
      });

      testWidgets('should apply correct styling to conflict with text', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testConflict));

        final conflictWithTextWidget = find.text('Conflicts with: Another clause');
        expect(conflictWithTextWidget, findsOneWidget);

        final textWidget = tester.widget<Text>(conflictWithTextWidget);
        expect(textWidget.style?.fontSize, equals(12));
        expect(textWidget.style?.fontStyle, equals(FontStyle.italic));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle very long conflict text', (WidgetTester tester) async {
        final longTextConflict = ConflictOrContrastEntity(
          text:
              'This is a very long conflict description that should still be displayed properly within the widget layout without causing any overflow issues or rendering problems',
          severity: Severity.high,
        );

        await tester.pumpWidget(createWidget(longTextConflict));

        expect(find.textContaining('This is a very long conflict'), findsOneWidget);
        expect(find.byType(SeverityBadge), findsOneWidget);
      });

      testWidgets('should handle very long conflictWith text', (WidgetTester tester) async {
        final longConflictWithConflict = ConflictOrContrastEntity(
          text: 'Short conflict',
          conflictWith: 'This is a very long conflict reference that should still be displayed properly',
          severity: Severity.medium,
        );

        await tester.pumpWidget(createWidget(longConflictWithConflict));

        expect(find.textContaining('Conflicts with: This is a very long'), findsOneWidget);
      });

      testWidgets('should handle empty conflict text', (WidgetTester tester) async {
        final emptyTextConflict = ConflictOrContrastEntity(text: '', severity: Severity.low);

        await tester.pumpWidget(createWidget(emptyTextConflict));

        expect(find.text(''), findsOneWidget);
        expect(find.byType(SeverityBadge), findsOneWidget);
      });

      testWidgets('should handle special characters in text', (WidgetTester tester) async {
        final specialCharConflict = ConflictOrContrastEntity(
          text: 'Conflict with special chars: @#\$%^&*()_+-={}[]|\\:";\'<>?,./`~',
          conflictWith: 'Reference with special chars: !@#\$%',
          severity: Severity.critical,
        );

        await tester.pumpWidget(createWidget(specialCharConflict));

        expect(find.textContaining('special chars: @#\$%'), findsOneWidget);
        expect(find.textContaining('Conflicts with: Reference with special'), findsOneWidget);
      });
    });

    group('Widget Integration', () {
      testWidgets('should integrate properly with SeverityBadge', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testConflict));

        final severityBadge = find.byType(SeverityBadge);
        expect(severityBadge, findsOneWidget);

        // Verify the severity badge receives correct data
        final severityBadgeWidget = tester.widget<SeverityBadge>(severityBadge);
        expect(severityBadgeWidget.severity, equals(testConflict.severity));
      });

      testWidgets('should render without errors', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testConflict));
        expect(tester.takeException(), isNull);
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible to screen readers', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testConflict));

        // Verify text is findable (accessible)
        expect(find.text('Test conflict description'), findsOneWidget);
        expect(find.text('Conflicts with: Another clause'), findsOneWidget);
      });
    });

    group('State Management', () {
      testWidgets('should handle entity updates correctly', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(testConflict));

        expect(find.text('Test conflict description'), findsOneWidget);

        // Update with new conflict
        final newConflict = ConflictOrContrastEntity(
          text: 'Updated conflict text',
          conflictWith: 'Updated reference',
          severity: Severity.high,
        );

        await tester.pumpWidget(createWidget(newConflict));

        expect(find.text('Updated conflict text'), findsOneWidget);
        expect(find.text('Conflicts with: Updated reference'), findsOneWidget);
        expect(find.text('Test conflict description'), findsNothing);
      });
    });

    group('Visual Appearance', () {
      testWidgets('should maintain consistent layout with different content', (WidgetTester tester) async {
        final variations = [
          ConflictOrContrastEntity(text: 'Short', severity: Severity.low),
          ConflictOrContrastEntity(
            text: 'Medium length conflict text',
            conflictWith: 'Reference',
            severity: Severity.medium,
          ),
          ConflictOrContrastEntity(
            text: 'Very long conflict description with lots of details',
            conflictWith: 'Very long reference clause',
            severity: Severity.critical,
          ),
        ];

        for (final variation in variations) {
          await tester.pumpWidget(createWidget(variation));

          expect(find.byType(ConflictItemWidget), findsOneWidget);
          expect(find.byType(SeverityBadge), findsOneWidget);
          expect(tester.takeException(), isNull);
        }
      });
    });
  });
}
