import 'package:flutter/services.dart';

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({required this.decimalRange})
    : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;

    if (text.isEmpty) {
      return newValue;
    }

    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts.length > 2) {
        return oldValue;
      }
      if (parts[1].length > decimalRange) {
        return oldValue;
      }
    }

    if (!RegExp(r'^\d*\.?\d*$').hasMatch(text)) {
      return oldValue;
    }

    return newValue;
  }
}
