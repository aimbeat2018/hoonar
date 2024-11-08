import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hoonar/custom/data_not_found.dart';

import '../../constants/common_widgets.dart';
import '../../constants/slide_right_route.dart';
import '../../model/success_models/home_post_success_model.dart';
import '../reels/reels_list_screen.dart';

class HoonarStarScreen extends StatefulWidget {
  final ScrollController controller;
  final List<PostsListData> hoonarStarList;

  const HoonarStarScreen(
      {super.key, required this.controller, required this.hoonarStarList});

  @override
  State<HoonarStarScreen> createState() => _HoonarStarScreenState();
}

class _HoonarStarScreenState extends State<HoonarStarScreen> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    // Set number of columns based on screen width
    int crossAxisCount = screenWidth < 600 ? 3 : 4;
    return widget.hoonarStarList.isEmpty
        ? SizedBox(
            height: 120,
            child: DataNotFound())
        : CustomScrollView(
            controller: widget.controller,
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
                            postList: widget.hoonarStarList,
                            index: index,
                          )),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: widget.hoonarStarList[index].postImage ?? '',

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
                  childCount: widget.hoonarStarList.length,
                ),
              ),
              // Other slivers...
            ],
          );
  }
}
