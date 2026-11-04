import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum TaskPriority { critical, high, medium, low }

enum TaskCategory { aiTech, deepWork, cyberHealth, wealth }

class TaskModel {
  final String id;
  final String title;
  final String description;
  final TaskCategory category;
  final TaskPriority priority;
  final bool isCompleted;
  final int xpReward;
  final DateTime dueDate;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    this.isCompleted = false,
    required this.xpReward,
    required this.dueDate,
  });

  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    TaskCategory? category,
    TaskPriority? priority,
    bool? isCompleted,
    int? xpReward,
    DateTime? dueDate,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
      xpReward: xpReward ?? this.xpReward,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  String get categoryName {
    switch (category) {
      case TaskCategory.aiTech:
        return 'AI & Teknologi';
      case TaskCategory.deepWork:
        return 'Deep Work';
      case TaskCategory.cyberHealth:
        return 'Bio-Health';
      case TaskCategory.wealth:
        return 'Finansial';
    }
  }

  Color get categoryColor {
    switch (category) {
      case TaskCategory.aiTech:
        return AppColors.cyan;
      case TaskCategory.deepWork:
        return AppColors.neonPurple;
      case TaskCategory.cyberHealth:
        return AppColors.neonEmerald;
      case TaskCategory.wealth:
        return AppColors.neonAmber;
    }
  }

  Color get priorityColor {
    switch (priority) {
      case TaskPriority.critical:
        return AppColors.neonPink;
      case TaskPriority.high:
        return AppColors.neonAmber;
      case TaskPriority.medium:
        return AppColors.neonBlue;
      case TaskPriority.low:
        return AppColors.textSecondary;
    }
  }

  String get priorityLabel {
    switch (priority) {
      case TaskPriority.critical:
        return 'KRITIKAL';
      case TaskPriority.high:
        return 'TINGGI';
      case TaskPriority.medium:
        return 'SEDANG';
      case TaskPriority.low:
        return 'RENDAH';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.index,
      'priority': priority.index,
      'isCompleted': isCompleted,
      'xpReward': xpReward,
      'dueDate': dueDate.toIso8601String(),
    };
  }

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: TaskCategory.values[json['category'] as int],
      priority: TaskPriority.values[json['priority'] as int],
      isCompleted: json['isCompleted'] as bool? ?? false,
      xpReward: json['xpReward'] as int? ?? 50,
      dueDate: DateTime.parse(json['dueDate'] as String),
    );
  }
}

