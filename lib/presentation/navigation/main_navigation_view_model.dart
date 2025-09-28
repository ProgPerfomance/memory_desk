import 'package:flutter/material.dart';

class MainNavigationViewModel extends ChangeNotifier {
  int index = 0;

  void selectIndex(int ind) {
    index = ind;
    notifyListeners();
  }
}
