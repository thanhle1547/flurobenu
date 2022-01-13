class PostPublishedState {
  final bool isLoading;
  final List<String> names;

  PostPublishedState({
    required this.isLoading,
    required this.names,
  });

  factory PostPublishedState.loading() => PostPublishedState(
        isLoading: true,
        names: [],
      );

  PostPublishedState copyWith({
    bool? isLoading,
    List<String>? names,
  }) =>
      PostPublishedState(
        isLoading: isLoading ?? this.isLoading,
        names: names ?? this.names,
      );
}
