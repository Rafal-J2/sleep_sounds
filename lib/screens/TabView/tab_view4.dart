import 'package:sleep_sounds/fun/arrays_3_4.dart';
import 'package:sleep_sounds/fun/fun_tab_view.dart';
import 'package:sleep_sounds/models/data_provider.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class TabViewFour extends StatefulWidget {
  const TabViewFour({
    Key? key,
    this.analytics,
    //   this.observer,
  }) : super(key: key);

  final FirebaseAnalytics? analytics;

  @override
  _State createState() => _State();
}

class _State extends State<TabViewFour> with AutomaticKeepAliveClientMixin {
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
        itemCount: arrays4.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.0, crossAxisCount: 3),
        itemBuilder: (context, index) {
          return Column(
            children: [
              TextButton(
                onPressed: () async {
                 addAllFour(cart, index);
                  _firebaseAnalytics(index);
                },
                child: _gridBuldier(index)
              ),
            ],
          );
        },
      );
    });
  }

Widget _gridBuldier(int index) =>Column(
                  children: [
                    Image(
                      fit: BoxFit.contain,
                      height: 50,
                      width: 120,
                      image: AssetImage(arrays4[index].isFav!
                          ? arrays4[index].picOn!
                          : arrays4[index].picOff!),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 8)),
                    arrays4[index].isFav!
                        ? AnimatedOpacity(
                      opacity: arrays4[index].isFav!
                          ? arrays4[index].opacityOn
                          : arrays4[index].opacityOff,
                      duration: const Duration(milliseconds: 800),
                      child: PlayerBuilder.volume(
                          player: arrays4[index].player,
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
                                      arrays4[index].player.setVolume(v);
                                    });
                                  }),
                            );
                          }),
                    )
                        : Text(
                      arrays4[index].title!,
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
    if (arrays4[index].isFav!) {
      await _analytics.logEvent(
        name: arrays4[index].events!,
      );
    }
  } catch (e) {
    debugPrint("********error catch***********");
  }
}