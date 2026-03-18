import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class DioClient {
  final String apiBaseUrl;

  DioClient({required this.apiBaseUrl});

  Dio get dio => _getDio();

  Dio _getDio() {
    BaseOptions options = BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: Duration(milliseconds: 50000),
      receiveTimeout: Duration(milliseconds: 30000),
    );
    Dio dio = Dio(options);
    dio.interceptors.addAll(<Interceptor>[_loggingInterceptor()]);

    return dio;
  }

  Interceptor _loggingInterceptor() {
    return InterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
        debugPrint("\n"
            "Request ${options.uri} \n"
            "-- headers --\n"
            "${options.headers.toString()} \n"
            "");
        handler.next(options);
      },
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        if (response.statusCode == 200) {
          debugPrint("\n"
              "Response ${response.requestOptions.uri} \n"
              "-- headers --\n"
              "${response.headers.toString()} \n"
              "-- payload --\n"
              "${jsonEncode(response.data)} \n"
              "");
        } else {
          debugPrint("Dio Response Status --> ${response.statusCode}");
        }
        handler.next(response);
      },
      onError: (DioException e, ErrorInterceptorHandler handler) {
        debugPrint("Dio Response Error --> $e");
        handler.next(e);
      },
    );
  }
}
