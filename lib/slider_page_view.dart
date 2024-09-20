import 'package:flutter/material.dart';

class SliderPageView extends StatefulWidget {
  @override
  _SliderPageViewState createState() => _SliderPageViewState();
}

class _SliderPageViewState extends State<SliderPageView> {
  late PageController _pageController;
  double currentPageValue = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.5);
    _pageController.addListener(() {
      setState(() {
        currentPageValue = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PageView with Overlap'),
      ),
      body: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: PageView.builder(
            controller: _pageController,
            itemCount: 5, // Adjust the number of items
            itemBuilder: (context, index) {
              // Call the custom item builder
              return _buildPageItem(index);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPageItem(int index) {
    double scaleFactor = 0.9;
    double currentScale =
        (1 - (currentPageValue - index).abs()).clamp(0.8, 1.0);
    double currentTranslation = 0.0;

    if (currentPageValue - index < 0) {
      currentTranslation = 60 * (0 - currentScale);
    } else if (currentPageValue - index > 0) {
      currentTranslation = -60 * (0 - currentScale);
    }

    return Transform.translate(
      offset: Offset(currentTranslation, 0),
      child: Transform.scale(
        scale: currentScale,
        child: Card(
          elevation: 5,
          color: Colors.blueAccent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.blueAccent,
            ),
            child: Center(
              child: Text(
                'Page $index',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
