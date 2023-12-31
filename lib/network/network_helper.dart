import 'package:dio/dio.dart';

abstract class NetworkHelper {
  void changeLanguage(String lang);

  void cancelRequests({CancelToken? cancelToken});

  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParams,
  });

  Future<Response<T>> post<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Function(int? count, int? total)? onSendProgress,
    Function(int? count, int? total)? onReceiveProgress,
  });

  Future<Response<T>> delete<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParams,
  });

  Future<Response<T>> put<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    Function(int? count, int? total)? onSendProgress,
    Function(int? count, int? total)? onReceiveProgress,
  });

  Future<dynamic> getFile(String? url);
}
