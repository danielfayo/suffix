import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/enums.dart';
import 'package:suffix/utils/text_styles.dart';
import 'package:suffix/view_models/gameplay_viewmodel.dart';
import 'package:suffix/views/home/home_screen.dart';
import 'package:suffix/widgets/button.dart';

Map<int, String> _feedbackHeading = {
  1: "Amazing!",
  2: "Great job!",
  3: "Great job!",
  4: "Great job!",
  5: "Clever!"
};

Map<int, String> _feedbackSub = {
  1: "You guessed the word in one try!",
  2: "You guessed the word in two tries",
  3: "You guessed the word in three tries",
  4: "You guessed the word in four tries",
  5: "You figured it out in just five tries"
};

void showFeedbackModal(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => const Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      child: FeedbackModal(),
    ),
  );
}

class FeedbackModal extends StatelessWidget {
  const FeedbackModal({super.key});

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
          builder: (context, value, child) {
            return Column(
              children: [
                Text(
                  "${_feedbackHeading[value.numberOfGuesses]}",
                  style: kHeading,
                ),
                Text(
                  "${_feedbackSub[value.numberOfGuesses]}",
                  style: kBodySm,
                ),
                const SizedBox(
                  height: 24,
                ),
                SizedBox(
                  height: 48,
                  child: Button(
                    buttonText: "Next Level",
                    buttonType: ButtonType.primary,
                    buttonSize: ButtonSize.medium,
                    onPressed: () {
                      Navigator.pop(context);
                      value.handleRestartGame();
                      value.handleGoToNextLevel();
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
