import 'package:flutter/material.dart';
import 'package:proyecto_123/features/tasks/data/models/task_model.dart';
import 'package:proyecto_123/features/tasks/data/repositories/task_repository.dart';

class TaskViewModel extends ChangeNotifier {
  final TaskRepository _repository;

  TaskViewModel(this._repository);

  List<TaskModel> _tasks = [];
  List<TaskModel> get tasks => _tasks;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTasks() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _tasks = await _repository.getTasks();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(String title) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newTask = TaskModel(title: title);
      final createdTask = await _repository.createTask(newTask);
      _tasks.insert(0, createdTask);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleTaskStatus(TaskModel task) async {
    final updatedTask = task.copyWith(completed: !task.completed);
    
    // Actualización optimista
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
      notifyListeners();
    }

    try {
      await _repository.updateTask(updatedTask);
    } catch (e) {
      // Revertir si falla
      if (index != -1) {
        _tasks[index] = task;
      }
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> deleteTask(int id) async {
    final originalTasks = List<TaskModel>.from(_tasks);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();

    try {
      await _repository.deleteTask(id);
    } catch (e) {
      _tasks = originalTasks;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }
}
