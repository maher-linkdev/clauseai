import 'package:deal_insights_assistant/src/core/enum/cap_type_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/likelihood_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/ownership_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/risk_category_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/security_type_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/severity_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/user_requirements_category.dart';
import 'package:flutter/foundation.dart';

import '../entity/contract_analysis_result_entity.dart';

@immutable
class ContractAnalysisResult extends ContractAnalysisResultEntity {
  const ContractAnalysisResult({
    super.obligations,
    super.paymentTerms,
    super.liabilities,
    super.risks,
    super.serviceLevels,
    super.intellectualProperty,
    super.securityRequirements,
    super.userRequirements,
    super.conflictsOrContrasts,
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
      risks: json['risks'] != null ? (json['risks'] as List).map((e) => Risk.fromJson(e)).toList() : null,
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
      'obligations': obligations?.map((e) => (e as Obligation).toJson()).toList(),
      'payment_terms': paymentTerms?.map((e) => (e as PaymentTerm).toJson()).toList(),
      'liabilities': liabilities?.map((e) => (e as Liability).toJson()).toList(),
      'risks': risks?.map((e) => (e as Risk).toJson()).toList(),
      'service_levels': serviceLevels?.map((e) => (e as ServiceLevel).toJson()).toList(),
      'intellectual_property': intellectualProperty?.map((e) => (e as IntellectualProperty).toJson()).toList(),
      'security_requirements': securityRequirements?.map((e) => (e as SecurityRequirement).toJson()).toList(),
      'user_requirements': userRequirements?.map((e) => (e as UserRequirement).toJson()).toList(),
      'conflicts_or_contrasts': conflictsOrContrasts?.map((e) => (e as ConflictOrContrast).toJson()).toList(),
    };
  }

  ContractAnalysisResultEntity toEntity() {
    return ContractAnalysisResultEntity(
      obligations: obligations,
      paymentTerms: paymentTerms,
      liabilities: liabilities,
      risks: risks,
      serviceLevels: serviceLevels,
      intellectualProperty: intellectualProperty,
      securityRequirements: securityRequirements,
      userRequirements: userRequirements,
      conflictsOrContrasts: conflictsOrContrasts,
    );
  }

  @override
  ContractAnalysisResult copyWith({
    List<ObligationEntity>? obligations,
    List<PaymentTermEntity>? paymentTerms,
    List<LiabilityEntity>? liabilities,
    List<RiskEntity>? risks,
    List<ServiceLevelEntity>? serviceLevels,
    List<IntellectualPropertyEntity>? intellectualProperty,
    List<SecurityRequirementEntity>? securityRequirements,
    List<UserRequirementEntity>? userRequirements,
    List<ConflictOrContrastEntity>? conflictsOrContrasts,
  }) {
    return ContractAnalysisResult(
      obligations: obligations ?? this.obligations,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      liabilities: liabilities ?? this.liabilities,
      risks: risks ?? this.risks,
      serviceLevels: serviceLevels ?? this.serviceLevels,
      intellectualProperty: intellectualProperty ?? this.intellectualProperty,
      securityRequirements: securityRequirements ?? this.securityRequirements,
      userRequirements: userRequirements ?? this.userRequirements,
      conflictsOrContrasts: conflictsOrContrasts ?? this.conflictsOrContrasts,
    );
  }
}

