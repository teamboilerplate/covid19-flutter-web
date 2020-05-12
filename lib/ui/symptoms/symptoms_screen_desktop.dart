import 'package:flutter/material.dart';
import 'package:covid19/data/symptoms_data.dart';
import 'package:covid19/constants/strings.dart';
import 'package:covid19/constants/text_styles.dart';
import 'package:covid19/constants/colors.dart';
import 'package:covid19/constants/dimens.dart';
import 'package:covid19/ui/symptoms/widgets/symptom_card_widget_desktop.dart';
import 'package:covid19/utils/device/device_utils.dart';
import 'package:covid19/utils/custom_scroll_behaviour.dart';
import 'package:covid19/widgets/sized_box_height_widget.dart';

/// [SymptomsDesktopScreen] Displays the list of Symptoms for Covid-19
/// Supports Desktop Screen Sizes
class SymptomsDesktopScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = DeviceUtils.getScaledHeight(context, 1);
    return Scaffold(
      // [AppBar] with 0 size used to set the statusbar background color and
      // statusbat text/icon color
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0.0),
        child: AppBar(
          backgroundColor: AppColors.whiteColor,
          brightness: Brightness.light,
          elevation: 0.0,
        ),
      ),

      // Wrapping the contents in [SafeArea] to avoid the Notch (When avaiable) and the bottom
      // navigation bar (Mostly comes in use for iOS Devices)
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            Dimens.horizontalPadding,
            Dimens.verticalPadding / 0.75,
            Dimens.horizontalPadding,
            0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Back Icon
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Page Title
                    Text(
                      Strings.symptomsTitle,
                      style: TextStyles.statisticsHeadingTextStlye.copyWith(
                        fontSize: screenHeight / 35,
                      ),
                    ),

                    // Vertical Spacing
                    SizedBoxHeightWidget(screenHeight / 125),
                  ],
                ),
              ),

              // Symptom Items
              // Wrapping the contents in a [Flexible] to make sure that the remaining space
              // in the screen is filled (Removing this causes the overflow error to occur as
              // a column does not allow scrolling inherently)
              Flexible(
                flex: 15,
                // Defining a [SingleChildScrollView] to scroll only the Symptom Items and not the header
                child: ScrollConfiguration(
                  behavior: const CustomScrollBehaviour(),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 20,
                              child: SymptomCardDesktopWidget(
                                title: symptomsData[0].title,
                                description: symptomsData[0].description,
                                imageURL: symptomsData[0].imageURL,
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            Expanded(
                              flex: 20,
                              child: SymptomCardDesktopWidget(
                                title: symptomsData[1].title,
                                description: symptomsData[1].description,
                                imageURL: symptomsData[1].imageURL,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 20,
                              child: SymptomCardDesktopWidget(
                                title: symptomsData[2].title,
                                description: symptomsData[2].description,
                                imageURL: symptomsData[2].imageURL,
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            Expanded(
                              flex: 20,
                              child: SymptomCardDesktopWidget(
                                title: symptomsData[3].title,
                                description: symptomsData[3].description,
                                imageURL: symptomsData[3].imageURL,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 20,
                              child: SymptomCardDesktopWidget(
                                title: symptomsData[4].title,
                                description: symptomsData[4].description,
                                imageURL: symptomsData[4].imageURL,
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            Expanded(
                              flex: 20,
                              child: SymptomCardDesktopWidget(
                                title: symptomsData[5].title,
                                description: symptomsData[5].description,
                                imageURL: symptomsData[5].imageURL,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 20,
                              child: SymptomCardDesktopWidget(
                                title: symptomsData[6].title,
                                description: symptomsData[6].description,
                                imageURL: symptomsData[6].imageURL,
                              ),
                            ),
                            const Spacer(
                              flex: 1,
                            ),
                            Expanded(
                              flex: 20,
                              child: SymptomCardDesktopWidget(
                                title: symptomsData[7].title,
                                description: symptomsData[7].description,
                                imageURL: symptomsData[7].imageURL,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 20,
                              child: SymptomCardDesktopWidget(
                                title: symptomsData[8].title,
                                description: symptomsData[8].description,
                                imageURL: symptomsData[8].imageURL,
                              ),
                            ),
                            const Spacer(
                              flex: 21,
                            ),
                          ],
                        )
                      ],
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
