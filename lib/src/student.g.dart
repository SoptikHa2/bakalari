// GENERATED CODE - DO NOT MODIFY BY HAND

part of bakalari.core.student;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) {
  return Student(
      name: json['name'] as String,
      schoolClass: json['schoolClass'] as String,
      year: json['year'] as int);
}

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'name': instance.name,
      'schoolClass': instance.schoolClass,
      'year': instance.year
    };
