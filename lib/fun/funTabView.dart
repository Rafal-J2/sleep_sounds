import 'dart:developer';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:sleep_sounds/fun/arrays_1_2.dart';
import 'package:sleep_sounds/fun/arrays_3_4.dart';
import 'package:sleep_sounds/fun/foreground_service.dart';
import 'package:sleep_sounds/fun/toast.dart';
import 'package:sleep_sounds/models/data_provider.dart';



Future<void> addAllTwo(DataProvider cart, int index) async {
        if (cart.count <= 5) {
      /// Bool checking
      arrays2[index].isFav = !arrays2[index].isFav!;
      //  Play or Stop sounds
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

 void addAllThree(DataProvider cart, int index)  {
    if (cart.count2 == 1 && arrays3[index].isFav == false) {
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

    if (cart.count == 6 && cart.count2 == 0) {
      toast();
    }

    /// foregroundService START or STOP
    if (cart.count2 == 1) {
      foregroundService();
    } else if (cart.count2 == 0 && cart.count == 0) {
      foregroundServiceStop();
    } 
  }


  void addAllFour(DataProvider cart, int index) {
      if (cart.count <= 5) {
       //Bool checking
       arrays4[index].isFav = !arrays4[index].isFav!;    
       // Play or Stop sounds
       arrays4[index].isFav!
           ? arrays4[index].player.open(
           Audio(
             arrays4[index].sounds!,
           ),
           volume: 0.5,
           //  showNotification: true,
           loopMode: LoopMode.single)
           : arrays4[index].player.pause();
       arrays4[index].isFav!
           ? cart.add(arrays4[index])
           : cart.remove(arrays4[index]);
       //Add image to page two. If is isFav = true, add entire arrays.
       // Table number is depends on from the selected item
       // for example:  arrays[0].isFav = true.
       // If is true add to cart provider entire items  "picOff, isFav, sounds, vol, player"
       // basketItems is the receiver i find screenTwo.dart
     } else if (cart.count == 6) {
       cart.remove(arrays4[index]);
       arrays4[index].isFav = false;
       arrays4[index].player.pause();
       //Toast Text
       if (cart.count == 6) {
         toast();
       }
     }
     // foregroundService START or STOP
     if (cart.count == 1) {
       foregroundService();
     } else if (cart.count == 0 && cart.count2 == 0) {
       foregroundServiceStop();
     }
  }