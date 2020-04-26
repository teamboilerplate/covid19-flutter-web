import 'dart:async';
import 'dart:convert';
import 'package:covid19/data/countries_list_data.dart';
import 'package:covid19/data/repository/base_repository.dart';
import 'package:covid19/data/repository/user_repository.dart';
import 'package:covid19/models/application/country_information_model.dart';
import 'package:covid19/models/application/ip_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:covid19/constants/app_theme.dart';
import 'package:covid19/constants/colors.dart';
import 'package:covid19/constants/dimens.dart';
import 'package:covid19/constants/strings.dart';
import 'package:covid19/constants/text_styles.dart';
import 'package:covid19/icons/covid19_icons.dart';
import 'package:covid19/models/statistics/countries_list_model.dart';
import 'package:covid19/res/asset_images.dart';
import 'package:covid19/stores/statistics/statistics_notifier.dart';
import 'package:covid19/ui/static/static_error_screen.dart';
import 'package:covid19/ui/statistics//widgets/statistics_loading_widget.dart';
import 'package:covid19/ui/statistics/widgets/info_graph_widgert.dart';
import 'package:covid19/ui/statistics/widgets/info_widget.dart';
import 'package:covid19/utils/custom_scroll_behaviour.dart';
import 'package:covid19/utils/device/device_utils.dart';
import 'package:covid19/widgets/country_picker/country_picker_dialog.dart';
import 'package:covid19/widgets/progress_indicator_widget.dart';
import 'package:covid19/widgets/sized_box_height_widget.dart';
import 'package:covid19/widgets/sized_box_width_widget.dart';

