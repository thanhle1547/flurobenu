import 'package:flurobenu/cubits/post_favorites/post_favorites_cubit.dart';
import 'package:flurobenu/cubits/post_published/post_published_cubit.dart';
import 'package:flurobenu/cubits/post_published/post_published_state.dart';
import 'package:flurobenu/navigate_mode.dart';
import 'package:flurobenu/router/app_pages.dart';
import 'package:flurobenu/router/app_router.dart';
import 'package:flurobenu/widget/favorite_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostPublishedScreen extends StatelessWidget {
  const PostPublishedScreen({Key? key}) : super(key: key);

  void _listItemTapHandler(BuildContext context, String name, int id) {
    if (navigateMode == NavigateMode.withoutContext) {
      AppRouter.navigator.toPage(
        AppPages.Post_Detail,
        blocValue: context.read<PostFavoritesCubit>(),
        arguments: {
          'name': name,
          'id': id,
          'aRandomIntListForNothing': [1, 2],
          'anotherRandomListForNothing': [3, 4],
          'aRandomMapForNothing': {'a': 0},
          // 'aRandomValueWillThrowErrorAtAssert': 0,
          // 'aRandomValueWillThrowErrorAtAssert': [1, 2],
          'anIntValueButTheDeclarationIsAIntValue': 0,
          'aFunction': () {},
        },
      );
    } else {
      AppRouter.toPage(
        context,
        AppPages.Post_Detail,
        blocValue: context.read<PostFavoritesCubit>(),
        arguments: {
          'name': name,
          'id': id,
          'aRandomIntListForNothing': [1, 2],
          'anotherRandomListForNothing': [3, 4],
          'aRandomMapForNothing': {'a': 0},
          // 'aRandomValueWillThrowErrorAtAssert': 0,
          // 'aRandomValueWillThrowErrorAtAssert': [1, 2],
          'anIntValueButTheDeclarationIsAIntValue': 0,
          'aFunction': () {},
        },
      );
    }
  }

  void _fabPressedHandler(BuildContext context) {
    if (navigateMode == NavigateMode.withoutContext) {
      AppRouter.navigator.toPage(AppPages.Post_Suggest);
    } else {
      AppRouter.toPage(context, AppPages.Post_Suggest);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post published'),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xEEFFFDFF),
      body: BlocBuilder<PostPublishedCubit, PostPublishedState>(
        builder: (_, state) {
          if (state.isLoading)
            return const Center(
              child: CircularProgressIndicator(),
            );

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20),
            itemCount: state.names.length,
            itemBuilder: (_, index) => Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 10,
              ),
              child: InkWell(
                onTap: () => _listItemTapHandler(
                  context,
                  state.names[index],
                  index,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                child: Ink(
                  height: 80,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, -1),
                        color: Colors.black12,
                        blurRadius: 24,
                        spreadRadius: -14,
                      ),
                    ],
                  ),
                  child: Center(
                    child: ListTile(
                      title: Text(state.names[index]),
                      trailing: FavoriteButton(id: index),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _fabPressedHandler(context),
        child: const Icon(Icons.undo_rounded),
      ),
    );
  }
}
