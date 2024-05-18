import 'package:suffix/models/models/word.dart';

class AbandonedGameInfo {
  final List<Word> words;
  final int numberOfGuesses;
  final int letterPosition;

  const AbandonedGameInfo(
      {required this.words,
      required this.numberOfGuesses,
      required this.letterPosition});

  factory AbandonedGameInfo.fromJson(Map<String, dynamic> json) =>
      AbandonedGameInfo(
          words: (json["words"] as List).map((e) => Word.fromJson(e)).toList(),
          numberOfGuesses: json["number_of_guesses"],
          letterPosition: json["letter_position"]);

  Map<String, dynamic> toJson() => {
    "words": words.map((e)=>e.toJson()).toList(),
    "number_of_guesses":numberOfGuesses,
    "letter_position":letterPosition
  };
}
