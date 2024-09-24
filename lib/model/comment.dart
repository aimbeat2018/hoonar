class Reply {
  final String username;
  final String replyText;
  final String time;

  Reply({required this.username, required this.replyText, required this.time});
}

class Comment {
  final String username;
  final String commentText;
  final String time;
  List<Reply> replies;

  Comment({required this.username, required this.commentText, required this.time, this.replies = const []});
}
