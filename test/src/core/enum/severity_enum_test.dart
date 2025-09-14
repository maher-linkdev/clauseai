import 'package:flutter_test/flutter_test.dart';
import 'package:deal_insights_assistant/src/core/enum/severity_enum.dart';

void main() {
  group('Severity enum', () {
    test('should have correct values', () {
      expect(Severity.values, hasLength(4));
      expect(Severity.values, contains(Severity.low));
      expect(Severity.values, contains(Severity.medium));
      expect(Severity.values, contains(Severity.high));
      expect(Severity.values, contains(Severity.critical));
    });

    test('should have correct order', () {
      final values = Severity.values;
      expect(values[0], equals(Severity.low));
      expect(values[1], equals(Severity.medium));
      expect(values[2], equals(Severity.high));
      expect(values[3], equals(Severity.critical));
    });

    test('should have correct index values', () {
      expect(Severity.low.index, equals(0));
      expect(Severity.medium.index, equals(1));
      expect(Severity.high.index, equals(2));
      expect(Severity.critical.index, equals(3));
    });

    test('should have correct string representation', () {
      expect(Severity.low.toString(), equals('Severity.low'));
      expect(Severity.medium.toString(), equals('Severity.medium'));
      expect(Severity.high.toString(), equals('Severity.high'));
      expect(Severity.critical.toString(), equals('Severity.critical'));
    });

    test('should have correct name property', () {
      expect(Severity.low.name, equals('low'));
      expect(Severity.medium.name, equals('medium'));
      expect(Severity.high.name, equals('high'));
      expect(Severity.critical.name, equals('critical'));
    });

    test('should support comparison operations', () {
      expect(Severity.low.index < Severity.medium.index, isTrue);
      expect(Severity.medium.index < Severity.high.index, isTrue);
      expect(Severity.high.index < Severity.critical.index, isTrue);
      
      expect(Severity.critical.index > Severity.high.index, isTrue);
      expect(Severity.high.index > Severity.medium.index, isTrue);
      expect(Severity.medium.index > Severity.low.index, isTrue);
    });

    test('should support equality comparison', () {
      expect(Severity.low, equals(Severity.low));
      expect(Severity.medium, equals(Severity.medium));
      expect(Severity.high, equals(Severity.high));
      expect(Severity.critical, equals(Severity.critical));
      
      expect(Severity.low, isNot(equals(Severity.medium)));
      expect(Severity.medium, isNot(equals(Severity.high)));
      expect(Severity.high, isNot(equals(Severity.critical)));
    });

    test('should support switch statements', () {
      String getSeverityDescription(Severity severity) {
        switch (severity) {
          case Severity.low:
            return 'Low severity';
          case Severity.medium:
            return 'Medium severity';
          case Severity.high:
            return 'High severity';
          case Severity.critical:
            return 'Critical severity';
        }
      }

      expect(getSeverityDescription(Severity.low), equals('Low severity'));
      expect(getSeverityDescription(Severity.medium), equals('Medium severity'));
      expect(getSeverityDescription(Severity.high), equals('High severity'));
      expect(getSeverityDescription(Severity.critical), equals('Critical severity'));
    });

    test('should be usable in collections', () {
      final severitySet = {Severity.low, Severity.medium, Severity.high, Severity.critical};
      expect(severitySet, hasLength(4));
      expect(severitySet.contains(Severity.low), isTrue);
      expect(severitySet.contains(Severity.critical), isTrue);

      final severityList = [Severity.critical, Severity.low, Severity.high, Severity.medium];
      expect(severityList, hasLength(4));
      expect(severityList.contains(Severity.low), isTrue);
    });

    test('should support filtering and mapping', () {
      final allSeverities = Severity.values;
      
      final highSeverities = allSeverities.where((s) => s.index >= Severity.high.index).toList();
      expect(highSeverities, equals([Severity.high, Severity.critical]));

      final severityNames = allSeverities.map((s) => s.name).toList();
      expect(severityNames, equals(['low', 'medium', 'high', 'critical']));
    });
  });
}
