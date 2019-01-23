/// This library contains class definitions for `bakalari` library.
/// You need this to be able to use classes used by `bakalari` library
/// whitout too much hassle. Just import it and let autocomplete do it's magic.
library bakalari.definitions;

import 'package:bakalari/src/helpers.dart';
import 'package:bakalari/src/modules/timetableModule.dart';
import 'package:json_annotation/json_annotation.dart';
part 'src/jsonAnnotationMethods.dart';


/* MODULES */

@JsonSerializable()
/// Grade response definition
class Grade {
  /// Short subject name (`M`, not `Math`)
  String subject;

  /// Value of the grade (usually 0-5). Please note that there might be other values here as well - for example
  /// `X`, or `1!`. In case here's just a number, you can find it in number format in `numericValue` field.
  String value;

  /// Value of the grade. Be careful, this will be null if the value of the grade as received from the server
  /// (see `value`) is not numeric - for example `X` or `1!`.
  double numericValue;

  /// Date when the grade was written
  DateTime date;

  /// Why did user get this grade
  String caption;

  /// Note from teacher
  String note;

  /// Weight of the grade
  int weight;

  Grade({this.caption, this.date, this.note, this.subject, this.value, this.numericValue, this.weight});

  /// Create new grade.
  ///
  /// Bakaweb date format is in format `yyMMddHHmm`.
  Grade.fromBakawebDate(this.subject, this.value, this.numericValue, String bakawebDateFormat, this.caption,
      this.note, this.weight) {
    this.date = Helpers.bakawebDateTimeToDateTime(bakawebDateFormat);
  }

  factory Grade.fromJson(Map<String, dynamic> json) =>
      _$GradeFromJson(json);
  Map<String, dynamic> toJson() => _$GradeToJson(this);

  @override
  String toString() {
    return "Grade: $value with weight $weight from $subject, received at $date with title $caption and note $note.";
  }
}

@JsonSerializable()
/// Homework response definition
class Homework {
  /// Long subject name (`Math`)
  String subjectLong;

  /// Short subject name (`M`)
  String subjectShort;

  DateTime from;
  DateTime to;

  String id;

  String status;

  String title;

  Homework(
      {this.subjectLong,
      this.id,
      this.subjectShort,
      this.from,
      this.status,
      this.title,
      this.to});

  factory Homework.fromJson(Map<String, dynamic> json) =>
      _$HomeworkFromJson(json);
  Map<String, dynamic> toJson() => _$HomeworkToJson(this);

  @override
  String toString() {
    return '{$status} [$subjectShort] ($to) - $title';
  }
}

/// Private message sent to user.
///
/// **WARNING:** Potential XSS vulnerability.
/// Content of the message is *unescaped* HTML.
/// Always be careful about whatever you do
/// with this.
@JsonSerializable()
class PrivateMessage {
  /// Id of the private message
  String id;

  /// # Potential vulnerability
  ///
  /// Content of private message.
  ///
  /// WARNING: UNESCAPED HTML
  ///
  /// WARNING: POTENTIAL XSS VULNERABILITY
  ///
  /// **ALWAYS** be careful about whatever you do
  /// with this.
  String content;

  /// Title of the message. It's empty most of the time,
  /// if not always. Do not rely on this.
  String title;

  /// Name of sender
  String senderName;

  /// DateTime sent
  DateTime dateTime;

  /// Type of message
  String type;

  PrivateMessage(
      {this.id,
      this.content,
      this.title,
      this.senderName,
      this.type,
      this.dateTime});

  PrivateMessage.fromBakawebDateTime(this.id, this.content, this.title,
      this.senderName, this.type, String dateTime) {
    this.dateTime = Helpers.bakawebDateTimeToDateTime(dateTime);
  }

  factory PrivateMessage.fromJson(Map<String, dynamic> json) =>
      _$PrivateMessageFromJson(json);
  Map<String, dynamic> toJson() => _$PrivateMessageToJson(this);

  @override
  String toString() {
    return 'Received a message from $senderName at $dateTime, here\'s the content: $content';
  }
}


@JsonSerializable()
class Subject {
  /// Long subject name (`Math`)
  String subjectLong;

  /// Short subject name (`M`)
  String subjectShort;

  String subjectId;

  String teacherName;

  /// Short teacher identifier (typically three letters of teacher's surname)
  String teacherShort;

  String teacherEmail;

