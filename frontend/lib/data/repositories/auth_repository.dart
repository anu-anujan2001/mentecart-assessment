import 'package:shared_preferences/shared_preferences.dart';
import '../datasource/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthRemoteDatasource datasource;

  AuthRepository(this.datasource);

  Future<UserModel> login(String email, String password) async {
    final response = await datasource.login(email, password);
    final user = UserModel.fromJson(response.data);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", user.token);

    return user;
  }

  Future<void> register(String name, String email, String password) async {
    await datasource.register(name, email, password);
  }
}
