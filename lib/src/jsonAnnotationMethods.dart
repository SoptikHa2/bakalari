part of bakalari.definitions;

Grade _$GradeFromJson(Map<String, dynamic> json) {
  return Grade(
      caption: json['caption'] as String,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      note: json['note'] as String,
      subject: json['subject'] as String,
      numericValue: (json['numericValue'] as num)?.toDouble(),
      value: json['value'] as String,
      weight: json['weight'] as int);
}

Map<String, dynamic> _$GradeToJson(Grade instance) => <String, dynamic>{
      'subject': instance.subject,
      'value': instance.value,
      'numericValue': instance.numericValue,
      'date': instance.date?.toIso8601String(),
      'caption': instance.caption,
      'note': instance.note,
      'weight': instance.weight
    };

Homework _$HomeworkFromJson(Map<String, dynamic> json) {
  return Homework(
      subjectLong: json['subjectLong'] as String,
      id: json['id'] as String,
      subjectShort: json['subjectShort'] as String,
      from:
          json['from'] == null ? null : DateTime.parse(json['from'] as String),
      status: json['status'] as String,
      title: json['title'] as String,
      to: json['to'] == null ? null : DateTime.parse(json['to'] as String));
}

Map<String, dynamic> _$HomeworkToJson(Homework instance) => <String, dynamic>{
      'subjectLong': instance.subjectLong,
      'subjectShort': instance.subjectShort,
      'from': instance.from?.toIso8601String(),
      'to': instance.to?.toIso8601String(),
      'id': instance.id,
      'status': instance.status,
      'title': instance.title
    };

PrivateMessage _$PrivateMessageFromJson(Map<String, dynamic> json) {
  return PrivateMessage(
      id: json['id'] as String,
      content: json['content'] as String,
      title: json['title'] as String,
      senderName: json['senderName'] as String,
      type: json['type'] as String,
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String));
}

Map<String, dynamic> _$PrivateMessageToJson(PrivateMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'title': instance.title,
      'senderName': instance.senderName,
      'dateTime': instance.dateTime?.toIso8601String(),
      'type': instance.type
    };

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
          ?.map((e) => e == null ? null : _LessonsFromJson(e))
          ?.toList(),
      shortName: json['shortName'] as String);
}

List<Lesson> _LessonsFromJson(List<dynamic> json) {
  return json.map((j) => Lesson.fromJson(j)).toList();
}

Map<String, dynamic> _$DayToJson(Day instance) => <String, dynamic>{
      'lessons': instance.lessons
          ?.map((m) => m?.map((l) => l.toJson())?.toList())
          ?.toList(),
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

School _$SchoolFromJson(Map<String, dynamic> json) {
  return School(
      bakawebLink: json['bakawebLink'] as String,
      name: json['name'] as String,
      bakawebVersion: json['bakawebVersion'] as String,
      allowedModules:
          (json['allowedModules'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$SchoolToJson(School instance) => <String, dynamic>{
      'bakawebLink': instance.bakawebLink?.toString(),
      'name': instance.name,
      'bakawebVersion': instance.bakawebVersion,
      'allowedModules': instance.allowedModules
    };

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
