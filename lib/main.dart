import 'package:flutter/material.dart';
import 'package:lecturenet/helpers/palette.dart';
import 'package:lecturenet/screens/homepage.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff2d033b),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xff810ca8),
        ),
        appBarTheme: AppBarTheme(
          color: Color(0xff810ca8),
        ),
        // textTheme: TextTheme(bodyMedium: )
      ),
      home: HomePage(),
    );
  }
}
