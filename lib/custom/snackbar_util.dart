import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SnackbarUtil {
  static void showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      backgroundColor: Colors.black.withOpacity(0.8),
      content: Text(
        message,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14,
        ),
      ),
      duration: Duration(seconds: 3),
      /* action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Implement undo action here if needed
        },
      ),*/
    );

    // Show the SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class Validation {
  static bool isValidEmail(String email) {
    // Regular expression for validating an email address
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$";
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }
}
