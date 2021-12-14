import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sleep_sounds/fun/arrays_3_4.dart';
import 'package:sleep_sounds/fun/clock_timer.dart';
import 'package:sleep_sounds/services/admob_service.dart';
import 'package:sleep_sounds/models/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'TabView/tab_view_four.dart';
import 'TabView/tab_view_one.dart';
import 'TabView/tab_view_two.dart';
import 'TabView/tab_view_three.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';


void main() async {
  runApp(ChangeNotifierProvider(
    create: (context) => DataProvider(),
    child: GoodDream(),
  ));
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  await Firebase.initializeApp();
}

class GoodDream extends StatefulWidget {
  //Functions to Show Dialog
  GoodDream({
    Key? key,
    this.confirmWidget,
    this.cancelWidget,
    this.title,
    this.observer,
    this.themeMode,
    this.onThemeModeChanged,
  }) : super(key: key);

  final ThemeMode? themeMode;
  final ValueChanged<ThemeMode>? onThemeModeChanged;

// Firebase Analytics
  //final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver? observer;
  // Dialogs global
  final Widget? confirmWidget;
  final Widget? cancelWidget;
  final String? title;

  @override
  _State createState() => _State(observer);
}

class _State extends State<GoodDream>   {
  _State(
      // this.analytics,
      this.observer,
      );
  final FirebaseAnalyticsObserver? observer;
  final ams = AdMobService();


  @override
  void initState() {
    super.initState();
    _switchThemeMode();
  }

  final dataStorage = GetStorage();
  late int intCheck;

  _checkStorage() {
    if(arrays4[0].checkThemeMode == ThemeMode.light) {
      intCheck = 0;
      dataStorage.write('intCheck', intCheck);
    } else if (arrays4[0].checkThemeMode == ThemeMode.dark){
      intCheck = 1;
      dataStorage.write('intCheck', intCheck);
    } else {
      intCheck = 2;
      dataStorage.write('intCheck', intCheck);
    }
  }

  void _switchThemeMode(){
    switch(dataStorage.read('intCheck')){
      case 0 :
        themeMode = ThemeMode.light;
        print('switchThemeMode - ThemeMode.light*');
        break;
      case 1 :
        themeMode = ThemeMode.dark;
        print('ThemeMode.dark*');
        break;
      case 2 :
        themeMode = ThemeMode.system;
        print('ThemeMode.system*');
    }
  }

  ThemeMode themeMode = ThemeMode.light;

  void startServiceInPlatform() async {
    if (Platform.isAndroid) {
      var methodChannel = MethodChannel("com.retroportalstudio.messages");
      String? data = await methodChannel.invokeMethod("startService");
      debugPrint(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    /// This is for verification
    final Size screenSize = MediaQuery.of(context).size;
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Consumer<DataProvider>(builder: (
        context,
        cart,
        child,
        ) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: FlexColorScheme
            .light(scheme: FlexScheme.red,
            onSecondary: Colors.white,
            scaffoldBackground: Color(0xFF20124d)
        )
            .toTheme,
        darkTheme: FlexColorScheme
            .dark(scheme: FlexScheme.red,
          onPrimary: Colors.white,
        )
            .toTheme,
    //   themeMode: arrays4[0].checkThemeMode,
        themeMode: cart.basketItems3.isEmpty ? themeMode : arrays4[0].checkThemeMode,
     //  themeMode: cart.basketItems3.isEmpty ? ThemeMode.system : cart.basketItems3[0].checkThemeMode,

        home: DefaultTabController(
          length: 4,
          child: WillPopScope(
            onWillPop: () => onBackPressed(),
            child: Scaffold(
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(40.0),
                child: AppBar(
                  backwardsCompatibility: false,
                  systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.black),
                  flexibleSpace: SizedBox(
                    child: TabBar(
                      isScrollable: true,
                      physics: ClampingScrollPhysics (),
                      labelPadding: EdgeInsets.only(top: 28, left: 15, right: 15),
                      tabs: [
                        Tab(
                          child: Text("Nature"),
                        ),
                        Tab(
                          child: Text("Water"),
                        ),
                        Tab(
                          child: Text("Music"),
                        ),
                        Tab(
                          child: Text("Mechanical"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              body: Container(
                decoration: BoxDecoration(
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        children: <Widget>[
                          ListView(
                            children: <Widget>[
                              Container(
                                height: screenSize.height / 1.6,
                                child: TabViewOne(
                                ),
                              ),
                            ],
                          ),
                          ListView(
                            children: <Widget>[
                              Container(
                                // width: 50.0,
                                height: screenSize.height / 1.6,
                                //  color: Colors.black12,
                                child: TabViewTwo(),
                              ),
                            ],
                          ),
                          ListView(
                            children: <Widget>[
                              Container(
                                height: screenSize.height / 1.6,
                                child: TabViewThree(),
                              ),
                            ],
                          ),
                          ListView(
                            children: <Widget>[
                              Container(
                                height: screenSize.height / 1.6,
                                child: TabViewFour(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  //  _checkStorage(),
                    ClockTimer(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<bool> onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to exit an App'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    ).then((value) => value ?? false);
  }
}