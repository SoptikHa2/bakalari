library bakalari.core.student;

import 'package:json_annotation/json_annotation.dart';
part 'student.g.dart';

/// This is student class.
/// Each student class is associated with one
/// `Bakalari` instance. All queries to the
/// `Bakalari` instance direclty alters student
/// connected to it.
///
/// Student class provides access to data about him.
/// Data about school can be found in `School` class
@JsonSerializable()
class Student {
  /// Name of student, reversed.
  /// The name is in format `Surname Name`
  String name;

  /// Student's class, in format like `3.A`
  String schoolClass;

  /// Student's year in school
  /// ("ročník")
  int year;

  Student({this.name, this.schoolClass, this.year});

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
  Map<String, dynamic> toJson() => _$StudentToJson(this);
}
