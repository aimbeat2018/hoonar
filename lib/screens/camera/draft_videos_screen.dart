import 'package:flutter/material.dart';

class DraftVideosScreen extends StatefulWidget {
  const DraftVideosScreen({super.key});

  @override
  State<DraftVideosScreen> createState() => _DraftVideosScreenState();
}

class _DraftVideosScreenState extends State<DraftVideosScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}
