import 'package:dio/dio.dart';
import '../network/dio_interceptor.dart';

class ApiServices {
  late final Dio _dio;

//POST
  Future<Response> post({
    required String url,
    required Object data,
  }) async {
    try {
      _dio = Dio();
      _dio.interceptors.add(DioInterceptor());
      final response = await _dio.post(
        url,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

//PUT
  Future<Response> put({
    required String url,
    required Object data,
  }) async {
    try {
      _dio = Dio();
      _dio.interceptors.add(DioInterceptor());
      final response = await _dio.put(
        url,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //GET
  Future<Response> get({
    required String url,
    String params = "",
  }) async {
    try {
      _dio = Dio();
      _dio.interceptors.add(DioInterceptor());
      final response = await _dio.get(
        url + params,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  //DELETE
  Future<Response> delete({
    required String url,
    String params = "",
  }) async {
    try {
      _dio = Dio();
      _dio.interceptors.add(DioInterceptor());
      final response = await _dio.delete(
        url + params,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
