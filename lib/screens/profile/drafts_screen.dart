import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/common_widgets.dart';
import '../../constants/slide_right_route.dart';
import '../../custom/data_not_found.dart';
import '../../model/success_models/home_post_success_model.dart';
import '../reels/reels_list_screen.dart';

class DraftsScreen extends StatefulWidget {
  final ScrollController controller;
  final List<PostsListData> draftList;

  const DraftsScreen(
      {super.key, required this.controller, required this.draftList});

  @override
  State<DraftsScreen> createState() => _DraftsScreenState();
}

class _DraftsScreenState extends State<DraftsScreen> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;

    // Set number of columns based on screen width
    int crossAxisCount = screenWidth < 600 ? 3 : 4;
    return widget.draftList.isEmpty
        ? SizedBox(height: 120, child: DataNotFound())
        : SingleChildScrollView(
            controller: widget.controller,
            child: GridView.builder(
              controller: widget.controller,
              shrinkWrap: true,
              // controller: gridScrollController,
              padding: const EdgeInsets.all(8),
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
            ),
          );
  }
}
