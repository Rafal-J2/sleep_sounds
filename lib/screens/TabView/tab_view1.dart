import 'package:sleep_sounds/fun/arrays_1_2.dart';
import 'package:sleep_sounds/models/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class TabViewOne extends StatefulWidget {
  const TabViewOne({
    Key? key,
    this.analytics,
    //   this.observer,
  }) : super(key: key);

  final FirebaseAnalytics? analytics;
  @override
  _State createState() => _State();
}

class _State extends State<TabViewOne> with AutomaticKeepAliveClientMixin {
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  void initState() {
    _analytics = FirebaseAnalytics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<DataProvider>(builder: (
      context,
      cart,
      child,
    ) {
      return GridView.builder(
        itemCount: arrays.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.0, crossAxisCount: 3),
        itemBuilder: (context, index) {
          return Column(
            children: [
              TextButton(
                onPressed: () async {
                 cart.addAll(index);
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
            fit: BoxFit.contain,
            height: 50,
            width: 120,
            image: AssetImage(arrays[index].isFav!
                ? arrays[index].picOn!
                : arrays[index].picOff!),
          ),
          const Padding(padding: EdgeInsets.only(top: 8)),
          arrays[index].isFav!
              ? AnimatedOpacity(
                  opacity: arrays[index].isFav!
                      ? arrays[index].opacityOn
                      : arrays[index].opacityOff,
                  duration: const Duration(milliseconds: 800),
                  child: PlayerBuilder.volume(
                      player: arrays[index].player,
                      builder: (context, volume) {
                        return Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor: Colors.grey,
                          child: Slider(
                              value: volume,
                              min: 0,
                              max: 1,
                              divisions: 50,
                              onChanged: (v) {
                                setState(() {
                                  arrays[index].player.setVolume(v);
                                });
                              }),
                        );
                      }),
                )
              : Text(
                  arrays[index].title!,
                  style: const TextStyle(
                      fontSize: 12.0,
                      //    height: 2.5,
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
        ],
      );

  @override
  bool get wantKeepAlive => true;
}

  late FirebaseAnalytics _analytics;
  Future<void> _firebaseAnalytics(int index) async {
    try {
      if (arrays[index].isFav!) {
        await _analytics.logEvent(
          name: arrays[index].events!,
        );
      }
    } catch (e) {
      debugPrint("********error catch***********");
    }
  }
