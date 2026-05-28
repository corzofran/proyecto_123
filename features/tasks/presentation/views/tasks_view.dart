import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto_123/features/auth/presentation/viewmodels/auth_viewmodel.dart';
import 'package:proyecto_123/features/tasks/presentation/viewmodels/task_viewmodel.dart';
import 'package:proyecto_123/features/tasks/presentation/widgets/task_item.dart';
import 'package:flutter_animate/flutter_animate.dart';

class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  @override
  void initState() {
    super.initState();
    // Ejecutar después del primer frame para evitar errores de BuildContext
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskViewModel>().fetchTasks();
    });
  }

  void _showAddTaskDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Tarea'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: '¿Qué tienes pendiente?',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<TaskViewModel>().addTask(controller.text);
                Navigator.pop(context);
              }
            },
            child: const Text('Añadir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.watch<TaskViewModel>();
    final authViewModel = context.read<AuthViewModel>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => taskViewModel.fetchTasks(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              title: const Text('Mis Tareas'),
              subtitle: Text('Bienvenido, ${authViewModel.user?.name ?? "Usuario"}'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () {
                    authViewModel.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
            if (taskViewModel.isLoading && taskViewModel.tasks.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (taskViewModel.errorMessage != null && taskViewModel.tasks.isEmpty)
              SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Error: ${taskViewModel.errorMessage}'),
                      ElevatedButton(
                        onPressed: () => taskViewModel.fetchTasks(),
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final task = taskViewModel.tasks[index];
                      return TaskItem(
                        task: task,
                        onToggle: (_) => taskViewModel.toggleTaskStatus(task),
                        onDelete: () => taskViewModel.deleteTask(task.id!),
                      ).animate().fadeIn(delay: (index * 50).ms).slideY(begin: 0.1);
                    },
                    childCount: taskViewModel.tasks.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskDialog,
        label: const Text('Nueva Tarea'),
        icon: const Icon(Icons.add_task),
      ),
    );
  }
}
