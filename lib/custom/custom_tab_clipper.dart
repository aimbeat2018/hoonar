// Custom Clipper to draw the curve
import 'package:flutter/material.dart';

class CustomTabClipper extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.grey[850]!
      ..style = PaintingStyle.fill;

    var path = Path();

    // Drawing a rectangle with rounded left corners
    path.moveTo(30, 0);  // Start drawing from the top-left
    path.lineTo(size.width, 0);  // Line to top-right
    path.lineTo(size.width, size.height);  // Line to bottom-right
    path.lineTo(30, size.height);  // Line to bottom-left
    path.arcToPoint(const Offset(1, 0), radius: const Radius.circular(10), clockwise: false);  // Rounded left side

    canvas.drawPath(path, paint);  // Draw the shape
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
