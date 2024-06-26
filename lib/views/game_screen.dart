import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/enums.dart';
import 'package:suffix/utils/text_styles.dart';
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
        child: Consumer<GameplayViewModel>(
            builder: (context, gameplayViewmodel, child) {
          // print(gameplayViewmodel.words.length);
          return Column(
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
                  Coins(
                    numberOfCoins: gameplayViewmodel.getAvailableCoinsAmount(),
                  ),
                  SizedBox(
                      width: 96,
                      height: 36,
                      child: InkWell(
                        onTap: () {
                          if (gameplayViewmodel.noMoreHint) {
                            Fluttertoast.showToast(
                              msg: "No more hints",
                              backgroundColor: kLight,
                              textColor: kDark,
                              gravity: ToastGravity.CENTER,
                            );
                          }
                          gameplayViewmodel.getHint();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: kAccent,
                            border: Border.all(color: kDark, width: 1),
                            borderRadius: BorderRadius.circular(99),
                            boxShadow: const [
                              BoxShadow(
                                color: kDark,
                                spreadRadius: 0,
                                blurRadius: 0,
                                offset: Offset(3, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/bulb.svg",
                                  semanticsLabel: 'Bulb Icon'),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                "-5",
                                style: kBody,
                              ),
                            ],
                          ),
                        ),
                      )
                      // Button(
                      //   buttonText: "-5",
                      //   buttonType: ButtonType.secondary,
                      //   buttonSize: ButtonSize.small,
                      //   onPressed: () => gameplayViewmodel.getHint(),
                      // ),
                      ),
                ],
              ),
              Text(
                "Level ${gameplayViewmodel.currentLevel}",
                style: kBodySm,
              ),
              const Expanded(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GuessWords(),
                  ],
                ),
              ),
              const Expanded(
                flex: 2,
                child: Keyboard(),
              )
            ],
          );
        }),
      )),
    );
  }
}
