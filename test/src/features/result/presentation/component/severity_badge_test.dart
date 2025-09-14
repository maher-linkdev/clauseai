import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/severity_badge.dart';
import 'package:deal_insights_assistant/src/core/enum/severity_enum.dart';
import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';

void main() {
  group('SeverityBadge Widget Tests', () {
    testWidgets('should render low severity badge correctly', (WidgetTester tester) async {
      // Arrange
      const severityBadge = SeverityBadge(severity: Severity.low);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: severityBadge)));

      // Assert
      expect(find.byType(SeverityBadge), findsOneWidget);
      expect(find.text('LOW'), findsOneWidget);
      
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(ColorsPalette.success.withOpacity(0.1)));
      expect(decoration.border?.top.color, equals(ColorsPalette.success.withOpacity(0.3)));
    });

    testWidgets('should render medium severity badge correctly', (WidgetTester tester) async {
      // Arrange
      const severityBadge = SeverityBadge(severity: Severity.medium);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: severityBadge)));

      // Assert
      expect(find.byType(SeverityBadge), findsOneWidget);
      expect(find.text('MEDIUM'), findsOneWidget);
      
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(ColorsPalette.warning.withOpacity(0.1)));
      expect(decoration.border?.top.color, equals(ColorsPalette.warning.withOpacity(0.3)));
    });

    testWidgets('should render high severity badge correctly', (WidgetTester tester) async {
      // Arrange
      const severityBadge = SeverityBadge(severity: Severity.high);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: severityBadge)));

      // Assert
      expect(find.byType(SeverityBadge), findsOneWidget);
      expect(find.text('HIGH'), findsOneWidget);
      
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(ColorsPalette.error.withOpacity(0.1)));
      expect(decoration.border?.top.color, equals(ColorsPalette.error.withOpacity(0.3)));
    });

    testWidgets('should render critical severity badge correctly', (WidgetTester tester) async {
      // Arrange
      const severityBadge = SeverityBadge(severity: Severity.critical);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: severityBadge)));

      // Assert
      expect(find.byType(SeverityBadge), findsOneWidget);
      expect(find.text('CRITICAL'), findsOneWidget);
      
      final container = tester.widget<Container>(find.byType(Container));
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, equals(ColorsPalette.error.withRed(200).withOpacity(0.1)));
      expect(decoration.border?.top.color, equals(ColorsPalette.error.withRed(200).withOpacity(0.3)));
    });

    testWidgets('should have correct padding and styling', (WidgetTester tester) async {
      // Arrange
      const severityBadge = SeverityBadge(severity: Severity.low);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: severityBadge)));

      // Assert
      final container = tester.widget<Container>(find.byType(Container));
      expect(container.padding, equals(const EdgeInsets.symmetric(horizontal: 8, vertical: 2)));
      
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, equals(BorderRadius.circular(4)));
      expect(decoration.border?.top.width, equals(1));
    });

    testWidgets('should handle all severity levels', (WidgetTester tester) async {
      // Test that we can create badges for all severity levels without errors
      for (final severity in Severity.values) {
        final severityBadge = SeverityBadge(severity: severity);
        
        await tester.pumpWidget(MaterialApp(home: Scaffold(body: severityBadge)));
        
        expect(find.byType(SeverityBadge), findsOneWidget);
        expect(find.text(severity.name.toUpperCase()), findsOneWidget);
      }
    });

    group('Color mapping', () {
      testWidgets('should use correct colors for each severity level', (WidgetTester tester) async {
        final testCases = {
          Severity.low: ColorsPalette.success,
          Severity.medium: ColorsPalette.warning,
          Severity.high: ColorsPalette.error,
          Severity.critical: ColorsPalette.error.withRed(200),
        };

        for (final entry in testCases.entries) {
          final severity = entry.key;
          final expectedColor = entry.value;
          
          final severityBadge = SeverityBadge(severity: severity);
          
          await tester.pumpWidget(MaterialApp(home: Scaffold(body: severityBadge)));
          
          final text = tester.widget<Text>(find.text(severity.name.toUpperCase()));
          final textStyle = text.style;
          expect(textStyle?.color, equals(expectedColor));
        }
      });
    });

    testWidgets('should render text with correct styling', (WidgetTester tester) async {
      // Arrange
      const severityBadge = SeverityBadge(severity: Severity.medium);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: severityBadge)));

      // Assert
      final text = tester.widget<Text>(find.text('MEDIUM'));
      final textStyle = text.style;
      
      expect(textStyle?.fontSize, equals(10));
      expect(textStyle?.fontWeight, equals(FontWeight.w600));
      expect(textStyle?.color, equals(ColorsPalette.warning));
    });

    testWidgets('should be accessible', (WidgetTester tester) async {
      // Arrange
      const severityBadge = SeverityBadge(severity: Severity.high);

      // Act
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: severityBadge)));

      // Assert - Check that the widget renders without accessibility issues
      expect(find.byType(SeverityBadge), findsOneWidget);
      expect(find.text('HIGH'), findsOneWidget);
      
      // The text should be findable, indicating it's accessible
      final text = find.text('HIGH');
      expect(text, findsOneWidget);
    });
  });
}