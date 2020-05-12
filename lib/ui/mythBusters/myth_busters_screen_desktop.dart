import 'package:flutter/material.dart';
import 'package:covid19/data/myth_buster_data.dart';
import 'package:covid19/constants/strings.dart';
import 'package:covid19/constants/text_styles.dart';
import 'package:covid19/constants/colors.dart';
import 'package:covid19/constants/dimens.dart';
import 'package:covid19/res/asset_images.dart';
import 'package:covid19/ui/mythBusters/widgets/myth_card_widget_desktop.dart';
import 'package:covid19/utils/custom_scroll_behaviour.dart';
import 'package:covid19/utils/device/device_utils.dart';
import 'package:covid19/widgets/sized_box_height_widget.dart';
import 'package:covid19/widgets/sized_box_width_widget.dart';

/// [MythBustersDesktopScreen] Displays the list of Symptoms for Covid-19
/// Supports Mobile Screen Sizes
class MythBustersDesktopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenWidth = DeviceUtils.getScaledWidth(context, 1);
    final screenHeight = DeviceUtils.getScaledHeight(context, 1);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Dimens.horizontalPadding,
            Dimens.verticalPadding / 0.75,
            Dimens.horizontalPadding,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        // Page Title
                        Text(
                          Strings.mythBusterTitle,
                          style: TextStyles.statisticsHeadingTextStlye.copyWith(
                            fontSize: screenHeight / 35,
                          ),
                        ),

                        // Horizontal Spacing
                        SizedBoxWidthWidget(screenWidth / 150),

                        // Myth Busters Icon
                        Container(
                          width: screenHeight / 25,
                          height: screenHeight / 25,
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(0, 0),
                                blurRadius: 29,
                                color: AppColors.boxShadowColor,
                              ),
                            ],
                            borderRadius: BorderRadius.all(
                              Radius.circular(screenWidth / 10),
                            ),
                            color: AppColors.mythColor,
                          ),
                          child: Center(
                            child: Image.asset(
                              AssetImages.myth,
                              height: screenHeight / 45,
                            ),
                          ),
                        )
                      ],
                    ),

                    // Vertical Spacing
                    SizedBoxHeightWidget(screenHeight / 75),

                    // Instruction text
                    Text(
                      'Click to know facts',
                      style: TextStyles.faqBodyTextStyle.copyWith(
                        fontSize: screenHeight / 45,
                      ),
                    ),

                    // Vertical Spacing
                    SizedBoxHeightWidget(screenHeight / 125),
                  ],
                ),
              ),

              // Myth Buster Items
              // Wrapping the contents in a [Expanded] to make sure that the remaining space
              // in the screen is filled
              Expanded(
                flex: 9,
                // Defining a [SingleChildScrollView] to scroll only the Symptom Items and not the header
                child: ScrollConfiguration(
                  behavior: const CustomScrollBehaviour(),
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: screenHeight / 50,
                    ),
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 4,
                      crossAxisSpacing: 15,
                      children: List.generate(
                        mythBusterData.length,
                        (index) {
                          if (index == 0 || index == 1) {
                            return Padding(
                              padding: EdgeInsets.only(top: screenHeight / 200),
                              child: MythCardDesktopWidget(
                                myth: mythBusterData[index].myth,
                                fact: mythBusterData[index].fact,
                              ),
                            );
                          }

                          // Adding extra padding at the bottom in case of the last element
                          if (index == mythBusterData.length - 1 ||
                              index == mythBusterData.length - 2) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: Dimens.verticalPadding,
                              ),
                              child: MythCardDesktopWidget(
                                myth: mythBusterData[index].myth,
                                fact: mythBusterData[index].fact,
                              ),
                            );
                          }

                          // Returning the normal widget in other cases
                          else {
                            return MythCardDesktopWidget(
                              myth: mythBusterData[index].myth,
                              fact: mythBusterData[index].fact,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
