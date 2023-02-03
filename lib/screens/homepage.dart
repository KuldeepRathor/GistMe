import 'package:flutter/material.dart';
import 'package:lecturenet/helpers/palette.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('LectureNet'),
          centerTitle: true,
          backgroundColor: AppColors.bgColor,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('Tap on mic button to start recording'),
              Icon(
                Icons.mic,
                size: 100,
                color: AppColors.accentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
