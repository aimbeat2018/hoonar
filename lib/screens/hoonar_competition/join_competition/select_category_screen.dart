import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/hoonar_competition/join_competition/select_contest_level.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/slide_right_route.dart';
import '../../../custom/snackbar_util.dart';
import '../../../model/star_category_model.dart';
import '../../../providers/home_provider.dart';
import '../../auth_screen/login_screen.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({super.key});

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
  List<StarCategoryModel> starCategoryModelList = [
    StarCategoryModel('assets/dark_mode_icons/dance.png', 'Dance',
        'assets/light_mode_icons/dance_light.png'),
    StarCategoryModel('assets/dark_mode_icons/vocals.png', 'Vocals',
        'assets/light_mode_icons/vocals_light.png'),
    StarCategoryModel('assets/dark_mode_icons/raps.png', 'raps',
        'assets/light_mode_icons/raps_light.png'),
    StarCategoryModel('assets/dark_mode_icons/poetry.png', 'Poetry',
        'assets/light_mode_icons/poetry_light.png'),
    StarCategoryModel('assets/dark_mode_icons/modelling.png', 'Modeling',
        'assets/light_mode_icons/modelling_light.png'),
    StarCategoryModel('assets/dark_mode_icons/show_skills.png', 'Smart Skills',
        'assets/light_mode_icons/show_skills_light.png'),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCategoryList(context);
    });
  }

  Future<void> getCategoryList(BuildContext context) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    await homeProvider.getCategoryList();

    if (homeProvider.errorMessage != null) {
      SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
    } else {
      if (homeProvider.categoryListSuccessModel?.status == '200') {
      } else if (homeProvider.categoryListSuccessModel?.message ==
          'Unauthorized Access!') {
        SnackbarUtil.showSnackBar(
            context, homeProvider.categoryListSuccessModel?.message! ?? '');
        Navigator.pushAndRemoveUntil(
            context, SlideRightRoute(page: LoginScreen()), (route) => false);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    // Set number of columns based on screen width
    int crossAxisCount = screenWidth < 600 ? 2 : 3;

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
            child: SafeArea(
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
                  Text(
                    AppLocalizations.of(context)!.chooseYourStarCategory,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: myLoading.isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 10,
                      childAspectRatio:
                          0.9, // Adjust according to image dimensions
                    ),
                    itemCount: starCategoryModelList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            SlideRightRoute(page: SelectContestLevel()),
                          );
                        },
                        child: Card(
                          elevation: 5,
                          shadowColor: myLoading.isDark
                              ? const Color(0xFF3F3F3F)
                              : Color(0x253F3F3F),
                          color: myLoading.isDark
                              ? const Color(0xFF3F3F3F)
                              : Color(0x253F3F3F),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Image.asset(
                                myLoading.isDark
                                    ? starCategoryModelList[index]
                                        .lightModeImage!
                                    : starCategoryModelList[index]
                                        .darkModeImage!,
                                height: 120,
                                width: 150,
                              ),
                              Text(
                                starCategoryModelList[index].name!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: myLoading.isDark
                                      ? Colors.white
                                      : Colors.black,
                                  fontWeight: FontWeight.w500,
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
      );
    });
  }
}
