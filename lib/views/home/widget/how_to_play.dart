import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/enums.dart';
import 'package:suffix/utils/text_styles.dart';
import 'package:suffix/widgets/button.dart';
import 'package:suffix/widgets/guess_block.dart';

const String _titleText = "How to play";
const String _hTp1 =
    "You have to guess a five-letter word within six attempts.";
const String _hTp2 = "After each guess, you receive feedback on your guess:";
const String _hTp3 =
    "Green letters indicate that a letter is in the correct position.";
const String _hTp4 =
    "A Yellow letters indicate that a letter is in the word but in the wrong position.";
const String _hTp5 = "White letters indicate that a letter is not in the word.";

void showHowToPlay(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: HowToPlayDialog(),
    ),
  );
}

class HowToPlayDialog extends StatelessWidget {
  const HowToPlayDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: kAccent,
          borderRadius: BorderRadius.circular(32),
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Opacity(opacity: 0, child: Icon(Icons.close)),
                const Text(
                  _titleText,
                  style: kHeading,
                ),
                InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: kDark,
                    )),
              ],
            ),
            const SizedBox(
              height: 32,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  runSpacing: 24,
                  children: [
                    const Text(
                      _hTp1,
                      style: kBody,
                    ),
                    const Text(
                      _hTp2,
                      style: kBody,
                    ),
                    _hintAndIllustration(
                        text: _hTp3,
                        blockLetters: ["R", "O", "B", "I", "N"]
                            .map((e) => GuessBlock(
                                  guessLetter: e,
                                  guessState: e == "R"
                                      ? GuessBlockState.inRightPlace
                                      : GuessBlockState.notInWord,
                                ))
                            .toList()),
                    _hintAndIllustration(
                        text: _hTp4,
                        blockLetters: ["S", "P", "E", "A", "R"]
                            .map((e) => GuessBlock(
                                  guessLetter: e,
                                  guessState: e == "E"
                                      ? GuessBlockState.inWord
                                      : GuessBlockState.notInWord,
                                ))
                            .toList()),
                    _hintAndIllustration(
                        text: _hTp5,
                        blockLetters: ["L", "O", "O", "P", "S"]
                            .map((e) => GuessBlock(
                                  guessLetter: e,
                                ))
                            .toList())
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
            SizedBox(
              height: 48,
              child: Button(
                buttonText: "Got it",
                onPressed: () => Navigator.pop(context),
                buttonType: ButtonType.secondary,
                buttonSize: ButtonSize.small,
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _hintAndIllustration(
        {required String text, required List<GuessBlock> blockLetters}) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: kBody,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(spacing: 8, children: blockLetters),
      ],
    );
