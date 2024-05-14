import 'package:flutter/foundation.dart';
import 'package:suffix/models/letter.dart';
import 'package:suffix/models/word.dart';

class GameplayViewModel extends ChangeNotifier {
  List<Word> words = [];
  int numberOfGuesses = 0;
  int _letterPosition = 0;
  int wordLength = 5;
  bool _wordIsComplete = false;
  bool wordIsCorrect = false;
  final String wordToGuess = "LASER";

// Populate the words array with words
  void getWords() {
    for (var i = 0; i < 6; i++) {
      List<Letter> newWord = [];
      for (var j = 0; j < wordLength; j++) {
        newWord.add(Letter(letterId: j));
      }
      words.add(Word(allLetters: newWord, wordId: i));
      notifyListeners();
    }
  }

// Handle typing of a key on the keyboard
  void handleTapLetter(String keyText) {
    if (_letterPosition < wordLength) {
      Letter letter = words
          .singleWhere((wrd) => wrd.wordId == numberOfGuesses)
          .allLetters
          .singleWhere((lttr) => lttr.letterId == _letterPosition);

      letter.letter = keyText;
      _letterPosition += 1;
      handleWordIsComplete();
      notifyListeners();
    }
  }

// Checks if the letters the user typed is up to 5
  void handleWordIsComplete() {
    if (numberOfGuesses < 6) {
      Word word =
          words.singleWhere((eachWord) => eachWord.wordId == numberOfGuesses);
      List<Letter> filledLetters =
          word.allLetters.where((lttr) => lttr.letter == null).toList();
      if (filledLetters.isEmpty) {
        _wordIsComplete = true;
        notifyListeners();
      }
    }
  }

// Checks if the word the user entered matches the word to be guessed
  void handleWordIsCorrect() {
    if (numberOfGuesses < 6) {
      List<String> lettersArr = [];
      Word wordToCheck =
          words.singleWhere((eachWord) => eachWord.wordId == numberOfGuesses);
      for (var eachLetter in wordToCheck.allLetters) {
        if (eachLetter.letter != null) {
          lettersArr.add(eachLetter.letter!);
        }
      }
      String letters = lettersArr.join("").toUpperCase();
      if (letters == wordToGuess) {
        wordIsCorrect = true;
      }
    }
    notifyListeners();
  }

// Lets a user guess the word again if they didn't get it in the previous trial
  void newGuess() {
    if (_wordIsComplete) {
      Word guessedWord =
          words.singleWhere((wrd) => wrd.wordId == numberOfGuesses);

      for (var i = 0; i < guessedWord.allLetters.length; i++) {
        Letter guessWordLetter = guessedWord.allLetters[i];
        for (var j = 0; j < wordToGuess.length; j++) {
          String eachLetter = wordToGuess[j];
          if (guessWordLetter.letter == eachLetter &&
              guessWordLetter.letterId == j) {
            guessWordLetter.isInRightPosition = true;
          } else if (guessWordLetter.letter == eachLetter) {
            guessWordLetter.letterIsPresent = true;
          } else {
            guessWordLetter.letterIsNotPresent = true;
          }
        }
      }
      handleWordIsCorrect();

      numberOfGuesses += 1;
      _letterPosition = 0;
      _wordIsComplete = false;
      handleWordIsComplete();
      notifyListeners();
    }
  }

// Backspace a letter the user typed
  void backSpace() {
    if (_letterPosition > 0) {
      Letter letter = words
          .singleWhere((wrd) => wrd.wordId == numberOfGuesses)
          .allLetters
          .singleWhere((lttr) => lttr.letterId == _letterPosition - 1);

      letter.letter = null;
      _letterPosition -= 1;
      handleWordIsComplete();
      notifyListeners();
    }
  }

// Restarts the entire game
  void handleRestartGame() {
    List<Word> emptyWords = [];
    for (var i = 0; i < 6; i++) {
      List<Letter> newWord = [];
      for (var j = 0; j < wordLength; j++) {
        newWord.add(Letter(letterId: j));
      }
      emptyWords.add(Word(allLetters: newWord, wordId: i));
    }
    words = emptyWords;
    numberOfGuesses = 0;
    notifyListeners();
  }

// Empties the word array
  void emptyAllWords() {
    words = [];
  }
}
