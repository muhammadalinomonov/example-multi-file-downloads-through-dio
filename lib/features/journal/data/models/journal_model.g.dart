// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'journal_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JournalModel _$JournalModelFromJson(Map<String, dynamic> json) => JournalModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      fileUrl: json['file_url'] as String? ?? '',
    );

Map<String, dynamic> _$JournalModelToJson(JournalModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'file_url': instance.fileUrl,
    };
