import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/text_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../constants/my_loading/my_loading.dart';

class VotesScreen extends StatefulWidget {
  const VotesScreen({super.key});

  @override
  State<VotesScreen> createState() => _VotesScreenState();
}

class _VotesScreenState extends State<VotesScreen> {
  bool isFollow = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Zone Level',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'dance',
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
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              children: [
                TextSpan(
                  text: '1234',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' ${AppLocalizations.of(context)!.votes}',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF939393),
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        /*.animate()
        // .shimmer(blendMode: BlendMode.srcOver, color: Colors.white12)
        .move(begin: const Offset(-16, 0), curve: Curves.easeOutQuad)*/
        ;
  }
}
