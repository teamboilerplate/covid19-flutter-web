import 'package:flutter/material.dart';
import 'package:covid19/constants/colors.dart';
import 'package:covid19/constants/dimens.dart';
import 'package:covid19/constants/strings.dart';
import 'package:covid19/constants/text_styles.dart';
import 'package:covid19/data/faq_data.dart';
import 'package:covid19/icons/covid19_icons.dart';
import 'package:covid19/models/faq/faq_model.dart';
import 'package:covid19/utils/custom_scroll_behaviour.dart';
import 'package:covid19/utils/device/device_utils.dart';
import 'package:covid19/widgets/sized_box_height_widget.dart';

class FAQScreen extends StatefulWidget {
  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  int _previousItemIndex = -1;

  // Tiles to build without the ExpansionList to enhance performance
  // Widget _buildTiles(FAQModel entry, int index) {
  //   debugPrint('Previous Index $_previousItemIndex');
  //   debugPrint('Entry Item $index is ${entry.isExpanded}');

  //   return ExpansionTile(
  //     onExpansionChanged: (bool isExpanded) {
  //       if (_previousItemIndex == -1) {
  //         setState(() {
  //           _previousItemIndex = index;
  //           faqData[index].isExpanded = true;
  //         });
  //       } else {
  //         setState(() {
  //           faqData[_previousItemIndex].isExpanded = false;
  //           faqData[index].isExpanded = !isExpanded;
  //           _previousItemIndex = index;
  //         });
  //       }
  //     },
  //     initiallyExpanded: faqData[index].isExpanded,
  //     title: Text(entry.title),
  //     children: <Widget>[
  //       Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Text(entry.description),
  //       ),
  //     ],
  //   );
  // }

  // Buidling the expansion Panel with the list of FAQs
  Widget _buildPanel({
    double screenWidth,
    double screenHeight,
  }) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        if (_previousItemIndex == -1) {
          setState(() {
            _previousItemIndex = index;
            faqData[index].isExpanded = !isExpanded;
          });
        } else {
          setState(() {
            faqData[_previousItemIndex].isExpanded = false;
            faqData[index].isExpanded = !isExpanded;
            _previousItemIndex = index;
          });
        }
      },
      children: faqData.map<ExpansionPanel>(
        (FAQModel item) {
          if (faqData.indexOf(item) == faqData.length - 1) {
            return ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Container(
                  margin: const EdgeInsets.only(
                    bottom: Dimens.verticalPadding / 0.3,
                  ),
                  child: ListTile(
                    title: Text(
                      item.title,
                      style: TextStyles.faqHeadingTextStyle.copyWith(
                        fontSize: screenWidth / 25,
                      ),
                    ),
                  ),
                );
              },
              body: ListTile(
                title: Container(
                  margin: const EdgeInsets.only(
                    bottom: Dimens.verticalPadding / 0.3,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: screenHeight / 30,
                    ),
                    child: Text(
                      item.description,
                      style: TextStyles.faqBodyTextStyle.copyWith(
                        fontSize: screenWidth / 25,
                      ),
                    ),
                  ),
                ),
              ),
              isExpanded: item.isExpanded,
            );
          } else {
            return ExpansionPanel(
              canTapOnHeader: true,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    item.title,
                    style: TextStyles.faqHeadingTextStyle.copyWith(
                      fontSize: screenWidth / 25,
                    ),
                  ),
                );
              },
              body: ListTile(
                title: Padding(
                  padding: EdgeInsets.only(
                    bottom: screenHeight / 30,
                  ),
                  child: Text(
                    item.description,
                    style: TextStyles.faqBodyTextStyle.copyWith(
                      fontSize: screenWidth / 25,
                    ),
                  ),
                ),
              ),
              isExpanded: item.isExpanded,
            );
          }
        },
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = DeviceUtils.getScaledWidth(context, 1);
    final screenHeight = DeviceUtils.getScaledHeight(context, 1);
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
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
              // FAQ Headers
              // Wrapping the contents in a [Expanded] to make sure that the remaining space
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    // Back Icon
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Covid19Icons.keyboardArrowLeft,
                        size: screenWidth / 12,
                        color: AppColors.blackColor,
                      ),
                    ),

                    // Vertical Spacing
                    SizedBoxHeightWidget(screenHeight / 50),

                    // Page Title
                    Text(
                      Strings.faqTitle,
                      style: TextStyles.statisticsHeadingTextStlye.copyWith(
                        fontSize: screenWidth / 15,
                      ),
                    ),
                  ],
                ),
              ),

              // Symptom Items
              // Wrapping the contents in a [Expanded] to make sure that the remaining space
              // in the screen is filled (Removing this causes the overflow error to occur as
              // a column does not allow scrolling inherently)
              Expanded(
                flex: 5,
                // Defining a [SingleChildScrollView] to scroll only the Symptom Items and not the header
                child: ScrollConfiguration(
                  behavior: const CustomScrollBehaviour(),
                  child: SingleChildScrollView(
                    child: _buildPanel(
                      screenWidth: screenWidth,
                      screenHeight: screenHeight,
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

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatefulWidget {
  final FAQModel entry;

  const EntryItem(this.entry);

  @override
  _EntryItemState createState() => _EntryItemState();
}

class _EntryItemState extends State<EntryItem> {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: PageStorageKey<FAQModel>(widget.entry),
      initiallyExpanded: widget.entry.isExpanded,
      title: Text(widget.entry.title),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(widget.entry.description),
        ),
      ],
    );
  }
}
