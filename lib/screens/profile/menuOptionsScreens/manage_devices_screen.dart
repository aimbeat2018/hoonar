import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';
import '../../../constants/common_widgets.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/text_constants.dart';
import '../../../constants/theme.dart';
import '../../../model/dummy_list_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ManageDevicesScreen extends StatefulWidget {
  const ManageDevicesScreen({super.key});

  @override
  State<ManageDevicesScreen> createState() => _ManageDevicesScreenState();
}

class _ManageDevicesScreenState extends State<ManageDevicesScreen> {
  List<DummyListModel> dummyDataList = [
    DummyListModel(
        image: 'assets/images/mobile.png',
        title: 'Samsung S24',
        subTitle: 'Now'),
    DummyListModel(
        image: 'assets/images/laptop.png',
        title: 'Macbook Pro',
        subTitle: '4 days ago'),
    DummyListModel(
        image: 'assets/images/mobile.png',
        title: 'Iphone 15 Pro Max',
        subTitle: '30 mins ago'),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        body: Container(
          padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              /*image: DecorationImage(
                image: AssetImage('assets/images/screens_back.png'),
                // Path to your image
                fit: BoxFit.cover, // Ensures the image covers the entire container
              ),*/
              color: myLoading.isDark ? Colors.black : Colors.white),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildAppbar(context, false),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: GradientText(
                    AppLocalizations.of(context)!.manageDevices,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: myLoading.isDark ? Colors.white : Colors.black,
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
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .then(delay: 200.ms) // baseline=800ms
                      .slide(),
                ),
                AnimatedList(
                  initialItemCount: dummyDataList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index, animation) {
                    return buildItem(animation, index,
                        myLoading.isDark); // Build each list item
                  },
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildItem(Animation<double> animation, int index, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
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
          Image.asset(
            dummyDataList[index].image!,
            height: 25,
            width: 25,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dummyDataList[index].title!,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  dummyDataList[index].subTitle!.toUpperCase(),
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF939393),
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                  ),
                )
              ],
            )
            /*  .animate()
                .fadeIn(duration: 1200.ms, curve: Curves.easeOutQuad)
                .slideX(duration: 800.ms)*/
            ,
          ),
          Text(
            AppLocalizations.of(context)!.remove,
            style: GoogleFonts.poppins(
              color: orangeColor,
              fontSize: 11,
              fontWeight: FontWeight.w400,
            ),
          )
        ],
      ),
    )
        /* .animate()
        // .shimmer(blendMode: BlendMode.srcOver, color: myLoading.isDark?Colors.white:Colors.black)
        .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad)*/
        ;
  }
}
