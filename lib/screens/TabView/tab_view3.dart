import 'package:sleep_sounds/fun/arrays_3_4.dart';
import 'package:sleep_sounds/models/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:sleep_sounds/fun/funTabView.dart';

class TabViewThree extends StatefulWidget {
  const TabViewThree({
    Key? key,
    this.analytics,
    //   this.observer,
  }) : super(key: key);

  // Firebase Analytics
  final FirebaseAnalytics? analytics;
//  final FirebaseAnalyticsObserver observer;

  @override
  _State createState() => _State();
}

class _State extends State<TabViewThree> {
  ThemeMode themeMode = ThemeMode.light;
  // Firebase Analytics
//  late FirebaseAnalytics _analytics;

  // _State(FirebaseAnalytics? analytics);

  @override
  void initState() {
    _analytics = FirebaseAnalytics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataProvider>(builder: (
      context,
      cart,
      child,
    ) {
      return GridView.builder(
        itemCount: arrays3.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.0, crossAxisCount: 3),
        itemBuilder: (context, index) {
          return Column(
            children: [
              TextButton(
                /// Stops all sounds
                onPressed: () async {
                  addAllThree(cart, index);
                  _firebaseAnalytics(index);
                },
                child: _gridBuldier(index),
              ),
            ],
          );
        },
      );
    });
  }

  Widget _gridBuldier(int index) => Column(
        children: [
          Image(
            height: 50,
            width: 60,
            //  height: 50.0,
            image: AssetImage(arrays3[index].isFav!
                ? arrays3[index].picOn!
                : arrays3[index].picOff!),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          arrays3[index].isFav!
              ? AnimatedOpacity(
                  duration: const Duration(milliseconds: 700),
                  opacity: arrays3[index].isFav!
                      ? arrays3[index].opacityOn
                      : arrays3[index].opacityOff,
                  child: PlayerBuilder.volume(
                      player: arrays3[index].player,
                      builder: (context, volume) {
                        return Slider(
                            activeColor: Colors.grey,
                            value: volume,
                            min: 0,
                            max: 1,
                            divisions: 50,
                            onChanged: (v) {
                              setState(() {
                                arrays3[index].player.setVolume(v);
                              });
                            });
                      }),
                )
              : Text(
                  arrays3[index].title!,
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
        ],
      );
}

late FirebaseAnalytics _analytics;

Future<void> _firebaseAnalytics(int index) async {
  try {
    if (arrays3[index].isFav!) {
      await _analytics.logEvent(
        name: arrays3[index].events!,
      );
    }
  } catch (e) {
    debugPrint("********error catch***********");
  }
}
