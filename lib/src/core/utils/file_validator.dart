import 'dart:typed_data';
import '../services/logging_service.dart';

class FileValidator {
  static const allowedExtensions = ['pdf', 'txt', 'docx'];
  static const maxFileSize = 10 * 1024 * 1024; // 10 MB

  /// Validate file from picker or drop target
  static String? validateFile({required String? fileName, required int fileSize, required Uint8List fileBytes}) {
    try {
      loggingService.methodEntry('FileValidator', 'validateFile', {
        'fileName': fileName,
        'fileSize': fileSize,
        'fileBytesLength': fileBytes.length,
      });

      if (fileName == null) {
        loggingService.validationError('fileName', 'null', 'File name is required');
        return "Invalid file (no name)";
      }

      loggingService.debug('Validating file: $fileName');

      final extension = fileName.split('.').last.toLowerCase();
      loggingService.debug('File extension detected: $extension');

      if (!allowedExtensions.contains(extension)) {
        loggingService.validationError('extension', extension, 'Unsupported file type');
        return "Unsupported file type: $extension";
      }

      if (fileSize > maxFileSize) {
        loggingService.validationError('fileSize', fileSize.toString(), 'File exceeds maximum size limit of ${maxFileSize / (1024 * 1024)}MB');
        return "File too large (max 10 MB)";
      }

      // Magic number check (extra safety)
      if (extension == 'pdf' && !isPdf(fileBytes)) {
        loggingService.validationError('fileContent', 'PDF', 'File does not have valid PDF magic numbers');
        return "File does not look like a valid PDF";
      }
      if (extension == 'docx' && !isDocx(fileBytes)) {
        loggingService.validationError('fileContent', 'DOCX', 'File does not have valid DOCX magic numbers');
        return "File does not look like a valid DOCX";
      }

      loggingService.info('File validation successful for: $fileName');
      loggingService.methodExit('FileValidator', 'validateFile', 'Valid');
      return null; // Valid
    } catch (e, stackTrace) {
      loggingService.error('File validation failed', e, stackTrace);
      return "File validation error: ${e.toString()}";
    }
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
