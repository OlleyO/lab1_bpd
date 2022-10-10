import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lab_1/models/rc5_model.dart';

class Lab3Screen extends StatefulWidget {
  const Lab3Screen({Key? key}) : super(key: key);

  static const path = "lab3";

  @override
  State<Lab3Screen> createState() => _Lab3ScreenState();
}

class _Lab3ScreenState extends State<Lab3Screen> {
  final file1Controller = TextEditingController();
  final file2Controller = TextEditingController();
  final keyController = TextEditingController();

  Rc5Action action = Rc5Action.encrypt;

  @override
  void dispose() {
    file1Controller.dispose();
    file2Controller.dispose();
    keyController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Лабораторна 3"),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: keyController,
                    decoration: InputDecoration(
                      labelText: "Ключ",
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: TextField(
                      controller: file1Controller,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Файл 1",
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.folder_open_outlined),
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          dialogTitle: "Оберіть файл для зчитування",
                          lockParentWindow: true,
                          initialDirectory:
                              "D:\\term 7\\labs\\PDS\\pds3\\app\\test",
                        );

                        if (result == null) {
                        } else {
                          final file = File(result.files.first.path!);

                          file1Controller.value = TextEditingValue(
                            text: result.files.first.path!,
                          );
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
                      controller: file2Controller,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Файл 2",
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.folder_open_outlined),
                      onPressed: () async {
                        final result = await FilePicker.platform.pickFiles(
                          dialogTitle: "Оберіть файл для зчитування",
                          lockParentWindow: true,
                          initialDirectory:
                              "D:\\term 7\\labs\\PDS\\pds3\\app\\test",
                        );

                        if (result == null) {
                        } else {
                          final file = File(result.files.first.path!);

                          file2Controller.value = TextEditingValue(
                            text: result.files.first.path!,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          leading: Radio<Rc5Action>(
                              value: Rc5Action.encrypt,
                              groupValue: action,
                              onChanged: (value) => setState(() {
                                    action = value!;
                                  })),
                          title: const Text("Зашифрувати"),
                        ),
                      ),
                      Expanded(
                        child: ListTile(
                          leading: Radio<Rc5Action>(
                              value: Rc5Action.decrypt,
                              groupValue: action,
                              onChanged: (value) => setState(() {
                                    action = value!;
                                  })),
                          title: const Text("Дешифрувати"),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final response = await post(
                            Uri.parse(
                              "http://localhost:3300/",
                            ),
                            headers: {
                              "Content-Type": "application/json",
                            },
                            body: Rc5Model(
                                    encryptionKey: keyController.text,
                                    inputFileName: file1Controller.text,
                                    outputFileName: file2Controller.text,
                                    action: action)
                                .toJson(),
                          );

                          print(response.statusCode);
                          print(response.body);

                          if (response.statusCode == 200) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Виконано"),
                                backgroundColor: Colors.greenAccent,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Помилка"),
                                backgroundColor: Colors.redAccent,
                              ),
                            );
                          }
                        },
                        child: const Text("Виконати"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
