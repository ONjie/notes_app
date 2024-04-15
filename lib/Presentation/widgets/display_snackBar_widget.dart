import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

SnackBar displaySnackBarWidget({required String message, required Color color}) {
  return SnackBar(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8)
    ),
    elevation: 5,
    backgroundColor: color,
      padding: const EdgeInsets.all(12),
      duration: const Duration(seconds: 2),
      content: Text(
        message,
        style: const TextStyle(
          color: CupertinoColors.white,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      )
  );
}
