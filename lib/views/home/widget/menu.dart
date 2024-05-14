import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/enums.dart';
import 'package:suffix/view_models/gameplay_viewmodel.dart';
import 'package:suffix/views/home/home_screen.dart';
import 'package:suffix/widgets/button.dart';

void showMenuSheet(BuildContext context) {
  showModalBottomSheet(context: context, builder: (context) => const Menu());
}

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.only(bottom: 32, top: 8, left: 16),
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          color: kAccent,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        child: Consumer<GameplayViewModel>(
          builder: (context, value, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 40,
                  child: Button(
                    buttonText: "Restart game",
                    buttonType: ButtonType.ghost,
                    buttonSize: ButtonSize.small,
                    onPressed: () {
                      value.handleRestartGame();
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(
                  height: 40,
                  child: Button(
                    buttonText: "Back to home",
                    buttonType: ButtonType.ghost,
                    buttonSize: ButtonSize.small,
                    onPressed: () {
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
                const SizedBox(
                  height: 40,
                  child: Button(
                    buttonText: "Mute sound",
                    buttonType: ButtonType.ghost,
                    buttonSize: ButtonSize.small,
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
