import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/screens/hoonar_competition/join_competition/select_contest_level.dart';
import 'package:provider/provider.dart';

import '../../../constants/common_widgets.dart';
import '../../../constants/key_res.dart';
import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/slide_right_route.dart';
import '../../../custom/data_not_found.dart';
import '../../../custom/snackbar_util.dart';
import '../../../providers/home_provider.dart';
import '../../../shimmerLoaders/contest_category_shimmer.dart';
import '../../auth_screen/login_screen.dart';

class SelectCategoryScreen extends StatefulWidget {
  const SelectCategoryScreen({super.key});

  @override
  State<SelectCategoryScreen> createState() => _SelectCategoryScreenState();
}

class _SelectCategoryScreenState extends State<SelectCategoryScreen> {
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
    final homeProvider = Provider.of<HomeProvider>(context);

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
                  homeProvider.isCategoryLoading ||
                          homeProvider.categoryListSuccessModel == null
                      ? ContestCategoryShimmer()
                      : homeProvider.categoryListSuccessModel!.data == null ||
                              homeProvider
                                  .categoryListSuccessModel!.data!.isEmpty
                          ? DataNotFound()
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 15,
                                mainAxisSpacing: 10,
                                childAspectRatio:
                                    0.9, // Adjust according to image dimensions
                              ),
                              itemCount: homeProvider
                                  .categoryListSuccessModel!.data!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    if (mounted) {
                                      setState(() {
                                        KeyRes.selectedCategoryId = homeProvider
                                            .categoryListSuccessModel!
                                            .data![index]
                                            .categoryId!;
                                      });
                                    }
                                    Navigator.push(
                                      context,
                                      SlideRightRoute(
                                          page: SelectContestLevel(
                                        categoryId: homeProvider
                                            .categoryListSuccessModel!
                                            .data![index]
                                            .categoryId,
                                        categoryName: homeProvider
                                                .categoryListSuccessModel!
                                                .data![index]
                                                .categoryName ??
                                            '',
                                      )),
                                    );
                                  },
                                  child: Card(
                                    elevation: 5,
                                    shadowColor: myLoading.isDark
                                        ? const Color(0xFF3F3F3F)
                                        : /*Color(0x253F3F3F)*/ Colors.white,
                                    color: myLoading.isDark
                                        ? const Color(0xFF3F3F3F)
                                        : /*Color(0x253F3F3F)*/ Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: myLoading.isDark
                                              ? homeProvider
                                                  .categoryListSuccessModel!
                                                  .data![index]
                                                  .imageUrl!
                                              : homeProvider
                                                  .categoryListSuccessModel!
                                                  .data![index]
                                                  .darkImageUrl!,
                                          placeholder: (context, url) => Center(
                                            child: SizedBox(
                                                height: 15,
                                                width: 15,
                                                child:
                                                    const CircularProgressIndicator()),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              buildInitialsAvatar('No Image',
                                                  fontSize: 12),
                                          fit: BoxFit.cover,
                                          height: 120,
                                          width: 150,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          homeProvider.categoryListSuccessModel!
                                              .data![index].categoryName!,
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
