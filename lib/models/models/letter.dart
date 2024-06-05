class Letter {
  Letter({
    this.letter,
    this.letterIsPresent = false,
    this.isInRightPosition = false,
    this.letterIsNotPresent = false,
    required this.letterId,
  });

  late int letterId;
  late String? letter;
  late bool letterIsPresent;
  late bool isInRightPosition;
  late bool letterIsNotPresent;

  Letter.fromJson(Map<String, dynamic> json) {
    letter = json["letter"];
    letterId = json["letter_id"];
    letterIsNotPresent = json["letter_not_present"];
    letterIsPresent = json["letter_is_present"];
    isInRightPosition = json["letter_in_right_position"];
  }

  Map<String, dynamic> toJson() => {
    "letter":letter,
    "letter_id":letterId,
    "letter_not_present":letterIsNotPresent,
    "letter_is_present":letterIsPresent,
    "letter_in_right_position":isInRightPosition
  };

  // @override
  // bool operator ==(covariant other) => other is Letter && letterId ==other.letterId;
  
  // @override
  // int get hashCode => letterId.hashCode;
  

}
