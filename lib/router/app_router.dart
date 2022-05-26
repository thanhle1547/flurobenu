// ignore_for_file: require_trailing_commas

import 'dart:collection';
import 'dart:developer';

import 'package:flurobenu/router/transition_builder_delegate.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocBase, BlocProvider, MultiBlocProvider;
// ignore: implementation_imports
import 'package:flutter_bloc/src/bloc_provider.dart'
    show BlocProviderSingleChildWidget;

import 'app_pages.dart';
import 'argument_error.dart';
import 'flurobenu_page_route_builder.dart';
import 'route_config.dart';
import 'route_transition.dart';

typedef PageBuilder = Widget Function();

dynamic _initialPage;
RouteTransition? _defaultTransition;
Curve? _defaultTransitionCurve;
Duration? _defaultTransitionDuration;
bool _shouldPreventDuplicates = true;
// bool _checkDefinedArgumentsTypeAtRunning = false;

PageRouteBuilder<T> _createRoute<T>({
  required PageBuilder pageBuilder,
  required RouteSettings settings,
  TransitionBuilderDelegate? transitionBuilderDelegate,
  Duration? transitionDuration,
  Curve? curve,
  bool opaque = true,
  bool fullscreenDialog = false,
}) =>
    FlurobenuPageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (_, __, ___) => pageBuilder(),
      transitionBuilderDelegate: transitionBuilderDelegate ??
          _defaultTransition?.builder ??
          RouteTransition.none.builder,
      transitionDuration: transitionDuration ??
          _defaultTransitionDuration ??
          const Duration(milliseconds: 300),
      curve: curve ?? _defaultTransitionCurve,
      opaque: opaque,
      fullscreenDialog: fullscreenDialog,
    );

PageRouteBuilder _createRouteFromName(String? name) {
  final key = _routes.keys.firstWhere(
    (e) => _effectiveRouteNameBuilder(e) == name,
    orElse: () => _initialPage,
  );

  if (key == null) throw StateError("$name not found");

  final RouteConfig config = _routes[key]!;

  return _createRoute(
    pageBuilder: () => config.pageBuilder(null),
    settings: RouteSettings(name: name),
    transitionBuilderDelegate:
        config.transition?.builder ?? config.customTransitionBuilderDelegate,
  );
}

List<Type> _routeTypes = [];
bool get _shouldCheckRouteType => _routeTypes.isNotEmpty;

bool _checkRouteType(dynamic page) {
  assert(() {
    if (_shouldCheckRouteType && !_routeTypes.contains(page.runtimeType))
      throw ArgumentError(
        "Route types did not contain type ${page.runtimeType} ($page)",
      );

    return true;
  }());

  return true;
}

/* 
void _checkDefinedRouteRequiredArguments(
    Map<String, Object>? requiredArguments) {
  if (requiredArguments == null) return;

  for (final MapEntry<String, Object> item in requiredArguments.entries) {
    if (item.value.toString() == _dynamicWord)
      _logAndThrowError(InvalidArgumentTypeException(item.key));
  }

  // if (effectiveEntryTypeName == _dynamicWord)
  //   _logAndThrowError(ArgumentError.notNull(entry.key));
}
*/

String Function(dynamic page)? _routeNameBuilder;

String Function(dynamic page) get _effectiveRouteNameBuilder =>
    _routeNameBuilder ?? (page) => page.toString();

Map<dynamic, RouteConfig> _routes = HashMap(
  equals: (key0, key1) => key0 == key1,
  hashCode: (key) => key.hashCode,
);

class AppRouter {
  static String Function(dynamic page)? pageKeyBuilder;

  static void setDefaultConfig({
    List<Type>? routeTypes,
    Map<dynamic, RouteConfig>? routes,
    required dynamic initialPage,
    String Function(dynamic page)? routeNameBuilder,
    String Function(dynamic page)? pageKeyBuilder,
    RouteTransition? transition = RouteTransition.rightToLeft,
    Curve? transitionCurve = Curves.easeOutQuad,
    Duration? transitionDuration = const Duration(milliseconds: 320),
    bool preventDuplicates = true,
    bool checkDefinedArgumentsTypeAtRunning = true,
  }) {
    if (routeTypes != null) _routeTypes = routeTypes;
    if (routes != null) _routes.addAll(routes);
    _initialPage = initialPage;
    _routeNameBuilder = routeNameBuilder;
    AppRouter.pageKeyBuilder = pageKeyBuilder;
    _defaultTransition = transition;
    _defaultTransitionCurve = transitionCurve;
    _defaultTransitionDuration = transitionDuration;
    _shouldPreventDuplicates = preventDuplicates;
    // _checkDefinedArgumentsTypeAtRunning = checkDefinedArgumentsTypeAtRunning;
  }

