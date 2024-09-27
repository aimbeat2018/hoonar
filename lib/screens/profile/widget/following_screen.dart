import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/text_constants.dart';

class FollowingScreen extends StatefulWidget {
  const FollowingScreen({super.key});

  @override
  State<FollowingScreen> createState() => _FollowingScreenState();
}

class _FollowingScreenState extends State<FollowingScreen>
    with SingleTickerProviderStateMixin {
  bool isFollow = false;
  late AnimationController _controller;
  late Animation<Offset> _rightAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    /* _leftAnimation = Tween<Offset>(
      begin: Offset(0.0, -1.0), // Start from the left
      end: Offset(0.0, 0.0), // End at the center
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0, // Start at 0 (invisible)
      end: 1, // End at 1 (original size)
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
*/
    _rightAnimation = Tween<Offset>(
      begin: Offset(1.0, 0.0), // Start from the right
      end: Offset(0.0, 0.0), // End at the center
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AnimatedList(
        initialItemCount: 10,
        itemBuilder: (context, index, animation) {
          return buildItem(animation, index); // Build each list item
        },
      ),
    );
  }

  Widget buildItem(Animation<double> animation, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 0.80,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(6.19),
        ),
      ),
      child: itemCommon(animation, index),
    ) /*.animate().moveX(
            begin: 200,
            end: 0,
            duration: 800.ms)*/ // Moves from -200px to 0px (top to center)
        ; // Fade in effect;
  }

  Widget itemCommon(Animation<double> animation, int index) {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              const CircleAvatar(
                radius: 20,
                // Set the radius based on available size
                backgroundImage: NetworkImage(
                  'https://www.stylecraze.com/wp-content/uploads/2020/09/Beautiful-Women-In-The-World.jpg',
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hitesh Malekar',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      '@hiteshm',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF939393),
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                      ),
                    )
                  ],
                )
                    /*.animate()
                    .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
                    .slide()*/,
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              isFollow = !isFollow;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.white, width: 1),
                color: Colors.transparent),
            child: Text(
              unfollow,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
