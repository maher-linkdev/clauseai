import 'package:flutter/foundation.dart';

@immutable
class ContractAnalysisResult {
  final List<Obligation>? obligations;
  final List<PaymentTerm>? paymentTerms;
  final List<Liability>? liabilities;
  final List<Risk>? risks;
  final List<ServiceLevel>? serviceLevels;
  final List<IntellectualProperty>? intellectualProperty;
  final List<SecurityRequirement>? securityRequirements;
  final List<UserRequirement>? userRequirements;
  final List<ConflictOrContrast>? conflictsOrContrasts;

  const ContractAnalysisResult({
    this.obligations,
    this.paymentTerms,
    this.liabilities,
    this.risks,
    this.serviceLevels,
    this.intellectualProperty,
    this.securityRequirements,
    this.userRequirements,
    this.conflictsOrContrasts,
  });

  factory ContractAnalysisResult.fromJson(Map<String, dynamic> json) {
    return ContractAnalysisResult(
      obligations: json['obligations'] != null
          ? (json['obligations'] as List).map((e) => Obligation.fromJson(e)).toList()
          : null,
      paymentTerms: json['payment_terms'] != null
          ? (json['payment_terms'] as List).map((e) => PaymentTerm.fromJson(e)).toList()
          : null,
      liabilities: json['liabilities'] != null
          ? (json['liabilities'] as List).map((e) => Liability.fromJson(e)).toList()
          : null,
      risks: json['risks'] != null
          ? (json['risks'] as List).map((e) => Risk.fromJson(e)).toList()
          : null,
      serviceLevels: json['service_levels'] != null
          ? (json['service_levels'] as List).map((e) => ServiceLevel.fromJson(e)).toList()
          : null,
      intellectualProperty: json['intellectual_property'] != null
          ? (json['intellectual_property'] as List).map((e) => IntellectualProperty.fromJson(e)).toList()
          : null,
      securityRequirements: json['security_requirements'] != null
          ? (json['security_requirements'] as List).map((e) => SecurityRequirement.fromJson(e)).toList()
          : null,
      userRequirements: json['user_requirements'] != null
          ? (json['user_requirements'] as List).map((e) => UserRequirement.fromJson(e)).toList()
          : null,
      conflictsOrContrasts: json['conflicts_or_contrasts'] != null
          ? (json['conflicts_or_contrasts'] as List).map((e) => ConflictOrContrast.fromJson(e)).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'obligations': obligations?.map((e) => e.toJson()).toList(),
      'payment_terms': paymentTerms?.map((e) => e.toJson()).toList(),
      'liabilities': liabilities?.map((e) => e.toJson()).toList(),
      'risks': risks?.map((e) => e.toJson()).toList(),
      'service_levels': serviceLevels?.map((e) => e.toJson()).toList(),
      'intellectual_property': intellectualProperty?.map((e) => e.toJson()).toList(),
      'security_requirements': securityRequirements?.map((e) => e.toJson()).toList(),
      'user_requirements': userRequirements?.map((e) => e.toJson()).toList(),
      'conflicts_or_contrasts': conflictsOrContrasts?.map((e) => e.toJson()).toList(),
    };
  }
}

enum Severity { low, medium, high, critical }

enum Likelihood { low, medium, high }

enum CapType { capped, uncapped, excluded }

enum Ownership { client, vendor, shared }

enum RiskCategory { legal, financial, operational, compliance, other }

enum SecurityType { dataProtection, compliance, accessControl, audit, other }

enum UserRequirementCategory { functional, nonFunctional, compliance, integration, other }

@immutable
class Obligation {
  final String text;
  final String party;
  final Severity severity;
  final String? timeframe;
  final double confidence;

  const Obligation({
    required this.text,
    required this.party,
    required this.severity,
    this.timeframe,
    required this.confidence,
  });

  factory Obligation.fromJson(Map<String, dynamic> json) {
    return Obligation(
      text: json['text'],
      party: json['party'],
      severity: _parseSeverity(json['severity']),
      timeframe: json['timeframe'],
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'party': party,
      'severity': severity.name.toUpperCase(),
      'timeframe': timeframe,
      'confidence': confidence,
    };
  }
}

@immutable
class PaymentTerm {
  final String text;
  final double? amount;
  final String? currency;
  final int? dueInDays;
  final Severity severity;
  final double confidence;