  // ignore: avoid_setters_without_getters
  static set routeTypes(List<Type> routes) => _routeTypes = routes;

  /// * [requiredArguments] If used, [AppRouter] will check this before navigate
  ///
  /// For example:
  /// ```
  /// AppRouter.define(
  ///   page: AppPages.home,
  ///   requiredArgumentNames: ['id', 'name'],
  ///   pageBuilder: (args) {
  ///     // ...
  ///   },
  /// );
  /// ```
  ///
  /// * [requiredArguments] If used, [AppRouter] will check this before navigate
  ///
  /// For example:
  /// ```
  /// AppRouter.define(
  ///   page: AppPages.home,
  ///   requiredArgument: {
  ///     'id': int,
  ///     'name': String,
  ///   },
  ///   pageBuilder: (args) {
  ///     // ...
  ///   },
  /// );
  /// ```
  ///
  /// * [requiredArgumentType] If used, [AppRouter] will check this before navigate
  ///
  /// For example:
  /// ```
  /// AppRouter.define(
  ///   page: AppPages.home,
  ///   requiredArgumentType: ScreenArgument,
  ///   pageBuilder: (args) {
  ///     // ...
  ///   },
  /// );
  /// ```
  void define({
    dynamic page,
    List<String>? requiredArgumentNames,
    Map<String, Object>? requiredArguments,
    Type? requiredArgumentType,
    RouteTransition? transition,
    Duration? transitionDuration,
    TransitionBuilderDelegate? customTransitionBuilderDelegate,
    Curve? curve,
    bool opaque = true,
    bool fullscreenDialog = false,
    bool? preventDuplicates,
    required Widget Function(Map<String, dynamic>? arguments) pageBuilder,
  }) {
    assert(_checkRouteType(page));

    // if (_checkDefinedArgumentsTypeAtRunning)
    //   _checkDefinedRouteRequiredArguments(requiredArguments);

    assert(
      assertRequiredArguments(requiredArguments),
      assertRequiredArgumentsFailed,
    );

    _routes.putIfAbsent(
      page,
      () => RouteConfig(
        pageBuilder: pageBuilder,
        transition: transition,
        transitionDuration: transitionDuration,
        customTransitionBuilderDelegate: customTransitionBuilderDelegate,
        curve: curve,
        opaque: opaque,
        fullscreenDialog: fullscreenDialog,
        requiredArgumentNames: requiredArgumentNames,
        requiredArguments: requiredArguments,
        // requiredArgumentType: requiredArgumentType,
        preventDuplicates: preventDuplicates,
      ),
    );
  }

  void defineGroup({
    required List<dynamic> pages,
    List<String>? requiredArgumentNames,
    Map<String, Object>? requiredArguments,
    Type? requiredArgumentType,
    RouteTransition? transition,
    Duration? transitionDuration,
    TransitionBuilderDelegate? customTransitionBuilderDelegate,
    Curve? curve,
    bool opaque = true,
    bool fullscreenDialog = false,
    bool? preventDuplicates,
    required Widget Function(Map<String, dynamic>? arguments) pageBuilder,
  }) =>
      define(
        page: pages,
        requiredArgumentNames: requiredArgumentNames,
        requiredArguments: requiredArguments,
        requiredArgumentType: requiredArgumentType,
        transition: transition,
        transitionDuration: transitionDuration,
        customTransitionBuilderDelegate: customTransitionBuilderDelegate,
        curve: curve,
        opaque: opaque,
        fullscreenDialog: fullscreenDialog,
        pageBuilder: pageBuilder,
        preventDuplicates: preventDuplicates,
      );

  static GlobalKey<NavigatorState>? _navigatorKey;

  static GlobalKey<NavigatorState> createNavigatorKeyIfNotExisted() =>
      _navigatorKey ??= GlobalKey<NavigatorState>();

  static NavigatorState? get currentNavigator => _navigatorKey?.currentState;
  static NavigatorState get navigator {
    try {
      return _navigatorKey!.currentState!;
    } catch (e) {
      throw StateError(
        "${e.toString()}. Maybe you did not create Navigator key",
      );
    }
  }

