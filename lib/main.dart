import 'package:covid19/constants/app_theme.dart';
import 'package:covid19/constants/strings.dart';
import 'package:covid19/data/repository/base_repository.dart';
import 'package:covid19/data/repository/user_repository.dart';
import 'package:covid19/stores/statistics/statistics_notifier.dart';
import 'package:covid19/ui/home/home_navigator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final BaseRepository repository = UserRepository();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Strings.appName,
      theme: themeData,
      home: Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => StatisticsChangeNotifier(
            userRepository: repository,
          ),
          child: HomeNavigator(),
        ),
      ),
    );
  }
}