/// Displays the country Information and country statistics
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
  String selectedCountry = '', selectedCountryISO2 = '';
  final BaseRepository repository = UserRepository();

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

        _fetchCountryInformation();

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
  Future<void> _fetchHomeData({@required String iso2}) async {
    Provider.of<StatisticsChangeNotifier>(context, listen: false).fetchHomeData(
      iso2: iso2,
    );
  }

  Future<void> _fetchCountryInformation() async {
    // Fetching the user's Address
    final IPModel ipaddress = await repository.fetchUserIP();

    // Fetching Information about User's country using the retrieved IP Address
    final CountryInformationModel userCountryInformation =
        await repository.fetchUserCountryInformation(
      ipAddress: ipaddress.origin,
    );
    setState(() {
      // setting the selected country code and country Name
      selectedCountryISO2 = userCountryInformation.countryCode;
      selectedCountry = userCountryInformation.countryName;

      // Setting today's date value
      today = DateTime.now();
      // Makign the Network Call to fetch the summary information for the selected country
      _fetchHomeData(iso2: selectedCountryISO2);
    });
  }

  // Building the row item for the Searchable Country Dialog
  Widget _buildDialogItem(Countries country) {
    return Row(
      children: <Widget>[
        Image.asset(
          'assets/flags/${country.iso2}.png',
          height: 32,
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
                  selectedCountry = country.name;
                  selectedCountryISO2 = country.iso2;
                  _fetchHomeData(iso2: selectedCountryISO2);
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
                  return Stack(
                    children: <Widget>[
                      HomeLoadingWidget(
                        today: today,
                      ),
                      const CustomProgressIndicatorWidget(),
                    ],
                  );

                // Switch Case which signfiies that [StatisticsState] has some content
                case StatisticsState.hasData:
                  final StatisticseData data = notifier.data;
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
                  return RefreshIndicator(
                    onRefresh: () => _fetchHomeData(
                      iso2: selectedCountryISO2,
                    ),
                    color: AppColors.accentColor,
                    child: ScrollConfiguration(
                      behavior: const CustomScrollBehaviour(),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                            Dimens.horizontalPadding,
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
                                  size: screenWidth / 12,
                                  color: AppColors.blackColor,
                                ),
                              ),

                              // Vertical Spacing
                              SizedBoxHeightWidget(screenHeight / 50),

                              // Page Title
                              Text(
                                Strings.outbreakTitle,
                                style: TextStyles.statisticsHeadingTextStlye
                                    .copyWith(
                                  fontSize: screenWidth / 23,
                                ),
                              ),

                              // Current Date
                              Text(
                                todayDateFormatter(today) ?? '',
                                style: TextStyles.statisticsSubHeadingTextStlye
                                    .copyWith(
                                  fontSize: screenWidth / 26,
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
                                        fontSize: screenWidth / 10,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Covid19Icons.globe,
                                    size: screenWidth / 12,
                                    color: AppColors.blackColor,
                                  ),
                                ],
                              ),

                              // Vertical Spacing
                              SizedBoxHeightWidget(screenHeight / 100),

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
                                    style: TextStyles
                                        .statisticsSubHeadingTextStlye
                                        .copyWith(
                                      fontSize: screenWidth / 30,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _fetchHomeData(
                                      iso2: selectedCountryISO2,
                                    ),
                                    child: Icon(
                                      Covid19Icons.autorenew,
                                      size: screenWidth / 28,
                                      color: AppColors.offBlackColor,
                                    ),
                                  ),
                                ],
                              ),

                              // Vertical Spacing
                              SizedBoxHeightWidget(screenHeight / 50),

                              // Details Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: Dimens.horizontalPadding / 0.75,
                                    ),
                                    child: Text(
                                      Strings.details,
                                      maxLines: 2,
                                      softWrap: true,
                                      style: TextStyles
                                          .statisticsAccentTextStyle
                                          .copyWith(
                                        fontSize: screenWidth / 22,
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
                                  right: Dimens.horizontalPadding,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: InfoCard(
                                        infoColor: AppColors.confirmedColor,
                                        infoIcon: Covid19Icons.add,
                                        infoValueNew: data
                                            .statisticsInformationData
                                            .global
                                            .newConfirmed,
                                        infoValue: data
                                            .statisticsInformationData
                                            .global
                                            .totalConfirmed,
                                        infoLabel: Strings.infectedLabel,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InfoCard(
                                        infoColor: AppColors.recoveredColor,
                                        infoIcon: Covid19Icons.favorite,
                                        infoValueNew: data
                                            .statisticsInformationData
                                            .global
                                            .newRecovered,
                                        infoValue: data
                                            .statisticsInformationData
                                            .global
                                            .totalRecovered,
                                        infoLabel: Strings.recoveredLabel,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InfoCard(
                                        infoColor: AppColors.deadColor,
                                        infoIcon: Covid19Icons.close,
                                        infoValueNew: data
                                            .statisticsInformationData
                                            .global
                                            .newDeaths,
                                        infoValue: data
                                            .statisticsInformationData
                                            .global
                                            .totalDeaths,
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
                                          style: TextStyles.hightlightText
                                              .copyWith(
                                            fontSize: screenWidth / 10,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Image.asset(
                                        'assets/flags/$selectedCountryISO2.png',
                                        height: 32,
                                      ),
                                    ),
                                    Flexible(
                                      flex: 1,
                                      child: Icon(
                                        Covid19Icons.arrowDropDown,
                                        size: screenWidth / 12,
                                        color: AppColors.offBlackColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Vertical Spacing
                              SizedBoxHeightWidget(screenHeight / 200),

                              // Details Button
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: Dimens.horizontalPadding / 0.75,
                                    ),
                                    child: Text(
                                      Strings.details,
                                      maxLines: 2,
                                      softWrap: true,
                                      style: TextStyles
                                          .statisticsAccentTextStyle
                                          .copyWith(
                                        fontSize: screenWidth / 22,
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
                                  right: Dimens.horizontalPadding,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(
                                      flex: 1,
                                      child: InfoCard(
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
                                    Expanded(
                                      flex: 1,
                                      child: InfoCard(
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
                                    Expanded(
                                      flex: 1,
                                      child: InfoCard(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    Strings.confirmedCasesTitle,
                                    maxLines: 2,
                                    softWrap: true,
                                    style: TextStyles.statisticsHeadingTextStlye
                                        .copyWith(
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
                        onRetry: () =>
                            notifier.fetchHomeData(iso2: selectedCountryISO2),
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
                        onRetry: () =>
                            notifier.fetchHomeData(iso2: selectedCountryISO2),
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

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