  /// {@macro flutter.widgets.widgetsApp.onGenerateInitialRoutes}
  static List<Route<dynamic>> onGenerateInitialRoutes(String initialRoute) => [
        _createRouteFromName(initialRoute),
      ];

  /// {@macro flutter.widgets.widgetsApp.onUnknownRoute}
  static Route<dynamic>? onUnknownRoute(RouteSettings settings) =>
      _createRouteFromName(settings.name);

  /// https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments#2-create-a-widget-that-extracts-the-arguments
  static Object? extractArguments(BuildContext context) =>
      ModalRoute.of(context)?.settings.arguments;

  /// * [duration]
  /// The duration the transition going forwards.
  ///
  /// * [opaque]
  ///
  /// {@macro flutter.widgets.TransitionRoute.opaque}
  ///
  /// * [fullscreenDialog]
  ///
  /// {@macro flutter.widgets.PageRoute.fullscreenDialog}
  static Future<T?> toPage<T extends Object?, B extends BlocBase<Object?>>(
    BuildContext context,
    dynamic page, {
    Map<String, dynamic>? arguments,
    B? blocValue,
    List<BlocProviderSingleChildWidget>? blocProviders,
    RouteTransition? transition,
    TransitionBuilderDelegate? customTransitionBuilderDelegate,
    Curve? curve,
    Duration? duration,
    bool? opaque,
    bool? fullscreenDialog,
  }) =>
      (currentNavigator ?? Navigator.of(context)).toPage(
        page,
        arguments: arguments,
        blocValue: blocValue,
        blocProviders: blocProviders,
        transition: transition,
        customTransitionBuilderDelegate: customTransitionBuilderDelegate,
        curve: curve,
        duration: duration,
        opaque: opaque,
        fullscreenDialog: fullscreenDialog,
      );

  /// * [duration]
  /// The duration the transition going forwards.
  static Future<T?>?
      replaceWithPage<T extends Object?, B extends BlocBase<Object?>>(
    BuildContext context,
    dynamic page, {
    Map<String, dynamic>? arguments,
    B? blocValue,
    List<BlocProviderSingleChildWidget>? blocProviders,
    RouteTransition? transition,
    Curve? curve,
    Duration? duration,
  }) =>
          (currentNavigator ?? Navigator.of(context)).replaceWithPage(
            page,
            arguments: arguments,
            blocValue: blocValue,
            blocProviders: blocProviders,
            transition: transition,
            curve: curve,
            duration: duration,
          );

  /// * [duration]
  /// The duration the transition going forwards.
  static Future<T?>?
      replaceAllWithPage<T extends Object?, B extends BlocBase<Object?>>(
    BuildContext context,
    dynamic page, {
    bool Function(Route<dynamic>)? predicate,
    Map<String, dynamic>? arguments,
    B? blocValue,
    List<BlocProviderSingleChildWidget>? blocProviders,
    RouteTransition? transition,
    TransitionBuilderDelegate? customTransitionBuilderDelegate,
    Curve? curve,
    Duration? duration,
  }) =>
          (currentNavigator ?? Navigator.of(context)).replaceAllWithPage(
            page,
            predicate: predicate,
            arguments: arguments,
            blocValue: blocValue,
            blocProviders: blocProviders,
            transition: transition,
            customTransitionBuilderDelegate: customTransitionBuilderDelegate,
            curve: curve,
            duration: duration,
          );

  static void back<T>(
    BuildContext context, {
    T? result,
  }) =>
      (currentNavigator ?? Navigator.of(context)).back(result: result);

  static void backToPageName(BuildContext context, String name) =>
      (currentNavigator ?? Navigator.of(context)).backToPageName(name);

  static void backToPage(BuildContext context, AppPages page) =>
      backToPageName(context, page.name);
}

extension FlurobenuExtension on BuildContext {
  /// https://docs.flutter.dev/cookbook/navigation/navigate-with-arguments#2-create-a-widget-that-extracts-the-arguments
  Object? extractArguments() => ModalRoute.of(this)?.settings.arguments;

  /// * [duration]
  /// The duration the transition going forwards.
  ///
  /// * [opaque]
  ///
  /// {@macro flutter.widgets.TransitionRoute.opaque}
  ///
  /// * [fullscreenDialog]
  ///
  /// {@macro flutter.widgets.PageRoute.fullscreenDialog}
  Future<T?> toPage<T extends Object?, B extends BlocBase<Object?>>(
    dynamic page, {
    Map<String, dynamic>? arguments,
    B? blocValue,
    List<BlocProviderSingleChildWidget>? blocProviders,
    RouteTransition? transition,
    Curve? curve,
    Duration? duration,
    bool? opaque,
    bool? fullscreenDialog,
  }) =>
      Navigator.of(this).toPage(
        page,
        arguments: arguments,
        blocValue: blocValue,
        blocProviders: blocProviders,
        transition: transition,
        curve: curve,
        duration: duration,
        opaque: opaque,
        fullscreenDialog: fullscreenDialog,
      );

