import 'package:flutter/material.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/enums.dart';
import 'package:suffix/utils/text_styles.dart';
import 'package:suffix/views/home/widget/how_to_play.dart';
import 'package:suffix/views/home/widget/letter_words_modal.dart';
import 'package:suffix/widgets/button.dart';

String _appNameText = "suffix";
String _buttonText = "Play game";
String _secondaryButtonText = "How to play";

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAccent,
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
            Text(
              _appNameText,
              style: kHeadingXLg,
            ),
            const Spacer(),
            Column(
              children: [
                SizedBox(
                  height: 64,
                  child: Button(
                    buttonText: _buttonText,
                    buttonType: ButtonType.primary,
                    buttonSize: ButtonSize.large,
                    onPressed: () {
                      showLetterWordsModal(context);
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => const GameScreen(),
                      //   ),
                      // );
                    },
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Button(
                  buttonText: _secondaryButtonText,
                  buttonType: ButtonType.ghost,
                  onPressed: () {
                    showHowToPlay(context);
                  },
                  buttonSize: ButtonSize.medium,
                )
              ],
            ),
            const Expanded(
              flex: 1,
              child: SizedBox(),
            ),
          ],
        ),
      )),
    );
  }
}
