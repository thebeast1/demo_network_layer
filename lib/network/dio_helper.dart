import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'network_helper.dart';

typedef RequestCallback = Future<Map<String, dynamic>> Function();
typedef ResponseCallback = Future<void> Function(Response);
typedef ErrorCallback = Future<void> Function(DioException);

class DioImpl extends NetworkHelper {
  late Dio _client;

  /// An instance of [CancelToken] used to pre-maturely cancel
  /// network requests.
  final CancelToken _cancelToken;



  DioImpl() : _cancelToken = CancelToken() {
    _client = Dio()
      ..interceptors.addAll([
        if (kDebugMode)
          PrettyDioLogger(
            requestHeader: true,
            requestBody: true,
            responseBody: true,
            error: true,
          ),

        /// add refresh token interceptor
      ])
      ..options.headers.addAll({'Accept': 'application/json'});
  }


  @override
  void changeLanguage(String lang) {
    _client.options.headers.update("lang", (value) => lang);
  }

  @override
  void cancelRequests({CancelToken? cancelToken}) {
    if (cancelToken == null) {
      _cancelToken.cancel('Cancelled');
    } else {
      cancelToken.cancel();
    }
  }

  @override
  Future<Response<T>> get<T>(
    String url, {
    Map<String, dynamic>? queryParams,
  }) {
    return _client.get(
      url,
      queryParameters: queryParams,
    );
  }

  @override
  Future<Response<T>> post<T>(
    String url, {
    dynamic data,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParams,
    Function(int? count, int? total)? onSendProgress,
    Function(int? count, int? total)? onReceiveProgress,
  }) {
    return _client.post(
      url,
      data: data,
      cancelToken: cancelToken ?? _cancelToken,
      queryParameters: queryParams,
    );
  }

  @override
  Future<Response<T>> put<T>(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
    Function(int? count, int? total)? onSendProgress,
    Function(int? count, int? total)? onReceiveProgress,
  }) {
    return _client.put(
      url,
      data: data,
      queryParameters: queryParams,
      cancelToken: cancelToken ?? _cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  @override
  Future<Response<T>> delete<T>(
    String url, {
    dynamic data,
    CancelToken? cancelToken,
    Map<String, dynamic>? queryParams,
  }) {
    return _client.delete(
      url,
      data: data,
      cancelToken: cancelToken ?? _cancelToken,
      queryParameters: queryParams,
    );
  }

  @override
  Future getFile(String? url, {CancelToken? cancelToken}) async {
    return _client.get(
      url!,
      cancelToken: cancelToken ?? _cancelToken,
      options: Options(
        responseType: ResponseType.bytes,
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );
  }
}