  /// * [duration]
  /// The duration the transition going forwards.
  Future<T?>? replaceWithPage<T extends Object?, B extends BlocBase<Object?>>(
    dynamic page, {
    Map<String, dynamic>? arguments,
    B? blocValue,
    List<BlocProviderSingleChildWidget>? blocProviders,
    RouteTransition? transition,
    Curve? curve,
    Duration? duration,
  }) =>
      Navigator.of(this).replaceWithPage(
        page,
        arguments: arguments,
        blocValue: blocValue,
        blocProviders: blocProviders,
        transition: transition,
        curve: curve,
        duration: duration,
      );

  /// * [duration]
  /// The duration the transition going forwards.
  Future<T?>?
      replaceAllWithPage<T extends Object?, B extends BlocBase<Object?>>(
    dynamic page, {
    bool Function(Route<dynamic>)? predicate,
    Map<String, dynamic>? arguments,
    B? blocValue,
    List<BlocProviderSingleChildWidget>? blocProviders,
    RouteTransition? transition,
    Curve? curve,
    Duration? duration,
  }) =>
          Navigator.of(this).replaceAllWithPage(
            page,
            predicate: predicate,
            arguments: arguments,
            blocValue: blocValue,
            blocProviders: blocProviders,
            transition: transition,
            curve: curve,
            duration: duration,
          );

  void back<T>({T? result}) => Navigator.of(this).back(result: result);

  void backToPageName(String name) => Navigator.of(this).backToPageName(name);

  void backToPage(AppPages page) => backToPageName(page.name);
}

void _logAndThrowError(Object e) {
  if (kDebugMode) {
    log(e.toString(), name: 'Flurobenu');
  }

  throw e;
}

/// throw StateError when you pushed the same page to the stack
void _duplicatedPage(String name) =>
    _logAndThrowError(StateError("Duplicated Page: $name"));

PageBuilder _resolvePageBuilderWithBloc<B extends BlocBase<Object?>>({
  required PageBuilder pageBuilder,
  B? blocValue,
  List<BlocProviderSingleChildWidget>? blocProviders,
}) {
  if (blocValue != null && blocProviders != null)
    _logAndThrowError(ArgumentError(
      'Do not pass value to [blocValue] & [blocProviders] at the same time.',
    ));

  if (blocValue != null)
    return () => BlocProvider.value(
          value: blocValue,
          child: pageBuilder(),
        );

  if (blocProviders != null)
    return () => MultiBlocProvider(
          providers: blocProviders,
          child: pageBuilder(),
        );

  return pageBuilder;
}

RouteConfig _getRouteConfig(dynamic page) {
  try {
    final dynamic key = _routes.keys.firstWhere(
      (e) {
        if (e is List) return e.contains(page);

        return e == page;
      },
      orElse: () => null,
    );

    if (key == null) throw "$page weren't defined";

    return _routes[key]!;
  } catch (e) {
    print(e);

    rethrow;
  }
}

/* 
const String _dynamicWord = 'dynamic';
late final RegExp _dynamicTypeRegex = RegExp(
  '<$_dynamicWord(, $_dynamicWord)?>\$',
);
*/

late final RegExp _dynamicTypeRegex = RegExp(
  r'<dynamic(, dynamic)?>$',
);

/*
late final RegExp _functionTypeRegex = RegExp(r' Function\(');

late final RegExp _functionParametersRegex = RegExp(
  r'\(\)',
);
*/

