import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/enums.dart';
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
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: kAccent,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          children: [
            const Row(
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
                  ),
                ),
                Coins(numberOfCoins: 344),
                SizedBox(
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
            Expanded(child: Keyboard(tapText: (keyText){}, tapDel: (){}))
          ],
        ),
      )),
    );
  }
}
