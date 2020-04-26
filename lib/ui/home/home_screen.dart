import 'package:flutter/material.dart';
import 'package:covid19/constants/colors.dart';
import 'package:covid19/constants/dimens.dart';
import 'package:covid19/constants/strings.dart';
import 'package:covid19/constants/text_styles.dart';
import 'package:covid19/res/asset_images.dart';
import 'package:covid19/ui/home/home_navigator.dart';
import 'package:covid19/ui/home/widgets/home_card_widget.dart';
import 'package:covid19/utils/custom_scroll_behaviour.dart';
import 'package:covid19/utils/device/device_utils.dart';
import 'package:covid19/widgets/sized_box_height_widget.dart';

/// [HomeScreen] is the first Screen of the application which displays various
/// cards available to the user and handles routes for each of them
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = DeviceUtils.getScaledHeight(context, 1);
    return Material(
      child: Scaffold(
        // [AppBar] with 0 size used to set the statusbar background color and
        // statusbat text/icon color
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(
            backgroundColor: AppColors.transparentColor,
            brightness: Brightness.light,
            elevation: 0.0,
          ),
        ),
        body: ScrollConfiguration(
          behavior: const CustomScrollBehaviour(),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                Dimens.horizontalPadding,
                Dimens.verticalPadding / 0.75,
                Dimens.horizontalPadding,
                Dimens.verticalPadding / 0.5,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Page Title
                  Opacity(
                    opacity: 0,
                    child: Text(
                      Strings.appSlogan,
                      style: TextStyles.statisticsHeadingTextStlye.copyWith(
                        fontSize: 0,
                      ),
                    ),
                  ),

                  Container(
                    height: screenHeight / 2,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage(
                          AssetImages.home,
                        ),
                      ),
                      color: Colors.transparent,
                    ),
                  ),

                  // Vertical Spacing
                  SizedBoxHeightWidget(screenHeight / 30),

                  Row(
                    children: <Widget>[
                      // Statistics Card
                      Expanded(
                        flex: 1,
                        child: HomeCardWidget(
                          backgroundColor: AppColors.primaryColor,
                          title: Strings.statisticsTitle,
                          imagePath: AssetImages.statistics,
                          route: HomeRoutes.latestNumbers.name,
                        ),
                      ),

                      // Prevention Numbers Card
                      Expanded(
                        flex: 1,
                        child: HomeCardWidget(
                          backgroundColor: AppColors.primaryColor,
                          title: Strings.preventionTitle,
                          imagePath: AssetImages.prevention,
                          route: HomeRoutes.prevention.name,
                        ),
                      ),

                      // Symptoms Card
                      Expanded(
                        flex: 1,
                        child: HomeCardWidget(
                          backgroundColor: AppColors.primaryColor,
                          title: Strings.symptomsTitle,
                          imagePath: AssetImages.symptoms,
                          route: HomeRoutes.symptoms.name,
                        ),
                      ),
                    ],
                  ),

                  // Vertical Spacing
                  SizedBoxHeightWidget(screenHeight / 30),

                  Row(
                    children: <Widget>[
                      // Myth Busters Card
                      Expanded(
                        flex: 1,
                        child: HomeCardWidget(
                          backgroundColor: AppColors.primaryColor,
                          title: Strings.mythBusterTitle,
                          imagePath: AssetImages.mythBusters,
                          route: HomeRoutes.mythBusters.name,
                        ),
                      ),

                      // FAQ Card
                      Expanded(
                        flex: 1,
                        child: HomeCardWidget(
                          backgroundColor: AppColors.primaryColor,
                          title: Strings.faqTitle,
                          imagePath: AssetImages.faq,
                          route: HomeRoutes.faq.name,
                        ),
                      ),

                      // Coronavirus information Card
                      Expanded(
                        flex: 1,
                        child: HomeCardWidget(
                          backgroundColor: AppColors.primaryColor,
                          title: Strings.covidInformationTitle,
                          imagePath: AssetImages.virus,
                          route: HomeRoutes.information.name,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
