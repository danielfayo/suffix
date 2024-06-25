import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suffix/models/models/abandoned_game_info.dart';
import 'package:suffix/models/game_service/game_service_repository.dart';
import 'package:suffix/models/models/game_level.dart';
import 'package:suffix/utils/enums.dart';
import 'package:uuid/v4.dart';

class OfflineGameServiceImpl implements IgameService {
  static OfflineGameServiceImpl? _singleInstance;

  factory OfflineGameServiceImpl() {
    _singleInstance ??= OfflineGameServiceImpl._internal();
    return _singleInstance!;
  }

  OfflineGameServiceImpl._internal();

  late SharedPreferences _preferences;

  Map<WordLength, List<String>> fullWordList = {};
  GameLevel level = GameLevel.defaultLevel();
  WordLength currentWordLenght = WordLength.five;
  Map<WordLength, AbandonedGameInfo> leftOverGameInfo = {};
  String _userId = "";
  Set<String> oldWords = {};
  int _avaiableCoins = 0;

  set userId(String value) {
    _userId = value;
    _preferences.setString("user_id", value);
  }

  @override
  String? getCurrentWord() {
    return fullWordList[currentWordLenght]
            ?[level.gameInstanceLevel(currentWordLenght) - 1]
        .trim()
        .toUpperCase();
  }

  recordGame(AbandonedGameInfo info) {
    leftOverGameInfo[currentWordLenght] = info;
  }

  @override
  Future<void> initGame() async {
    _preferences = await SharedPreferences.getInstance();
    userId = _preferences.getString("user_id") ?? const UuidV4().generate();
    fullWordList = await generateWordList();
    String? gameData = _preferences.getString("game_data");
    if (gameData == null) {
      currentWordLenght = WordLength.five;
      _avaiableCoins = 50;
      return;
    }
    Map<String, dynamic> usableGameData = jsonDecode(gameData);
    // print(usableGameData);
    if (usableGameData["abandoned_game"] != null) {
      leftOverGameInfo =
          (usableGameData["abandoned_game"] as Map).map((key, value) {
        return MapEntry(
            (key as String).toWordLength(), AbandonedGameInfo.fromJson(value));
      });
    }

    level = GameLevel.fromJson(usableGameData["level"]);
    currentWordLenght = usableGameData["word_length"].toString().toWordLength();
    _avaiableCoins = usableGameData["available_coins"];
  }

  @override
  int getAvailableCoins() => _avaiableCoins;

  @override
  void deductCoins() {
    if (_avaiableCoins >= 5) {
      _avaiableCoins = _avaiableCoins - 5;
    }
  }

  @override
  void incrementCoins(int amount) {
    _avaiableCoins = _avaiableCoins + amount;
  }

  @override
  String? nextLevel() {
    leftOverGameInfo = {};
    level.nextLevel(currentWordLenght);
    return getCurrentWord();
  }

  @override
  String? getNewWord(String oldWord) {
    List<String> wordLengthWords = fullWordList[currentWordLenght]!;
    wordLengthWords.remove(oldWord.toLowerCase());
    fullWordList[currentWordLenght] = wordLengthWords;
    oldWords.add(oldWord);
    leftOverGameInfo = {};
    return getCurrentWord();
  }

  Future<Map<WordLength, List<String>>> generateWordList() async {
    List<String> alphaWord = await rootBundle
        .loadString("assets/word_list/words_alpha.txt")
        .then((value) {
      return value.split("\n");
    });
    List<String> word1 = await rootBundle
        .loadString("assets/word_list/word1.text")
        .then((value) {
      return value.split("\n");
    });

    List<String> word2 = await rootBundle
        .loadString("assets/word_list/word2.text")
        .then((value) {
      return value.split("\n");
    });

    Set<String> uniqueWords = {}..addAll([...word2, ...alphaWord, ...word1]);
    // uniqueWords.where((valye))
    return {
      WordLength.five: generateUniqueListForUser(
          uniqueWords.where((e) => e.toString().trim().length == 5).toList()),
      WordLength.seven: generateUniqueListForUser(
          uniqueWords.where((e) => e.toString().trim().length == 7).toList()),
      WordLength.six: generateUniqueListForUser(
          uniqueWords.where((e) => e.toString().trim().length == 6).toList()),
      WordLength.four: generateUniqueListForUser(
          uniqueWords.where((e) => e.toString().trim().length == 4).toList())
    };
  }

  List<String> generateUniqueListForUser(List<String> words) {
    List<String> multatedWords = words;

    for (int i = multatedWords.length - 1; i > 0; i--) {
      String tempWord = multatedWords[i];

      int j = Random(_userId.hashCode).nextInt(i + 1);

      multatedWords[i] = multatedWords[j];
      multatedWords[j] = tempWord;
    }
    return multatedWords;
  }

  @override
  Future<bool> saveGameState() async {
    Map<String, dynamic> tempAbandonedGame = leftOverGameInfo.map((key, value) {
      return MapEntry(key.name, value.toJson());
    });

    Map<String, dynamic> gameState = {
      "abandoned_game": tempAbandonedGame,
      "word_length": currentWordLenght.name,
      "level": level.toJson(),
      "oldWords": oldWords.toList(),
      "available_coins": _avaiableCoins,
    };
    return await _preferences.setString("game_data", jsonEncode(gameState));
  }

  @override
  int getWordLenght() => currentWordLenght.toInt();

  @override
  bool wordIsInWordList(String word) {
    bool existingWordList = false;
    fullWordList.forEach((key, value) {
      if ([
        ...value,
        ...oldWords
      ].any((element) => element.trim().toLowerCase() == word.toLowerCase())) {
        existingWordList = true;
        return;
      }
    });
    return existingWordList;
  }

  @override
  AbandonedGameInfo? getAbandondedGame() => leftOverGameInfo[currentWordLenght];

  @override
  int getCurrentLevel() {
    return level.gameInstanceLevel(currentWordLenght);
  }
}

extension on WordLength {
  int toInt() {
    switch (this) {
      case WordLength.five:
        return 5;
      case WordLength.four:
        return 4;
      case WordLength.six:
        return 6;
      case WordLength.seven:
        return 7;
    }
  }
}

extension ConvertToWordLength on num {
  WordLength toWordLength() {
    switch (this) {
      case 5:
        return WordLength.five;
      case 6:
        return WordLength.six;
      case 4:
        return WordLength.four;
      case 7:
        return WordLength.seven;
      default:
        return WordLength.five;
    }
  }
}

extension on String {
  WordLength toWordLength() {
    switch (this) {
      case "five":
        return WordLength.five;
      case "six":
        return WordLength.six;
      case "four":
        return WordLength.four;
      case "seven":
        return WordLength.seven;
      default:
        return WordLength.five;
    }
  }
}
