import 'package:flutter/material.dart';

class KanjiWord {
  final String kanji;
  final String? furigana;
  final String? meaning;
  final bool hasKanji;
  final VoidCallback? onTap;

  const KanjiWord({
    required this.kanji,
    this.furigana,
    this.meaning,
    this.hasKanji = false,
    this.onTap,
  });
}

class FuriganaText extends StatelessWidget {
  final List<KanjiWord> words;
  final TextStyle? textStyle;
  final TextStyle? furiganaStyle;
  final double furiganaScale;
  final double spacing;

  const FuriganaText({
    super.key,
    required this.words,
    this.textStyle,
    this.furiganaStyle,
    this.furiganaScale = 0.5,
    this.spacing = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: words.map((word) {
          final baseStyle = textStyle ?? Theme.of(context).textTheme.bodyMedium!;
          final furiStyle = (furiganaStyle ?? baseStyle.copyWith(
            fontSize: baseStyle.fontSize! * furiganaScale,
            height: 1.0,
            color: Colors.grey[600],
          ));

          // If punctuation, render simple text
          if (RegExp(r'[。、！？「」『』（）]').hasMatch(word.kanji)) {
            return TextSpan(
              text: word.kanji,
              style: baseStyle,
            );
          }

          // If no furigana or not kanji, render simple text
          if (!word.hasKanji || word.furigana == null) {
            return TextSpan(
              text: word.kanji,
              style: baseStyle,
            );
          }

          return WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: word.onTap,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Base kanji text
                  Text(
                    word.kanji,
                    style: baseStyle,
                  ),
                  // Furigana text positioned above
                  Positioned(
                    top: -furiStyle.fontSize! * 1.2,
                    child: Text(
                      word.furigana!,
                      style: furiStyle,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class FuriganaRichText extends StatelessWidget {
  final List<KanjiWord> words;
  final TextStyle? textStyle;
  final TextStyle? furiganaStyle;
  final double furiganaScale;
  final double spacing;
  final TextAlign textAlign;
  final bool selectable;

  const FuriganaRichText({
    super.key,
    required this.words,
    this.textStyle,
    this.furiganaStyle,
    this.furiganaScale = 0.5,
    this.spacing = 2.0,
    this.textAlign = TextAlign.left,
    this.selectable = false,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = textStyle ?? Theme.of(context).textTheme.bodyMedium!;
    final furiStyle = (furiganaStyle ?? baseStyle.copyWith(
      fontSize: baseStyle.fontSize! * furiganaScale,
      height: 1.0,
      color: Colors.grey[600],
    ));

    final textSpans = <InlineSpan>[];

    for (var i = 0; i < words.length; i++) {
      final word = words[i];
      
      // If punctuation, render as plain text
      if (RegExp(r'[。、！？「」『』（）]').hasMatch(word.kanji)) {
        textSpans.add(TextSpan(
          text: word.kanji,
          style: baseStyle,
        ));
        continue;
      }

      // If no furigana or not kanji, render as plain text
      if (!word.hasKanji || word.furigana == null) {
        textSpans.add(TextSpan(
          text: word.kanji,
          style: baseStyle,
        ));
        continue;
      }

      textSpans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            onTap: word.onTap,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Base kanji text
                Text(
                  word.kanji,
                  style: baseStyle,
                ),
                // Furigana text positioned above
                Positioned(
                  top: -furiStyle.fontSize! * 1.2,
                  child: Text(
                    word.furigana!,
                    style: furiStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Add spacing between words
      if (i < words.length - 1) {
        textSpans.add(TextSpan(text: ' ' * spacing.toInt()));
      }
    }

    final richText = RichText(
      text: TextSpan(children: textSpans),
      textAlign: textAlign,
    );

    return selectable
        ? SelectableText.rich(
            TextSpan(children: textSpans),
            textAlign: textAlign,
          )
        : richText;
  }
}
