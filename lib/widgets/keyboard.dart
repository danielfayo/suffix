import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/enums.dart';
import 'package:suffix/utils/text_styles.dart';
import 'package:suffix/view_models/gameplay_viewmodel.dart';
import 'package:suffix/views/home/widget/feedback_modal.dart';
import 'package:suffix/widgets/button.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({
    super.key,
    required this.tapText,
    required this.tapDel,
    required this.tapSubmit,
  });

  final void Function(String keyText) tapText;
  final void Function() tapDel;
  final void Function() tapSubmit;

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
          children: _buildKeyRows(context,
              tapDel: tapDel, tapText: tapText, handleSubmit: tapSubmit),
        ),
      ],
    );
  }
}

List<Widget> _buildKeyRows(BuildContext context,
    {required Function() tapDel,
    required Function(String keyText) tapText,
    required Function() handleSubmit}) {
  return [
    _buildKeyRow(
        ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'], KeyType.text,
        tapDel: tapDel, tapText: tapText),
    const SizedBox(
      height: 8,
    ),
    Padding(
      padding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width / 11) / 2),
      child: _buildKeyRow(
          ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'], KeyType.text,
          tapDel: tapDel, tapText: tapText),
    ),
    const SizedBox(
      height: 8,
    ),
    Padding(
      padding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width / 6) / 2),
      child: Row(
          children: ["Z", "C", "V", "B", "N", "M", "DEL"]
              .map((e) => KeyboardKey(
                    keyText: e,
                    keyType: e.toLowerCase() == "del"
                        ? KeyType.delete
                        : KeyType.text,
                    tapDel: tapDel,
                    tapText: tapText,
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
            value.newGuess();
            if (value.wordIsCorrect) {
              showFeedbackModal(context);
            }
          },
        ),
      );
    }),
  ];
}

Widget _buildKeyRow(List<String> keys, KeyType keyType,
    {required Function() tapDel, required Function(String keyText) tapText}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: keys
        .map((key) => KeyboardKey(
              keyText: key,
              tapDel: tapDel,
              tapText: tapText,
            ))
        .toList(),
  );
}

class KeyboardKey extends StatefulWidget {
  final String keyText;
  final KeyType keyType;
  final Function(String key)? tapText;
  final void Function()? tapDel;

  const KeyboardKey({
    super.key,
    required this.keyText,
    this.keyType = KeyType.text,
    this.tapText,
    this.tapDel,
  });

  @override
  State<KeyboardKey> createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {
  bool tapped = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.keyText == "DEL" ? 3 : 2,
      // 
      child: InkWell(
        onTap: () {
          tapped = false;
          setState(() {});
          if (widget.tapDel != null && widget.keyText == "DEL") {
            widget.tapDel!();
            return;
          }
          if (widget.tapText != null) {
            widget.tapText!(widget.keyText);
          }
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
              color: kAccent,
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
            child: Text(
              widget.keyText,
              style: kHeading,
            ),
          ),
        ),
      ),
    );
  }
}

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
