import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:covid19/ui/mythBusters/myth_busters_screen_mobile.dart';
import 'package:covid19/ui/mythBusters/myth_busters_screen_desktop.dart';

/// [InformationScreen] is used to build the widgets based on the user's
/// device screen using [ScreenTypeLayout]
class MythBustersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => MythBustersMobileScreen(),
        desktop: (BuildContext context) => MythBustersDesktopScreen(),
      ),
    );
  }
}
