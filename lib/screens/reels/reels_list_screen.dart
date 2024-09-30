import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:hoonar/screens/reels/reels_widget.dart';
import 'package:provider/provider.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/text_constants.dart';
import '../../model/slider_model.dart';

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
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
        body: SafeArea(
          child: Stack(
            children: [
              Swiper(
                controller: controller,
                itemBuilder: (BuildContext context, int index) {
                  return ReelsWidget(
                    model: sliderModelList[index],
                  );
                },
                itemCount: sliderModelList.length,
                scrollDirection: Axis.vertical,
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
