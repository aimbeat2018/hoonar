import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class PictureSlideShow extends StatefulWidget {
  @override
  _PictureSlideShowState createState() => _PictureSlideShowState();
}

class _PictureSlideShowState extends State<PictureSlideShow> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider(
        items: [1, 2, 3, 4, 5].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                // width: 400,
                // height: 400,
                // margin: EdgeInsets.all(0.5),
                decoration:
                    BoxDecoration(color: Colors.lightBlue[100 * (i % 5)]),
                child: Center(
                  child: Text(
                    'text $i',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              );
            },
          );
        }).toList(),
        options: CarouselOptions(
          enlargeCenterPage: true,
          height: 200.0,

          pageSnapping: true,
          enlargeStrategy: CenterPageEnlargeStrategy.height
        ),
      ),
    );
  }
}
