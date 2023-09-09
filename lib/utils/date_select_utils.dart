import 'package:flutter/material.dart';

class DateSelectButton extends StatelessWidget {
  final VoidCallback showDatePicker;

  DateSelectButton({required this.showDatePicker});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: showDatePicker,
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
      ),
      child: Text(
        '날짜 선택하기',
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}
