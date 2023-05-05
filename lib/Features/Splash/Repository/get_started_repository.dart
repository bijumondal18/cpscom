import 'package:cpscom_admin/Features/Splash/Model/get_started_response_model.dart';

import '../../../Api/api_provider.dart';

class GetStartedRepository {
  final apiProvider = ApiProvider();

  Future<ResponseGetStarted> getStarted(RequestGetStarted requestGetStarted) {
    return apiProvider.getStarted(requestGetStarted);
  }
}

class NetworkError extends Error {}
