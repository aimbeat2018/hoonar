import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../constants/my_loading/my_loading.dart';

class DataNotFound extends StatelessWidget {
  const DataNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, MyLoading myLoading, child) => SizedBox(
        height: MediaQuery.of(context).size.width,
        width: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /* Container(
                height: 55,
                child: Image(
                  image: AssetImage(
                    myLoading.isDark ? icLogo : icLogoLight,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),*/
              Text(
                AppLocalizations.of(context)!.noDataFound,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: myLoading.isDark ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
