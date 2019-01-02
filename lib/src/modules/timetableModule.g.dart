// GENERATED CODE - DO NOT MODIFY BY HAND

part of bakalari.modules.timetable;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Timetable _$TimetableFromJson(Map<String, dynamic> json) {
  return Timetable(
      currentCycleCaption: json['currentCycleCaption'] as String,
      currentCycleID: json['currentCycleID'] as String,
      days: (json['days'] as List)
          ?.map(
              (e) => e == null ? null : Day.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      times: (json['times'] as List)
          ?.map((e) =>
              e == null ? null : LessonTime.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$TimetableToJson(Timetable instance) => <String, dynamic>{
      'days': instance.days?.map((d) => d.toJson())?.toList(),
      'times': instance.times?.map((t) => t.toJson())?.toList(),
      'currentCycleID': instance.currentCycleID,
      'currentCycleCaption': instance.currentCycleCaption
    };

Day _$DayFromJson(Map<String, dynamic> json) {
  return Day(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      lessons: (json['lessons'] as List)
          ?.map((e) =>
              e == null ? null : _LessonsFromJson(e))
          ?.toList(),
      shortName: json['shortName'] as String);
}

List<Lesson> _LessonsFromJson(List<Map<String, dynamic>> json){
  return json.map((j) => Lesson.fromJson(j)).toList();
}

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
      'lessons': instance.lessons?.map((m) => m?.map((l) => l.toJson())?.toList())?.toList(),
      'date': instance.date?.toIso8601String(),
      'shortName': instance.shortName
    };

Lesson _$LessonFromJson(Map<String, dynamic> json) {
  return Lesson(
      type: json['type'] as String,
      teacherLong: json['teacherLong'] as String,
      teacherShort: json['teacherShort'] as String,
      subjectShort: json['subjectShort'] as String,
      subjectLong: json['subjectLong'] as String,
      change: json['change'] as String,
      classGroupLong: json['classGroupLong'] as String,
      classGroupShort: json['classGroupShort'] as String,
      classroom: json['classroom'] as String,
      id: json['id'] as String,
      isSet: json['isSet'] as bool,
      lessonContent: json['lessonContent'] as String,
      lessonTime: json['lessonTime'] == null
          ? null
          : LessonTime.fromJson(json['lessonTime'] as Map<String, dynamic>));
}

Map<String, dynamic> _$LessonToJson(Lesson instance) => <String, dynamic>{
      'type': instance.type,
      'id': instance.id,
      'subjectLong': instance.subjectLong,
      'subjectShort': instance.subjectShort,
      'teacherLong': instance.teacherLong,
      'teacherShort': instance.teacherShort,
      'classroom': instance.classroom,
      'lessonContent': instance.lessonContent,
      'change': instance.change,
      'classGroupLong': instance.classGroupLong,
      'classGroupShort': instance.classGroupShort,
      'lessonTime': instance.lessonTime?.toJson(),
      'isSet': instance.isSet
    };

LessonTime _$LessonTimeFromJson(Map<String, dynamic> json) {
  return LessonTime(
      caption: json['caption'] as String,
      beginTime: json['beginTime'] as String,
      endTime: json['endTime'] as String);
}

Map<String, dynamic> _$LessonTimeToJson(LessonTime instance) =>
    <String, dynamic>{
      'caption': instance.caption,
      'beginTime': instance.beginTime,
      'endTime': instance.endTime
    };
