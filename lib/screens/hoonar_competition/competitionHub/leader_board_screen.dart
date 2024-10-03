import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/hoonar_competition/competitionHub/your_rank_screen.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/slide_right_route.dart';
import '../../../model/contestant.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({super.key});

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  final contestantList = [
    Contestant("1", 'Prathamesh Santosh Gaikar', '123k'),
    Contestant("2", 'Pallavi Suresh Joshi', '12.2k'),
    Contestant("3", 'Pratik Santanu Mhatre', '10.1k'),
    Contestant("4", 'Sejal Krishna Patil', '11.9k'),
    Contestant("5", 'Sanjana Harishchandra Singh', '11.5k'),
    Contestant("6", 'Manmohit S Singh', '11.3k'),
    Contestant("7", 'Prathamesh Santosh Gaikar', '11k'),
    Contestant("8", 'Payel Vishal Mondal', '9.7k'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: TextField(
                  style: GoogleFonts.poppins(
                      color: myLoading.isDark ? Colors.white : Colors.black,
                      fontSize: 14),
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    fillColor:
                        myLoading.isDark ? Color(0xFF2A2A2A) : Colors.white70,
                    hintText: AppLocalizations.of(context)!.searchContestant,
                    hintStyle: GoogleFonts.poppins(
                        color: myLoading.isDark ? Colors.white : Colors.black,
                        fontSize: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: Icon(
                      Icons.search,
                      color: myLoading.isDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    SlideRightRoute(page: YourRankScreen()),
                  );
                },
                child: Hero(
                  tag: 'your_rank',
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: contBlueColor1),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          'assets/images/rank.png',
                          height: 28,
                          width: 28,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.yourRank,
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    AppLocalizations.of(context)!.rank,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: myLoading.isDark
                            ? Colors.white70
                            : Colors.grey.shade900,
                        fontWeight: FontWeight.normal),
                  )),
                  Expanded(
                      flex: 3,
                      child: Text(
                        textAlign: TextAlign.center,
                        AppLocalizations.of(context)!.contestantName,
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: myLoading.isDark
                                ? Colors.white70
                                : Colors.grey.shade900,
                            fontWeight: FontWeight.normal),
                      )),
                  Expanded(
                      child: Text(
                    textAlign: TextAlign.center,
                    AppLocalizations.of(context)!.votes,
                    style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: myLoading.isDark
                            ? Colors.white70
                            : Colors.grey.shade900,
                        fontWeight: FontWeight.normal),
                  ))
                ],
              ),
              ListView.builder(
                itemCount: contestantList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final contestant = contestantList[index];
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: (contestant.rank == 1 ||
                                    contestant.rank == 2 ||
                                    contestant.rank == 3)
                                ? Image.asset(
                                    contestant.rank == 1
                                        ? 'assets/images/1st.png'
                                        : contestant.rank == 2
                                            ? 'assets/images/2nd.png'
                                            : 'assets/images/3rd.png',
                                    height: 20,
                                    width: 20,
                                  )
                                : Text(
                                    contestant.rank.toString(),
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        color: myLoading.isDark
                                            ? Colors.white70
                                            : Colors.grey.shade900,
                                        fontWeight: FontWeight.normal),
                                  )),
                        Expanded(
                            flex: 3,
                            child: Text(
                              textAlign: TextAlign.center,
                              contestant.name,
                              style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.normal),
                            )),
                        Expanded(
                            child: Text(
                          textAlign: TextAlign.center,
                          contestant.votes,
                          style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.normal),
                        ))
                      ],
                    ),
                  );
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
