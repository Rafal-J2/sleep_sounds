import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:sleep_sounds/fun/arrays_1_2.dart';
import 'package:sleep_sounds/fun/foreground_service.dart';
import 'package:sleep_sounds/fun/toast.dart';
import 'package:sleep_sounds/models/data_provider.dart';



Future<void> addAllTwo(DataProvider cart, int index) async {
        if (cart.count <= 5) {
      /// Bool checking
      arrays2[index].isFav = !arrays2[index].isFav!;
      // Click_events Analytics
      // if (arrays2[index].isFav!) {
      //   await _analytics.logEvent(
      //     name: arrays2[index].events!,
      //   );
      // }
      // /// Play or Stop sounds
      arrays2[index].isFav!
          ? arrays2[index].player.open(
          Audio(arrays2[index].sounds!),
          volume: 0.5,
          loopMode: LoopMode.single)
          : arrays2[index].player.pause();
    
      /// Add image to page two
      arrays2[index].isFav!
          ? cart.add(arrays2[index])
          : cart.remove(arrays2[index]);
    } else if (cart.count == 6) {
      cart.remove(arrays2[index]);
      arrays2[index].isFav = false;
      arrays2[index].player.pause();
      //Toast Text
      if (cart.count == 6) {
        toast();
      }
    }
    /// foregroundService START or STOP
    if (cart.count == 1) {
      foregroundService();
    } else if (cart.count == 0 && cart.count2 == 0) {
      foregroundServiceStop();
    }
  }