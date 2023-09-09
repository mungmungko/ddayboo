import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<void> pickDate(
    BuildContext context, Function(DateTime) onDateSelected) async {
  DateTime? selectedDate;

  await showModalBottomSheet(
    context: context,
    builder: (BuildContext builder) {
      return Column(
        children: [
          Container(
            height: MediaQuery.of(context).copyWith().size.height / 3,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (DateTime dateTime) {
                selectedDate = dateTime;
              },
            ),
          ),
          ElevatedButton(
            child: Text("확인"),
            onPressed: () {
              if (selectedDate != null) {
                onDateSelected(selectedDate!);
                Navigator.of(context).pop();
              }
            },
          )
        ],
      );
    },
  );
}
