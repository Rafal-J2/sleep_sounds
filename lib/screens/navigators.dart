
//import 'package:admob_flutter/admob_flutter.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sleep_sounds/fun/arrays_3_4.dart';
import 'package:sleep_sounds/models/data_provider.dart';
import 'package:sleep_sounds/screens/main_screen.dart';
import 'package:sleep_sounds/screens/mixes.dart';
import 'package:sleep_sounds/screens/screen_two.dart';
import 'package:sleep_sounds/services/admob_service.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import 'menu.dart';


class Navigators extends StatefulWidget {
  @override
  _NavigatorsState createState() => _NavigatorsState();
}

class _NavigatorsState extends State<Navigators> {

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Save States in BottomNavigationBar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);
  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ThemeMode themeMode = ThemeMode.light;
  late var _selectedPageIndex;
  late List<Widget> _pages;
  PageController? _pageController;

  final ams = AdMobService();
  final dataStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    _switchThemeMode();
    _selectedPageIndex = 0;
    _pages = [
      GoodDream(),
      CheckoutPage(),
      Menu(),
      Mix(),
    ];
    /// Save state all screens
    _pageController = PageController(initialPage: _selectedPageIndex);
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


  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> admobBaner = <Widget>[];
    admobBaner.add(Container(
      // child: AdmobBanner(
      //   adUnitId: ams.getBannerAdId()!,
      //   adSize: AdmobBannerSize.ADAPTIVE_BANNER(
      //       width: MediaQuery.of(context).size.width.toInt()),
      // ),
    ));
    return Consumer<DataProvider>(builder: (
      context,
      cart,
      child,
    ) {
      return MaterialApp(
        theme: FlexColorScheme.light(
                scheme: FlexScheme.red,
                //   onSecondary: Colors.white,
                scaffoldBackground: Color(0xFF20124d),
                /// Colors Navigation Bar
                background: Color(0xFF20124d))
            .toTheme,
        darkTheme: FlexColorScheme.dark(
          scheme: FlexScheme.red,
          onPrimary: Colors.white,
          //  scaffoldBackground: Colors.black87,
        ).toTheme,
        //  themeMode: arrays4[0].checkThemeMode,
      //  themeMode: cart.basketItems3.isEmpty ? ThemeMode.system : cart.basketItems3[0].checkThemeMode,
        themeMode: cart.basketItems3.isEmpty ? themeMode : arrays4[0].checkThemeMode,
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(),
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.red,
            selectedIconTheme: IconThemeData(color: Colors.red),
            //   backgroundColor: Color(0xFF20124d),
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Mix Sounds ',
              ),
              BottomNavigationBarItem(
               icon: cart.count <= 0
                    ? Icon(Icons.surround_sound)
                    : Lottie.asset('assets/lottieFiles/sounds_waves.json'),
                label: 'Active Sounds - ${cart.count.toString()}',
                /*
                icon: Icon(Icons.surround_sound,
                    color: cart.count <= 0
                        ? null
                        : Colors.white),*/
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu),
                label: 'Settings',
              ),
            ],
            //   selectedItemColor: Colors.white,
            //   unselectedItemColor: Colors.blue,
            showSelectedLabels: true,
            currentIndex: _selectedPageIndex,
            onTap: (selectedPageIndex) {
              setState(() {
                _selectedPageIndex = selectedPageIndex;
                _pageController!.jumpToPage(selectedPageIndex);
              });
            },
          ),
          // Admob banner
          //    persistentFooterButtons: admobBaner,
          /// Colors ADS
          //  backgroundColor: Color(0xFF20124d),
        ),
      );
    });
  }
}