// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge_requirements.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BadgeRequirementsImpl _$$BadgeRequirementsImplFromJson(
        Map<String, dynamic> json) =>
    _$BadgeRequirementsImpl(
      level: $enumDecode(_$BadgeLevelEnumMap, json['level']),
      requiredBooksRead: (json['requiredBooksRead'] as num).toInt(),
      requiredFavoriteBooks: (json['requiredFavoriteBooks'] as num).toInt(),
      requiredReadingStreak: (json['requiredReadingStreak'] as num).toInt(),
    );

Map<String, dynamic> _$$BadgeRequirementsImplToJson(
        _$BadgeRequirementsImpl instance) =>
    <String, dynamic>{
      'level': _$BadgeLevelEnumMap[instance.level]!,
      'requiredBooksRead': instance.requiredBooksRead,
      'requiredFavoriteBooks': instance.requiredFavoriteBooks,
      'requiredReadingStreak': instance.requiredReadingStreak,
    };

const _$BadgeLevelEnumMap = {
  BadgeLevel.beginner: 'beginner',
  BadgeLevel.intermediate: 'intermediate',
  BadgeLevel.advanced: 'advanced',
  BadgeLevel.master: 'master',
};
