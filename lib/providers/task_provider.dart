import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  final _uuid = const Uuid();

  List<TaskModel> _tasks = [];
  TaskCategory? _selectedCategory;
  String _filter = 'all'; // 'all', 'active', 'completed'

  TaskProvider() {
    _initializeDefaultTasks();
  }

  List<TaskModel> get tasks {
    return _tasks.where((task) {
      if (_selectedCategory != null && task.category != _selectedCategory) {
        return false;
      }
      if (_filter == 'active' && task.isCompleted) return false;
      if (_filter == 'completed' && !task.isCompleted) return false;
      return true;
    }).toList();
  }

  List<TaskModel> get allTasks => _tasks;
  TaskCategory? get selectedCategory => _selectedCategory;
  String get filter => _filter;

  int get completedCount => _tasks.where((t) => t.isCompleted).length;
  int get activeCount => _tasks.where((t) => !t.isCompleted).length;
  double get completionRate => _tasks.isEmpty ? 0 : completedCount / _tasks.length;

  void _initializeDefaultTasks() {
    _tasks = [
      TaskModel(
        id: _uuid.v4(),
        title: 'Review Rencana Strategis Kuartal Depan',
        description: 'Tinjau roadmap pencapaian target, alokasi sumber daya, dan mitigasi risiko.',
        category: TaskCategory.deepWork,
        priority: TaskPriority.critical,
        isCompleted: true,
        xpReward: 120,
        dueDate: DateTime.now().add(const Duration(hours: 2)),
      ),
      TaskModel(
        id: _uuid.v4(),
        title: 'Sesi Deep Work: Analisis Model & Data',
        description: 'Fokus intensif 90 menit tanpa interupsi untuk penyelesaian laporan evaluasi.',
        category: TaskCategory.deepWork,
        priority: TaskPriority.high,
        isCompleted: false,
        xpReward: 150,
        dueDate: DateTime.now().add(const Duration(hours: 4)),
      ),
      TaskModel(
        id: _uuid.v4(),
        title: 'Penyesuaian Alokasi Portofolio Finansial',
        description: 'Evaluasi kinerja aset reksa dana, saham teknologi, dan cadangan likuiditas kas.',
        category: TaskCategory.wealth,
        priority: TaskPriority.high,
        isCompleted: false,
        xpReward: 90,
        dueDate: DateTime.now().add(const Duration(hours: 7)),
      ),
      TaskModel(
        id: _uuid.v4(),
        title: 'Jalan Santai & Peregangan 20 Menit',
        description: 'Istirahatkan mata dari layar gawai dan pulihkan sirkulasi tubuh.',
        category: TaskCategory.cyberHealth,
        priority: TaskPriority.medium,
        isCompleted: false,
        xpReward: 75,
        dueDate: DateTime.now().add(const Duration(hours: 10)),
      ),
      TaskModel(
        id: _uuid.v4(),
        title: 'Riset Perkembangan Arsitektur Software Terbaru',
        description: 'Pelajari praktik terbaik otomatisasi sistem dan efisiensi performa aplikasi.',
        category: TaskCategory.aiTech,
        priority: TaskPriority.medium,
        isCompleted: false,
        xpReward: 100,
        dueDate: DateTime.now().add(const Duration(days: 1)),
      ),
    ];
  }

  void toggleTask(String id, Function(int xp)? onXpEarned) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      final task = _tasks[index];
      final newStatus = !task.isCompleted;
      _tasks[index] = task.copyWith(isCompleted: newStatus);

      if (newStatus && onXpEarned != null) {
        onXpEarned(task.xpReward);
      }
      notifyListeners();
    }
  }

  void addTask({
    required String title,
    required String description,
    required TaskCategory category,
    required TaskPriority priority,
    required int xpReward,
    required DateTime dueDate,
  }) {
    final newTask = TaskModel(
      id: _uuid.v4(),
      title: title,
      description: description,
      category: category,
      priority: priority,
      xpReward: xpReward,
      dueDate: dueDate,
    );
    _tasks.insert(0, newTask);
    notifyListeners();
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }

  void setCategoryFilter(TaskCategory? category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setStatusFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }
}
