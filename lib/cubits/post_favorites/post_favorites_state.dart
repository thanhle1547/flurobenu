abstract class PostFavoritesState {
  const PostFavoritesState();
}

class PostFavoritesInitialState extends PostFavoritesState {}

class PostFavoritesLoadedState extends PostFavoritesState {}

class PostFavoriteChangedState extends PostFavoritesState {
  final int id;

  const PostFavoriteChangedState(this.id);
}
