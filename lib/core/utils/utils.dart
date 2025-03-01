import 'dart:developer' show log;
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:task_manager/features/auth/views/welcome.dart';

import '../../main.dart';
import '../custom_exception/status_code_exception.dart';

Future<T?> executeSafely<T>(
    Function() function, {
      T? defaultValue,
      Function(dynamic error, StackTrace stackTrace)? onError,
      String? functionName = "UnknownFunction"
    }) async {
  try {
    return await function();
  } catch (error, stackTrace) {
    if (onError != null) {
      return onError(error, stackTrace);
    } else {
      log("functionName: $functionName, at: ${DateTime.now()}",error: error, stackTrace: stackTrace);
    }
    return defaultValue;
  }
}

String? validatePassWord(String password,
    {
      bool requireUppercase = true,
      bool requireLowercase = true,
      bool requireDigit = true,
      bool requireSpecial = true,
      int minLength = 8,
      int maxLength = 12,
    }) {
  List<String> pass = password.split('').toList();

  bool hasUppercase =
  pass.any((char) => char.codeUnitAt(0) >= 65 && char.codeUnitAt(0) <= 90);
  bool hasLowercase =
  pass.any((char) => char.codeUnitAt(0) >= 97 && char.codeUnitAt(0) <= 122);
  bool hasDigit =
  pass.any((char) => char.codeUnitAt(0) >= 48 && char.codeUnitAt(0) <= 57);
  bool hasSpecial = pass.any((char) =>
  (char.codeUnitAt(0) >= 33 && char.codeUnitAt(0) <= 47) ||
      (char.codeUnitAt(0) >= 58 && char.codeUnitAt(0) <= 64) ||
      (char.codeUnitAt(0) >= 91 && char.codeUnitAt(0) <= 96) ||
      (char.codeUnitAt(0) >= 123 && char.codeUnitAt(0) <= 126));

  if (requireUppercase && !hasUppercase) {
    return "Password must contain at least one uppercase letter";
  } else if (requireLowercase && !hasLowercase) {
    return "Password must contain at least one lowercase letter";
  } else if (requireDigit && !hasDigit) {
    return "Password must contain at least one digit";
  } else if (requireSpecial && requireSpecial && !hasSpecial) {
    return "Password must contain at least one special character";
  } else if (password.length<= minLength || password.length >= maxLength) {
    return "Password must be between 8 and 12 characters long.";
  } else {
    return null;
  }
}

void showSnackBar(String message,BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

Color strengthenColor(Color color, double factor) {
  int r = (color.red * factor).clamp(0, 255).toInt();
  int g = (color.green * factor).clamp(0, 255).toInt();
  int b = (color.blue * factor).clamp(0, 255).toInt();

  return Color.fromARGB(color.alpha, r, g, b);
}

List<DateTime> generateWeekDates(int skipWeeks){
  final today = DateTime.now();
  final weekDay = today.weekday;
  DateTime startOfWeek = today.subtract(Duration(days: weekDay==7?0:weekDay));
  startOfWeek = startOfWeek.add(Duration(days: skipWeeks*7));
  return List.generate(7, (index)=>startOfWeek.add(Duration(days: index)));
}

String rgbToHex(Color color){
  return "${color.red.toRadixString(16).padLeft(2,'0')}${color.green.toRadixString(16).padLeft(2,'0')}${color.blue.toRadixString(16).padLeft(2,'0')}";
}

Color hexToRgb(String hex){
  return Color(int.parse(hex,radix: 16)+0xFF000000);
}

void sessionExpiredPopUp(Object e) {
  if (e is StatusCodeException && e.statusCode == 498) {
    final context1 = navigatorKey.currentContext!;
    showDialog(
      context: context1,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.red, size: 28),
              SizedBox(width: 8),
              Text("Session Expired", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            "Your session has expired. Please log in again.",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Future.delayed(const Duration(milliseconds: 500), () {
                  Navigator.of(context1).pushReplacement(
                    MaterialPageRoute(builder: (context) => const Welcome()),
                  );
                });
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text("Re-Login"),
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget centerLoader(){
  return const Center(
      child: SizedBox(
        height: 100,
        width: 100,
        child: LoadingIndicator(
            indicatorType: Indicator.lineScale, /// Required, The loading type of the widget
            colors: [Colors.yellow,Colors.green,Colors.orangeAccent,Colors.green,Colors.red],       /// Optional, The color collections
            strokeWidth: 10,                     /// Optional, The stroke of the line, only applicable to widget which contains line
            backgroundColor: Colors.transparent,      /// Optional, Background of the widget
            pathBackgroundColor: Colors.black   /// Optional, the stroke backgroundColor
        ),
      )
  );
}
