import 'package:flutter/material.dart';
import 'package:suffix/models/game_service/offline_game_service_impl.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/enums.dart';
import 'package:suffix/utils/text_styles.dart';
import 'package:suffix/views/game_screen.dart';
import 'package:suffix/widgets/button.dart';

void showLetterWordsModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      child: LetterWordsModal(),
    ),
  );
}

class LetterWordsModal extends StatefulWidget {
  const LetterWordsModal({super.key});

  @override
  State<LetterWordsModal> createState() => _LetterWordsModalState();
}

class _LetterWordsModalState extends State<LetterWordsModal> {
  int selectedNumber = 5;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kAccent,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: kDark, width: 1),
          boxShadow: const [
            BoxShadow(
              color: kDark,
              spreadRadius: 0,
              blurRadius: 0,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Letters in word",
              style: kHeading,
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: "4567"
                  .split("")
                  .map(
                    (e) => InkWell(
                      onTap: () {
                        selectedNumber = int.parse(e);
                        setState(() {});
                      },
                      child: Container(
                        width: 48,
                        height: 48,
                        margin: EdgeInsets.only(right: e != "7" ? 16 : 0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selectedNumber.toString() == e
                              ? kOrange
                              : kAccent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: kDark, width: 1),
                          boxShadow: const [
                            BoxShadow(
                              color: kDark,
                              spreadRadius: 0,
                              blurRadius: 0,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          e,
                          style: kHeadingLg,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(
              height: 32,
            ),
            SizedBox(
              height: 48,
              child: Button(
                buttonText: "Start",
                buttonType: ButtonType.secondary,
                buttonSize: ButtonSize.medium,
                onPressed: () {
                  OfflineGameServiceImpl().currentWordLenght =
                      selectedNumber.toWordLength();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GameScreen(),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
