import 'package:flutter/widgets.dart';

import 'transition_builder_delegate.dart';

class FlurobenuPageRouteBuilder<T> extends PageRouteBuilder<T> {
  FlurobenuPageRouteBuilder({
    RouteSettings? settings,
    required RoutePageBuilder pageBuilder,
    required this.transitionBuilderDelegate,
    required Duration transitionDuration,
    this.curve,
    required bool opaque,
    required bool fullscreenDialog,
  }) : super(
          settings: settings,
          pageBuilder: pageBuilder,
          transitionDuration: transitionDuration,
          opaque: opaque,
          fullscreenDialog: fullscreenDialog,
        );

  final TransitionBuilderDelegate transitionBuilderDelegate;
  final Curve? curve;

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return transitionBuilderDelegate.buildTransition(
      this,
      context,
      animation,
      secondaryAnimation,
      curve,
      child,
    );
  }
}
