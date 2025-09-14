import 'package:deal_insights_assistant/src/features/result/presentation/component/result_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

void main() {
  group('ResultHeader', () {
    bool backPressed = false;
    bool newAnalysisPressed = false;

    setUp(() {
      backPressed = false;
      newAnalysisPressed = false;
    });

    Widget createWidget({String? fileName, bool isDesktop = false}) {
      return MaterialApp(
        home: Scaffold(
          body: ResultHeader(
            fileName: fileName,
            onBackPressed: () => backPressed = true,
            onNewAnalysis: () => newAnalysisPressed = true,
            isDesktop: isDesktop,
          ),
        ),
      );
    }

    group('Constructor and Properties', () {
      testWidgets('should create widget with required parameters', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        expect(find.byType(ResultHeader), findsOneWidget);
        expect(find.text('Contract Analysis Complete'), findsOneWidget);
      });

      testWidgets('should display custom filename when provided', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(fileName: 'test_contract.pdf'));

        expect(find.text('test_contract.pdf'), findsOneWidget);
      });

      testWidgets('should display default text when filename is null', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(fileName: null));

        expect(find.text('Document Analysis'), findsOneWidget);
      });
    });

    group('Desktop Layout', () {
      testWidgets('should display desktop layout when isDesktop is true', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(isDesktop: true));

        expect(find.byType(ResultHeader), findsOneWidget);
        expect(find.text('Contract Analysis Complete'), findsOneWidget);
        expect(
          find.text(
            'AI-powered analysis has identified key contract elements. Review each section for detailed insights.',
          ),
          findsOneWidget,
        );
      });

      testWidgets('should not show back button in desktop layout', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(isDesktop: true));

        expect(find.byType(IconButton), findsNothing);
      });

      testWidgets('should not show new analysis button in desktop layout', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(isDesktop: true));

        expect(find.byType(ElevatedButton), findsNothing);
        expect(find.text('New Analysis'), findsNothing);
      });

      testWidgets('should display file icon in desktop layout', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(isDesktop: true));

        final icons = tester.widgetList<Icon>(find.byType(Icon));
        expect(icons.any((icon) => icon.icon == PhosphorIcons.fileText(PhosphorIconsStyle.duotone)), isTrue);
        expect(icons.any((icon) => icon.icon == PhosphorIcons.info(PhosphorIconsStyle.regular)), isTrue);
      });

      testWidgets('should have proper container decoration in desktop layout', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(isDesktop: true));

        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers.length, greaterThan(0));

        // Main container should have gradient and border
        final mainContainer = containers.first;
        expect(mainContainer.decoration, isA<BoxDecoration>());
        final decoration = mainContainer.decoration as BoxDecoration;
        expect(decoration.gradient, isA<LinearGradient>());
        expect(decoration.border, isNotNull);
        expect(decoration.borderRadius, isNotNull);
      });
    });

    group('Mobile Layout', () {
      testWidgets('should display mobile layout when isDesktop is false', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(isDesktop: false));

        expect(find.byType(ResultHeader), findsOneWidget);
        expect(find.text('Contract Analysis Complete'), findsOneWidget);
        expect(
          find.text(
            'AI-powered analysis has identified key contract elements. Review each section for detailed insights.',
          ),
          findsOneWidget,
        );
      });

      testWidgets('should show back button in mobile layout', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(isDesktop: false));

        expect(find.byType(IconButton), findsOneWidget);

        final iconButton = tester.widget<IconButton>(find.byType(IconButton));
        final icon = iconButton.icon as Icon;
        expect(icon.icon, equals(PhosphorIcons.arrowLeft()));
      });

      testWidgets('should display all icons in mobile layout', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(isDesktop: false));

        final icons = tester.widgetList<Icon>(find.byType(Icon));
        expect(icons.any((icon) => icon.icon == PhosphorIcons.fileText(PhosphorIconsStyle.duotone)), isTrue);
        expect(icons.any((icon) => icon.icon == PhosphorIcons.info(PhosphorIconsStyle.regular)), isTrue);
        expect(icons.any((icon) => icon.icon == PhosphorIcons.arrowLeft()), isTrue);
        expect(icons.any((icon) => icon.icon == PhosphorIcons.plus()), isTrue);
      });

      testWidgets('should have proper container decoration in mobile layout', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(isDesktop: false));

        final containers = tester.widgetList<Container>(find.byType(Container));
        expect(containers.length, greaterThan(0));

        // Main container should have gradient and border
        final mainContainer = containers.first;
        expect(mainContainer.decoration, isA<BoxDecoration>());
        final decoration = mainContainer.decoration as BoxDecoration;
        expect(decoration.gradient, isA<LinearGradient>());
        expect(decoration.border, isNotNull);
        expect(decoration.borderRadius, isNotNull);
      });
    });

    group('Button Interactions', () {
      testWidgets('should call onBackPressed when back button is tapped', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(isDesktop: false));

        expect(backPressed, isFalse);

        await tester.tap(find.byType(IconButton));
        await tester.pumpAndSettle();

        expect(backPressed, isTrue);
      });
    });

    group('Text Content', () {
      testWidgets('should display correct main title', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        expect(find.text('Contract Analysis Complete'), findsOneWidget);
      });

      testWidgets('should display correct info text', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        expect(
          find.text(
            'AI-powered analysis has identified key contract elements. Review each section for detailed insights.',
          ),
          findsOneWidget,
        );
      });

      testWidgets('should display new analysis button text', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(isDesktop: false));

        expect(find.text('New Analysis'), findsOneWidget);
      });

      testWidgets('should handle long filenames correctly', (WidgetTester tester) async {
        const longFileName = 'very_long_contract_filename_that_should_still_display_properly.pdf';
        await tester.pumpWidget(createWidget(fileName: longFileName));

        expect(find.text(longFileName), findsOneWidget);
      });

      testWidgets('should handle filenames with special characters', (WidgetTester tester) async {
        const specialFileName = 'contract_v2.1_final(2023).pdf';
        await tester.pumpWidget(createWidget(fileName: specialFileName));

        expect(find.text(specialFileName), findsOneWidget);
      });

      testWidgets('should handle empty filename string', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(fileName: ''));

        expect(find.text(''), findsOneWidget);
      });
    });

    group('Layout Structure', () {
      testWidgets('should have correct number of containers', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(isDesktop: false));

        final containers = find.byType(Container);
        expect(containers, findsNWidgets(3)); // Main container, icon container, info container
      });

      testWidgets('should have proper spacing elements', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.length, greaterThan(0));

        // Check for specific spacing values
        expect(sizedBoxes.any((box) => box.width == 20), isTrue); // Icon spacing
        expect(sizedBoxes.any((box) => box.width == 12), isTrue); // Info icon spacing
        expect(sizedBoxes.any((box) => box.height == 8), isTrue); // Title spacing
        expect(sizedBoxes.any((box) => box.height == 24), isTrue); // Section spacing
      });

      testWidgets('should have expanded widgets for proper flex layout', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        expect(find.byType(Expanded), findsNWidgets(2)); // Main content and info text
      });
    });

    group('Theme Integration', () {
      testWidgets('should use theme text styles', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        final textWidgets = tester.widgetList<Text>(find.byType(Text));
        expect(textWidgets.length, greaterThan(0));

        // All text widgets should have styles applied
        for (final text in textWidgets) {
          expect(text.style, isNotNull);
        }
      });

      testWidgets('should respond to theme changes', (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.light(),
            home: Scaffold(
              body: ResultHeader(
                fileName: 'test.pdf',
                onBackPressed: () => backPressed = true,
                onNewAnalysis: () => newAnalysisPressed = true,
                isDesktop: false,
              ),
            ),
          ),
        );

        expect(find.byType(ResultHeader), findsOneWidget);
        expect(find.text('Contract Analysis Complete'), findsOneWidget);
      });
    });

    group('Button Styling', () {
      testWidgets('should have proper icon button styling in mobile layout', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(isDesktop: false));

        final iconButton = tester.widget<IconButton>(find.byType(IconButton));
        expect(iconButton.style, isNotNull);
      });
    });

    group('Icon Display', () {
      testWidgets('should display file text icon with correct style', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        final icons = tester.widgetList<Icon>(find.byType(Icon));
        final fileIcon = icons.firstWhere((icon) => icon.icon == PhosphorIcons.fileText(PhosphorIconsStyle.duotone));

        expect(fileIcon.size, equals(32));
      });

      testWidgets('should display info icon with correct style', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        final icons = tester.widgetList<Icon>(find.byType(Icon));
        final infoIcon = icons.firstWhere((icon) => icon.icon == PhosphorIcons.info(PhosphorIconsStyle.regular));

        expect(infoIcon.size, equals(20));
      });

      testWidgets('should display arrow left icon in mobile layout', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(isDesktop: false));

        final icons = tester.widgetList<Icon>(find.byType(Icon));
        final arrowIcon = icons.firstWhere((icon) => icon.icon == PhosphorIcons.arrowLeft());

        expect(arrowIcon.size, equals(20));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null filename gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(fileName: null));

        expect(find.text('Document Analysis'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle very long filenames without overflow', (WidgetTester tester) async {
        const veryLongFileName =
            'this_is_an_extremely_long_filename_that_could_potentially_cause_layout_issues_if_not_handled_properly_contract_analysis_document_final_version_2023.pdf';
        await tester.pumpWidget(createWidget(fileName: veryLongFileName));

        expect(find.textContaining(veryLongFileName), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible in desktop layout', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(fileName: 'test.pdf', isDesktop: true));

        // All text should be findable
        expect(find.text('Contract Analysis Complete'), findsOneWidget);
        expect(find.text('test.pdf'), findsOneWidget);
        expect(
          find.text(
            'AI-powered analysis has identified key contract elements. Review each section for detailed insights.',
          ),
          findsOneWidget,
        );

        // Desktop layout should not have interactive buttons
        expect(find.byType(IconButton), findsNothing);
        expect(find.byType(ElevatedButton), findsNothing);

        // No exceptions should occur
        expect(tester.takeException(), isNull);
      });
    });
  });
}
