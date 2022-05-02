// ignore_for_file: constant_identifier_names, unnecessary_this

enum AppPages {
  Initial,
  //
  Post_Published,

  // undefined page
  Post_Suggest,
  Post_Detail,
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
}
