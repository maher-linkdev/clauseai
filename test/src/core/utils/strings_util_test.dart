import 'package:flutter_test/flutter_test.dart';
import 'package:deal_insights_assistant/src/core/utils/strings_util.dart';

void main() {
  group('StringsUtil', () {
    group('cleanJsonResponseString', () {
      test('should remove json markdown wrapper from beginning and end', () {
        const input = '```json\n{"key": "value"}\n```';
        const expected = '{"key": "value"}';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should remove only json markdown wrapper from beginning', () {
        const input = '```json\n{"key": "value"}';
        const expected = '{"key": "value"}';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should remove only markdown wrapper from end', () {
        const input = '{"key": "value"}\n```';
        const expected = '{"key": "value"}';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should handle string without markdown wrappers', () {
        const input = '{"key": "value"}';
        const expected = '{"key": "value"}';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should trim whitespace from input', () {
        const input = '   {"key": "value"}   ';
        const expected = '{"key": "value"}';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should handle complex json with markdown wrappers', () {
        const input = '''```json
{
  "name": "John Doe",
  "age": 30,
  "address": {
    "street": "123 Main St",
    "city": "New York"
  },
  "hobbies": ["reading", "swimming"]
}
```''';
        const expected = '''{
  "name": "John Doe",
  "age": 30,
  "address": {
    "street": "123 Main St",
    "city": "New York"
  },
  "hobbies": ["reading", "swimming"]
}''';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should handle empty string', () {
        const input = '';
        const expected = '';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should handle string with only whitespace', () {
        const input = '   \n\t   ';
        const expected = '';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should handle string with only json markdown wrapper', () {
        const input = '```json```';
        const expected = '';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should handle string with only opening json markdown', () {
        const input = '```json';
        const expected = '';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should handle string with only closing markdown', () {
        const input = '```';
        const expected = '';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should handle json with nested backticks', () {
        const input = '```json\n{"code": "```javascript\\nconsole.log(\\"hello\\");\\n```"}\n```';
        const expected = '{"code": "```javascript\\nconsole.log(\\"hello\\");\\n```"}';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should handle malformed json with markdown wrappers', () {
        const input = '```json\n{"key": "value",}\n```';
        const expected = '{"key": "value",}';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should handle json array with markdown wrappers', () {
        const input = '```json\n[{"id": 1}, {"id": 2}]\n```';
        const expected = '[{"id": 1}, {"id": 2}]';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should handle string with multiple json markdown blocks', () {
        const input = '```json\n{"first": "block"}\n```\n```json\n{"second": "block"}\n```';
        // Only removes the first occurrence from beginning and last from end
        const expected = '{"first": "block"}\n```\n```json\n{"second": "block"}';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should handle case sensitivity', () {
        const input = '```JSON\n{"key": "value"}\n```';
        // Should not remove uppercase JSON
        const expected = '```JSON\n{"key": "value"}';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should handle special characters in json', () {
        const input = '```json\n{"special": "äöü@#\$%^&*()_+-={}[]|\\\\:;\\\"\'<>?,./"}\n```';
        const expected = '{"special": "äöü@#\$%^&*()_+-={}[]|\\\\:;\\\"\'<>?,./"}';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should handle very long json string', () {
        final longValue = 'a' * 10000;
        final input = '```json\n{"longValue": "$longValue"}\n```';
        final expected = '{"longValue": "$longValue"}';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });

      test('should handle json with newlines and tabs', () {
        const input = '```json\n{\n\t"key": "value",\n\t"nested": {\n\t\t"inner": "data"\n\t}\n}\n```';
        const expected = '{\n\t"key": "value",\n\t"nested": {\n\t\t"inner": "data"\n\t}\n}';
        
        final result = StringsUtil.cleanJsonResponseString(input);
        
        expect(result, equals(expected));
      });
    });
  });
}
