import 'package:flutter/material.dart';

class ZoomCarouselSlider extends StatefulWidget {
  @override
  _ZoomCarouselSliderState createState() => _ZoomCarouselSliderState();
}

class _ZoomCarouselSliderState extends State<ZoomCarouselSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  double _currentPage =
      0.0; // Track the current page for scaling and translation

  final List<String> _images = [
    'https://via.placeholder.com/400x200/FF0000/FFFFFF?text=Slide+1',
    'https://via.placeholder.com/400x200/00FF00/FFFFFF?text=Slide+2',
    'https://via.placeholder.com/400x200/0000FF/FFFFFF?text=Slide+3',
    'https://via.placeholder.com/400x200/FFFF00/FFFFFF?text=Slide+4',
    'https://via.placeholder.com/400x200/00FFFF/FFFFFF?text=Slide+5',
  ];

  @override
  void initState() {
    super.initState();

    // Wait for the frame to be built and then update the pageController
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _currentPage =
            _pageController.page ?? 0.0; // Ensure _currentPage is initialized
      });
    });

    // Listen to page changes
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Zoom Carousel Slider')),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _images.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  double scale = 1.0;
                  double offset = 0.0;

                  // Calculate scale and offset based on pageController's position
                  double page = index - _currentPage;

                  // Zoom in/out effect (center item gets bigger)
                  scale = 1 - (page.abs() * 0.2); // Adjust zoom effect here
                  offset = page *
                      60; // Adjust this for how far the adjacent items should be

                  // Prevent scale from going below a certain value
                  scale = scale < 0.8 ? 0.8 : scale;

                  return Center(
                    child: Transform.scale(
                      scale: scale,
                      child: Transform.translate(
                        offset: Offset(offset, 0),
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(_images[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _images.map((url) {
                int index = _images.indexOf(url);
                return Container(
                  width: 8,
                  height: 8,
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index ? Colors.blue : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
