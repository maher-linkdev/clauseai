import 'dart:typed_data';

import 'package:deal_insights_assistant/src/core/utils/file_validator.dart';
import 'package:deal_insights_assistant/src/features/home/domain/service/document_analysis_service.dart';
import 'package:deal_insights_assistant/src/features/home/presentation/logic/home_state.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Home state provider
final homeStateProvider = StateNotifierProvider<HomeStateNotifier, HomeState>((ref) {
  final documentService = ref.watch(documentAnalysisServiceProvider);
  return HomeStateNotifier(documentService);
});

class HomeStateNotifier extends StateNotifier<HomeState> {
  final DocumentAnalysisService _documentService;

  HomeStateNotifier(this._documentService) : super(const HomeState());

  // Update text input
  void updateTextInput(String text) {
    state = state.copyWith(
      textInput: text,
      selectedText: text.isNotEmpty ? text : null,
      inputSource: text.isNotEmpty ? InputSource.text : InputSource.none,
      errorMessage: null,
    );
  }

  // Set dragging state
  void setDragging(bool isDragging) {
    state = state.copyWith(isDragging: isDragging);
  }

  // Pick file using file picker
  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: _documentService.getSupportedExtensions(),
        withData: true,
      );

      if (result != null && result.files.first.path != null) {
        final file = result.files.first;
        await _validateAndSetFile(file);
      }
    } catch (e) {
      state = state.copyWith(errorMessage: 'Failed to pick file: ${e.toString()}', uploadStatus: UploadStatus.error);
    }
  }

  // Handle dropped file
  Future<void> handleDroppedFile(PlatformFile file) async {
    try {
      await _validateAndSetFile(file);
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to handle dropped file: ${e.toString()}',
        uploadStatus: UploadStatus.error,
      );
    }
  }

  // Validate and set file
  Future<void> _validateAndSetFile(PlatformFile file) async {
    final String? error = FileValidator.validateFile(fileName: file.name, fileSize: file.size, fileBytes: file.bytes!);

    if (error != null) {
      state = state.copyWith(errorMessage: error, uploadStatus: UploadStatus.error);
    } else {
      state = state.copyWith(
        fileBytes: file.bytes as Uint8List,
        selectedFileName: file.name,
        selectedText: null,
        textInput: '',
        inputSource: InputSource.file,
        uploadStatus: UploadStatus.idle,
        errorMessage: null,
      );
    }
  }

  // Clear selection
  void clearSelection() {
    print('clearSelection');
    state = state.copyWith(
      fileBytes: null,
      selectedText: null,
      selectedFileName: null,
      textInput: '',
      inputSource: InputSource.none,
      uploadStatus: UploadStatus.idle,
      errorMessage: null,
      extractedText: null,
      shouldOverride: true,
      isDragging: false,
    );
  }

  // Analyze document (extract text)
  Future<void> analyzeDocument() async {
    if (!state.hasInput) return;

    //try {
    state = state.copyWith(uploadStatus: UploadStatus.analyzing, errorMessage: null);

    String extractedText = '';

    if (state.hasSelectedFile) {
      // Extract text from file
      extractedText = await _documentService.extractTextFromBytes(state.fileBytes!, state.selectedFileName!);
      print("extractedText $extractedText");
      if (!_documentService.isValidExtractedText(extractedText)) {
        throw Exception('No readable text found in the document');
      }
    } else if (state.hasSelectedText) {
      // Use the provided text
      extractedText = state.selectedText!;
    }

    // Simulate analysis delay
    await Future.delayed(const Duration(seconds: 1));

    state = state.copyWith(uploadStatus: UploadStatus.completed, extractedText: extractedText, errorMessage: null);
    //} catch (e) {
    //state = state.copyWith(uploadStatus: UploadStatus.error, errorMessage: 'Analysis failed: ${e.toString()}');
    //}
  }

  // Reset error state
  void clearError() {
    state = state.copyWith(
      errorMessage: null,
      inputSource: state.inputSource,
      extractedText: state.extractedText,
      fileBytes: state.fileBytes,
      selectedFileName: state.selectedFileName,
      isDragging: state.isDragging,
      textInput: state.textInput,
      selectedText: state.selectedText,
      uploadStatus: state.uploadStatus == UploadStatus.error ? UploadStatus.idle : state.uploadStatus,
      shouldOverride: true,
    );
  }
}
