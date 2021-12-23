import 'dart:developer';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:sleep_sounds/fun/arrays_3_4.dart';
import 'package:sleep_sounds/fun/mode_switch.dart';
import 'package:sleep_sounds/fun/show_dialogs.dart';
import 'package:sleep_sounds/models/data_provider.dart';

class Menu extends StatefulWidget {
  const Menu({
    Key? key,}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with AutomaticKeepAliveClientMixin {

  final dataStorage = GetStorage();

  @override
  void initState() {
    super.initState();
    dataStorage.read('intCheck');
    log("what is inCheck in initState: $intCheck");
    log("dataStorage.read: ${dataStorage.read('intCheck')}");
    _switchThemeMode();
  }

  void _switchThemeMode(){
    switch(dataStorage.read('intCheck')){
      case 0 :
        themeMode = ThemeMode.light;
        debugPrint('switchThemeMode - ThemeMode.light*');
        break;
      case 1 :
      themeMode = ThemeMode.dark;
        debugPrint('ThemeMode.dark*');
        break;
      case 2 :
       themeMode = ThemeMode.system;
        debugPrint('ThemeMode.system*');
    }
  }

   _checkStorage() {
  if(themeMode == ThemeMode.light) {
    intCheck = 0;
  } else if (themeMode == ThemeMode.dark){
    intCheck = 1;
  } else {intCheck = 2;}
  dataStorage.write('intCheck', intCheck);
  log("dataStorage.write ${dataStorage.write('intCheck', intCheck)}");
}

    int intCheck = 2;
  late ThemeMode themeMode;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<DataProvider>(builder: (
        context,
        cart,
        child,
        ) {
      return ListView(
        children: <Widget>[
          Column(
            children: [
              ListTile(
                title: const Text('Privacy Policy',
                    style: TextStyle(color: Colors.white)),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Privacy Policy'),
                          content: setupAlertDialogContainer(),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Approve'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
              ListTile(
                title: const Text(
                  'Acknowledgments',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Acknowledgments'),
                          content: showMyDialog3(),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Approve'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                },
              ),
              ListTile(
                title: const Text(
                  'Exit the application',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              ),
              Column(
                children: [
                  Container(
                    height: 200,
                    child: HomePage(
                      // We pass it the current theme mode.
                       themeMode:  themeMode,
                      // On the home page we can toggle theme mode between light and dark.
                      onThemeModeChanged: (ThemeMode mode) {
                        setState(() {
                         themeMode = mode;
                         _checkStorage();
                          arrays4[0].checkThemeMode = mode;
                          cart.add3(arrays4[0]);
                        });
                        log("acart.add3(arrays4[0]");
                      },
                      flexSchemeData: FlexColor.schemes[FlexScheme.red],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    });

  }

  @override
  bool get wantKeepAlive => true;


}



