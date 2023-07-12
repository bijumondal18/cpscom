import 'package:cpscom_admin/Features/ReportScreen/Model/user_report_model.dart';

import '../../../Api/api_provider.dart';

class UserReportRepository {
  final apiProvider = ApiProvider();

  Future<UserReportResponseModel> userReport(Map<String, dynamic> requestUserReport) {
    return apiProvider.userReport(requestUserReport);
  }
}

class NetworkError extends Error {}