import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../../constants/color_constants.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectShareScreen extends StatefulWidget {
  const ConnectShareScreen({super.key});

  @override
  State<ConnectShareScreen> createState() => _ConnectShareScreenState();
}

class _ConnectShareScreenState extends State<ConnectShareScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(myLoading.isDark
                  ? 'assets/images/screens_back.png'
                  : 'assets/dark_mode_icons/white_screen_back.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15.0, top: 30, bottom: 30),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Image.asset(
                        'assets/images/back_image.png',
                        height: 28,
                        width: 28,
                        color: myLoading.isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01), // Space from the top

                Container(
                  // width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: screenHeight * 0.35,
                  width: screenWidth * 0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage(
                            'assets/images/image1.png',
                          ))),
                ),

                SizedBox(
                  height: 20,
                ),

                Center(
                  child: GradientText(
                    AppLocalizations.of(context)!.shareThisVideo,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: myLoading.isDark ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [
                          myLoading.isDark ? Colors.white : Colors.black,
                          myLoading.isDark ? Colors.white : Colors.black,
                          myLoading.isDark
                              ? greyTextColor8
                              : Colors.grey.shade700
                        ]),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: myLoading.isDark
                        ? const Color(0x603F3F3F)
                        : Color(0x153F3F3F),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Video Link',
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.copy,
                        color: myLoading.isDark ? Colors.white : Colors.black,
                      )
                    ],
                  ),
                ),

                SizedBox(
                  height: 30,
                ),

                Text(
                  AppLocalizations.of(context)!.shareVia,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: myLoading.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: InkWell(
                            onTap: () {},
                            child: Image.asset(
                              'assets/images/insta.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {},
                            child: Image.asset(
                              'assets/images/whatsapp.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {},
                            child: Image.asset(
                              'assets/images/twitter.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: InkWell(
                            onTap: () {},
                            child: Image.asset(
                              'assets/images/copy.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {},
                            child: Image.asset(
                              'assets/images/fb.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {},
                            child: Image.asset(
                              'assets/images/snap.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
