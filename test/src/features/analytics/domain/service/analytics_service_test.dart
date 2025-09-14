import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/service/analytics_service.dart';
import 'package:deal_insights_assistant/src/core/services/logging_service.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/model/contract_analysis_result_model.dart';
import 'package:deal_insights_assistant/src/core/enum/severity_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/likelihood_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/cap_type_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/risk_category_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/security_type_enum.dart';

// Mock classes
class MockLoggingService extends Mock implements LoggingService {}

void main() {
  setUpAll(() {
    // Register fallback values for mocktail
    registerFallbackValue(const Duration(seconds: 1));
    registerFallbackValue(<String, dynamic>{});
  });

  group('AnalyticsService', () {
    late AnalyticsService service;
    late MockLoggingService mockLoggingService;
    
    setUp(() {
      mockLoggingService = MockLoggingService();
      service = AnalyticsService(mockLoggingService);
      
      // Setup default mock behavior for logging service methods
      // These methods don't need to be mocked as they are not called by the methods we're testing
    });

    group('isValidForAnalysis', () {
      test('should return false for empty text', () {
        expect(service.isValidForAnalysis(''), isFalse);
        expect(service.isValidForAnalysis('   '), isFalse);
      });

      test('should return false for text less than 100 characters', () {
        const shortText = 'This is a short text.';
        expect(service.isValidForAnalysis(shortText), isFalse);
      });

      test('should return false for text with less than 20 words', () {
        const fewWords = 'This text has only a few words.';
        expect(service.isValidForAnalysis(fewWords), isFalse);
      });

      test('should return true for valid contract text', () {
        const validText = '''
        This is a comprehensive contract agreement between Party A and Party B.
        The terms and conditions outlined in this document shall govern the relationship
        between the parties for the duration of the agreement. This contract includes
        various clauses related to payment terms, obligations, liabilities, and other
        important provisions that must be followed by both parties involved.
        ''';
        
        expect(service.isValidForAnalysis(validText), isTrue);
      });
    });

    group('createTestResult', () {
      test('should create a valid test result with all required fields', () {
        final result = service.createTestResult();
        
        expect(result, isA<ContractAnalysisResult>());
        expect(result.obligations, isNotNull);
        expect(result.obligations, isNotEmpty);
        expect(result.paymentTerms, isNotNull);
        expect(result.liabilities, isNotNull);
        expect(result.risks, isNotNull);
        expect(result.serviceLevels, isNotNull);
        expect(result.securityRequirements, isNotNull);
      });

      test('should create obligations with correct structure', () {
        final result = service.createTestResult();
        
        expect(result.obligations!.length, greaterThan(0));
        
        final firstObligation = result.obligations!.first;
        expect(firstObligation.text, isNotEmpty);
        expect(firstObligation.party, equals('Vendor'));
        expect(firstObligation.severity, equals(Severity.high));
        expect(firstObligation.timeframe, isNotNull);
        expect(firstObligation.confidence, equals(0.9));
      });

      test('should create payment terms with correct structure', () {
        final result = service.createTestResult();
        
        expect(result.paymentTerms!.length, greaterThan(0));
        
        final firstPaymentTerm = result.paymentTerms!.first;
        expect(firstPaymentTerm.text, isNotEmpty);
        expect(firstPaymentTerm.dueInDays, equals(45));
        expect(firstPaymentTerm.severity, equals(Severity.medium));
        expect(firstPaymentTerm.confidence, equals(0.8));
      });

      test('should create risks with correct structure', () {
        final result = service.createTestResult();
        
        expect(result.risks!.length, greaterThan(0));
        
        final firstRisk = result.risks!.first;
        expect(firstRisk.text, isNotEmpty);
        expect(firstRisk.severity, equals(Severity.high));
        expect(firstRisk.likelihood, equals(Likelihood.medium));
        expect(firstRisk.category, equals(RiskCategory.operational));
        expect(firstRisk.confidence, equals(0.8));
        expect(firstRisk.riskScore, equals(6));
      });
    });
  });
}