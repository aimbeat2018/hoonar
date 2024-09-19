import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/text_constants.dart';
import 'package:hoonar/model/slider_model.dart';

class OptionsScreen extends StatefulWidget {
  final SliderModel? model;

  OptionsScreen({Key? key, this.model}) : super(key: key);

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset(
                    // 'assets/images/vote_not_given.png',
                    'assets/images/vote_given.png',
                    scale: 5,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    votes,
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/images/like.png',
                    // 'assets/images/unlike.png',
                    scale: 7,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    likes,
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/images/comment.png',
                    scale: 7,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    comments,
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/images/share.png',
                    scale: 7,
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  Text(
                    share,
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
