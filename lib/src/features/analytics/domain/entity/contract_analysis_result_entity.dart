import 'package:deal_insights_assistant/src/core/enum/cap_type_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/likelihood_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/ownership_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/risk_category_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/security_type_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/severity_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/user_requirements_category.dart';
import 'package:flutter/foundation.dart';

@immutable
class ContractAnalysisResultEntity {
  final List<ObligationEntity>? obligations;
  final List<PaymentTermEntity>? paymentTerms;
  final List<LiabilityEntity>? liabilities;
  final List<RiskEntity>? risks;
  final List<ServiceLevelEntity>? serviceLevels;
  final List<IntellectualPropertyEntity>? intellectualProperty;
  final List<SecurityRequirementEntity>? securityRequirements;
  final List<UserRequirementEntity>? userRequirements;
  final List<ConflictOrContrastEntity>? conflictsOrContrasts;

  const ContractAnalysisResultEntity({
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

  ContractAnalysisResultEntity copyWith({
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
    return ContractAnalysisResultEntity(
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ContractAnalysisResultEntity &&
        listEquals(other.obligations, obligations) &&
        listEquals(other.paymentTerms, paymentTerms) &&
        listEquals(other.liabilities, liabilities) &&
        listEquals(other.risks, risks) &&
        listEquals(other.serviceLevels, serviceLevels) &&
        listEquals(other.intellectualProperty, intellectualProperty) &&
        listEquals(other.securityRequirements, securityRequirements) &&
        listEquals(other.userRequirements, userRequirements) &&
        listEquals(other.conflictsOrContrasts, conflictsOrContrasts);
  }

  @override
  int get hashCode {
    return Object.hash(
      obligations,
      paymentTerms,
      liabilities,
      risks,
      serviceLevels,
      intellectualProperty,
      securityRequirements,
      userRequirements,
      conflictsOrContrasts,
    );
  }
}

@immutable
class ObligationEntity {
  final String text;
  final String party;
  final Severity severity;
  final String? timeframe;
  final double confidence;

  const ObligationEntity({
    required this.text,
    required this.party,
    required this.severity,
    this.timeframe,
    required this.confidence,
  });

  ObligationEntity copyWith({String? text, String? party, Severity? severity, String? timeframe, double? confidence}) {
    return ObligationEntity(
      text: text ?? this.text,
      party: party ?? this.party,
      severity: severity ?? this.severity,
      timeframe: timeframe ?? this.timeframe,
      confidence: confidence ?? this.confidence,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ObligationEntity &&
        other.text == text &&
        other.party == party &&
        other.severity == severity &&
        other.timeframe == timeframe &&
        other.confidence == confidence;
  }

  @override
  int get hashCode {
    return Object.hash(text, party, severity, timeframe, confidence);
  }
}

@immutable
class PaymentTermEntity {
  final String text;
  final double? amount;
  final String? currency;
  final int? dueInDays;
  final Severity severity;
  final double confidence;

  const PaymentTermEntity({
    required this.text,
    this.amount,
    this.currency,
    this.dueInDays,
    required this.severity,
    required this.confidence,
  });

  PaymentTermEntity copyWith({
    String? text,
    double? amount,
    String? currency,
    int? dueInDays,
    Severity? severity,
    double? confidence,
  }) {
    return PaymentTermEntity(
      text: text ?? this.text,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      dueInDays: dueInDays ?? this.dueInDays,
      severity: severity ?? this.severity,
      confidence: confidence ?? this.confidence,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PaymentTermEntity &&
        other.text == text &&
        other.amount == amount &&
        other.currency == currency &&
        other.dueInDays == dueInDays &&
        other.severity == severity &&
        other.confidence == confidence;
  }

  @override
  int get hashCode {
    return Object.hash(text, amount, currency, dueInDays, severity, confidence);
  }
}

@immutable
class LiabilityEntity {
  final String text;
  final String party;
  final CapType capType;
  final String? capValue;
  final List<String> excludedDamages;
  final Severity severity;
  final double confidence;

  const LiabilityEntity({
    required this.text,
    required this.party,
    required this.capType,
    this.capValue,
    required this.excludedDamages,
    required this.severity,
    required this.confidence,
  });

  LiabilityEntity copyWith({
    String? text,
    String? party,
    CapType? capType,
    String? capValue,
    List<String>? excludedDamages,
    Severity? severity,
    double? confidence,
  }) {
    return LiabilityEntity(
      text: text ?? this.text,
      party: party ?? this.party,
      capType: capType ?? this.capType,
      capValue: capValue ?? this.capValue,
      excludedDamages: excludedDamages ?? this.excludedDamages,
      severity: severity ?? this.severity,
      confidence: confidence ?? this.confidence,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LiabilityEntity &&
        other.text == text &&
        other.party == party &&
        other.capType == capType &&
        other.capValue == capValue &&
        listEquals(other.excludedDamages, excludedDamages) &&
        other.severity == severity &&
        other.confidence == confidence;
  }

  @override
  int get hashCode {
    return Object.hash(text, party, capType, capValue, excludedDamages, severity, confidence);
  }
}

@immutable
class RiskEntity {
  final String text;
  final Severity severity;
  final Likelihood likelihood;
  final RiskCategory category;
  final double confidence;
  final int riskScore;

  const RiskEntity({
    required this.text,
    required this.severity,
    required this.likelihood,
    required this.category,
    required this.confidence,
    required this.riskScore,
  });

  RiskEntity copyWith({
    String? text,
    Severity? severity,
    Likelihood? likelihood,
    RiskCategory? category,
    double? confidence,
    int? riskScore,
  }) {
    return RiskEntity(
      text: text ?? this.text,
      severity: severity ?? this.severity,
      likelihood: likelihood ?? this.likelihood,
      category: category ?? this.category,
      confidence: confidence ?? this.confidence,
      riskScore: riskScore ?? this.riskScore,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RiskEntity &&
        other.text == text &&
        other.severity == severity &&
        other.likelihood == likelihood &&
        other.category == category &&
        other.confidence == confidence &&
        other.riskScore == riskScore;
  }

  @override
  int get hashCode {
    return Object.hash(text, severity, likelihood, category, confidence, riskScore);
  }
}

@immutable
class ServiceLevelEntity {
  final String text;
  final String metric;
  final String target;
  final Severity severity;

  const ServiceLevelEntity({required this.text, required this.metric, required this.target, required this.severity});

  ServiceLevelEntity copyWith({String? text, String? metric, String? target, Severity? severity}) {
    return ServiceLevelEntity(
      text: text ?? this.text,
      metric: metric ?? this.metric,
      target: target ?? this.target,
      severity: severity ?? this.severity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceLevelEntity &&
        other.text == text &&
        other.metric == metric &&
        other.target == target &&
        other.severity == severity;
  }

  @override
  int get hashCode {
    return Object.hash(text, metric, target, severity);
  }
}

@immutable
class IntellectualPropertyEntity {
  final String text;
  final Ownership ownership;
  final Severity severity;

  const IntellectualPropertyEntity({required this.text, required this.ownership, required this.severity});

  IntellectualPropertyEntity copyWith({String? text, Ownership? ownership, Severity? severity}) {
    return IntellectualPropertyEntity(
      text: text ?? this.text,
      ownership: ownership ?? this.ownership,
      severity: severity ?? this.severity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IntellectualPropertyEntity &&
        other.text == text &&
        other.ownership == ownership &&
        other.severity == severity;
  }

  @override
  int get hashCode {
    return Object.hash(text, ownership, severity);
  }
}

@immutable
class SecurityRequirementEntity {
  final String text;
  final SecurityType type;
  final Severity severity;

  const SecurityRequirementEntity({required this.text, required this.type, required this.severity});

  SecurityRequirementEntity copyWith({String? text, SecurityType? type, Severity? severity}) {
    return SecurityRequirementEntity(
      text: text ?? this.text,
      type: type ?? this.type,
      severity: severity ?? this.severity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SecurityRequirementEntity && other.text == text && other.type == type && other.severity == severity;
  }

  @override
  int get hashCode {
    return Object.hash(text, type, severity);
  }
}

@immutable
class UserRequirementEntity {
  final String text;
  final UserRequirementCategory category;
  final Severity severity;

  const UserRequirementEntity({required this.text, required this.category, required this.severity});

  UserRequirementEntity copyWith({String? text, UserRequirementCategory? category, Severity? severity}) {
    return UserRequirementEntity(
      text: text ?? this.text,
      category: category ?? this.category,
      severity: severity ?? this.severity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserRequirementEntity &&
        other.text == text &&
        other.category == category &&
        other.severity == severity;
  }

  @override
  int get hashCode {
    return Object.hash(text, category, severity);
  }
}

@immutable
class ConflictOrContrastEntity {
  final String text;
  final String? conflictWith;
  final Severity severity;

  const ConflictOrContrastEntity({required this.text, this.conflictWith, required this.severity});

  ConflictOrContrastEntity copyWith({String? text, String? conflictWith, Severity? severity}) {
    return ConflictOrContrastEntity(
      text: text ?? this.text,
      conflictWith: conflictWith ?? this.conflictWith,
      severity: severity ?? this.severity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ConflictOrContrastEntity &&
        other.text == text &&
        other.conflictWith == conflictWith &&
        other.severity == severity;
  }

  @override
  int get hashCode {
    return Object.hash(text, conflictWith, severity);
  }
}
