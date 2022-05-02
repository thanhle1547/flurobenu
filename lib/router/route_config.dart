import 'package:flutter/material.dart';

import 'route_transition.dart';
import 'transition_builder_delegate.dart';

class RouteConfig {
  final Widget Function(Map<String, dynamic>? arguments) pageBuilder;
  final RouteTransition? transition;
  final Duration? transitionDuration;
  final TransitionBuilderDelegate? customTransitionBuilderDelegate;
  final Curve? curve;
  final bool opaque;
  final bool fullscreenDialog;
  final List<String>? requiredArgumentNames;
  final Map<String, Type>? requiredArguments;
  // final Type? requiredArgumentType;
  final bool? preventDuplicates;

  RouteConfig({
    required this.pageBuilder,
    this.transition,
    this.transitionDuration,
    this.customTransitionBuilderDelegate,
    this.curve,
    required this.opaque,
    required this.fullscreenDialog,
    this.requiredArgumentNames,
    this.requiredArguments,
    // Type? requiredArgumentType,
    this.preventDuplicates,
  });
  //  : requiredArgumentType =
  //           requiredArgumentType ?? requiredArguments.runtimeType;
}
