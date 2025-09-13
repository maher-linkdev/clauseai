import 'dart:typed_data';

enum InputSource { none, file, text }

enum UploadStatus { idle, uploading, analyzing, completed, error }

class HomeState {
  final Uint8List? fileBytes;
  final String? selectedFileName;
  final String? selectedText;
  final String textInput;
  final InputSource inputSource;
  final UploadStatus uploadStatus;
  final bool isDragging;
  final String? errorMessage;
  final String? extractedText;

  const HomeState({
    this.fileBytes,
    this.selectedFileName = '',
    this.selectedText,
    this.textInput = '',
    this.inputSource = InputSource.none,
    this.uploadStatus = UploadStatus.idle,
    this.isDragging = false,
    this.errorMessage,
    this.extractedText,
  });

  HomeState copyWith({
    Uint8List? fileBytes,
    String? selectedFileName,
    String? selectedText,
    String? textInput,
    InputSource? inputSource,
    UploadStatus? uploadStatus,
    bool? isDragging,
    String? errorMessage,
    String? extractedText,
    bool shouldOverride = false,
  }) {
    return HomeState(
      fileBytes: shouldOverride ? fileBytes : fileBytes ?? this.fileBytes,
      selectedFileName: shouldOverride ? selectedFileName : selectedFileName ?? this.selectedFileName,
      selectedText: shouldOverride ? selectedText : selectedText ?? this.selectedText,
      textInput: shouldOverride ? textInput ?? "" : textInput ?? this.textInput,
      inputSource: inputSource ?? this.inputSource,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      isDragging: isDragging ?? this.isDragging,
      errorMessage: shouldOverride ? errorMessage : errorMessage ?? this.errorMessage,
      extractedText: shouldOverride ? extractedText : extractedText ?? this.extractedText,
    );
  }

  bool get hasSelectedFile => fileBytes != null;

  bool get hasSelectedFileName => selectedFileName != null && selectedFileName!.isNotEmpty;

  bool get hasSelectedText => selectedText != null && selectedText!.isNotEmpty;

  bool get hasInput => hasSelectedFile || hasSelectedText;

  bool get isUploading => uploadStatus == UploadStatus.uploading;

  bool get isAnalyzing => uploadStatus == UploadStatus.analyzing;

  bool get isProcessing => isUploading || isAnalyzing;

  bool get hasError => errorMessage != null;
}
