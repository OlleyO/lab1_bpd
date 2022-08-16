import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../constants/app_styles.dart';

class InfoTile extends StatelessWidget {
  final String title;
  final int value;

  const InfoTile({
    Key? key,
    required this.value,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: AppStyles.mainText,
      ),
      trailing: Text(
        NumberFormat().format(value),
        style: AppStyles.mainText,
      ),
    );
  }
}
