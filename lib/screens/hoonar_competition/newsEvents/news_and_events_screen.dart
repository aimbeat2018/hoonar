import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../constants/color_constants.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/slide_right_route.dart';
import '../../../../constants/theme.dart';
import 'upcoming_events_screen.dart';

class NewsAndEventsScreen extends StatefulWidget {
  const NewsAndEventsScreen({super.key});

  @override
  State<NewsAndEventsScreen> createState() => _NewsAndEventsScreenState();
}

class _NewsAndEventsScreenState extends State<NewsAndEventsScreen> {
  @override
  Widget build(BuildContext context) {
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
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15.0, top: 10, bottom: 0),
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
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: GradientText(
                        AppLocalizations.of(context)!.news_events,
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
                      )

                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                            child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: myLoading.isDark
                                  ? greyBackColor.withOpacity(0.5)
                                  : Colors.white70),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  '09/03/2024',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 40,
                              ),
                              Icon(
                                Icons.calendar_month,
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                              )
                            ],
                          ),
                        )),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              SlideRightRoute(page: UpcomingEventsScreen()),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/upcoming_events.png',
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                height: 20,
                                width: 20,
                              ),
                              SizedBox(height: 3),
                              Text(
                                AppLocalizations.of(context)!.upcomingEvents,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      shrinkWrap: true,
                      itemCount: 5,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  width: 1)),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 10, right: 10, left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!
                                      .headline
                                      .toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                Text(
                                  '${AppLocalizations.of(context)!.today}, 09:00 PM',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
