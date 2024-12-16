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
                  widget.hoonarStarList.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
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
            ),
          );

    /* CustomScrollView(
      controller: widget.controller,
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
    );*/
  }
}
