import 'dart:ui';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/text_constants.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog(
      {Key? key,
      required this.title1,
      required this.title2,
      required this.onPositiveTap,
      required this.aspectRatio,
      this.positiveText,
      this.isDarkMode})
      : super(key: key);

  final String title1;
  final String title2;
  final VoidCallback onPositiveTap;
  final double aspectRatio;
  final bool? isDarkMode;
  final String? positiveText;

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: isDarkMode! ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                const Spacer(),
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 8),
                      child: Text(
                        title1,
                        style: GoogleFonts.poppins(
                            color: isDarkMode! ? Colors.white : Colors.black,
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        title2,
                        style: GoogleFonts.poppins(
                          color: isDarkMode! ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                          color: isDarkMode!
                              ? Colors.white.withOpacity(0.8)
                              : Colors.grey,
                          width: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Directionality.of(context) ==
                                          TextDirection.rtl
                                      ? (isDarkMode!
                                          ? Colors.transparent
                                          : Colors.grey.shade50)
                                      : (isDarkMode!
                                          ? Colors.white.withOpacity(0.8)
                                          : Colors.grey.shade500),
                                  width: 0.5,
                                ),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  color: isDarkMode!
                                      ? Colors.white
                                      : Colors.black),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: onPositiveTap,
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Directionality.of(context) !=
                                          TextDirection.rtl
                                      ? Colors.transparent
                                      : Colors.white.withOpacity(0.8),
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Text(
                              positiveText ?? AppLocalizations.of(context)!.yes,
                              style: GoogleFonts.poppins(
                                  fontSize: 17, color: Colors.pink),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
