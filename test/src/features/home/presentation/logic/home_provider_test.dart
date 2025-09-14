import 'dart:typed_data';

import 'package:deal_insights_assistant/src/core/services/logging_service.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/entity/contract_analysis_result_entity.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/service/analytics_service.dart';
import 'package:deal_insights_assistant/src/features/home/domain/service/document_analysis_service.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/logic/home_provider.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/logic/home_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

// Mock classes using mocktail
class MockDocumentAnalysisService extends Mock implements DocumentAnalysisService {}

class MockAnalyticsService extends Mock implements AnalyticsService {}

class MockLoggingService extends Mock implements LoggingService {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('HomeStateNotifier', () {
    late HomeStateNotifier notifier;
    late MockDocumentAnalysisService mockDocumentService;
    late MockAnalyticsService mockAnalyticsService;
    late MockLoggingService mockLoggingService;
    late MockGoRouter mockRouter;

    setUpAll(() {
      // Register fallback values for mocktail
      registerFallbackValue(Uint8List.fromList([]));
      registerFallbackValue(const ContractAnalysisResultEntity());
    });

    setUp(() {
      mockDocumentService = MockDocumentAnalysisService();
      mockAnalyticsService = MockAnalyticsService();
      mockLoggingService = MockLoggingService();
      mockRouter = MockGoRouter();

      notifier = HomeStateNotifier(mockDocumentService, mockAnalyticsService, mockLoggingService);

      // Setup default mock behaviors
      when(() => mockDocumentService.getSupportedExtensions()).thenReturn(['pdf', 'doc', 'docx', 'txt']);
      when(() => mockLoggingService.info(any())).thenReturn(null);
      when(() => mockLoggingService.error(any(), any(), any())).thenReturn(null);
    });

    group('setDragging', () {
      test('should set dragging state to true', () {
        notifier.setDragging(true);

        expect(notifier.state.isDragging, isTrue);
      });

      test('should set dragging state to false', () {
        // First set to true
        notifier.setDragging(true);
        expect(notifier.state.isDragging, isTrue);

        // Then set to false
        notifier.setDragging(false);

        expect(notifier.state.isDragging, isFalse);
      });
    });

    group('handleDroppedFile', () {
      test('should handle file validation error', () async {
        final testBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        final file = PlatformFile(
          name: 'test.xyz', // Unsupported extension
          size: testBytes.length,
          bytes: testBytes,
        );

        await notifier.handleDroppedFile(file);

        expect(notifier.state.uploadStatus, equals(UploadStatus.error));
        expect(notifier.state.errorMessage, isNotNull);
        verify(() => mockLoggingService.error(any<String>(), any<Object>(), any<StackTrace?>())).called(1);
      });
    });

    group('clearSelection', () {
      test('should clear all selections and reset state', () {
        // Set up complex state
        final testBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        notifier.state = notifier.state.copyWith(
          fileBytes: testBytes,
          selectedFileName: 'test.pdf',
          selectedText: 'Some text',
          textInput: 'Input text',
          inputSource: InputSource.file,
          uploadStatus: UploadStatus.completed,
          isDragging: true,
          errorMessage: 'Some error',
          extractedText: 'Extracted text',
        );

        notifier.clearSelection();

        expect(notifier.state.fileBytes, isNull);
        expect(notifier.state.selectedText, isNull);
        expect(notifier.state.selectedFileName, isNull);
        expect(notifier.state.textInput, equals(''));
        expect(notifier.state.inputSource, equals(InputSource.none));
        expect(notifier.state.uploadStatus, equals(UploadStatus.idle));
        expect(notifier.state.errorMessage, isNull);
        expect(notifier.state.extractedText, isNull);
        expect(notifier.state.isDragging, isFalse);

        verify(() => mockLoggingService.info('Clearing selection')).called(1);
      });
    });

    group('clearError', () {
      test('should clear error message and reset error status', () {
        // Set state with error
        notifier.state = notifier.state.copyWith(uploadStatus: UploadStatus.error, errorMessage: 'Test error');

        notifier.clearError();

        expect(notifier.state.errorMessage, isNull);
        expect(notifier.state.uploadStatus, equals(UploadStatus.idle));
      });

      test('should preserve other upload statuses when clearing error', () {
        // Set state with completed status
        notifier.state = notifier.state.copyWith(uploadStatus: UploadStatus.completed, errorMessage: 'Test error');

        notifier.clearError();

        expect(notifier.state.errorMessage, isNull);
        expect(notifier.state.uploadStatus, equals(UploadStatus.completed));
      });

      test('should preserve all other state properties', () {
        final testBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        notifier.state = notifier.state.copyWith(
          fileBytes: testBytes,
          selectedFileName: 'test.pdf',
          selectedText: 'Some text',
          textInput: 'Input text',
          inputSource: InputSource.file,
          uploadStatus: UploadStatus.error,
          isDragging: true,
          errorMessage: 'Test error',
          extractedText: 'Extracted text',
        );

        notifier.clearError();

        expect(notifier.state.fileBytes, equals(testBytes));
        expect(notifier.state.selectedFileName, equals('test.pdf'));
        expect(notifier.state.selectedText, equals('Some text'));
        expect(notifier.state.textInput, equals('Input text'));
        expect(notifier.state.inputSource, equals(InputSource.file));
        expect(notifier.state.isDragging, isTrue);
        expect(notifier.state.extractedText, equals('Extracted text'));
        expect(notifier.state.errorMessage, isNull);
        expect(notifier.state.uploadStatus, equals(UploadStatus.idle));
      });
    });

    group('analyzeDocument', () {
      test('should handle no input gracefully', () async {
        // State with no input
        expect(notifier.state.hasInput, isFalse);

        await notifier.analyzeDocument(mockRouter);

        // Should not change state or call any services
        expect(notifier.state.uploadStatus, equals(UploadStatus.idle));
        verifyNever(() => mockDocumentService.extractTextFromBytes(any<Uint8List>(), any<String>()));
        verifyNever(() => mockAnalyticsService.analyzeContract(any<String>()));
        verifyNever(() => mockRouter.pushNamed(any<String>(), extra: any(named: 'extra')));
      });

      test('should handle text extraction failure', () async {
        final testBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        notifier.state = notifier.state.copyWith(
          fileBytes: testBytes,
          selectedFileName: 'contract.pdf',
          inputSource: InputSource.file,
        );

        // Setup mock to throw exception
        when(
          () => mockDocumentService.extractTextFromBytes(testBytes, 'contract.pdf'),
        ).thenThrow(Exception('Text extraction failed'));

        await notifier.analyzeDocument(mockRouter);

        expect(notifier.state.uploadStatus, equals(UploadStatus.error));
        expect(notifier.state.errorMessage, contains('Analysis failed'));
        expect(notifier.state.errorMessage, contains('Text extraction failed'));

        verify(() => mockLoggingService.error(any<String>(), any<Object>(), any<StackTrace?>())).called(1);
        verifyNever(() => mockRouter.pushNamed(any<String>(), extra: any(named: 'extra')));
      });

      test('should handle invalid extracted text', () async {
        final testBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        notifier.state = notifier.state.copyWith(
          fileBytes: testBytes,
          selectedFileName: 'contract.pdf',
          inputSource: InputSource.file,
        );

        const extractedText = 'Short'; // Invalid text

        when(
          () => mockDocumentService.extractTextFromBytes(testBytes, 'contract.pdf'),
        ).thenAnswer((_) async => extractedText);
        when(() => mockDocumentService.isValidExtractedText(extractedText)).thenReturn(false);

        await notifier.analyzeDocument(mockRouter);

        expect(notifier.state.uploadStatus, equals(UploadStatus.error));
        expect(notifier.state.errorMessage, contains('No readable text found'));

        verify(() => mockLoggingService.error(any<String>(), any<Object>(), any<StackTrace?>())).called(1);
        verifyNever(() => mockAnalyticsService.analyzeContract(any<String>()));
        verifyNever(() => mockRouter.pushNamed(any<String>(), extra: any(named: 'extra')));
      });

      test('should handle invalid text for analysis', () async {
        const inputText = 'Short text'; // Valid extracted but invalid for analysis
        notifier.state = notifier.state.copyWith(selectedText: inputText, inputSource: InputSource.text);

        when(() => mockAnalyticsService.isValidForAnalysis(inputText)).thenReturn(false);

        await notifier.analyzeDocument(mockRouter);

        expect(notifier.state.uploadStatus, equals(UploadStatus.error));
        expect(notifier.state.errorMessage, contains('too short or invalid'));

        verify(() => mockLoggingService.error(any<String>(), any<Object>(), any<StackTrace?>())).called(1);
        verifyNever(() => mockAnalyticsService.analyzeContract(any<String>()));
        verifyNever(() => mockRouter.pushNamed(any<String>(), extra: any(named: 'extra')));
      });

      test('should handle contract analysis failure', () async {
        const inputText = 'This is valid contract text for analysis with sufficient content.';
        notifier.state = notifier.state.copyWith(selectedText: inputText, inputSource: InputSource.text);

        when(() => mockAnalyticsService.isValidForAnalysis(inputText)).thenReturn(true);
        when(() => mockAnalyticsService.analyzeContract(inputText)).thenThrow(Exception('Analysis service failed'));

        await notifier.analyzeDocument(mockRouter);

        expect(notifier.state.uploadStatus, equals(UploadStatus.error));
        expect(notifier.state.errorMessage, contains('Analysis failed'));
        expect(notifier.state.errorMessage, contains('Analysis service failed'));

        verify(() => mockLoggingService.error(any<String>(), any<Object>(), any<StackTrace?>())).called(1);
        verifyNever(() => mockRouter.pushNamed(any<String>(), extra: any(named: 'extra')));
      });
    });

    group('Error Handling', () {
      test('should handle unexpected errors gracefully', () async {
        final testBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        notifier.state = notifier.state.copyWith(
          fileBytes: testBytes,
          selectedFileName: 'contract.pdf',
          inputSource: InputSource.file,
        );

        // Setup mock to throw unexpected error
        when(
          () => mockDocumentService.extractTextFromBytes(any<Uint8List>(), any<String>()),
        ).thenThrow(StateError('Unexpected state error'));

        await notifier.analyzeDocument(mockRouter);

        expect(notifier.state.uploadStatus, equals(UploadStatus.error));
        expect(notifier.state.errorMessage, contains('Analysis failed'));
        verify(() => mockLoggingService.error(any<String>(), any<Object>(), any<StackTrace?>())).called(1);
      });

      test('should log all errors appropriately', () async {
        const errorMessage = 'Test error message';

        // Test file handling error
        final file = PlatformFile(name: 'test.xyz', size: 100, bytes: Uint8List.fromList([1, 2, 3]));

        await notifier.handleDroppedFile(file);

        verify(
          () =>
              mockLoggingService.error(any<String>(that: contains('Invalid file')), any<Object>(), any<StackTrace?>()),
        ).called(1);
      });
    });

    group('State Management', () {
      test('should maintain state consistency during operations', () async {
        // Test that state transitions are atomic and consistent
        const inputText = 'Valid contract text for analysis.';
        
        // First update text input (typing)
        notifier.updateTextInput(inputText);
        expect(notifier.state.textInput, equals(inputText));
        expect(notifier.state.selectedText, isNull); // Not selected yet, just typed
        expect(notifier.state.inputSource, equals(InputSource.none));
        expect(notifier.state.hasInput, isFalse);

        // Then set as selected text for analysis
        notifier.setSelectedText(inputText);
        expect(notifier.state.textInput, equals(inputText));
        expect(notifier.state.selectedText, equals(inputText));
        expect(notifier.state.inputSource, equals(InputSource.text));
        expect(notifier.state.hasInput, isTrue);

        // Clear and verify all related fields are cleared
        notifier.clearSelection();
        expect(notifier.state.textInput, equals(''));
        expect(notifier.state.selectedText, isNull);
        expect(notifier.state.inputSource, equals(InputSource.none));
        expect(notifier.state.hasInput, isFalse);
      });

      test('should handle rapid state changes correctly', () {
        // Simulate rapid user interactions
        notifier.updateTextInput('First text');
        notifier.setDragging(true);
        notifier.updateTextInput('Second text');
        notifier.setDragging(false);
        notifier.clearSelection();

        expect(notifier.state.textInput, equals(''));
        expect(notifier.state.isDragging, isFalse);
        expect(notifier.state.inputSource, equals(InputSource.none));
      });
    });

    group('Integration', () {
      test('should work with real-like file data', () async {
        // Simulate a real PDF file structure (simplified)
        final pdfHeader = [0x25, 0x50, 0x44, 0x46]; // %PDF
        final testBytes = Uint8List.fromList([...pdfHeader, ...List.generate(100, (i) => i % 256)]);

        final file = PlatformFile(name: 'contract.pdf', size: testBytes.length, bytes: testBytes);

        await notifier.handleDroppedFile(file);

        expect(notifier.state.hasSelectedFile, isTrue);
        expect(notifier.state.selectedFileName, equals('contract.pdf'));
        expect(notifier.state.fileBytes, equals(testBytes));
      });
    });
  });
}
