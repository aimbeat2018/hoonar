import 'dart:async';

import 'package:card_swiper/card_swiper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:hoonar/screens/reels/reels_widget.dart';
import 'package:provider/provider.dart';

import '../../constants/internet_connectivity.dart';
import '../../constants/key_res.dart';
import '../../constants/my_loading/my_loading.dart';
import '../../constants/no_internet_screen.dart';
import '../../model/success_models/home_post_success_model.dart';

class ReelsListScreen extends StatefulWidget {
  final List<PostsListData>? postList;
  final int? index;

  const ReelsListScreen({super.key, this.postList, this.index});

  @override
  State<ReelsListScreen> createState() => _ReelsListScreenState();
}

class _ReelsListScreenState extends State<ReelsListScreen> {
  final controller = SwiperController();
  int? currentIndex;
  bool hasSwiped = false; // Flag to track if the user has swiped
  String _connectionStatus = 'unKnown';
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = widget.index;

    CheckInternet.initConnectivity().then((value) => setState(() {
          _connectionStatus = value;
        }));

    _connectivitySubscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      CheckInternet.updateConnectionStatus(result).then((value) => setState(() {
            _connectionStatus = value;
          }));
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyLoading>(builder: (context, myLoading, child) {
      return _connectionStatus == KeyRes.connectivityCheck
          ? const NoInternetScreen()
          : Scaffold(
              backgroundColor: myLoading.isDark ? Colors.black : Colors.white,
              body: SafeArea(
                child: Stack(
                  children: [
                    Swiper(
                      controller: controller,
                      index: currentIndex,
                      itemBuilder: (BuildContext context, int index) {
                        // if(currentIndex!=index+1) {
                        //   currentIndex = /*hasSwiped ? index : */index;
                        // }

                        return ReelsWidget(
                          model: widget.postList![index],
                          index: index,
                          postList: widget.postList!,
                        );
                      },
                      itemCount: widget.postList!.length,
                      scrollDirection: Axis.vertical,
                      loop: false,
                      onIndexChanged: (index) {
                        setState(() {
                          hasSwiped = true;
                          currentIndex = index;
                        });
                      },
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
