import 'package:dio/dio.dart';

class DioHelper {
  static late Dio _dio;

  static init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://fcm.googleapis.com/fcm/send',
        receiveDataWhenStatusError: true,
      ),
    );
  }

  static Future<Response?> postData({
    required String path,
    Map<String, dynamic>? query,
    required Map<String, dynamic> data,
    String? token,
    String? baseUrl,
  }) async {
    final dio = (baseUrl == null)
        ? _dio
        : Dio(
            BaseOptions(
              baseUrl: baseUrl,
              receiveDataWhenStatusError: true,
            ),
          );

    dio.options.headers = {
      'Content-Type': 'application/json',
      'Authorization': token,
    };
    return await dio.post(
      path,
      queryParameters: query,
      data: data,
    );
  }
}
