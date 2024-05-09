import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:suffix/utils/text_styles.dart';

class Coins extends StatelessWidget {
  const Coins({super.key, required this.numberOfCoins});

  final int numberOfCoins;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset("assets/coin.svg", semanticsLabel: 'Coin'),
        const SizedBox(
          width: 8,
        ),
        Text(
          numberOfCoins.toString(),
          style: kBodySm,
        )
      ],
    );
  }
}
