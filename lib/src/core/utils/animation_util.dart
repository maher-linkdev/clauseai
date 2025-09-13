import 'package:deal_insights_assistant/src/core/enum/slide_direction_enum.dart';
import 'package:flutter/animation.dart' show Offset;

class AnimationUtil {
  static Offset getBeginOffset(SlideFromDirection direction) {
    switch (direction) {
      case SlideFromDirection.top:
        return const Offset(0, -2.0);
      case SlideFromDirection.bottom:
        return const Offset(0, 2.0);
      case SlideFromDirection.left:
        return const Offset(-2.0, 0);
      case SlideFromDirection.right:
        return const Offset(2.0, 0);
    }
  }
}
