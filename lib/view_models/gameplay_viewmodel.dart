import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:suffix/models/game_service/game_service_repository.dart';
import 'package:suffix/models/game_service/offline_game_service_impl.dart';
import 'package:suffix/models/models/abandoned_game_info.dart';
import 'package:suffix/models/models/letter.dart';
import 'package:suffix/models/models/word.dart';

class GameplayViewModel extends ChangeNotifier {
  List<Word> words = [];
  int numberOfGuesses = 0;
  int letterPosition = 0;
  int wordLength = 5;
  bool _wordIsComplete = false;
  bool wordIsCorrect = false;
  String wordToGuess = "LASER";
  int currentLevel = 1;
  bool guessedWordIsValid = false;
  Map<String, String> keyColor = {
    for (var letter in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('')) letter: "kAccent"
  };
  bool noMoreHint = false;

  final IgameService gameService = OfflineGameServiceImpl();

  int getAvailableCoinsAmount() {
    return gameService.getAvailableCoins();
  }

// Populate the words array with words
  void getWords() {
    defaultGame();
    wordToGuess = gameService.getCurrentWord() ?? "LASER";
    wordLength = gameService.getWordLenght();
    currentLevel = gameService.getCurrentLevel();
    if (gameService.getAbandondedGame() != null) {
      AbandonedGameInfo gameInfo = gameService.getAbandondedGame()!;
      words = gameInfo.words;
      numberOfGuesses = gameInfo.numberOfGuesses;
      letterPosition = gameInfo.letterPosition;
      keyColor = gameInfo.keyColor;
      notifyListeners();
      return;
    }

    for (var i = 0; i < 6; i++) {
      List<Letter> newWord = [];
      for (var j = 0; j < wordLength; j++) {
        newWord.add(Letter(letterId: j));
      }

      words.add(Word(allLetters: newWord, wordId: i));
      notifyListeners();
    }
  }

  defaultGame() {
    words = [];
    numberOfGuesses = 0;
    letterPosition = 0;
    keyColor = {
      for (var letter in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split(''))
        letter: "kAccent"
    };
    // noMoreHint = false;
    // _wordIsComplete = false;
    // wordIsCorrect = false;
    // numberOfGuesses = 0;
    // letterPosition = 0;
  }

  void recordGame() {
    (gameService as OfflineGameServiceImpl).recordGame(AbandonedGameInfo(
      words: words,
      numberOfGuesses: numberOfGuesses,
      letterPosition: letterPosition,
      keyColor: keyColor,
    ));
  }

// Handle typing of a key on the keyboard
  void handleTapLetter(String keyText) {
    if (letterPosition < wordLength) {
      Letter letter = words
          .singleWhere((wrd) => wrd.wordId == numberOfGuesses)
          .allLetters
          .singleWhere((lttr) => lttr.letterId == letterPosition);

      letter.letter = keyText;
      if (letterPosition < wordToGuess.length - 1) {
        letterPosition += 1;
      }
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
        gameService.incrementCoins(wordLength);
      }
    }
    // print(wordToGuess);
    notifyListeners();
  }

  void handleGuessedWordIsValid() {
    if (_wordIsComplete) {
      List<String> guessedWordArr = [];
      for (var letter in words
          .singleWhere((wrd) => wrd.wordId == numberOfGuesses)
          .allLetters) {
        guessedWordArr.add(letter.letter!);
      }
      String guessedWord = guessedWordArr.join("");

      guessedWordIsValid = gameService.wordIsInWordList(guessedWord);
    }
    notifyListeners();
  }

