abstract class IgameService {
  // IgameService({required this.fullWordList});

  void initGame();
  String? getCurrentWord();
  String? getNextWord(bool passedPrevious);
  Future<bool> saveGameState();
  int getWordLenght();
}
