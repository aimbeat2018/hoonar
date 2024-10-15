import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CupertinoCustomDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmButtonText;
  final String cancelButtonText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;

  const CupertinoCustomDialog({
    Key? key,
    required this.title,
    required this.message,
    this.confirmButtonText = 'Confirm',
    this.cancelButtonText = 'Cancel',
    this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title:
          Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      content: Text(message,
          style: GoogleFonts.poppins(fontWeight: FontWeight.normal)),
      actions: [
      /*  CupertinoDialogAction(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: Text(cancelButtonText,
              style: GoogleFonts.poppins(fontWeight: FontWeight.normal)),
        ),*/
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: onConfirm ?? () => Navigator.of(context).pop(),
          child: Text(confirmButtonText,
              style: GoogleFonts.poppins(fontWeight: FontWeight.normal)),
        ),
      ],
    );
  }
}
