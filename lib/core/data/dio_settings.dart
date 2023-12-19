import 'package:dio/dio.dart';

class DioSettings {
  final BaseOptions _dioBaseOptions = BaseOptions();

  BaseOptions get dioBaseOptions => _dioBaseOptions;
  Dio get dio {
    final dio = Dio();
    // dio.interceptors.add(
    //   LogInterceptor(
    //     responseBody: true,
    //     requestBody: true,
    //     request: true,
    //     requestHeader: true,
    //   ),
    // );
    return dio;
  }
}
