import 'dart:developer';

import 'package:dio/dio.dart';

class ApiClient {
  static Dio _dio = Dio();

  // Future<Response> registerUser(Map<String, dynamic>? userData) async {
  //   try {
  //     Response response = await _dio.post(path)
  //   } catch (e) {

  //   }
  // }
  static Future<Response> login(String username, String password) async {
    Response? response;
    var data = FormData.fromMap({
      'username': username,
      'password': password,
    });
    try {
      response = await _dio.post('http://127.0.0.1:8000/api/login', data: data);
      log(response.toString());
      // if()
    } catch (e) {
      // throw Exception(e.toString());
      log('gagal');
    }
    return response!;
  }
  // Future<Response> getUserProfilData() async {}
  // Future<Response> logout() async {}
}
