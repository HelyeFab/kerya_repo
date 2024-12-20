import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/books/domain/models/book_language.dart';

class LanguageState {
  final BookLanguage selectedLanguage;

  const LanguageState({
    required this.selectedLanguage,
  });

  LanguageState copyWith({
    BookLanguage? selectedLanguage,
  }) {
    return LanguageState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }
}

abstract class LanguageEvent {
  const LanguageEvent();
}

class LanguageChanged extends LanguageEvent {
  final BookLanguage language;

  const LanguageChanged(this.language);
}

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(const LanguageState(selectedLanguage: BookLanguage.english)) {
    on<LanguageChanged>((event, emit) {
      emit(state.copyWith(selectedLanguage: event.language));
    });
  }
}
