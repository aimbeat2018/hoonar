import 'package:flutter/material.dart';

/// Appbar Widget
PreferredSizeWidget buildAppbar(BuildContext context, bool isDarkMode) {
  return AppBar(
    elevation: 0,
    toolbarHeight: 28,
    backgroundColor: Colors.transparent,
    automaticallyImplyLeading: false,
    leadingWidth: 41,
    leading: InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
        padding: EdgeInsets.only(left: 13),
        child: Image.asset(
          'assets/images/back_image.png',
          height: 28,
          width: 28,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    ),
  );
}
