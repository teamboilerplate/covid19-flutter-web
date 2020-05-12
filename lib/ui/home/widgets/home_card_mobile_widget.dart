import 'package:flutter/material.dart';
import 'package:covid19/constants/text_styles.dart';
import 'package:covid19/constants/colors.dart';
import 'package:covid19/constants/dimens.dart';
import 'package:covid19/ui/home/home_navigator.dart';
import 'package:covid19/utils/device/device_utils.dart';

/// Displays the navigation Home Cards on the Mobile Devices
///
/// **Requires**
/// 1. [title] - For the title text
/// 2. [backgroundColor] - For the backgroundColor of the Card
/// 3. [imagePath] - For the Image to be displayed
/// 4. [route] - For the value to be used to navigate to the desired screen using [HomeNavigator]
/// Supports Mobile Screen Sizes
class HomeCardWidget extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final String imagePath;
  final String route;

  const HomeCardWidget({
    Key key,
    this.title,
    this.backgroundColor,
    this.imagePath,
    this.route,
  }) : super(
          key: key,
        );
  @override
  Widget build(BuildContext context) {
    final screenHeight = DeviceUtils.getScaledHeight(context, 1);
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(route),
      child: Container(
        height: screenHeight / 5,
        margin: const EdgeInsets.symmetric(
          horizontal: Dimens.horizontalPadding / 5,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimens.horizontalPadding,
          vertical: Dimens.verticalPadding / 2,
        ),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 0),
              blurRadius: 1,
              color: AppColors.boxShadowColor,
            ),
          ],
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          color: backgroundColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              imagePath,
              height: screenHeight / 10,
              fit: BoxFit.contain,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: screenHeight / 10,
                  height: screenHeight / 8.5,
                  decoration: BoxDecoration(
                    color: AppColors.homeCardLoadingColor.withOpacity(0.5),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                );
              },
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyles.homeCardTitle.copyWith(
                fontSize: screenHeight / 60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
