import 'dart:developer';
import 'package:sleep_sounds/fun/arrays_3_4.dart';
import 'package:sleep_sounds/fun/toast.dart';
import 'package:sleep_sounds/models/data_provider.dart';
import 'package:sleep_sounds/fun/foreground_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:provider/provider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

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
  _State createState() => _State(analytics);
}

class _State extends State<TabViewThree> {
  ThemeMode themeMode = ThemeMode.light;
  // Firebase Analytics
  late FirebaseAnalytics _analytics;

  _State(FirebaseAnalytics? analytics);

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
                  if (cart.count2 == 1 &&
                      arrays3[index].isFav == false) {
                    for (int i = 0; i < arrays3.length; i++) {
                      arrays3[i].player.stop();
                      cart.remove2(arrays3[i]);
                      cart.remove(arrays3[i]);
                      arrays3[i].isFav = false;
                    }
                  }
                  if (cart.count2 <= 1 && arrays3[index].isFav == false && cart.count <= 5) {
                    arrays3[index].player.open(Audio(arrays3[index].sounds!),
                        volume: 0.5, loopMode: LoopMode.single);
                    cart.add2(arrays3[index]);
                    cart.add(arrays3[index]);
                    arrays3[index].isFav = true;
                  } else {
                    arrays3[index].player.pause();
                    log('{arrays3[index].player.pause()} ${arrays3[index].player.pause()}');
                    cart.remove2(arrays3[index]);
                    cart.remove(arrays3[index]);
                    arrays3[index].isFav = false;
                  }

                  if(cart.count == 6 && cart.count2 == 0) {
                    toast();
                  }

                  /// foregroundService START or STOP
                  if (cart.count2 == 1) {
                    foregroundService();
                  } else if (cart.count2 == 0 && cart.count == 0) {
                    foregroundServiceStop();
                  }
                  // Click_events - if isFav is true
                  if (arrays3[index].isFav!) {
                    await _analytics.logEvent(
                      name: arrays3[index].events!,
                    );
                  }
                },
                child: Column(
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
                ),
              ),
            ],
          );
        },
      );
    });
  }
}