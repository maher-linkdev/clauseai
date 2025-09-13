import 'dart:convert';

import 'package:deal_insights_assistant/src/core/utils/strings_util.dart';
import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/contract_analysis_result.dart';

// Service provider
final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

class AnalyticsService {
  late final GenerativeModel _model;

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

  AnalyticsService() {
    // Initialize Firebase App Check for security

    // Initialize Firebase AI model with App Check protection
    _model = FirebaseAI.googleAI(useLimitedUseAppCheckTokens: true).generativeModel(model: 'gemini-1.5-flash');
  }

  /// Analyze contract or RFP document and return structured result
  Future<ContractAnalysisResult> analyzeContract(String documentText) async {
    try {
      final prompt = _buildContractAnalysisPrompt(documentText);
      final response = await _model.generateContent([Content.text(prompt)]);
      print("response summary${response.thoughtSummary}");
      print("response text ${response.text}");
      if (response.text == null || response.text!.isEmpty) {
        throw Exception('No analysis generated from the document');
      }
      String jsonString = StringsUtil.cleanJsonResponseString(response.text!);

      // Parse the JSON response
      final jsonResponse = jsonDecode(jsonString);
      return ContractAnalysisResult.fromJson(jsonResponse as Map<String, dynamic>);
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid JSON response from AI model: ${e.toString()}');
      }
      throw Exception('Failed to analyze contract: ${e.toString()}');
    }
  }

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

  /// Validate if the document text is suitable for contract analysis
  bool isValidForAnalysis(String text) {
    if (text.isEmpty) return false;

    // Check minimum length (at least 100 characters)
    if (text.length < 100) return false;

    // Check if text contains meaningful content (not just special characters)
    final hasAlphabetic = RegExp(r'[a-zA-Z]').hasMatch(text);
    if (!hasAlphabetic) return false;

    // Check if text has reasonable word count (at least 20 words)
    final wordCount = text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
    if (wordCount < 20) return false;

    return true;
  }
}
