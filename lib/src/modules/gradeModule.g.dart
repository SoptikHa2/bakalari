// GENERATED CODE - DO NOT MODIFY BY HAND

part of bakalari.modules.grade;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Grade _$GradeFromJson(Map<String, dynamic> json) {
  return Grade(
      caption: json['caption'] as String,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      note: json['note'] as String,
      subject: json['subject'] as String,
      value: (json['value'] as num)?.toDouble(),
      weight: json['weight'] as int);
}

Map<String, dynamic> _$GradeToJson(Grade instance) => <String, dynamic>{
      'subject': instance.subject,
      'value': instance.value,
      'date': instance.date?.toIso8601String(),
      'caption': instance.caption,
      'note': instance.note,
      'weight': instance.weight
    };
