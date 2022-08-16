import 'dart:collection';

import 'package:intl/intl.dart';

class Algorithm {
  /// Модуль порівняння
  final int m;

  /// Множник
  final int a;

  /// Приріст
  final int c;

  /// початкове значення
  final int x0;

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

      _generatedNumbers.add(xi);
    }

    return UnmodifiableListView(_generatedNumbers);
  }

  UnmodifiableListView<int> get generatedNumbers =>
      UnmodifiableListView(_generatedNumbers);

  String formattedGeneratedNumbers({required OutputType outputType}) =>
      _generatedNumbers
          .map((n) => NumberFormat().format(n))
          .join(outputType == OutputType.application ? "; " : "\n");

  void reset() {
    _generatedNumbers = [];
  }

  int get period {
    int zeroIndex = 0;

    if (_generatedNumbers.isEmpty) {
      return -1;
    }

    int indexOfFirstRepeat =
        _generatedNumbers.indexOf(_generatedNumbers[zeroIndex], zeroIndex + 1);

    return indexOfFirstRepeat - zeroIndex;
  }
}

enum OutputType {
  file,
  application,
}
