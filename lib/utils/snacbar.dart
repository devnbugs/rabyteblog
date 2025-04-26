import 'package:flutter/material.dart';

void openSnacbar(BuildContext context, message) {
  final snackBar = SnackBar(
    duration: const Duration(seconds: 1),
    padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
    content: Container(
      alignment: Alignment.centerLeft,
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500
        ),
      ),
    ),
    action: SnackBarAction(
      label: 'Ok',
      textColor: Colors.blueAccent,
      onPressed: () {},
    ),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
