import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {
  AppInterceptors(
    this.onRequestHeader,
    this.onResponseCallback,
    this.onErrorCallback,
  );

  final Future<Map<String, dynamic>> Function()? onRequestHeader;
  final Future<void> Function(Response)? onResponseCallback;
  final Future<void> Function(DioError)? onErrorCallback;

  @override
  FutureOr<dynamic> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (onRequestHeader != null) {
      final header = await onRequestHeader!.call();
      options.headers.addAll(header);
      // print all request headers
      options.headers.forEach((key, value) {
        log('Request Header | $key : $value');
      });
    }
    return handler.next(options);
  }

  @override
  FutureOr<dynamic> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    await onResponseCallback?.call(response);
    return handler.resolve(response);
  }

  @override
  FutureOr<dynamic> onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    await onErrorCallback?.call(err);
    log(err.message ?? err.error.toString(), error: err);
    return handler.next(err);
  }
}
