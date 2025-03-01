
import 'package:flutter/material.dart';

class AppTheme{
  static ThemeData lightTheme = ThemeData(
    fontFamily: "Cera Pro",
    appBarTheme: const AppBarTheme(color: Colors.white),
    scaffoldBackgroundColor: Colors.white,
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.grey.shade300,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Colors.red,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        textStyle: const TextStyle(color: Colors.white),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    ),
    datePickerTheme: DatePickerThemeData(
      backgroundColor: Colors.white,
      headerBackgroundColor: const Color(0xFF6A1B9A), // Purple header
      headerForegroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      surfaceTintColor: Colors.transparent,
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.2),
      todayBackgroundColor: WidgetStateProperty.all(const Color(0xFF6A1B9A).withOpacity(.5)),
      todayForegroundColor: WidgetStateProperty.all(Colors.white),
      dayForegroundColor: WidgetStateProperty.all(Colors.black),
      dayOverlayColor: WidgetStateProperty.all(Colors.black.withOpacity(0.1)),
      yearForegroundColor: WidgetStateProperty.all(Colors.white),
      confirmButtonStyle: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(const Color(0xFF6A1B9A)), // Purple
        foregroundColor: WidgetStateProperty.all(Colors.white),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      cancelButtonStyle: ButtonStyle(
        foregroundColor: WidgetStateProperty.all(Colors.black),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ),

    // Modern Time Picker Theme
    timePickerTheme: TimePickerThemeData(
      backgroundColor: Colors.white,
      hourMinuteColor: const Color(0xFF6A1B9A).withOpacity(0.1), // Light purple
      hourMinuteTextColor: Colors.black,
      dialHandColor: const Color(0xFF6A1B9A), // Purple
      dialBackgroundColor: Colors.white,
      entryModeIconColor: const Color(0xFF6A1B9A), // Purple
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      hourMinuteShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      dialTextColor: Colors.black,
      helpTextStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      dayPeriodColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const Color(0xFF6A1B9A); // Purple for selected AM/PM
        }
        return Colors.transparent;
      }),
      dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white; // White text for selected AM/PM
        }
        return Colors.black;
      }),
      hourMinuteTextStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    ),

    useMaterial3: true,
  );
}