Widget Function() _getPageBuilder<T extends Object?>(
  RouteConfig routeConfig,
  dynamic argument,
  Map<String, dynamic>? arguments,
) {
  assert(() {
    if (routeConfig.requiredArgumentNames != null) {
      if (arguments == null) {
        _logAndThrowError(MissingArgument(
          routeConfig.requiredArgumentNames.toString(),
        ));
      }

      for (final String name in routeConfig.requiredArgumentNames!) {
        if (!arguments!.containsKey(name))
          _logAndThrowError(MissingArgument(name));
      }
    }

    if (routeConfig.requiredArguments != null) {
      if (arguments == null) {
        _logAndThrowError(MissingArgument(
          routeConfig.requiredArguments.toString(),
        ));
      } else {
        for (final entry in routeConfig.requiredArguments!.entries) {
          final Type effectiveEntryType = entry.value is Type
              ? entry.value as Type
              : entry.value.runtimeType;

          if (!arguments.containsKey(entry.key)) {
            _logAndThrowError(MissingArgument(entry.key, effectiveEntryType));
          }

          String effectiveEntryTypeName = entry.value is String
              ? entry.value as String
              : effectiveEntryType.toString();

          effectiveEntryTypeName =
              effectiveEntryTypeName.replaceFirst(_dynamicTypeRegex, '');

          final currentArgument = arguments[entry.key];

          String effectiveArgumentType = objectRuntimeType(currentArgument, '');

          if (effectiveArgumentType.contains('=>'))
            effectiveArgumentType = 'Function';

          /*
          if (!effectiveArgumentType.contains(_functionTypeRegex)) {
            final String argumentReturnType =
                effectiveArgumentType.split('=> ')[1];

            if (argumentReturnType != 'dynamic') {
              final String entryReturnType =
                  effectiveEntryTypeName.split(_functionTypeRegex)[0];

              if (argumentReturnType != entryReturnType) {
                _logAndThrowError(ArgumentTypeError(
                  effectiveEntryType,
                  argumentType,
                  "'${entry.key}'",
                ));
              }
            }

            effectiveArgumentType = effectiveArgumentType.replaceAll('\n', '');

            final String parameters = effectiveArgumentType.substring(
              effectiveArgumentType.indexOf('(') + 1,
              effectiveArgumentType.lastIndexOf(')'),
            );

            final int indexOfPCurlyBraces = effectiveArgumentType.indexOf('{');

            // Function

            String? namedArguments;

            if (indexOfPCurlyBraces != -1) {
              namedArguments = effectiveArgumentType.substring(
                indexOfPCurlyBraces + 1,
                effectiveArgumentType.lastIndexOf('}'),
              );
            }

            final List<String> argumentParametersType = parameters.split();

            _logAndThrowError(ArgumentTypeError(
              effectiveEntryType,
              argumentType,
              "'${entry.key}'",
            ));
          } else 
          */
          if (!effectiveArgumentType.contains(effectiveEntryTypeName)) {
            _logAndThrowError(ArgumentTypeError(
              effectiveEntryType,
              currentArgument.runtimeType,
              "'${entry.key}'",
            ));
          }
        }
      }
    }

    /*
    else if (routeConfig.requiredArgumentType != null) {
      if (argument != null && argument != routeConfig.requiredArgumentType) {
        throw ArgumentTypeError(
          routeConfig.requiredArgumentType!,
          argument.runtimeType,
        );
      } else if (arguments != null) {
        for (final entry in routeConfig.requiredArguments!.entries) {
          if (!arguments.containsKey(entry.key))
            throw MissingArgument(entry.key, entry.value);
          else if (arguments[entry.key].runtimeType != entry.value) {
            throw ArgumentTypeError(
              entry.value,
              arguments[entry.key].runtimeType,
              "'${entry.key}'",
            );
          }
        }
      }
    }
    */

    return true;
  }());

  return () => routeConfig.pageBuilder(arguments);
}

extension NavigatorStateExtension on NavigatorState {
  /// * [duration]
  /// The duration the transition going forwards.
  ///
  /// * [opaque]
  ///
  /// {@macro flutter.widgets.TransitionRoute.opaque}
  ///
  /// * [fullscreenDialog]
  ///
  /// {@macro flutter.widgets.PageRoute.fullscreenDialog}
  Future<T?> toPage<T extends Object?, B extends BlocBase<Object?>>(
    dynamic page, {
    dynamic argument,
    Map<String, dynamic>? arguments,
    B? blocValue,
    List<BlocProviderSingleChildWidget>? blocProviders,
    RouteTransition? transition,
    TransitionBuilderDelegate? customTransitionBuilderDelegate,
    Curve? curve,
    bool? preventDuplicates,
    Duration? duration,
    bool? opaque,
    bool? fullscreenDialog,
  }) {
    assert(_checkRouteType(page));

    final RouteConfig routeConfig = _getRouteConfig(page);

    // if (requiredArgumentNames != null)

    assert(() {
      if ((preventDuplicates ?? _shouldPreventDuplicates) &&
          widget.pages.isNotEmpty &&
          widget.pages.last.name == page.name) {
        _duplicatedPage(page.name.runtimeType.toString());
      }

      return true;
    }());

    return push<T>(
      _createRoute(
        pageBuilder: _resolvePageBuilderWithBloc(
          pageBuilder: _getPageBuilder(
            routeConfig,
            argument,
            arguments,
          ),
          blocValue: blocValue,
          blocProviders: blocProviders,
        ),
        settings: RouteSettings(
          name: _effectiveRouteNameBuilder(page),
          arguments: arguments,
        ),
        transitionBuilderDelegate:
            (transition ?? routeConfig.transition)?.builder ??
                customTransitionBuilderDelegate ??
                routeConfig.customTransitionBuilderDelegate,
        transitionDuration: duration ?? routeConfig.transitionDuration,
        curve: curve ?? routeConfig.curve,
        opaque: opaque ?? routeConfig.opaque,
        fullscreenDialog: fullscreenDialog ?? routeConfig.fullscreenDialog,
      ),
    );
  }

