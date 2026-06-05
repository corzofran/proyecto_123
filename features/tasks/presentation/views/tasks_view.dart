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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskViewModel>().fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final taskViewModel = context.watch<TaskViewModel>();
    final authViewModel = context.read<AuthViewModel>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: RefreshIndicator(
        onRefresh: () => taskViewModel.fetchTasks(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              expandedHeight: 150,
              backgroundColor: colorScheme.surface,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Mis Tareas',
                  style: TextStyle(color: colorScheme.onSurface, fontWeight: FontWeight.bold),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colorScheme.primaryContainer.withOpacity(0.4),
                        colorScheme.surface,
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    authViewModel.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  icon: Icon(Icons.logout_rounded, color: colorScheme.primary),
                ),
              ],
            ),
            // Resumen de tareas para las capturas
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    _buildStatCard(
                      context, 
                      'Pendientes', 
                      '${taskViewModel.tasks.where((t) => !t.completed).length}',
                      colorScheme.tertiaryContainer,
                      colorScheme.onTertiaryContainer,
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      context, 
                      'Completadas', 
                      '${taskViewModel.tasks.where((t) => t.completed).length}',
                      colorScheme.primaryContainer,
                      colorScheme.onPrimaryContainer,
                    ),
                  ],
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
              ),
            ),
            if (taskViewModel.isLoading && taskViewModel.tasks.isEmpty)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
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
                      );
                    },
                    childCount: taskViewModel.tasks.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {}, // Simulado para capturas
        label: const Text('Nueva Tarea'),
        icon: const Icon(Icons.add_rounded),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ).animate().scale(delay: 400.ms),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String count, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(count, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
            Text(title, style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }
}
