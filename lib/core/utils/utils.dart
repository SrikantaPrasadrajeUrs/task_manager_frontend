import 'dart:developer' show log;
import 'package:flutter/material.dart';

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
