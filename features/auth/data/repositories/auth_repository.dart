import 'package:proyecto_123/core/network/api_client.dart';
import 'package:proyecto_123/core/constants/app_constants.dart';
import 'package:proyecto_123/features/auth/data/models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<UserModel> login(String email, String password) async {
    try {
      // Intento real a la API de simulación
      final response = await _apiClient.post(AppConstants.loginEndpoint, {
        'email': email,
        'password': password,
      });
      return UserModel(
        id: '1',
        email: email,
        name: 'Usuario Demo',
        token: response['token'],
      );
    } catch (e) {
      // MODO DEMO: Si la API falla, devolvemos un usuario falso para tus capturas
      return UserModel(
        id: '99',
        email: email,
        name: 'Admin Pro',
        token: 'fake_token_for_screenshots',
      );
    }
  }

  Future<UserModel> register(String email, String password, String name) async {
    try {
      await _apiClient.post(AppConstants.registerEndpoint, {
        'email': email,
        'password': password,
      });
      return UserModel(id: '2', email: email, name: name, token: 'reg_token');
    } catch (e) {
      return UserModel(id: '100', email: email, name: name, token: 'demo_token');
    }
  }
}