// Lets a user guess the word again if they didn't get it in the previous trial
  void newGuess() {
    if (_wordIsComplete && guessedWordIsValid) {
      Word guessedWord =
          words.singleWhere((wrd) => wrd.wordId == numberOfGuesses);

      List<bool> usedLetters =
          List<bool>.filled(guessedWord.allLetters.length, false);

      for (var i = 0; i < guessedWord.allLetters.length; i++) {
        Letter guessWordLetter = guessedWord.allLetters[i];
        if (guessWordLetter.letter == wordToGuess[i]) {
          guessWordLetter.isInRightPosition = true;
          usedLetters[i] = true;
          keyColor[guessWordLetter.letter!] = "kGreen";
        }
      }

      for (var i = 0; i < guessedWord.allLetters.length; i++) {
        Letter guessWordLetter = guessedWord.allLetters[i];
        if (!guessWordLetter.isInRightPosition) {
          for (var j = 0; j < wordToGuess.length; j++) {
            if (!usedLetters[j] && guessWordLetter.letter == wordToGuess[j]) {
              guessWordLetter.letterIsPresent = true;
              usedLetters[j] = true;
              if (keyColor[guessWordLetter.letter!] != "kGreen") {
                keyColor[guessWordLetter.letter!] = "kYellow";
              }
              break;
            }
          }
          if (!guessWordLetter.letterIsPresent) {
            guessWordLetter.letterIsNotPresent = true;
            if (keyColor[guessWordLetter.letter!] != "kGreen" &&
                keyColor[guessWordLetter.letter!] != "kYellow") {
              keyColor[guessWordLetter.letter!] = "kLight";
            }
          }
        }
      }

      handleWordIsCorrect();
      numberOfGuesses += 1;
      letterPosition = 0;
      _wordIsComplete = false;
      handleWordIsComplete();
      notifyListeners();
    }
  }

// Backspace a letter the user typed
  void backSpace() {
    Word activeWord = words.singleWhere((wrd) => wrd.wordId == numberOfGuesses);
    bool activeLetterIsEmpty =
        activeWord.allLetters[letterPosition].letter == null;
    Letter selectedLetter = activeLetterIsEmpty
        ? letterPosition > 0
            ? activeWord.allLetters[letterPosition - 1]
            : activeWord.allLetters[letterPosition]
        : activeWord.allLetters[letterPosition];

    selectedLetter.letter = null;
    (activeWord.allLetters[letterPosition].letter == null && letterPosition > 0)
        ? activeLetterIsEmpty
            ? letterPosition -= 1
            : letterPosition
        : null;
    handleWordIsComplete();
    notifyListeners();
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
    keyColor = {
      for (var letter in 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split(''))
        letter: "kAccent"
    };
    numberOfGuesses = 0;
    letterPosition = 0;
    wordIsCorrect = false;
    _wordIsComplete = false;
    notifyListeners();
  }

  void getLevelNewWord(String oldWord) {
    wordToGuess = gameService.getNewWord(oldWord)!;
    handleRestartGame();
  }

// Empties the word array
  void emptyAllWords() {
    words = [];
  }

// Provides a letter hint for the user
  void getHint() {
    List<String> knownLetters = keyColor.keys
        .where((eachColor) => (keyColor[eachColor] == "kYellow" ||
            keyColor[eachColor] == "kGreen"))
        .toList();

    List<String> unknownLetters = wordToGuess
        .split("")
        .where(
          (element) => !knownLetters.contains(element),
        )
        .toList();
    if (unknownLetters.isEmpty) {
      noMoreHint = true;
    }
    if (unknownLetters.isNotEmpty) {
      String randomLetter =
          unknownLetters[Random().nextInt(unknownLetters.length)];
      keyColor[randomLetter] = "kYellow";
      gameService.deductCoins();
    }

    // for (var i = 0; i < wordToGuess.length; i++) {
    //   if (i == letterPosition) {
    //     // handleTapLetter(wordToGuess[letterPosition]);
    //     if (keyColor[wordToGuess[letterPosition]] != "KGreen") {
    //       keyColor[wordToGuess[letterPosition]] = "kYellow";
    //     }
    //   }
    // }
    notifyListeners();
  }

// Handles making a box active
  void handleActiveBox(int letterId, int wordId) {
    if (numberOfGuesses == wordId) {
      letterPosition = letterId;
    }
    notifyListeners();
  }

  void handleGoToNextLevel() {
    wordToGuess = gameService.nextLevel()!;
    print(wordToGuess);
    gameService.saveGameState();
    currentLevel = gameService.getCurrentLevel();
  }
}
