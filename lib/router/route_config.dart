import 'package:flutter/material.dart';

import 'route_transition.dart';
import 'transition_builder_delegate.dart';

const String assertRequiredArgumentsFailed =
    'A value of type dynamic can not be defined';

bool assertRequiredArguments(Map<String, Object>? requiredArguments) {
  if (requiredArguments == null) return true;

  for (final MapEntry<String, Object> item in requiredArguments.entries) {
    final String type = item.value.toString();

    if (type == 'dynamic') return false;
  }

  return true;
}

class RouteConfig {
  final Widget Function(Map<String, dynamic>? arguments) pageBuilder;
  final RouteTransition? transition;
  final Duration? transitionDuration;
  final TransitionBuilderDelegate? customTransitionBuilderDelegate;
  final Curve? curve;
  final bool opaque;
  final bool fullscreenDialog;
  final List<String>? requiredArgumentNames;

  /// The key is the name of argument.
  ///
  /// The value is the type of argument. It's can be anything but [dynamic].
  ///
  /// Example:
  /// ```dart
  /// requiredArguments: {
  ///   'val_1': int,
  ///   'val_2': String,
  ///   'val_3': List,
  ///   'val_4': 'List<int>',
  ///   'val_5': 9,
  /// }
  /// ```
  /// In above example:
  ///
  ///  * 'val_4'` has value of `'List<int>'` (a String),
  /// not `List<int>`, because dart analysis will show error:
  /// `This requires the 'constructor-tearoffs' language feature to be enabled.`
  ///
  ///  * `'val_5'` has value of `9` (a spcific number), this value will
  /// be treat as `runtimeType`
  final Map<String, Object>? requiredArguments;
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
  }) : assert(
          assertRequiredArguments(requiredArguments),
          assertRequiredArgumentsFailed,
        );
  //  : requiredArgumentType =
  //           requiredArgumentType ?? requiredArguments.runtimeType;
}
