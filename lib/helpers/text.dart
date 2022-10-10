import 'dart:math';

class TextHelper {
  // format 2^10-1
  static num? fieldTextToNumber(String text) {
    if (int.tryParse(text) != null) {
      return int.tryParse(text);
    }

    var tmp = RegExp(r"\^\d+").stringMatch(text);
    var power = 1;
    if (tmp != null) {
      power = int.parse(tmp.substring(1));
    }

    var toPowerAndAfterPower = text.split(RegExp(r"\^\d+"));
    var toPower = int.parse(toPowerAndAfterPower[0]);
    var afterPower = int.tryParse(toPowerAndAfterPower[1]);

    if (afterPower == null) {
      afterPower = 0;
    }

    return pow(toPower, power) + afterPower;
  }
}
