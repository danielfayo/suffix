import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:suffix/models/models/word.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/text_styles.dart';
import 'package:suffix/view_models/gameplay_viewmodel.dart';

class GuessWords extends StatelessWidget {
  const GuessWords({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameplayViewModel>(
      builder: (context, gameplayViewModel, child) {
        return Column(
          children: gameplayViewModel.words
              .map((word) => WordRow(word: word))
              .toList(),
        );
      },
    );
  }
}

class WordRow extends StatefulWidget {
  const WordRow({super.key, required this.word});

  final Word word;

  @override
  State<WordRow> createState() => _WordRowState();
}

class _WordRowState extends State<WordRow> with TickerProviderStateMixin {

  @override
  Widget build(BuildContext context) {
    double boxSize =
        ((MediaQuery.of(context).size.width / 7) - (16 * 2)).clamp(40, 47);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Consumer<GameplayViewModel>(builder: (context, value, child) {
        return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.word.allLetters
                .map((eachLetter) => GestureDetector(
                      onTap: () {
                        value.handleActiveBox(
                            eachLetter.letterId, widget.word.wordId);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: boxSize,
                        width: boxSize,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: eachLetter.isInRightPosition
                              ? kGreen
                              : eachLetter.letterIsPresent
                                  ? kYellow
                                  : eachLetter.letterIsNotPresent
                                      ? kLight
                                      : kAccent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            width: (value.numberOfGuesses ==
                                        widget.word.wordId &&
                                    value.letterPosition ==
                                        eachLetter.letterId)
                                ? 2
                                : 1,
                            color: kDark,
                          ),
                        ),
                        child: eachLetter.letter != null
                            ? Text(
                                eachLetter.letter!,
                                style: kHeading,
                              )
                            : null,
                      ),
                    ))
                .toList());
      }),
    );
  }
}
