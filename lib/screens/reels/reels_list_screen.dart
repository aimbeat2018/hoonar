import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:hoonar/screens/reels/reels_widget.dart';

import '../../constants/common_widgets.dart';
import '../../constants/text_constants.dart';
import '../../model/slider_model.dart';
import '../home/widgets/reels_screen.dart';

class ReelsListScreen extends StatefulWidget {
  const ReelsListScreen({super.key});

  @override
  State<ReelsListScreen> createState() => _ReelsListScreenState();
}

class _ReelsListScreenState extends State<ReelsListScreen> {
  final controller = SwiperController();
  List<SliderModel> sliderModelList = [
    SliderModel(raps, 'assets/images/video1.mp4', '', '@abcd@123'),
    SliderModel(vocals, 'assets/images/video2.mp4', '', '@abcd@123'),
    SliderModel(dance, 'assets/images/video3.mp4', '', '@abcd@123'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppbar(context),
      body: Swiper(
        controller: controller,
        itemBuilder: (BuildContext context, int index) {
          return ReelsWidget(
            model: sliderModelList[index],
          );
        },
        itemCount: sliderModelList.length,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
