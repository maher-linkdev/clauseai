import 'package:deal_insights_assistant/src/core/enum/cap_type_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/likelihood_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/ownership_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/risk_category_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/security_type_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/severity_enum.dart';
import 'package:deal_insights_assistant/src/core/enum/user_requirements_category.dart';
import 'package:deal_insights_assistant/src/features/analytics/data/model/contract_analysis_result_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContractAnalysisResult', () {
    group('Constructor and Basic Properties', () {
      test('should create instance with default null values', () {
        const result = ContractAnalysisResultModel();

        expect(result.obligations, isNull);
        expect(result.paymentTerms, isNull);
        expect(result.liabilities, isNull);
        expect(result.risks, isNull);
        expect(result.serviceLevels, isNull);
        expect(result.intellectualProperty, isNull);
        expect(result.securityRequirements, isNull);
        expect(result.userRequirements, isNull);
        expect(result.conflictsOrContrasts, isNull);
      });

      test('should create instance with provided values', () {
        final obligations = [
          const Obligation(text: 'Test obligation', party: 'Vendor', severity: Severity.high, confidence: 0.9),
        ];

        final result = ContractAnalysisResultModel(obligations: obligations);

        expect(result.obligations, equals(obligations));
        expect(result.paymentTerms, isNull);
      });
    });

    group('JSON Serialization', () {
      test('should serialize to JSON correctly', () {
        final result = ContractAnalysisResultModel(
          obligations: [
            const Obligation(
              text: 'Test obligation',
              party: 'Vendor',
              severity: Severity.high,
              timeframe: '30 days',
              confidence: 0.9,
            ),
          ],
          paymentTerms: [
            const PaymentTerm(
              text: 'Net 30 payment',
              amount: 1000.0,
              currency: 'USD',
              dueInDays: 30,
              severity: Severity.medium,
              confidence: 0.8,
            ),
          ],
        );

        final json = result.toJson();

        expect(json['obligations'], isA<List>());
        expect(json['obligations']?.length, equals(1));
        expect(json['obligations']?[0]['text'], equals('Test obligation'));
        expect(json['obligations']?[0]['party'], equals('Vendor'));
        expect(json['obligations']?[0]['severity'], equals('HIGH'));
        expect(json['obligations']?[0]['confidence'], equals(0.9));

        expect(json['payment_terms'], isA<List>());
        expect(json['payment_terms']?.length, equals(1));
        expect(json['payment_terms']?[0]['amount'], equals(1000.0));
        expect(json['payment_terms']?[0]['currency'], equals('USD'));
      });

      test('should serialize null lists as null', () {
        const result = ContractAnalysisResultModel();

        final json = result.toJson();

        expect(json['obligations'], isNull);
        expect(json['payment_terms'], isNull);
        expect(json['liabilities'], isNull);
        expect(json['risks'], isNull);
        expect(json['service_levels'], isNull);
        expect(json['intellectual_property'], isNull);
        expect(json['security_requirements'], isNull);
        expect(json['user_requirements'], isNull);
        expect(json['conflicts_or_contrasts'], isNull);
      });
    });

    group('JSON Deserialization', () {
      test('should deserialize from JSON correctly', () {
        final json = {
          'obligations': [
            {
              'text': 'Test obligation',
              'party': 'Vendor',
              'severity': 'HIGH',
              'timeframe': '30 days',
              'confidence': 0.9,
            },
          ],
          'payment_terms': [
            {
              'text': 'Net 30 payment',
              'amount': 1000.0,
              'currency': 'USD',
              'due_in_days': 30,
              'severity': 'MEDIUM',
              'confidence': 0.8,
            },
          ],
        };

        final result = ContractAnalysisResultModel.fromJson(json);

        expect(result.obligations?.length, equals(1));
        expect(result.obligations?[0].text, equals('Test obligation'));
        expect(result.obligations?[0].severity, equals(Severity.high));

        expect(result.paymentTerms?.length, equals(1));
        expect(result.paymentTerms?[0].amount, equals(1000.0));
        expect(result.paymentTerms?[0].currency, equals('USD'));
      });

      test('should handle null values in JSON', () {
        final json = <String, dynamic>{};

        final result = ContractAnalysisResultModel.fromJson(json);

        expect(result.obligations, isNull);
        expect(result.paymentTerms, isNull);
        expect(result.liabilities, isNull);
        expect(result.risks, isNull);
        expect(result.serviceLevels, isNull);
        expect(result.intellectualProperty, isNull);
        expect(result.securityRequirements, isNull);
        expect(result.userRequirements, isNull);
        expect(result.conflictsOrContrasts, isNull);
      });
    });

    group('copyWith', () {
      test('should create new instance with updated values', () {
        const original = ContractAnalysisResultModel();
        final obligations = [
          const Obligation(text: 'New obligation', party: 'Client', severity: Severity.low, confidence: 0.7),
        ];

        final updated = original.copyWith(obligations: obligations);

        expect(updated.obligations, equals(obligations));
        expect(updated.paymentTerms, isNull); // unchanged
      });

      test('should return same values when no parameters provided', () {
        final obligations = [
          const Obligation(text: 'Test obligation', party: 'Vendor', severity: Severity.high, confidence: 0.9),
        ];
        final original = ContractAnalysisResultModel(obligations: obligations);

        final copied = original.copyWith();

        expect(copied.obligations, equals(original.obligations));
        expect(copied.paymentTerms, equals(original.paymentTerms));
      });
    });

    group('toEntity', () {
      test('should convert to entity correctly', () {
        final obligations = [
          const Obligation(text: 'Test obligation', party: 'Vendor', severity: Severity.high, confidence: 0.9),
        ];
        final model = ContractAnalysisResultModel(obligations: obligations);

        final entity = model.toEntity();

        expect(entity.obligations, equals(obligations));
        expect(entity.paymentTerms, isNull);
      });
    });
  });

  group('Obligation', () {
    group('Constructor', () {
      test('should create instance with required fields', () {
        const obligation = Obligation(
          text: 'Test obligation',
          party: 'Vendor',
          severity: Severity.high,
          confidence: 0.9,
        );

        expect(obligation.text, equals('Test obligation'));
        expect(obligation.party, equals('Vendor'));
        expect(obligation.severity, equals(Severity.high));
        expect(obligation.timeframe, isNull);
        expect(obligation.confidence, equals(0.9));
      });

      test('should create instance with optional timeframe', () {
        const obligation = Obligation(
          text: 'Test obligation',
          party: 'Vendor',
          severity: Severity.medium,
          timeframe: '30 days',
          confidence: 0.8,
        );

        expect(obligation.timeframe, equals('30 days'));
      });
    });

    group('JSON Serialization', () {
      test('should serialize to JSON correctly', () {
        const obligation = Obligation(
          text: 'Test obligation',
          party: 'Vendor',
          severity: Severity.high,
          timeframe: '30 days',
          confidence: 0.9,
        );

        final json = obligation.toJson();

        expect(json['text'], equals('Test obligation'));
        expect(json['party'], equals('Vendor'));
        expect(json['severity'], equals('HIGH'));
        expect(json['timeframe'], equals('30 days'));
        expect(json['confidence'], equals(0.9));
      });
    });

    group('JSON Deserialization', () {
      test('should deserialize from JSON correctly', () {
        final json = {
          'text': 'Test obligation',
          'party': 'Vendor',
          'severity': 'HIGH',
          'timeframe': '30 days',
          'confidence': 0.9,
        };

        final obligation = Obligation.fromJson(json);

        expect(obligation.text, equals('Test obligation'));
        expect(obligation.party, equals('Vendor'));
        expect(obligation.severity, equals(Severity.high));
        expect(obligation.timeframe, equals('30 days'));
        expect(obligation.confidence, equals(0.9));
      });

      test('should handle null timeframe', () {
        final json = {
          'text': 'Test obligation',
          'party': 'Vendor',
          'severity': 'LOW',
          'timeframe': null,
          'confidence': 0.7,
        };

        final obligation = Obligation.fromJson(json);

        expect(obligation.timeframe, isNull);
        expect(obligation.severity, equals(Severity.low));
      });
    });

    group('copyWith', () {
      test('should create new instance with updated values', () {
        const original = Obligation(text: 'Original text', party: 'Vendor', severity: Severity.low, confidence: 0.5);

        final updated = original.copyWith(text: 'Updated text', severity: Severity.high);

        expect(updated.text, equals('Updated text'));
        expect(updated.party, equals('Vendor')); // unchanged
        expect(updated.severity, equals(Severity.high));
        expect(updated.confidence, equals(0.5)); // unchanged
      });
    });
  });

  group('PaymentTerm', () {
    group('Constructor', () {
      test('should create instance with required fields', () {
        const paymentTerm = PaymentTerm(text: 'Net 30 payment', severity: Severity.medium, confidence: 0.8);

        expect(paymentTerm.text, equals('Net 30 payment'));
        expect(paymentTerm.amount, isNull);
        expect(paymentTerm.currency, isNull);
        expect(paymentTerm.dueInDays, isNull);
        expect(paymentTerm.severity, equals(Severity.medium));
        expect(paymentTerm.confidence, equals(0.8));
      });

      test('should create instance with all fields', () {
        const paymentTerm = PaymentTerm(
          text: 'Net 30 payment',
          amount: 1000.0,
          currency: 'USD',
          dueInDays: 30,
          severity: Severity.medium,
          confidence: 0.8,
        );

        expect(paymentTerm.amount, equals(1000.0));
        expect(paymentTerm.currency, equals('USD'));
        expect(paymentTerm.dueInDays, equals(30));
      });
    });

    group('JSON Serialization', () {
      test('should serialize to JSON correctly', () {
        const paymentTerm = PaymentTerm(
          text: 'Net 30 payment',
          amount: 1000.0,
          currency: 'USD',
          dueInDays: 30,
          severity: Severity.medium,
          confidence: 0.8,
        );

        final json = paymentTerm.toJson();

        expect(json['text'], equals('Net 30 payment'));
        expect(json['amount'], equals(1000.0));
        expect(json['currency'], equals('USD'));
        expect(json['due_in_days'], equals(30));
        expect(json['severity'], equals('MEDIUM'));
        expect(json['confidence'], equals(0.8));
      });
    });

    group('JSON Deserialization', () {
      test('should deserialize from JSON correctly', () {
        final json = {
          'text': 'Net 30 payment',
          'amount': 1000.0,
          'currency': 'USD',
          'due_in_days': 30,
          'severity': 'MEDIUM',
          'confidence': 0.8,
        };

        final paymentTerm = PaymentTerm.fromJson(json);

        expect(paymentTerm.text, equals('Net 30 payment'));
        expect(paymentTerm.amount, equals(1000.0));
        expect(paymentTerm.currency, equals('USD'));
        expect(paymentTerm.dueInDays, equals(30));
        expect(paymentTerm.severity, equals(Severity.medium));
        expect(paymentTerm.confidence, equals(0.8));
      });

      test('should handle integer amount conversion', () {
        final json = {
          'text': 'Net 30 payment',
          'amount': 1000, // integer instead of double
          'currency': 'USD',
          'due_in_days': 30,
          'severity': 'HIGH',
          'confidence': 0.9,
        };

        final paymentTerm = PaymentTerm.fromJson(json);

        expect(paymentTerm.amount, equals(1000.0));
      });
    });
  });

  group('Liability', () {
    group('Constructor', () {
      test('should create instance with required fields', () {
        const liability = Liability(
          text: 'Vendor liability clause',
          party: 'Vendor',
          capType: CapType.capped,
          excludedDamages: ['indirect', 'consequential'],
          severity: Severity.high,
          confidence: 0.9,
        );

        expect(liability.text, equals('Vendor liability clause'));
        expect(liability.party, equals('Vendor'));
        expect(liability.capType, equals(CapType.capped));
        expect(liability.capValue, isNull);
        expect(liability.excludedDamages, equals(['indirect', 'consequential']));
        expect(liability.severity, equals(Severity.high));
        expect(liability.confidence, equals(0.9));
      });
    });

    group('JSON Serialization', () {
      test('should serialize to JSON correctly', () {
        const liability = Liability(
          text: 'Vendor liability clause',
          party: 'Vendor',
          capType: CapType.capped,
          capValue: '100,000 USD',
          excludedDamages: ['indirect', 'consequential'],
          severity: Severity.high,
          confidence: 0.9,
        );

        final json = liability.toJson();

        expect(json['text'], equals('Vendor liability clause'));
        expect(json['party'], equals('Vendor'));
        expect(json['cap_type'], equals('CAPPED'));
        expect(json['cap_value'], equals('100,000 USD'));
        expect(json['excluded_damages'], equals(['indirect', 'consequential']));
        expect(json['severity'], equals('HIGH'));
        expect(json['confidence'], equals(0.9));
      });
    });

    group('JSON Deserialization', () {
      test('should deserialize from JSON correctly', () {
        final json = {
          'text': 'Vendor liability clause',
          'party': 'Vendor',
          'cap_type': 'CAPPED',
          'cap_value': '100,000 USD',
          'excluded_damages': ['indirect', 'consequential'],
          'severity': 'HIGH',
          'confidence': 0.9,
        };

        final liability = Liability.fromJson(json);

        expect(liability.text, equals('Vendor liability clause'));
        expect(liability.party, equals('Vendor'));
        expect(liability.capType, equals(CapType.capped));
        expect(liability.capValue, equals('100,000 USD'));
        expect(liability.excludedDamages, equals(['indirect', 'consequential']));
        expect(liability.severity, equals(Severity.high));
        expect(liability.confidence, equals(0.9));
      });
    });
  });

  group('Risk', () {
    group('Constructor', () {
      test('should create instance with all required fields', () {
        const risk = Risk(
          text: 'Data breach risk',
          severity: Severity.critical,
          likelihood: Likelihood.medium,
          category: RiskCategory.operational,
          confidence: 0.85,
          riskScore: 6,
        );

        expect(risk.text, equals('Data breach risk'));
        expect(risk.severity, equals(Severity.critical));
        expect(risk.likelihood, equals(Likelihood.medium));
        expect(risk.category, equals(RiskCategory.operational));
        expect(risk.confidence, equals(0.85));
        expect(risk.riskScore, equals(6));
      });
    });

    group('JSON Serialization', () {
      test('should serialize to JSON correctly', () {
        const risk = Risk(
          text: 'Data breach risk',
          severity: Severity.critical,
          likelihood: Likelihood.high,
          category: RiskCategory.legal,
          confidence: 0.9,
          riskScore: 8,
        );

        final json = risk.toJson();

        expect(json['text'], equals('Data breach risk'));
        expect(json['severity'], equals('CRITICAL'));
        expect(json['likelihood'], equals('HIGH'));
        expect(json['category'], equals('legal'));
        expect(json['confidence'], equals(0.9));
        expect(json['risk_score'], equals(8));
      });
    });

    group('JSON Deserialization', () {
      test('should deserialize from JSON correctly', () {
        final json = {
          'text': 'Financial risk',
          'severity': 'HIGH',
          'likelihood': 'MEDIUM',
          'category': 'financial',
          'confidence': 0.8,
          'risk_score': 6,
        };

        final risk = Risk.fromJson(json);

        expect(risk.text, equals('Financial risk'));
        expect(risk.severity, equals(Severity.high));
        expect(risk.likelihood, equals(Likelihood.medium));
        expect(risk.category, equals(RiskCategory.financial));
        expect(risk.confidence, equals(0.8));
        expect(risk.riskScore, equals(6));
      });
    });
  });

  group('ServiceLevel', () {
    group('Constructor', () {
      test('should create instance with all required fields', () {
        const serviceLevel = ServiceLevel(
          text: '99.9% uptime',
          metric: 'uptime',
          target: '99.9%',
          severity: Severity.high,
        );

        expect(serviceLevel.text, equals('99.9% uptime'));
        expect(serviceLevel.metric, equals('uptime'));
        expect(serviceLevel.target, equals('99.9%'));
        expect(serviceLevel.severity, equals(Severity.high));
      });
    });

    group('JSON Serialization', () {
      test('should serialize to JSON correctly', () {
        const serviceLevel = ServiceLevel(
          text: '99.9% uptime',
          metric: 'uptime',
          target: '99.9%',
          severity: Severity.critical,
        );

        final json = serviceLevel.toJson();

        expect(json['text'], equals('99.9% uptime'));
        expect(json['metric'], equals('uptime'));
        expect(json['target'], equals('99.9%'));
        expect(json['severity'], equals('CRITICAL'));
      });
    });

    group('JSON Deserialization', () {
      test('should deserialize from JSON correctly', () {
        final json = {
          'text': 'Response time < 2s',
          'metric': 'response_time',
          'target': '2 seconds',
          'severity': 'MEDIUM',
        };

        final serviceLevel = ServiceLevel.fromJson(json);

        expect(serviceLevel.text, equals('Response time < 2s'));
        expect(serviceLevel.metric, equals('response_time'));
        expect(serviceLevel.target, equals('2 seconds'));
        expect(serviceLevel.severity, equals(Severity.medium));
      });
    });
  });

  group('IntellectualProperty', () {
    group('Constructor', () {
      test('should create instance with all required fields', () {
        const ip = IntellectualProperty(
          text: 'Source code ownership',
          ownership: Ownership.client,
          severity: Severity.high,
        );

        expect(ip.text, equals('Source code ownership'));
        expect(ip.ownership, equals(Ownership.client));
        expect(ip.severity, equals(Severity.high));
      });
    });

    group('JSON Serialization', () {
      test('should serialize to JSON correctly', () {
        const ip = IntellectualProperty(
          text: 'Patent rights',
          ownership: Ownership.shared,
          severity: Severity.critical,
        );

        final json = ip.toJson();

        expect(json['text'], equals('Patent rights'));
        expect(json['ownership'], equals('SHARED'));
        expect(json['severity'], equals('CRITICAL'));
      });
    });

    group('JSON Deserialization', () {
      test('should deserialize from JSON correctly', () {
        final json = {'text': 'Trademark usage', 'ownership': 'VENDOR', 'severity': 'LOW'};

        final ip = IntellectualProperty.fromJson(json);

        expect(ip.text, equals('Trademark usage'));
        expect(ip.ownership, equals(Ownership.vendor));
        expect(ip.severity, equals(Severity.low));
      });
    });
  });

  group('SecurityRequirement', () {
    group('Constructor', () {
      test('should create instance with all required fields', () {
        const security = SecurityRequirement(
          text: 'Data encryption required',
          type: SecurityType.dataProtection,
          severity: Severity.critical,
        );

        expect(security.text, equals('Data encryption required'));
        expect(security.type, equals(SecurityType.dataProtection));
        expect(security.severity, equals(Severity.critical));
      });
    });

    group('JSON Serialization', () {
      test('should serialize to JSON correctly', () {
        const security = SecurityRequirement(
          text: 'Access control mandatory',
          type: SecurityType.accessControl,
          severity: Severity.high,
        );

        final json = security.toJson();

        expect(json['text'], equals('Access control mandatory'));
        expect(json['type'], equals('access control'));
        expect(json['severity'], equals('HIGH'));
      });
    });

    group('JSON Deserialization', () {
      test('should deserialize from JSON correctly', () {
        final json = {'text': 'Compliance audit required', 'type': 'audit', 'severity': 'CRITICAL'};

        final security = SecurityRequirement.fromJson(json);

        expect(security.text, equals('Compliance audit required'));
        expect(security.type, equals(SecurityType.audit));
        expect(security.severity, equals(Severity.critical));
      });
    });
  });

  group('UserRequirement', () {
    group('Constructor', () {
      test('should create instance with all required fields', () {
        const userReq = UserRequirement(
          text: 'System must integrate with existing APIs',
          category: UserRequirementCategory.integration,
          severity: Severity.high,
        );

        expect(userReq.text, equals('System must integrate with existing APIs'));
        expect(userReq.category, equals(UserRequirementCategory.integration));
        expect(userReq.severity, equals(Severity.high));
      });
    });

    group('JSON Serialization', () {
      test('should serialize to JSON correctly', () {
        const userReq = UserRequirement(
          text: 'Performance requirements',
          category: UserRequirementCategory.nonFunctional,
          severity: Severity.medium,
        );

        final json = userReq.toJson();

        expect(json['text'], equals('Performance requirements'));
        expect(json['category'], equals('non-functional'));
        expect(json['severity'], equals('MEDIUM'));
      });
    });

    group('JSON Deserialization', () {
      test('should deserialize from JSON correctly', () {
        final json = {'text': 'User login functionality', 'category': 'functional', 'severity': 'HIGH'};

        final userReq = UserRequirement.fromJson(json);

        expect(userReq.text, equals('User login functionality'));
        expect(userReq.category, equals(UserRequirementCategory.functional));
        expect(userReq.severity, equals(Severity.high));
      });
    });
  });

  group('ConflictOrContrast', () {
    group('Constructor', () {
      test('should create instance with required fields', () {
        const conflict = ConflictOrContrast(text: 'Conflicting terms found', severity: Severity.critical);

        expect(conflict.text, equals('Conflicting terms found'));
        expect(conflict.conflictWith, isNull);
        expect(conflict.severity, equals(Severity.critical));
      });

      test('should create instance with conflictWith field', () {
        const conflict = ConflictOrContrast(
          text: 'Payment terms conflict',
          conflictWith: 'Section 3.2',
          severity: Severity.high,
        );

        expect(conflict.conflictWith, equals('Section 3.2'));
      });
    });

    group('JSON Serialization', () {
      test('should serialize to JSON correctly', () {
        const conflict = ConflictOrContrast(
          text: 'Liability cap mismatch',
          conflictWith: 'Section 5.1',
          severity: Severity.critical,
        );

        final json = conflict.toJson();

        expect(json['text'], equals('Liability cap mismatch'));
        expect(json['conflict_with'], equals('Section 5.1'));
        expect(json['severity'], equals('CRITICAL'));
      });
    });

    group('JSON Deserialization', () {
      test('should deserialize from JSON correctly', () {
        final json = {'text': 'Terms inconsistency', 'conflict_with': 'Appendix A', 'severity': 'HIGH'};

        final conflict = ConflictOrContrast.fromJson(json);

        expect(conflict.text, equals('Terms inconsistency'));
        expect(conflict.conflictWith, equals('Appendix A'));
        expect(conflict.severity, equals(Severity.high));
      });
    });
  });

  group('Helper Parsing Functions', () {
    group('Severity Parsing', () {
      test('should parse all severity levels correctly', () {
        // Testing through JSON deserialization to access private function
        expect(
          Obligation.fromJson({'text': '', 'party': '', 'severity': 'LOW', 'confidence': 0.5}).severity,
          equals(Severity.low),
        );
        expect(
          Obligation.fromJson({'text': '', 'party': '', 'severity': 'MEDIUM', 'confidence': 0.5}).severity,
          equals(Severity.medium),
        );
        expect(
          Obligation.fromJson({'text': '', 'party': '', 'severity': 'HIGH', 'confidence': 0.5}).severity,
          equals(Severity.high),
        );
        expect(
          Obligation.fromJson({'text': '', 'party': '', 'severity': 'CRITICAL', 'confidence': 0.5}).severity,
          equals(Severity.critical),
        );
      });

      test('should handle case insensitive severity parsing', () {
        expect(
          Obligation.fromJson({'text': '', 'party': '', 'severity': 'low', 'confidence': 0.5}).severity,
          equals(Severity.low),
        );
        expect(
          Obligation.fromJson({'text': '', 'party': '', 'severity': 'High', 'confidence': 0.5}).severity,
          equals(Severity.high),
        );
      });

      test('should default to low for invalid severity', () {
        expect(
          Obligation.fromJson({'text': '', 'party': '', 'severity': 'INVALID', 'confidence': 0.5}).severity,
          equals(Severity.low),
        );
      });
    });

    group('Likelihood Parsing', () {
      test('should parse all likelihood levels correctly', () {
        expect(
          Risk.fromJson({
            'text': '',
            'severity': 'LOW',
            'likelihood': 'LOW',
            'category': 'other',
            'confidence': 0.5,
            'risk_score': 1,
          }).likelihood,
          equals(Likelihood.low),
        );
        expect(
          Risk.fromJson({
            'text': '',
            'severity': 'LOW',
            'likelihood': 'MEDIUM',
            'category': 'other',
            'confidence': 0.5,
            'risk_score': 1,
          }).likelihood,
          equals(Likelihood.medium),
        );
        expect(
          Risk.fromJson({
            'text': '',
            'severity': 'LOW',
            'likelihood': 'HIGH',
            'category': 'other',
            'confidence': 0.5,
            'risk_score': 1,
          }).likelihood,
          equals(Likelihood.high),
        );
      });

      test('should default to low for invalid likelihood', () {
        expect(
          Risk.fromJson({
            'text': '',
            'severity': 'LOW',
            'likelihood': 'INVALID',
            'category': 'other',
            'confidence': 0.5,
            'risk_score': 1,
          }).likelihood,
          equals(Likelihood.low),
        );
      });
    });

    group('CapType Parsing', () {
      test('should parse all cap types correctly', () {
        expect(
          Liability.fromJson({
            'text': '',
            'party': '',
            'cap_type': 'CAPPED',
            'excluded_damages': [],
            'severity': 'LOW',
            'confidence': 0.5,
          }).capType,
          equals(CapType.capped),
        );
        expect(
          Liability.fromJson({
            'text': '',
            'party': '',
            'cap_type': 'UNCAPPED',
            'excluded_damages': [],
            'severity': 'LOW',
            'confidence': 0.5,
          }).capType,
          equals(CapType.uncapped),
        );
        expect(
          Liability.fromJson({
            'text': '',
            'party': '',
            'cap_type': 'EXCLUDED',
            'excluded_damages': [],
            'severity': 'LOW',
            'confidence': 0.5,
          }).capType,
          equals(CapType.excluded),
        );
      });

      test('should default to capped for invalid cap type', () {
        expect(
          Liability.fromJson({
            'text': '',
            'party': '',
            'cap_type': 'INVALID',
            'excluded_damages': [],
            'severity': 'LOW',
            'confidence': 0.5,
          }).capType,
          equals(CapType.capped),
        );
      });
    });

    group('Ownership Parsing', () {
      test('should parse all ownership types correctly', () {
        expect(
          IntellectualProperty.fromJson({'text': '', 'ownership': 'CLIENT', 'severity': 'LOW'}).ownership,
          equals(Ownership.client),
        );
        expect(
          IntellectualProperty.fromJson({'text': '', 'ownership': 'VENDOR', 'severity': 'LOW'}).ownership,
          equals(Ownership.vendor),
        );
        expect(
          IntellectualProperty.fromJson({'text': '', 'ownership': 'SHARED', 'severity': 'LOW'}).ownership,
          equals(Ownership.shared),
        );
      });

      test('should default to client for invalid ownership', () {
        expect(
          IntellectualProperty.fromJson({'text': '', 'ownership': 'INVALID', 'severity': 'LOW'}).ownership,
          equals(Ownership.client),
        );
      });
    });

    group('Risk Category Parsing', () {
      test('should parse all risk categories correctly', () {
        expect(
          Risk.fromJson({
            'text': '',
            'severity': 'LOW',
            'likelihood': 'LOW',
            'category': 'legal',
            'confidence': 0.5,
            'risk_score': 1,
          }).category,
          equals(RiskCategory.legal),
        );
        expect(
          Risk.fromJson({
            'text': '',
            'severity': 'LOW',
            'likelihood': 'LOW',
            'category': 'financial',
            'confidence': 0.5,
            'risk_score': 1,
          }).category,
          equals(RiskCategory.financial),
        );
        expect(
          Risk.fromJson({
            'text': '',
            'severity': 'LOW',
            'likelihood': 'LOW',
            'category': 'operational',
            'confidence': 0.5,
            'risk_score': 1,
          }).category,
          equals(RiskCategory.operational),
        );
        expect(
          Risk.fromJson({
            'text': '',
            'severity': 'LOW',
            'likelihood': 'LOW',
            'category': 'compliance',
            'confidence': 0.5,
            'risk_score': 1,
          }).category,
          equals(RiskCategory.compliance),
        );
        expect(
          Risk.fromJson({
            'text': '',
            'severity': 'LOW',
            'likelihood': 'LOW',
            'category': 'other',
            'confidence': 0.5,
            'risk_score': 1,
          }).category,
          equals(RiskCategory.other),
        );
      });

      test('should default to other for invalid risk category', () {
        expect(
          Risk.fromJson({
            'text': '',
            'severity': 'LOW',
            'likelihood': 'LOW',
            'category': 'INVALID',
            'confidence': 0.5,
            'risk_score': 1,
          }).category,
          equals(RiskCategory.other),
        );
      });
    });

    group('Security Type Parsing', () {
      test('should parse all security types correctly', () {
        expect(
          SecurityRequirement.fromJson({'text': '', 'type': 'data protection', 'severity': 'LOW'}).type,
          equals(SecurityType.dataProtection),
        );
        expect(
          SecurityRequirement.fromJson({'text': '', 'type': 'compliance', 'severity': 'LOW'}).type,
          equals(SecurityType.compliance),
        );
        expect(
          SecurityRequirement.fromJson({'text': '', 'type': 'access control', 'severity': 'LOW'}).type,
          equals(SecurityType.accessControl),
        );
        expect(
          SecurityRequirement.fromJson({'text': '', 'type': 'audit', 'severity': 'LOW'}).type,
          equals(SecurityType.audit),
        );
        expect(
          SecurityRequirement.fromJson({'text': '', 'type': 'other', 'severity': 'LOW'}).type,
          equals(SecurityType.other),
        );
      });

      test('should handle spaces in security type parsing', () {
        expect(
          SecurityRequirement.fromJson({'text': '', 'type': 'dataprotection', 'severity': 'LOW'}).type,
          equals(SecurityType.dataProtection),
        );
        expect(
          SecurityRequirement.fromJson({'text': '', 'type': 'accesscontrol', 'severity': 'LOW'}).type,
          equals(SecurityType.accessControl),
        );
      });

      test('should default to other for invalid security type', () {
        expect(
          SecurityRequirement.fromJson({'text': '', 'type': 'INVALID', 'severity': 'LOW'}).type,
          equals(SecurityType.other),
        );
      });
    });

    group('User Requirement Category Parsing', () {
      test('should parse all user requirement categories correctly', () {
        expect(
          UserRequirement.fromJson({'text': '', 'category': 'functional', 'severity': 'LOW'}).category,
          equals(UserRequirementCategory.functional),
        );
        expect(
          UserRequirement.fromJson({'text': '', 'category': 'non-functional', 'severity': 'LOW'}).category,
          equals(UserRequirementCategory.nonFunctional),
        );
        expect(
          UserRequirement.fromJson({'text': '', 'category': 'compliance', 'severity': 'LOW'}).category,
          equals(UserRequirementCategory.compliance),
        );
        expect(
          UserRequirement.fromJson({'text': '', 'category': 'integration', 'severity': 'LOW'}).category,
          equals(UserRequirementCategory.integration),
        );
        expect(
          UserRequirement.fromJson({'text': '', 'category': 'other', 'severity': 'LOW'}).category,
          equals(UserRequirementCategory.other),
        );
      });

      test('should handle variations in user requirement category parsing', () {
        expect(
          UserRequirement.fromJson({'text': '', 'category': 'nonfunctional', 'severity': 'LOW'}).category,
          equals(UserRequirementCategory.nonFunctional),
        );
        expect(
          UserRequirement.fromJson({'text': '', 'category': 'non functional', 'severity': 'LOW'}).category,
          equals(UserRequirementCategory.nonFunctional),
        );
      });

      test('should default to other for invalid user requirement category', () {
        expect(
          UserRequirement.fromJson({'text': '', 'category': 'INVALID', 'severity': 'LOW'}).category,
          equals(UserRequirementCategory.other),
        );
      });
    });
  });

  group('Complex JSON Round Trip Tests', () {
    test('should maintain data integrity through JSON serialization round trip', () {
      final original = ContractAnalysisResultModel(
        obligations: [
          const Obligation(
            text: 'Test obligation',
            party: 'Vendor',
            severity: Severity.high,
            timeframe: '30 days',
            confidence: 0.9,
          ),
        ],
        risks: [
          const Risk(
            text: 'Data risk',
            severity: Severity.critical,
            likelihood: Likelihood.medium,
            category: RiskCategory.operational,
            confidence: 0.85,
            riskScore: 6,
          ),
        ],
        securityRequirements: [
          const SecurityRequirement(
            text: 'Encryption required',
            type: SecurityType.dataProtection,
            severity: Severity.high,
          ),
        ],
      );

      final json = original.toJson();
      final deserialized = ContractAnalysisResultModel.fromJson(json);

      expect(deserialized.obligations?.length, equals(1));
      expect(deserialized.obligations?[0].text, equals('Test obligation'));
      expect(deserialized.obligations?[0].severity, equals(Severity.high));

      expect(deserialized.risks?.length, equals(1));
      expect(deserialized.risks?[0].category, equals(RiskCategory.operational));

      expect(deserialized.securityRequirements?.length, equals(1));
      expect(deserialized.securityRequirements?[0].type, equals(SecurityType.dataProtection));
    });
  });
}
