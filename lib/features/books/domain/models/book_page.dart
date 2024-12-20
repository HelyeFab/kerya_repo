import 'package:equatable/equatable.dart';
import 'package:Keyra/features/books/domain/models/book_language.dart';

class BookPage extends Equatable {
  final Map<BookLanguage, String> text;
  final Map<BookLanguage, String> audioPath;
  final String? imagePath;

  const BookPage({
    required this.text,
    required this.audioPath,
    this.imagePath,
  });

  String getText(BookLanguage language) {
    return text[language] ?? '';
  }

  String? getAudioPath(BookLanguage language) {
    return audioPath[language];
  }

  BookPage copyWith({
    Map<BookLanguage, String>? text,
    Map<BookLanguage, String>? audioPath,
    String? imagePath,
  }) {
    return BookPage(
      text: text ?? this.text,
      audioPath: audioPath ?? this.audioPath,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text.map((key, value) => MapEntry(key.code, value)),
      'audioPath': audioPath.map((key, value) => MapEntry(key.code, value)),
      'imagePath': imagePath,
    };
  }

  factory BookPage.fromJson(Map<String, dynamic> json) {
    return BookPage(
      text: (json['text'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(BookLanguage.fromCode(key), value as String),
      ),
      audioPath: (json['audioPath'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(BookLanguage.fromCode(key), value as String),
      ),
      imagePath: json['imagePath'] as String?,
    );
  }

  @override
  List<Object?> get props => [text, audioPath, imagePath];
}
