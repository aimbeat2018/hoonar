import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/common_widgets.dart';
import '../../constants/session_manager.dart';
import '../../constants/slide_right_route.dart';
import '../../custom/data_not_found.dart';
import '../../custom/snackbar_util.dart';
import '../../model/request_model/list_common_request_model.dart';
import '../../model/success_models/home_post_success_model.dart';
import '../../providers/home_provider.dart';
import '../auth_screen/login_screen.dart';
import '../reels/reels_list_screen.dart';

class FeedScreen extends StatefulWidget {
  final ScrollController controller;
  final List<PostsListData> feedsList;
  final bool isDarkMode;
  final String from;

  const FeedScreen(
      {super.key,
      required this.controller,
      required this.feedsList,
      required this.isDarkMode,
      required this.from});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  SessionManager sessionManager = SessionManager();

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
            widget.feedsList.removeAt(index);
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
    await Future.delayed(const Duration(seconds: 2), () {
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
            AppLocalizations.of(context)!.deleteVideo,
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
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    int crossAxisCount = screenWidth < 600 ? 3 : 4;
    return widget.feedsList.isEmpty
        ? const SizedBox(height: 120, child: DataNotFound())
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
                  widget.feedsList.length,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onLongPress: widget.from == 'main'
                      ? () {
                          showDeleteDialog(context, widget.isDarkMode,
                              widget.feedsList[index].postId!, index);
                          // deletePost(context, widget.feedsList[index].postId!, index);
                        }
                      : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      SlideRightRoute(
                          page: ReelsListScreen(
                        postList: widget.feedsList,
                        index: index,
                      )),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: widget.feedsList[index].postImage ?? '',

                    placeholder: (context, url) => const Center(
                      child: SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator()),
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
                      postList: widget.feedsList,
                      index: index,
                    )),
                  );
                },
                child: CachedNetworkImage(
                  imageUrl: widget.feedsList[index].postImage ?? '',

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
            childCount: widget.feedsList.length,
          ),
        ),
        // Other slivers...
      ],
    );*/
  }
}
