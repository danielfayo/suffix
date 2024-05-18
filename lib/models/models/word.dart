import 'package:suffix/models/models/letter.dart';

class Word {
  Word({required this.allLetters, required this.wordId});

  final int wordId;
  List<Letter> allLetters;

  factory Word.fromJson(Map<String, dynamic> json) => Word(
      allLetters:
          (json["letters"] as List).map((e) => Letter.fromJson(e)).toList(),
      wordId: json["word_id"]);


  Map<String,dynamic> toJson() =>{
    "letters": allLetters.map((e)=>e.toJson()).toList(),
    "word_id":wordId
  };


}
