import 'package:deal_insights_assistant/src/core/enum/slide_direction_enum.dart';
import 'package:deal_insights_assistant/src/core/utils/animation_util.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnimationUtil', () {
    group('getBeginOffset', () {
      test('should return correct offset for top direction', () {
        final result = AnimationUtil.getBeginOffset(SlideFromDirection.top);
        expect(result, equals(const Offset(0, -2.0)));
      });

      test('should return correct offset for bottom direction', () {
        final result = AnimationUtil.getBeginOffset(SlideFromDirection.bottom);
        expect(result, equals(const Offset(0, 2.0)));
      });

      test('should return correct offset for left direction', () {
        final result = AnimationUtil.getBeginOffset(SlideFromDirection.left);
        expect(result, equals(const Offset(-2.0, 0)));
      });

      test('should return correct offset for right direction', () {
        final result = AnimationUtil.getBeginOffset(SlideFromDirection.right);
        expect(result, equals(const Offset(2.0, 0)));
      });

      test('should handle all enum values', () {
        // Test that all enum values are handled
        for (final direction in SlideFromDirection.values) {
          expect(() => AnimationUtil.getBeginOffset(direction), returnsNormally);
        }
      });

      test('should return offsets with correct magnitude', () {
        final topOffset = AnimationUtil.getBeginOffset(SlideFromDirection.top);
        final bottomOffset = AnimationUtil.getBeginOffset(SlideFromDirection.bottom);
        final leftOffset = AnimationUtil.getBeginOffset(SlideFromDirection.left);
        final rightOffset = AnimationUtil.getBeginOffset(SlideFromDirection.right);

        // All offsets should have magnitude of 2.0
        expect(topOffset.distance, equals(2.0));
        expect(bottomOffset.distance, equals(2.0));
        expect(leftOffset.distance, equals(2.0));
        expect(rightOffset.distance, equals(2.0));
      });

      test('should return opposite offsets for opposite directions', () {
        final topOffset = AnimationUtil.getBeginOffset(SlideFromDirection.top);
        final bottomOffset = AnimationUtil.getBeginOffset(SlideFromDirection.bottom);
        final leftOffset = AnimationUtil.getBeginOffset(SlideFromDirection.left);
        final rightOffset = AnimationUtil.getBeginOffset(SlideFromDirection.right);

        // Top and bottom should be opposite in Y direction
        expect(topOffset.dy, equals(-bottomOffset.dy));
        expect(topOffset.dx, equals(bottomOffset.dx));

        // Left and right should be opposite in X direction
        expect(leftOffset.dx, equals(-rightOffset.dx));
        expect(leftOffset.dy, equals(rightOffset.dy));
      });

      test('should return offsets that move elements off screen', () {
        // All offsets should move elements outside the visible area (magnitude > 1.0)
        for (final direction in SlideFromDirection.values) {
          final offset = AnimationUtil.getBeginOffset(direction);
          expect(offset.distance, greaterThan(1.0));
        }
      });

      test('should work with animation transitions', () {
        // Test that offsets can be used in typical animation scenarios
        final beginOffset = AnimationUtil.getBeginOffset(SlideFromDirection.left);
        const endOffset = Offset.zero;

        // Simulate animation progress
        final midOffset = Offset.lerp(beginOffset, endOffset, 0.5);

        expect(midOffset, isNotNull);
        expect(midOffset!.dx, equals(-1.0)); // Halfway between -2.0 and 0
        expect(midOffset.dy, equals(0.0));
      });

      test('should handle edge case calculations', () {
        final topOffset = AnimationUtil.getBeginOffset(SlideFromDirection.top);
        final bottomOffset = AnimationUtil.getBeginOffset(SlideFromDirection.bottom);

        // Test mathematical properties
        expect(topOffset.dy, isNegative);
        expect(bottomOffset.dy, isPositive);
        expect(topOffset.dx, equals(0.0));
        expect(bottomOffset.dx, equals(0.0));
      });
    });

    group('Offset properties', () {
      test('should create valid Offset objects', () {
        for (final direction in SlideFromDirection.values) {
          final offset = AnimationUtil.getBeginOffset(direction);

          expect(offset, isA<Offset>());
          expect(offset.dx, isA<double>());
          expect(offset.dy, isA<double>());
          expect(offset.dx.isFinite, isTrue);
          expect(offset.dy.isFinite, isTrue);
        }
      });

      test('should have correct coordinate system orientation', () {
        // Flutter coordinate system: (0,0) at top-left
        // Positive Y goes down, positive X goes right

        final topOffset = AnimationUtil.getBeginOffset(SlideFromDirection.top);
        final bottomOffset = AnimationUtil.getBeginOffset(SlideFromDirection.bottom);
        final leftOffset = AnimationUtil.getBeginOffset(SlideFromDirection.left);
        final rightOffset = AnimationUtil.getBeginOffset(SlideFromDirection.right);

        // Top should have negative Y (above screen)
        expect(topOffset.dy, lessThan(0));

        // Bottom should have positive Y (below screen)
        expect(bottomOffset.dy, greaterThan(0));

        // Left should have negative X (left of screen)
        expect(leftOffset.dx, lessThan(0));

        // Right should have positive X (right of screen)
        expect(rightOffset.dx, greaterThan(0));
      });
    });
  });
}
