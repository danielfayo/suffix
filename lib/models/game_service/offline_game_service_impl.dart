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

  late Map<WordLength, List<String>> fullWordList;
  late GameLevel level = GameLevel.defaultLevel();
  late WordLength currentWordLenght;
  AbandonedGameInfo? leftOverGameInfo;
  String _userId = "";

  set userId(String value) {
    _userId = value;
    _preferences.setString("user_id", value);
  }

  @override
  String? getCurrentWord() {
    return fullWordList[currentWordLenght]
            ?[level.gameInstanceLevel(currentWordLenght)]
        .trim()
        .toUpperCase();
  }

  @override
  void initGame() async {
    _preferences = await SharedPreferences.getInstance();
    userId = _preferences.getString("user_id") ?? const UuidV4().generate();
    fullWordList = await generateWordList();
    String? gameData = _preferences.getString("game_data");
    if (gameData == null) {
      currentWordLenght = WordLength.five;
      return;
    }
    Map<String, dynamic> usableGameData = jsonDecode(gameData);
    if (usableGameData["abandoned_game"] != null) {
      leftOverGameInfo =
          AbandonedGameInfo.fromJson(usableGameData["abandoned_game"]);
    }

    print("we here");
    level = GameLevel.fromJson(usableGameData["level"]);
    currentWordLenght = usableGameData["word_length"].toString().toWordLength();
  }

  @override
  String? getNextWord(bool passedPrevious) {
    // TODO: implement getNextWord
    throw UnimplementedError();
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
    ;
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
    Map<String, dynamic> gameState = {
      "abandoned_game": leftOverGameInfo?.toJson(),
      "word_length": currentWordLenght.name,
      "level": level.toJson()
    };
    return await _preferences.setString("game_data", jsonEncode(gameState));
  }

  @override
  int getWordLenght() => currentWordLenght.toInt();
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
