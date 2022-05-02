import 'package:flurobenu/router/transition_builder_delegate.dart';

enum Transition {
  fadeIn,
  rightToLeft,
  rightToLeftWithFade,
  downToUp,
  none,
}

extension TransitionExt on Transition {
  TransitionBuilderDelegate get builder {
    switch (this) {
      case Transition.fadeIn:
        return const FadeInTransition();
      case Transition.rightToLeft:
        return const RightToLeftTransition();
      case Transition.rightToLeftWithFade:
        return const RightToLeftWithFadeTransition();
      case Transition.downToUp:
        return const DownToUpTransition();
      case Transition.none:
        return const NoTransition();
    }
  }
}
