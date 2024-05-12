import 'package:flutter/material.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/enums.dart';
import 'package:suffix/utils/text_styles.dart';
import 'package:suffix/widgets/button.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({
    super.key,
    required this.tapText,
    required this.tapDel,
  });

  final void Function(String keyText) tapText;
  final void Function() tapDel;

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
          children: _buildKeyRows(context),
        ),
      ],
    );
  }
}

List<Widget> _buildKeyRows(BuildContext context) {
  return [
    _buildKeyRow(
        ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'], KeyType.text),
    const SizedBox(
      height: 8,
    ),
    Padding(
      padding: EdgeInsets.symmetric(
          horizontal: (MediaQuery.of(context).size.width / 11) / 2),
      child: _buildKeyRow(
          ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'], KeyType.text),
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
                  ))
              .toList()
          // [

          //   keyboardKey("Z", KeyType.text),
          //   keyboardKey("C", KeyType.text),
          //   keyboardKey("V", KeyType.text),
          //   keyboardKey("B", KeyType.text),
          //   keyboardKey("N", KeyType.text),
          //   keyboardKey("M", KeyType.text),
          //   keyboardKey("DEL", KeyType.delete),
          // ],
          ),
    ),
    const SizedBox(
      height: 16,
    ),
    const Button(
      buttonText: "Submit",
      buttonType: ButtonType.secondary,
      buttonSize: ButtonSize.small,
    ),
  ];
}

Widget _buildKeyRow(List<String> keys, KeyType keyType) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: keys
        .map((key) => KeyboardKey(
              keyText: key,
            ))
        .toList(),
  );
}

class KeyboardKey extends StatefulWidget {
  final String keyText;
  final KeyType keyType;

  const KeyboardKey(
      {super.key, required this.keyText, this.keyType = KeyType.text});

  @override
  State<KeyboardKey> createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {
  bool tapped = false;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: widget.keyText == "DEL" ? 3 : 2,
      child: InkWell(
        onTap: () {
          tapped = false;
          setState(() {});
        },
        onTapDown: (details) {
          tapped = true;
          setState(() {});
        },
        onTapCancel: () {
          tapped = false;
          setState(() {});
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 500),
          scale: tapped ? 0.89 : 1,
          child: Container(
            height: 40,
            margin: const EdgeInsets.all(2.0),
            decoration: BoxDecoration(
                color: kAccent,
                borderRadius: BorderRadius.circular(4.0),
                boxShadow: const [
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
      ),
    );
  }
}

Widget keyboardKey(String keyText, KeyType keyType) {
  return Expanded(
    flex: keyText == "DEL" ? 3 : 2,
    child: GestureDetector(
      onTap: () {
        // if (keyType == KeyType.enter) {
        //   tapEnt();
        // } else if (keyType == KeyType.delete) {
        //   tapDel();
        // } else {
        //   tapText(keyText);
        // }
      },
      child: Container(
        height: 40,
        margin: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            color: kAccent,
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: const [
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
            keyText,
            style: kHeading,
          ),
        ),
      ),
    ),
  );
}
