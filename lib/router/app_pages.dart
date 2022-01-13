// ignore_for_file: constant_identifier_names, unnecessary_this

import 'package:flurobenu/cubits/post_favorites/post_favorites_cubit.dart';
import 'package:flurobenu/cubits/post_published/post_published_cubit.dart';
import 'package:flurobenu/navigate_mode.dart';
import 'package:flurobenu/screens/post_detail_screen.dart';
import 'package:flurobenu/screens/post_published_screen.dart';
import 'package:flurobenu/screens/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_router.dart' as trans show Transition;
import 'page_config.dart';

enum AppPages {
  Initial,
  //
  Post_Published,
  Post_Detail,
}

String _getPageArgumentErrorString(List<String> args) => args.join(', ');

Never _areRequired(List<String> properties) {
  throw ArgumentError.notNull(_getPageArgumentErrorString(properties));
}

void _checkMissingRequiredArgumentsAndAssureError(
  Map<String, dynamic>? arguments,
  List<String> argNames,
) {
  try {
    if (arguments == null) _areRequired(argNames);

    final List<String> missingArgNames =
        argNames.where((e) => arguments.containsKey(e) == false).toList();

    if (missingArgNames.isNotEmpty) _areRequired(missingArgNames);
  } catch (e) {
    // ignore: avoid_print
    print(e);

    rethrow;
  }
}

final RegExp _keyPattern = RegExp('(?<=[a-z])[A-Z]');

extension AppPagesExtension on AppPages {
  String get key => this
      .toString()
      .split('.')
      .last
      .replaceAll('_', '.')
      .replaceAllMapped(
        _keyPattern,
        (Match m) => "_${m.group(0) ?? ''}",
      )
      .toLowerCase();

  String get path => "/${this.key.replaceAll('.', '/')}";

  String get name => path;

  static PageConfig getPageConfig(
    AppPages page,
    Map<String, dynamic>? arguments,
  ) {
    switch (page) {
      case AppPages.Initial:
      case AppPages.Post_Published:
        if (page == AppPages.Initial &&
            navigateMode == NavigateMode.withoutContext) {
          return PageConfig()..pageBuilder = () => const SplashScreen();
        }

        return PageConfig()
          ..pageBuilder = () => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => PostPublishedCubit(),
                  ),
                  BlocProvider(
                    create: (_) => PostFavoritesCubit(),
                  ),
                ],
                child: const PostPublishedScreen(),
              );
      case AppPages.Post_Detail:
        _checkMissingRequiredArgumentsAndAssureError(arguments, ['name', 'id']);

        final String name = arguments!['name'] as String;
        final int id = arguments['id'] as int;

        return PageConfig()
          ..transition = trans.Transition.rightToLeftWithFade
          ..pageBuilder = () => PostDetailScreen(name: name, id: id);
      default:
        throw StateError(
          "Missing page: ${page.toString()} in AppPagesExtension.getPageConfig()",
        );
    }
  }

  static PageConfig getPageConfigForUnknownRouteName(String? name) =>
      getPageConfig(
        name == AppPages.Initial.name || name?.isEmpty == true
            ? AppPages.Initial
            : AppPages.values.firstWhere(
                (e) => e.name.contains(name!),
                orElse: () => AppPages.Initial,
              ),
        {},
      );
}
