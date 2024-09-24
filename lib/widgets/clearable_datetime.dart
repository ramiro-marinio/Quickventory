import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ClearableDatetime extends StatefulWidget {
  final void Function(DateTime? date) changeDate;
  final DateTime? initalDatetime;
  const ClearableDatetime(
      {super.key, required this.changeDate, this.initalDatetime});

  @override
  State<ClearableDatetime> createState() => _ClearableDatetimeState();
}

class _ClearableDatetimeState extends State<ClearableDatetime> {
  DateTime? dateTime;
  @override
  void initState() {
    super.initState();
    dateTime = widget.initalDatetime;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            onTap: () {
              showDatePicker(
                context: context,
                firstDate: DateTime(1800),
                lastDate: DateTime(DateTime.now().year + 100),
              ).then(
                (result) {
                  if (result != null) {
                    dateTime = result;
                    widget.changeDate(result);
                    setState(() {});
                  }
                },
              );
            },
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
            child: Container(
              decoration: commonBoxDecoration,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 150,
                  child: Center(
                    child: AutoSizeText(
                      dateTime != null ? formatDate(dateTime!) : '-',
                    ),
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              dateTime = null;
              widget.changeDate(null);
              setState(() {});
            },
            icon: const PhosphorIcon(
              PhosphorIconsBold.trash,
            ),
          )
        ],
      ),
    );
  }
}

final commonBoxDecoration = BoxDecoration(
  border: Border.all(
    color: Colors.blue, // Border color
    width: 2.0, // Border width
  ),
  borderRadius: const BorderRadius.all(Radius.circular(4.0)), // Rounded corners
);

String formatDate(DateTime date) {
  // List of month names
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  // Extract day, month, and year
  int day = date.day;
  String month = months[date.month - 1]; // Month is 1-indexed
  int year = date.year;

  // Format the date
  return '$day of $month, $year';
}
