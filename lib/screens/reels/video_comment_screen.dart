import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/session_manager.dart';
import 'package:hoonar/providers/auth_provider.dart';
import 'package:hoonar/shimmerLoaders/vote_list_shimmer.dart';
import 'package:provider/provider.dart';

import '../../constants/common_widgets.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/slide_right_route.dart';
import '../../constants/utils.dart';
import '../../custom/snackbar_util.dart';
import '../../model/comment.dart';
import '../../model/request_model/list_common_request_model.dart';
import '../../model/success_models/profile_success_model.dart';
import '../../model/success_models/video_comment_list_model.dart';
import '../../providers/home_provider.dart';
import '../auth_screen/login_screen.dart';
import 'package:timeago/timeago.dart' as timeago;

class VideoCommentScreen extends StatefulWidget {
  final int postId;

  const VideoCommentScreen({super.key, required this.postId});

  @override
  State<VideoCommentScreen> createState() => VideoCommentScreenState();
}

class VideoCommentScreenState extends State<VideoCommentScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _replyController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();
  int? _selectedCommentIndex;
  List<VideoCommentListData> commentDataList = [];
  double _height = 450;
  SessionManager sessionManager = SessionManager();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    sessionManager.initPref();
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.position.pixels) {
          if (!isLoading) {
            getCommentList(context);
          }
        }
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getCommentList(context);
    });
  }

  void updateHeight(double height) {
    setState(() {
      _height = height;
    });
  }

  void _addReply(int commentIndex, String replyText) {
   /* setState(() {
      commentList[commentIndex].replies.add(Reply(
          username: 'CurrentUser', replyText: replyText, time: 'Just now'));
      _selectedCommentIndex = null; // Reset reply input focus
    });*/
    _replyController.clear();
  }

  Future<void> getCommentList(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel = ListCommonRequestModel(
          limit: paginationLimit,
          start: commentDataList.length == 10 ? commentDataList.length : 0,
          postId: widget.postId);

      await homeProvider.getCommentList(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.videoCommentLitModel?.status == '200') {
        } else if (homeProvider.videoCommentLitModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.videoCommentLitModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<void> addComment(BuildContext context, String comment) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    ListCommonRequestModel requestModel = ListCommonRequestModel(
        limit: paginationLimit,
        start: commentDataList.length == 10 ? commentDataList.length : 0,
        postId: widget.postId,
        comment: comment);
    await homeProvider.addComment(requestModel,
        sessionManager.getString(SessionManager.accessToken) ?? '');

    if (homeProvider.errorMessage != null) {
      SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
    } else {
      if (homeProvider.addPostModel?.status == '200') {
      } else if (homeProvider.addPostModel?.message == 'Unauthorized Access!') {
        SnackbarUtil.showSnackBar(
            context, homeProvider.addPostModel?.message! ?? '');
        Navigator.pushAndRemoveUntil(context,
            SlideRightRoute(page: const LoginScreen()), (route) => false);
      }
    }
  }

  Future<void> likeUnlikeComment(BuildContext context, String commentId) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel = ListCommonRequestModel(
        commentId: commentId,
        limit: paginationLimit,
        start: commentDataList.length == 10 ? commentDataList.length : 0,
        postId: widget.postId,
      );

      await homeProvider.likeUnlikeComment(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.likeUnlikeVideoModel?.status == '200') {
        } else if (homeProvider.likeUnlikeVideoModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.likeUnlikeVideoModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
    });
  }

  Future<void> deleteComment(BuildContext context, String commentId) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);

    sessionManager.initPref().then((onValue) async {
      ListCommonRequestModel requestModel = ListCommonRequestModel(
        commentId: commentId,
        limit: paginationLimit,
        start: commentDataList.length == 10 ? commentDataList.length : 0,
        postId: widget.postId,
      );

      await homeProvider.deleteComment(requestModel,
          sessionManager.getString(SessionManager.accessToken) ?? '');

      if (homeProvider.errorMessage != null) {
        SnackbarUtil.showSnackBar(context, homeProvider.errorMessage ?? '');
      } else {
        if (homeProvider.deleteCommentModel?.status == '200') {
        } else if (homeProvider.deleteCommentModel?.message ==
            'Unauthorized Access!') {
          SnackbarUtil.showSnackBar(
              context, homeProvider.deleteCommentModel?.message! ?? '');
          Navigator.pushAndRemoveUntil(context,
              SlideRightRoute(page: const LoginScreen()), (route) => false);
        }
      }
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
              Text(
                AppLocalizations.of(context)!.comments,
                style: GoogleFonts.poppins(
                    color: myLoading.isDark ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
              ),

              Expanded(
                child: ValueListenableBuilder<VideoCommentListModel?>(
                    valueListenable: homeProvider.commentListNotifier,
                    builder: (context, commentData, child) {
                      if (commentData == null) {
                        return VoteListShimmer();
                      } else {
                        commentDataList = commentData.data!;
                      }
                      return ListView.builder(
                        itemCount: commentDataList.length,
                        itemBuilder: (context, index) {
                          return _buildCommentItem(
                              commentDataList[index], index, myLoading.isDark);
                        },
                      );
                    }),
              ),
              // Reaction bar
              const SizedBox(height: 10),

              Align(
                alignment: Alignment.bottomLeft,
                child: AnimatedPadding(
                  padding: MediaQuery.of(context).viewInsets,
                  // You can change the duration and curve as per your requirement:
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.decelerate,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ValueListenableBuilder<ProfileSuccessModel?>(
                            valueListenable: Provider.of<AuthProvider>(context)
                                .profileNotifier,
                            builder: (context, profile, child) {
                              if (profile == null) {
                                return const SizedBox();
                              }
                              String initials =
                                  profile.data?.fullName != null ||
                                          profile.data?.fullName != ""
                                      ? profile.data!.fullName!
                                          .trim()
                                          .split(' ')
                                          .map((e) => e[0])
                                          .take(2)
                                          .join()
                                          .toUpperCase()
                                      : '';
                              return CircleAvatar(
                                radius: 18,
                                backgroundColor: myLoading.isDark
                                    ? Colors.grey.shade700
                                    : Colors.grey.shade200,
                                child: ClipOval(
                                  child: profile.data?.userProfile != ""
                                      ? CachedNetworkImage(
                                          imageUrl: profile.data!.userProfile!,
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              buildInitialsAvatar(initials,
                                                  fontSize: 12),
                                          fit: BoxFit.cover,
                                          width: 80,
                                          // Match the size of the CircleAvatar
                                          height: 80,
                                        )
                                      : buildInitialsAvatar(initials,
                                          fontSize: 12),
                                ),
                              );
                            }),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText:
                                  AppLocalizations.of(context)!.addAComment,
                              hintStyle:
                                  GoogleFonts.poppins(color: Colors.grey),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        homeProvider.isSearchLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              )
                            : IconButton(
                                icon: Icon(Icons.send,
                                    color: myLoading.isDark
                                        ? Colors.white
                                        : Colors.black),
                                onPressed: () {
                                  if (_commentController.text.isNotEmpty) {
                                    addComment(
                                        context, _commentController.text);
                                    _commentController.clear();
                                  }
                                },
                              ),
                      ],
                    ),
                  ),
                ),
              )
              // Add comment input
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCommentItem(
      VideoCommentListData comment, int commentIndex, bool isDarkMode) {
    String initials = comment.fullName != null || comment.fullName != ""
        ? comment.fullName!
            .trim()
            .split(' ')
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase()
        : '';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor:
                    isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
                child: ClipOval(
                  child: comment.userProfile != null
                      ? CachedNetworkImage(
                          imageUrl: comment.userProfile!,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              buildInitialsAvatar(initials, fontSize: 12),
                          fit: BoxFit.cover,
                          width: 80,
                          // Match the size of the CircleAvatar
                          height: 80,
                        )
                      : buildInitialsAvatar(initials, fontSize: 12),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onLongPress: () {
                    showDeleteDialog(
                        context, isDarkMode, comment.commentsId.toString());
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            comment.userName ?? '',
                            style: GoogleFonts.poppins(
                              color: isDarkMode ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            formatRelativeTime(comment.createdDate ?? ''),
                            style: GoogleFonts.poppins(
                                color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        comment.comment ?? '',
                        style: GoogleFonts.poppins(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontSize: 13),
                      ),
                      /*    Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedCommentIndex = commentIndex;
                                });
                              },
                              child: Text(AppLocalizations.of(context)!.reply,
                                  style: GoogleFonts.poppins(
                                      color: Colors.grey, fontSize: 12)),
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          if (comment.replies!.isNotEmpty)
                            Text(
                                '${comment.replies!.length} ${comment.replies!.length == 1 ? AppLocalizations.of(context)!.reply.toLowerCase() : AppLocalizations.of(context)!.replies}',
                                style: GoogleFonts.poppins(
                                    color: Colors.grey, fontSize: 12)),
                        ],
                      ),*/
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  likeUnlikeComment(context, comment.commentsId.toString());
                },
                child: Row(
                  children: [
                    Image.asset(
                      comment.isLiked == 0
                          ? 'assets/images/unlike.png'
                          : 'assets/images/like.png',
                      width: 20,
                      height: 20,
                    ),
                    /* Icon(Icons.favorite_border,
                        size: 18,
                        color: isDarkMode ? Colors.white : Colors.black),*/
                    const SizedBox(width: 5),
                    Text(comment.likesCount.toString(),
                        style: GoogleFonts.poppins(
                            color: isDarkMode ? Colors.white : Colors.black)),
                  ],
                ),
              ),
            ],
          ),
          // Replies Section
          /*if (comment.replies!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: ListView.builder(
                itemCount: comment.replies!.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, replyIndex) {
                  return _buildReplyItem(
                      comment.replies![replyIndex], isDarkMode);
                },
              ),
            ),
          // Reply input box for selected comment
          if (_selectedCommentIndex == commentIndex)
            _buildReplyInput(commentIndex),*/
        ],
      ),
    );
  }

  Widget _buildReplyItem(Replies reply, bool isDarkMode) {
    String initials = reply.fullName != null || reply.fullName != ""
        ? reply.fullName!
            .trim()
            .split(' ')
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase()
        : '';

    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor:
                isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200,
            child: ClipOval(
              child: reply.userProfile != null
                  ? CachedNetworkImage(
                      imageUrl: reply.userProfile!,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          buildInitialsAvatar(initials, fontSize: 12),
                      fit: BoxFit.cover,
                      width: 80,
                      // Match the size of the CircleAvatar
                      height: 80,
                    )
                  : buildInitialsAvatar(initials, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(reply.userName ?? '',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(reply.reply ?? '',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal, fontSize: 14)),
                ],
              ),
              Text(formatRelativeTime(reply.createdAt ?? ''),
                  style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReplyInput(int commentIndex) {
    return Padding(
      padding: const EdgeInsets.only(left: 40.0, top: 8.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 16.0, // size of the avatar
            backgroundImage: NetworkImage(
                'https://www.stylecraze.com/wp-content/uploads/2020/09/Beautiful-Women-In-The-World.jpg'), // or AssetImage('assets/avatar.png')
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _replyController,
              decoration: InputDecoration(
                hintText: "Add a reply...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (_replyController.text.isNotEmpty) {
                _addReply(commentIndex, _replyController.text);
              }
            },
          ),
        ],
      ),
    );
  }

  void showDeleteDialog(
      BuildContext context, bool isDarkMode, String commentId) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(
            AppLocalizations.of(context)!.deleteComment,
            style: GoogleFonts.poppins(
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          content: Text(
            AppLocalizations.of(context)!.areYouSureYouWantToDeleteComment,
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
                deleteComment(context, commentId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String formatRelativeTime(String dateTimeString) {
    // Parse the input date string
    DateTime dateTime = DateTime.parse(dateTimeString);

    // Convert to relative time
    return timeago.format(dateTime, locale: 'en');
  }
}
