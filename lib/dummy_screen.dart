import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DummyScreen extends StatefulWidget {
  const DummyScreen({super.key});

  @override
  State<DummyScreen> createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bottom Sheet Example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent, // For rounded corners
              builder: (context) => _buildBottomSheet(context),
              isScrollControlled: true,
            );
          },
          child: Text("Show Bottom Sheet"),
        ),
      ),
    );
  }

  Widget _buildBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5, // Initial size of the BottomSheet
      maxChildSize: 0.9, // Max size of the BottomSheet
      minChildSize: 0.3, // Min size of the BottomSheet
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.black, // Adjust as per your theme
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.grey[600],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              // Comments section
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    // _buildComment(
                    //   "divn.edits",
                    //   "Presets available in bio 🙌❤️",
                    //   "6h",
                    //   56,
                    // ),
                    // _buildComment(
                    //   "divn.edits",
                    //   "Colorgrade using Preset pack. Name: C Crimson green.",
                    //   "20h",
                    //   347,
                    // ),
                    Html(
                      data:
                          '<p><br></p><table class=\\"table table-bordered\\"><tbody><tr><td><p><img src=\\"https://atrussama.com/maaj_maval//resources/uploads/complaint_images/banner3.png\\" style=\\"width: 1018.81px;\\"><br></p></td><td>To ensure that the uploaded images are saved properly in your database alongside the description, you need to modify your <code>store_info</code> method to include the image URL in the data being inserted. Here’s how you can do it:<br></td></tr></tbody></table><table class=\\"table table-bordered\\"><tbody><tr><td><p><img src=\\"https://atrussama.com/maaj_maval//resources/uploads/complaint_images/banner2.png\\" style=\\"width: 1018.81px;\\"><br></p></td><td>To ensure that the uploaded images are saved properly in your database alongside the description, you need to modify your <code>store_info</code> method to include the image URL in the data being inserted. Here’s how you can do it:<br></td></tr></tbody></table>',
                      style: {
                        "table": Style(
                          width: Width.auto(),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                        "th": Style(
                          padding: HtmlPaddings.all(10),
                          backgroundColor: Colors.grey[200],
                        ),
                        "td": Style(
                          padding: HtmlPaddings.all(10),
                          border: Border.all(color: Colors.black, width: 1),
                        ),
                      },
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              // Reaction bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildReactionButton(Icons.favorite, Colors.red),
                    _buildReactionButton(Icons.handshake, Colors.yellow),
                    _buildReactionButton(
                        Icons.local_fire_department, Colors.orange),
                    _buildReactionButton(Icons.emoji_people, Colors.yellow),
                    _buildReactionButton(
                        Icons.emoji_emotions_outlined, Colors.yellow),
                    _buildReactionButton(Icons.face, Colors.yellow),
                    _buildReactionButton(Icons.card_giftcard, Colors.purple),
                  ],
                ),
              ),
              SizedBox(height: 10),
              // Add comment input
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/profile_image.png'),
                      // Add user profile image
                      radius: 18,
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
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
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 5),
                    Text(
                      time,
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Text(
                  comment,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.favorite_border, size: 18, color: Colors.white),
                    SizedBox(width: 5),
                    Text(likes.toString(),
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget for reaction buttons (emoji)
  Widget _buildReactionButton(IconData icon, Color color) {
    return IconButton(
      icon: Icon(icon, color: color, size: 30),
      onPressed: () {
        // Handle reactions
      },
    );
  }
}
