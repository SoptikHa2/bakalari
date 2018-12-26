library bakalari.core.school;

import 'package:json_annotation/json_annotation.dart';
part 'school.g.dart';

@JsonSerializable()
class School {
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

  School(
      {this.bakawebLink, this.name, this.bakawebVersion, this.allowedModules});

  factory School.fromJson(Map<String, dynamic> json) =>
      _$SchoolFromJson(json);
  Map<String, dynamic> toJson() => _$SchoolToJson(this);
}
