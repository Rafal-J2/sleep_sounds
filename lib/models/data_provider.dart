import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleep_sounds/fun/arrays_1_2.dart';
import 'package:sleep_sounds/fun/foreground_service.dart';
import 'package:sleep_sounds/fun/toast.dart';
import 'package:sleep_sounds/models/view_models.dart';

class DataProvider extends ChangeNotifier {
  final Map<int, int> _cart = {};

  Map<int, int> get cart => _cart;

  final List<ViewModels> _items = [];

  late final FirebaseAnalytics? analytics;
  late FirebaseAnalytics _analytics;

  void add(ViewModels item) {
    _items.add(item);

    notifyListeners();
  }

  void addAll(index) async {
    if (count <= 5) {
      //Bool checking
      arrays[index].isFav = !arrays[index].isFav!;
 
  
      // Play or Stop sounds
      arrays[index].isFav!
          ? arrays[index].player.open(
              Audio(
                arrays[index].sounds!,
              ),
              volume: 0.5,
              //  showNotification: true,
              loopMode: LoopMode.single)
          : arrays[index].player.pause();

      //   cart.addTest2(index);
      arrays[index].isFav! ? add(arrays[index]) : remove(arrays[index]);

      //Add image to page two. If is isFav = true, add entire arrays.
      // Table number is depends on from the selected item
      // for example:  arrays[0].isFav = true.
      // If is true add to cart provider entire items  "picOff, isFav, sounds, vol, player"
      // basketItems is the receiver i find screenTwo.dart
    } else if (count == 6) {
      cart.remove(arrays[index]);
      arrays[index].isFav = false;
      arrays[index].player.pause();

      //Toast Text
      if (count == 6) {
        toast();
      }
    }
    // foregroundService START or STOP
    if (count == 1) {
      foregroundService();
    } else if (count == 0 && count2 == 0) {
      foregroundServiceStop();
    }
  }

  void remove(ViewModels item) {
    _items.remove(item);
    notifyListeners();
  }

  int get count {
    return _items.length;
  }

  // counter to piano
  int get count2 {
    return _items2.length;
  }

  final List<ViewModels> _items2 = [];

  void add2(ViewModels item) {
    _items2.add(item);
    notifyListeners();
  }

  void remove2(ViewModels item) {
    _items2.remove(item);
    notifyListeners();
  }

  List<ViewModels> get basketItems2 {
    return _items2;
  }

  List<ViewModels> get basketItems {
    return _items;
  }

  final List<ViewModels> _items3 = [];

  add3(ViewModels item) {
    _items3.add(item);
    notifyListeners();
  }

  List<ViewModels> get basketItems3 {
    return _items3;
  }
}
