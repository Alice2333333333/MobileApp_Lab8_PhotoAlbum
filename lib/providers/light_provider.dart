import 'package:flutter/material.dart';

class LightProvider extends ChangeNotifier {
  int _luxValue = 0;

  int get luxValue => _luxValue;

  set luxValue(int newLuxValue) {
    _luxValue = newLuxValue;
    notifyListeners();
  }
}
