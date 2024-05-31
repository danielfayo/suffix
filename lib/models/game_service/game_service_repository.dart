import 'package:suffix/models/models/abandoned_game_info.dart';

abstract class IgameService {
  // IgameService({required this.fullWordList});

  void initGame();
  String? getCurrentWord();
  String? nextLevel();
  Future<bool> saveGameState();
  int getWordLenght();
  bool wordIsInWordList(String word);
  AbandonedGameInfo? getAbandondedGame();
  int getCurrentLevel();
}
