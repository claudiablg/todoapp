import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/pages/task_controller.dart';
import 'package:todo_app/sheets/create_task_sheet.dart';
import 'package:todo_app/sheets/create_task_sheet_controller.dart';
import 'package:todo_app/widgets/task_list_item.dart';
import 'package:todo_app/entities/task.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskController>(
      init: TaskController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(title: const Text('Mes Tâches')),
          body: SafeArea(
            child: Column(
              children: [
                // Tasks list
                Expanded(
                  child: Obx(() {
                    if (controller.tasks.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: controller.tasks.length,
                      itemBuilder: (context, index) {
                        final task = controller.tasks[index];
                        return TaskListItem(
                          task: task,
                          onToggle: () =>
                              controller.toggleTaskCompletion(task.id),
                          onDelete: () =>
                              _showDeleteDialog(context, controller, task),
                          onEdit: () =>
                              _showEditTaskSheet(context, controller, task),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () => _showCreateTaskSheet(context, controller),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task_alt, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Aucune tâche pour le moment',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Appuyez sur le bouton + pour ajouter une tâche',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _showCreateTaskSheet(BuildContext context, TaskController controller) {
    // Initialize the CreateTaskSheet controller with no initial task
    Get.put(CreateTaskSheetController(initialTask: null));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateTaskSheet(),
    ).then((_) {
      // Clean up the controller when sheet is closed
      Get.delete<CreateTaskSheetController>();
    });
  }

  void _showEditTaskSheet(
    BuildContext context,
    TaskController controller,
    Task task,
  ) {
    // Initialize the CreateTaskSheet controller with the task to edit
    Get.put(CreateTaskSheetController(initialTask: task));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateTaskSheet(),
    ).then((_) {
      // Clean up the controller when sheet is closed
      Get.delete<CreateTaskSheetController>();
    });
  }

  void _showDeleteDialog(
    BuildContext context,
    TaskController controller,
    Task task,
  ) {
    Get.dialog(
      AlertDialog(
        title: const Text('Supprimer la tâche'),
        content: Text('Êtes-vous sûr de vouloir supprimer "${task.title}" ?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              controller.deleteTask(task.id);
              Get.back();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
