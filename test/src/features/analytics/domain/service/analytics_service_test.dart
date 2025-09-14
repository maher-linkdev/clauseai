import 'package:deal_insights_assistant/src/core/services/logging_service.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/service/analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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
  });
}
