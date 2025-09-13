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
    if (text.trim().isEmpty) return false;
    if (text.trim().length < 100) return false;
    if (text.trim().split(' ').length < 20) return false;

    return true;
  }

  /// Create a test ContractAnalysisResult for testing purposes
  /// TODO: Remove this method once real AI integration is working
  ContractAnalysisResult createTestResult() {
    return ContractAnalysisResult(
      obligations: [
        Obligation(
          text:
              "The selected vendor shall be responsible for: 1. Infrastructure Management - 24/7 monitoring of servers, storage, and networking. - Ensuring uptime of at least 99.5% per month. - Implementing automated failover and disaster recovery. 2. Compliance & Security - Compliance with GDPR, HIPAA, and ISO 27001 standards. - Quarterly penetration testing and annual external audits. - Encryption of all data at rest and in transit. 3. Reporting - Monthly performance reports including SLA adherence. - Incident reports within 24 hours of occurrence. - Quarterly strategic review meetings.",
          party: "Vendor",
          severity: Severity.high,
          timeframe: "24 months, with two optional one-year extensions",
          confidence: 0.9,
        ),
        Obligation(
          text: "Vendor must provide detailed invoices with cost breakdowns.",
          party: "Vendor",
          severity: Severity.medium,
          timeframe: "Ongoing",
          confidence: 0.8,
        ),
        Obligation(
          text: "Vendor agrees not to disclose any confidential information obtained during the course of the project.",
          party: "Vendor",
          severity: Severity.high,
          timeframe: "Throughout contract duration",
          confidence: 0.9,
        ),
        Obligation(
          text: "All employees must sign NDAs before project commencement.",
          party: "Vendor",
          severity: Severity.high,
          timeframe: "Before project start",
          confidence: 0.9,
        ),
        Obligation(
          text: "Vendor must provide an incident response plan within 30 days of contract signing.",
          party: "Vendor",
          severity: Severity.high,
          timeframe: "30 days of contract signing",
          confidence: 0.9,
        ),
        Obligation(
          text: "Upon termination, vendor must return all company data within 15 days.",
          party: "Vendor",
          severity: Severity.high,
          timeframe: "15 days of termination",
          confidence: 0.9,
        ),
        Obligation(
          text: "Proposals must be submitted electronically in PDF format by 25 September 2025.",
          party: "Vendor",
          severity: Severity.high,
          timeframe: "25 September 2025",
          confidence: 0.95,
        ),
      ],
      paymentTerms: [
        PaymentTerm(
          text: "Payment will be made on a net 45 days basis after receipt of invoice.",
          amount: null,
          currency: null,
          dueInDays: 45,
          severity: Severity.medium,
          confidence: 0.8,
        ),
        PaymentTerm(
          text: "Late payments beyond 15 days will incur a 5% penalty fee.",
          amount: null,
          currency: null,
          dueInDays: 15,
          severity: Severity.medium,
          confidence: 0.8,
        ),
        PaymentTerm(
          text: "Additional services outside scope require written approval and separate invoicing.",
          amount: null,
          currency: null,
          dueInDays: null,
          severity: Severity.low,
          confidence: 0.7,
        ),
      ],
      liabilities: [
        Liability(
          text: "Vendor shall be liable for direct damages up to 150% of the contract value.",
          party: "Vendor",
          capType: CapType.capped,
          capValue: "150% of the contract value",
          excludedDamages: ["indirect or consequential damages"],
          severity: Severity.high,
          confidence: 0.9,
        ),
        Liability(
          text: "Vendor shall maintain professional indemnity insurance coverage.",
          party: "Vendor",
          capType: CapType.uncapped,
          capValue: null,
          excludedDamages: [],
          severity: Severity.medium,
          confidence: 0.8,
        ),
      ],
      risks: [
        Risk(
          text: "Risk of data breach must be mitigated through encryption, access control, and continuous monitoring.",
          severity: Severity.high,
          likelihood: Likelihood.medium,
          category: RiskCategory.operational,
          confidence: 0.8,
          riskScore: 6,
        ),
        Risk(
          text: "Breach of confidentiality may result in immediate termination of the contract and legal action.",
          severity: Severity.critical,
          likelihood: Likelihood.low,
          category: RiskCategory.legal,
          confidence: 0.7,
          riskScore: 4,
        ),
      ],
      serviceLevels: [
        ServiceLevel(
          text: "Ensuring uptime of at least 99.5% per month.",
          metric: "uptime",
          target: "99.5%",
          severity: Severity.high,
        ),
      ],
      intellectualProperty: [],
      securityRequirements: [
        SecurityRequirement(
          text: "Compliance with GDPR, HIPAA, and ISO 27001 standards.",
          type: SecurityType.compliance,
          severity: Severity.high,
        ),
        SecurityRequirement(
          text: "Quarterly penetration testing and annual external audits.",
          type: SecurityType.audit,
          severity: Severity.high,
        ),
        SecurityRequirement(
          text: "Encryption of all data at rest and in transit.",
          type: SecurityType.dataProtection,
          severity: Severity.high,
        ),
      ],
      userRequirements: [],
      conflictsOrContrasts: [],
    );
  }
}
