import 'package:get/get.dart';
import 'package:rxdart/rxdart.dart';
import 'package:objectbox/objectbox.dart';
import 'package:todo_app/objectbox.dart';
import '../entities/task.dart';

class TaskController extends GetxController {
  // Observable list of tasks using RxDart
  final RxList<Task> tasks = RxList<Task>();

  // Stream controller for tasks
  final BehaviorSubject<List<Task>> _tasksSubject =
      BehaviorSubject<List<Task>>();

  // Getter for the tasks stream
  Stream<List<Task>> get tasksStream => _tasksSubject.stream;

  // Box for ObjectBox operations
  late final Box<Task> _taskBox;

  @override
  void onInit() {
    super.onInit();
    _initializeBox();
    _loadTasks();
  }

  @override
  void onClose() {
    _tasksSubject.close();
    super.onClose();
  }

  void _initializeBox() {
    _taskBox = Db.getBox<Task>();
  }

  // Load all tasks from ObjectBox
  void _loadTasks() {
    final allTasks = _taskBox.getAll();
    tasks.assignAll(allTasks);
    _tasksSubject.add(allTasks);
  }

  // Add a new task
  void addTask(String title, {String description = '', DateTime? dueDate}) {
    if (title.trim().isNotEmpty) {
      final task = Task(
        title: title.trim(),
        description: description.trim(),
        dueDate: dueDate,
      );

      // Save to ObjectBox
      final id = _taskBox.put(task);
      task.id = id;

      // Add to reactive list
      tasks.add(task);
      _tasksSubject.add(tasks.toList());

      Get.snackbar(
        'Succès',
        'Tâche ajoutée avec succès',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Update a task
  void updateTask(Task task) {
    if (task.title.trim().isNotEmpty) {
      // Update in ObjectBox
      _taskBox.put(task);

      // Update in reactive list
      final index = tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        tasks[index] = task;
        _tasksSubject.add(tasks.toList());
      }

      Get.snackbar(
        'Succès',
        'Tâche mise à jour avec succès',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  // Toggle task completion
  void toggleTaskCompletion(int taskId) {
    final task = tasks.firstWhereOrNull((task) => task.id == taskId);
    if (task != null) {
      task.toggleCompletion();
      updateTask(task);
    }
  }

  // Delete a task
  void deleteTask(int taskId) {
    // Remove from ObjectBox
    _taskBox.remove(taskId);

    // Remove from reactive list
    tasks.removeWhere((task) => task.id == taskId);
    _tasksSubject.add(tasks.toList());
  }

  // Get task by ID
  Task? getTaskById(int taskId) {
    return tasks.firstWhereOrNull((task) => task.id == taskId);
  }
}
