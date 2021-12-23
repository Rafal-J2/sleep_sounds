import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sleep_sounds/fun/arrays_3_4.dart';
import 'package:sleep_sounds/fun/foreground_service.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:sleep_sounds/models/data_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage>
    with AutomaticKeepAliveClientMixin {

  final dataStorage = GetStorage();

  @override
  void initState(){
    super.initState();
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

 ThemeMode themeMode = ThemeMode.light;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Size screenSize = MediaQuery.of(context).size;
    return Consumer<DataProvider>(
      builder: (context, cart, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: FlexColorScheme.light(
            scheme: FlexScheme.red,
            onSecondary: Colors.white,
            scaffoldBackground: const Color(0xFF20124d),
          ).toTheme,
          darkTheme: FlexColorScheme.dark(
            scheme: FlexScheme.red,
          ).toTheme,
          themeMode: cart.basketItems3.isEmpty ? themeMode : arrays4[0].checkThemeMode,
          home: Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(40.0),
              child: AppBar(
                systemOverlayStyle:
                    const SystemUiOverlayStyle(statusBarColor: Colors.black),
                title: const Text('Active sounds'),
              ),
            ),
            body: ListView(
              children: <Widget>[
                Center(
                  child: cart.count == 0
                      ? const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Text(
                            'No active sounds',
                            style: TextStyle(fontSize: 28, color: Colors.white),
                          ),
                        )
                      : null,
                ),
                Center(child: cart.count <= 0 ? Lottie.asset('assets/lottieFiles/relax.json') : null),
                SizedBox(
                  // width: 50.0,
                  height: screenSize.height,
                  child: ListView.builder(
                      itemCount: cart.basketItems.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.black26,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 8.0),
                                          child: Image(
                                            height: 50.0,
                                            width: 50.0,
                                            image: AssetImage(
                                              cart.basketItems[index].picOff!,
                                            ),
                                          ),
                                        ),
                                        PlayerBuilder.volume(
                                            player: cart.basketItems[index].player,
                                            builder: (context, _vol) {
                                              return Slider(
                                                  activeColor: Colors.white,
                                                  value: _vol,
                                                  min: 0,
                                                  max: 1,
                                                  divisions: 50,
                                                  onChanged: (v) {
                                                    setState(() {
                                                      cart.basketItems[index].player
                                                          .setVolume(v);
                                                    });
                                                  });
                                            }),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_forever,
                                            color: Colors.white,
                                          ),
                                          iconSize: 48.0,
                                          onPressed: () {
                                            // Pause sounds with page one
                                            cart.basketItems[index].player.pause();
                                            cart.basketItems[index].isFav = false;
                                            cart.remove(cart.basketItems[index]);
                                            if (cart.count == 0) {
                                              foregroundServiceStop();
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                ),

              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
