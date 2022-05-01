import 'dart:developer' show log;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class RouteLoggingObserver extends RouteObserver<PageRoute<dynamic>> {
  late final RegExp _dynamicWordRegex = RegExp(r'\bdynamic\b');

  String _objectRuntimeType(Object? object) => objectRuntimeType(object, '');

  String _getStringRepresentationOfListItems(List list) {
    if (list.isEmpty) return '[]';

    if (list is List<num> ||
        list is List<bool> ||
        list is List<String> ||
        list is List<Map> ||
        list is List<Set> ||
        list is List<Symbol> ||
        list is List<BigInt>) {
      return list.toString();
    }

    final String firstItemRuntimeType = _objectRuntimeType(list[0]);
    final String listRuntimeType = _objectRuntimeType(list);

    final String startString = "[Instance of '$firstItemRuntimeType'";

    final isDynamicList = listRuntimeType.contains(_dynamicWordRegex);

    final bool didItemNotOverrideToString =
        (isDynamicList ? list : [list[0]]).toString().startsWith(startString);

    late final isSingleItemTypeList =
        listRuntimeType.contains(RegExp("\\b$firstItemRuntimeType\\b"));

    if (didItemNotOverrideToString && (isDynamicList || isSingleItemTypeList)) {
      return "$startString, ...]";
    }

    return list.toString();
  }

  String _resolveArguments(Object? args) {
    if (args == null) return '';

    if (args is Map)
      // ignore: prefer_interpolation_to_compose_strings
      return '?' +
          args.entries
              .map(
                (e) => [
                  e.key.toString(),
                  if (e.value is Function)
                    _objectRuntimeType(e.value)
                  else if (e.value is List)
                    [
                      _objectRuntimeType(e.value),
                      "(${e.value.length} item${e.value.length == 1 ? '' : 's'})",
                      _getStringRepresentationOfListItems(e.value as List),
                    ].join(' ')
                  else
                    e.value.toString(),
                ].join('='),
              )
              .join('&');

    return "?${args.toString()}";
  }

  void _log(
    String action,
    RouteSettings settings, {
    bool seperateArgumentsToNewLine = false,
  }) {
    String arguments = _resolveArguments(settings.arguments);

    if (seperateArgumentsToNewLine) {
      final int numWhiteSpace =
          (settings.name?.length ?? 0) > 9 ? settings.name!.length - 9 : 0;
      arguments = "\n${' ' * numWhiteSpace}message: $arguments";
    }

    log(
      "$action: ${settings.name}$arguments",
      name: 'Navigator',
    );
  }

  bool _isModalBottomSheetRoute(Route<dynamic> route) =>
      objectRuntimeType(route, '').contains('_ModalBottomSheetRoute');

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    if (route is DialogRoute)
      _log('CLOSE DIALOG', route.settings);
    else if (_isModalBottomSheetRoute(route))
      _log('CLOSE MODEL BOTTOM SHEET', route.settings);
    else if (route.settings.name != null) _log('POP ROUTE', route.settings);
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    if (route is DialogRoute)
      _log(
        'SHOW DIALOG',
        route.settings,
        seperateArgumentsToNewLine: true,
      );
    else if (_isModalBottomSheetRoute(route))
      _log('SHOW MODEL BOTTOM SHEET', route.settings);
    else if (route.settings.name != null) _log('PUSH ROUTE', route.settings);
  }
}
