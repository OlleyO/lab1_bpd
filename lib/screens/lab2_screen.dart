import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:lab_1/constants/app_styles.dart';

class Lab2Screen extends StatefulWidget {
  static const String path = "lab2";

  const Lab2Screen({Key? key}) : super(key: key);

  @override
  State<Lab2Screen> createState() => _Lab2ScreenState();
}

// var result = await Process.run(
// "D:\\labs_bpd\\lab2_c\\x64\\Release\\lab2_c",
// [
// "-h",
// ],
// );
//
// print(result.stdout);

class _Lab2ScreenState extends State<Lab2Screen> {
  final toHashController = TextEditingController();
  final hashedController = TextEditingController();
  final checksumController1 = TextEditingController();
  final checksumController2 = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
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
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: TextField(
                            controller: toHashController,
                            decoration: InputDecoration(
                              labelText: "Текст",
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

                                final text = await file.readAsString();

                                print(text);

                                toHashController.value = TextEditingValue(
                                  text: text,
                                  selection: TextSelection.fromPosition(
                                    TextPosition(offset: text.length),
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
                                // TODO: KEEP IT
                                // var result = await Process.run(
                                //   "D:\\labs_bpd\\lab2_c\\x64\\Release\\lab2_c",
                                //   [
                                //     "-i",
                                //     toHashController.text,
                                //   ],
                                // );
                                //
                                // hashedController.value = TextEditingValue(
                                //   text: result.stdout.toString(),
                                // );

                                var bytes = utf8.encode(toHashController.text);

                                var digest =
                                    md5.convert(bytes).toString().toUpperCase();

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
                              // var result = await Process.run(
                              //   "D:\\labs_bpd\\lab2_c\\x64\\Release\\lab2_c",
                              //   [
                              //     "-if",
                              //     checksumController1.text,
                              //     "-cif",
                              //     checksumController2.text,
                              //   ],
                              // );
                              //
                              // print(result.stdout);

                              final file1 = File(checksumController1.text);

                              final text1 = await file1.readAsString();

                              final file2 = File(checksumController2.text);

                              final hashed = md5
                                  .convert(utf8.encode(text1))
                                  .toString()
                                  .toUpperCase();

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
              // const SizedBox(width: 15.0),
              // Expanded(
              //   child: Card(
              //     child: Padding(
              //       padding: const EdgeInsets.all(15.0),
              //       child: Column(
              //         children: <Widget>[
              //           TextField(
              //             readOnly: true,
              //             decoration: InputDecoration(
              //               labelText: "Захешований текст",
              //             ),
              //           ),
              //           SizedBox(
              //             height: 15.0,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
