import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/enums.dart';
import 'package:suffix/utils/text_styles.dart';
import 'package:suffix/view_models/gameplay_viewmodel.dart';
import 'package:suffix/views/home/home_screen.dart';
import 'package:suffix/widgets/button.dart';

void showOutOfTriesModal(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      child: OutOfTriesModal(),
    ),
  );
}

class OutOfTriesModal extends StatelessWidget {
  const OutOfTriesModal({super.key});

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
        child: Consumer<GameplayViewModel>(
          builder: (newcontext, value, child) {
            return Column(
              children: [
                Text(
                  "Out of tries!",
                  style: kHeading,
                ),
                Text(
                  "${value.wordToGuess} was the word. Better luck next time",
                  style: kBodySm,
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  height: 48,
                  child: Button(
                    buttonText: "New game",
                    buttonType: ButtonType.primary,
                    buttonSize: ButtonSize.medium,
                    onPressed: () {
                      Navigator.pop(context);
                      value.handleRestartGame();
                    },
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                SizedBox(
                  height: 36,
                  child: Button(
                    buttonText: "Back to home",
                    buttonType: ButtonType.ghost,
                    buttonSize: ButtonSize.medium,
                    onPressed: () {
                      value.handleRestartGame();
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                          type: PageTransitionType.leftToRight,
                          child: const HomeScreen(),
                        ),
                      );
                      value.emptyAllWords();
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
