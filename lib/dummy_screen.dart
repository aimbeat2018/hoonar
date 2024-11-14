import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DummyScreen extends StatefulWidget {
  const DummyScreen({super.key});

  @override
  State<DummyScreen> createState() => _DummyScreenState();
}

class _DummyScreenState extends State<DummyScreen> {
  late FijkPlayer _player;
  bool _isPlaying = false;
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _player = FijkPlayer();
    _player.setDataSource(
      "https://storage.bunnycdn.com/hoonar-star/post_video/1731585275-file_example_MP4_480_1_5MG.mp4?accesskey=cbbd781a-e234-428c-a1a32c5109e4-f5f6-4054",
      autoPlay: true,
      showCover: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _player.dispose();
  }

  // Play or Pause the video
  void _togglePlayPause() {
    setState(() {
      if (_isPlaying) {
        _player.pause();
        _isPlaying = false;
        _isPaused = true;
      } else if (_isPaused) {
        _player.start();
        _isPlaying = true;
        _isPaused = false;
      } else {
        _player.start();
        _isPlaying = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FijkPlayer with Custom Controls'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FijkView(
              player: _player,
              fit: FijkFit.cover,
              height: 300,
              fs: false,
              width: MediaQuery.of(context).size.width,
            ),
            SizedBox(height: 20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     IconButton(
            //       icon: Icon(
            //         _isPlaying ? Icons.pause : Icons.play_arrow,
            //         size: 40,
            //       ),
            //       onPressed: _togglePlayPause,
            //     ),
            //     // Add more custom controls as needed
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