  /// * [duration]
  /// The duration the transition going forwards.
  Future<T?>? replaceWithPage<T extends Object?, B extends BlocBase<Object?>>(
    dynamic page, {
    dynamic argument,
    Map<String, dynamic>? arguments,
    B? blocValue,
    List<BlocProviderSingleChildWidget>? blocProviders,
    RouteTransition? transition,
    TransitionBuilderDelegate? customTransitionBuilderDelegate,
    Curve? curve,
    Duration? duration,
  }) {
    assert(_checkRouteType(page));

    final RouteConfig routeConfig = _getRouteConfig(page);

    return pushReplacement(
      _createRoute(
        pageBuilder: _resolvePageBuilderWithBloc(
          pageBuilder: _getPageBuilder(
            routeConfig,
            argument,
            arguments,
          ),
          blocValue: blocValue,
          blocProviders: blocProviders,
        ),
        settings: RouteSettings(
          name: _effectiveRouteNameBuilder(page),
          arguments: arguments,
        ),
        transitionBuilderDelegate:
            (transition ?? routeConfig.transition)?.builder ??
                customTransitionBuilderDelegate ??
                routeConfig.customTransitionBuilderDelegate,
        transitionDuration: duration ?? routeConfig.transitionDuration,
        curve: curve ?? routeConfig.curve,
        opaque: routeConfig.opaque,
        fullscreenDialog: routeConfig.fullscreenDialog,
      ),
    );
  }

  /// * [duration]
  /// The duration the transition going forwards.
  Future<T?>?
      replaceAllWithPage<T extends Object?, B extends BlocBase<Object?>>(
    dynamic page, {
    bool Function(Route<dynamic>)? predicate,
    dynamic argument,
    Map<String, dynamic>? arguments,
    B? blocValue,
    List<BlocProviderSingleChildWidget>? blocProviders,
    RouteTransition? transition,
    TransitionBuilderDelegate? customTransitionBuilderDelegate,
    Curve? curve,
    Duration? duration,
  }) {
    assert(_checkRouteType(page));

    final RouteConfig routeConfig = _getRouteConfig(page);

    return pushAndRemoveUntil(
      _createRoute(
        pageBuilder: _resolvePageBuilderWithBloc(
          pageBuilder: _getPageBuilder(
            routeConfig,
            argument,
            arguments,
          ),
          blocValue: blocValue,
          blocProviders: blocProviders,
        ),
        settings: RouteSettings(
          name: _effectiveRouteNameBuilder(page),
          arguments: arguments,
        ),
        transitionBuilderDelegate:
            (transition ?? routeConfig.transition)?.builder ??
                customTransitionBuilderDelegate ??
                routeConfig.customTransitionBuilderDelegate,
        transitionDuration: duration ?? routeConfig.transitionDuration,
        curve: curve ?? routeConfig.curve,
        opaque: routeConfig.opaque,
        fullscreenDialog: routeConfig.fullscreenDialog,
      ),
      predicate ?? (Route<dynamic> _) => false,
    );
  }

  void back<T>({T? result}) => pop(result);

  void backToPageName(String name) => popUntil((route) {
        if (route is DialogRoute) return false;

        String? routeName;

        if (route is MaterialPageRoute || route is PageRouteBuilder)
          routeName = route.settings.name;

        return routeName == name ||
            routeName == _effectiveRouteNameBuilder(_initialPage);
      });

  void backToPage(dynamic page) => backToPageName(
        _effectiveRouteNameBuilder(page),
      );
}
