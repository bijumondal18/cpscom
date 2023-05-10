import 'dart:developer';

import 'package:cpscom_admin/Api/urls.dart';
import 'package:cpscom_admin/Features/CreateNewGroup/Model/response_create_group.dart';
import 'package:cpscom_admin/Features/Splash/Model/get_started_response_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiProvider {
  final Dio _dio = Dio();

  ///--------- Fetch CMS Get Started  -----///
  Future<ResponseGetStarted> getStarted(
      RequestGetStarted requestGetStarted) async {
    try {
      Response response = await _dio.post(Urls.baseUrl + Urls.cmsGetStarted,
          data: requestGetStarted.toJson());
      if (kDebugMode) {
        log('--------Response Get Started : $response');
      }
      return response.statusCode == 200
          ? ResponseGetStarted.fromJson(response.data)
          : throw Exception('Something Went Wrong');
    } catch (error, stacktrace) {
      if (kDebugMode) {
        log("Exception occurred: $error stackTrace: $stacktrace");
      }
      return ResponseGetStarted.withError(
          "You're offline. Please check your Internet connection.");
    }
  }

  ///--------- Create Group  -----///
  Future<ResponseCreateGroup> createGroups(Map<String, dynamic> request) async {
    String url = Urls.baseUrl + Urls.groupCreateGroup;
    try {
      Response response = await _dio.post(url, data: request);
      log('--------Response Groups List : $response');
      return response.statusCode == 200
          ? ResponseCreateGroup.fromJson(response.data)
          : throw Exception('Something Went Wrong');
    } catch (error, stacktrace) {
      log("Exception occurred: $error stackTrace: $stacktrace");
      return ResponseCreateGroup.withError(
          "You're offline. Please check your Internet connection.");
    }
  }

}
