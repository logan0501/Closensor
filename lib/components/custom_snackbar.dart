import 'package:flutter/material.dart';

SnackBar customSnackBar(String message, Color color) {
  return SnackBar(
    content: Text(message),
    backgroundColor: color,
  );
}