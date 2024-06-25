import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:suffix/utils/colors.dart';
import 'package:suffix/utils/text_styles.dart';

void showInvalidWordSnackbar(BuildContext context) {
  // ScaffoldMessenger.of(context).showSnackBar(invalidWordSnackbar);
  Fluttertoast.showToast(
    msg: "Invalid word",
    backgroundColor: kLight,
    textColor: kDark,
    gravity: ToastGravity.CENTER,
  );
}

SnackBar invalidWordSnackbar = SnackBar(
  content: IntrinsicWidth(
    child: Container(
      child: Text(
        "Invalid Word",
        style: kBodySm,
        textAlign: TextAlign.center,
      ),
    ),
  ),
  margin: const EdgeInsets.only(bottom: 32, left: 32, right: 32),
  behavior: SnackBarBehavior.floating,
  elevation: 0,
  backgroundColor: kLight,
  shape: RoundedRectangleBorder(
    side: const BorderSide(
      color: kDark,
      width: 1,
    ),
    borderRadius: BorderRadius.circular(24),
  ),
  duration: const Duration(seconds: 2),
);
