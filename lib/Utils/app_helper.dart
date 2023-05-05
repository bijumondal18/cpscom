import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppHelper {
  static String getDeviceInfo() {
    return "";
  }

  static void showToast() {}

  static String getDeviceId() {
    return "";
  }

  static String getAppVersion() {
    String appVersion = '';
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      appVersion = packageInfo.version;
    });

    //String appName = _packageInfo.appName;
    //String packageName = _packageInfo.packageName;
    //appVersion = _packageInfo.version;
    // String buildNumber = _packageInfo.buildNumber;
    return appVersion;
  }

  static String getDateFromString(String givenDate) {
    var inputDate = DateTime.parse(givenDate);
    //var outputFormat = DateFormat('dd MMM, yyyy');
    var outputFormat = DateFormat('dd MMM');
    var outputDate = outputFormat.format(inputDate);
    return outputDate;
  }

  static String getBookingStatus(String givenData) {
    var bookingStatus = '';

    if (givenData == "C") {
      bookingStatus = 'Canceled'.toUpperCase();
    } else if (givenData == "CMP") {
      bookingStatus = 'Completed'.toUpperCase();
    } else if (givenData == "R") {
      bookingStatus = 'Rebook'.toUpperCase();
    } else if (givenData == "N") {
      bookingStatus = 'New'.toUpperCase();
    }

    return bookingStatus;
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
