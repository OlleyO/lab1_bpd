import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab_1/constants/app_styles.dart';
import 'package:lab_1/helpers/algorithm.dart';
import 'package:lab_1/helpers/text.dart';
import 'package:lab_1/widgets/info_tile.dart';

class Lab1Screen extends StatefulWidget {
  static const String path = "lab1";

  /// Номер варіанту
  final int variantNum;

  const Lab1Screen({
    Key? key,
    required this.variantNum,
  }) : super(key: key);

  @override
  State<Lab1Screen> createState() => _Lab1ScreenState();
}

class _Lab1ScreenState extends State<Lab1Screen> {
  int numberOfNumbers = 0;
  bool isNumberValid = false;

  final _mController = TextEditingController();
  final _aController = TextEditingController();
  final _cConroller = TextEditingController();
  final _xoController = TextEditingController();
  final _periodController = TextEditingController();
  final _toDisplatController = TextEditingController();

  Algorithm? algorithm;

  @override
  void dispose() {
    _mController.dispose();
    _aController.dispose();
    _xoController.dispose();
    _periodController.dispose();
    _toDisplatController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Генератор псевдорандомних чисел"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0).copyWith(bottom: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Варіант #${widget.variantNum}",
                          style: AppStyles.titleText,
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 25.0,
                        ),

                        InfoTile(
                          title: "Модуль порівняння, m:",
                          controller: _mController,
                        ),
                        InfoTile(
                          title: "Множник, a:",
                          controller: _aController,
                        ),
                        InfoTile(
                          title: "Приріст, c:",
                          controller: _cConroller,
                        ),
                        InfoTile(
                          title: "Початкове значення, X0:",
                          controller: _xoController,
                        ),

                        const SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ConstrainedBox(
                              constraints: const BoxConstraints(
                                maxWidth: 250.0,
                              ),
                              child: TextField(
                                  decoration: const InputDecoration(
                                    labelText: "Кількість чисел",
                                  ),
                                  maxLength: 10,
                                  onChanged: (value) {
                                    setState(() {
                                      final number = int.tryParse(value);

                                      if (number == null || number <= 0) {
                                        setState(() {
                                          isNumberValid = false;
                                        });

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            content: Text(
                                              "Введіть натуральне число",
                                              style: AppStyles.titleText,
                                            ),
                                          ),
                                        );
                                      } else {
                                        setState(() {
                                          numberOfNumbers = number;
                                          isNumberValid = true;
                                        });
                                      }
                                    });
                                  }),
                            ),
                            ElevatedButton(
                              onPressed: isNumberValid
                                  ? () async {
                                      setState(() {
                                        algorithm = Algorithm(
                                            a: TextHelper.fieldTextToNumber(
                                                    _aController.text)!
                                                .toInt(),
                                            c: TextHelper.fieldTextToNumber(
                                                    _cConroller.text)!
                                                .toInt(),
                                            m: TextHelper.fieldTextToNumber(
                                                    _mController.text)!
                                                .toInt(),
                                            x0: TextHelper.fieldTextToNumber(
                                                    _xoController.text)!
                                                .toInt());
                                      });

                                      final file = File(
                                          "D:\\labs_bpd\\lab_1\\tests\\output.txt");

                                      await for (final number in algorithm!
                                          .generateNPseudoNumbersAsync(
                                              numberOfNumbers)) {
                                        print('writing to file...');
                                        await file.writeAsString('$number\n');
                                      }

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          backgroundColor: Colors.greenAccent,
                                          content: Text(
                                            "Успішно згенеровано",
                                            style: AppStyles.titleText,
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              child: const Text(
                                "Згенерувати",
                              ),
                            ),
                          ],
                        ),

                        // Divider(),
                        const SizedBox(
                          height: 25.0,
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.redAccent),
                              ),
                              onPressed: () {
                                setState(() {
                                  algorithm!.reset();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.blueAccent,
                                      content: Text(
                                        "Дані очищено",
                                        style: AppStyles.titleText,
                                      ),
                                    ),
                                  );
                                });
                              },
                              child: const Text("Очистити дані"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                // String? outputFile =
                                //     await FilePicker.platform.saveFile(
                                //   dialogTitle: "Оберіть файл:",
                                //   fileName: "lab1_output.txt",
                                //   lockParentWindow: true,
                                // );
                                //
                                // if (outputFile == null) {
                                // } else {
                                //   var file =
                                //       await File(outputFile).writeAsString(
                                //     algorithm!.formattedGeneratedNumbers(
                                //         outputType: OutputType.file),
                                //   );
                                // }
                              },
                              child: const Text(
                                "Зберегти",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15.0),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Результат",
                            style: AppStyles.titleText,
                          ),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 25.0,
                        ),
                        TextFormField(
                          controller: _periodController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Період",
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        InfoTile(
                          title: "Показати n перших чисел",
                          controller: _toDisplatController,
                          onChange: (val) => setState(() {}),
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              algorithm != null
                                  ? algorithm!.generatedNumbers
                                      .map((n) => NumberFormat().format(n))
                                      .toList()
                                      .sublist(
                                          0,
                                          int.tryParse(_toDisplatController
                                                      .text) ==
                                                  null
                                              ? null
                                              : int.parse(
                                                  _toDisplatController.text))
                                      .join("; ")
                                  : "",
                              style: AppStyles.mainText
                                  .copyWith(wordSpacing: 55.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
