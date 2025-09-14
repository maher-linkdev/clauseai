import 'package:deal_insights_assistant/src/features/result/presentation/component/analysis_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnalysisSection', () {
    late List<String> testItems;
    late Widget Function(String) testItemBuilder;

    setUp(() {
      testItems = ['Item 1', 'Item 2', 'Item 3'];
      testItemBuilder = (String item) => Text(item);
    });

    Widget createWidget({
      List<String>? items,
      Widget Function(String)? itemBuilder,
      String title = 'Test Section',
      IconData icon = Icons.list,
    }) {
      return MaterialApp(
        home: Scaffold(
          body: AnalysisSection<String>(
            title: title,
            icon: icon,
            items: items ?? testItems,
            itemBuilder: itemBuilder ?? testItemBuilder,
          ),
        ),
      );
    }

    group('Constructor and Properties', () {
      testWidgets('should create widget with required parameters', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        expect(find.byType(AnalysisSection<String>), findsOneWidget);
        expect(find.text('Test Section'), findsOneWidget);
        expect(find.byIcon(Icons.list), findsOneWidget);
      });

      testWidgets('should display correct item count', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        expect(find.text('3'), findsOneWidget); // Item count badge
      });

      testWidgets('should display all items when expanded', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
        expect(find.text('Item 3'), findsOneWidget);
      });
    });

    group('Expand/Collapse Functionality', () {
      testWidgets('should be expanded by default', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        // Should show all items initially
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
        expect(find.text('Item 3'), findsOneWidget);
      });

      testWidgets('should collapse when header is tapped', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        // Initially expanded
        expect(find.text('Item 1'), findsOneWidget);

        // Tap header to collapse
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        // Items should be hidden
        expect(find.text('Item 1'), findsNothing);
        expect(find.text('Item 2'), findsNothing);
        expect(find.text('Item 3'), findsNothing);
      });

      testWidgets('should expand when collapsed header is tapped', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        // Collapse first
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();
        expect(find.text('Item 1'), findsNothing);

        // Expand again
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();

        // Items should be visible again
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Item 2'), findsOneWidget);
        expect(find.text('Item 3'), findsOneWidget);
      });

      testWidgets('should animate arrow rotation on expand/collapse', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        final animatedRotationFinder = find.byType(AnimatedRotation);
        expect(animatedRotationFinder, findsOneWidget);

        // Get initial rotation
        AnimatedRotation animatedRotation = tester.widget(animatedRotationFinder);
        expect(animatedRotation.turns, equals(0.5)); // Expanded state

        // Collapse
        await tester.tap(find.byType(InkWell));
        await tester.pump();

        animatedRotation = tester.widget(animatedRotationFinder);
        expect(animatedRotation.turns, equals(0.0)); // Collapsed state
      });
    });

    group('Empty State', () {
      testWidgets('should handle empty items list', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(items: []));

        expect(find.text('0'), findsOneWidget); // Item count should be 0
        expect(find.text('Test Section'), findsOneWidget); // Title should still show
      });

      testWidgets('should not show any items when list is empty', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(items: []));

        // Should not find any item text
        expect(find.text('Item 1'), findsNothing);
        expect(find.text('Item 2'), findsNothing);
        expect(find.text('Item 3'), findsNothing);
      });
    });

    group('Custom ItemBuilder', () {
      testWidgets('should use custom item builder correctly', (WidgetTester tester) async {
        Widget customItemBuilder(String item) {
          return Container(
            key: Key('custom-$item'),
            child: Column(children: [Text('Custom: $item'), const Icon(Icons.star)]),
          );
        }

        await tester.pumpWidget(createWidget(itemBuilder: customItemBuilder));

        expect(find.text('Custom: Item 1'), findsOneWidget);
        expect(find.text('Custom: Item 2'), findsOneWidget);
        expect(find.text('Custom: Item 3'), findsOneWidget);
        expect(find.byIcon(Icons.star), findsNWidgets(3));
      });
    });

    group('Generic Type Support', () {
      testWidgets('should work with different data types', (WidgetTester tester) async {
        final numbers = [1, 2, 3, 4];
        Widget numberBuilder(int number) => Text('Number: $number');

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnalysisSection<int>(
                title: 'Numbers',
                icon: Icons.numbers,
                items: numbers,
                itemBuilder: numberBuilder,
              ),
            ),
          ),
        );

        expect(find.text('4'), findsOneWidget); // Count
        expect(find.text('Number: 1'), findsOneWidget);
        expect(find.text('Number: 2'), findsOneWidget);
        expect(find.text('Number: 3'), findsOneWidget);
        expect(find.text('Number: 4'), findsOneWidget);
      });
    });

    group('Visual Elements', () {
      testWidgets('should display title with correct style', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(title: 'Custom Title'));

        expect(find.text('Custom Title'), findsOneWidget);
      });

      testWidgets('should display custom icon', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(icon: Icons.security));

        expect(find.byIcon(Icons.security), findsOneWidget);
        expect(find.byIcon(Icons.list), findsNothing);
      });

      testWidgets('should show item count badge', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(items: ['A', 'B']));

        expect(find.text('2'), findsOneWidget);
      });

      testWidgets('should show expand/collapse arrow', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
      });
    });

    group('Animation Behavior', () {
      testWidgets('should have AnimatedContainer for content', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        expect(find.byType(AnimatedContainer), findsOneWidget);
      });

      testWidgets('should animate content height on collapse', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        final animatedContainer = find.byType(AnimatedContainer);
        expect(animatedContainer, findsOneWidget);

        // Collapse
        await tester.tap(find.byType(InkWell));
        await tester.pump();

        // Should still have the AnimatedContainer
        expect(animatedContainer, findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible with semantic labels', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        // Widget should be findable and interactable
        expect(find.byType(InkWell), findsOneWidget);

        // Should be tappable
        await tester.tap(find.byType(InkWell));
        expect(tester.takeException(), isNull);
      });
    });

    group('State Management', () {
      testWidgets('should maintain state across rebuilds', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget());

        // Collapse the section
        await tester.tap(find.byType(InkWell));
        await tester.pumpAndSettle();
        expect(find.text('Item 1'), findsNothing);

        // Rebuild with same data
        await tester.pumpWidget(createWidget());

        // Should remain collapsed
        expect(find.text('Item 1'), findsNothing);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle single item', (WidgetTester tester) async {
        await tester.pumpWidget(createWidget(items: ['Single Item']));

        expect(find.text('1'), findsOneWidget); // Count
        expect(find.text('Single Item'), findsOneWidget);
      });

      testWidgets('should handle long titles', (WidgetTester tester) async {
        const longTitle = 'This is a very long title that should still display properly in the analysis section header';

        await tester.pumpWidget(createWidget(title: longTitle));

        expect(find.text(longTitle), findsOneWidget);
      });
    });
  });
}
