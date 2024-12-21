// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_progress.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BadgeProgressImpl _$$BadgeProgressImplFromJson(Map<String, dynamic> json) =>
    _$BadgeProgressImpl(
      currentLevel: $enumDecode(_$BadgeLevelEnumMap, json['currentLevel']),
      booksRead: (json['booksRead'] as num).toInt(),
      favoriteBooks: (json['favoriteBooks'] as num).toInt(),
      readingStreak: (json['readingStreak'] as num).toInt(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$BadgeProgressImplToJson(_$BadgeProgressImpl instance) =>
    <String, dynamic>{
      'currentLevel': _$BadgeLevelEnumMap[instance.currentLevel]!,
      'booksRead': instance.booksRead,
      'favoriteBooks': instance.favoriteBooks,
      'readingStreak': instance.readingStreak,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

const _$BadgeLevelEnumMap = {
  BadgeLevel.beginner: 'beginner',
  BadgeLevel.intermediate: 'intermediate',
  BadgeLevel.advanced: 'advanced',
  BadgeLevel.master: 'master',
};
