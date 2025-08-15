import 'package:objectbox/objectbox.dart';

@Entity()
class Task {
  @Id()
  int id;

  String title;
  String description;
  DateTime dateCreated;
  DateTime? dueDate;
  bool isCompleted;
  DateTime? completedAt;

  Task({
    this.id = 0,
    required this.title,
    this.description = '',
    DateTime? dateCreated,
    this.dueDate,
    this.isCompleted = false,
    this.completedAt,
  }) : dateCreated = dateCreated ?? DateTime.now();

  Task.create({
    this.id = 0,
    required this.title,
    this.description = '',
    required this.dueDate,
    DateTime? dateCreated,
    this.isCompleted = false,
    this.completedAt,
  }) : dateCreated = dateCreated ?? DateTime.now();

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? dueDate,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  void toggleCompletion() {
    isCompleted = !isCompleted;
    completedAt = isCompleted ? DateTime.now() : null;
  }
}
