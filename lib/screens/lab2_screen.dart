import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lab_1/constants/app_styles.dart';
import 'package:lab_1/constants/test_data.dart';

class Lab2Screen extends StatefulWidget {
  static const String path = "lab2";

  const Lab2Screen({Key? key}) : super(key: key);

  @override
  State<Lab2Screen> createState() => _Lab2ScreenState();
}

class _Lab2ScreenState extends State<Lab2Screen> {
  final toHashController = TextEditingController();
  final hashedController = TextEditingController();
  final checksumController1 = TextEditingController();
  final checksumController2 = TextEditingController();

  var textToHash = <int>[];

  var runTest = false;

  @override
  void dispose() {
    toHashController.dispose();
    hashedController.dispose();
    checksumController1.dispose();
    checksumController2.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Лабораторна 2"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Хешування",
                          style: AppStyles.titleText,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: ConstrainedBox(
                            constraints: BoxConstraints(
                              maxHeight: 50.0,
                            ),
                            child: SingleChildScrollView(
                              child: TextField(
                                controller: toHashController,
                                maxLines: null,
                                decoration: InputDecoration(
                                  labelText: "Текст",
                                ),
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.folder_open_outlined),
                            onPressed: () async {
                              final result =
                                  await FilePicker.platform.pickFiles(
                                dialogTitle: "Оберіть файл для зчитування",
                                lockParentWindow: true,
                              );

                              if (result == null) {
                              } else {
                                final file = File(result.files.first.path!);

                                var text = "";

                                textToHash = file.readAsBytesSync();

                                toHashController.value = TextEditingValue(
                                  text: file.path,
                                  selection: TextSelection.fromPosition(
                                    TextPosition(offset: file.path.length),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        TextField(
                          controller: hashedController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Захешований текст",
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                var digest = md5.convert(textToHash).toString();

                                hashedController.value = TextEditingValue(
                                  text: digest,
                                );
                              },
                              child: const Text(
                                "Захешувати",
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                String? outputFile =
                                    await FilePicker.platform.saveFile(
                                  dialogTitle: "Оберіть файл:",
                                  fileName: "lab2_output.txt",
                                  lockParentWindow: true,
                                );

                                if (outputFile == null) {
                                } else {
                                  var file = await File(outputFile)
                                      .writeAsString(hashedController.text);
                                }
                              },
                              child: Text(
                                "Зберегти",
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 50.0,
                        ),
                        Text(
                          "Перевірка цілісності з використанням контрольної суми",
                          style: AppStyles.titleText,
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: TextField(
                            readOnly: true,
                            controller: checksumController1,
                            decoration: InputDecoration(
                              labelText: "Файл для перевірки",
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.folder_open_outlined),
                            onPressed: () async {
                              final res = await FilePicker.platform.pickFiles(
                                dialogTitle: "Оберіть файл:",
                                lockParentWindow: true,
                              );

                              if (res != null) {
                                checksumController1.value =
                                    TextEditingValue(text: res.paths.first!);
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: TextField(
                            readOnly: true,
                            controller: checksumController2,
                            decoration: InputDecoration(
                              labelText: "Файл, що містить хеш",
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.folder_open_outlined),
                            onPressed: () async {
                              final res = await FilePicker.platform.pickFiles(
                                dialogTitle: "Оберіть файл:",
                                lockParentWindow: true,
                              );

                              if (res != null) {
                                checksumController2.value =
                                    TextEditingValue(text: res.paths.first!);
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () async {
                              var text1 = <int>[];
                              final file1 = File(checksumController1.text);

                              text1 = file1.readAsBytesSync();

                              final file2 = File(checksumController2.text);

                              final hashed = md5.convert(text1).toString();

                              final hash = await file2.readAsString();

                              print({
                                "hash": hash,
                                "hashed": hashed,
                              });

                              if (hashed == hash) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Файл ${checksumController1.text} цілий"),
                                    backgroundColor: Colors.greenAccent,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Файл ${checksumController1.text} пошкоджений",
                                      style: AppStyles.titleText,
                                    ),
                                    backgroundColor: Colors.redAccent,
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Перевірити",
                            ),
                          ),
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
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Тести",
                              style: AppStyles.titleText,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  runTest = true;
                                });
                              },
                              child: Text("Запустити"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        (() => runTest
                            ? Expanded(
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    final item =
                                        TestData.lab2.entries.toList()[index];

                                    final hash = md5
                                        .convert(utf8.encode(item.key))
                                        .toString()
                                        .toUpperCase();

                                    final asExpected = item.value == hash;

                                    return ListTile(
                                      title: Text(
                                          "H(${item.key}) expected ${item.value} actual $hash"),
                                      trailing: asExpected
                                          ? Icon(
                                              Icons.check,
                                              color: Colors.greenAccent,
                                            )
                                          : Icon(
                                              Icons.close,
                                              color: Colors.redAccent,
                                            ),
                                    );
                                  },
                                  itemCount: TestData.lab2.length,
                                ),
                              )
                            : Container())()
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
