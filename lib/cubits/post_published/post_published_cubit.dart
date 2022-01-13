import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mock_data/mock_data.dart';

import 'post_published_state.dart';

class PostPublishedCubit extends Cubit<PostPublishedState> {
  PostPublishedCubit() : super(PostPublishedState.loading()) {
    _loadData();
  }

  late final List<String> names;

  void _loadData() {
    names = List.generate(10, (_) => mockName());

    emit(state.copyWith(isLoading: false, names: names));
  }
}
