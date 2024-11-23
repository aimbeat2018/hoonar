import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_social_share/custom_social_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/custom/snackbar_util.dart';
import 'package:provider/provider.dart';

import '../../../../constants/color_constants.dart';
import '../../../../constants/my_loading/my_loading.dart';
import '../../../../constants/theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectShareScreen extends StatefulWidget {
  final String videoUrl;
  final String videoThumbnail;

  const ConnectShareScreen(
      {super.key, required this.videoUrl, required this.videoThumbnail});

  @override
  State<ConnectShareScreen> createState() => _ConnectShareScreenState();
}

class _ConnectShareScreenState extends State<ConnectShareScreen> {
  final _share = CustomSocialShare();
  var _onlyInstalled = false;
  var _installedApps = <ShareWith>[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _share.getInstalledAppsForShare().then((value) {
        debugPrint("_MyAppState.build: $value");
        _installedApps = value;
        setState(() {});
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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
                SizedBox(height: screenHeight * 0.01), // Space from the top

                /* Container(
                  // width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: screenHeight * 0.35,
                  width: screenWidth * 0.5,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.videoThumbnail))),
                ),*/

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: screenHeight * 0.35,
                  width: screenWidth * 0.7,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    // Ensures the child respects the border radius
                    child: CachedNetworkImage(
                      imageUrl: widget.videoThumbnail,
                      fit: BoxFit.fill,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                Center(
                  child: GradientText(
                    AppLocalizations.of(context)!.shareThisVideo,
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: myLoading.isDark ? Colors.black : Colors.white,
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
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: myLoading.isDark
                        ? const Color(0x603F3F3F)
                        : const Color(0x153F3F3F),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.videoUrl,
                          textAlign: TextAlign.start,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color:
                                myLoading.isDark ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          copyToClipboard(context);
                        },
                        child: Icon(
                          Icons.copy,
                          color: myLoading.isDark ? Colors.white : Colors.black,
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(
                  height: 30,
                ),

                Text(
                  AppLocalizations.of(context)!.shareVia,
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: myLoading.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              _share
                                  .to(ShareWith.instagram, widget.videoUrl)
                                  .then((value) {
                                if (value == false) {
                                  SnackbarUtil.showSnackBar(
                                      context, 'App not installed');
                                }
                              });
                            },
                            child: Image.asset(
                              'assets/images/insta.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              _share
                                  .to(ShareWith.whatsapp, widget.videoUrl)
                                  .then((value) {
                                if (value == false) {
                                  SnackbarUtil.showSnackBar(
                                      context, 'App not installed');
                                }
                              });
                            },
                            child: Image.asset(
                              'assets/images/whatsapp.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              _share
                                  .to(ShareWith.x, widget.videoUrl)
                                  .then((value) {
                                if (value == false) {
                                  SnackbarUtil.showSnackBar(
                                      context, 'App not installed');
                                }
                              });
                            },
                            child: Image.asset(
                              'assets/images/twitter.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              _share
                                  .to(ShareWith.facebook, widget.videoUrl)
                                  .then((value) {
                                if (value == false) {
                                  SnackbarUtil.showSnackBar(
                                      context, 'App not installed');
                                }
                              });
                            },
                            child: Image.asset(
                              'assets/images/fb.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              _share
                                  .to(ShareWith.snapchat, widget.videoUrl)
                                  .then((value) {
                                if (value == false) {
                                  SnackbarUtil.showSnackBar(
                                      context, 'App not installed');
                                }
                              });
                            },
                            child: Image.asset(
                              'assets/images/snap.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {
                              _share.toAll(widget.videoUrl).then((value) {
                                if (value == false) {
                                  SnackbarUtil.showSnackBar(
                                      context, 'App not installed');
                                }
                              });
                            },
                            child: Image.asset(
                              'assets/images/more_share.png',
                              height: 60,
                              width: 60,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  void shareToSpecificApp(BuildContext context, String appPackageName) {}

  void copyToClipboard(BuildContext context) {
    Clipboard.setData(ClipboardData(text: widget.videoUrl)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Link copied to clipboard!"),
        ),
      );
    });
  }
}
