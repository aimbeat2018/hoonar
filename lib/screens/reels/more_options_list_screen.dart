import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/providers/home_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../model/star_category_model.dart';

class MoreOptionsListScreen extends StatefulWidget {
  final int postId;

  const MoreOptionsListScreen({super.key, required this.postId});

  @override
  State<MoreOptionsListScreen> createState() => _MoreOptionsListScreenState();
}

class _MoreOptionsListScreenState extends State<MoreOptionsListScreen>
    with SingleTickerProviderStateMixin {
  double _height = 250;

  List<StarCategoryModel> optionsList = [];

  void updateHeight(double height) {
    setState(() {
      _height = height;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      optionsList = [
        StarCategoryModel("", AppLocalizations.of(context)!.interested, ''),
        StarCategoryModel('', AppLocalizations.of(context)!.not_interested, ''),
        StarCategoryModel('', AppLocalizations.of(context)!.report, ''),
      ];
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final homeProvider = Provider.of<HomeProvider>(context);

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: keyboardHeight > 0 ? _height + keyboardHeight : _height,
          child: Column(
            children: [
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          color: myLoading.isDark ? Colors.white60 : Colors.grey,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          optionsList[0].name!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: myLoading.isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                          color: myLoading.isDark ? Colors.white60 : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5.0, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.visibility_off_outlined,
                          color: myLoading.isDark ? Colors.white60 : Colors.grey,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          optionsList[1].name!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: myLoading.isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                          color: myLoading.isDark ? Colors.white60 : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical:5.0, horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.report_gmailerrorred,
                          color: myLoading.isDark ? Colors.red : Colors.red,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          optionsList[2].name!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: myLoading.isDark ? Colors.red : Colors.red,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 15,
                          color: myLoading.isDark ? Colors.red : Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              /*  ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: optionsList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.visibility),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              optionsList[index].name!,
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
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              )*/
            ],
          ),
        ),
      );
    });
  }
}
