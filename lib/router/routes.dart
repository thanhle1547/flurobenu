import 'package:flurobenu/cubits/post_favorites/post_favorites_cubit.dart';
import 'package:flurobenu/cubits/post_published/post_published_cubit.dart';
import 'package:flurobenu/router/app_pages.dart';
import 'package:flurobenu/router/route_config.dart';
import 'package:flurobenu/router/route_transition.dart';
import 'package:flurobenu/screens/post_detail_screen.dart';
import 'package:flurobenu/screens/post_published_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

late final RouteConfig _postPublished = RouteConfig(
  pageBuilder: (arguments) => MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (_) => PostPublishedCubit(),
      ),
      BlocProvider(
        create: (_) => PostFavoritesCubit(),
      ),
    ],
    child: const PostPublishedScreen(),
  ),
  opaque: true,
  fullscreenDialog: false,
);

late final RouteConfig _postDetail = RouteConfig(
  requiredArguments: {
    'name': String,
    'id': int,
    'aRandomIntListForNothing': 'List<int>',
    'anotherRandomListForNothing': List,
    'aRandomMapForNothing': Map,
    // uncomment each one of the line below to see the error
    // 'aRandomValueWillThrowErrorAtAssert': dynamic,
    // 'aRandomValueWillThrowErrorAtAssert': 'list<int>',
    'anIntValueButTheDeclarationIsAIntValue': 9,
    // 'aFunction': 'void Function()',
    'aFunction': Function,
  },
  pageBuilder: (arguments) => PostDetailScreen(
    name: arguments!['name'] as String,
    id: arguments['id'] as int,
  ),
  transition: RouteTransition.rightToLeftWithFade,
  opaque: true,
  fullscreenDialog: false,
);

late final Map<dynamic, RouteConfig> routes = {
  AppPages.Initial: _postPublished,
  AppPages.Post_Published: _postPublished,
  AppPages.Post_Detail: _postDetail,
};
