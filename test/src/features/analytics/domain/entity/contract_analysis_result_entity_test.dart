import 'package:flutter_test/flutter_test.dart';
import 'package:deal_insights_assistant/src/features/analytics/domain/entity/contract_analysis_result_entity.dart';
import 'package:deal_insights_assistant/src/core/enum/severity_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/cap_type_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/likelihood_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/ownership_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/risk_category_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/security_type_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/user_requirements_category.dart';

void main() {
  group('ContractAnalysisResultEntity', () {
    late ContractAnalysisResultEntity entity;

    setUp(() {
      entity = const ContractAnalysisResultEntity();
    });

    group('Constructor', () {
      test('should create entity with all null fields by default', () {
        expect(entity.obligations, isNull);
        expect(entity.paymentTerms, isNull);
        expect(entity.liabilities, isNull);
        expect(entity.risks, isNull);
        expect(entity.serviceLevels, isNull);
        expect(entity.intellectualProperty, isNull);
        expect(entity.securityRequirements, isNull);
        expect(entity.userRequirements, isNull);
        expect(entity.conflictsOrContrasts, isNull);
      });

      test('should create entity with provided lists', () {
        final obligations = [
          const ObligationEntity(
            text: 'Test obligation',
            party: 'Party A',
            severity: Severity.medium,
            confidence: 0.8,
          ),
        ];

        final result = ContractAnalysisResultEntity(obligations: obligations);

        expect(result.obligations, equals(obligations));
        expect(result.paymentTerms, isNull);
      });
    });

    group('copyWith', () {
      test('should return same instance when no parameters provided', () {
        final copied = entity.copyWith();

        expect(copied.obligations, equals(entity.obligations));
        expect(copied.paymentTerms, equals(entity.paymentTerms));
        expect(copied.liabilities, equals(entity.liabilities));
        expect(copied.risks, equals(entity.risks));
        expect(copied.serviceLevels, equals(entity.serviceLevels));
        expect(copied.intellectualProperty, equals(entity.intellectualProperty));
        expect(copied.securityRequirements, equals(entity.securityRequirements));
        expect(copied.userRequirements, equals(entity.userRequirements));
        expect(copied.conflictsOrContrasts, equals(entity.conflictsOrContrasts));
      });

      test('should update only specified fields', () {
        final newObligations = [
          const ObligationEntity(
            text: 'New obligation',
            party: 'Party B',
            severity: Severity.high,
            confidence: 0.9,
          ),
        ];

        final copied = entity.copyWith(obligations: newObligations);

        expect(copied.obligations, equals(newObligations));
        expect(copied.paymentTerms, equals(entity.paymentTerms));
      });
    });

    group('Equality', () {
      test('should be equal when all lists are equal', () {
        const entity1 = ContractAnalysisResultEntity();
        const entity2 = ContractAnalysisResultEntity();

        expect(entity1, equals(entity2));
        expect(entity1.hashCode, equals(entity2.hashCode));
      });

      test('should not be equal when lists differ', () {
        final entity1 = const ContractAnalysisResultEntity();
        final entity2 = ContractAnalysisResultEntity(
          obligations: [
            const ObligationEntity(
              text: 'Test',
              party: 'Party',
              severity: Severity.low,
              confidence: 0.5,
            ),
          ],
        );

        expect(entity1, isNot(equals(entity2)));
      });
    });
  });

  group('ObligationEntity', () {
    late ObligationEntity obligation;

    setUp(() {
      obligation = const ObligationEntity(
        text: 'Test obligation',
        party: 'Party A',
        severity: Severity.medium,
        timeframe: '30 days',
        confidence: 0.8,
      );
    });

    group('Constructor', () {
      test('should create obligation with required fields', () {
        const entity = ObligationEntity(
          text: 'Test',
          party: 'Party',
          severity: Severity.low,
          confidence: 0.5,
        );

        expect(entity.text, equals('Test'));
        expect(entity.party, equals('Party'));
        expect(entity.severity, equals(Severity.low));
        expect(entity.timeframe, isNull);
        expect(entity.confidence, equals(0.5));
      });

      test('should create obligation with all fields', () {
        expect(obligation.text, equals('Test obligation'));
        expect(obligation.party, equals('Party A'));
        expect(obligation.severity, equals(Severity.medium));
        expect(obligation.timeframe, equals('30 days'));
        expect(obligation.confidence, equals(0.8));
      });
    });

    group('copyWith', () {
      test('should return same instance when no parameters provided', () {
        final copied = obligation.copyWith();

        expect(copied.text, equals(obligation.text));
        expect(copied.party, equals(obligation.party));
        expect(copied.severity, equals(obligation.severity));
        expect(copied.timeframe, equals(obligation.timeframe));
        expect(copied.confidence, equals(obligation.confidence));
      });

      test('should update only specified fields', () {
        final copied = obligation.copyWith(
          severity: Severity.high,
          confidence: 0.95,
        );

        expect(copied.text, equals(obligation.text));
        expect(copied.party, equals(obligation.party));
        expect(copied.severity, equals(Severity.high));
        expect(copied.timeframe, equals(obligation.timeframe));
        expect(copied.confidence, equals(0.95));
      });
    });

    group('Equality', () {
      test('should be equal when all fields are equal', () {
        const obligation1 = ObligationEntity(
          text: 'Test',
          party: 'Party',
          severity: Severity.low,
          timeframe: '30 days',
          confidence: 0.8,
        );

        const obligation2 = ObligationEntity(
          text: 'Test',
          party: 'Party',
          severity: Severity.low,
          timeframe: '30 days',
          confidence: 0.8,
        );

        expect(obligation1, equals(obligation2));
        expect(obligation1.hashCode, equals(obligation2.hashCode));
      });

      test('should not be equal when fields differ', () {
        const obligation1 = ObligationEntity(
          text: 'Test 1',
          party: 'Party',
          severity: Severity.low,
          confidence: 0.8,
        );

        const obligation2 = ObligationEntity(
          text: 'Test 2',
          party: 'Party',
          severity: Severity.low,
          confidence: 0.8,
        );

        expect(obligation1, isNot(equals(obligation2)));
      });
    });
  });

  group('PaymentTermEntity', () {
    late PaymentTermEntity paymentTerm;

    setUp(() {
      paymentTerm = const PaymentTermEntity(
        text: 'Payment due in 30 days',
        amount: 1000.0,
        currency: 'USD',
        dueInDays: 30,
        severity: Severity.medium,
        confidence: 0.9,
      );
    });

    group('Constructor', () {
      test('should create payment term with all fields', () {
        expect(paymentTerm.text, equals('Payment due in 30 days'));
        expect(paymentTerm.amount, equals(1000.0));
        expect(paymentTerm.currency, equals('USD'));
        expect(paymentTerm.dueInDays, equals(30));
        expect(paymentTerm.severity, equals(Severity.medium));
        expect(paymentTerm.confidence, equals(0.9));
      });
    });

    group('copyWith', () {
      test('should update specified fields', () {
        final copied = paymentTerm.copyWith(
          amount: 2000.0,
          currency: 'EUR',
        );

        expect(copied.text, equals(paymentTerm.text));
        expect(copied.amount, equals(2000.0));
        expect(copied.currency, equals('EUR'));
        expect(copied.dueInDays, equals(paymentTerm.dueInDays));
        expect(copied.severity, equals(paymentTerm.severity));
        expect(copied.confidence, equals(paymentTerm.confidence));
      });
    });
  });

  group('LiabilityEntity', () {
    late LiabilityEntity liability;

    setUp(() {
      liability = const LiabilityEntity(
        text: 'Liability cap of \$1M',
        party: 'Vendor',
        capType: CapType.capped,
        capValue: '\$1,000,000',
        excludedDamages: ['consequential', 'punitive'],
        severity: Severity.high,
        confidence: 0.85,
      );
    });

    group('Constructor', () {
      test('should create liability with all fields', () {
        expect(liability.text, equals('Liability cap of \$1M'));
        expect(liability.party, equals('Vendor'));
        expect(liability.capType, equals(CapType.capped));
        expect(liability.capValue, equals('\$1,000,000'));
        expect(liability.excludedDamages, equals(['consequential', 'punitive']));
        expect(liability.severity, equals(Severity.high));
        expect(liability.confidence, equals(0.85));
      });
    });

    group('copyWith', () {
      test('should update specified fields', () {
        final copied = liability.copyWith(
          capType: CapType.uncapped,
          capValue: '50%',
        );

        expect(copied.text, equals(liability.text));
        expect(copied.party, equals(liability.party));
        expect(copied.capType, equals(CapType.uncapped));
        expect(copied.capValue, equals('50%'));
        expect(copied.excludedDamages, equals(liability.excludedDamages));
        expect(copied.severity, equals(liability.severity));
        expect(copied.confidence, equals(liability.confidence));
      });
    });
  });

  group('RiskEntity', () {
    late RiskEntity risk;

    setUp(() {
      risk = const RiskEntity(
        text: 'Data breach risk',
        severity: Severity.critical,
        likelihood: Likelihood.medium,
        category: RiskCategory.legal,
        confidence: 0.75,
        riskScore: 8,
      );
    });

    group('Constructor', () {
      test('should create risk with all fields', () {
        expect(risk.text, equals('Data breach risk'));
        expect(risk.severity, equals(Severity.critical));
        expect(risk.likelihood, equals(Likelihood.medium));
        expect(risk.category, equals(RiskCategory.legal));
        expect(risk.confidence, equals(0.75));
        expect(risk.riskScore, equals(8));
      });
    });

    group('copyWith', () {
      test('should update specified fields', () {
        final copied = risk.copyWith(
          severity: Severity.high,
          riskScore: 7,
        );

        expect(copied.text, equals(risk.text));
        expect(copied.severity, equals(Severity.high));
        expect(copied.likelihood, equals(risk.likelihood));
        expect(copied.category, equals(risk.category));
        expect(copied.confidence, equals(risk.confidence));
        expect(copied.riskScore, equals(7));
      });
    });
  });

  group('ServiceLevelEntity', () {
    late ServiceLevelEntity serviceLevel;

    setUp(() {
      serviceLevel = const ServiceLevelEntity(
        text: '99.9% uptime required',
        metric: 'uptime',
        target: '99.9%',
        severity: Severity.high,
      );
    });

    group('Constructor', () {
      test('should create service level with all fields', () {
        expect(serviceLevel.text, equals('99.9% uptime required'));
        expect(serviceLevel.metric, equals('uptime'));
        expect(serviceLevel.target, equals('99.9%'));
        expect(serviceLevel.severity, equals(Severity.high));
      });
    });

    group('copyWith', () {
      test('should update specified fields', () {
        final copied = serviceLevel.copyWith(
          target: '99.95%',
          severity: Severity.critical,
        );

        expect(copied.text, equals(serviceLevel.text));
        expect(copied.metric, equals(serviceLevel.metric));
        expect(copied.target, equals('99.95%'));
        expect(copied.severity, equals(Severity.critical));
      });
    });
  });

  group('IntellectualPropertyEntity', () {
    late IntellectualPropertyEntity intellectualProperty;

    setUp(() {
      intellectualProperty = const IntellectualPropertyEntity(
        text: 'Client retains IP ownership',
        ownership: Ownership.client,
        severity: Severity.medium,
      );
    });

    group('Constructor', () {
      test('should create intellectual property with all fields', () {
        expect(intellectualProperty.text, equals('Client retains IP ownership'));
        expect(intellectualProperty.ownership, equals(Ownership.client));
        expect(intellectualProperty.severity, equals(Severity.medium));
      });
    });

    group('copyWith', () {
      test('should update specified fields', () {
        final copied = intellectualProperty.copyWith(
          ownership: Ownership.vendor,
          severity: Severity.high,
        );

        expect(copied.text, equals(intellectualProperty.text));
        expect(copied.ownership, equals(Ownership.vendor));
        expect(copied.severity, equals(Severity.high));
      });
    });
  });

  group('SecurityRequirementEntity', () {
    late SecurityRequirementEntity securityRequirement;

    setUp(() {
      securityRequirement = const SecurityRequirementEntity(
        text: 'SOC 2 compliance required',
        type: SecurityType.compliance,
        severity: Severity.high,
      );
    });

    group('Constructor', () {
      test('should create security requirement with all fields', () {
        expect(securityRequirement.text, equals('SOC 2 compliance required'));
        expect(securityRequirement.type, equals(SecurityType.compliance));
        expect(securityRequirement.severity, equals(Severity.high));
      });
    });

    group('copyWith', () {
      test('should update specified fields', () {
        final copied = securityRequirement.copyWith(
          type: SecurityType.dataProtection,
          severity: Severity.critical,
        );

        expect(copied.text, equals(securityRequirement.text));
        expect(copied.type, equals(SecurityType.dataProtection));
        expect(copied.severity, equals(Severity.critical));
      });
    });
  });

  group('UserRequirementEntity', () {
    late UserRequirementEntity userRequirement;

    setUp(() {
      userRequirement = const UserRequirementEntity(
        text: 'User training required',
        category: UserRequirementCategory.functional,
        severity: Severity.medium,
      );
    });

    group('Constructor', () {
      test('should create user requirement with all fields', () {
        expect(userRequirement.text, equals('User training required'));
        expect(userRequirement.category, equals(UserRequirementCategory.functional));
        expect(userRequirement.severity, equals(Severity.medium));
      });
    });

    group('copyWith', () {
      test('should update specified fields', () {
        final copied = userRequirement.copyWith(
          category: UserRequirementCategory.integration,
          severity: Severity.high,
        );

        expect(copied.text, equals(userRequirement.text));
        expect(copied.category, equals(UserRequirementCategory.integration));
        expect(copied.severity, equals(Severity.high));
      });
    });
  });

  group('ConflictOrContrastEntity', () {
    late ConflictOrContrastEntity conflict;

    setUp(() {
      conflict = const ConflictOrContrastEntity(
        text: 'Conflicting termination clauses',
        conflictWith: 'Section 5.2',
        severity: Severity.high,
      );
    });

    group('Constructor', () {
      test('should create conflict with all fields', () {
        expect(conflict.text, equals('Conflicting termination clauses'));
        expect(conflict.conflictWith, equals('Section 5.2'));
        expect(conflict.severity, equals(Severity.high));
      });

      test('should create conflict without conflictWith', () {
        const conflictWithoutRef = ConflictOrContrastEntity(
          text: 'General conflict',
          severity: Severity.medium,
        );

        expect(conflictWithoutRef.text, equals('General conflict'));
        expect(conflictWithoutRef.conflictWith, isNull);
        expect(conflictWithoutRef.severity, equals(Severity.medium));
      });
    });

    group('copyWith', () {
      test('should update specified fields', () {
        final copied = conflict.copyWith(
          conflictWith: 'Section 6.1',
          severity: Severity.critical,
        );

        expect(copied.text, equals(conflict.text));
        expect(copied.conflictWith, equals('Section 6.1'));
        expect(copied.severity, equals(Severity.critical));
      });
    });
  });
}
