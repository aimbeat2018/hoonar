import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/color_constants.dart';
import 'package:hoonar/constants/text_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../constants/my_loading/my_loading.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchnameController = TextEditingController();
  final List<String> recentSearches = [
    "Prathamesh Santosh Gaikar",
    "Pallavi Suresh Joshi",
    "Sejal Krishna Patil",
    "Sanjana Harishchandra Singh",
    "Manmohit S Singh",
    "Payel Vishal Mondal",
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                /*image: DecorationImage(
                  image: AssetImage('assets/images/screens_back.png'),
                  // Path to your image
                  fit:
                      BoxFit.cover, // Ensures the image covers the entire container
                ),*/
                color: myLoading.isDark ? Colors.black : Colors.white),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color: myLoading.isDark
                              ? Colors.white.withOpacity(0.12999999523162842)
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText:
                                      AppLocalizations.of(context)!.searchHint,
                                  hintStyle: GoogleFonts.poppins(
                                    color: hintGreyColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20),
                                ),
                                controller: searchnameController,
                                cursorColor: Colors.white,
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.white),
                                keyboardType: TextInputType.text,
                                onChanged: (value) {
                                  //loadLocationData(value);
                                },
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4.0),
                                child: Icon(
                                  Icons.search,
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        AppLocalizations.of(context)!.recentSearch,
                        style: GoogleFonts.sourceSans3(
                          fontSize: 15,
                          color: myLoading.isDark ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      itemCount: recentSearches.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          visualDensity:
                              const VisualDensity(horizontal: 0, vertical: -2),
                          leading: Icon(
                            Icons.search,
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                            size: 20,
                          ),
                          title: Text(
                            recentSearches[index],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.close,
                              color: myLoading.isDark
                                  ? Colors.white
                                  : Colors.black,
                              size: 20,
                            ),
                            onPressed: () {
                              // Handle remove action for each recent search
                            },
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
