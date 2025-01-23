import 'package:flutter/material.dart';

class ImageLoaderWidget extends StatefulWidget {
  final String imageUrl;

  const ImageLoaderWidget({Key? key, required this.imageUrl}) : super(key: key);

  @override
  _ImageLoaderWidgetState createState() => _ImageLoaderWidgetState();
}

class _ImageLoaderWidgetState extends State<ImageLoaderWidget> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() {
    final ImageStream stream =
        NetworkImage(widget.imageUrl).resolve(ImageConfiguration());
    stream.addListener(
      ImageStreamListener(
        (image, synchronousCall) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        },
        onError: (exception, stackTrace) {
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Image Container
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            image: _isLoading
                ? null // No image until it's loaded
                : DecorationImage(
                    image: NetworkImage(widget.imageUrl),
                    fit: BoxFit.cover,
                  ),
          ),
        ),

        // Circular Loader Overlay (Visible until the image loads)
        if (_isLoading)
          const Center(
            child: CircularProgressIndicator(
              color: Colors.white, // Customize color
              strokeWidth: 2.5, // Customize thickness
            ),
          ),
      ],
    );
  }
}
