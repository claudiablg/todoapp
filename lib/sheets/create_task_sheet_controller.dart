import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:todo_app/entities/task.dart';
import 'package:todo_app/objectbox.dart';
import 'package:todo_app/pages/task_controller.dart';

class CreateTaskSheetController extends GetxController {
  late final RxString name;
  late final int id;
  late final bool isEditing;
  final Task? initialTask;
  final nameAlreadyUsed = ValueNotifier(false);
  final tasks = Db.getBox<Task>().getAll();

  CreateTaskSheetController({this.initialTask}) {
    final i = initialTask;
    inspect(i);
    id = i?.id ?? 0;
    name = (i?.title ?? '').obs;
    isEditing = i != null;
  }

  void onTextChange(String text) {
    name.value = text;
    nameAlreadyUsed.value = tasks
        .where((f) => f.id != initialTask?.id)
        .any((f) => f.title.toLowerCase() == text.toLowerCase().trim());
  }

  void submitTask() {
    if (nameAlreadyUsed.value) {
      return;
    }

    final taskController = Get.find<TaskController>();

    if (isEditing && initialTask != null) {
      // Update existing task
      final updatedTask = initialTask!.copyWith(title: name.value);
      taskController.updateTask(updatedTask);
    } else {
      // Create new task
      taskController.addTask(name.value);
    }

    Get.back();
  }

  void closeSheet() {
    Get.back();
  }
}
