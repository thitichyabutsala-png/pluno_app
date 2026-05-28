import 'package:flutter/material.dart';

import 'screens/home_page.dart';
import 'theme/app_colors.dart';

class PlunoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pluno',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: C.background,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PlunoHomePage(),
    );
  }
}
