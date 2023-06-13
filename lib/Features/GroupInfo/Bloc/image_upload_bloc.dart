// import 'dart:async';
// import 'dart:io';
//
// import 'package:bloc/bloc.dart';
// import 'package:cpscom_admin/Api/api_provider.dart';
// import 'package:cpscom_admin/Features/GroupInfo/Model/response_image_upload.dart';
// import 'package:equatable/equatable.dart';
//
// part 'image_upload_event.dart';
//
// part 'image_upload_state.dart';
//
// class ImageUploadBloc extends Bloc<ImageUploadEvent, ImageUploadState> {
//   ImageUploadBloc() : super(ImageUploadStateInitial()) {
//     final ApiProvider apiProvider = ApiProvider();
//     on<ImageUploadSubmittedEvent>((event, emit) async {
//       Map<String, dynamic> request = {
//         "image": event.filePath,
//         "group_id": event.groupId,
//       };
//       try {
//         emit(ImageUploadStateLoading());
//         final mData = await apiProvider.uploadGroupImage(request);
//         if (mData.status == true) {
//           emit(ImageUploadStateLoaded(mData));
//         } else {
//           emit(ImageUploadStateFailed(mData.message.toString()));
//           emit(ImageUploadStateInitial());
//         }
//       } catch (e) {
//         emit(ImageUploadStateFailed(e.toString()));
//         emit(ImageUploadStateInitial());
//       }
//     });
//   }
// }
