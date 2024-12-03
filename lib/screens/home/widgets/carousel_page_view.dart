import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hoonar/constants/slide_right_route.dart';
import 'package:hoonar/screens/home/widgets/options_screen.dart';
import 'package:hoonar/screens/reels/reels_list_screen.dart';
import 'package:provider/provider.dart';

import '../../../constants/common_widgets.dart';
import '../../../model/success_models/home_post_success_model.dart';
import '../../../providers/user_provider.dart';

class CarouselPageView extends StatefulWidget {
  final List<PostsListData> sliderModelList;
  final bool isDarkMode;

  const CarouselPageView(
      {super.key, required this.sliderModelList, required this.isDarkMode});

  @override
  _CarouselPageViewState createState() => _CarouselPageViewState();
}

class _CarouselPageViewState extends State<CarouselPageView>
    with SingleTickerProviderStateMixin {
  int activePage = 1;
  int previousPage = 0;
  bool isLoading = false;
  bool isFollowLoading = false;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  void initState() {
    super.initState();
  }

  Widget buildVideoWidget(
      PostsListData data,
      /*ChewieController chewieController,
      VideoPlayerController videoController,*/
      String initials) {
    return Container(
      width: 250,
      decoration: BoxDecoration(
        color: Colors.black,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                SlideRightRoute(
                  page: ReelsListScreen(
                    postList: widget.sliderModelList,
                    index: widget.sliderModelList.indexOf(data),
                  ),
                ),
              );
            },
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: 250,
                height: 250,
                child: Image.network(
                  data.postImage!,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          buildVideoOverlay(data),
        ],
      ),
    );
  }

  Widget buildVideoOverlay(PostsListData data) {
    final initials = (data.fullName ?? '').trim().isNotEmpty
        ? data.fullName!
            .split(' ')
            .map((e) => e[0])
            .take(2)
            .join()
            .toUpperCase()
        : '';

    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            buildProfileAndFollow(data, initials),
            Flexible(child: OptionsScreen(model: data)),
            const SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  Widget buildProfileAndFollow(PostsListData data, String initials) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Expanded(
      flex: 3,
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: widget.isDarkMode
                    ? Colors.grey.shade700
                    : Colors.grey.shade200,
                child: ClipOval(
                  child: data.userProfile?.isNotEmpty == true
                      ? CachedNetworkImage(
                          imageUrl: data.userProfile!,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              buildInitialsAvatar(initials, fontSize: 10),
                          fit: BoxFit.cover,
                          width: 20,
                          height: 20,
                        )
                      : buildInitialsAvatar(initials, fontSize: 10),
                ),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  data.userName ?? '',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis, // Ensure text truncation
                ),
              ),
              const SizedBox(width: 5),
              buildFollowButton(data, userProvider),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFollowButton(PostsListData data, UserProvider userProvider) {
    return Flexible(
      child: ValueListenableBuilder<int?>(
        valueListenable: userProvider.followStatusNotifier,
        builder: (context, followStatus, child) {
          final isFollowing = data.followOrNot == 1 || followStatus == 1;

          return Container(
            margin: const EdgeInsets.only(left: 5),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isFollowing ? Colors.white : Colors.transparent,
                width: 1,
              ),
              color: isFollowing ? Colors.transparent : Colors.white,
            ),
            child: isFollowLoading
                ? const Center(child: CircularProgressIndicator())
                : Text(
                    isFollowing
                        ? AppLocalizations.of(context)!.unfollow
                        : AppLocalizations.of(context)!.follow,
                    style: GoogleFonts.poppins(
                      fontSize: 8,
                      color: isFollowing ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : CarouselSlider.builder(
            carouselController: _carouselController,
            itemCount: widget.sliderModelList.length,
            itemBuilder: (BuildContext context, int index, int realIndex) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _carouselController
                        .animateToPage(index); // Navigate to tapped item
                  });
                },
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          SlideRightRoute(
                            page: ReelsListScreen(
                              postList: widget.sliderModelList,
                              index: index,
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        // Add rounded corners
                        child: Image.network(
                          widget.sliderModelList[index].postImage!,
                          fit: BoxFit
                              .cover, // Properly fills the available space
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            ); // Show a loader while the image loads
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(Icons.error,
                                  size: 50, color: Colors.red),
                            ); // Show an error icon if the image fails to load
                          },
                        ),
                      ),
                    ),
                    buildVideoOverlay(widget.sliderModelList[index]),
                    // Overlay for videos
                  ],
                ),
              );
            },
            options: CarouselOptions(
              enlargeCenterPage: true,
              height: MediaQuery.of(context).size.height * 0.48,
              viewportFraction: 0.7,
              enlargeStrategy: CenterPageEnlargeStrategy.zoom,
              onPageChanged: (index, reason) {
                setState(() {
                  // Update the index if needed for additional state tracking
                });
              },
            ),
          );
  }
}
