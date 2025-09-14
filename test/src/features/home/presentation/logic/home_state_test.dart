import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/logic/home_state.dart';

void main() {
  group('InputSource Enum', () {
    test('should have correct values', () {
      expect(InputSource.values, hasLength(3));
      expect(InputSource.values, contains(InputSource.none));
      expect(InputSource.values, contains(InputSource.file));
      expect(InputSource.values, contains(InputSource.text));
    });

    test('should have correct order', () {
      expect(InputSource.values[0], equals(InputSource.none));
      expect(InputSource.values[1], equals(InputSource.file));
      expect(InputSource.values[2], equals(InputSource.text));
    });

    test('should support equality comparison', () {
      expect(InputSource.none, equals(InputSource.none));
      expect(InputSource.file, equals(InputSource.file));
      expect(InputSource.text, equals(InputSource.text));
      expect(InputSource.none, isNot(equals(InputSource.file)));
    });

    test('should work in switch statements', () {
      String getSourceName(InputSource source) {
        switch (source) {
          case InputSource.none:
            return 'none';
          case InputSource.file:
            return 'file';
          case InputSource.text:
            return 'text';
        }
      }

      expect(getSourceName(InputSource.none), equals('none'));
      expect(getSourceName(InputSource.file), equals('file'));
      expect(getSourceName(InputSource.text), equals('text'));
    });
  });

  group('UploadStatus Enum', () {
    test('should have correct values', () {
      expect(UploadStatus.values, hasLength(5));
      expect(UploadStatus.values, contains(UploadStatus.idle));
      expect(UploadStatus.values, contains(UploadStatus.uploading));
      expect(UploadStatus.values, contains(UploadStatus.analyzing));
      expect(UploadStatus.values, contains(UploadStatus.completed));
      expect(UploadStatus.values, contains(UploadStatus.error));
    });

    test('should have correct order', () {
      expect(UploadStatus.values[0], equals(UploadStatus.idle));
      expect(UploadStatus.values[1], equals(UploadStatus.uploading));
      expect(UploadStatus.values[2], equals(UploadStatus.analyzing));
      expect(UploadStatus.values[3], equals(UploadStatus.completed));
      expect(UploadStatus.values[4], equals(UploadStatus.error));
    });

    test('should support equality comparison', () {
      expect(UploadStatus.idle, equals(UploadStatus.idle));
      expect(UploadStatus.uploading, equals(UploadStatus.uploading));
      expect(UploadStatus.analyzing, equals(UploadStatus.analyzing));
      expect(UploadStatus.completed, equals(UploadStatus.completed));
      expect(UploadStatus.error, equals(UploadStatus.error));
      expect(UploadStatus.idle, isNot(equals(UploadStatus.uploading)));
    });

    test('should work in switch statements', () {
      String getStatusName(UploadStatus status) {
        switch (status) {
          case UploadStatus.idle:
            return 'idle';
          case UploadStatus.uploading:
            return 'uploading';
          case UploadStatus.analyzing:
            return 'analyzing';
          case UploadStatus.completed:
            return 'completed';
          case UploadStatus.error:
            return 'error';
        }
      }

      expect(getStatusName(UploadStatus.idle), equals('idle'));
      expect(getStatusName(UploadStatus.uploading), equals('uploading'));
      expect(getStatusName(UploadStatus.analyzing), equals('analyzing'));
      expect(getStatusName(UploadStatus.completed), equals('completed'));
      expect(getStatusName(UploadStatus.error), equals('error'));
    });
  });

  group('HomeState', () {
    group('Constructor', () {
      test('should create with default values', () {
        const state = HomeState();

        expect(state.fileBytes, isNull);
        expect(state.selectedFileName, equals(''));
        expect(state.selectedText, isNull);
        expect(state.textInput, equals(''));
        expect(state.inputSource, equals(InputSource.none));
        expect(state.uploadStatus, equals(UploadStatus.idle));
        expect(state.isDragging, isFalse);
        expect(state.errorMessage, isNull);
        expect(state.extractedText, isNull);
      });

      test('should create with custom values', () {
        final fileBytes = Uint8List.fromList([1, 2, 3, 4, 5]);
        const state = HomeState(
          fileBytes: null,
          selectedFileName: 'test.pdf',
          selectedText: 'Test text',
          textInput: 'Input text',
          inputSource: InputSource.file,
          uploadStatus: UploadStatus.uploading,
          isDragging: true,
          errorMessage: 'Test error',
          extractedText: 'Extracted text',
        );

        expect(state.selectedFileName, equals('test.pdf'));
        expect(state.selectedText, equals('Test text'));
        expect(state.textInput, equals('Input text'));
        expect(state.inputSource, equals(InputSource.file));
        expect(state.uploadStatus, equals(UploadStatus.uploading));
        expect(state.isDragging, isTrue);
        expect(state.errorMessage, equals('Test error'));
        expect(state.extractedText, equals('Extracted text'));
      });
    });

    group('copyWith', () {
      test('should copy with new values', () {
        const originalState = HomeState();
        final newFileBytes = Uint8List.fromList([1, 2, 3]);
        
        final newState = originalState.copyWith(
          fileBytes: newFileBytes,
          selectedFileName: 'new.pdf',
          selectedText: 'New text',
          textInput: 'New input',
          inputSource: InputSource.text,
          uploadStatus: UploadStatus.analyzing,
          isDragging: true,
          errorMessage: 'New error',
          extractedText: 'New extracted',
        );

        expect(newState.fileBytes, equals(newFileBytes));
        expect(newState.selectedFileName, equals('new.pdf'));
        expect(newState.selectedText, equals('New text'));
        expect(newState.textInput, equals('New input'));
        expect(newState.inputSource, equals(InputSource.text));
        expect(newState.uploadStatus, equals(UploadStatus.analyzing));
        expect(newState.isDragging, isTrue);
        expect(newState.errorMessage, equals('New error'));
        expect(newState.extractedText, equals('New extracted'));
      });

      test('should preserve original values when not specified', () {
        final originalFileBytes = Uint8List.fromList([1, 2, 3]);
        final originalState = HomeState(
          fileBytes: originalFileBytes,
          selectedFileName: 'original.pdf',
          selectedText: 'Original text',
          textInput: 'Original input',
          inputSource: InputSource.file,
          uploadStatus: UploadStatus.completed,
          isDragging: true,
          errorMessage: 'Original error',
          extractedText: 'Original extracted',
        );

        final newState = originalState.copyWith(
          selectedFileName: 'new.pdf',
        );

        expect(newState.fileBytes, equals(originalFileBytes));
        expect(newState.selectedFileName, equals('new.pdf'));
        expect(newState.selectedText, equals('Original text'));
        expect(newState.textInput, equals('Original input'));
        expect(newState.inputSource, equals(InputSource.file));
        expect(newState.uploadStatus, equals(UploadStatus.completed));
        expect(newState.isDragging, isTrue);
        expect(newState.errorMessage, equals('Original error'));
        expect(newState.extractedText, equals('Original extracted'));
      });

      test('should handle shouldOverride parameter', () {
        final originalState = HomeState(
          fileBytes: Uint8List.fromList([1, 2, 3]),
          selectedFileName: 'original.pdf',
          selectedText: 'Original text',
          textInput: 'Original input',
          errorMessage: 'Original error',
          extractedText: 'Original extracted',
        );

        final newState = originalState.copyWith(
          fileBytes: null,
          selectedFileName: null,
          selectedText: null,
          textInput: null,
          errorMessage: null,
          extractedText: null,
          shouldOverride: true,
        );

        expect(newState.fileBytes, isNull);
        expect(newState.selectedFileName, isNull);
        expect(newState.selectedText, isNull);
        expect(newState.textInput, equals(''));
        expect(newState.errorMessage, isNull);
        expect(newState.extractedText, isNull);
      });

      test('should handle shouldOverride false (default behavior)', () {
        final originalState = HomeState(
          fileBytes: Uint8List.fromList([1, 2, 3]),
          selectedFileName: 'original.pdf',
          selectedText: 'Original text',
          textInput: 'Original input',
          errorMessage: 'Original error',
          extractedText: 'Original extracted',
        );

        final newState = originalState.copyWith(
          fileBytes: null,
          selectedFileName: null,
          selectedText: null,
          textInput: null,
          errorMessage: null,
          extractedText: null,
          shouldOverride: false,
        );

        // Should preserve original values when shouldOverride is false
        expect(newState.fileBytes, equals(originalState.fileBytes));
        expect(newState.selectedFileName, equals(originalState.selectedFileName));
        expect(newState.selectedText, equals(originalState.selectedText));
        expect(newState.textInput, equals(originalState.textInput));
        expect(newState.errorMessage, equals(originalState.errorMessage));
        expect(newState.extractedText, equals(originalState.extractedText));
      });
    });

    group('Convenience Getters', () {
      test('hasSelectedFile should work correctly', () {
        const stateWithoutFile = HomeState();
        expect(stateWithoutFile.hasSelectedFile, isFalse);

        final stateWithFile = HomeState(fileBytes: Uint8List.fromList([1, 2, 3]));
        expect(stateWithFile.hasSelectedFile, isTrue);
      });

      test('hasSelectedFileName should work correctly', () {
        const stateWithoutFileName = HomeState();
        expect(stateWithoutFileName.hasSelectedFileName, isFalse);

        const stateWithEmptyFileName = HomeState(selectedFileName: '');
        expect(stateWithEmptyFileName.hasSelectedFileName, isFalse);

        const stateWithFileName = HomeState(selectedFileName: 'test.pdf');
        expect(stateWithFileName.hasSelectedFileName, isTrue);
      });

      test('hasSelectedText should work correctly', () {
        const stateWithoutText = HomeState();
        expect(stateWithoutText.hasSelectedText, isFalse);

        const stateWithEmptyText = HomeState(selectedText: '');
        expect(stateWithEmptyText.hasSelectedText, isFalse);

        const stateWithText = HomeState(selectedText: 'Test text');
        expect(stateWithText.hasSelectedText, isTrue);
      });

      test('hasInput should work correctly', () {
        const stateWithoutInput = HomeState();
        expect(stateWithoutInput.hasInput, isFalse);

        final stateWithFile = HomeState(fileBytes: Uint8List.fromList([1, 2, 3]));
        expect(stateWithFile.hasInput, isTrue);

        const stateWithText = HomeState(selectedText: 'Test text');
        expect(stateWithText.hasInput, isTrue);

        final stateWithBoth = HomeState(
          fileBytes: Uint8List.fromList([1, 2, 3]),
          selectedText: 'Test text',
        );
        expect(stateWithBoth.hasInput, isTrue);
      });

      test('isUploading should work correctly', () {
        const idleState = HomeState(uploadStatus: UploadStatus.idle);
        expect(idleState.isUploading, isFalse);

        const uploadingState = HomeState(uploadStatus: UploadStatus.uploading);
        expect(uploadingState.isUploading, isTrue);

        const analyzingState = HomeState(uploadStatus: UploadStatus.analyzing);
        expect(analyzingState.isUploading, isFalse);
      });

      test('isAnalyzing should work correctly', () {
        const idleState = HomeState(uploadStatus: UploadStatus.idle);
        expect(idleState.isAnalyzing, isFalse);

        const uploadingState = HomeState(uploadStatus: UploadStatus.uploading);
        expect(uploadingState.isAnalyzing, isFalse);

        const analyzingState = HomeState(uploadStatus: UploadStatus.analyzing);
        expect(analyzingState.isAnalyzing, isTrue);
      });

      test('isProcessing should work correctly', () {
        const idleState = HomeState(uploadStatus: UploadStatus.idle);
        expect(idleState.isProcessing, isFalse);

        const uploadingState = HomeState(uploadStatus: UploadStatus.uploading);
        expect(uploadingState.isProcessing, isTrue);

        const analyzingState = HomeState(uploadStatus: UploadStatus.analyzing);
        expect(analyzingState.isProcessing, isTrue);

        const completedState = HomeState(uploadStatus: UploadStatus.completed);
        expect(completedState.isProcessing, isFalse);

        const errorState = HomeState(uploadStatus: UploadStatus.error);
        expect(errorState.isProcessing, isFalse);
      });

      test('hasError should work correctly', () {
        const stateWithoutError = HomeState();
        expect(stateWithoutError.hasError, isFalse);

        const stateWithError = HomeState(errorMessage: 'Test error');
        expect(stateWithError.hasError, isTrue);

        const stateWithEmptyError = HomeState(errorMessage: '');
        expect(stateWithEmptyError.hasError, isTrue); // Empty string is still considered an error
      });
    });

    group('State Transitions', () {
      test('should support typical file upload flow', () {
        // Start with initial state
        const initialState = HomeState();
        expect(initialState.hasInput, isFalse);
        expect(initialState.isProcessing, isFalse);

        // File selected
        final fileSelectedState = initialState.copyWith(
          fileBytes: Uint8List.fromList([1, 2, 3]),
          selectedFileName: 'contract.pdf',
          inputSource: InputSource.file,
        );
        expect(fileSelectedState.hasInput, isTrue);
        expect(fileSelectedState.hasSelectedFile, isTrue);
        expect(fileSelectedState.inputSource, equals(InputSource.file));

        // Start analyzing
        final analyzingState = fileSelectedState.copyWith(
          uploadStatus: UploadStatus.analyzing,
        );
        expect(analyzingState.isAnalyzing, isTrue);
        expect(analyzingState.isProcessing, isTrue);

        // Analysis completed
        final completedState = analyzingState.copyWith(
          uploadStatus: UploadStatus.completed,
          extractedText: 'Extracted contract text',
        );
        expect(completedState.isProcessing, isFalse);
        expect(completedState.extractedText, isNotNull);
      });

      test('should support text input flow', () {
        // Start with initial state
        const initialState = HomeState();

        // Text entered
        final textEnteredState = initialState.copyWith(
          textInput: 'Contract text input',
          selectedText: 'Contract text input',
          inputSource: InputSource.text,
        );
        expect(textEnteredState.hasInput, isTrue);
        expect(textEnteredState.hasSelectedText, isTrue);
        expect(textEnteredState.inputSource, equals(InputSource.text));

        // Start analyzing
        final analyzingState = textEnteredState.copyWith(
          uploadStatus: UploadStatus.analyzing,
        );
        expect(analyzingState.isAnalyzing, isTrue);

        // Analysis completed
        final completedState = analyzingState.copyWith(
          uploadStatus: UploadStatus.completed,
        );
        expect(completedState.isProcessing, isFalse);
      });

      test('should support error handling', () {
        final processingState = HomeState(
          fileBytes: Uint8List.fromList([1, 2, 3]),
          selectedFileName: 'contract.pdf',
          uploadStatus: UploadStatus.analyzing,
        );

        final errorState = processingState.copyWith(
          uploadStatus: UploadStatus.error,
          errorMessage: 'Analysis failed',
        );

        expect(errorState.hasError, isTrue);
        expect(errorState.isProcessing, isFalse);
        expect(errorState.uploadStatus, equals(UploadStatus.error));
      });

      test('should support clearing state', () {
        final complexState = HomeState(
          fileBytes: Uint8List.fromList([1, 2, 3]),
          selectedFileName: 'contract.pdf',
          selectedText: 'Some text',
          textInput: 'Input text',
          inputSource: InputSource.file,
          uploadStatus: UploadStatus.completed,
          isDragging: true,
          errorMessage: 'Some error',
          extractedText: 'Extracted text',
        );

        final clearedState = complexState.copyWith(
          fileBytes: null,
          selectedFileName: null,
          selectedText: null,
          textInput: '',
          inputSource: InputSource.none,
          uploadStatus: UploadStatus.idle,
          isDragging: false,
          errorMessage: null,
          extractedText: null,
          shouldOverride: true,
        );

        expect(clearedState.hasInput, isFalse);
        expect(clearedState.hasError, isFalse);
        expect(clearedState.isProcessing, isFalse);
        expect(clearedState.isDragging, isFalse);
        expect(clearedState.inputSource, equals(InputSource.none));
      });
    });

    group('Edge Cases', () {
      test('should handle null values correctly', () {
        const state = HomeState(
          fileBytes: null,
          selectedFileName: null,
          selectedText: null,
          errorMessage: null,
          extractedText: null,
        );

        expect(state.fileBytes, isNull);
        expect(state.selectedFileName, isNull);
        expect(state.selectedText, isNull);
        expect(state.errorMessage, isNull);
        expect(state.extractedText, isNull);
        expect(state.hasSelectedFile, isFalse);
        expect(state.hasSelectedText, isFalse);
        expect(state.hasError, isFalse);
      });

      test('should handle empty strings correctly', () {
        const state = HomeState(
          selectedFileName: '',
          selectedText: '',
          textInput: '',
          errorMessage: '',
          extractedText: '',
        );

        expect(state.hasSelectedFileName, isFalse);
        expect(state.hasSelectedText, isFalse);
        expect(state.hasError, isTrue); // Empty error message is still considered an error
      });

      test('should handle large file bytes', () {
        final largeBytes = Uint8List.fromList(List.generate(1000000, (i) => i % 256));
        final state = HomeState(fileBytes: largeBytes);

        expect(state.hasSelectedFile, isTrue);
        expect(state.fileBytes!.length, equals(1000000));
      });
    });
  });
}
