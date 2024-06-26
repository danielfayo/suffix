import 'package:suffix/models/models/abandoned_game_info.dart';

abstract class IgameService {
  // IgameService({required this.fullWordList});

  void initGame();
  String? getCurrentWord();
  String? nextLevel();
  String? getNewWord(String oldWord);
  Future<bool> saveGameState();
  int getWordLenght();
  bool wordIsInWordList(String word);
  AbandonedGameInfo? getAbandondedGame();
  int getCurrentLevel();
  int getAvailableCoins();
  void deductCoins();
  void incrementCoins(int amount);
}
