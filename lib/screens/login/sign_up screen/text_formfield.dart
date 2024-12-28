import 'package:flutter/material.dart';

class TTextFormFieldTheme {
  TTextFormFieldTheme._();

  static InputDecorationTheme lightInputDecorationTheme = const InputDecorationTheme(
    border: OutlineInputBorder(),
    prefixIconColor: Colors.green,
    floatingLabelStyle: TextStyle(color: Colors.green),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.green),
    ),
  );

  static InputDecorationTheme darkInputDecorationTheme = const InputDecorationTheme(
    border: OutlineInputBorder(),
    prefixIconColor: Colors.white,
    floatingLabelStyle: TextStyle(color: Colors.white),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(width: 2, color: Colors.white),
    ),
  );
}
