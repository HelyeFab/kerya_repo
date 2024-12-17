// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_word.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SavedWord _$SavedWordFromJson(Map<String, dynamic> json) {
  return _SavedWord.fromJson(json);
}

/// @nodoc
mixin _$SavedWord {
  String get id => throw _privateConstructorUsedError;
  String get word => throw _privateConstructorUsedError;
  String get definition => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  List<String>? get examples => throw _privateConstructorUsedError;
  @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
  DateTime get savedAt => throw _privateConstructorUsedError;

  /// Serializes this SavedWord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavedWord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedWordCopyWith<SavedWord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedWordCopyWith<$Res> {
  factory $SavedWordCopyWith(SavedWord value, $Res Function(SavedWord) then) =
      _$SavedWordCopyWithImpl<$Res, SavedWord>;
  @useResult
  $Res call(
      {String id,
      String word,
      String definition,
      String language,
      List<String>? examples,
      @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
      DateTime savedAt});
}

/// @nodoc
class _$SavedWordCopyWithImpl<$Res, $Val extends SavedWord>
    implements $SavedWordCopyWith<$Res> {
  _$SavedWordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedWord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? word = null,
    Object? definition = null,
    Object? language = null,
    Object? examples = freezed,
    Object? savedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      definition: null == definition
          ? _value.definition
          : definition // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      examples: freezed == examples
          ? _value.examples
          : examples // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      savedAt: null == savedAt
          ? _value.savedAt
          : savedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SavedWordImplCopyWith<$Res>
    implements $SavedWordCopyWith<$Res> {
  factory _$$SavedWordImplCopyWith(
          _$SavedWordImpl value, $Res Function(_$SavedWordImpl) then) =
      __$$SavedWordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String word,
      String definition,
      String language,
      List<String>? examples,
      @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
      DateTime savedAt});
}

/// @nodoc
class __$$SavedWordImplCopyWithImpl<$Res>
    extends _$SavedWordCopyWithImpl<$Res, _$SavedWordImpl>
    implements _$$SavedWordImplCopyWith<$Res> {
  __$$SavedWordImplCopyWithImpl(
      _$SavedWordImpl _value, $Res Function(_$SavedWordImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavedWord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? word = null,
    Object? definition = null,
    Object? language = null,
    Object? examples = freezed,
    Object? savedAt = null,
  }) {
    return _then(_$SavedWordImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      word: null == word
          ? _value.word
          : word // ignore: cast_nullable_to_non_nullable
              as String,
      definition: null == definition
          ? _value.definition
          : definition // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      examples: freezed == examples
          ? _value._examples
          : examples // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      savedAt: null == savedAt
          ? _value.savedAt
          : savedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SavedWordImpl extends _SavedWord {
  const _$SavedWordImpl(
      {required this.id,
      required this.word,
      required this.definition,
      required this.language,
      final List<String>? examples,
      @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
      required this.savedAt})
      : _examples = examples,
        super._();

  factory _$SavedWordImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedWordImplFromJson(json);

  @override
  final String id;
  @override
  final String word;
  @override
  final String definition;
  @override
  final String language;
  final List<String>? _examples;
  @override
  List<String>? get examples {
    final value = _examples;
    if (value == null) return null;
    if (_examples is EqualUnmodifiableListView) return _examples;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
  final DateTime savedAt;

  @override
  String toString() {
    return 'SavedWord(id: $id, word: $word, definition: $definition, language: $language, examples: $examples, savedAt: $savedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedWordImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.word, word) || other.word == word) &&
            (identical(other.definition, definition) ||
                other.definition == definition) &&
            (identical(other.language, language) ||
                other.language == language) &&
            const DeepCollectionEquality().equals(other._examples, _examples) &&
            (identical(other.savedAt, savedAt) || other.savedAt == savedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, word, definition, language,
      const DeepCollectionEquality().hash(_examples), savedAt);

  /// Create a copy of SavedWord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedWordImplCopyWith<_$SavedWordImpl> get copyWith =>
      __$$SavedWordImplCopyWithImpl<_$SavedWordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedWordImplToJson(
      this,
    );
  }
}

abstract class _SavedWord extends SavedWord {
  const factory _SavedWord(
      {required final String id,
      required final String word,
      required final String definition,
      required final String language,
      final List<String>? examples,
      @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
      required final DateTime savedAt}) = _$SavedWordImpl;
  const _SavedWord._() : super._();

  factory _SavedWord.fromJson(Map<String, dynamic> json) =
      _$SavedWordImpl.fromJson;

  @override
  String get id;
  @override
  String get word;
  @override
  String get definition;
  @override
  String get language;
  @override
  List<String>? get examples;
  @override
  @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
  DateTime get savedAt;

  /// Create a copy of SavedWord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedWordImplCopyWith<_$SavedWordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
