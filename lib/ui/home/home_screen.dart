import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:covid19/ui/home/home_screen_mobile.dart';
import 'package:covid19/ui/home/home_screen_desktop.dart';

/// [HomeScreen] is used to build the widgets based on the user's
/// device screen using [ScreenTypeLayout]
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => HomeMobileScreen(),
        desktop: (BuildContext context) => HomeDesktopScreen(),
      ),
    );
  }
}
