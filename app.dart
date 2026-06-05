import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'core/network/api_client.dart';
import 'shared/theme/app_theme.dart';
import 'shared/theme/util.dart';

import 'features/auth/data/repositories/auth_repository.dart';
import 'features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'features/auth/presentation/views/login_view.dart';
import 'features/auth/presentation/views/register_view.dart';
import 'features/tasks/data/repositories/task_repository.dart';
import 'features/tasks/presentation/viewmodels/task_viewmodel.dart';
import 'features/tasks/presentation/views/tasks_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // Usamos las utilidades de tu carpeta shared
    final textTheme = createTextTheme(context, "Roboto", "Roboto");
    final theme = MaterialTheme(textTheme);

    // Inyección de dependencias con las APIs de simulación para tus capturas
    final authApiClient = ApiClient(baseUrl: AppConstants.authBaseUrl);
    final taskApiClient = ApiClient(baseUrl: AppConstants.tasksBaseUrl);
    
    final authRepository = AuthRepository(authApiClient);
    final taskRepository = TaskRepository(taskApiClient);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(authRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => TaskViewModel(taskRepository),
        ),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        theme: theme.light(),
        darkTheme: theme.dark(),
        themeMode: ThemeMode.system,
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginView(),
          '/register': (context) => const RegisterView(),
          '/tasks': (context) => const TasksView(),
        },
      ),
    );
  }
}
