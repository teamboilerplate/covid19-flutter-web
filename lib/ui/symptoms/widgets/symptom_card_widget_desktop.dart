import 'package:covid19/constants/colors.dart';
import 'package:covid19/constants/text_styles.dart';
import 'package:covid19/utils/device/device_utils.dart';
import 'package:covid19/widgets/sized_box_height_widget.dart';
import 'package:flutter/material.dart';

/// To Build the widget to display the card for each Symptom
/// **Requires**
/// 1. [title] - title of the Symptom
/// 2. [description] - Description about the symptom
/// 3. [imageURL] - URL for the image specific to the symptom
/// Supports Desktop Screen Sizes
class SymptomCardDesktopWidget extends StatelessWidget {
  final String title, description, imageURL;

  const SymptomCardDesktopWidget({
    Key key,
    @required this.title,
    @required this.description,
    @required this.imageURL,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final screenWidth = DeviceUtils.getScaledWidth(context, 1);
    final screenHeight = DeviceUtils.getScaledHeight(context, 1);
    return Container(
      margin: EdgeInsets.only(
        bottom: screenHeight / 45,
      ),
      padding: EdgeInsets.only(
        left: screenWidth / 75,
        top: screenHeight / 50,
        right: screenWidth / 75,
        bottom: screenHeight / 50,
      ),
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 1,
            color: AppColors.boxShadowColor,
          ),
        ],
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: AppColors.whiteColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              right: screenWidth / 100,
            ),
            child: Image.network(
              imageURL,
              height: screenHeight / 10,
              fit: BoxFit.cover,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: screenHeight / 10,
                  height: screenHeight / 10,
                  decoration: BoxDecoration(
                    color: AppColors.offBlackColor.withOpacity(0.5),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(50),
                    ),
                  ),
                );
              },
            ),
          ),
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyles.statisticsHeadingTextStlye.copyWith(
                    fontSize: screenHeight / 45,
                  ),
                ),

                // Vertical Spacing
                SizedBoxHeightWidget(screenHeight / 75),

                Text(
                  description,
                  style: TextStyles.statisticsSubHeadingTextStlye.copyWith(
                    fontSize: screenHeight / 50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
