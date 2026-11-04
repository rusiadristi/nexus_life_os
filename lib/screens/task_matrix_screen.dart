import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../theme/app_colors.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../providers/user_profile_provider.dart';
import '../widgets/cyber_card.dart';
import '../widgets/cyber_button.dart';

class TaskMatrixScreen extends StatelessWidget {
  const TaskMatrixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProv = context.watch<TaskProvider>();
    final profile = context.watch<UserProfileProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Daftar Tugas & Prioritas',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.cyan.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.bolt, color: AppColors.cyan, size: 15),
                const SizedBox(width: 4),
                Text(
                  '${profile.currentXp} Poin',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.cyan,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Status & Filter Tabs
            _buildFilters(taskProv),

            // Category Bar
            _buildCategoryChips(taskProv),

            // Task List
            Expanded(
              child: taskProv.tasks.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      itemCount: taskProv.tasks.length,
                      itemBuilder: (context, index) {
                        final task = taskProv.tasks[index];
                        return _buildTaskItem(context, task, taskProv, profile);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.cyan,
        foregroundColor: Colors.white,
        elevation: 2,
        icon: const Icon(Icons.add, size: 20),
        label: Text(
          'Tambah Tugas',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () => _showAddTaskSheet(context, taskProv),
      ),
    );
  }

  Widget _buildFilters(TaskProvider taskProv) {
    final filters = [
      {'id': 'all', 'label': 'Semua (${taskProv.allTasks.length})'},
      {'id': 'active', 'label': 'Aktif (${taskProv.activeCount})'},
      {'id': 'completed', 'label': 'Selesai (${taskProv.completedCount})'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: filters.map((f) {
          final isSelected = taskProv.filter == f['id'];
          return Expanded(
            child: GestureDetector(
              onTap: () => taskProv.setStatusFilter(f['id'] as String),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.cyan.withOpacity(0.12) : AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.cyan.withOpacity(0.5) : AppColors.cardBorder,
                  ),
                ),
                child: Center(
                  child: Text(
                    f['label'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? AppColors.cyan : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCategoryChips(TaskProvider taskProv) {
    return Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildChip(
            label: 'Semua Kategori',
            isSelected: taskProv.selectedCategory == null,
            onTap: () => taskProv.setCategoryFilter(null),
          ),
          ...TaskCategory.values.map((cat) {
            return _buildChip(
              label: _getCategoryLabel(cat),
              isSelected: taskProv.selectedCategory == cat,
              onTap: () => taskProv.setCategoryFilter(cat),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip({required String label, required bool isSelected, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ),
        ),
        selected: isSelected,
        selectedColor: AppColors.cyan,
        backgroundColor: AppColors.surface,
        side: BorderSide(color: isSelected ? AppColors.cyan : AppColors.cardBorder),
        onSelected: (_) => onTap(),
      ),
    );
  }

  String _getCategoryLabel(TaskCategory cat) {
    switch (cat) {
      case TaskCategory.aiTech:
        return 'Teknologi & AI';
      case TaskCategory.deepWork:
        return 'Deep Work';
      case TaskCategory.cyberHealth:
        return 'Kesehatan & Pola Hidup';
      case TaskCategory.wealth:
        return 'Finansial';
    }
  }

  Widget _buildTaskItem(
    BuildContext context,
    TaskModel task,
    TaskProvider taskProv,
    UserProfileProvider profile,
  ) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.neonRed.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.neonRed.withOpacity(0.3)),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: AppColors.neonRed, size: 24),
      ),
      onDismissed: (_) {
        taskProv.deleteTask(task.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.surface,
            content: Text(
              'Tugas telah dihapus.',
              style: GoogleFonts.plusJakartaSans(color: AppColors.textPrimary),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: CyberCard(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Checkbox(
                value: task.isCompleted,
                activeColor: AppColors.cyan,
                checkColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                onChanged: (_) {
                  taskProv.toggleTask(task.id, (xp) {
                    profile.addXp(xp);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: AppColors.surfaceLight,
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppColors.neonEmerald),
                            const SizedBox(width: 8),
                            Text(
                              '+$xp Poin berhasil diperoleh!',
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  });
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: task.isCompleted ? AppColors.textMuted : AppColors.textPrimary,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      task.description,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: task.categoryColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            task.categoryName,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: task.categoryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: task.priorityColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            task.priorityLabel,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: task.priorityColor,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '+${task.xpReward} Poin',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppColors.cyan,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline_rounded, size: 54, color: AppColors.textMuted.withOpacity(0.4)),
          const SizedBox(height: 14),
          Text(
            'Tidak ada tugas pada filter ini',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tekan tombol + untuk menambahkan tugas baru',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaskSheet(BuildContext context, TaskProvider taskProv) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    TaskCategory selectedCat = TaskCategory.aiTech;
    TaskPriority selectedPrio = TaskPriority.high;
    int xp = 100;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 18,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.cardBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Buat Tugas Baru',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(
                        labelText: 'Judul Tugas',
                        hintText: 'Contoh: Rancang strategi peluncuran produk',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descController,
                      style: const TextStyle(color: AppColors.textPrimary),
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Keterangan Tambahan',
                        hintText: 'Tentukan target pencapaian spesifik...',
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Kategori',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: TaskCategory.values.map((cat) {
                        final isSel = selectedCat == cat;
                        return ChoiceChip(
                          label: Text(_getCategoryLabel(cat)),
                          selected: isSel,
                          selectedColor: AppColors.cyan,
                          labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.textPrimary),
                          onSelected: (_) => setModalState(() => selectedCat = cat),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Prioritas',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: TaskPriority.values.map((prio) {
                        final isSel = selectedPrio == prio;
                        return ChoiceChip(
                          label: Text(prio.name.toUpperCase()),
                          selected: isSel,
                          selectedColor: AppColors.cyan,
                          labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.textPrimary),
                          onSelected: (_) => setModalState(() => selectedPrio = prio),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 18),
                    CyberButton(
                      text: 'Simpan Tugas',
                      isFullWidth: true,
                      onPressed: () {
                        if (titleController.text.trim().isEmpty) return;
                        taskProv.addTask(
                          title: titleController.text.trim(),
                          description: descController.text.trim().isEmpty
                              ? 'Tugas penting untuk diselesaikan.'
                              : descController.text.trim(),
                          category: selectedCat,
                          priority: selectedPrio,
                          xpReward: xp,
                          dueDate: DateTime.now().add(const Duration(hours: 12)),
                        );
                        Navigator.pop(ctx);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
