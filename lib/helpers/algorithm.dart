import 'dart:collection';

import 'package:intl/intl.dart';

class Algorithm {
  final int m;

  final int a;

  final int c;

  final int x0;

  int period = -1;

  List<int> _generatedNumbers = [];

  Algorithm({
    required this.a,
    required this.c,
    required this.m,
    required this.x0,
  });

  UnmodifiableListView<int> generateNPseudoRandNumbers({int n = 50}) {
    _generatedNumbers = [];

    int xi = x0;

    for (int i = 0; i < n; i++) {
      xi = (a * xi + c) % m;
      var indexOf = _generatedNumbers.lastIndexOf(xi);

      if (indexOf != -1) {
        period = _generatedNumbers.length - indexOf;
      }

      _generatedNumbers.add(xi);
    }

    return UnmodifiableListView(_generatedNumbers);
  }

  Stream<int> generateNPseudoNumbersAsync(int n) async* {
    int xi = x0;

    for (int i = 0; i < n; i++) {
      xi = (a * xi + c) % m;

      yield xi;
    }
  }

  UnmodifiableListView<int> get generatedNumbers =>
      UnmodifiableListView(_generatedNumbers);

  String formattedGeneratedNumbers(
          {required OutputType outputType, int? amount}) =>
      _generatedNumbers
          .map((n) => NumberFormat().format(n))
          .toList()
          .sublist(0, amount == null ? null : amount)
          .join(outputType == OutputType.application ? "; " : "\n");

  void reset() {
    _generatedNumbers = [];
  }
}

enum OutputType {
  file,
  application,
}
