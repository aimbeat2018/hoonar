import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/my_loading/my_loading.dart';
import '../../../constants/text_constants.dart';
import '../../../model/slider_model.dart';
import '../../home/widgets/slider_page_view.dart';

class HoonarStarsScreen extends StatefulWidget {
  const HoonarStarsScreen({super.key});

  @override
  State<HoonarStarsScreen> createState() => _HoonarStarsScreenState();
}

class _HoonarStarsScreenState extends State<HoonarStarsScreen> {
  List<SliderModel> sliderModelList = [
    SliderModel(raps, 'assets/images/video1.mp4', '', '@abcd@123'),
    SliderModel(vocals, 'assets/images/video2.mp4', '', '@abcd@123'),
    SliderModel(dance, 'assets/images/video3.mp4', '', '@abcd@123'),
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                SizedBox(
                    height: screenHeight * 0.58,
                    child: SliderPageView(
                      sliderModelList: sliderModelList,
                    )),
              ],
            ),
          ),
        ),
      );
    });
  }
}
