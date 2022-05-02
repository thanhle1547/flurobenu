// ignore_for_file: require_trailing_commas

import 'package:flutter/material.dart';

abstract class TransitionBuilderDelegate {
  const TransitionBuilderDelegate();

  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Curve? curve,
    Widget child,
  );
}

extension AnimatableExt on Animatable {
  /// Returns a new [Animatable] whose value is determined by first evaluating
  /// the given parent and then evaluating this object.
  ///
  /// This allows [Tween]s to be chained before obtaining an [Animation].
  Animatable<T> chainWithCurve<T>(Curve? curve) {
    if (curve == null) return this as Animatable<T>;

    return chain(CurveTween(curve: curve)) as Animatable<T>;
  }
}

class NoTransition extends TransitionBuilderDelegate {
  const NoTransition();

  @override
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Curve? curve,
    Widget child,
  ) {
    return child;
  }
}

class FadeInTransition extends TransitionBuilderDelegate {
  const FadeInTransition();

  @override
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Curve? curve,
    Widget child,
  ) {
    final CurvedAnimation? curvedAnimation =
        curve == null ? null : CurvedAnimation(parent: animation, curve: curve);

    return FadeTransition(
      opacity: curvedAnimation ?? animation,
      child: child,
    );
  }
}

class RightToLeftTransition extends TransitionBuilderDelegate {
  const RightToLeftTransition();

  @override
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Curve? curve,
    Widget child,
  ) {
    final Animatable<Offset> tween = Tween(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).chainWithCurve(curve);

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}

class RightToLeftWithFadeTransition extends TransitionBuilderDelegate {
  const RightToLeftWithFadeTransition();

  @override
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Curve? curve,
    Widget child,
  ) {
    Animatable<Offset> tween = Tween(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    );

    if (curve != null) tween = tween.chain(CurveTween(curve: curve));

    return SlideTransition(
      position: tween.animate(animation),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

class DownToUpTransition extends TransitionBuilderDelegate {
  const DownToUpTransition();

  @override
  Widget buildTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Curve? curve,
    Widget child,
  ) {
    Animatable<Offset> tween = Tween(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    );

    if (curve != null) tween = tween.chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween),
      child: child,
    );
  }
}
