import 'package:flutter/material.dart';

class Activator extends ValueNotifier<bool> {
  final List<ValueNotifier> list;
  Activator({this.list = const []}) : super(false) {
    for (var controller in list) {
      controller.addListener(_check);
    }
  }

  void _check() {
    var res = true;
    for (var controller in list) {
      if (controller is TextEditingController) {
        if (controller.text.isEmpty) {
          res = false;
          break;
        }
      } else if (!controller.value) {
        res = false;
        break;
      }
    }
    value = res;
  }
}

double? convert(String value) {
  return double.tryParse(value.replaceFirst(',', '.'));
}
