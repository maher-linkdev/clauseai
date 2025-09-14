import 'package:deal_insights_assistant/src/core/constants/colors_palette.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/animated_circular_percentage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnimatedCircularPercentage', () {
    Widget createWidget({
      double percentage = 0.75,
      double size = 40.0,
      Color? progressColor,
      Color? backgroundColor,
      double strokeWidth = 3.0,
      Duration animationDuration = const Duration(milliseconds: 1500),
      bool showPercentageText = true,
      TextStyle? textStyle,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: AnimatedCircularPercentage(
            percentage: percentage,
            size: size,
            progressColor: progressColor,
            backgroundColor: backgroundColor,
            strokeWidth: strokeWidth,
            animationDuration: animationDuration,
            showPercentageText: showPercentageText,
            textStyle: textStyle,
          ),
        ),
      );
    }

    Future<void> pumpWidgetAndWait(WidgetTester tester, Widget widget) async {
      await tester.pumpWidget(widget);
      // Wait for the 100ms delay in initState
      await tester.pump(const Duration(milliseconds: 100));
      // Additional pump to ensure animation starts
      await tester.pump();
    }

    group('Constructor and Properties', () {
      testWidgets('should create widget with default parameters', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget());

        expect(find.byType(AnimatedCircularPercentage), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNWidgets(2)); // Background + progress
      });

      testWidgets('should display percentage text by default', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget(percentage: 0.85));

        // Should show percentage text (will be animated, so might not be exact)
        expect(find.textContaining('%'), findsOneWidget);
      });

      testWidgets('should respect custom size', (WidgetTester tester) async {
        const customSize = 60.0;
        await pumpWidgetAndWait(tester, createWidget(size: customSize));

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.width, equals(customSize));
        expect(sizedBox.height, equals(customSize));
      });

      testWidgets('should hide percentage text when showPercentageText is false', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget(showPercentageText: false));

        await tester.pump(const Duration(milliseconds: 200));

        expect(find.textContaining('%'), findsNothing);
      });
    });

    group('Animation Behavior', () {
      testWidgets('should animate from 0 to target percentage', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget(percentage: 0.8));

        // Initially should be at or near 0
        await tester.pump(const Duration(milliseconds: 50));

        final initialText = tester.widget<Text>(find.textContaining('%'));
        final initialValue = int.parse(initialText.data!.replaceAll('%', ''));
        expect(initialValue, lessThanOrEqualTo(10)); // Should be low initially

        // After animation time, should be closer to target
        await tester.pump(const Duration(milliseconds: 1600));

        expect(find.text('80%'), findsOneWidget);
      });

      testWidgets('should update animation when percentage changes', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget(percentage: 0.5));

        // Wait for initial animation
        await tester.pump(const Duration(milliseconds: 1600));
        expect(find.text('50%'), findsOneWidget);

        // Change percentage
        await pumpWidgetAndWait(tester, createWidget(percentage: 0.9));

        // Wait for new animation
        await tester.pump(const Duration(milliseconds: 1600));
        expect(find.text('90%'), findsOneWidget);
      });

      testWidgets('should have proper animation duration', (WidgetTester tester) async {
        const customDuration = Duration(milliseconds: 500);
        await pumpWidgetAndWait(tester, createWidget(percentage: 0.6, animationDuration: customDuration));

        // Should complete faster with shorter duration
        await tester.pump(const Duration(milliseconds: 600));
        expect(find.text('60%'), findsOneWidget);
      });
    });

    group('Color Logic', () {
      testWidgets('should use success color for high percentages (≥80%)', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget(percentage: 0.85));

        await tester.pump(const Duration(milliseconds: 1600));

        final progressIndicators = tester.widgetList<CircularProgressIndicator>(find.byType(CircularProgressIndicator));

        // Find the progress indicator (not background)
        final progressIndicator = progressIndicators.firstWhere((indicator) => indicator.value != 1.0);

        expect(progressIndicator.valueColor?.value, equals(ColorsPalette.success));
      });

      testWidgets('should use primary color for medium-high percentages (≥60%)', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget(percentage: 0.7));

        await tester.pump(const Duration(milliseconds: 1600));

        final progressIndicators = tester.widgetList<CircularProgressIndicator>(find.byType(CircularProgressIndicator));

        final progressIndicator = progressIndicators.firstWhere((indicator) => indicator.value != 1.0);

        expect(progressIndicator.valueColor?.value, equals(ColorsPalette.primary));
      });

      testWidgets('should use warning color for medium percentages (≥40%)', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget(percentage: 0.5));

        await tester.pump(const Duration(milliseconds: 1600));

        final progressIndicators = tester.widgetList<CircularProgressIndicator>(find.byType(CircularProgressIndicator));

        final progressIndicator = progressIndicators.firstWhere((indicator) => indicator.value != 1.0);

        expect(progressIndicator.valueColor?.value, equals(ColorsPalette.warning));
      });

      testWidgets('should use error color for low percentages (<40%)', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget(percentage: 0.2));

        await tester.pump(const Duration(milliseconds: 1600));

        final progressIndicators = tester.widgetList<CircularProgressIndicator>(find.byType(CircularProgressIndicator));

        final progressIndicator = progressIndicators.firstWhere((indicator) => indicator.value != 1.0);

        expect(progressIndicator.valueColor?.value, equals(ColorsPalette.error));
      });

      testWidgets('should respect custom progress color', (WidgetTester tester) async {
        const customColor = Colors.purple;
        await pumpWidgetAndWait(tester, createWidget(percentage: 0.5, progressColor: customColor));

        await tester.pump(const Duration(milliseconds: 1600));

        final progressIndicators = tester.widgetList<CircularProgressIndicator>(find.byType(CircularProgressIndicator));

        final progressIndicator = progressIndicators.firstWhere((indicator) => indicator.value != 1.0);

        expect(progressIndicator.valueColor?.value, equals(customColor));
      });

      testWidgets('should respect custom background color', (WidgetTester tester) async {
        const customBgColor = Colors.red;
        await pumpWidgetAndWait(tester, createWidget(backgroundColor: customBgColor));

        final progressIndicators = tester.widgetList<CircularProgressIndicator>(find.byType(CircularProgressIndicator));

        final backgroundIndicator = progressIndicators.firstWhere((indicator) => indicator.value == 1.0);

        expect(backgroundIndicator.valueColor?.value, equals(customBgColor));
      });
    });

    group('Text Styling', () {
      testWidgets('should use custom text style when provided', (WidgetTester tester) async {
        const customTextStyle = TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red);

        await pumpWidgetAndWait(tester, createWidget(percentage: 0.5, textStyle: customTextStyle));

        await tester.pump(const Duration(milliseconds: 1600));

        final text = tester.widget<Text>(find.textContaining('%'));
        expect(text.style?.fontSize, equals(12));
        expect(text.style?.fontWeight, equals(FontWeight.bold));
        expect(text.style?.color, equals(Colors.red));
      });

      testWidgets('should calculate font size based on widget size when no custom style', (WidgetTester tester) async {
        const widgetSize = 80.0;
        await pumpWidgetAndWait(tester, createWidget(percentage: 0.5, size: widgetSize));

        await tester.pump(const Duration(milliseconds: 1600));

        final text = tester.widget<Text>(find.textContaining('%'));
        expect(text.style?.fontSize, equals(widgetSize * 0.25)); // 20.0
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle 0% correctly', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget(percentage: 0.0));

        await tester.pump(const Duration(milliseconds: 1600));

        expect(find.text('0%'), findsOneWidget);
      });

      testWidgets('should handle 100% correctly', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget(percentage: 1.0));

        await tester.pump(const Duration(milliseconds: 1600));

        expect(find.text('100%'), findsOneWidget);
      });

      testWidgets('should handle values above 1.0', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget(percentage: 1.2));

        await tester.pump(const Duration(milliseconds: 1600));

        expect(find.text('120%'), findsOneWidget);
      });

      testWidgets('should handle very small stroke width', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget(strokeWidth: 0.5));

        expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
        // Should not crash
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle very large stroke width', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget(strokeWidth: 20.0));

        expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
        // Should not crash
        expect(tester.takeException(), isNull);
      });
    });

    group('Widget Lifecycle', () {
      testWidgets('should properly dispose animation controller', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget());

        // Widget should be created without errors
        expect(find.byType(AnimatedCircularPercentage), findsOneWidget);

        // Remove widget
        await tester.pumpWidget(const MaterialApp(home: Scaffold(body: SizedBox())));

        // Should dispose without errors
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle widget updates correctly', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget(percentage: 0.3));
        await tester.pump(const Duration(milliseconds: 1600));

        // Update with different percentage
        await pumpWidgetAndWait(tester, createWidget(percentage: 0.8));
        await tester.pump(const Duration(milliseconds: 1600));

        expect(find.text('80%'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible for screen readers', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget(percentage: 0.65));

        await tester.pump(const Duration(milliseconds: 1600));

        // Text should be readable by screen readers
        expect(find.text('65%'), findsOneWidget);
      });
    });

    group('Stack Layout', () {
      testWidgets('should contain background and progress indicators', (WidgetTester tester) async {
        await pumpWidgetAndWait(tester, createWidget());

        // Should have exactly 2 CircularProgressIndicators
        expect(find.byType(CircularProgressIndicator), findsNWidgets(2));
      });
    });
  });
}
