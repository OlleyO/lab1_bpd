import 'package:flutter/material.dart';

import '../constants/app_styles.dart';

class InfoTile extends StatelessWidget {
  final String title;
  final void Function(String?)? onChange;
  final TextEditingController controller;

  const InfoTile(
      {Key? key, required this.title, required this.controller, this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: AppStyles.mainText,
      ),
      trailing: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 200,
        ),
        child: TextField(
          controller: controller,
          onChanged: onChange,
        ),
      ),
    );
  }
}
