import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/enums.dart';
import 'package:suffix/view_models/gameplay_viewmodel.dart';
import 'package:suffix/views/home/widget/guess_words.dart';
import 'package:suffix/views/home/widget/menu.dart';
import 'package:suffix/widgets/button.dart';
import 'package:suffix/widgets/coins.dart';
import 'package:suffix/widgets/keyboard.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      context.read<GameplayViewModel>().getWords();
    });
    // Provider.of<GameplayViewModel>(context).getWords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAccent,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 96,
                  height: 36,
                  child: Button(
                    buttonText: "Menu",
                    buttonType: ButtonType.secondary,
                    buttonSize: ButtonSize.small,
                    onPressed: () => showMenuSheet(context),
                  ),
                ),
                const Coins(numberOfCoins: 344),
                const SizedBox(
                  width: 96,
                  height: 36,
                  child: Button(
                    buttonText: "-5",
                    buttonType: ButtonType.secondary,
                    buttonSize: ButtonSize.small,
                  ),
                ),
              ],
            ),
            const Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GuessWords(),
                ],
              ),
            ),
            Consumer<GameplayViewModel>(
              builder: (context, gameplayViewmodel, child) {
                return Expanded(
                  child: Keyboard(
                    tapText: (keyText) {
                      gameplayViewmodel.handleTapLetter(keyText);
                    },
                    tapDel: () {
                      gameplayViewmodel.backSpace();
                    },
                    tapSubmit: () => gameplayViewmodel.newGuess(),
                  ),
                );
              },
            )
          ],
        ),
      )),
    );
  }
}
