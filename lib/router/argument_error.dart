class ArgumentTypeError {
  final String? _name;
  final Type _configType;
  final Type _assignedType;

  ArgumentTypeError(
    this._configType,
    this._assignedType, [
    this._name,
  ]);

  @override
  String toString() => "A value of type $_assignedType can’t be assigned to "
      "argument ${_name == null ? '' : "$_name "}of type $_configType";
}

/*
class InvalidArgumentTypeException {
  final String _name;

  InvalidArgumentTypeException(this._name);

  @override
  String toString() => "A value of type dynamic can not "
      "be defined (in argument name $_name)";
}
*/

/*
class NoArgumentError {
  const NoArgumentError();

  @override
  String toString() => 'No argument';
}
*/

class MissingArgument {
  final String _name;
  final Type? _type;

  MissingArgument(
    this._name, [
    this._type,
  ]);

  @override
  String toString() => "Missing argument: $_name"
      "${_type == null ? '' : " of type $_type "}";
}