@immutable
class Obligation extends ObligationEntity {
  const Obligation({
    required super.text,
    required super.party,
    required super.severity,
    super.timeframe,
    required super.confidence,
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

  @override
  Obligation copyWith({String? text, String? party, Severity? severity, String? timeframe, double? confidence}) {
    return Obligation(
      text: text ?? this.text,
      party: party ?? this.party,
      severity: severity ?? this.severity,
      timeframe: timeframe ?? this.timeframe,
      confidence: confidence ?? this.confidence,
    );
  }
}

@immutable
class PaymentTerm extends PaymentTermEntity {
  const PaymentTerm({
    required super.text,
    super.amount,
    super.currency,
    super.dueInDays,
    required super.severity,
    required super.confidence,
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

  @override
  PaymentTerm copyWith({
    String? text,
    double? amount,
    String? currency,
    int? dueInDays,
    Severity? severity,
    double? confidence,
  }) {
    return PaymentTerm(
      text: text ?? this.text,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      dueInDays: dueInDays ?? this.dueInDays,
      severity: severity ?? this.severity,
      confidence: confidence ?? this.confidence,
    );
  }
}

@immutable
class Liability extends LiabilityEntity {
  const Liability({
    required super.text,
    required super.party,
    required super.capType,
    super.capValue,
    required super.excludedDamages,
    required super.severity,
    required super.confidence,
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

  @override
  Liability copyWith({
    String? text,
    String? party,
    CapType? capType,
    String? capValue,
    List<String>? excludedDamages,
    Severity? severity,
    double? confidence,
  }) {
    return Liability(
      text: text ?? this.text,
      party: party ?? this.party,
      capType: capType ?? this.capType,
      capValue: capValue ?? this.capValue,
      excludedDamages: excludedDamages ?? this.excludedDamages,
      severity: severity ?? this.severity,
      confidence: confidence ?? this.confidence,
    );
  }
}

@immutable
class Risk extends RiskEntity {
  const Risk({
    required super.text,
    required super.severity,
    required super.likelihood,
    required super.category,
    required super.confidence,
    required super.riskScore,
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

  @override
  Risk copyWith({
    String? text,
    Severity? severity,
    Likelihood? likelihood,
    RiskCategory? category,
    double? confidence,
    int? riskScore,
  }) {
    return Risk(
      text: text ?? this.text,
      severity: severity ?? this.severity,
      likelihood: likelihood ?? this.likelihood,
      category: category ?? this.category,
      confidence: confidence ?? this.confidence,
      riskScore: riskScore ?? this.riskScore,
    );
  }
}

@immutable
class ServiceLevel extends ServiceLevelEntity {
  const ServiceLevel({required super.text, required super.metric, required super.target, required super.severity});

  factory ServiceLevel.fromJson(Map<String, dynamic> json) {
    return ServiceLevel(
      text: json['text'],
      metric: json['metric'],
      target: json['target'],
      severity: _parseSeverity(json['severity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'metric': metric, 'target': target, 'severity': severity.name.toUpperCase()};
  }

  @override
  ServiceLevel copyWith({String? text, String? metric, String? target, Severity? severity}) {
    return ServiceLevel(
      text: text ?? this.text,
      metric: metric ?? this.metric,
      target: target ?? this.target,
      severity: severity ?? this.severity,
    );
  }
}

@immutable
class IntellectualProperty extends IntellectualPropertyEntity {
  const IntellectualProperty({required super.text, required super.ownership, required super.severity});

  factory IntellectualProperty.fromJson(Map<String, dynamic> json) {
    return IntellectualProperty(
      text: json['text'],
      ownership: _parseOwnership(json['ownership']),
      severity: _parseSeverity(json['severity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'ownership': ownership.name.toUpperCase(), 'severity': severity.name.toUpperCase()};
  }

  @override
  IntellectualProperty copyWith({String? text, Ownership? ownership, Severity? severity}) {
    return IntellectualProperty(
      text: text ?? this.text,
      ownership: ownership ?? this.ownership,
      severity: severity ?? this.severity,
    );
  }
}

@immutable
class SecurityRequirement extends SecurityRequirementEntity {
  const SecurityRequirement({required super.text, required super.type, required super.severity});

  factory SecurityRequirement.fromJson(Map<String, dynamic> json) {
    return SecurityRequirement(
      text: json['text'],
      type: _parseSecurityType(json['type']),
      severity: _parseSeverity(json['severity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'type': _securityTypeToString(type), 'severity': severity.name.toUpperCase()};
  }

  @override
  SecurityRequirement copyWith({String? text, SecurityType? type, Severity? severity}) {
    return SecurityRequirement(text: text ?? this.text, type: type ?? this.type, severity: severity ?? this.severity);
  }
}

@immutable
class UserRequirement extends UserRequirementEntity {
  const UserRequirement({required super.text, required super.category, required super.severity});

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

  @override
  UserRequirement copyWith({String? text, UserRequirementCategory? category, Severity? severity}) {
    return UserRequirement(
      text: text ?? this.text,
      category: category ?? this.category,
      severity: severity ?? this.severity,
    );
  }
}

@immutable
class ConflictOrContrast extends ConflictOrContrastEntity {
  const ConflictOrContrast({required super.text, super.conflictWith, required super.severity});

  factory ConflictOrContrast.fromJson(Map<String, dynamic> json) {
    return ConflictOrContrast(
      text: json['text'],
      conflictWith: json['conflict_with'],
      severity: _parseSeverity(json['severity']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'text': text, 'conflict_with': conflictWith, 'severity': severity.name.toUpperCase()};
  }

  @override
  ConflictOrContrast copyWith({String? text, String? conflictWith, Severity? severity}) {
    return ConflictOrContrast(
      text: text ?? this.text,
      conflictWith: conflictWith ?? this.conflictWith,
      severity: severity ?? this.severity,
    );
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
