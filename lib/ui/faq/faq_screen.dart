import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:covid19/ui/faq/faq_screen_mobile.dart';
import 'package:covid19/ui/faq/faq_screen_desktop.dart';

/// [FAQScreen] is used to build the widgets based on the user's
/// device screen using [ScreenTypeLayout]
class FAQScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenTypeLayout.builder(
        mobile: (BuildContext context) => FAQMobileScreen(),
        desktop: (BuildContext context) => FAQDesktopScreen(),
      ),
    );
  }
}