  /// In-school teacher phone number
  String teacherPhone;

  Subject(
      {this.subjectId,
      this.subjectLong,
      this.subjectShort,
      this.teacherEmail,
      this.teacherName,
      this.teacherPhone,
      this.teacherShort});

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectToJson(this);

  @override
  String toString() {
    return '[$subjectShort:$teacherShort] - $teacherName ($teacherEmail)';
  }
}

enum TimetableSource { Today, Permanent, ByDate }

/// This is timetable returned from school system.
@JsonSerializable()
class Timetable {
  /// Days in timetable (should be around 5), each
  /// has list of lessons
  List<Day> days;

  /// This lists the lesson times, so one can
  /// easily build table
  List<LessonTime> times;

  /// ID of current (week) cycle
  /// (timetable might differ in different cycles)
  String currentCycleID;

  /// Name of current (week) cycle
  String currentCycleCaption;

  Timetable(
      {this.currentCycleCaption, this.currentCycleID, this.days, this.times});

  factory Timetable.fromJson(Map<String, dynamic> json) =>
      _$TimetableFromJson(json);
  Map<String, dynamic> toJson() => _$TimetableToJson(this);
}

/// This is one day in timetable that encapsulates individual lessons
@JsonSerializable()
class Day {
  /// This contains list of lessons. Most of the time,
  /// the inner list consists of only one lesson. But for example in most
  /// permanent timetables, more differenet lessons can occur at the same
  /// time. In which case, the inner list will contain more lessons.
  List<List<Lesson>> lessons;
  DateTime date;
  String shortName;

  Day({this.date, this.lessons, this.shortName});

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);
  Map<String, dynamic> toJson() => _$DayToJson(this);
}

/// This is lesson - teacher, time, etc
///
/// Following fields are declared always:
/// - `String type`
///
/// All other fields can be null, especially
/// if there is empty hour in the timetable.
///
/// Check out artifical `isSet` field to know
/// if the lesson is in the timetable.
@JsonSerializable()
class Lesson {
  /// Type of lesson, one letter code
  String type;

  /// Id of lesson
  String id;

  /// Long name of subject - for example Math
  String subjectLong;

  /// Short name of subject - for example M
  String subjectShort;

  /// Full name and title of teacher
  String teacherLong;

  /// Shortened name of teacher (usually three letters of his surname)
  String teacherShort;

  /// ID of classsroom where the lesson takes place
  String classroom;

  /// What was (will be) done in the lesson
  String lessonContent;

  /// Described change (if any) (for example when moved from classroom 204 to 203)
  String change;

  /// Group of class (if class divides to groups for particular subject)
  String classGroupLong;

  /// The same as `classGroupLong`, but shortcode fro it (usually three letters)
  String classGroupShort;

  LessonTime lessonTime;

  /// This determines if most of the fields here are set. If this is false,
  /// probably there is no lesson sheduled and it makes no sence to try to get
  /// additional info about this lesson.
  bool isSet;

  Lesson(
      {this.type,
      this.teacherLong,
      this.teacherShort,
      this.subjectShort,
      this.subjectLong,
      this.change,
      this.classGroupLong,
      this.classGroupShort,
      this.classroom,
      this.id,
      this.isSet,
      this.lessonContent,
      this.lessonTime});

  factory Lesson.fromJson(Map<String, dynamic> json) => _$LessonFromJson(json);
  Map<String, dynamic> toJson() => _$LessonToJson(this);
}

/// This is time when lesson occurs.
@JsonSerializable()
class LessonTime {
  String caption;
  String beginTime;
  String endTime;

  LessonTime({this.caption, this.beginTime, this.endTime});

  factory LessonTime.fromJson(Map<String, dynamic> json) =>
      _$LessonTimeFromJson(json);
  Map<String, dynamic> toJson() => _$LessonTimeToJson(this);
}








/* OTHER */

/// This error is thrown whenever library receives bad response from server,
/// be it wrong status code or response format.
class BadResponseError extends Error {
  /// Decription of error
  String errorMessage;

  /// Error trace
  StackTrace trace;

  /// Error constructor. Specify errorMessage as error description and trace (as `StackTrace.current`).
  BadResponseError(this.errorMessage, this.trace);

  /// Override toString() and return error message, newline, and trace.
  @override
  String toString() => errorMessage + " at\n" + trace.toString();
}
