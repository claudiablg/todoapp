import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/sheets/create_task_sheet_controller.dart';

class CreateTaskSheet extends GetView<CreateTaskSheetController> {
  const CreateTaskSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateTaskSheetController>(
      builder: (controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header avec titre et bouton fermer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    controller.isEditing
                        ? 'Modifier la tâche'
                        : 'Ajouter une tâche',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: controller.closeSheet,
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Formulaire
              Form(
                child: TextFormField(
                  controller: TextEditingController(
                    text: controller.name.value,
                  ),
                  onChanged: controller.onTextChange,
                  decoration: InputDecoration(
                    labelText: 'Titre de la tâche',
                    hintText: 'Entrez le titre de votre tâche...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  maxLines: 3,
                  minLines: 1,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Le titre ne peut pas être vide';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => controller.submitTask(),
                ),
              ),
              const SizedBox(height: 24),

              // Bouton d'action
              ElevatedButton(
                onPressed: controller.submitTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  controller.isEditing ? 'Modifier' : 'Ajouter',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
