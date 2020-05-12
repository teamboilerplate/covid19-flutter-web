import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:covid19/models/statistics/statistics_response_model.dart';
import 'package:covid19/models/statistics/countries_list_model.dart';
import 'package:covid19/data/repository/base_repository.dart';
import 'package:covid19/data/repository/user_repository.dart';
import 'package:covid19/data/countries_list_data.dart';
import 'package:covid19/icons/covid19_icons.dart';
import 'package:covid19/constants/app_theme.dart';
import 'package:covid19/constants/strings.dart';
import 'package:covid19/constants/text_styles.dart';
import 'package:covid19/constants/colors.dart';
import 'package:covid19/constants/dimens.dart';
import 'package:covid19/res/asset_images.dart';
import 'package:covid19/stores/statistics/statistics_notifier.dart';
import 'package:covid19/ui/static/static_error_screen.dart';
import 'package:covid19/ui/statistics//widgets/statistics_loading_widget_mobile.dart';
import 'package:covid19/ui/statistics/widgets/statistiics_loading_widget_desktop.dart';
import 'package:covid19/ui/statistics/widgets/info_card_widget_mobile.dart';
import 'package:covid19/ui/statistics/widgets/info_graph_widget_mobile.dart';
import 'package:covid19/ui/statistics/widgets/info_card_widget_desktop.dart';
import 'package:covid19/ui/statistics/widgets/info_graph_widget_desktop.dart';
import 'package:covid19/ui/statistics/global_countries_details_screen.dart';
import 'package:covid19/utils/device/device_utils.dart';
import 'package:covid19/utils/custom_scroll_behaviour.dart';
import 'package:covid19/utils/emoji_flags.dart';
import 'package:covid19/widgets/progress_indicator_widget.dart';
import 'package:covid19/widgets/country_picker/country_picker_dialog.dart';
import 'package:covid19/widgets/sized_box_height_widget.dart';
import 'package:covid19/widgets/sized_box_width_widget.dart';

