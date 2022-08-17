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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Лабораторна 2"),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
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
                            decoration: InputDecoration(
                              labelText: "Текст",
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.file_copy),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Захешований текст",
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "Захешувати",
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "Зберегти до файлу",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50.0,
                        ),
                        Divider(),
                        SizedBox(
                          height: 50.0,
                        ),
                        Text(
                          "Перевірка цілісності з використанням контрольної суми",
                          style: AppStyles.titleText,
                        ),
                        SizedBox(
                          height: 25.0,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: TextField(
                            decoration: InputDecoration(
                              labelText: "Текст",
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.file_copy),
                            onPressed: () {},
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {},
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
