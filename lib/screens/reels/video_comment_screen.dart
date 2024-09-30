import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../model/comment.dart';

class VideoCommentScreen extends StatefulWidget {
  const VideoCommentScreen({super.key});

  @override
  State<VideoCommentScreen> createState() => VideoCommentScreenState();
}

class VideoCommentScreenState extends State<VideoCommentScreen>
    with SingleTickerProviderStateMixin {
  List<Comment> commentList = [
    Comment(
      username: 'user1',
      commentText: 'Amazing photo!',
      time: '2h',
      replies: [Reply(username: 'user2', replyText: 'Thanks!', time: '1h')],
    ),
    Comment(
      username: 'user3',
      commentText: 'Love this!',
      time: '4h',
      replies: [],
    ),
  ];

  TextEditingController _replyController = TextEditingController();
  int? _selectedCommentIndex;

  double _height = 450;

  void updateHeight(double height) {
    setState(() {
      _height = height;
    });
  }

  void _addReply(int commentIndex, String replyText) {
    setState(() {
      commentList[commentIndex].replies.add(Reply(
          username: 'CurrentUser', replyText: replyText, time: 'Just now'));
      _selectedCommentIndex = null; // Reset reply input focus
    });
    _replyController.clear();
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return SafeArea(
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
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
                child: ListView.builder(
                  itemCount: commentList.length,
                  itemBuilder: (context, index) {
                    return _buildCommentItem(
                        commentList[index], index, myLoading.isDark);
                  },
                ),
              ),
              // Reaction bar
              SizedBox(height: 10),
              // Add comment input
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18.0, // size of the avatar
                      backgroundImage: NetworkImage(
                          'https://img.freepik.com/free-photo/portrait-beautiful-indian-woman_23-2150913228.jpg'), // or AssetImage('assets/avatar.png')
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)!.addAComment,
                          hintStyle: GoogleFonts.poppins(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send,
                          color:
                              myLoading.isDark ? Colors.white : Colors.black),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildCommentItem(Comment comment, int commentIndex, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.0, // size of the avatar
                backgroundImage: NetworkImage(
                    'https://static.vecteezy.com/system/resources/thumbnails/037/807/836/small_2x/ai-generated-ambitious-corporate-indian-businesswoman-photo.jpg'), // or AssetImage('assets/avatar.png')
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.username,
                          style: GoogleFonts.poppins(
                            color: isDarkMode ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 5),
                        Text(
                          comment.time,
                          style: GoogleFonts.poppins(
                              color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(
                      comment.commentText,
                      style: GoogleFonts.poppins(
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontSize: 13),
                    ),
                    Row(
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
                        SizedBox(
                          width: 20,
                        ),
                        if (comment.replies.isNotEmpty)
                          Text(
                              '${comment.replies.length} ${comment.replies.length == 1 ? AppLocalizations.of(context)!.reply.toLowerCase() : AppLocalizations.of(context)!.replies}',
                              style: GoogleFonts.poppins(
                                  color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.favorite_border,
                      size: 18,
                      color: isDarkMode ? Colors.white : Colors.black),
                  SizedBox(width: 5),
                  Text(20.toString(),
                      style: GoogleFonts.poppins(
                          color: isDarkMode ? Colors.white : Colors.black)),
                ],
              ),
            ],
          ),
          // Replies Section
          if (comment.replies.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: ListView.builder(
                itemCount: comment.replies.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, replyIndex) {
                  return _buildReplyItem(comment.replies[replyIndex]);
                },
              ),
            ),
          // Reply input box for selected comment
          if (_selectedCommentIndex == commentIndex)
            _buildReplyInput(commentIndex),
        ],
      ),
    );
  }

  Widget _buildReplyItem(Reply reply) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16.0, // size of the avatar
            backgroundImage: NetworkImage(
                'https://www.stylecraze.com/wp-content/uploads/2020/09/Beautiful-Women-In-The-World.jpg'), // or AssetImage('assets/avatar.png')
          ),
          SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(reply.username,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  SizedBox(width: 4),
                  Text(reply.replyText,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal, fontSize: 14)),
                ],
              ),
              Text(reply.time,
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
          CircleAvatar(
            radius: 16.0, // size of the avatar
            backgroundImage: NetworkImage(
                'https://www.stylecraze.com/wp-content/uploads/2020/09/Beautiful-Women-In-The-World.jpg'), // or AssetImage('assets/avatar.png')
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _replyController,
              decoration: InputDecoration(
                hintText: "Add a reply...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
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

// Widget for each comment item
  Widget _buildComment(
      String username, String comment, String time, int likes) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile_image.png'),
            // Replace with user's profile image
            radius: 18,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      username,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      time,
                      style:
                          GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  comment,
                  style: GoogleFonts.poppins(color: Colors.white),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.favorite_border, size: 18, color: Colors.white),
                    SizedBox(width: 5),
                    Text(likes.toString(),
                        style: GoogleFonts.poppins(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
