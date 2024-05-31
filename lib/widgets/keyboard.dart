import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/enums.dart';
import 'package:suffix/utils/text_styles.dart';
import 'package:suffix/view_models/gameplay_viewmodel.dart';
import 'package:suffix/views/home/widget/feedback_modal.dart';
import 'package:suffix/views/home/widget/invalid_word_snackbar.dart';
import 'package:suffix/views/home/widget/out_of_tries_modal.dart';
import 'package:suffix/widgets/button.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: Container(),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: _buildKeyRows(
            context,
          ),
        ),
      ],
    );
  }
}

List<Widget> _buildKeyRows(
  BuildContext context,
) {
  return [
    _buildKeyRow(
      ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
      KeyType.text,
    ),
    const SizedBox(
      height: 8,
    ),
    Padding(
      padding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width / 11) / 2),
      child: _buildKeyRow(
        ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
        KeyType.text,
      ),
    ),
    const SizedBox(
      height: 8,
    ),
    Padding(
      padding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width / 6) / 2),
      child: Row(
          children: ["Z", "X", "C", "V", "B", "N", "M", "DEL"]
              .map((e) => KeyboardKey(
                    keyText: e,
                    keyType: e.toLowerCase() == "del"
                        ? KeyType.delete
                        : KeyType.text,
                  ))
              .toList()),
    ),
    const SizedBox(
      height: 16,
    ),
    Consumer<GameplayViewModel>(builder: (ctxt, value, child) {
      return SizedBox(
        height: 48,
        child: Button(
          buttonText: "Submit",
          buttonType: ButtonType.secondary,
          buttonSize: ButtonSize.medium,
          onPressed: () {
            value.handleGuessedWordIsValid();
            if (!value.guessedWordIsValid) {
              showInvalidWordSnackbar(context);
              return;
            }
            value.newGuess();
            if (value.wordIsCorrect) {
              showFeedbackModal(context);
              return;
            }
            if (!value.wordIsCorrect && value.numberOfGuesses > 5) {
              showOutOfTriesModal(context);
            }
          },
        ),
      );
    }),
  ];
}

Widget _buildKeyRow(List<String> keys, KeyType keyType) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: keys
        .map(
          (key) => KeyboardKey(
            keyText: key,
          ),
        )
        .toList(),
  );
}

class KeyboardKey extends StatefulWidget {
  final String keyText;
  final KeyType keyType;

  const KeyboardKey({
    super.key,
    required this.keyText,
    this.keyType = KeyType.text,
  });

  @override
  State<KeyboardKey> createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {
  bool tapped = false;
  SvgPicture backSpaceIcon = SvgPicture.asset("assets/back-space.svg",
      semanticsLabel: 'Back Space Icon');
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.keyText == "DEL" ? 3 : 2,
      //
      child: Consumer<GameplayViewModel>(builder: (context, value, child) {
        return InkWell(
          onTap: () {
            tapped = false;
            setState(() {});
            if (widget.keyText == "DEL") {
              value.backSpace();
              return;
            }
            value.handleTapLetter(widget.keyText);
          },
          onTapDown: (details) {
            tapped = true;
            setState(() {});
          },
          onTapCancel: () {
            tapped = false;
            setState(() {});
          },
          child: Container(
            height: 40,
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
                color: widget.keyText == "DEL"
                    ? kAccent
                    : colorMap[value.keyColor[widget.keyText]],
                borderRadius: BorderRadius.circular(4.0),
                boxShadow: tapped
                    ? []
                    : const [
                        BoxShadow(
                          color: kDark,
                          spreadRadius: 0,
                          blurRadius: 0,
                          offset: Offset(3, 3),
                        ),
                      ],
                border: Border.all(
                  width: 1,
                  color: kDark,
                )),
            child: Center(
              child: widget.keyText == "DEL"
                  ? backSpaceIcon
                  : Text(
                      widget.keyText,
                      style: kHeading,
                    ),
            ),
          ),
        );
      }),
    );
  }
}

Map<String, Color> colorMap = {
  "kAccent": kAccent,
  "kGreen": kGreen,
  "kYellow": kYellow,
  "kLight": kLight,
};

// Widget keyboardKey(String keyText, KeyType keyType) {
//   return Expanded(
//     flex: keyText == "DEL" ? 3 : 2,
//     child: GestureDetector(
//       onTap: () {
//         // if (keyType == KeyType.enter) {
//         //   tapEnt();
//         // } else if (keyType == KeyType.delete) {
//         //   tapDel();
//         // } else {
//         //   tapText(keyText);
//         // }
//       },
//       child: Container(
//         height: 40,
//         margin: const EdgeInsets.all(2.0),
//         decoration: BoxDecoration(
//           color: kAccent,
//           borderRadius: BorderRadius.circular(4.0),
//           boxShadow: const [
//             BoxShadow(
//               color: kDark,
//               spreadRadius: 0,
//               blurRadius: 0,
//               offset: Offset(3, 3),
//             ),
//           ],
//           border: Border.all(
//             width: 1,
//             color: kDark,
//           ),
//         ),
//         child: Center(
//           child: Text(
//             keyText,
//             style: kHeading,
//           ),
//         ),
//       ),
//     ),
//   );
// }
