import 'dart:typed_data';

import 'package:deal_insights_assistant/src/features/home/domain/service/document_analysis_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DocumentAnalysisService', () {
    late DocumentAnalysisService service;

    setUp(() {
      service = DocumentAnalysisService();
    });

    group('getSupportedExtensions', () {
      test('should return correct supported extensions', () {
        final extensions = service.getSupportedExtensions();

        expect(extensions, hasLength(4));
        expect(extensions, contains('pdf'));
        expect(extensions, contains('doc'));
        expect(extensions, contains('docx'));
        expect(extensions, contains('txt'));
      });

      test('should return list of strings', () {
        final extensions = service.getSupportedExtensions();

        for (final extension in extensions) {
          expect(extension, isA<String>());
          expect(extension.isNotEmpty, isTrue);
        }
      });
    });

    group('getMaxFileSizeBytes', () {
      test('should return 10MB limit', () {
        final maxSize = service.getMaxFileSizeBytes();
        expect(maxSize, equals(10 * 1024 * 1024)); // 10MB
      });

      test('should return positive value', () {
        final maxSize = service.getMaxFileSizeBytes();
        expect(maxSize, greaterThan(0));
      });
    });

    group('isFileSizeValid', () {
      test('should return true for valid file sizes', () {
        final maxSize = service.getMaxFileSizeBytes();

        expect(service.isFileSizeValid(0), isTrue);
        expect(service.isFileSizeValid(1024), isTrue); // 1KB
        expect(service.isFileSizeValid(1024 * 1024), isTrue); // 1MB
        expect(service.isFileSizeValid(maxSize), isTrue); // Exactly at limit
        expect(service.isFileSizeValid(maxSize - 1), isTrue); // Just under limit
      });

      test('should return false for oversized files', () {
        final maxSize = service.getMaxFileSizeBytes();

        expect(service.isFileSizeValid(maxSize + 1), isFalse); // Just over limit
        expect(service.isFileSizeValid(maxSize * 2), isFalse); // Double the limit
        expect(service.isFileSizeValid(100 * 1024 * 1024), isFalse); // 100MB
      });
    });

    group('isValidExtractedText', () {
      test('should return true for valid text', () {
        expect(service.isValidExtractedText('This is a valid contract text with sufficient content.'), isTrue);
        expect(service.isValidExtractedText('Contract terms and conditions apply here.'), isTrue);
        expect(service.isValidExtractedText('WHEREAS the parties agree to the following terms...'), isTrue);
      });

      test('should return false for invalid text', () {
        expect(service.isValidExtractedText(''), isFalse); // Empty
        expect(service.isValidExtractedText('   '), isFalse); // Only whitespace
        expect(service.isValidExtractedText('123456789'), isFalse); // Too short
        expect(service.isValidExtractedText('1234567890'), isFalse); // Exactly 10 chars but no letters
        expect(service.isValidExtractedText('12345678901234567890'), isFalse); // Long but no letters
      });

      test('should require alphabetic characters', () {
        expect(service.isValidExtractedText('This has letters and numbers 123'), isTrue);
        expect(service.isValidExtractedText('1234567890!@#\$%^&*()'), isFalse); // No letters
        expect(service.isValidExtractedText('a234567890'), isTrue); // Has one letter
      });

      test('should require minimum length', () {
        expect(service.isValidExtractedText('abc'), isFalse); // Too short
        expect(service.isValidExtractedText('abcdefghij'), isTrue); // Exactly 10 chars with letters
        expect(service.isValidExtractedText('abcdefghijk'), isTrue); // More than 10 chars
      });

      test('should handle special characters and formatting', () {
        expect(service.isValidExtractedText('Contract\nwith\nnewlines\nand\nspaces'), isTrue);
        expect(service.isValidExtractedText('Contract with special chars: @#\$%^&*()'), isTrue);
        expect(service.isValidExtractedText('Contract with unicode: café résumé naïve'), isTrue);
      });
    });

    group('extractTextFromBytes', () {
      test('should handle TXT files correctly', () async {
        final txtContent = 'This is a test contract document with sufficient content for validation.';
        final txtBytes = Uint8List.fromList(txtContent.codeUnits);

        final result = await service.extractTextFromBytes(txtBytes, 'test.txt');

        expect(result, equals(txtContent));
        expect(service.isValidExtractedText(result), isTrue);
      });

      test('should throw exception for unsupported file types', () async {
        final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);

        expect(() => service.extractTextFromBytes(bytes, 'test.xyz'), throwsA(isA<Exception>()));

        expect(() => service.extractTextFromBytes(bytes, 'test.png'), throwsA(isA<Exception>()));
      });

      test('should handle files without extension', () async {
        final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);

        expect(() => service.extractTextFromBytes(bytes, 'testfile'), throwsA(isA<Exception>()));
      });

      test('should handle empty filename', () async {
        final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);

        expect(() => service.extractTextFromBytes(bytes, ''), throwsA(isA<Exception>()));
      });

      test('should handle case insensitive extensions', () async {
        final txtContent = 'Test content for case sensitivity validation.';
        final txtBytes = Uint8List.fromList(txtContent.codeUnits);

        final resultLower = await service.extractTextFromBytes(txtBytes, 'test.txt');
        final resultUpper = await service.extractTextFromBytes(txtBytes, 'test.TXT');
        final resultMixed = await service.extractTextFromBytes(txtBytes, 'test.Txt');

        expect(resultLower, equals(txtContent));
        expect(resultUpper, equals(txtContent));
        expect(resultMixed, equals(txtContent));
      });

      test('should trim whitespace from extracted text', () async {
        final txtContent = '   \n\t  This is content with whitespace  \n\t   ';
        final txtBytes = Uint8List.fromList(txtContent.codeUnits);

        final result = await service.extractTextFromBytes(txtBytes, 'test.txt');

        expect(result, equals('This is content with whitespace'));
        expect(result.startsWith(' '), isFalse);
        expect(result.endsWith(' '), isFalse);
      });

      test('should handle empty TXT files', () async {
        final emptyBytes = Uint8List.fromList([]);

        final result = await service.extractTextFromBytes(emptyBytes, 'empty.txt');

        expect(result, equals(''));
        expect(service.isValidExtractedText(result), isFalse);
      });

      test('should handle TXT files with only whitespace', () async {
        final whitespaceContent = '   \n\t\r   ';
        final whitespaceBytes = Uint8List.fromList(whitespaceContent.codeUnits);

        final result = await service.extractTextFromBytes(whitespaceBytes, 'whitespace.txt');

        expect(result, equals(''));
        expect(service.isValidExtractedText(result), isFalse);
      });
    });

    group('Error Handling', () {
      test('should provide meaningful error messages', () async {
        final bytes = Uint8List.fromList([1, 2, 3, 4, 5]);

        try {
          await service.extractTextFromBytes(bytes, 'test.unknown');
          fail('Should have thrown an exception');
        } catch (e) {
          expect(e.toString(), contains('Failed to extract text from bytes'));
          expect(e.toString(), contains('Unsupported file format'));
        }
      });

      test('should handle null or invalid bytes gracefully', () async {
        // Test with empty bytes for unsupported format
        final emptyBytes = Uint8List.fromList([]);

        expect(() => service.extractTextFromBytes(emptyBytes, 'test.unknown'), throwsA(isA<Exception>()));
      });
    });

    group('Integration with File Validation', () {
      test('should work with FileValidator supported extensions', () {
        final serviceExtensions = service.getSupportedExtensions();
        final expectedExtensions = ['pdf', 'txt', 'docx']; // From FileValidator

        for (final ext in expectedExtensions) {
          expect(serviceExtensions, contains(ext));
        }
      });

      test('should have consistent file size limits', () {
        final serviceMaxSize = service.getMaxFileSizeBytes();
        final expectedMaxSize = 10 * 1024 * 1024; // 10MB from FileValidator

        expect(serviceMaxSize, equals(expectedMaxSize));
      });
    });

    group('Performance', () {
      test('should handle text extraction efficiently', () async {
        final content = 'Test contract content for performance testing.';
        final bytes = Uint8List.fromList(content.codeUnits);

        final stopwatch = Stopwatch()..start();
        final result = await service.extractTextFromBytes(bytes, 'test.txt');
        stopwatch.stop();

        expect(result, equals(content));
        expect(stopwatch.elapsedMilliseconds, lessThan(100)); // Should be very fast for TXT
      });

      test('should validate text efficiently', () {
        final testTexts = [
          'Valid contract text with sufficient content.',
          'Another valid contract document.',
          'Short', // Invalid
          '', // Invalid
          '1234567890', // Invalid - no letters
        ];

        final stopwatch = Stopwatch()..start();

        for (final text in testTexts) {
          service.isValidExtractedText(text);
        }

        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(10)); // Should be very fast
      });
    });

    group('Edge Cases', () {
      test('should handle filename with multiple dots', () async {
        final content = 'Test content for file with multiple dots in name.';
        final bytes = Uint8List.fromList(content.codeUnits);

        final result = await service.extractTextFromBytes(bytes, 'test.file.with.dots.txt');

        expect(result, equals(content));
      });

      test('should handle filename with path separators', () async {
        final content = 'Test content for file with path in name.';
        final bytes = Uint8List.fromList(content.codeUnits);

        // Should work with just the extension
        final result = await service.extractTextFromBytes(bytes, '/path/to/file.txt');

        expect(result, equals(content));
      });

      test('should handle very long filenames', () async {
        final content = 'Test content for file with very long name.';
        final bytes = Uint8List.fromList(content.codeUnits);
        final longName = 'a' * 200 + '.txt';

        final result = await service.extractTextFromBytes(bytes, longName);

        expect(result, equals(content));
      });
    });
  });
}
