import 'package:suffix/models/letter.dart';

class Word {
  Word({required this.allLetters, required this.wordId});
  
  final int wordId;
  List<Letter> allLetters;
}