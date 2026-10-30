import 'package:dio/dio.dart';

class AppHttpClient {
  AppHttpClient._();

  static const baseUrl = 'https://viacep.com.br/ws';
  static const timeoutInMilliseconds = 10000;

  static Dio create() {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: timeoutInMilliseconds,
        receiveTimeout: timeoutInMilliseconds,
        responseType: ResponseType.json,
      ),
    );
  }
}
