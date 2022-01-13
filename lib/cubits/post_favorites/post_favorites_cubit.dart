import 'package:flutter_bloc/flutter_bloc.dart';

import 'post_favorites_state.dart';

class PostFavoritesCubit extends Cubit<PostFavoritesState> {
  PostFavoritesCubit() : super(PostFavoritesInitialState()) {
    _loadData();
  }

  late final List<int> _ids;

  void _loadData() {
    _ids = [];
    emit(PostFavoritesLoadedState());
  }

  void toogle(int id) {
    if (hasSaved(id))
      _ids.remove(id);
    else
      _ids.add(id);

    emit(PostFavoriteChangedState(id));
  }

  bool hasSaved(int id) => _ids.contains(id);
}
