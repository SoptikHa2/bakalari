// GENERATED CODE - DO NOT MODIFY BY HAND

part of bakalari.modules.privateMessages;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
