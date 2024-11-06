import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:hoonar/screens/reels/reels_widget.dart';
import 'package:provider/provider.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/text_constants.dart';
import '../../model/slider_model.dart';
import '../../model/success_models/home_post_success_model.dart';
import '../../model/success_models/post_list_success_model.dart';

class ReelsListScreen extends StatefulWidget {
  final List<PostsListData>? postList;
  final int? index;

  const ReelsListScreen({super.key, this.postList, this.index});

  @override
  State<ReelsListScreen> createState() => _ReelsListScreenState();
}

class _ReelsListScreenState extends State<ReelsListScreen> {
  final controller = SwiperController();
  int? currentIndex;
  bool hasSwiped = false; // Flag to track if the user has swiped

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Swiper(
                controller: controller,
                itemBuilder: (BuildContext context, int index) {
                  int displayIndex = hasSwiped ? index : currentIndex!;

                  return ReelsWidget(
                    model: widget.postList![displayIndex],
                  );
                },
                itemCount: widget.postList!.length,
                scrollDirection: Axis.vertical,
                onIndexChanged: (index) {
                  setState(() {
                    hasSwiped = true;
                    currentIndex =
                        index;
                  });
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: 13, top: 15),
                    child: Image.asset(
                      'assets/images/back_image.png',
                      height: 28,
                      width: 28,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
