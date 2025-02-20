import 'dart:math';

import 'package:flutter/material.dart';

typedef CallbackSelection = void Function(double duration);

class WaveSlider extends StatefulWidget {
  final double widthWaveSlider;
  final double heightWaveSlider;
  final Color wavActiveColor;
  final Color wavDeactiveColor;
  final Color sliderColor;
  final Color backgroundColor;
  final Color positionTextColor;
  final double duration;
  final CallbackSelection callbackStart;
  final CallbackSelection callbackEnd;
  const WaveSlider({
    super.key,
    required this.duration,
    required this.callbackStart,
    required this.callbackEnd,
    this.widthWaveSlider = 0,
    this.heightWaveSlider = 0,
    this.wavActiveColor = Colors.deepPurple,
    this.wavDeactiveColor = Colors.blueGrey,
    this.sliderColor = Colors.red,
    this.backgroundColor = Colors.grey,
    this.positionTextColor = Colors.black,
  });

  @override
  State<StatefulWidget> createState() => WaveSliderState();
}

class WaveSliderState extends State<WaveSlider> {
  double widthSlider = 300;
  double heightSlider = 100;
  static const barWidth = 5.0;
  static const selectBarWidth = 20.0;
  double barStartPosition = 0.0;
  double barEndPosition = 50;
  List<int> bars = [];

  @override
  void initState() {
    super.initState();

    var shortSize = MediaQueryData.fromView(WidgetsBinding.instance.window).size.shortestSide;

    widthSlider = (widget.widthWaveSlider < 50) ? (shortSize - 2 - 40) : widget.widthWaveSlider;
    heightSlider = (widget.heightWaveSlider < 50) ? 100 : widget.heightWaveSlider;
    barEndPosition = widthSlider - selectBarWidth;

    Random r = Random();
    for (var i = 0; i < (widthSlider / barWidth); i++) {
      int number = 1 + r.nextInt(heightSlider.toInt() - 1);
      bars.add(r.nextInt(number));
    }
  }

  double _getBarStartPosition() {
    return ((barEndPosition) < barStartPosition) ? barEndPosition : barStartPosition;
  }

  double _getBarEndPosition() {
    return ((barStartPosition + selectBarWidth) > barEndPosition) ? (barStartPosition + selectBarWidth) : barEndPosition;
  }

  int _getStartTime() {
    return (_getBarStartPosition() / (widthSlider / widget.duration)).toInt();
  }

  int _getEndTime() {
    return ((_getBarEndPosition() + selectBarWidth) / (widthSlider / widget.duration)).ceilToDouble().toInt();
  }

  String _timeFormatter(int second) {
    Duration duration = Duration(seconds: second);

    List<int> durations = [];
    if (duration.inHours > 0) {
      durations.add(duration.inHours);
    }
    durations.add(duration.inMinutes);
    durations.add(duration.inSeconds);

    return durations.map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':');
  }

  @override
  Widget build(BuildContext context) {
    int i = 0;

    return SizedBox(
      width: widthSlider,
      height: heightSlider,
      child: Column(
        children: [
          Row(
            children: [
              Text(_timeFormatter(_getStartTime()), style: TextStyle(color: widget.positionTextColor)),
              Expanded(child: Container()),
              Text(_timeFormatter(_getEndTime()), style: TextStyle(color: widget.positionTextColor)),
            ],
          ),
          Expanded(
            child: Container(
              color: widget.backgroundColor,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.centerLeft,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: bars.map((int height) {
                      Color color = i >= barStartPosition / barWidth && i <= barEndPosition / barWidth
                          ? widget.wavActiveColor
                          : widget.wavDeactiveColor;
                      i++;

                      return Container(
                        color: color,
                        height: height.toDouble(),
                        width: 5.0,
                      );
                    }).toList(),
                  ),
                  Bar(
                    position: _getBarStartPosition(),
                    colorBG: widget.sliderColor,
                    width: selectBarWidth,
                    callback: (DragUpdateDetails details) {
                      var tmp = barStartPosition + details.delta.dx;
                      if ((barEndPosition - selectBarWidth) > tmp && (tmp >= 0)) {
                        setState(() {
                          barStartPosition += details.delta.dx;
                        });
                      }
                    },
                    callbackEnd: (details) {
                      widget.callbackStart(_getStartTime().toDouble());
                    },
                  ),
                  CenterBar(
                    position: _getBarStartPosition() + selectBarWidth,
                    width: _getBarEndPosition() - _getBarStartPosition() - selectBarWidth,
                    callback: (details) {
                      var tmp1 = barStartPosition + details.delta.dx;
                      var tmp2 = barEndPosition + details.delta.dx;
                      if ((tmp1 > 0) && ((tmp2 + selectBarWidth) < widthSlider)) {
                        setState(() {
                          barStartPosition += details.delta.dx;
                          barEndPosition += details.delta.dx;
                        });
                      }
                    },
                    callbackEnd: (details) {
                      widget.callbackStart(_getStartTime().toDouble());
                      widget.callbackEnd(_getEndTime().toDouble());
                    },
                  ),
                  Bar(
                    position: _getBarEndPosition(),
                    colorBG: widget.sliderColor,
                    width: selectBarWidth,
                    callback: (DragUpdateDetails details) {
                      var tmp = barEndPosition + details.delta.dx;
                      if ((barStartPosition + selectBarWidth) < tmp && (tmp + selectBarWidth) <= widthSlider) {
                        setState(() {
                          barEndPosition += details.delta.dx;
                        });
                      }
                    },
                    callbackEnd: (details) {
                      widget.callbackEnd(_getEndTime().toDouble());
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CenterBar extends StatelessWidget {
  final double position;
  final double width;
  final GestureDragUpdateCallback callback;
  final GestureDragEndCallback? callbackEnd;

  const CenterBar({super.key, required this.position, required this.width, required this.callback, required this.callbackEnd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: position >= 0.0 ? position : 0.0),
      child: GestureDetector(
        onHorizontalDragUpdate: callback,
        onHorizontalDragEnd: callbackEnd,
        child: Container(
          color: Colors.black38,
          // height: 200.0,
          width: width,
          child: Column(
            children: [
              Container(height: 4, color: Colors.red),
              Expanded(child: Container()),
              Container(height: 4, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }
}

class Bar extends StatelessWidget {
  final double position;
  final Color? colorBG;
  final double width;
  final GestureDragUpdateCallback callback;
  final GestureDragEndCallback? callbackEnd;

  const Bar(
      {super.key, required this.position, required this.width, required this.callback, required this.callbackEnd, this.colorBG});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: position >= 0.0 ? position : 0.0),
      child: GestureDetector(
        onHorizontalDragUpdate: callback,
        onHorizontalDragEnd: callbackEnd,
        child: Container(
          color: colorBG ?? Colors.red,
          height: double.infinity,
          width: width,
          child: const Icon(Icons.menu, size: 16, color: Colors.white),
        ),
      ),
    );
  }
}