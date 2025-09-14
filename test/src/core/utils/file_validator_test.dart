import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:deal_insights_assistant/src/core/utils/file_validator.dart';

void main() {
  group('FileValidator', () {
    group('Constants', () {
      test('should have correct allowed extensions', () {
        expect(FileValidator.allowedExtensions, equals(['pdf', 'txt', 'docx']));
      });

      test('should have correct max file size', () {
        expect(FileValidator.maxFileSize, equals(10 * 1024 * 1024)); // 10 MB
      });
    });

    group('validateFile', () {
      test('should return null for valid PDF file', () {
        final pdfBytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2D]); // %PDF-
        final result = FileValidator.validateFile(
          fileName: 'test.pdf',
          fileSize: 1024,
          fileBytes: pdfBytes,
        );

        expect(result, isNull);
      });

      test('should return null for valid TXT file', () {
        final txtBytes = Uint8List.fromList([0x48, 0x65, 0x6C, 0x6C, 0x6F]); // "Hello"
        final result = FileValidator.validateFile(
          fileName: 'test.txt',
          fileSize: 1024,
          fileBytes: txtBytes,
        );

        expect(result, isNull);
      });

      test('should return null for valid DOCX file', () {
        final docxBytes = Uint8List.fromList([0x50, 0x4B, 0x03, 0x04, 0x14]); // PK (zip header with 5 bytes)
        final result = FileValidator.validateFile(
          fileName: 'test.docx',
          fileSize: 1024,
          fileBytes: docxBytes,
        );

        expect(result, isNull);
      });

      test('should return error for null fileName', () {
        final bytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46]);
        final result = FileValidator.validateFile(
          fileName: null,
          fileSize: 1024,
          fileBytes: bytes,
        );

        expect(result, equals("Invalid file (no name)"));
      });

      test('should return error for unsupported file extension', () {
        final bytes = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]); // PNG header
        final result = FileValidator.validateFile(
          fileName: 'test.png',
          fileSize: 1024,
          fileBytes: bytes,
        );

        expect(result, equals("Unsupported file type: png"));
      });

      test('should return error for file too large', () {
        final bytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46]);
        final largeFileSize = FileValidator.maxFileSize + 1;
        final result = FileValidator.validateFile(
          fileName: 'test.pdf',
          fileSize: largeFileSize,
          fileBytes: bytes,
        );

        expect(result, equals("File too large (max 10 MB)"));
      });

      test('should return error for invalid PDF magic numbers', () {
        final invalidPdfBytes = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]); // PNG header
        final result = FileValidator.validateFile(
          fileName: 'test.pdf',
          fileSize: 1024,
          fileBytes: invalidPdfBytes,
        );

        expect(result, equals("File does not look like a valid PDF"));
      });

      test('should return error for invalid DOCX magic numbers', () {
        final invalidDocxBytes = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]); // PNG header
        final result = FileValidator.validateFile(
          fileName: 'test.docx',
          fileSize: 1024,
          fileBytes: invalidDocxBytes,
        );

        expect(result, equals("File does not look like a valid DOCX"));
      });

      test('should handle case insensitive extensions', () {
        final pdfBytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2D]); // %PDF- (5 bytes)
        
        // Test uppercase
        final resultUpper = FileValidator.validateFile(
          fileName: 'test.PDF',
          fileSize: 1024,
          fileBytes: pdfBytes,
        );
        expect(resultUpper, isNull);

        // Test mixed case
        final resultMixed = FileValidator.validateFile(
          fileName: 'test.Pdf',
          fileSize: 1024,
          fileBytes: pdfBytes,
        );
        expect(resultMixed, isNull);
      });

      test('should handle files with multiple dots in name', () {
        final pdfBytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2D]); // %PDF- (5 bytes)
        final result = FileValidator.validateFile(
          fileName: 'test.file.with.dots.pdf',
          fileSize: 1024,
          fileBytes: pdfBytes,
        );

        expect(result, isNull);
      });

      test('should handle empty file name', () {
        final bytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46]);
        final result = FileValidator.validateFile(
          fileName: '',
          fileSize: 1024,
          fileBytes: bytes,
        );

        expect(result, contains("Unsupported file type"));
      });

      test('should handle file name without extension', () {
        final bytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46]);
        final result = FileValidator.validateFile(
          fileName: 'testfile',
          fileSize: 1024,
          fileBytes: bytes,
        );

        expect(result, contains("Unsupported file type"));
      });

      test('should handle maximum allowed file size', () {
        final pdfBytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2D]); // %PDF- (5 bytes)
        final result = FileValidator.validateFile(
          fileName: 'test.pdf',
          fileSize: FileValidator.maxFileSize,
          fileBytes: pdfBytes,
        );

        expect(result, isNull);
      });

      test('should handle zero file size', () {
        final pdfBytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2D]); // %PDF- (5 bytes)
        final result = FileValidator.validateFile(
          fileName: 'test.pdf',
          fileSize: 0,
          fileBytes: pdfBytes,
        );

        expect(result, isNull);
      });
    });

    group('isPdf', () {
      test('should return true for valid PDF magic numbers', () {
        final pdfBytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2D]); // %PDF-
        expect(FileValidator.isPdf(pdfBytes), isTrue);
      });

      test('should return false for invalid PDF magic numbers', () {
        final invalidBytes = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]); // PNG header
        expect(FileValidator.isPdf(invalidBytes), isFalse);
      });

      test('should return false for bytes too short', () {
        final shortBytes = Uint8List.fromList([0x25, 0x50, 0x44]); // Only 3 bytes
        expect(FileValidator.isPdf(shortBytes), isFalse);
      });

      test('should return false for empty bytes', () {
        final emptyBytes = Uint8List.fromList([]);
        expect(FileValidator.isPdf(emptyBytes), isFalse);
      });

      test('should return true for PDF with additional content', () {
        final pdfBytesWithContent = Uint8List.fromList([
          0x25, 0x50, 0x44, 0x46, // %PDF
          0x2D, 0x31, 0x2E, 0x34, // -1.4
          0x0A, 0x25, 0xE2, 0xE3, // Additional PDF content
        ]);
        expect(FileValidator.isPdf(pdfBytesWithContent), isTrue);
      });

      test('should return false for partial PDF magic numbers', () {
        final partialBytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x00]); // %PD + null
        expect(FileValidator.isPdf(partialBytes), isFalse);
      });
    });

    group('isDocx', () {
      test('should return true for valid DOCX magic numbers', () {
        final docxBytes = Uint8List.fromList([0x50, 0x4B, 0x03, 0x04, 0x14]); // PK zip header (5 bytes)
        expect(FileValidator.isDocx(docxBytes), isTrue);
      });

      test('should return true for alternative zip header', () {
        final zipBytes = Uint8List.fromList([0x50, 0x4B, 0x05, 0x06, 0x00]); // PK alternative (5 bytes)
        expect(FileValidator.isDocx(zipBytes), isTrue);
      });

      test('should return false for invalid DOCX magic numbers', () {
        final invalidBytes = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47]); // PNG header
        expect(FileValidator.isDocx(invalidBytes), isFalse);
      });

      test('should return false for bytes too short', () {
        final shortBytes = Uint8List.fromList([0x50]); // Only 1 byte
        expect(FileValidator.isDocx(shortBytes), isFalse);
      });

      test('should return false for empty bytes', () {
        final emptyBytes = Uint8List.fromList([]);
        expect(FileValidator.isDocx(emptyBytes), isFalse);
      });

      test('should return true for DOCX with additional content', () {
        final docxBytesWithContent = Uint8List.fromList([
          0x50, 0x4B, 0x03, 0x04, // PK zip header
          0x14, 0x00, 0x00, 0x00, // Additional zip content
          0x08, 0x00, 0x00, 0x00,
        ]);
        expect(FileValidator.isDocx(docxBytesWithContent), isTrue);
      });

      test('should return false for partial zip magic numbers', () {
        final partialBytes = Uint8List.fromList([0x50, 0x00, 0x03, 0x04]); // P + null + rest
        expect(FileValidator.isDocx(partialBytes), isFalse);
      });
    });

    group('Edge cases and error handling', () {
      test('should handle very large byte arrays', () {
        final largeBytes = Uint8List(1000000);
        largeBytes[0] = 0x25;
        largeBytes[1] = 0x50;
        largeBytes[2] = 0x44;
        largeBytes[3] = 0x46;

        final result = FileValidator.validateFile(
          fileName: 'large.pdf',
          fileSize: 1000000,
          fileBytes: largeBytes,
        );

        expect(result, isNull);
      });

      test('should handle special characters in file names', () {
        final pdfBytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2D]); // %PDF- (5 bytes)
        final result = FileValidator.validateFile(
          fileName: 'test file with spaces & special chars!.pdf',
          fileSize: 1024,
          fileBytes: pdfBytes,
        );

        expect(result, isNull);
      });

      test('should handle unicode characters in file names', () {
        final pdfBytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2D]); // %PDF- (5 bytes)
        final result = FileValidator.validateFile(
          fileName: 'тест_файл_测试文件.pdf',
          fileSize: 1024,
          fileBytes: pdfBytes,
        );

        expect(result, isNull);
      });

      test('should handle file size at boundary conditions', () {
        final pdfBytes = Uint8List.fromList([0x25, 0x50, 0x44, 0x46, 0x2D]); // %PDF- (5 bytes)
        
        // Just under the limit
        final resultUnder = FileValidator.validateFile(
          fileName: 'test.pdf',
          fileSize: FileValidator.maxFileSize - 1,
          fileBytes: pdfBytes,
        );
        expect(resultUnder, isNull);

        // Just over the limit
        final resultOver = FileValidator.validateFile(
          fileName: 'test.pdf',
          fileSize: FileValidator.maxFileSize + 1,
          fileBytes: pdfBytes,
        );
        expect(resultOver, contains("File too large"));
      });
    });
  });
}
