import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sleep_sounds/models/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

import 'fun/splash_screen.dart';

void main() async {
  await GetStorage.init();
// FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
const MyApp({Key? key}) : super(key: key);
// Firebase
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

 
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    var materialApp = const MaterialApp(
      debugShowCheckedModeBanner: false,
    home: SplashScreen(),
    );
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: materialApp,
    );
  }
}
