import 'package:flutter/foundation.dart';

class ServiceQuantity with ChangeNotifier{
  int _numServices = 0;
  int get numServices => _numServices;



  display(int num){
    _numServices = num;

    notifyListeners();
  }
}