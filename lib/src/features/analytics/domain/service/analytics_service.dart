import 'dart:convert';

import 'package:deal_insights_assistant/src/core/services/logging_service.dart';
import 'package:deal_insights_assistant/src/core/utils/strings_util.dart';
import 'package:deal_insights_assistant/src/features/analytics/data/model/contract_analysis_result_model.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/entity/contract_analysis_result_entity.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Service provider
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  final loggingService = ref.watch(loggingServiceProvider);
  return AnalyticsService(loggingService);
});

class AnalyticsService {
  final LoggingService loggingService;
  GenerativeModel? _model;

  AnalyticsService(this.loggingService);

  // Lazy initialization of Firebase AI model
  GenerativeModel get model {
    _model ??= FirebaseAI.googleAI(useLimitedUseAppCheckTokens: true).generativeModel(model: 'gemini-1.5-flash');
    return _model!;
  }

  // JSON Schema for contract analysis response
  static const String _contractAnalysisSchema = '''
{
  "obligations": [
    {
      "text": "string",
      "party": "string",
      "severity": "LOW | MEDIUM | HIGH | CRITICAL",
      "timeframe": "string | null",
      "confidence": "float (0-1)"
    }
  ],
  "payment_terms": [
    {
      "text": "string",
      "amount": "number | null",
      "currency": "string | null",
      "due_in_days": "number | null",
      "severity": "LOW | MEDIUM | HIGH | CRITICAL",
      "confidence": "float (0-1)"
    }
  ],
  "liabilities": [
    {
      "text": "string",
      "party": "string",
      "cap_type": "CAPPED | UNCAPPED | EXCLUDED",
      "cap_value": "string | null",
      "excluded_damages": ["string"],
      "severity": "LOW | MEDIUM | HIGH | CRITICAL",
      "confidence": "float (0-1)"
    }
  ],
  "risks": [
    {
      "text": "string",
      "severity": "LOW | MEDIUM | HIGH | CRITICAL",
      "likelihood": "LOW | MEDIUM | HIGH",
      "category": "legal | financial | operational | compliance | other",
      "confidence": "float (0-1)",
      "risk_score": "integer (severity × likelihood)"
    }
  ],
  "service_levels": [
    {
      "text": "string",
      "metric": "string",
      "target": "string",
      "severity": "LOW | MEDIUM | HIGH | CRITICAL"
    }
  ],
  "intellectual_property": [
    {
      "text": "string",
      "ownership": "CLIENT | VENDOR | SHARED",
      "severity": "LOW | MEDIUM | HIGH | CRITICAL"
    }
  ],
  "security_requirements": [
    {
      "text": "string",
      "type": "data protection | compliance | access control | audit | other",
      "severity": "LOW | MEDIUM | HIGH | CRITICAL"
    }
  ],
  "user_requirements": [
    {
      "text": "string",
      "category": "functional | non-functional | compliance | integration | other",
      "severity": "LOW | MEDIUM | HIGH | CRITICAL"
    }
  ],
  "conflicts_or_contrasts": [
    {
      "text": "string",
      "conflict_with": "string | null",
      "severity": "LOW | MEDIUM | HIGH | CRITICAL"
    }
  ]
}''';

  /// Build the prompt for contract analysis
  String _buildContractAnalysisPrompt(String documentText) {
    return '''
You are a contract and RFP analysis assistant specialized in the technology field.

Your job is to analyze contract or RFP documents and produce a structured JSON summary.

Focus on these areas:
- Obligations (who must do what, deadlines, responsibilities)
- Payment terms (amounts, timing, conditions)
- Liabilities (caps, exclusions, indemnities, parties responsible)
- Risks (operational, legal, compliance, financial) with severity and likelihood
- Service levels (SLAs) (uptime, response times, resolution times)
- Intellectual property (ownership of deliverables, licensing, source code rights)
- Security requirements (data protection, compliance, audits, access control)
- User requirements (functional, non-functional, integrations, compliance)
- Conflicts or contrasts (clauses that contradict or create ambiguity)
CRITICAL: You MUST respond with ONLY a valid JSON object that follows this EXACT structure. Do not include any explanatory text, markdown formatting, or additional commentary.


Required JSON Structure (follow this exactly):
$_contractAnalysisSchema

IMPORTANT FORMATTING RULES:
1. Return ONLY the JSON object - no markdown, no explanations, no extra text
2. Use the exact field names shown in the schema
3. For "text" fields, extract the actual clause text from the document
4. For severity, use only: LOW, MEDIUM, HIGH, or CRITICAL
5. For confidence, use decimal values between 0.0 and 1.0
6. If a section has no items, use an empty array []
7. Do NOT use "clause" or "breakdown" fields - use the flat structure shown

Document to analyze:
$documentText

Respond with the JSON object only:''';
  }

  /// Analyze contract or RFP document and return structured result
  Future<ContractAnalysisResultEntity> analyzeContract(String documentText) async {
    final stopwatch = Stopwatch()..start();

    try {
      loggingService.methodEntry('AnalyticsService', 'analyzeContract', {
        'documentTextLength': documentText.length,
        'documentPreview': documentText.substring(0, documentText.length > 100 ? 100 : documentText.length),
      });

      final prompt = _buildContractAnalysisPrompt(documentText);
      loggingService.info('Sending contract analysis request to Firebase AI');

      final response = await model.generateContent([Content.text(prompt)]);

      loggingService.info('Received response from Firebase AI');
      loggingService.debug('Response thought summary: ${response.thoughtSummary ?? 'No summary'}');

      if (response.text == null || response.text!.isEmpty) {
        loggingService.error('No analysis generated from the document - empty response');
        throw Exception('No analysis generated from the document');
      }

      loggingService.debug(
        'Raw response text received (first 200 chars): ${response.text!.substring(0, response.text!.length > 200 ? 200 : response.text!.length)}',
      );

      String jsonString = StringsUtil.cleanJsonResponseString(response.text!);
      loggingService.debug('Cleaned JSON string for parsing');

      // Parse the JSON response
      final jsonResponse = jsonDecode(jsonString);
      final result = ContractAnalysisResultModel.fromJson(jsonResponse as Map<String, dynamic>);

      stopwatch.stop();
      loggingService.performance('Contract Analysis', stopwatch.elapsed, {
        'documentLength': documentText.length,
        'responseLength': response.text!.length,
        'obligationsCount': result.obligations?.length ?? 0,
        'risksCount': result.risks?.length ?? 0,
        'paymentTermsCount': result.paymentTerms?.length ?? 0,
        'liabilitiesCount': result.liabilities?.length ?? 0,
      });

      loggingService.methodExit('AnalyticsService', 'analyzeContract', 'Success');
      return result;
    } catch (e, stackTrace) {
      stopwatch.stop();
      loggingService.error('Contract analysis failed after ${stopwatch.elapsed.inMilliseconds}ms', e, stackTrace);

      if (e is FormatException) {
        loggingService.businessError('JSON Parsing', 'Invalid JSON response from AI model', e, stackTrace);
        throw Exception('Invalid JSON response from AI model: ${e.toString()}');
      }

      loggingService.businessError('Contract Analysis', 'Failed to analyze contract', e, stackTrace);
      throw Exception('Failed to analyze contract: ${e.toString()}');
    }
  }

  /// Validate if the document text is suitable for contract analysis
  bool isValidForAnalysis(String text) {
    if (text.trim().isEmpty) return false;
    if (text.trim().length < 100) return false;
    if (text.trim().split(' ').length < 20) return false;

    return true;
  }
}
