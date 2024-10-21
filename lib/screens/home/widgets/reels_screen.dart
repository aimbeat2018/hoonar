// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hoonar/model/slider_model.dart';
// import 'package:hoonar/screens/home/widgets/options_screen.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
//
// class ReelsScreen extends StatefulWidget {
//   final SliderModel model;
//
//   const ReelsScreen({super.key, required this.model});
//
//   @override
//   State<ReelsScreen> createState() => _ReelsScreenState();
// }
//
// class _ReelsScreenState extends State<ReelsScreen> {
//   late VideoPlayerController _videoPlayerController;
//   ChewieController? _chewieController;
//   bool _isPaused = false;
//
//   @override
//   void initState() {
//     super.initState();
//     initializePlayer();
//   }
//
//   Future initializePlayer() async {
//     // _videoPlayerController =
//     //     VideoPlayerController.networkUrl(Uri.parse(widget.model.video));
//     _videoPlayerController = VideoPlayerController.asset(widget.model.video);
//     await Future.wait([_videoPlayerController.initialize()]);
//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController,
//       autoPlay: false,
//       showControls: false,
//       looping: true,
//     );
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     _videoPlayerController.dispose();
//     if (_chewieController != null) _chewieController!.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: Stack(
//         fit: StackFit.expand,
//         children: [
//           _chewieController != null &&
//                   _chewieController!.videoPlayerController.value.isInitialized
//               ? GestureDetector(
//                   onTap: () {
//                     if (_videoPlayerController.value.isPlaying) {
//                       _videoPlayerController.pause();
//                       setState(() {
//                         _isPaused = !_isPaused;
//                       });
//                     } else {
//                       // If the video is paused, play it.
//                       _videoPlayerController.play();
//
//                       setState(() {
//                         _isPaused = !_isPaused;
//                       });
//                     }
//                     // _videoPlayerController.pause();
//                   },
//                   child: Chewie(
//                     controller: _chewieController!,
//                   ),
//                 )
//               : Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     CircularProgressIndicator(),
//                     SizedBox(height: 10),
//                     Text('Loading...')
//                   ],
//                 ),
//           Align(
//             alignment: Alignment.bottomLeft,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: OptionsScreen(
//                     model: widget.model,
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(
//                         vertical: 8.0, horizontal: 5),
//                     child: Row(
//                       children: [
//                         CircleAvatar(
//                           radius: 13.0, // size of the avatar
//                           backgroundImage: NetworkImage(
//                               'https://www.stylecraze.com/wp-content/uploads/2020/09/Beautiful-Women-In-The-World.jpg'), // or AssetImage('assets/avatar.png')
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Expanded(
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 widget.model.userName,
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 10,
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                               ),
//                               Flexible(
//                                 child: Container(
//                                   margin: EdgeInsets.only(left: 5),
//                                   padding: EdgeInsets.symmetric(
//                                       horizontal: 10, vertical: 3),
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(10),
//                                       color: Colors.white),
//                                   child: Text(
//                                     AppLocalizations.of(context)!.follow,
//                                     style: GoogleFonts.poppins(
//                                       fontSize: 8,
//                                       color: Colors.black,
//                                       fontWeight: FontWeight.w600,
//                                     ),
//                                   ),
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
