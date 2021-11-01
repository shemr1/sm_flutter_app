import 'package:flutter/foundation.dart';

class TotalCost extends ChangeNotifier{
  double _totalCost = 0;

  double get totalCost => _totalCost;

  displayResult(double num) async{
    _totalCost = num;

    await Future.delayed(const Duration(milliseconds: 100),(){
      notifyListeners();
    });
  }
}