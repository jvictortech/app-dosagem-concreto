import 'package:flutter/services.dart';

class NumberFormatter extends TextInputFormatter {

  @override
  TextEditingValue formatEditUpdate(oldValue, newValue) {
    if (newValue.text == '') {
      return newValue;
    }
    return newValue.text.contains(RegExp(r'^\d{1,5}([,]\d{0,5})?$'))
        ? newValue
        : oldValue;
  }
}
