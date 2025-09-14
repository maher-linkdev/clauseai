import 'package:flutter_test/flutter_test.dart';
import 'package:deal_insights_assistant/src/core/enum/slide_direction_enum.dart';

void main() {
  group('SlideFromDirection enum', () {
    test('should have correct values', () {
      expect(SlideFromDirection.values, hasLength(4));
      expect(SlideFromDirection.values, contains(SlideFromDirection.bottom));
      expect(SlideFromDirection.values, contains(SlideFromDirection.top));
      expect(SlideFromDirection.values, contains(SlideFromDirection.left));
      expect(SlideFromDirection.values, contains(SlideFromDirection.right));
    });

    test('should have correct order', () {
      final values = SlideFromDirection.values;
      expect(values[0], equals(SlideFromDirection.bottom));
      expect(values[1], equals(SlideFromDirection.top));
      expect(values[2], equals(SlideFromDirection.left));
      expect(values[3], equals(SlideFromDirection.right));
    });

    test('should have correct index values', () {
      expect(SlideFromDirection.bottom.index, equals(0));
      expect(SlideFromDirection.top.index, equals(1));
      expect(SlideFromDirection.left.index, equals(2));
      expect(SlideFromDirection.right.index, equals(3));
    });

    test('should have correct string representation', () {
      expect(SlideFromDirection.bottom.toString(), equals('SlideFromDirection.bottom'));
      expect(SlideFromDirection.top.toString(), equals('SlideFromDirection.top'));
      expect(SlideFromDirection.left.toString(), equals('SlideFromDirection.left'));
      expect(SlideFromDirection.right.toString(), equals('SlideFromDirection.right'));
    });

    test('should have correct name property', () {
      expect(SlideFromDirection.bottom.name, equals('bottom'));
      expect(SlideFromDirection.top.name, equals('top'));
      expect(SlideFromDirection.left.name, equals('left'));
      expect(SlideFromDirection.right.name, equals('right'));
    });

    test('should support equality comparison', () {
      expect(SlideFromDirection.bottom, equals(SlideFromDirection.bottom));
      expect(SlideFromDirection.top, equals(SlideFromDirection.top));
      expect(SlideFromDirection.left, equals(SlideFromDirection.left));
      expect(SlideFromDirection.right, equals(SlideFromDirection.right));
      
      expect(SlideFromDirection.bottom, isNot(equals(SlideFromDirection.top)));
      expect(SlideFromDirection.left, isNot(equals(SlideFromDirection.right)));
    });

    test('should support switch statements', () {
      String getDirectionDescription(SlideFromDirection direction) {
        switch (direction) {
          case SlideFromDirection.bottom:
            return 'Slide from bottom';
          case SlideFromDirection.top:
            return 'Slide from top';
          case SlideFromDirection.left:
            return 'Slide from left';
          case SlideFromDirection.right:
            return 'Slide from right';
        }
      }

      expect(getDirectionDescription(SlideFromDirection.bottom), equals('Slide from bottom'));
      expect(getDirectionDescription(SlideFromDirection.top), equals('Slide from top'));
      expect(getDirectionDescription(SlideFromDirection.left), equals('Slide from left'));
      expect(getDirectionDescription(SlideFromDirection.right), equals('Slide from right'));
    });

    test('should be usable in collections', () {
      final directionSet = {
        SlideFromDirection.bottom,
        SlideFromDirection.top,
        SlideFromDirection.left,
        SlideFromDirection.right
      };
      expect(directionSet, hasLength(4));
      expect(directionSet.contains(SlideFromDirection.bottom), isTrue);
      expect(directionSet.contains(SlideFromDirection.right), isTrue);

      final directionList = [
        SlideFromDirection.right,
        SlideFromDirection.bottom,
        SlideFromDirection.left,
        SlideFromDirection.top
      ];
      expect(directionList, hasLength(4));
      expect(directionList.contains(SlideFromDirection.top), isTrue);
    });

    test('should support filtering and mapping', () {
      final allDirections = SlideFromDirection.values;
      
      final verticalDirections = allDirections
          .where((d) => d == SlideFromDirection.top || d == SlideFromDirection.bottom)
          .toList();
      expect(verticalDirections, equals([SlideFromDirection.bottom, SlideFromDirection.top]));

      final horizontalDirections = allDirections
          .where((d) => d == SlideFromDirection.left || d == SlideFromDirection.right)
          .toList();
      expect(horizontalDirections, equals([SlideFromDirection.left, SlideFromDirection.right]));

      final directionNames = allDirections.map((d) => d.name).toList();
      expect(directionNames, equals(['bottom', 'top', 'left', 'right']));
    });

    test('should handle opposite directions', () {
      // Helper function to get opposite direction
      SlideFromDirection getOpposite(SlideFromDirection direction) {
        switch (direction) {
          case SlideFromDirection.bottom:
            return SlideFromDirection.top;
          case SlideFromDirection.top:
            return SlideFromDirection.bottom;
          case SlideFromDirection.left:
            return SlideFromDirection.right;
          case SlideFromDirection.right:
            return SlideFromDirection.left;
        }
      }

      expect(getOpposite(SlideFromDirection.bottom), equals(SlideFromDirection.top));
      expect(getOpposite(SlideFromDirection.top), equals(SlideFromDirection.bottom));
      expect(getOpposite(SlideFromDirection.left), equals(SlideFromDirection.right));
      expect(getOpposite(SlideFromDirection.right), equals(SlideFromDirection.left));
    });

    test('should categorize directions correctly', () {
      bool isVertical(SlideFromDirection direction) {
        return direction == SlideFromDirection.top || direction == SlideFromDirection.bottom;
      }

      bool isHorizontal(SlideFromDirection direction) {
        return direction == SlideFromDirection.left || direction == SlideFromDirection.right;
      }

      expect(isVertical(SlideFromDirection.top), isTrue);
      expect(isVertical(SlideFromDirection.bottom), isTrue);
      expect(isVertical(SlideFromDirection.left), isFalse);
      expect(isVertical(SlideFromDirection.right), isFalse);

      expect(isHorizontal(SlideFromDirection.left), isTrue);
      expect(isHorizontal(SlideFromDirection.right), isTrue);
      expect(isHorizontal(SlideFromDirection.top), isFalse);
      expect(isHorizontal(SlideFromDirection.bottom), isFalse);
    });
  });
}
