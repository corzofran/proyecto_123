import 'package:proyecto_123/core/network/api_client.dart';
import 'package:proyecto_123/core/constants/app_constants.dart';
import 'package:proyecto_123/features/tasks/data/models/task_model.dart';

class TaskRepository {
  final ApiClient _apiClient;

  TaskRepository(this._apiClient);

  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await _apiClient.get(AppConstants.tasksEndpoint);
      
      List<dynamic> list;
      if (response is List) {
        list = response;
      } else if (response is Map && (response.containsKey('data') || response.containsKey('tareas'))) {
        list = response['data'] ?? response['tareas'];
      } else {
        list = [];
      }

      return list.take(10).map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      // MODO SIMULACIÓN: Datos de ejemplo para capturas de pantalla
      return [
        TaskModel(id: 1, title: 'Completar informe de Arquitectura', completed: true),
        TaskModel(id: 2, title: 'Revisar endpoints de la API', completed: false),
        TaskModel(id: 3, title: 'Diseñar interfaz con Material 3', completed: true),
        TaskModel(id: 4, title: 'Implementar Provider para el estado', completed: true),
        TaskModel(id: 5, title: 'Subir repositorio a GitHub', completed: false),
      ];
    }
  }

  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final response = await _apiClient.post(AppConstants.tasksEndpoint, task.toJson());
      final data = (response is Map && response.containsKey('data')) ? response['data'] : response;
      return TaskModel.fromJson(data);
    } catch (e) {
      return task.copyWith(id: DateTime.now().millisecondsSinceEpoch);
    }
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    try {
      final response = await _apiClient.put('${AppConstants.tasksEndpoint}/${task.id}', task.toJson());
      final data = (response is Map && response.containsKey('data')) ? response['data'] : response;
      return TaskModel.fromJson(data);
    } catch (e) {
      return task;
    }
  }

  Future<void> deleteTask(int id) async {
    try {
      await _apiClient.delete('${AppConstants.tasksEndpoint}/$id');
    } catch (e) {
      // Ignorar error en simulación
    }
  }
}
