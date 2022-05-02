import 'package:flurobenu/router/transition_builder_delegate.dart';

enum RouteTransition {
  fadeIn,
  rightToLeft,
  rightToLeftWithFade,
  downToUp,

  /// This transition is intended to match the default for Android P.
  openUpwards,

  /// Slides the page upwards and fades it in, starting
  /// from 1/4 screen below the top.
  fadeUpwards,
  none,
}

extension TransitionExt on RouteTransition {
  TransitionBuilderDelegate get builder {
    switch (this) {
      case RouteTransition.fadeIn:
        return const FadeInTransition();
      case RouteTransition.rightToLeft:
        return const RightToLeftTransition();
      case RouteTransition.rightToLeftWithFade:
        return const RightToLeftWithFadeTransition();
      case RouteTransition.downToUp:
        return const DownToUpTransition();
      case RouteTransition.openUpwards:
        return const OpenUpwardsTransition();
      case RouteTransition.fadeUpwards:
        return const FadeUpwardsTransition();
      case RouteTransition.none:
        return const NoTransition();
    }
  }
}
