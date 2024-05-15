import 'package:flutter/material.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/enums.dart';
import 'package:suffix/utils/text_styles.dart';

class GuessBlock extends StatefulWidget {
  final GuessBlockState guessState;
  final String guessLetter;

  const GuessBlock({super.key, this.guessState = GuessBlockState.notInWord,required this.guessLetter});
  @override
  State<GuessBlock> createState() => _GuessBlockState();
}

class _GuessBlockState extends State<GuessBlock> {
  @override
  Widget build(BuildContext context) {
    double size = (MediaQuery.of(context).size.width / 7).clamp(40, 47);
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: widget.guessState == GuessBlockState.inWord
              ? kYellow
              : widget.guessState == GuessBlockState.inRightPlace
                  ? kGreen
                  : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(width: 1, color: kDark)),
          child: Text(widget.guessLetter,style: kHeading,),
    );
  }
}


