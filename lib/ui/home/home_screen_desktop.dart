import 'package:flutter/material.dart';
import 'package:covid19/data/network/constants/endpoints.dart';
import 'package:covid19/constants/colors.dart';
import 'package:covid19/ui/statistics/statistics_screen.dart';
import 'package:covid19/ui/prevention/prevention_screen.dart';
import 'package:covid19/ui/symptoms/symptoms_screen.dart';
import 'package:covid19/ui/mythBusters/myth_busters_screen.dart';
import 'package:covid19/ui/faq/faq_screen.dart';
import 'package:covid19/ui/information/information_screen.dart';

/// [HomeScreen] is the first Screen of the application which displays various
/// cards available to the user and handles routes for each of them
/// Supports Desktop Screen Sizes
class HomeDesktopScreen extends StatefulWidget {
  @override
  _HomeDesktopScreenState createState() => _HomeDesktopScreenState();
}

class _HomeDesktopScreenState extends State<HomeDesktopScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Row(
          children: <Widget>[
            Container(
              width: 125,
              child: NavigationRail(
                backgroundColor: AppColors.primaryColor,
                selectedIndex: _selectedIndex,
                onDestinationSelected: (int index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                selectedLabelTextStyle: const TextStyle(
                  color: AppColors.mythColor,
                  fontSize: 15,
                ),
                labelType: NavigationRailLabelType.selected,
                groupAlignment: 0.0,
                destinations: [
                  navigationRaiilItem(
                    imagePath: '${Endpoints.baseUrlGraphics}/statistics.svg',
                    title: 'Statistics',
                  ),
                  navigationRaiilItem(
                    imagePath: '${Endpoints.baseUrlGraphics}/prevention.svg',
                    title: 'Prevention',
                  ),
                  navigationRaiilItem(
                    imagePath: '${Endpoints.baseUrlGraphics}/symptoms.svg',
                    title: 'Symptoms',
                  ),
                  navigationRaiilItem(
                    imagePath: '${Endpoints.baseUrlGraphics}/myth-busters.svg',
                    title: 'Myth\nBusters',
                  ),
                  navigationRaiilItem(
                    imagePath: '${Endpoints.baseUrlGraphics}/faq-data.svg',
                    title: 'FAQ',
                  ),
                  navigationRaiilItem(
                    imagePath: '${Endpoints.baseUrlGraphics}/virus.svg',
                    title: 'What is\nCovid-19?',
                  ),
                ],
              ),
            ),

            // This is the main content.
            if (_selectedIndex == 0)
              Expanded(
                child: StatisticsScreen(),
              )
            else if (_selectedIndex == 1)
              Expanded(
                child: PreventionScreen(),
              )
            else if (_selectedIndex == 2)
              Expanded(
                child: SymptomsScreen(),
              )
            else if (_selectedIndex == 3)
              Expanded(
                child: MythBustersScreen(),
              )
            else if (_selectedIndex == 4)
              Expanded(
                child: FAQScreen(),
              )
            else if (_selectedIndex == 5)
              Expanded(
                child: InformationScreen(),
              )
          ],
        ),
      ),
    );
  }
}

/// Displays the navigation Rail Items
///
/// **Requires**
/// 1. [title] - For the title text
/// 2. [imagePath] - For the Image to be displayed
NavigationRailDestination navigationRaiilItem(
    {String title, String imagePath}) {
  return NavigationRailDestination(
    icon: Image.network(
      imagePath,
      color: AppColors.homeCardLoadingColor,
      height: 36,
      alignment: Alignment.center,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.homeCardLoadingColor,
            shape: BoxShape.circle,
          ),
        );
      },
    ),
    selectedIcon: Image.network(
      imagePath,
      height: 36,
      alignment: Alignment.center,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
        );
      },
    ),
    label: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
      ),
    ),
  );
}
