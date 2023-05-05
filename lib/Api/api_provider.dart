import 'dart:convert';
import 'dart:developer';

import 'package:cpscom_admin/Api/urls.dart';
import 'package:cpscom_admin/Features/CreateNewGroup/Model/response_create_group.dart';
import 'package:cpscom_admin/Features/Home/Model/response_groups_list.dart';
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

  ///--------- Fetch Groups List  -----///
  Future<ResponseGroupsList> fetchGroupsList(Map<String, String> uid) async {
    String url = Urls.baseUrl + Urls.groupNameList;
    try {
      Response response = await _dio.post(url, data: uid);
      log('--------Response Groups List : $response');
      return response.statusCode == 200
          ? ResponseGroupsList.fromJson(response.data)
          : throw Exception('Something Went Wrong');
    } catch (error, stacktrace) {
      log("Exception occurred: $error stackTrace: $stacktrace");
      return ResponseGroupsList.withError(
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

// ///--------- Get Massage Essentials List Items -----///
// Future<MassageEssentialsResponseModel> fetchMassageEssentials() async {
//   try {
//     Response response =
//         await _dio.get(Urls.baseUrl + Urls.massageEssentialItems);
//     if (kDebugMode) {
//       log('--------Response Massage Essentials Products List : $response');
//     }
//     return response.statusCode == 200
//         ? MassageEssentialsResponseModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return MassageEssentialsResponseModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Fetch Enhance Your Health Products List Items -----///
// Future<HealthProductsResponseModel> fetchHeathProducts() async {
//   try {
//     Response response = await _dio.get(Urls.baseUrl + Urls.healthItems);
//     if (kDebugMode) {
//       log('--------Response Health Products List : $response');
//     }
//     return response.statusCode == 200
//         ? HealthProductsResponseModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return HealthProductsResponseModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Get Massage Essentials Item Details List Items -----///
// Future<ProductDetailsResponseModel> fetchProductDetails(String id) async {
//   try {
//     Response response =
//         await _dio.get(Urls.baseUrl + Urls.massageEssentialItemDetails + id);
//     if (kDebugMode) {
//       log('--------Response Massage Essentials Item Details : $response');
//     }
//     return response.statusCode == 200
//         ? ProductDetailsResponseModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return ProductDetailsResponseModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Fetch Feedback / Therapist Reviews List Items -----///
// Future<FeedBackListResponseModel> fetchFeedbackList(
//     FeedBackListRequestModel requestModel) async {
//   String url = Urls.baseUrl + Urls.therapistList;
//   try {
//     Response response = await _dio.post(url, data: requestModel.toJson());
//     if (kDebugMode) {
//       log('--------Response Feedback List : $response');
//     }
//     return response.statusCode == 200
//         ? FeedBackListResponseModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return FeedBackListResponseModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Fetch Feedback / Therapist Reviews List Items -----///
// Future<ResponseMyGiftCards> fetchMyGiftCardList(
//     MyGiftCardListRequestModel requestModel) async {
//   String url = Urls.baseUrl + Urls.myGiftCard;
//   try {
//     Response response = await _dio.post(url, data: requestModel.toJson());
//     if (kDebugMode) {
//       log('--------Response My Gift Card List : $response');
//     }
//     return response.statusCode == 200
//         ? ResponseMyGiftCards.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return ResponseMyGiftCards.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Fetch Massage Club View Contents  -----///
// Future<ViewContentsModel> fetchViewContents() async {
//   String url = Urls.baseUrl + Urls.massageClubViewContents;
//   try {
//     Response response = await _dio.get(url);
//     if (kDebugMode) {
//       log('--------Response View Contents : $response');
//     }
//     return response.statusCode == 200
//         ? ViewContentsModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return ViewContentsModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Fetch Feedback / Therapist Reviews List Items -----///
// Future<ReferCreditResponseModel> fetchReferCreditLink(
//     ReferCreditRequestModel requestModel) async {
//   String url = Urls.baseUrl + Urls.referCredit;
//   try {
//     Response response = await _dio.post(url, data: requestModel.toJson());
//     if (kDebugMode) {
//       log('--------Response Refer Credit : $response');
//     }
//     return response.statusCode == 200
//         ? ReferCreditResponseModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return ReferCreditResponseModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Fetch Country List Items -----///
// Future<ResponseCountryModel> fetchCountryList() async {
//   try {
//     Response response = await _dio.get(Urls.baseUrl + Urls.getCountry);
//     if (kDebugMode) {
//       log('--------Response Country List : $response');
//     }
//     return response.statusCode == 200
//         ? ResponseCountryModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return ResponseCountryModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Fetch State List Items -----///
// Future<ResponseStateModel> fetchStateList(String countryId) async {
//   try {
//     Response response =
//         await _dio.get(Urls.baseUrl + Urls.getState + countryId);
//     if (kDebugMode) {
//       log('--------Response State List : $response');
//     }
//     return response.statusCode == 200
//         ? ResponseStateModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return ResponseStateModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Fetch City List Items -----///
// Future<ResponseCityModel> fetchCityList(String stateId) async {
//   try {
//     Response response = await _dio.get(Urls.baseUrl + Urls.getCity + stateId);
//     if (kDebugMode) {
//       log('--------Response City List : $response');
//     }
//     return response.statusCode == 200
//         ? ResponseCityModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return ResponseCityModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Fetch Massage Club All Reviews   -----///
// Future<ResponseAllReviewsModel> fetchAllReviews() async {
//   String url = Urls.baseUrl + Urls.massageClubReviews;
//   try {
//     Response response = await _dio.get(url);
//     if (kDebugMode) {
//       log('--------Response All Reviews : $response');
//     }
//     return response.statusCode == 200
//         ? ResponseAllReviewsModel.fromJson(json.decode(response.data))
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return ResponseAllReviewsModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Fetch Order Histories   -----///
// Future<OrderHistoryResponseModel> fetchOrderHistory(
//     RequestOrderHistory requestOrderHistory) async {
//   String url = Urls.baseUrl + Urls.orderHistory;
//   try {
//     Response response =
//         await _dio.post(url, data: requestOrderHistory.toJson());
//     if (kDebugMode) {
//       log('--------Response Order History : $response');
//     }
//     return response.statusCode == 200
//         ? OrderHistoryResponseModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return OrderHistoryResponseModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Fetch Cart List  -----///
// Future<CartResponseModel> fetchCartList(String userId) async {
//   String url = Urls.baseUrl + Urls.cartList;
//   try {
//     Response response = await _dio.get(url + userId);
//     if (kDebugMode) {
//       log('--------Response Cart List : $response');
//     }
//     return response.statusCode == 200
//         ? CartResponseModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return CartResponseModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Fetch Default Shipping Address Items -----///
// Future<ResponseDefaultShippingAddressModel> fetchDefaultShippingAddress(
//     RequestDefaultShippingAddressModel requestModel) async {
//   String url = Urls.baseUrl + Urls.getDefaultShipTo;
//   try {
//     Response response = await _dio.post(url, data: requestModel.toJson());
//     if (kDebugMode) {
//       log('--------Response Default Shipping Address : $response');
//     }
//     return response.statusCode == 200
//         ? ResponseDefaultShippingAddressModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return ResponseDefaultShippingAddressModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Fetch User Details Items -----///
// Future<UserDetailsResponseModel> fetchUserDetails(
//     UserDetailsRequestModel requestModel) async {
//   String url = Urls.baseUrl + Urls.userDetails;
//   try {
//     Response response = await _dio.post(url, data: requestModel.toJson());
//     if (kDebugMode) {
//       log('--------Response User Details : $response');
//     }
//     return response.statusCode == 200
//         ? UserDetailsResponseModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return UserDetailsResponseModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Fetch All Gift Cards List Items -----///
// Future<AllGiftCardsResponseModel> fetchAllGiftCardsList() async {
//   try {
//     Response response = await _dio.get(Urls.baseUrl + Urls.allGifts);
//     if (kDebugMode) {
//       log('--------Response All Gift Cards List : $response');
//     }
//     return response.statusCode == 200
//         ? AllGiftCardsResponseModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return AllGiftCardsResponseModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Add Product To Cart --------------///
// Future<AddToCartResponseModel> addToCart(
//     AddToCartRequestModel requestModel) async {
//   String url = Urls.baseUrl + Urls.addToCart;
//   try {
//     Response response = await _dio.post(url, data: requestModel.toJson());
//     if (kDebugMode) {
//       log('--------Response add to Cart : $response');
//     }
//     return response.statusCode == 200
//         ? AddToCartResponseModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return AddToCartResponseModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Delete Cart Item --------------///
// Future<DeleteCartResponseModel> deleteCartItem(
//     DeleteCartItemRequestModel requestModel) async {
//   String url = Urls.baseUrl + Urls.deleteCart;
//   try {
//     Response response = await _dio.post(url, data: requestModel.toJson());
//     if (kDebugMode) {
//       log('--------Response delete cart item : $response');
//     }
//     return response.statusCode == 200
//         ? DeleteCartResponseModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return DeleteCartResponseModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
//
// ///--------- Fetch Massage Services List  -----///
// Future<MassageServicesResponseModel> fetchMassageServices() async {
//   String url = Urls.baseUrl + Urls.getMassageType;
//   try {
//     Response response = await _dio.get(url);
//     if (kDebugMode) {
//       log('--------Response Massage Services List : $response');
//     }
//     return response.statusCode == 200
//         ? MassageServicesResponseModel.fromJson(response.data)
//         : throw Exception('Something Went Wrong');
//   } catch (error, stacktrace) {
//     if (kDebugMode) {
//       log("Exception occurred: $error stackTrace: $stacktrace");
//     }
//     return MassageServicesResponseModel.withError(
//         "You're offline. Please check your Internet connection.");
//   }
// }
}
