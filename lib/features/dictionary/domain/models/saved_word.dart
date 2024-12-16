import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'saved_word.freezed.dart';
part 'saved_word.g.dart';

DateTime _timestampToDateTime(Timestamp timestamp) => timestamp.toDate();
Timestamp _dateTimeToTimestamp(DateTime dateTime) => Timestamp.fromDate(dateTime);

@freezed
class SavedWord with _$SavedWord {
  const SavedWord._();

  const factory SavedWord({
    required String id,
    required String word,
    required String definition,
    String? phonetic,
    List<String>? examples,
    @JsonKey(fromJson: _timestampToDateTime, toJson: _dateTimeToTimestamp)
    required DateTime savedAt,
  }) = _SavedWord;

  factory SavedWord.fromJson(Map<String, dynamic> json) =>
      _$SavedWordFromJson(json);

  factory SavedWord.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SavedWord.fromJson({
      'id': doc.id,
      ...data,
    });
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    json.remove('id'); // Remove id as it's stored as document ID
    return json;
  }
}
