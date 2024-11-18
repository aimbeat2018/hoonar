import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ManualScrollingText extends StatefulWidget {
  final String text;
  final TextStyle? textStyle;
  final Duration duration;
  final double height;

  const ManualScrollingText({
    Key? key,
    required this.text,
    this.textStyle,
    this.duration = const Duration(seconds: 10),
    this.height = 50.0, // Default height for the scrolling text container
  }) : super(key: key);

  @override
  _ManualScrollingTextState createState() => _ManualScrollingTextState();
}

class _ManualScrollingTextState extends State<ManualScrollingText>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);

    _animationController.addListener(() {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent *
            _animationController.value);
      }
    });

    _animationController.repeat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    widget.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: widget.textStyle ??
                        GoogleFonts.poppins(
                            fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 20), // Gap between the two instances
                  Text(
                    widget.text,
                    style: widget.textStyle ??
                        GoogleFonts.poppins(
                            fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
