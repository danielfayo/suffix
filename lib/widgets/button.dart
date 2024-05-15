import 'package:flutter/material.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/enums.dart';
import 'package:suffix/utils/text_styles.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.buttonText,
    required this.buttonType,
    required this.buttonSize,
    this.onPressed,
  });

  final String buttonText;
  final ButtonType buttonType;
  final ButtonSize buttonSize;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    Text buttonTxt = Text(
      buttonText,
      style: buttonSize == ButtonSize.large ? kHeadingLg : kBody,
    );

    return buttonType == ButtonType.ghost
        ? TextButton(
            onPressed: onPressed,
            child: buttonTxt,
          )
        : Container(
            decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: kDark,
                  spreadRadius: 0,
                  blurRadius: 0,
                  offset: Offset(3, 3),
                ),
              ],
              borderRadius: BorderRadius.circular(99),
            ),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ButtonStyle(
                backgroundColor: buttonType == ButtonType.primary
                    ? const MaterialStatePropertyAll(kOrange)
                    : const MaterialStatePropertyAll(kAccent),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: kDark),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
                padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(
                    horizontal: 24,
                    // vertical: buttonSize == ButtonSize.large
                    //     ? 20
                    //     : buttonSize == ButtonSize.medium
                    //         ? 16
                    //         : 8,
                  ),
                ),
              ),
              child: buttonTxt,
            ),
          );
  }
}
