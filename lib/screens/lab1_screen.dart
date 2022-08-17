import 'dart:io';
import 'dart:math';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lab_1/constants/app_styles.dart';
import 'package:lab_1/helpers/algorithm.dart';
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
  Algorithm algorithm = Algorithm(
    m: (pow(2, 30) - 1).toInt(),
    a: pow(17, 3).toInt(),
    c: 10946,
    x0: 29,
  );

  int numberOfNumbers = 0;
  bool isNumberValid = false;

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
                          value: algorithm.m,
                        ),
                        InfoTile(
                          title: "Множник, a:",
                          value: algorithm.a,
                        ),
                        InfoTile(
                          title: "Приріст, c:",
                          value: algorithm.c,
                        ),
                        InfoTile(
                          title: "Початкове значення, X0:",
                          value: algorithm.x0,
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
                                          const SnackBar(
                                            backgroundColor: Colors.redAccent,
                                            content: Text(
                                              "Введіть натуральне число",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
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
                                  ? () {
                                      setState(() {
                                        algorithm.generateNPseudoRandNumbers(
                                            n: numberOfNumbers);

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            backgroundColor: Colors.greenAccent,
                                            content: Text(
                                              "Успішно згенеровано",
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      });
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
                                  algorithm.reset();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.blueAccent,
                                      content: Text(
                                        "Дані очищено",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                });
                              },
                              child: const Text("Очистити дані"),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                String? outputFile =
                                    await FilePicker.platform.saveFile(
                                  dialogTitle: "Оберіть файл:",
                                  fileName: "lab1_output.txt",
                                );

                                if (outputFile == null) {
                                } else {
                                  var file =
                                      await File(outputFile).writeAsString(
                                    algorithm.formattedGeneratedNumbers(
                                        outputType: OutputType.file),
                                  );
                                }
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
                        InfoTile(
                          title: "Період:",
                          value: algorithm.period,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              algorithm.formattedGeneratedNumbers(
                                  outputType: OutputType.application),
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
