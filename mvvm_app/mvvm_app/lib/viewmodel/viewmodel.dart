import 'package:flutter/material.dart';
import 'package:mvvm_app/model/model.dart';

class AdviceState extends ChangeNotifier{
  final AdviceModel model;
  String? errorMessage;
  String? advice;
  AdviceState(this.model){
    nextAdvice();
  }

  Future<void> nextAdvice() async {
    try {
      advice = (await model.loadAdviceFromServer()).advice;
    } catch (e) {
      errorMessage = 'Erro: $e';
    }
    notifyListeners();
  }
}