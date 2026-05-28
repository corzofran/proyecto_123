import 'package:proyecto_123/core/network/api_client.dart';
import 'package:proyecto_123/core/constants/app_constants.dart';
import 'package:proyecto_123/features/auth/data/models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  Future<UserModel> login(String email, String password) async {
    // Usando ReqRes.in para el login real
    final response = await _apiClient.post(AppConstants.loginEndpoint, {
      'email': email,
      'password': password,
    });
    
    // ReqRes solo devuelve el token, así que complementamos el modelo
    return UserModel(
      id: '1',
      email: email,
      name: 'Usuario Logueado',
      token: response['token'],
    );
  }

  Future<UserModel> register(String email, String password, String name) async {
    // Usando ReqRes.in para el registro real
    final response = await _apiClient.post(AppConstants.registerEndpoint, {
      'email': email,
      'password': password,
    });
    
    return UserModel(
      id: response['id']?.toString() ?? '2',
      email: email,
      name: name,
      token: response['token'] ?? 'token-registro-exitoso',
    );
  }
}
