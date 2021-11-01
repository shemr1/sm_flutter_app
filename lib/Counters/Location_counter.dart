import 'package:flutter/foundation.dart';

class LocationChanger with ChangeNotifier{
  int _counter = 0;

  int get count => _counter;

  displayResult(int num){
    _counter = num;
    notifyListeners();
  }
}