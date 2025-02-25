import "package:flutter/material.dart";

final lightTheme =
    ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
    ).copyWith();

final darkTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.orange,
    brightness: Brightness.dark,
  ),
).copyWith(
  scaffoldBackgroundColor: Colors.black, // AMOLED(純粋な黒に上書き)
);
