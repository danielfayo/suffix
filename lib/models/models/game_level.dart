import 'package:suffix/utils/enums.dart';

class GameLevel {
  late int fourLetterWordLevel;
  late int fiveLetterWordLevel;
  late int sixLetterWordLevel;
  late int sevenLetterWordLevel;

  GameLevel(
      {required this.fiveLetterWordLevel,
      required this.fourLetterWordLevel,
      required this.sevenLetterWordLevel,
      required this.sixLetterWordLevel});

  GameLevel.fromJson(Map<String, dynamic> json) {
    fourLetterWordLevel = json["four_letter_word_level"];
    fiveLetterWordLevel = json["five_letter_word_level"];
    sixLetterWordLevel = json["six_letter_word_level"];
    sevenLetterWordLevel = json["seven_letter_word_level"];
  }

  factory GameLevel.defaultLevel() => GameLevel(
      fiveLetterWordLevel: 1,
      fourLetterWordLevel: 1,
      sevenLetterWordLevel: 1,
      sixLetterWordLevel: 1);

  Map<String, dynamic> toJson() => {
        "four_letter_word_level": fourLetterWordLevel,
        "five_letter_word_level": fiveLetterWordLevel,
        "six_letter_word_level": sixLetterWordLevel,
        "seven_letter_word_level": sevenLetterWordLevel
      };

  int gameInstanceLevel(WordLength wordLength) {
    switch (wordLength) {
      case WordLength.five:
        return fiveLetterWordLevel;
      case WordLength.four:
        return fourLetterWordLevel;
      case WordLength.six:
        return sixLetterWordLevel;
      case WordLength.seven:
        return sevenLetterWordLevel;
    }
  }
  int nextLevel(WordLength wordLength) {
    switch (wordLength) {
      case WordLength.five:
        return fiveLetterWordLevel += 1;
      case WordLength.four:
        return fourLetterWordLevel += 1;
      case WordLength.six:
        return sixLetterWordLevel += 1;
      case WordLength.seven:
        return sevenLetterWordLevel += 1;
    }
  }
}
