import 'package:cpscom_admin/Features/Home/Model/response_groups_list.dart';

import '../../../Api/api_provider.dart';

class FetchGroupsListRepository {
  final apiProvider = ApiProvider();

  Future<ResponseGroupsList> fetchGroupsList(Map<String, String> uid) {
    return apiProvider.fetchGroupsList(uid);
  }
}

class NetworkError extends Error {}
