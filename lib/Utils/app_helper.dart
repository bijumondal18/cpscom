import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
// import 'package:package_info_plus/package_info_plus.dart';

class AppHelper {
  static String getDateFromString(String givenDate) {
    var inputDate = DateTime.parse(givenDate);
    var outputFormat = DateFormat('hh:mm a');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String getStringDateFromTimestamp(int timestamp) {
    DateTime inputDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: false);
    var outputFormat = DateFormat('dd MMM, yyyy').format(inputDate);
    return outputFormat;
  }

  static String getStringTimeFromTimestamp(int timestamp) {
    DateTime inputDate =
        DateTime.fromMillisecondsSinceEpoch(timestamp, isUtc: false);
    var outputFormat = DateFormat('hh:mm a').format(inputDate);
    return outputFormat;
  }
}

extension extString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp =
        RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>');
    return passwordRegExp.hasMatch(this);
  }

  bool get isNotNull {
    return this != null;
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^\+?0[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }
}

extension DateHelper on DateTime {

  String formatDate() {
    final formatter = DateFormat('dd MMM, yyyy');
    return formatter.format(this);
  }
  bool isSameDate(DateTime other) {
    return this.year == other.year &&
        this.month == other.month &&
        this.day == other.day;
  }

  int getDifferenceInDaysWithNow() {
    final now = DateTime.now();
    return now.difference(this).inDays;
  }
}