  const PaymentTerm({
    required this.text,
    this.amount,
    this.currency,
    this.dueInDays,
    required this.severity,
    required this.confidence,
  });

  factory PaymentTerm.fromJson(Map<String, dynamic> json) {
    return PaymentTerm(
      text: json['text'],
      amount: json['amount']?.toDouble(),
      currency: json['currency'],
      dueInDays: json['due_in_days'],
      severity: _parseSeverity(json['severity']),
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'amount': amount,
      'currency': currency,
      'due_in_days': dueInDays,
      'severity': severity.name.toUpperCase(),
      'confidence': confidence,
    };
  }
}

@immutable
class Liability {
  final String text;
  final String party;
  final CapType capType;
  final String? capValue;
  final List<String> excludedDamages;
  final Severity severity;
  final double confidence;

  const Liability({
    required this.text,
    required this.party,
    required this.capType,
    this.capValue,
    required this.excludedDamages,
    required this.severity,
    required this.confidence,
  });

  factory Liability.fromJson(Map<String, dynamic> json) {
    return Liability(
      text: json['text'],
      party: json['party'],
      capType: _parseCapType(json['cap_type']),
      capValue: json['cap_value'],
      excludedDamages: List<String>.from(json['excluded_damages'] ?? []),
      severity: _parseSeverity(json['severity']),
      confidence: (json['confidence'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'party': party,
      'cap_type': capType.name.toUpperCase(),
      'cap_value': capValue,
      'excluded_damages': excludedDamages,
      'severity': severity.name.toUpperCase(),
      'confidence': confidence,
    };
  }
}

@immutable
class Risk {
  final String text;
  final Severity severity;
  final Likelihood likelihood;
  final RiskCategory category;
  final double confidence;
  final int riskScore;

  const Risk({
    required this.text,
    required this.severity,
    required this.likelihood,
    required this.category,
    required this.confidence,
    required this.riskScore,
  });

  factory Risk.fromJson(Map<String, dynamic> json) {
    return Risk(
      text: json['text'],
      severity: _parseSeverity(json['severity']),
      likelihood: _parseLikelihood(json['likelihood']),
      category: _parseRiskCategory(json['category']),
      confidence: (json['confidence'] as num).toDouble(),
      riskScore: json['risk_score'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'severity': severity.name.toUpperCase(),
      'likelihood': likelihood.name.toUpperCase(),
      'category': category.name,
      'confidence': confidence,
      'risk_score': riskScore,
    };
  }
}

@immutable
class ServiceLevel {
  final String text;
  final String metric;
  final String target;
  final Severity severity;

  const ServiceLevel({
    required this.text,
    required this.metric,
    required this.target,
    required this.severity,
  });

  factory ServiceLevel.fromJson(Map<String, dynamic> json) {
    return ServiceLevel(
      text: json['text'],
      metric: json['metric'],
      target: json['target'],
      severity: _parseSeverity(json['severity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'metric': metric,
      'target': target,
      'severity': severity.name.toUpperCase(),
    };
  }
}

@immutable
class IntellectualProperty {
  final String text;
  final Ownership ownership;
  final Severity severity;

  const IntellectualProperty({
    required this.text,
    required this.ownership,
    required this.severity,
  });

  factory IntellectualProperty.fromJson(Map<String, dynamic> json) {
    return IntellectualProperty(
      text: json['text'],
      ownership: _parseOwnership(json['ownership']),
      severity: _parseSeverity(json['severity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'ownership': ownership.name.toUpperCase(),
      'severity': severity.name.toUpperCase(),
    };
  }
}

@immutable
class SecurityRequirement {
  final String text;
  final SecurityType type;
  final Severity severity;

  const SecurityRequirement({
    required this.text,
    required this.type,
    required this.severity,
  });

  factory SecurityRequirement.fromJson(Map<String, dynamic> json) {
    return SecurityRequirement(
      text: json['text'],
      type: _parseSecurityType(json['type']),
      severity: _parseSeverity(json['severity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'type': _securityTypeToString(type),
      'severity': severity.name.toUpperCase(),
    };
  }
}

@immutable
class UserRequirement {
  final String text;
  final UserRequirementCategory category;
  final Severity severity;

  const UserRequirement({
    required this.text,
    required this.category,
    required this.severity,
  });

  factory UserRequirement.fromJson(Map<String, dynamic> json) {
    return UserRequirement(
      text: json['text'],
      category: _parseUserRequirementCategory(json['category']),
      severity: _parseSeverity(json['severity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'category': _userRequirementCategoryToString(category),
      'severity': severity.name.toUpperCase(),
    };
  }
}

@immutable
class ConflictOrContrast {
  final String text;
  final String? conflictWith;
  final Severity severity;

  const ConflictOrContrast({
    required this.text,
    this.conflictWith,
    required this.severity,
  });

  factory ConflictOrContrast.fromJson(Map<String, dynamic> json) {
    return ConflictOrContrast(
      text: json['text'],
      conflictWith: json['conflict_with'],
      severity: _parseSeverity(json['severity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'conflict_with': conflictWith,
      'severity': severity.name.toUpperCase(),
    };
  }
}

// Helper parsing functions
Severity _parseSeverity(String severity) {
  switch (severity.toLowerCase()) {
    case 'low':
      return Severity.low;
    case 'medium':
      return Severity.medium;
    case 'high':
      return Severity.high;
    case 'critical':
      return Severity.critical;
    default:
      return Severity.low;
  }
}

Likelihood _parseLikelihood(String likelihood) {
  switch (likelihood.toLowerCase()) {
    case 'low':
      return Likelihood.low;
    case 'medium':
      return Likelihood.medium;
    case 'high':
      return Likelihood.high;
    default:
      return Likelihood.low;
  }
}

CapType _parseCapType(String capType) {
  switch (capType.toLowerCase()) {
    case 'capped':
      return CapType.capped;
    case 'uncapped':
      return CapType.uncapped;
    case 'excluded':
      return CapType.excluded;
    default:
      return CapType.capped;
  }
}

Ownership _parseOwnership(String ownership) {
  switch (ownership.toLowerCase()) {
    case 'client':
      return Ownership.client;
    case 'vendor':
      return Ownership.vendor;
    case 'shared':
      return Ownership.shared;
    default:
      return Ownership.client;
  }
}

RiskCategory _parseRiskCategory(String category) {
  switch (category.toLowerCase()) {
    case 'legal':
      return RiskCategory.legal;
    case 'financial':
      return RiskCategory.financial;
    case 'operational':
      return RiskCategory.operational;
    case 'compliance':
      return RiskCategory.compliance;
    case 'other':
      return RiskCategory.other;
    default:
      return RiskCategory.other;
  }
}

SecurityType _parseSecurityType(String type) {
  switch (type.toLowerCase().replaceAll(' ', '')) {
    case 'dataprotection':
      return SecurityType.dataProtection;
    case 'compliance':
      return SecurityType.compliance;
    case 'accesscontrol':
      return SecurityType.accessControl;
    case 'audit':
      return SecurityType.audit;
    case 'other':
      return SecurityType.other;
    default:
      return SecurityType.other;
  }
}

String _securityTypeToString(SecurityType type) {
  switch (type) {
    case SecurityType.dataProtection:
      return 'data protection';
    case SecurityType.compliance:
      return 'compliance';
    case SecurityType.accessControl:
      return 'access control';
    case SecurityType.audit:
      return 'audit';
    case SecurityType.other:
      return 'other';
  }
}

UserRequirementCategory _parseUserRequirementCategory(String category) {
  switch (category.toLowerCase().replaceAll('-', '').replaceAll(' ', '')) {
    case 'functional':
      return UserRequirementCategory.functional;
    case 'nonfunctional':
      return UserRequirementCategory.nonFunctional;
    case 'compliance':
      return UserRequirementCategory.compliance;
    case 'integration':
      return UserRequirementCategory.integration;
    case 'other':
      return UserRequirementCategory.other;
    default:
      return UserRequirementCategory.other;
  }
}

String _userRequirementCategoryToString(UserRequirementCategory category) {
  switch (category) {
    case UserRequirementCategory.functional:
      return 'functional';
    case UserRequirementCategory.nonFunctional:
      return 'non-functional';
    case UserRequirementCategory.compliance:
      return 'compliance';
    case UserRequirementCategory.integration:
      return 'integration';
    case UserRequirementCategory.other:
      return 'other';
  }
}
