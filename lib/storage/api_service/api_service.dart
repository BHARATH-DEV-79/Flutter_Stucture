



import 'package:dio/dio.dart';

import 'api_execption.dart';
import 'api_network.dart';


class ApiService {
  static Future<T> get<T>({
    required String path,
    required T Function(dynamic data) fromJson,
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await DioClient.instance.get(
        path,
        queryParameters: query,
      );
      return fromJson(response.data);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  static Future<T> post<T>({
    required String path,
    required dynamic body,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await DioClient.instance.post(
        path,
        data: body,
      );
      return fromJson(response.data);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  static Future<T> put<T>({
    required String path,
    required dynamic body,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await DioClient.instance.put(
        path,
        data: body,
      );
      return fromJson(response.data);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  static Future<T> delete<T>({
    required String path,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await DioClient.instance.delete(path);
      return fromJson(response.data);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}



// abstract class BaseService {
//   static final BaseOptions options = BaseOptions(
//     baseUrl: dotenv.env['SERVER_URL'] ?? '',
//     contentType: 'application/json',
//   );

//   static Dio dio = Dio(options);

//   static Options headerWithToken(String token) {
//     return Options(headers: {Keys.TokenKey: token});
//   }
// }

// extension ApiStatusExtension on int {
//   ApiStatus toApiStatus() {
//     switch (this) {
//       case 200:
//         return ApiStatus.success200;
//       case 400:
//         return ApiStatus.error400;
//       case 401:
//         return ApiStatus.unauthorized401;
//       case 404:
//         return ApiStatus.notFound404;
//       case 500:
//         return ApiStatus.serverError500;
//       default:
//         return ApiStatus.unknown;
//     }
//   }
// }

// // Exceptions
// class ApiException implements Exception {
//   final String message;
//   final int? statusCode;
//   ApiException(this.message, {this.statusCode});
//   @override
//   String toString() => "ApiException($statusCode): $message";
// }

// class ValidationException extends ApiException {
//   final Map<String, List<String>>? fieldErrors;
//   ValidationException(super.message, {this.fieldErrors})
//     : super(statusCode: 400);
// }

// class AuthenticationException extends ApiException {
//   AuthenticationException(super.message) : super(statusCode: 401);
// }

// class ServerException extends ApiException {
//   ServerException(super.message, {super.statusCode});
// }

// class NetworkException extends ApiException {
//   NetworkException(super.message);
// }

// class TimeoutException extends ApiException {
//   TimeoutException() : super("Request timeout. Please try again later.");
// }

// class ApiService {

//   static const Duration timeoutDuration = Duration(seconds: 30);

//   static Map<String, String> _getHeaders({String? token}) {
//     final headers = {
//       'Content-Type': 'application/json',
//       'Accept': 'application/json',
//     };
//     if (token != null && token.isNotEmpty) {
//       headers['token'] = token;
//     }
//     return headers;
//   }

//   static ApiException _handleHttpError(http.Response response) {
//     final statusCode = response.statusCode;
//     String message = 'Unknown error occurred';
//     Map<String, dynamic>? errorJson;

//     try {
//       if (response.body.isNotEmpty) {
//         errorJson = json.decode(response.body);
//         message = errorJson?['message'] ?? errorJson?['error'] ?? message;
//       }
//     } catch (e) {
//       print('Failed to parse error response: $e');
//     }

//     switch (statusCode) {
//       case 400:
//         return ValidationException(message,
//             fieldErrors: errorJson?['field_errors'] != null
//                 ? Map<String, List<String>>.from(errorJson!['field_errors']
//                     .map((k, v) => MapEntry(k, List<String>.from(v))))
//                 : null);
//       case 401:
//         return AuthenticationException(message);
//       case 403:
//       case 404:
//       case 409:
//       case 422:
//         return ApiException(message, statusCode: statusCode);
//       case 429:
//         return ApiException(message, statusCode: statusCode);
//       case 500:
//       case 502:
//       case 503:
//       case 504:
//         return ServerException(message, statusCode: statusCode);
//       default:
//         return ApiException(message, statusCode: statusCode);
//     }
//   }

//   static ApiException _handleNetworkError(dynamic error) {
//     if (error is SocketException) {
//       return NetworkException('No internet connection.');
//     } else if (error is HttpException) {
//       return NetworkException('Network error: ${error.message}');
//     } else if (error is FormatException) {
//       return ApiException('Invalid response format.');
//     } else if (error.toString().contains('timeout')) {
//       return TimeoutException();
//     } else {
//       return NetworkException('Unexpected network error: ${error.toString()}');
//     }
//   }

//   // Helper to determine if token should be added
//   static bool _isAuthFree(String endpoint) {
//     return endpoint == login;
//         // endpoint == verifyOtp ||
//         // endpoint == doctorLogin ||
//         // endpoint == doctorVerifyOtp;
//   }

//   static Future<String?> _getToken(String endpoint, String? customToken) async {
//     if (_isAuthFree(endpoint)) return null;
//     return customToken ?? await AppStorage.getToken();
//   }

//   static void _debugPrint(String method, Uri uri, Map<String, String> headers,
//       dynamic body, http.Response response) {
//     print('\n📡 [$method] Request → ${uri.toString()}');
//     print('📤 Headers → $headers');
//     if (body != null) print('📤 Body → $body');
//     print('📥 Status → ${response.statusCode}');
//     print('📥 Response → ${response.body}');
//   }

//   // GET
//  // GET
// static Future<T> get<T>({
//   required String endpoint,
//   required T Function(Map<String, dynamic>) fromJson,
//   String? token,
//   Map<String, String>? queryParams,
// }) async {
//   try {
//     final uri = Uri.parse('$baseUrl$endpoint')
//         .replace(queryParameters: queryParams);

//     final resolvedToken = await _getToken(endpoint, token);
//     final headers = _getHeaders(token: resolvedToken);

//     final response =
//         await http.get(uri, headers: headers).timeout(timeoutDuration);

//     _debugPrint('GET', uri, headers, null, response);

//     if (response.statusCode >= 200 && response.statusCode < 300 ||
//         response.statusCode == 400) {
//       return fromJson(json.decode(response.body));
//     } else {
//       throw _handleHttpError(response);
//     }
//   } catch (e) {
//     throw e is ApiException ? e : _handleNetworkError(e);
//   }
// }

//   // POST
//   static Future<T> post<T>({
//     required String endpoint,
//     required T Function(Map<String, dynamic>) fromJson,
//     String? token,
//     Map<String, String>? queryParams,
//     Map<String, dynamic>? data,
//   }) async {
//     Uri uri =
//         Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
//     final resolvedToken = await _getToken(endpoint, token);
//     final headers = _getHeaders(token: resolvedToken);
//     final body = data != null ? json.encode(data) : null;

//     // ✅ Always print the request before sending
//     print('\n📡 [POST] Request → $uri');
//     print('📤 Headers → $headers');
//     if (body != null) print('📤 Body → $body');

//     try {
//       final response = await http
//           .post(uri, headers: headers, body: body)
//           .timeout(timeoutDuration);

//       // ✅ Print response
//       print('📥 Status → ${response.statusCode}');
//       print('📥 Response → ${response.body}');

//       if (response.statusCode >= 200 && response.statusCode < 300 ||
//           response.statusCode == 400) {
//         return fromJson(json.decode(response.body));
//       } else {
//         throw _handleHttpError(response);
//       }
//     } catch (e) {
//       print('❌ Error → $e');
//       throw e is ApiException ? e : _handleNetworkError(e);
//     }
//   }

//   // PUT
//   static Future<T> put<T>({
//     required String endpoint,
//     required T Function(Map<String, dynamic>) fromJson,
//     String? token,
//     Map<String, String>? queryParams,
//     Map<String, dynamic>? data,
//   }) async {
//     try {
//       Uri uri =
//           Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
//       final resolvedToken = await _getToken(endpoint, token);
//       final headers = _getHeaders(token: resolvedToken);
//       final body = data != null ? json.encode(data) : null;

//       final response = await http
//           .put(uri, headers: headers, body: body)
//           .timeout(timeoutDuration);
//       _debugPrint('PUT', uri, headers, body, response);

//       if (response.statusCode >= 200 && response.statusCode < 300 ||
//           response.statusCode == 400) {
//         return fromJson(json.decode(response.body));
//       } else {
//         throw _handleHttpError(response);
//       }
//     } catch (e) {
//       throw e is ApiException ? e : _handleNetworkError(e);
//     }
//   }

//   // PATCH
//   static Future<T> patch<T>({
//     required String endpoint,
//     required T Function(Map<String, dynamic>) fromJson,
//     String? token,
//     Map<String, String>? queryParams,
//     Map<String, dynamic>? data,
//   }) async {
//     try {
//       Uri uri =
//           Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
//       final resolvedToken = await _getToken(endpoint, token);
//       final headers = _getHeaders(token: resolvedToken);
//       final body = data != null ? json.encode(data) : null;

//       final response = await http
//           .patch(uri, headers: headers, body: body)
//           .timeout(timeoutDuration);
//       _debugPrint('PATCH', uri, headers, body, response);

//       if (response.statusCode >= 200 && response.statusCode < 300 ||
//           response.statusCode == 400) {
//         return fromJson(json.decode(response.body));
//       } else {
//         throw _handleHttpError(response);
//       }
//     } catch (e) {
//       throw e is ApiException ? e : _handleNetworkError(e);
//     }
//   }

//   // DELETE
//   static Future<T> delete<T>({
//     required String endpoint,
//     String? token,
//     Map<String, String>? queryParams,
//         required T Function(Map<String, dynamic>) fromJson,

//   }) async {
//     try {
//       Uri uri =
//           Uri.parse('$baseUrl$endpoint').replace(queryParameters: queryParams);
//       final resolvedToken = await _getToken(endpoint, token);
//       final headers = _getHeaders(token: resolvedToken);

//       final response =
//           await http.delete(uri, headers: headers).timeout(timeoutDuration);
//       _debugPrint('DELETE', uri, headers, null, response);

//       if (response.statusCode >= 200 && response.statusCode < 300 ||
//           response.statusCode == 400) {
//         return fromJson(json.decode(response.body));
//       } else {
//         throw _handleHttpError(response);
//       }
//     } catch (e) {
//       throw e is ApiException ? e : _handleNetworkError(e);
//     }
//   }

//   // MULTIPART (upload form-data)
//   static Future<T> upload<T>({
//     required String endpoint,
//     required T Function(Map<String, dynamic>) fromJson,
//     required String method, // 'POST', 'PUT', etc.
//     String? token,
//     Map<String, String>? fields,
//     Map<String, String>? fields2,
//     List<http.MultipartFile>? files,
//   }) async {
//     try {
//       final uri = Uri.parse('$baseUrl$endpoint');
//       final resolvedToken = await _getToken(endpoint, token);

//       final multipartRequest = http.MultipartRequest(method, uri);

//       // Add headers
//       if (resolvedToken != null && resolvedToken.isNotEmpty) {
//         multipartRequest.headers['Authorization'] = resolvedToken;
//       }

//       // Add fields
//       if (fields != null) {
//         multipartRequest.fields.addAll(fields);
//       }

//       // Add fields2
//       if (fields2 != null) {
//         multipartRequest.fields.addAll(fields2);
//       }

//       // Add files
//       if (files != null && files.isNotEmpty) {
//         multipartRequest.files.addAll(files);
//       }

//       print('\n📡 [$method] Multipart Request → $uri');
//       print('📤 Headers → ${multipartRequest.headers}');
//       print('📤 Fields → ${multipartRequest.fields}');
//       print('📤 Fields2 → $fields2');
//       print('📤 Files → ${files?.map((f) => f.filename).toList()}');

//       final streamedResponse = await multipartRequest.send();
//       final response = await http.Response.fromStream(streamedResponse);

//       print('📥 Status → ${response.statusCode}');
//       print('📥 Response → ${response.body}');

//       if (response.statusCode >= 200 && response.statusCode < 300 ||
//           response.statusCode == 400) {
//         return fromJson(json.decode(response.body));
//       } else {
//         throw _handleHttpError(response);
//       }
//     } catch (e) {
//       throw e is ApiException ? e : _handleNetworkError(e);
//     }
//   }
// }
