import 'package:covid19/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:covid19/constants/app_theme.dart';
import 'package:covid19/constants/strings.dart';
import 'package:covid19/data/repository/base_repository.dart';
import 'package:covid19/data/repository/user_repository.dart';
import 'package:covid19/stores/statistics/statistics_notifier.dart';

/// The main function is the entry point of our application,
/// telling Dart where it should start running our code
void main() {
  runApp(MyApp());
}

/// [Provider] is used to mangage states for the data
/// corresponding to the [StatisticsScreen]
class MyApp extends StatelessWidget {
  final BaseRepository repository = UserRepository();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StatisticsChangeNotifier(
        userRepository: repository,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Strings.appName,
        theme: themeData,
        routes: Routes.routes,
      ),
    );
  }
}
