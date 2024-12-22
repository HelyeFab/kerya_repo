import 'package:hive_flutter/hive_flutter.dart';
import '../../domain/models/book.dart';

class BookCacheService {
  static const String _boxName = 'books';
  late Box<Book> _box;

  Future<void> init() async {
    _box = await Hive.openBox<Book>(_boxName);
  }

  Future<void> cacheBooks(List<Book> books) async {
    await _box.clear();
    await _box.putAll(
      Map.fromEntries(books.map((book) => MapEntry(book.id, book))),
    );
  }

  List<Book> getCachedBooks() {
    return _box.values.toList();
  }

  Future<void> updateBook(Book book) async {
    await _box.put(book.id, book);
  }

  Future<void> clear() async {
    await _box.clear();
  }

  bool get hasCache => _box.isNotEmpty;
}
