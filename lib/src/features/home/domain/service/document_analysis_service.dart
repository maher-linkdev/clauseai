import 'dart:io';
import 'dart:typed_data';

import 'package:docx_to_text/docx_to_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

// Service provider
final documentAnalysisServiceProvider = Provider<DocumentAnalysisService>((ref) {
  return DocumentAnalysisService();
});

class DocumentAnalysisService {
  // /// Extract text from a document file (PDF, DOC, DOCX, TXT)
  // Future<String> extractTextFromFile(File file) async {
  //   try {
  //     final extension = path.extension(file.path).toLowerCase();
  //
  //     switch (extension) {
  //       case '.pdf':
  //         return await _extractTextFromPdf(file);
  //       case '.doc':
  //       case '.docx':
  //         return await _extractTextFromDocx(file);
  //       case '.txt':
  //         return await _extractTextFromTxt(file);
  //       default:
  //         throw UnsupportedError('Unsupported file format: $extension');
  //     }
  //   } catch (e) {
  //     throw Exception('Failed to extract text from file: ${e.toString()}');
  //   }
  // }
  Future<String> extractTextFromBytes(Uint8List bytes, String fileName) async {
    try {
      final extension = fileName.split('.').last.toLowerCase();

      switch (extension) {
        case 'pdf':
          return await _extractTextFromPdfBytes(bytes);
        case 'doc':
        case 'docx':
          return await _extractTextFromDocxBytes(bytes);
        case 'txt':
          return String.fromCharCodes(bytes).trim();
        default:
          throw UnsupportedError('Unsupported file format: $extension');
      }
    } catch (e) {
      throw Exception('Failed to extract text from bytes: ${e.toString()}');
    }
  }

  /// Extract text from PDF file using Syncfusion PDF (web-compatible)
  Future<String> _extractTextFromPdf(File file) async {
    try {
      final Uint8List bytes = await file.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      String extractedText = '';

      // Extract text from each page
      for (int i = 0; i < document.pages.count; i++) {
        final PdfPage page = document.pages[i];
        final String pageText = PdfTextExtractor(document).extractText(startPageIndex: i);
        extractedText += pageText;

        // Add page separator if not the last page
        if (i < document.pages.count - 1) {
          extractedText += '\n\n--- Page ${i + 2} ---\n\n';
        }
      }

      // Dispose the document
      document.dispose();

      return extractedText.trim();
    } catch (e) {
      throw Exception('Failed to extract text from PDF: ${e.toString()}');
    }
  }

  /// Extract text from DOCX file
  Future<String> _extractTextFromDocx(File file) async {
    try {
      final bytes = await file.readAsBytes();
      final text = docxToText(bytes);
      return text?.trim() ?? '';
    } catch (e) {
      throw Exception('Failed to extract text from DOCX: ${e.toString()}');
    }
  }

  /// Extract text from TXT file
  Future<String> _extractTextFromTxt(File file) async {
    try {
      final text = await file.readAsString();
      return text.trim();
    } catch (e) {
      throw Exception('Failed to extract text from TXT: ${e.toString()}');
    }
  }

  /// Extract text from bytes (useful for web file uploads)

  /// Extract text from PDF bytes (optimized for web)
  Future<String> _extractTextFromPdfBytes(Uint8List bytes) async {
    try {
      final PdfDocument document = PdfDocument(inputBytes: bytes);

      String extractedText = '';

      // Extract text from each page
      for (int i = 0; i < document.pages.count; i++) {
        final PdfPage page = document.pages[i];
        final String pageText = PdfTextExtractor(document).extractText(startPageIndex: i);
        extractedText += pageText;

        // Add page separator if not the last page
        if (i < document.pages.count - 1) {
          extractedText += '\n\n--- Page ${i + 2} ---\n\n';
        }
      }

      // Dispose the document
      document.dispose();

      return extractedText.trim();
    } catch (e) {
      throw Exception('Failed to extract text from PDF bytes: ${e.toString()}');
    }
  }

  /// Extract text from DOCX bytes
  Future<String> _extractTextFromDocxBytes(Uint8List bytes) async {
    try {
      final text = docxToText(bytes);
      return text?.trim() ?? '';
    } catch (e) {
      throw Exception('Failed to extract text from DOCX bytes: ${e.toString()}');
    }
  }

  /// Validate if the extracted text contains meaningful content
  bool isValidExtractedText(String text) {
    if (text.isEmpty) return false;

    // Check if text has at least 10 characters and contains some alphabetic characters
    if (text.length < 10) return false;

    final hasAlphabetic = RegExp(r'[a-zA-Z]').hasMatch(text);
    return hasAlphabetic;
  }

  /// Get supported file extensions
  List<String> getSupportedExtensions() {
    return ['pdf', 'doc', 'docx', 'txt'];
  }

  /// Get file size limit in bytes (10MB for web compatibility)
  int getMaxFileSizeBytes() {
    return 10 * 1024 * 1024; // 10MB
  }

  /// Check if file size is within limits
  bool isFileSizeValid(int fileSizeBytes) {
    return fileSizeBytes <= getMaxFileSizeBytes();
  }
}
