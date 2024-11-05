import 'package:flutter/material.dart';

class SecondsTab extends StatelessWidget {
  final VoidCallback onTap;
  final bool isSelected;
  final String title;

  const SecondsTab(
      {Key? key,
      required this.onTap,
      required this.isSelected,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 35,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.black26,
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: /*isSelected ? Colors.white : Colors.black*/Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
