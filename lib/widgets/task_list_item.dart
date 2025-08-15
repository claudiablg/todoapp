import 'package:flutter/material.dart';
import '../entities/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (_) => onToggle(),
                activeColor: Colors.green,
              ),
              const SizedBox(width: 4),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task.isCompleted ? Colors.grey : Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    if (task.description.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          task.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    Text(
                      'Créée le ${_formatDate(task.dateCreated)}',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),

                    if (task.dueDate != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 12,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Échéance: ${_formatDate(task.dueDate!)}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                    if (task.isCompleted && task.completedAt != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 12,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Complétée le ${_formatDate(task.completedAt!)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: onEdit,
                    tooltip: 'Modifier',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[100],
                      shape: const CircleBorder(),
                    ),
                  ),
                  const SizedBox(height: 4),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 20, color: Colors.red),
                    onPressed: onDelete,
                    tooltip: 'Supprimer',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      shape: const CircleBorder(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) {
      return 'Aujourd\'hui à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (taskDate == today.subtract(const Duration(days: 1))) {
      return 'Hier à ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    }
  }
}
