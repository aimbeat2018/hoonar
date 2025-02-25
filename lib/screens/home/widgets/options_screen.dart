import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../constants/session_manager.dart';
import '../../../model/success_models/home_post_success_model.dart';

class OptionsScreen extends StatefulWidget {
  final PostsListData? model;

  const OptionsScreen({super.key, this.model});

  @override
  State<OptionsScreen> createState() => _OptionsScreenState();
}

class _OptionsScreenState extends State<OptionsScreen> {
  SessionManager sessionManager = SessionManager();

  // int modelLikeStatus = 0;

  @override
  void initState() {
    super.initState();
    sessionManager.initPref();
    // setState(() {
    //   modelLikeStatus = widget.model!.videoLikesOrNot ?? 0;
    // });
  }

  /* Future<void> likeUnlikeVideo(BuildContext context, int postId) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel =
          ListCommonRequestModel(postId: postId);

      await homeProvider.likeUnlikeVideo(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.likeUnlikeVideoModel?.status == '200') {
          if (homeProvider.likeUnlikeVideoModel?.message ==
              'Post Unlike Successful') {
            setState(() {
              modelLikeStatus = 0;
            });
          } else {
            setState(() {
              modelLikeStatus = 1;
            });
          }
        } else if (homeProvider.likeUnlikeVideoModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.likeUnlikeVideoModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/images/vote_not_given.png',
                    // 'assets/images/vote_given.png',
                    height: 20,
                    width: 20,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    AppLocalizations.of(context)!.votes,
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Image.asset(
                    /*modelLikeStatus == 0
                        ? */'assets/images/unlike.png'
                       /* : 'assets/images/like.png'*/,
                    scale: 7,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    AppLocalizations.of(context)!.likes,
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/images/comment.png',
                    scale: 7,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    AppLocalizations.of(context)!.comments,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Column(
                children: [
                  Image.asset(
                    'assets/images/share.png',
                    scale: 7,
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Text(
                    AppLocalizations.of(context)!.share,
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
