import 'package:dio/dio.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

void setUpDio(Dio dio) {
  dio.options.baseUrl = 'https://jsonplaceholder.typicode.com';
  dio.options.connectTimeout = const Duration(seconds: 8);
  dio.options.receiveTimeout = const Duration(seconds: 8);

  dio.interceptors.addAll([
    TalkerDioLogger(
      settings: const TalkerDioLoggerSettings(
        printRequestData: true,
        printRequestHeaders: true,
        printResponseMessage: true,
      ),
    ),
  ]);
}
