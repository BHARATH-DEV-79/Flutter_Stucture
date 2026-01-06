

import 'package:dio/dio.dart';
import '../../utils/constants/api_errors.dart';

class DioErrorHandler {
  static ApiError handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiError(message: "Connection timeout");

      case DioExceptionType.sendTimeout:
        return ApiError(message: "Request timeout");

      case DioExceptionType.receiveTimeout:
        return ApiError(message: "Response timeout");

      case DioExceptionType.badResponse:
        final status = error.response?.statusCode;
        final message =
            error.response?.data?['message'] ??
            "Server error occurred";
        return ApiError(message: message, statusCode: status);

      case DioExceptionType.cancel:
        return ApiError(message: "Request cancelled");

      case DioExceptionType.connectionError:
        return ApiError(message: "No internet connection");

      default:
        return ApiError(message: "Something went wrong");
    }
  }
}




// import 'dart:io';

// import 'package:dio/dio.dart';
// import 'package:flutter/widgets.dart';

// import '../../utils/constants/app_strings.dart';
// import '../../utils/constants/enums.dart';
// import '../../utils/widgets/common_snackbar.dart';
// import '../app_execptions.dart';

// class ExceptionHandler {
//   static AppException handleApiException(DioException e) {
//     if (e.error.runtimeType == SocketException) {
//       throw DataFetchException('No Internet');
//     } else if (e.response?.statusCode == 400) {
//       String? type = e.response?.data['error']['type'];
//       String? message = e.response?.data['error']['message'];
//       if (type == AppStrings.unauthorizedException ||
//           message == AppStrings.unauthorizedException) {
//         // AppStorage().clearAll();
//         message = AppStrings.tokenExpired;
//       } else {
//         message = e.response?.data['error']['message'];
//       }

//       throw BadRequestException(message ?? 'Bad Request');
//     } else if (e.response?.statusCode == 401) {
//       throw UnauthorizedException();
//     } else if (e.response?.statusCode == 429) {
//       throw TooManyRequestsException();
//     } else if (e.response?.statusCode == 500) {
//       throw InternalErrorException();
//     } else {
//       throw UnknownErrorException();
//     }
//   }

//   static void handleUiException({
//     required BuildContext context,
//     required Status status,
//     required String? message,
//     bool? showDataNotFound,
//     void Function()? onServerError,
//   }) {
//     if (status == Status.ERROR) {
//       if (onServerError != null) {
//         onServerError();
//       }
//       if ((message?.contains(AppStrings.unauthorizedException) ?? false) ||
//           (message?.contains(AppStrings.tokenExpired) ?? false)) {
//         // showCommonSnackbar(context, message: 'Invalid Credentials');
//         // Navigator.pushNamed(context, AppRoutes.mainDashboard);
//       } else if (message == AppStrings.errorNetwork) {
//         //TODO: Design No internet page

//         // context.goNamed(noInternetRoute);
//         showCommonSnackbar(context, message: 'Invalid Credentials');
//       } else if (showDataNotFound ?? true) {
//         showCommonSnackbar(context, message: 'Invalid Credentials');
//       }
//     }
//   }
// }
