// GENERATED CODE - DO NOT MODIFY BY HAND

part of bakalari.modules.subjectList;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subject _$SubjectFromJson(Map<String, dynamic> json) {
  return Subject(
      subjectId: json['subjectId'] as String,
      subjectLong: json['subjectLong'] as String,
      subjectShort: json['subjectShort'] as String,
      teacherEmail: json['teacherEmail'] as String,
      teacherName: json['teacherName'] as String,
      teacherPhone: json['teacherPhone'] as String,
      teacherShort: json['teacherShort'] as String);
}

Map<String, dynamic> _$SubjectToJson(Subject instance) => <String, dynamic>{
      'subjectLong': instance.subjectLong,
      'subjectShort': instance.subjectShort,
      'subjectId': instance.subjectId,
      'teacherName': instance.teacherName,
      'teacherShort': instance.teacherShort,
      'teacherEmail': instance.teacherEmail,
      'teacherPhone': instance.teacherPhone
    };
