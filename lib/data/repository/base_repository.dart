import 'package:flutter/material.dart';
import 'package:covid19/models/application/ip_model.dart';
import 'package:covid19/models/application/country_information_model.dart';
import 'package:covid19/models/statistics/statistics_response_model.dart';
import 'package:covid19/models/statistics/country_statistics_day_model.dart';

/// Repository that houses all the methods to make API requests
///
/// [TestRepository] and [UserRepository] extend the BaseRepository
/// to override and implement the API requests
abstract class BaseRepository {
  /// Fetch IP of the user
  Future<IPModel> fetchUserIP();

  /// Fetch Current Country iso2 for the user
  Future<CountryInformationModel> fetchUserCountryInformation(
      {@required String ipAddress});

  /// Fetch Global Information and country specific information
  Future<StatisticsResponseModel> fetchHomeData({@required String iso2});

  /// Fetch Statistics about the required country - Confirmed Cases
  Future<List<CountryStatistics>> fetchCountryStatisticsConfirmed(
      {@required String iso2});

  /// Fetch Statistics about the required country - Confirmed Cases
  Future<List<CountryStatistics>> fetchCountryStatisticsRecovered(
      {@required String iso2});
}
