import 'package:flutter/material.dart';
import 'package:covid19/constants/colors.dart';
import 'package:covid19/constants/dimens.dart';
import 'package:covid19/constants/strings.dart';
import 'package:covid19/constants/text_styles.dart';
import 'package:covid19/icons/covid19_icons.dart';
import 'package:covid19/ui/statistics/statistics_screen.dart';
import 'package:covid19/utils/custom_scroll_behaviour.dart';
import 'package:covid19/utils/device/device_utils.dart';
import 'package:covid19/widgets/sized_box_height_widget.dart';
import 'package:covid19/widgets/sized_box_width_widget.dart';

/// Data being displayed when the current state of [HomeChangeNotifier]
/// is loading
/// **Requires**
/// 1. [today] - to display the current date of the user in EEEE, d MMMM y format
/// Supports Desktop Screen Sizes
class StatisticsDesktopLoadingWidget extends StatelessWidget {
  final DateTime today;

  const StatisticsDesktopLoadingWidget({Key key, this.today}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = DeviceUtils.getScaledWidth(context, 1);
    final screenHeight = DeviceUtils.getScaledHeight(context, 1);
    return ScrollConfiguration(
      behavior: const CustomScrollBehaviour(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Dimens.horizontalPadding,
            Dimens.verticalPadding / 0.75,
            Dimens.horizontalPadding,
            Dimens.verticalPadding / 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Page Title
                  Text(
                    Strings.outbreakTitle,
                    style: TextStyles.statisticsHeadingTextStlye.copyWith(
                      fontSize: screenHeight / 35,
                    ),
                  ),

                  // Current Date
                  Text(
                    todayDateFormatter(today) ?? '',
                    style: TextStyles.statisticsSubHeadingTextStlye.copyWith(
                      fontSize: screenHeight / 40,
                    ),
                  ),

                  // Vertical Spacing
                  SizedBoxHeightWidget(screenHeight / 50),

                  // Last Updated On Information
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                      color: AppColors.offBlackColor,
                    ),
                    width: screenWidth / 5,
                    height: screenHeight / 50,
                  ),

                  // Vertical Spacing
                  SizedBoxHeightWidget(screenHeight / 50),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // Global Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                right: screenWidth / 120,
                              ),
                              child: Text(
                                Strings.globalTitle,
                                softWrap: true,
                                style: TextStyles.hightlightText.copyWith(
                                  fontSize: screenHeight / 25,
                                ),
                              ),
                            ),
                            Icon(
                              Covid19Icons.globe,
                              size: screenHeight / 25,
                              color: AppColors.blackColor,
                            ),
                          ],
                        ),

                        // Vertical Spacing
                        SizedBoxHeightWidget(screenHeight / 100),

                        // Information Cards
                        Padding(
                          padding: const EdgeInsets.only(
                            right: Dimens.horizontalPadding / 2.5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              // Global Confirmed Cases
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Container(
                                    height: screenHeight / 6.1,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: AppColors.offBlackColor,
                                    ),
                                  ),
                                ),
                              ),

                              // Horizontal Spacing
                              SizedBoxWidthWidget(screenWidth / 75),

                              // Global Recovered Cases
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Container(
                                    height: screenHeight / 6.1,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: AppColors.offBlackColor,
                                    ),
                                  ),
                                ),
                              ),

                              // Horizontal Spacing˝
                              SizedBoxWidthWidget(screenWidth / 75),

                              // Global Active Cases
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Container(
                                    height: screenHeight / 6.1,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: AppColors.offBlackColor,
                                    ),
                                  ),
                                ),
                              ),

                              // Horizontal Spacing
                              SizedBoxWidthWidget(screenWidth / 75),

                              // Global Deaths
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Container(
                                    height: screenHeight / 6.1,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: AppColors.offBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Vertical Spacing
                        SizedBoxHeightWidget(screenHeight / 35),

                        const Padding(
                          padding: EdgeInsets.only(
                            right: Dimens.horizontalPadding,
                          ),
                          child: Divider(
                            color: AppColors.offBlackColor,
                            height: 1,
                          ),
                        ),

                        // Vertical Spacing
                        SizedBoxHeightWidget(screenHeight / 75),

                        // Global Cases List
                        ScrollConfiguration(
                          behavior: const CustomScrollBehaviour(),
                          child: Container(
                            height: screenHeight / 1.8,
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'Country',
                                          textAlign: TextAlign.center,
                                          style: TextStyles
                                              .statisticsHeadingTextStlye
                                              .copyWith(
                                            fontSize: screenHeight / 55,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Infected',
                                          textAlign: TextAlign.center,
                                          style: TextStyles
                                              .statisticsHeadingTextStlye
                                              .copyWith(
                                            fontSize: screenHeight / 55,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Recovered',
                                          textAlign: TextAlign.center,
                                          style: TextStyles
                                              .statisticsHeadingTextStlye
                                              .copyWith(
                                            fontSize: screenHeight / 55,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Active',
                                          textAlign: TextAlign.center,
                                          style: TextStyles
                                              .statisticsHeadingTextStlye
                                              .copyWith(
                                            fontSize: screenHeight / 55,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'Deaths',
                                          textAlign: TextAlign.center,
                                          style: TextStyles
                                              .statisticsHeadingTextStlye
                                              .copyWith(
                                            fontSize: screenHeight / 55,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 8,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: 10,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                          vertical: screenHeight / 150,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(5),
                                                  ),
                                                ),
                                                child: Container(
                                                  height: screenHeight / 35,
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(5),
                                                    ),
                                                    color:
                                                        AppColors.offBlackColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 25,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Country Title
                        // Gesture Detector is used to eliminate the ripple effect
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: screenWidth / 50,
                                ),
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                    color: AppColors.offBlackColor,
                                  ),
                                  height: screenHeight / 25,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 3,
                              child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5),
                                  ),
                                  color: AppColors.offBlackColor,
                                ),
                                height: screenHeight / 25,
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Icon(
                                Covid19Icons.arrowDropDown,
                                size: screenHeight / 25,
                                color: AppColors.offBlackColor,
                              ),
                            ),
                          ],
                        ),
                        // Vertical Spacing
                        SizedBoxHeightWidget(screenHeight / 100),

                        // Information Cards
                        Padding(
                          padding: const EdgeInsets.only(
                            right: Dimens.horizontalPadding / 2.5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Container(
                                    height: screenHeight / 6.1,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: AppColors.offBlackColor,
                                    ),
                                  ),
                                ),
                              ),

                              // Horizontal Spacing
                              SizedBoxWidthWidget(screenWidth / 75),

                              // Country Speicific Recovered Cases
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Container(
                                    height: screenHeight / 6.1,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: AppColors.offBlackColor,
                                    ),
                                  ),
                                ),
                              ),

                              // Horizontal Spacing
                              SizedBoxWidthWidget(screenWidth / 75),

                              // Country Speicific Active Cases
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Container(
                                    height: screenHeight / 6.1,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: AppColors.offBlackColor,
                                    ),
                                  ),
                                ),
                              ),

                              // Horizontal Spacing
                              SizedBoxWidthWidget(screenWidth / 75),

                              // Country Speicific Deaths
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Container(
                                    height: screenHeight / 6.1,
                                    decoration: const BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5),
                                      ),
                                      color: AppColors.offBlackColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Vertical Spacing
                        SizedBoxHeightWidget(screenHeight / 25),

                        // Confirmed Cases Label
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              Strings.confirmedCasesTitle,
                              maxLines: 2,
                              softWrap: true,
                              style: TextStyles.statisticsHeadingTextStlye
                                  .copyWith(
                                fontSize: screenHeight / 35,
                              ),
                            ),
                          ],
                        ),

                        // Vertical Spacing
                        SizedBoxHeightWidget(screenHeight / 75),

                        // Information Tab
                        // Tab Items
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            // Tab 1
                            // Gesture Detector used to avoid the Ripple Effect caused in InkWell
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: AppColors.blackColor,
                                    width: 2,
                                  ),
                                ),
                              ),
                              child: Text(
                                Strings.dailyStatiscsLable,
                                style: TextStyles.hightlightText.copyWith(
                                  fontSize: screenHeight / 35,
                                ),
                              ),
                            ),

                            // Horizontal Spacing
                            SizedBoxWidthWidget(screenWidth / 100),

                            // Tab 2
                            // Gesture Detector used to avoid the Ripple Effect caused in InkWell
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                Strings.weeklyStatiscsLable,
                                style: TextStyles.titleTextStyle.copyWith(
                                  fontSize: screenHeight / 35,
                                ),
                              ),
                            ),

                            // Horizontal Spacing
                            SizedBoxWidthWidget(screenWidth / 100),

                            // Tab 3
                            // Gesture Detector used to avoid the Ripple Effect caused in InkWell
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              padding: const EdgeInsets.all(10),
                              child: Text(
                                Strings.dailyGrowthStatiscsLable,
                                style: TextStyles.titleTextStyle.copyWith(
                                  fontSize: screenHeight / 35,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
