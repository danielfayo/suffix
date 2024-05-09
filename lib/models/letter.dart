class Letter {
  Letter({
    this.letter,
    this.letterIsPresent = false,
    this.isInRightPosition = false,
    this.letterIsNotPresent = false,
    required this.letterId,
  });

  final int letterId;
  String? letter;
  bool letterIsPresent;
  bool isInRightPosition;
  bool letterIsNotPresent;
}
