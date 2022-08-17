import 'dart:io';

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
                                var result = await Process.run(
                                  "D:\\labs_bpd\\lab2_c\\x64\\Release\\lab2_c",
                                  [
                                    "-i",
                                    toHashController.text,
                                  ],
                                );

                                hashedController.value = TextEditingValue(
                                    text: result.stdout.toString());

                                // setState(() {
                                //   hashedText = result.stdout.toString();
                                // });
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
                              labelText: "Файл1",
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.folder_open_outlined),
                            onPressed: () async {
                              final res = await FilePicker.platform
                                  .pickFiles(dialogTitle: "Оберіть файл:");

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
                              labelText: "Файл2",
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.folder_open_outlined),
                            onPressed: () async {
                              final res = await FilePicker.platform
                                  .pickFiles(dialogTitle: "Оберіть файл:");

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
                              var result = await Process.run(
                                "D:\\labs_bpd\\lab2_c\\x64\\Release\\lab2_c",
                                [
                                  "-if",
                                  checksumController1.text,
                                  "-cif",
                                  checksumController2.text,
                                ],
                              );

                              print(result.stdout);
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
