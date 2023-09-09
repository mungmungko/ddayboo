import 'package:flutter/material.dart';

class DateDisplayWidget extends StatelessWidget {
  final int? daysDifference;
  final DateTime? startDate;

  DateDisplayWidget({
    required this.daysDifference,
    this.startDate,
  });

  // DateTime에서 원하는 형식으로 날짜를 반환하는 함수
  String formattedDate(DateTime dateTime) {
    final year = dateTime.year;
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');

    return '$year.$month.$day';
  }

  @override
  Widget build(BuildContext context) {
    String todayDate = formattedDate(DateTime.now());
    String? startDateStr = startDate != null ? formattedDate(startDate!) : null;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Text(
              daysDifference != null ? 'love day\n$startDateStr' : '날짜를 선택해주세요',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              daysDifference != null ? '${daysDifference!.abs()} 일' : '-',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 33.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Text(
            //   'today\n$todayDate',
            //   textAlign: TextAlign.center,
            //   style: TextStyle(
            //     fontSize: 13.0,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
