// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_word.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SavedWordImpl _$$SavedWordImplFromJson(Map<String, dynamic> json) =>
    _$SavedWordImpl(
      id: json['id'] as String,
      word: json['word'] as String,
      definition: json['definition'] as String,
      phonetic: json['phonetic'] as String?,
      examples: (json['examples'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      savedAt: _timestampToDateTime(json['savedAt'] as Timestamp),
    );

Map<String, dynamic> _$$SavedWordImplToJson(_$SavedWordImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'word': instance.word,
      'definition': instance.definition,
      'phonetic': instance.phonetic,
      'examples': instance.examples,
      'savedAt': _dateTimeToTimestamp(instance.savedAt),
    };