/// [StatisticsScreen] Displays the country Information and country statistics
/// Handles the various states of the [HomeChangeNotifier] to perform
/// the appropriate action
class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  bool isOffline = false;

  List<Countries> countriesList;
  DateTime today = DateTime.now();
  List<Countries> countrySearchItems = [];
  List<Countries> countryDataItems = [];
  String selectedCountry, selectedCountryISO2;
  final BaseRepository repository = UserRepository();
  int countryItemInfected,
      countryItemRecovered,
      countryItemActive,
      countryItemDeaths,
      countryItemNewInfected,
      countryItemNewRecovered,
      countryItemNewActive,
      countryItemNewDeaths;

  @override
  void initState() {
    super.initState();

    // Setting the value of [selectedCountry] and [selectedCountryISO2] which
    // used to display the current selected country and to fetch the flag flat icon
    // of the Country respectively
    //
    // Using [Futre.delayed] act as an additional secutiry layer to perform the requested
    // tasks before the UI is painted
    Future.delayed(
      const Duration(milliseconds: 10),
      () {
        // Using [Bloc] to obtain the state which contains the [selectedCountry], [selectedCountryISO2]
        // and [countriesList]

        // Setting today's date value
        today = DateTime.now();
        // Makign the Network Call to fetch the summary information for the selected country
        _fetchHomeData(iso2: selectedCountryISO2);

        setState(
          () {
            // selectedCountryISO2 = 'IN';
            countriesList =
                CountriesLisitModel.fromJson(jsonDecode(countriesListJSON))
                    .countries;

            // Adding all the items of the [countriesList] to [countrySearchItems]
            for (final item in countriesList) {
              countrySearchItems.add(
                Countries(
                  iso2: item.iso2,
                  name: item.name,
                ),
              );
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Fetching Global Information and about selected countri/Home Country
  Future<void> _fetchHomeData({String iso2, String countryName}) async {
    Provider.of<StatisticsChangeNotifier>(context, listen: false).fetchHomeData(
      iso2: iso2,
      countryName: countryName,
    );
  }

  // Building the row item for the Searchable Country Dialog
  Widget _buildDialogItem(Countries country) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          Emoji.byISOCode('flag_${country.iso2.toLowerCase()}').char,
          style: const TextStyle(
            fontSize: 30,
          ),
        ),
        const SizedBoxWidthWidget(15),
        Flexible(
          child: Text(
            country.name ?? '',
            style: TextStyles.statisticsHeadingTextStlye.copyWith(
              fontSize: 16,
            ),
          ),
        )
      ],
    );
  }

  // Method used to open the Searchable Country Dialog
  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: themeData,
          child: CountryPickerDialog(
            isDividerEnabled: true,
            // Passing sort Comparator to sort the items of the list in ascending order
            sortComparator: (a, b) => a.name.compareTo(b.name),
            titlePadding: const EdgeInsets.all(8.0),
            searchCursorColor: AppColors.offBlackColor,
            countriesList: countrySearchItems,
            isSearchable: true,
            onValuePicked: (Countries country) {
              setState(
                () {
                  // Setting the values of [selectedCountry] and [selectedCountryISO2]
                  // after selecting a country.
                  // This data is used to fetch the Information and Statistics about
                  // the selectec country.
                  // selectedCountry = country.name;
                  // selectedCountryISO2 = country.iso2;
                  _fetchHomeData(
                    iso2: country.iso2,
                    countryName: country.name,
                  );
                },
              );
            },
            itemBuilder: _buildDialogItem,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final screenWidth = DeviceUtils.getScaledWidth(context, 1);
    final screenHeight = DeviceUtils.getScaledHeight(context, 1);
    // Wrapping the contents in [SafeArea] to avoid the Notch (When avaiable) and the bottom
    // navigation bar (Mostly comes in use for iOS Devices)
    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).userGestureInProgress) {
          return false;
        } else {
          return true;
        }
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: Consumer<StatisticsChangeNotifier>(
            builder: (
              BuildContext context,
              StatisticsChangeNotifier notifier,
              Widget child,
            ) {
              switch (notifier.state) {
                // Switch Case which signfiies that [StatisticsState] is Loading
                case StatisticsState.loading:
                  return ScreenTypeLayout.builder(
                    mobile: (BuildContext context) => Stack(
                      children: <Widget>[
                        StatisticsMobileLoadingWidget(
                          today: today,
                        ),
                        const CustomProgressIndicatorWidget(),
                      ],
                    ),
                    desktop: (BuildContext context) => Stack(
                      children: <Widget>[
                        StatisticsDesktopLoadingWidget(
                          today: today,
                        ),
                        const CustomProgressIndicatorWidget(),
                      ],
                    ),
                  );

                // Switch Case which signfiies that [StatisticsState] has some content
                case StatisticsState.hasData:
                  final StatisticseData data = notifier.data;
                  selectedCountryISO2 = data.countryInformation.countryCode;
                  selectedCountry = data.countryInformation.countryName;

                  // Fetching the index of the selected country
                  // TODO :- Change this post summary API being available country-wise
                  int currentCountryIndex =
                      data.statisticsInformationData.countries.indexWhere(
                    (item) => item.countryCode == selectedCountryISO2,
                  );

                  // Adding negative checker clause (Not Found) if the data is not initialised yet
                  if (currentCountryIndex < 0) {
                    currentCountryIndex = 0;
                  }
                  // [ScreenTypeLayout] is used to build the widgets based on the user's device screens
                  return ScreenTypeLayout.builder(
                    // Mobile Screen Layout
                    mobile: (BuildContext context) => statisticsMobileScreen(
                      context,
                      screenWidth,
                      screenHeight,
                      data,
                      currentCountryIndex,
                    ),
                    // Desktop Screen Layout
                    desktop: (BuildContext context) => statisticsDesktopScreen(
                      context,
                      screenWidth,
                      screenHeight,
                      data,
                      currentCountryIndex,
                    ),
                  );

                // Switch Case which signfiies that [StatisticsState] has some Generic error
                case StatisticsState.hasError:
                  final error = notifier.error;
                  return Scaffold(
                    body: Center(
                      child: StaticErrorScreen(
                        image: const AssetImage(AssetImages.genericError),
                        title: error,
                        desc: Strings.genericErrorDesc,
                        actionText: Strings.retryButton,
                        onRetry: () => notifier.fetchHomeData(
                          iso2: selectedCountryISO2,
                          countryName: selectedCountry,
                        ),
                      ),
                    ),
                  );

                // Switch Case which signfiies that [StatisticsState] has Network error
                case StatisticsState.hasNetworkError:
                  final error = notifier.error;
                  return Scaffold(
                    body: Center(
                      child: StaticErrorScreen(
                        image: const AssetImage(AssetImages.noInternet),
                        title: error,
                        desc: Strings.noInternetErrorDesc,
                        actionText: Strings.retryButton,
                        onRetry: () => notifier.fetchHomeData(
                          iso2: selectedCountryISO2,
                          countryName: selectedCountry,
                        ),
                      ),
                    ),
                  );

                // Switch Case which signfiies that [StatisticsState] is Unitlialised
                // which is the default state for [StatisticsState]
                case StatisticsState.unInit:
                  return const Center(
                    child: CustomProgressIndicatorWidget(),
                  );
              }
              // If the state of [StatisticsState] is none of the switched states,
              // returning an empty container to catch it if it ever occurs
              // This should never happen.
              return Container();
            },
          ),
        ),
      ),
    );
  }

  /// Displays the Global and Country-wise Statistics
  ///
  /// **Requires**
  /// 1. [context] - Current context of where the widget is substituted (Used to Pop the Navigation Stack)
  /// 2. [screenWidth] - Device Screen Width
  /// 3. [screenHeight] - Device Screen Height
  /// 4. [data] - Data fetched from [StatisticsNotifier] which includes Global and country-wise data
  /// 5. [currentCountryIndex] - Index of the current country picked by user or by default, home country of user
  /// Supports Mobile Screen Sizes
  Widget statisticsMobileScreen(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    StatisticseData data,
    int currentCountryIndex,
  ) {
    return RefreshIndicator(
      onRefresh: () => _fetchHomeData(
        iso2: selectedCountryISO2,
        countryName: selectedCountry,
      ),
      color: AppColors.accentColor,
      child: ScrollConfiguration(
        behavior: const CustomScrollBehaviour(),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              Dimens.horizontalPadding / 2.5,
              Dimens.verticalPadding / 0.75,
              0,
              Dimens.verticalPadding / 0.3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Back Icon
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Covid19Icons.keyboardArrowLeft,
                    size: screenHeight / 45,
                    color: AppColors.blackColor,
                  ),
                ),

                // Vertical Spacing
                SizedBoxHeightWidget(screenHeight / 50),

                // Page Title
                Text(
                  Strings.outbreakTitle,
                  style: TextStyles.statisticsHeadingTextStlye.copyWith(
                    fontSize: screenHeight / 45,
                  ),
                ),

                // Current Date
                Text(
                  todayDateFormatter(today) ?? '',
                  style: TextStyles.statisticsSubHeadingTextStlye.copyWith(
                    fontSize: screenHeight / 60,
                  ),
                ),

                // Vertical Spacing
                SizedBoxHeightWidget(screenHeight / 100),

                // Global Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        right: screenWidth / 50,
                      ),
                      child: Text(
                        Strings.globalTitle,
                        softWrap: true,
                        style: TextStyles.hightlightText.copyWith(
                          fontSize: screenHeight / 30,
                        ),
                      ),
                    ),
                    Icon(
                      Covid19Icons.globe,
                      size: screenHeight / 35,
                      color: AppColors.blackColor,
                    ),
                  ],
                ),

                // Vertical Spacing
                SizedBoxHeightWidget(screenHeight / 100),

                // Last Updated On Information
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  direction: Axis.horizontal,

                  // Last Updated Date & Time
                  children: <Widget>[
                    Text(
                      lastUpdateDateFormatter(
                            data.statisticsInformationData.date,
                          ) ??
                          '',
                      maxLines: 2,
                      softWrap: true,
                      style: TextStyles.statisticsSubHeadingTextStlye.copyWith(
                        fontSize: screenHeight / 70,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _fetchHomeData(
                        iso2: selectedCountryISO2,
                        countryName: selectedCountry,
                      ),
                      child: Icon(
                        Covid19Icons.autorenew,
                        size: screenHeight / 65,
                        color: AppColors.offBlackColor,
                      ),
                    ),
                  ],
                ),

                // Vertical Spacing
                SizedBoxHeightWidget(screenHeight / 50),

                //Details Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GlobalCountriesDetails(
                            globalCountriesList:
                                data.statisticsInformationData.countries,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          right: Dimens.horizontalPadding / 0.75,
                        ),
                        child: Text(
                          Strings.details,
                          maxLines: 2,
                          softWrap: true,
                          style: TextStyles.statisticsAccentTextStyle.copyWith(
                            fontSize: screenHeight / 50,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Vertical Spacing
                SizedBoxHeightWidget(screenHeight / 75),

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
                        child: InfoCardMobileWidget(
                          infoColor: AppColors.confirmedColor,
                          infoIcon: Covid19Icons.add,
                          infoValueNew: data
                              .statisticsInformationData.global.newConfirmed,
                          infoValue: data
                              .statisticsInformationData.global.totalConfirmed,
                          infoLabel: Strings.infectedLabel,
                        ),
                      ),

                      // Horizontal Spacing
                      SizedBoxWidthWidget(screenWidth / 75),

                      // Global Recovered Cases
                      Expanded(
                        flex: 1,
                        child: InfoCardMobileWidget(
                          infoColor: AppColors.recoveredColor,
                          infoIcon: Covid19Icons.favorite,
                          infoValueNew: data
                              .statisticsInformationData.global.newRecovered,
                          infoValue: data
                              .statisticsInformationData.global.totalRecovered,
                          infoLabel: Strings.recoveredLabel,
                        ),
                      ),

                      // Horizontal Spacing˝
                      SizedBoxWidthWidget(screenWidth / 75),

                      // Global Active Cases
                      Expanded(
                        flex: 1,
                        child: InfoCardMobileWidget(
                          infoColor: AppColors.activeColor,
                          infoIcon: Icons.text_format,
                          infoValueNew: data.statisticsInformationData.global
                                  .newConfirmed -
                              (data.statisticsInformationData.global
                                      .newRecovered +
                                  data.statisticsInformationData.global
                                      .newDeaths),
                          infoValue: data.statisticsInformationData.global
                                  .totalConfirmed -
                              (data.statisticsInformationData.global
                                      .totalRecovered +
                                  data.statisticsInformationData.global
                                      .totalDeaths),
                          infoLabel: Strings.activeLabel,
                        ),
                      ),

                      // Horizontal Spacing
                      SizedBoxWidthWidget(screenWidth / 75),

                      // Global Deaths
                      Expanded(
                        flex: 1,
                        child: InfoCardMobileWidget(
                          infoColor: AppColors.deadColor,
                          infoIcon: Covid19Icons.close,
                          infoValueNew:
                              data.statisticsInformationData.global.newDeaths,
                          infoValue:
                              data.statisticsInformationData.global.totalDeaths,
                          infoLabel: Strings.deathsLabel,
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

                // Country Title
                // Gesture Detector is used to eliminate the ripple effect
                GestureDetector(
                  onTap: () {
                    _openCountryPickerDialog();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 5,
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: screenWidth / 50,
                          ),
                          child: Text(
                            selectedCountry ?? '',
                            softWrap: true,
                            style: TextStyles.hightlightText.copyWith(
                              fontSize: screenHeight / 30,
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Text(
                          // Adding null checker clause if the data is not initialised yet
                          selectedCountryISO2 != null
                              ? Emoji.byISOCode(
                                      'flag_${selectedCountryISO2.toLowerCase()}')
                                  .char
                              : '',
                          style: TextStyle(
                            fontSize: screenHeight / 35,
                          ),
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Icon(
                          Covid19Icons.arrowDropDown,
                          size: screenHeight / 30,
                          color: AppColors.offBlackColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Vertical Spacing
                SizedBoxHeightWidget(screenHeight / 200),

                // Details Button
                // TODO :- Country Specific Details
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: <Widget>[
                //     Padding(
                //       padding: const EdgeInsets.only(
                //         right: Dimens.horizontalPadding / 0.75,
                //       ),
                //       child: Text(
                //         Strings.details,
                //         maxLines: 2,
                //         softWrap: true,
                //         style: TextStyles
                //             .statisticsAccentTextStyle
                //             .copyWith(
                //           fontSize: screenHeight / 50,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

                // Vertical Spacing
                SizedBoxHeightWidget(screenHeight / 75),

                // Information Cards
                Padding(
                  padding: const EdgeInsets.only(
                    right: Dimens.horizontalPadding,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: InfoCardMobileWidget(
                          infoColor: AppColors.confirmedColor,
                          infoIcon: Covid19Icons.add,
                          infoValueNew: data.statisticsInformationData
                              .countries[currentCountryIndex].newConfirmed,
                          infoValue: data.statisticsInformationData
                              .countries[currentCountryIndex].totalConfirmed,
                          infoLabel: Strings.infectedLabel,
                        ),
                      ),

                      // Horizontal Spacing
                      SizedBoxWidthWidget(screenWidth / 75),

                      // Country Speicific Recovered Cases
                      Expanded(
                        flex: 1,
                        child: InfoCardMobileWidget(
                          infoColor: AppColors.recoveredColor,
                          infoIcon: Covid19Icons.favorite,
                          infoValueNew: data.statisticsInformationData
                              .countries[currentCountryIndex].newRecovered,
                          infoValue: data.statisticsInformationData
                              .countries[currentCountryIndex].totalRecovered,
                          infoLabel: Strings.recoveredLabel,
                        ),
                      ),

                      // Horizontal Spacing
                      SizedBoxWidthWidget(screenWidth / 75),

                      // Country Speicific Active Cases
                      Expanded(
                        flex: 1,
                        child: InfoCardMobileWidget(
                          infoColor: AppColors.activeColor,
                          infoIcon: Icons.text_format,
                          infoValueNew: data.statisticsInformationData
                                  .countries[currentCountryIndex].newConfirmed -
                              (data
                                      .statisticsInformationData
                                      .countries[currentCountryIndex]
                                      .newRecovered +
                                  data
                                      .statisticsInformationData
                                      .countries[currentCountryIndex]
                                      .newDeaths),
                          infoValue: data
                                  .statisticsInformationData
                                  .countries[currentCountryIndex]
                                  .totalConfirmed -
                              (data
                                      .statisticsInformationData
                                      .countries[currentCountryIndex]
                                      .totalRecovered +
                                  data
                                      .statisticsInformationData
                                      .countries[currentCountryIndex]
                                      .totalDeaths),
                          infoLabel: Strings.activeLabel,
                        ),
                      ),

                      // Horizontal Spacing
                      SizedBoxWidthWidget(screenWidth / 75),

                      // Country Speicific Deaths
                      Expanded(
                        flex: 1,
                        child: InfoCardMobileWidget(
                          infoColor: AppColors.deadColor,
                          infoIcon: Covid19Icons.close,
                          infoValueNew: data.statisticsInformationData
                              .countries[currentCountryIndex].newDeaths,
                          infoValue: data.statisticsInformationData
                              .countries[currentCountryIndex].totalDeaths,
                          infoLabel: Strings.deathsLabel,
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
                      style: TextStyles.statisticsHeadingTextStlye.copyWith(
                        fontSize: screenWidth / 18,
                      ),
                    ),
                  ],
                ),

                // Vertical Spacing
                SizedBoxHeightWidget(screenHeight / 75),

                // Information Tab
                InfoGraphWidget(
                  countryStatisticsConfirmedList:
                      data.countryStatisticsConfirmedList,
                  countryStatisticsRecoveredList:
                      data.countryStatisticsRecoveredList,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Displays the Global and Country-wise Statistics
  ///
  /// **Requires**
  /// 1. [context] - Current context of where the widget is substituted (Used to Pop the Navigation Stack)
  /// 2. [screenWidth] - Device Screen Width
  /// 3. [screenHeight] - Device Screen Height
  /// 4. [data] - Data fetched from [StatisticsNotifier] which includes Global and country-wise data
  /// 5. [currentCountryIndex] - Index of the current country picked by user or by default, home country of user
  /// Supports Desktop Screen Sizes
  Widget statisticsDesktopScreen(
    BuildContext context,
    double screenWidth,
    double screenHeight,
    StatisticseData data,
    int currentCountryIndex,
  ) {
    // Copying the List of [HomeCountries] without a reference to the original List
    final List<HomeCountries> globalCountriesList =
        List.from(data.statisticsInformationData.countries);

    // Sorting the new List of [HomeCountries] in descending order of Confirmed Cases
    globalCountriesList
        .sort((a, b) => b.totalConfirmed.compareTo(a.totalConfirmed));

    return RefreshIndicator(
      onRefresh: () => _fetchHomeData(
        iso2: selectedCountryISO2,
        countryName: selectedCountry,
      ),
      color: AppColors.accentColor,
      child: ScrollConfiguration(
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
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,

                      // Last Updated Date & Time
                      children: <Widget>[
                        Text(
                          lastUpdateDateFormatter(
                                data.statisticsInformationData.date,
                              ) ??
                              '',
                          maxLines: 2,
                          softWrap: true,
                          style:
                              TextStyles.statisticsSubHeadingTextStlye.copyWith(
                            fontSize: screenHeight / 50,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _fetchHomeData(
                            iso2: selectedCountryISO2,
                            countryName: selectedCountry,
                          ),
                          child: Icon(
                            Covid19Icons.autorenew,
                            size: screenHeight / 50,
                            color: AppColors.offBlackColor,
                          ),
                        ),
                      ],
                    ),

                    // Vertical Spacing
                    SizedBoxHeightWidget(screenHeight / 50),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Global Information
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
                                  child: InfoCardDesktopWidget(
                                    infoColor: AppColors.confirmedColor,
                                    infoIcon: Covid19Icons.add,
                                    infoValueNew: data.statisticsInformationData
                                        .global.newConfirmed,
                                    infoValue: data.statisticsInformationData
                                        .global.totalConfirmed,
                                    infoLabel: Strings.infectedLabel,
                                  ),
                                ),

                                // Horizontal Spacing
                                SizedBoxWidthWidget(screenWidth / 75),

                                // Global Recovered Cases
                                Expanded(
                                  flex: 1,
                                  child: InfoCardDesktopWidget(
                                    infoColor: AppColors.recoveredColor,
                                    infoIcon: Covid19Icons.favorite,
                                    infoValueNew: data.statisticsInformationData
                                        .global.newRecovered,
                                    infoValue: data.statisticsInformationData
                                        .global.totalRecovered,
                                    infoLabel: Strings.recoveredLabel,
                                  ),
                                ),

                                // Horizontal Spacing˝
                                SizedBoxWidthWidget(screenWidth / 75),

                                // Global Active Cases
                                Expanded(
                                  flex: 1,
                                  child: InfoCardDesktopWidget(
                                    infoColor: AppColors.activeColor,
                                    infoIcon: Icons.text_format,
                                    infoValueNew: data.statisticsInformationData
                                            .global.newConfirmed -
                                        (data.statisticsInformationData.global
                                                .newRecovered +
                                            data.statisticsInformationData
                                                .global.newDeaths),
                                    infoValue: data.statisticsInformationData
                                            .global.totalConfirmed -
                                        (data.statisticsInformationData.global
                                                .totalRecovered +
                                            data.statisticsInformationData
                                                .global.totalDeaths),
                                    infoLabel: Strings.activeLabel,
                                  ),
                                ),

                                // Horizontal Spacing
                                SizedBoxWidthWidget(screenWidth / 75),

                                // Global Deaths
                                Expanded(
                                  flex: 1,
                                  child: InfoCardDesktopWidget(
                                    infoColor: AppColors.deadColor,
                                    infoIcon: Covid19Icons.close,
                                    infoValueNew: data.statisticsInformationData
                                        .global.newDeaths,
                                    infoValue: data.statisticsInformationData
                                        .global.totalDeaths,
                                    infoLabel: Strings.deathsLabel,
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
                                  // Global Cases List Header label
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

                                  // Gloabl Cases List of Countries
                                  Expanded(
                                    flex: 8,
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: globalCountriesList.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        // Assigning Total Values for each country
                                        // Total Confirmed cases
                                        countryItemInfected =
                                            globalCountriesList[index]
                                                .totalConfirmed;

                                        // Total Recovered cases
                                        countryItemRecovered =
                                            globalCountriesList[index]
                                                .totalRecovered;

                                        // Total Active cases
                                        countryItemActive =
                                            globalCountriesList[index]
                                                    .totalConfirmed -
                                                (globalCountriesList[index]
                                                        .totalRecovered +
                                                    globalCountriesList[index]
                                                        .totalDeaths);

                                        // Total Death cases
                                        countryItemDeaths =
                                            globalCountriesList[index]
                                                .totalDeaths;

                                        // Assigning New Values for each country
                                        // New Confirmed cases
                                        countryItemNewInfected =
                                            globalCountriesList[index]
                                                .newConfirmed;

                                        // New Recovered cases
                                        countryItemNewRecovered =
                                            globalCountriesList[index]
                                                .newRecovered;

                                        // New Active cases
                                        countryItemNewActive =
                                            globalCountriesList[index]
                                                    .newConfirmed -
                                                (globalCountriesList[index]
                                                        .newRecovered +
                                                    globalCountriesList[index]
                                                        .newDeaths);

                                        // New Death cases
                                        countryItemNewDeaths =
                                            globalCountriesList[index]
                                                .newDeaths;

                                        // Item that display the Country Item
                                        return Container(
                                          margin: EdgeInsets.symmetric(
                                            vertical: screenHeight / 150,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth / 100,
                                            vertical: screenHeight / 100,
                                          ),

                                          // Adding alternate colours to the List
                                          decoration: BoxDecoration(
                                            color: index % 2 == 0
                                                ? AppColors.activeColor
                                                    .withOpacity(0.1)
                                                : AppColors.activeColor
                                                    .withOpacity(0.2),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(
                                                screenHeight / 50,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              // Country Label
                                              Expanded(
                                                flex: 1,
                                                child: Text(
                                                  globalCountriesList[index]
                                                      .country,
                                                  style: TextStyle(
                                                    fontSize: screenHeight / 60,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),

                                              // Country Cases (New and Total)
                                              Expanded(
                                                flex: 4,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // New Cases Values
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        // New Infected Cases
                                                        Expanded(
                                                          child: Text(
                                                            countryItemNewInfected ==
                                                                    0
                                                                ? '$countryItemNewInfected'
                                                                : '+ $countryItemNewInfected',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyles
                                                                .statisticsAccentTextStyle
                                                                .copyWith(
                                                              color: AppColors
                                                                  .confirmedColor,
                                                            ),
                                                          ),
                                                        ),

                                                        // New Recovered Cases
                                                        Expanded(
                                                          child: Text(
                                                            countryItemNewRecovered ==
                                                                    0
                                                                ? '$countryItemNewRecovered'
                                                                : '+ $countryItemNewRecovered',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyles
                                                                .statisticsAccentTextStyle
                                                                .copyWith(
                                                              color: AppColors
                                                                  .recoveredColor,
                                                            ),
                                                          ),
                                                        ),

                                                        // New Active Cases
                                                        Expanded(
                                                          child: Text(
                                                            countryItemNewActive >
                                                                    0
                                                                ? '+ $countryItemNewActive'
                                                                : countryItemNewActive
                                                                            .abs() ==
                                                                        0
                                                                    ? '${countryItemNewActive.abs()}'
                                                                    : '- ${countryItemNewActive.abs()}',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyles
                                                                .statisticsAccentTextStyle
                                                                .copyWith(
                                                              color: AppColors
                                                                  .activeColor,
                                                            ),
                                                          ),
                                                        ),

                                                        // New Deceased Cases
                                                        Expanded(
                                                          child: Text(
                                                            countryItemNewDeaths ==
                                                                    0
                                                                ? '$countryItemNewDeaths'
                                                                : '+ $countryItemNewDeaths',
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyles
                                                                .statisticsAccentTextStyle
                                                                .copyWith(
                                                              color: AppColors
                                                                  .deadColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    // Total Cases Values
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        // Total Infected Cases
                                                        Expanded(
                                                          child: Text(
                                                            '$countryItemInfected',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),

                                                        // Total Recovered Cases
                                                        Expanded(
                                                          child: Text(
                                                            '$countryItemRecovered',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),

                                                        // Total Active Cases
                                                        Expanded(
                                                          child: Text(
                                                            '$countryItemActive',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),

                                                        // Total Deceased Casesƒ
                                                        Expanded(
                                                          child: Text(
                                                            '$countryItemDeaths',
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
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

                    // Adding a Vertical Separator between the Global and Country-wise Information
                    Container(
                      width: 25,
                    ),

                    // Country-wise Information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Country Title
                          // Gesture Detector is used to eliminate the ripple effect
                          GestureDetector(
                            onTap: () {
                              _openCountryPickerDialog();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  flex: 10,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      right: screenWidth / 120,
                                    ),
                                    child: Text(
                                      selectedCountry ?? '',
                                      softWrap: true,
                                      style: TextStyles.hightlightText.copyWith(
                                        fontSize: screenHeight / 25,
                                      ),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Text(
                                    // Adding null checker clause if the data is not initialised yet
                                    selectedCountryISO2 != null
                                        ? Emoji.byISOCode(
                                                'flag_${selectedCountryISO2.toLowerCase()}')
                                            .char
                                        : '',
                                    style: TextStyle(
                                      fontSize: screenHeight / 35,
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: 1,
                                  child: Icon(
                                    Covid19Icons.arrowDropDown,
                                    size: screenWidth / 60,
                                    color: AppColors.offBlackColor,
                                  ),
                                ),
                              ],
                            ),
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
                                  child: InfoCardDesktopWidget(
                                    infoColor: AppColors.confirmedColor,
                                    infoIcon: Covid19Icons.add,
                                    infoValueNew: data
                                        .statisticsInformationData
                                        .countries[currentCountryIndex]
                                        .newConfirmed,
                                    infoValue: data
                                        .statisticsInformationData
                                        .countries[currentCountryIndex]
                                        .totalConfirmed,
                                    infoLabel: Strings.infectedLabel,
                                  ),
                                ),

                                // Horizontal Spacing
                                SizedBoxWidthWidget(screenWidth / 75),

                                // Country Speicific Recovered Cases
                                Expanded(
                                  flex: 1,
                                  child: InfoCardDesktopWidget(
                                    infoColor: AppColors.recoveredColor,
                                    infoIcon: Covid19Icons.favorite,
                                    infoValueNew: data
                                        .statisticsInformationData
                                        .countries[currentCountryIndex]
                                        .newRecovered,
                                    infoValue: data
                                        .statisticsInformationData
                                        .countries[currentCountryIndex]
                                        .totalRecovered,
                                    infoLabel: Strings.recoveredLabel,
                                  ),
                                ),

                                // Horizontal Spacing
                                SizedBoxWidthWidget(screenWidth / 75),

                                // Country Speicific Active Cases
                                Expanded(
                                  flex: 1,
                                  child: InfoCardDesktopWidget(
                                    infoColor: AppColors.activeColor,
                                    infoIcon: Icons.text_format,
                                    infoValueNew: data
                                            .statisticsInformationData
                                            .countries[currentCountryIndex]
                                            .newConfirmed -
                                        (data
                                                .statisticsInformationData
                                                .countries[currentCountryIndex]
                                                .newRecovered +
                                            data
                                                .statisticsInformationData
                                                .countries[currentCountryIndex]
                                                .newDeaths),
                                    infoValue: data
                                            .statisticsInformationData
                                            .countries[currentCountryIndex]
                                            .totalConfirmed -
                                        (data
                                                .statisticsInformationData
                                                .countries[currentCountryIndex]
                                                .totalRecovered +
                                            data
                                                .statisticsInformationData
                                                .countries[currentCountryIndex]
                                                .totalDeaths),
                                    infoLabel: Strings.activeLabel,
                                  ),
                                ),

                                // Horizontal Spacing
                                SizedBoxWidthWidget(screenWidth / 75),

                                // Country Speicific Deaths
                                Expanded(
                                  flex: 1,
                                  child: InfoCardDesktopWidget(
                                    infoColor: AppColors.deadColor,
                                    infoIcon: Covid19Icons.close,
                                    infoValueNew: data
                                        .statisticsInformationData
                                        .countries[currentCountryIndex]
                                        .newDeaths,
                                    infoValue: data
                                        .statisticsInformationData
                                        .countries[currentCountryIndex]
                                        .totalDeaths,
                                    infoLabel: Strings.deathsLabel,
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
                          InfoGraphDesktopWidget(
                            countryStatisticsConfirmedList:
                                data.countryStatisticsConfirmedList,
                            countryStatisticsRecoveredList:
                                data.countryStatisticsRecoveredList,
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
      ),
    );
  }
}

String todayDateFormatter(DateTime date) {
  const dayData =
      '{ "1" : "Mon", "2" : "Tue", "3" : "Wed", "4" : "Thur", "5" : "Fri", "6" : "Sat", "7" : "Sun" }';

  const monthData =
      '{ "1" : "Jan", "2" : "Feb", "3" : "Mar", "4" : "Apr", "5" : "May", "6" : "June", "7" : "Jul", "8" : "Aug", "9" : "Sep", "10" : "Oct", "11" : "Nov", "12" : "Dec" }';

  return '${json.decode(dayData)['${date.weekday}']}, ${date.day.toString()} ${json.decode(monthData)['${date.month}']} ${date.year.toString()}';
}

String lastUpdateDateFormatter(String date) {
  final parsedDateTime = DateTime.parse(date);

  return 'Information Last Updated : ${todayDateFormatter(parsedDateTime.toLocal())} ${parsedDateTime.toLocal().hour.toString()}:${parsedDateTime.toLocal().minute.toString()}';
}
