import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../constants/common_widgets.dart';
import '../../constants/internet_connectivity.dart';
import '../../constants/session_manager.dart';
import '../../constants/slide_right_route.dart';
import '../../custom/data_not_found.dart';
import '../../custom/snackbar_util.dart';
import '../../model/request_model/list_common_request_model.dart';
import '../../../../model/success_models/sound_list_model.dart';
import '../../model/success_models/home_post_success_model.dart';
import '../../providers/home_provider.dart';
import '../auth_screen/login_screen.dart';
import '../hoonar_competition/create_upload_video/uploadVideo/upload_video_screen.dart';
import '../reels/reels_list_screen.dart';

class DraftsScreen extends StatefulWidget {
  final ScrollController controller;
  final List<PostsListData> draftList;
  final bool isDarkMode;
  final String from;

  const DraftsScreen(
      {super.key,
      required this.controller,
      required this.draftList,
      required this.isDarkMode,
      required this.from});

  @override
  State<DraftsScreen> createState() => _DraftsScreenState();
}

class _DraftsScreenState extends State<DraftsScreen> {
  SessionManager sessionManager = SessionManager();
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  Future<void> deletePost(BuildContext context, int postId, int index) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(postId: postId);

      await homeProvider.deletePost(
        context,
        requestModel,
        sessionManager.getString(SessionManager.accessToken) ?? '',
      );

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.deletePostModel?.status == '200') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.deletePostModel?.message! ?? '');
          setState(() {
            widget.draftList.removeAt(index);
          });
        } else if (homeProvider.deletePostModel?.status == '401') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.deletePostModel?.message! ?? '');
        } else if (homeProvider.deletePostModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.deletePostModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
    await Future.delayed(Duration(seconds: 2), () {
      // Navigator.pop(context);
      // Navigator.pop(context);
      Navigator.pop(context);
    });
  }

  void showDeleteDialog(
      BuildContext context, bool isDarkMode, int postId, int index) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            AppLocalizations.of(context)!.deleteVideo.toUpperCase(),
            style: GoogleFonts.poppins(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!.areYouSureYouWantToDeleteThisVideo,
            style: GoogleFonts.poppins(
              color: isDarkMode ? Colors.white70 : Colors.black87,
            ),
          ),
          actions: [
            CupertinoDialogAction(
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: GoogleFonts.poppins(
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: Text(
                AppLocalizations.of(context)!.delete,
                style: GoogleFonts.poppins(
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                // Navigator.pop(context1);
                deletePost(context, postId, index);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckInternet.initConnectivity().then((value) => setState(() {
          _connectionStatus = value;
        }));

    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      CheckInternet.updateConnectionStatus(result).then((value) => setState(() {
            _connectionStatus = value;
          }));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = screenWidth < 600 ? 3 : 4;
    return widget.draftList.isEmpty
        ? SizedBox(height: 120, child: DataNotFound())
        : SingleChildScrollView(
            controller: widget.controller,
            child: GridView.builder(
              controller: widget.controller,
              shrinkWrap: true,
              // controller: gridScrollController,
              padding: const EdgeInsets.all(0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 0,
                mainAxisSpacing: 2,
                childAspectRatio: 0.6,
              ),
              itemCount: /*homeProvider
                                          .postListSuccessModel!.data!*/
                  widget.draftList.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onLongPress: widget.from == 'main'
                      ? () {
                          showDeleteDialog(context, widget.isDarkMode,
                              widget.draftList[index].postId!, index);
                          // deletePost(context, widget.draftList[index].postId!, index);
                        }
                      : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      SlideRightRoute(
                          page: ReelsListScreen(
                        postList: widget.draftList,
                        index: index,
                      )),
                    );
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: widget.draftList[index].postImage ?? '',

                        placeholder: (context, url) => Center(
                          child: SizedBox(
                              height: 15,
                              width: 15,
                              child: const CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) =>
                            buildInitialsAvatar('No Image', fontSize: 12),
                        fit: BoxFit.cover,
                        width: 80,
                        // Match the size of the CircleAvatar
                        height: 80,
                      ),
                      Positioned(
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            // SoundList soundListModel = SoundList(
                            //     soundTitle:
                            //         widget.draftList[index].soundTitle ?? '',
                            //     duration:
                            //         widget.draftList[index].duration ?? '',
                            //     soundImage:
                            //         widget.draftList[index].soundImage ?? '',
                            //     soundId:
                            //         int.parse(widget.draftList[index].soundId!),
                            //     sound: widget.draftList[index].sound ?? '');

                            Navigator.push(
                              context,
                              SlideRightRoute(
                                page: UploadVideoScreen(
                                  videoThumbnail:
                                      widget.draftList[index].postImage ?? '',
                                  postId: widget.draftList[index].postId,
                                  from: "feed",
                                  selectedMusic: null,
                                  videoUrl:
                                      widget.draftList[index].postVideo ?? '',
                                  caption:
                                      widget.draftList[index].postDescription ??
                                          '',
                                  hashTag:
                                      widget.draftList[index].postHashTag ?? '',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(5),
                            margin: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.black
                                  .withAlpha(96), // Background color
                              shape: BoxShape.circle, // Circular shape
                            ),
                            child: Icon(Icons.edit, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );

    /* return CustomScrollView(
      controller: widget.controller,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      slivers: [
        // Other slivers...
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            childAspectRatio: 0.55,
          ),
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    SlideRightRoute(
                        page: ReelsListScreen(
                      postList: widget.draftList,
                      index: index,
                    )),
                  );
                },
                child: CachedNetworkImage(
                  imageUrl: widget.draftList[index].postImage ?? '',

                  placeholder: (context, url) => Center(
                    child: SizedBox(
                        height: 15,
                        width: 15,
                        child: const CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) =>
                      buildInitialsAvatar('No Image', fontSize: 12),
                  fit: BoxFit.cover,
                  width: 80,
                  // Match the size of the CircleAvatar
                  height: 80,
                ),
              );
            },
            childCount: widget.draftList.length,
          ),
        ),
        // Other slivers...
      ],
    );*/
  }
}
