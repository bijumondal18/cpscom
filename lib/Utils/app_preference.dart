import 'dart:math';

//import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  static late SharedPreferences sharedPreferences;
  //static late FlutterSecureStorage flutterSecureStorage;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
    //flutterSecureStorage = const FlutterSecureStorage();
  }

  Future<void> clearPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> setIsFirstTimeAppLoaded(bool firstTimeAppLoaded) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('first_time_app_loaded', firstTimeAppLoaded);
  }

  Future<bool?> isFirstTimeAppLoaded() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? firstTimeAppLoaded = prefs.getBool('first_time_app_loaded');
    return firstTimeAppLoaded;
  }

  Future<void> setIsLoggedIn(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_logged_in', isLoggedIn);
  }

  Future<bool?> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? loggedIn = prefs.getBool('is_logged_in');
    return loggedIn;
  }

  Future<void> setUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_id', userId);
  }

  Future<String> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userId = prefs.getString('user_id') ?? '0';
    return userId;
  }

  Future<void> setFirstName(String firstName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('first_name', firstName);
  }

  Future<String> getFirstName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String firstName = prefs.getString('first_name') ?? '';
    return firstName;
  }

  Future<void> setLastName(String lastName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('last_name', lastName);
  }

  Future<String> getLastName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String lastName = prefs.getString('last_name') ?? '';
    return lastName;
  }

  Future<void> setMobileNumber(String mobile) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mobile_number', mobile);
  }

  Future<String> getMobileNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String mobile = prefs.getString('mobile_number') ?? '';
    return mobile;
  }

  Future<void> setUserType(String userType) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_type', userType);
  }

  Future<String> getUserType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userType = prefs.getString('user_type')!;
    return userType;
  }
}

class ImagePreference {
  static late SharedPreferences sharedPreferences;

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static String getFileSizeString({required int bytes, int decimals = 0}) {
    const suffixes = ["b", "kb", "mb", "gb", "tb"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
  }

  Future<void> setImagePath(String imagePath) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('profile_image', imagePath);
  }

  Future<String> getImagePath() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String image = prefs.getString('profile_image')!;
    return image;
  }
}
