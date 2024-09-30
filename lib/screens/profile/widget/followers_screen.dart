import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/text_constants.dart';
import 'package:provider/provider.dart';

import '../../../constants/my_loading/my_loading.dart';

class FollowersScreen extends StatefulWidget {
  const FollowersScreen({super.key});

  @override
  State<FollowersScreen> createState() => _FollowersScreenState();
}

class _FollowersScreenState extends State<FollowersScreen>
    with SingleTickerProviderStateMixin {
  bool isFollow = false;
  late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: AnimatedList(
          initialItemCount: 10,
          itemBuilder: (context, index, animation) {
            return buildItem(
                animation, index, myLoading.isDark); // Build each list item
          },
        ),
      );
    });
  }

  Widget buildItem(Animation<double> animation, int index, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 0.80,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          borderRadius: BorderRadius.circular(6.19),
        ),
      ),
      child: Row(
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
                          color: isDarkMode ? Colors.white : Colors.black,
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
                  /* .animate()
                      .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
                      .slide()*/
                  ,
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
                border: Border.all(
                  color: isFollow
                      ? (isDarkMode ? Colors.white : Colors.black)
                      : Colors.transparent,
                  width: 1,
                ),
                color: isFollow
                    ? Colors.transparent
                    : (isDarkMode ? Colors.white : Colors.black),
              ),
              child: Text(
                isFollow
                    ? AppLocalizations.of(context)!.unfollow
                    : AppLocalizations.of(context)!.follow,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: isFollow
                      ? (isDarkMode ? Colors.white : Colors.black)
                      : (isDarkMode ? Colors.black : Colors.white),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
