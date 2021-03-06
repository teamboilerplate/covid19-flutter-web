import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:covid19/ui/symptoms/symptoms_screen_mobile.dart';
import 'package:covid19/ui/symptoms/symptoms_screen_desktop.dart';

/// [SymptomsScreen] is used to build the widgets based on the user's
/// device screen using [ScreenTypeLayout]ƒ
class SymptomsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => SymptomsMobileScreen(),
        desktop: (BuildContext context) => SymptomsDesktopScreen(),
      ),
    );
  }
}
