import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/payment_term_item_widget.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/severity_badge.dart';
import 'package:deal_insights_assistant/src/features/result/presentation/component/animated_circular_percentage.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/entity/contract_analysis_result_entity.dart';
import 'package:deal_insights_assistant/src/core/enum/severity_enum.dart';

void main() {
  group('PaymentTermItemWidget', () {
    late PaymentTermEntity testPaymentTerm;
    late PaymentTermEntity paymentTermWithAmount;
    late PaymentTermEntity paymentTermWithoutAmount;
    late PaymentTermEntity paymentTermWithDue;
    late PaymentTermEntity paymentTermWithoutDue;

    setUp(() {
      testPaymentTerm = const PaymentTermEntity(
        text: 'Payment due within 30 days of invoice receipt',
        amount: 10000.50,
        currency: 'USD',
        dueInDays: 30,
        severity: Severity.medium,
        confidence: 0.85,
      );

      paymentTermWithAmount = const PaymentTermEntity(
        text: 'Monthly subscription fee',
        amount: 99.99,
        currency: 'EUR',
        dueInDays: null,
        severity: Severity.low,
        confidence: 0.92,
      );

      paymentTermWithoutAmount = const PaymentTermEntity(
        text: 'Payment terms to be negotiated',
        amount: null,
        currency: null,
        dueInDays: 45,
        severity: Severity.high,
        confidence: 0.78,
      );

      paymentTermWithDue = const PaymentTermEntity(
        text: 'First milestone payment',
        amount: 5000.0,
        currency: 'GBP',
        dueInDays: 15,
        severity: Severity.critical,
        confidence: 0.96,
      );

      paymentTermWithoutDue = const PaymentTermEntity(
        text: 'Final payment on completion',
        amount: 25000.0,
        currency: 'USD',
        dueInDays: null,
        severity: Severity.low,
        confidence: 0.89,
      );
    });

    Widget createWidget(PaymentTermEntity paymentTerm) {
      return MaterialApp(
        home: Scaffold(
          body: PaymentTermItemWidget(paymentTerm: paymentTerm),
        ),
      );
    }

    Future<void> pumpWidgetAndSettle(WidgetTester tester, PaymentTermEntity paymentTerm) async {
      await tester.pumpWidget(createWidget(paymentTerm));
      await tester.pumpAndSettle();
    }

    group('Constructor and Properties', () {
      testWidgets('should create widget with payment term entity', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        expect(find.byType(PaymentTermItemWidget), findsOneWidget);
        expect(find.text('Payment due within 30 days of invoice receipt'), findsOneWidget);
      });

      testWidgets('should display all required components', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        expect(find.byType(SeverityBadge), findsOneWidget);
        expect(find.byType(AnimatedCircularPercentage), findsOneWidget);
        expect(find.text('Payment due within 30 days of invoice receipt'), findsOneWidget);
      });
    });

    group('Severity Badge Display', () {
      testWidgets('should display severity badge with correct severity', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.medium));
      });

      testWidgets('should display high severity correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, paymentTermWithoutAmount);
        
        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.high));
      });

      testWidgets('should display critical severity correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, paymentTermWithDue);
        
        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.critical));
      });

      testWidgets('should display low severity correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, paymentTermWithoutDue);
        
        final severityBadge = tester.widget<SeverityBadge>(find.byType(SeverityBadge));
        expect(severityBadge.severity, equals(Severity.low));
      });
    });

    group('Amount and Currency Display', () {
      testWidgets('should display amount and currency when both are present', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        expect(find.text('USD 10000.50'), findsOneWidget);
      });

      testWidgets('should display EUR currency correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, paymentTermWithAmount);
        
        expect(find.text('EUR 99.99'), findsOneWidget);
      });

      testWidgets('should display GBP currency correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, paymentTermWithDue);
        
        expect(find.text('GBP 5000.00'), findsOneWidget);
      });

      testWidgets('should not display amount when null', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, paymentTermWithoutAmount);
        
        expect(find.textContaining('USD'), findsNothing);
        expect(find.textContaining('EUR'), findsNothing);
        expect(find.textContaining('GBP'), findsNothing);
      });

      testWidgets('should not display currency when null', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, paymentTermWithoutAmount);
        
        expect(find.textContaining('USD'), findsNothing);
        expect(find.textContaining('EUR'), findsNothing);
      });

      testWidgets('should format decimal amounts correctly', (WidgetTester tester) async {
        final decimalPayment = testPaymentTerm.copyWith(amount: 1234.56);
        await pumpWidgetAndSettle(tester, decimalPayment);
        
        expect(find.text('USD 1234.56'), findsOneWidget);
      });

      testWidgets('should format whole number amounts correctly', (WidgetTester tester) async {
        final wholeNumberPayment = testPaymentTerm.copyWith(amount: 5000.0);
        await pumpWidgetAndSettle(tester, wholeNumberPayment);
        
        expect(find.text('USD 5000.00'), findsOneWidget);
      });
    });

    group('Payment Term Text Display', () {
      testWidgets('should display payment term text correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        expect(find.text('Payment due within 30 days of invoice receipt'), findsOneWidget);
      });

      testWidgets('should display long payment term text correctly', (WidgetTester tester) async {
        final longTextPayment = testPaymentTerm.copyWith(
          text: 'This is a very long payment term description that includes specific conditions, penalties for late payment, and detailed instructions for processing the payment according to the contract specifications.',
        );
        await pumpWidgetAndSettle(tester, longTextPayment);
        
        expect(find.textContaining('This is a very long payment term'), findsOneWidget);
      });

      testWidgets('should display text with special characters correctly', (WidgetTester tester) async {
        final specialCharPayment = testPaymentTerm.copyWith(
          text: 'Payment due @ 30 days (net/30) - 2% discount if paid within 10 days',
        );
        await pumpWidgetAndSettle(tester, specialCharPayment);
        
        expect(find.text('Payment due @ 30 days (net/30) - 2% discount if paid within 10 days'), findsOneWidget);
      });
    });

    group('Confidence Display', () {
      testWidgets('should display confidence percentage correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(0.85));
        expect(percentageWidget.size, equals(24));
      });

      testWidgets('should display high confidence correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, paymentTermWithDue);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(0.96));
      });

      testWidgets('should display low confidence correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, paymentTermWithoutAmount);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(0.78));
      });

      testWidgets('should have correct size for confidence display', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.size, equals(24));
        expect(percentageWidget.textStyle?.fontSize, equals(8));
      });
    });

    group('Due Date Display', () {
      testWidgets('should display due date when present', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        expect(find.text('Due in 30 days • '), findsOneWidget);
      });

      testWidgets('should display different due dates correctly', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, paymentTermWithDue);
        
        expect(find.text('Due in 15 days • '), findsOneWidget);
      });

      testWidgets('should not display due date when null', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, paymentTermWithoutDue);
        
        expect(find.textContaining('Due in'), findsNothing);
      });

      testWidgets('should handle zero days correctly', (WidgetTester tester) async {
        final zeroDaysPayment = testPaymentTerm.copyWith(dueInDays: 0);
        await pumpWidgetAndSettle(tester, zeroDaysPayment);
        
        expect(find.text('Due in 0 days • '), findsOneWidget);
      });

      testWidgets('should handle single day correctly', (WidgetTester tester) async {
        final oneDayPayment = testPaymentTerm.copyWith(dueInDays: 1);
        await pumpWidgetAndSettle(tester, oneDayPayment);
        
        expect(find.text('Due in 1 days • '), findsOneWidget);
      });

      testWidgets('should handle large due periods correctly', (WidgetTester tester) async {
        final largeDuePayment = testPaymentTerm.copyWith(dueInDays: 365);
        await pumpWidgetAndSettle(tester, largeDuePayment);
        
        expect(find.text('Due in 365 days • '), findsOneWidget);
      });
    });

    group('Layout Structure', () {
      testWidgets('should have proper column layout', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        final column = tester.widget<Column>(find.byType(Column));
        expect(column.crossAxisAlignment, equals(CrossAxisAlignment.start));
      });

      testWidgets('should have proper row layouts', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        expect(find.byType(Row), findsNWidgets(2)); // Header row and due date row
      });

      testWidgets('should have correct spacing between elements', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        final sizedBoxes = tester.widgetList<SizedBox>(find.byType(SizedBox));
        expect(sizedBoxes.any((box) => box.width == 8), isTrue); // Horizontal spacing
        expect(sizedBoxes.any((box) => box.height == 8), isTrue); // Main vertical spacing
        expect(sizedBoxes.any((box) => box.height == 4), isTrue); // Due date spacing
      });

      testWidgets('should have spacer in header row', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        expect(find.byType(Spacer), findsOneWidget);
      });
    });

    group('Conditional Rendering', () {
      testWidgets('should show amount section when amount and currency are present', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        expect(find.text('USD 10000.50'), findsOneWidget);
      });

      testWidgets('should hide amount section when amount is null', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, paymentTermWithoutAmount);
        
        expect(find.textContaining('USD'), findsNothing);
        expect(find.textContaining('EUR'), findsNothing);
        expect(find.textContaining('GBP'), findsNothing);
      });

      testWidgets('should hide amount section when currency is null', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, paymentTermWithoutAmount);
        
        expect(find.textContaining('10000.50'), findsNothing);
        expect(find.textContaining('99.99'), findsNothing);
        expect(find.textContaining('5000.00'), findsNothing);
      });

      testWidgets('should show due date section when dueInDays is present', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        expect(find.text('Due in 30 days • '), findsOneWidget);
      });

      testWidgets('should hide due date section when dueInDays is null', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, paymentTermWithoutDue);
        
        expect(find.textContaining('Due in'), findsNothing);
      });
    });

    group('Text Styling', () {
      testWidgets('should apply correct text styles for amount', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        final amountText = tester.widget<Text>(find.text('USD 10000.50'));
        expect(amountText.style?.fontSize, equals(14));
        expect(amountText.style?.fontWeight, equals(FontWeight.w600));
      });

      testWidgets('should apply correct text styles for payment term text', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        final termText = tester.widget<Text>(find.text('Payment due within 30 days of invoice receipt'));
        expect(termText.style?.fontSize, equals(14));
        expect(termText.style?.height, equals(1.4));
      });

      testWidgets('should apply correct text styles for due date', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        final dueText = tester.widget<Text>(find.text('Due in 30 days • '));
        expect(dueText.style?.fontSize, equals(12));
        expect(dueText.style?.fontStyle, equals(FontStyle.italic));
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle zero amount correctly', (WidgetTester tester) async {
        final zeroAmountPayment = testPaymentTerm.copyWith(amount: 0.0);
        await pumpWidgetAndSettle(tester, zeroAmountPayment);
        
        expect(find.text('USD 0.00'), findsOneWidget);
      });

      testWidgets('should handle very small amounts correctly', (WidgetTester tester) async {
        final smallAmountPayment = testPaymentTerm.copyWith(amount: 0.01);
        await pumpWidgetAndSettle(tester, smallAmountPayment);
        
        expect(find.text('USD 0.01'), findsOneWidget);
      });

      testWidgets('should handle very large amounts correctly', (WidgetTester tester) async {
        final largeAmountPayment = testPaymentTerm.copyWith(amount: 999999.99);
        await pumpWidgetAndSettle(tester, largeAmountPayment);
        
        expect(find.text('USD 999999.99'), findsOneWidget);
      });

      testWidgets('should handle zero confidence correctly', (WidgetTester tester) async {
        final zeroConfidencePayment = testPaymentTerm.copyWith(confidence: 0.0);
        await pumpWidgetAndSettle(tester, zeroConfidencePayment);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(0.0));
      });

      testWidgets('should handle full confidence correctly', (WidgetTester tester) async {
        final fullConfidencePayment = testPaymentTerm.copyWith(confidence: 1.0);
        await pumpWidgetAndSettle(tester, fullConfidencePayment);
        
        final percentageWidget = tester.widget<AnimatedCircularPercentage>(find.byType(AnimatedCircularPercentage));
        expect(percentageWidget.percentage, equals(1.0));
      });

      testWidgets('should handle empty text gracefully', (WidgetTester tester) async {
        final emptyTextPayment = testPaymentTerm.copyWith(text: '');
        await pumpWidgetAndSettle(tester, emptyTextPayment);
        
        expect(find.text(''), findsOneWidget);
        expect(tester.takeException(), isNull);
      });

      testWidgets('should handle negative due days', (WidgetTester tester) async {
        final negativeDuePayment = testPaymentTerm.copyWith(dueInDays: -5);
        await pumpWidgetAndSettle(tester, negativeDuePayment);
        
        expect(find.text('Due in -5 days • '), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    });

    group('Widget Integration', () {
      testWidgets('should integrate properly with severity badge', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        final severityBadge = find.byType(SeverityBadge);
        expect(severityBadge, findsOneWidget);
        
        final badgeWidget = tester.widget<SeverityBadge>(severityBadge);
        expect(badgeWidget.severity, equals(testPaymentTerm.severity));
      });

      testWidgets('should integrate properly with animated percentage', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        final percentageWidget = find.byType(AnimatedCircularPercentage);
        expect(percentageWidget, findsOneWidget);
        
        final widget = tester.widget<AnimatedCircularPercentage>(percentageWidget);
        expect(widget.percentage, equals(testPaymentTerm.confidence));
        expect(widget.showPercentageText, isTrue);
      });
    });

    group('Currency Variations', () {
      testWidgets('should handle different currency codes correctly', (WidgetTester tester) async {
        final currencies = ['USD', 'EUR', 'GBP', 'JPY', 'CAD', 'AUD', 'CHF'];
        
        for (final currency in currencies) {
          final currencyPayment = testPaymentTerm.copyWith(currency: currency);
          await pumpWidgetAndSettle(tester, currencyPayment);
          
          expect(find.text('$currency 10000.50'), findsOneWidget);
          
          // Clean up for next iteration
          await tester.pumpWidget(const MaterialApp(home: Scaffold()));
          await tester.pumpAndSettle();
        }
      });

      testWidgets('should handle custom currency codes', (WidgetTester tester) async {
        final customCurrencyPayment = testPaymentTerm.copyWith(currency: 'BTC');
        await pumpWidgetAndSettle(tester, customCurrencyPayment);
        
        expect(find.text('BTC 10000.50'), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('should be accessible for screen readers', (WidgetTester tester) async {
        await pumpWidgetAndSettle(tester, testPaymentTerm);
        
        // All text should be findable
        expect(find.text('Payment due within 30 days of invoice receipt'), findsOneWidget);
        expect(find.text('USD 10000.50'), findsOneWidget);
        expect(find.text('Due in 30 days • '), findsOneWidget);
        
        // No exceptions should occur
        expect(tester.takeException(), isNull);
      });
    });
  });
}