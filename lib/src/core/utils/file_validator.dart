import 'dart:typed_data';

class FileValidator {
  static const allowedExtensions = ['pdf', 'txt', 'docx'];
  static const maxFileSize = 10 * 1024 * 1024; // 10 MB

  /// Validate file from picker or drop target
  static String? validateFile({required String? fileName, required int fileSize, required Uint8List fileBytes}) {
    if (fileName == null) return "Invalid file (no name)";

    final extension = fileName.split('.').last.toLowerCase();
    print("file extension ${extension}");
    if (!allowedExtensions.contains(extension)) {
      return "Unsupported file type: $extension";
    }

    if (fileSize > maxFileSize) {
      return "File too large (max 10 MB)";
    }

    // Magic number check (extra safety)
    if (extension == 'pdf' && !isPdf(fileBytes)) {
      return "File does not look like a valid PDF";
    }
    if (extension == 'docx' && !isDocx(fileBytes)) {
      return "File does not look like a valid DOCX";
    }

    return null; // ✅ Valid
  }

  static bool isPdf(Uint8List bytes) =>
      bytes.length > 4 &&
      bytes[0] == 0x25 && // %
      bytes[1] == 0x50 && // P
      bytes[2] == 0x44 && // D
      bytes[3] == 0x46; // F

  static bool isDocx(Uint8List bytes) =>
      bytes.length > 4 &&
      bytes[0] == 0x50 && // P
      bytes[1] == 0x4B; // K (zip header)
}
