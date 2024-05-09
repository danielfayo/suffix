import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/enums.dart';
import 'package:suffix/utils/text_styles.dart';

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
          children: _buildKeyRows(),
        ),
      ],
    );
  }
}

List<Widget> _buildKeyRows() {
  return [
    _buildKeyRow(
        ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'], KeyType.text),
    const SizedBox(
      height: 8,
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: _buildKeyRow(
          ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'], KeyType.text),
    ),
    const SizedBox(
      height: 8,
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          keyboardKey("Z", KeyType.text),
          keyboardKey("C", KeyType.text),
          keyboardKey("V", KeyType.text),
          keyboardKey("B", KeyType.text),
          keyboardKey("N", KeyType.text),
          keyboardKey("M", KeyType.text),
          keyboardKey("DEL", KeyType.delete),
        ],
      ),
    )
  ];
}

Widget _buildKeyRow(List<String> keys, KeyType keyType) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: keys.map((key) => keyboardKey(key, keyType)).toList(),
  );
}

Widget keyboardKey(String keyText, KeyType keyType) {
  return Expanded(
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
