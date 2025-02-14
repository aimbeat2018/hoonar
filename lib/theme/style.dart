import 'package:flutter/material.dart';

// Additional text themes
TextStyle boldCaptionStyle(BuildContext context) => Theme.of(context)
    .textTheme
    .bodySmall!
    .copyWith(fontWeight: FontWeight.bold);

TextStyle normalCaptionStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodySmall!.copyWith(
          // color: Colors.grey,
          fontSize: 14,
        );

TextStyle normalHeadingStyle(BuildContext context) =>
    Theme.of(context).textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.normal,
        );

TextStyle textFieldHintStyle(BuildContext context) =>
    Theme.of(context).textTheme.bodySmall!.copyWith(
          color: Colors.grey[500],
          fontWeight: FontWeight.normal,
          fontSize: 15,
        );

TextStyle textFieldInputStyle(BuildContext context, FontWeight? fontWeight) =>
    Theme.of(context).textTheme.bodyLarge!.copyWith(
          // color: Colors.black,
          fontSize: 18,
          fontWeight: fontWeight ?? FontWeight.normal,
        );

class ThemeUtils {
  bool isLightMode = true;

  /// Theme light mode

 static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      primaryColorDark: Colors.white,
      scaffoldBackgroundColor: Colors.white,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      colorScheme: ColorScheme(
        primary: Colors.grey.withOpacity(0.4),
        error: Colors.red,
        brightness: Brightness.light,
        surface: Colors.grey.shade100,
        secondary: Colors.black,
        onSurface: Colors.black,
        onSecondary: Colors.white,
        onPrimary: Colors.grey.shade100,
        onError: Colors.red,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.black),
        bodyMedium: TextStyle(color: Colors.black),
        labelLarge: TextStyle(color: Colors.black),
      ),
      iconTheme: const IconThemeData(color: Colors.black),
      useMaterial3: false,
    );
  }

  /// Theme dark mode
  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      primaryColorDark: Colors.black,
      scaffoldBackgroundColor: Colors.black,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      focusColor: Colors.transparent,
      colorScheme: ColorScheme(
          primary: Colors.white,
          error: Colors.red,
          brightness: Brightness.dark,
          surface: Colors.white,
          onSurface: Colors.grey.shade100,
          secondary: Colors.white,
          onSecondary: Colors.blue,
          onPrimary: Colors.red,
          onError: Colors.red),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
        labelLarge: TextStyle(color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      useMaterial3: false,
    );
  }
}
