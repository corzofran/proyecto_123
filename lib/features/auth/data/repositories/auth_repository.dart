import '../../../../core/network/http_client.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/database/database_helper.dart';
import '../models/user_model.dart';

/// Repositorio de autenticación.
class AuthRepository {
  final ApiClient _apiClient;

  AuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// LOGIN — busca un usuario por email primero localmente y luego en la API
  Future<UserModel?> login(String email, String password) async {
    // 1. Buscamos en la base de datos local (Persistencia real)
    final localUser = await DatabaseHelper.instance.getUser(email);
    if (localUser != null) {
      return localUser;
    }

    // 2. Si no está local, buscamos en la API
    try {
      final data = await _apiClient.get(AppConstants.usersEndpoint);
      final List users = data as List;

      final match = users.firstWhere(
        (u) => (u['email'] as String).toLowerCase() == email.toLowerCase(),
        orElse: () => null,
      );

      if (match == null) return null;
      
      final user = UserModel.fromJson(match);
      // Guardamos localmente para la próxima vez
      await DatabaseHelper.instance.insertUser(user);
      return user;
    } catch (e) {
      return null;
    }
  }

  /// REGISTER — crea un usuario y lo guarda en la base de datos local
  Future<UserModel> register(String name, String email, String username) async {
    final data = await _apiClient.post(
      AppConstants.usersEndpoint,
      {
        'name': name,
        'email': email,
        'username': username,
      },
    );

    final newUser = UserModel.fromJson(data);
    
    // GUARDAR EN BASE DE DATOS LOCAL (Persistencia permanente)
    await DatabaseHelper.instance.insertUser(newUser);
    
    return newUser;
  }
}
