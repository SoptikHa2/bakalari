library bakalari.core.school;

class School{
  /// Link to school's bakaweb login page
  Uri bakawebLink;
  /// Name of school. This often contains school address.
  String name;
  /// Version of Bakaláři school system
  String bakawebVersion;
  /// Allowed school modules. This list contains
  /// modules identifiers. Some of the modules
  /// may not be yet implemented by this library.
  /// 
  /// If you know how to implement them, leave
  /// a [GitHub issue](https://github.com/SoptikHa2/bakalari).
  List<String> allowedModules;
}