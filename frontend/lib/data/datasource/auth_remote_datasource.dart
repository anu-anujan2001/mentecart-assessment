import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';

class AuthRemoteDatasource {
  Future<Response> login(String email, String password) async {
    return await DioClient.dio.post(
      "/auth/login",

      data: {"email": email, "password": password},
    );
  }

  Future<Response> register(String name, String email, String password) async {
    return await DioClient.dio.post(
      "/auth/register",

      data: {"name": name, "email": email, "password": password},
    );
  }
}
