import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_123/core/constants/app_constants.dart';
import 'package:proyecto_123/core/network/api_client.dart';
import 'package:proyecto_123/core/theme/app_theme.dart';
import 'package:proyecto_123/features/auth/data/repositories/auth_repository.dart';
import 'package:proyecto_123/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:proyecto_123/features/auth/presentation/views/login_view.dart';
import 'package:proyecto_123/features/auth/presentation/views/register_view.dart';
import 'package:proyecto_123/features/tasks/data/repositories/task_repository.dart';
import 'package:proyecto_123/features/tasks/presentation/viewmodels/task_viewmodel.dart';
import 'package:proyecto_123/features/tasks/presentation/views/tasks_view.dart';

void main() {
  // 1. CLIENTE HTTP: Configuración de Clientes para distintas APIs
  final authClient = ApiClient(baseUrl: AppConstants.authBaseUrl);
  final taskClient = ApiClient(baseUrl: AppConstants.tasksBaseUrl);

  // 2. ARQUITECTURA: Inyección de dependencias manual (Screaming Architecture)
  final authRepository = AuthRepository(authClient);
  final taskRepository = TaskRepository(taskClient);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel(authRepository)),
        ChangeNotifierProvider(create: (_) => TaskViewModel(taskRepository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Master Pro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/tasks': (context) => const TasksView(),
      },
    );
  }
}
