import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/core/utils/utils.dart';
import 'package:task_manager/features/home/cubit/task_cubit.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({super.key});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int skipWeeks = 0;
  final currentDate = DateTime.now();
  DateTime selectedDate = DateTime.now();
  String monthName = DateFormat("MMMM").format(DateTime.now());
  List<DateTime> weekDates = [];

  @override
  void initState() {
    super.initState();
    weekDates = generateWeekDates(skipWeeks);
  }

  void onWeekChanged(bool shouldIncrease) {
    weekDates = generateWeekDates(shouldIncrease?++skipWeeks:--skipWeeks);
    monthName = DateFormat("MMMM").format(weekDates.first);
    setState(() {
      weekDates;
      monthName;
      skipWeeks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: ()=> onWeekChanged(false),
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: Colors.black54),
            ),
            Text(
              monthName,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: Colors.black87,
              ),
            ),
            IconButton(
              onPressed: ()=> onWeekChanged(true),
              icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18, color: Colors.black54),
            ),
          ],
        ),
        // Date List
        SizedBox(
          key: ValueKey(MediaQuery.of(context).orientation),
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weekDates.length,
            itemBuilder: (context, index) {
              final date = weekDates[index];
              final isSelected = selectedDate.day == date.day&&selectedDate.month==date.month&&selectedDate.year==date.year;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDate = date;
                  });
                  context.read<TaskCubit>().onDateSelected(selectedDate);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: MediaQuery.of(context).size.width/9.5,
                  margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                      colors: [Colors.orangeAccent.withOpacity(0.8), Colors.deepOrangeAccent.withOpacity(0.9)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : null,
                    color: isSelected ? null : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                    border: isSelected?null:Border.all(color: Colors.grey.shade200),
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: Colors.orangeAccent.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ] : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        spreadRadius: 1,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat('dd').format(date),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat('EEE').format(date),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
