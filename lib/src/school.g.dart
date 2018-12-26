// GENERATED CODE - DO NOT MODIFY BY HAND

part of bakalari.core.school;

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

School _$SchoolFromJson(Map<String, dynamic> json) {
  return School(
      bakawebLink: json['bakawebLink'] == null
          ? null
          : Uri.parse(json['bakawebLink'] as String),
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
