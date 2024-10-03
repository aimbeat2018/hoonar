import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/text_constants.dart';
import '../../../model/slider_model.dart';
import '../../../model/star_category_model.dart';
import '../../home/widgets/slider_page_view.dart';

class HoonarStarsScreen extends StatefulWidget {
  const HoonarStarsScreen({super.key});

  @override
  State<HoonarStarsScreen> createState() => _HoonarStarsScreenState();
}

class _HoonarStarsScreenState extends State<HoonarStarsScreen> {
  List<SliderModel> sliderModelList = [
    SliderModel(raps, 'assets/images/video1.mp4', '', '@abcd@123'),
    SliderModel(vocals, 'assets/images/video2.mp4', '', '@abcd@123'),
    SliderModel(dance, 'assets/images/video3.mp4', '', '@abcd@123'),
  ];
  List<StarCategoryModel> zoneLevelsList = [];
  StarCategoryModel? selectedLevel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      zoneLevelsList = [
        StarCategoryModel('', AppLocalizations.of(context)!.zone_leve, '1'),
        StarCategoryModel('', AppLocalizations.of(context)!.divisionLevel, '0'),
        StarCategoryModel('', AppLocalizations.of(context)!.districtLevel, '0'),
        StarCategoryModel('', AppLocalizations.of(context)!.stateLevel, '0'),
        StarCategoryModel('', AppLocalizations.of(context)!.regionLevel, '0'),
        StarCategoryModel('', AppLocalizations.of(context)!.stateLevel, '0'),
        StarCategoryModel('', AppLocalizations.of(context)!.nationalLevel, '0'),
      ];

      // Set selectedLevel to one of the items in zoneLevelsList
      selectedLevel = zoneLevelsList.firstWhere(
        (element) =>
            element.name == AppLocalizations.of(context)!.districtLevel,
        orElse: () =>
            zoneLevelsList.first, // Default to the first item if not found
      );

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(children: [
                SizedBox(
                    height: screenHeight * 0.58,
                    child: SliderPageView(
                      sliderModelList: sliderModelList,
                    )),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 45.0),
                  child: InputDecorator(
                    decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 3),
                        labelText: AppLocalizations.of(context)!.level,
                        labelStyle: GoogleFonts.poppins(
                          color: myLoading.isDark ? Colors.white : Colors.black,
                          fontSize: 14,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                width: 1)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                width: 1)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(8),
                            ),
                            borderSide: BorderSide(
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                width: 1))),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<StarCategoryModel>(
                        dropdownColor:
                            myLoading.isDark ? Colors.black : Colors.white,
                        // Dropdown background color
                        value: selectedLevel,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: myLoading.isDark ? Colors.white : Colors.black,
                        ),
                        isExpanded: true,
                        // Make dropdown fill the width
                        style: GoogleFonts.poppins(
                          color: myLoading.isDark ? Colors.white : Colors.black,
                          fontSize: 14,
                        ),
                        items: zoneLevelsList
                            .map<DropdownMenuItem<StarCategoryModel>>(
                                (StarCategoryModel value) {
                          return DropdownMenuItem<StarCategoryModel>(
                            value: value,
                            child: Text(
                              value.name ?? '',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: myLoading.isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (StarCategoryModel? newValue) {
                          setState(() {
                            selectedLevel = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ));
    });
  }
}
