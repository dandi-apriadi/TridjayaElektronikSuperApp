import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/models/user_model.dart';
import '../../core/theme/app_theme.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../shared/dummy_data/dummy_data.dart';
import '../../shared/widgets/stat_card.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  String _selectedStatus = 'Semua';
  final List<String> _statusFilters = ['Semua', 'Pending', 'InProgress', 'Completed'];

  Color _priorityColor(String p) {
    switch (p) {
      case 'Urgent': return AppColors.error;
      case 'High': return AppColors.warning;
      case 'Medium': return AppColors.info;
      default: return AppColors.textSecondary;
    }
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'Completed': return AppColors.success;
      case 'InProgress': return AppColors.info;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final canCreate = user?.role == UserRole.kepalaCabang || user?.role == UserRole.owner;

    var tasks = DummyDataProvider.tasks;
    if (_selectedStatus != 'Semua') {
      tasks = tasks.where((t) => t.status == _selectedStatus).toList();
    }
    tasks = List.from(tasks)..sort((a, b) {
      const order = {'Urgent': 0, 'High': 1, 'Medium': 2, 'Low': 3};
      return (order[a.priority] ?? 4).compareTo(order[b.priority] ?? 4);
    });

    final all = DummyDataProvider.tasks;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: canCreate
          ? FloatingActionButton.extended(
              onPressed: () => _showCreateTaskDialog(context),
              icon: const Icon(Icons.add_task_rounded),
              label: const Text('Buat Tugas'),
              backgroundColor: AppColors.primary,
            )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primary,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: const Text('Manajemen Tugas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
            iconTheme: const IconThemeData(color: Colors.white),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: _buildFilterBar(),
            ),
          ),
        ],
        body: Column(children: [
          _buildSummaryRow(all),
          Expanded(
            child: tasks.isEmpty
                ? _buildEmpty()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _buildTaskCard(context, tasks[i]),
                  ),
          ),
        ]),
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _statusFilters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final f = _statusFilters[i];
            final isSelected = _selectedStatus == f;
            return GestureDetector(
              onTap: () => setState(() => _selectedStatus = f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? Colors.white : Colors.white.withOpacity(0.3)),
                ),
                child: Text(f, style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600,
                  color: isSelected ? AppColors.primary : Colors.white,
                )),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryRow(List<DummyTask> all) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(children: [
        Expanded(child: StatCard(title: 'Total', value: '${all.length}', icon: Icons.list_alt_rounded, color: AppColors.primary)),
        const SizedBox(width: 8),
        Expanded(child: StatCard(title: 'Pending', value: '${all.where((t) => t.status == 'Pending').length}', icon: Icons.pending_outlined, color: AppColors.warning)),
        const SizedBox(width: 8),
        Expanded(child: StatCard(title: 'Selesai', value: '${all.where((t) => t.status == 'Completed').length}', icon: Icons.check_circle_outline, color: AppColors.success)),
      ]),
    );
  }

  Widget _buildTaskCard(BuildContext context, DummyTask task) {
    final isOverdue = task.dueDate.isBefore(DateTime.now()) && task.status != 'Completed';
    final pColor = _priorityColor(task.priority);
    final sColor = _statusColor(task.status);
    return GestureDetector(
      onTap: () => _showTaskDetail(context, task),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppShadows.sm,
          border: Border.all(color: isOverdue ? AppColors.error.withOpacity(0.25) : AppColors.divider),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 4, height: 40, decoration: BoxDecoration(color: pColor, borderRadius: BorderRadius.circular(2))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(task.title, style: AppTextStyles.bodyMedium),
              const SizedBox(height: 2),
              Row(children: [
                const Icon(Icons.person_outline_rounded, size: 12, color: AppColors.textHint),
                const SizedBox(width: 3),
                Text(task.assignee, style: AppTextStyles.caption),
              ]),
            ])),
            StatusBadge(label: task.status, color: sColor),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: pColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: Text(task.priority, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: pColor)),
            ),
            const SizedBox(width: 8),
            Icon(isOverdue ? Icons.warning_amber_rounded : Icons.access_time_rounded,
                size: 13, color: isOverdue ? AppColors.error : AppColors.textHint),
            const SizedBox(width: 4),
            Text(_formatDue(task.dueDate),
                style: AppTextStyles.caption.copyWith(
                  color: isOverdue ? AppColors.error : AppColors.textSecondary,
                  fontWeight: isOverdue ? FontWeight.w600 : FontWeight.w400,
                )),
            const Spacer(),
            if (task.status != 'Completed')
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Status diperbarui'), behavior: SnackBarBehavior.floating)),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    task.status == 'Pending' ? 'Mulai' : 'Selesai',
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                  ),
                ),
              ),
          ]),
        ]),
      ),
    );
  }

  String _formatDue(DateTime dt) {
    final diff = dt.difference(DateTime.now());
    if (diff.isNegative) return 'Lewat ${-diff.inHours}j yang lalu';
    if (diff.inHours < 1) return 'Dalam ${diff.inMinutes}m';
    if (diff.inHours < 24) return 'Dalam ${diff.inHours}j';
    return 'Dalam ${diff.inDays}h';
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(color: AppColors.surfaceVariant, shape: BoxShape.circle),
          child: const Icon(Icons.task_alt_rounded, size: 36, color: AppColors.textHint),
        ),
        const SizedBox(height: 16),
        Text('Tidak ada tugas', style: AppTextStyles.subtitle),
        const SizedBox(height: 4),
        Text('Filter: $_selectedStatus', style: AppTextStyles.caption),
      ]),
    );
  }

  void _showTaskDetail(BuildContext context, DummyTask task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: _priorityColor(task.priority).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(task.priority, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _priorityColor(task.priority))),
              ),
              const SizedBox(width: 8),
              StatusBadge(label: task.status, color: _statusColor(task.status)),
            ]),
            const SizedBox(height: 14),
            Text(task.title, style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
              child: Column(children: [
                _detailRow(Icons.person_outline_rounded, 'Assignee', task.assignee),
                const Divider(height: 16),
                _detailRow(Icons.access_time_outlined, 'Tenggat', _formatDue(task.dueDate)),
              ]),
            ),
            const SizedBox(height: 20),
            Text('Bukti Penyelesaian', style: AppTextStyles.subtitle),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih foto — Coming Soon'), behavior: SnackBarBehavior.floating)),
              child: Container(
                height: 90, width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, style: BorderStyle.solid),
                ),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.add_photo_alternate_outlined, color: AppColors.textHint, size: 28),
                  const SizedBox(height: 6),
                  Text('Lampirkan Foto Bukti', style: AppTextStyles.caption),
                ]),
              ),
            ),
            const SizedBox(height: 24),
            if (task.status != 'Completed')
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Tugas ditandai selesai'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating));
                },
                icon: const Icon(Icons.check_rounded),
                label: const Text('Tandai Selesai'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
              ),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textHint),
          const SizedBox(width: 8),
          Text('$label: ', style: AppTextStyles.caption),
          Text(value, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  void _showCreateTaskDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Buat Tugas Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Judul Tugas')),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Prioritas'),
                value: 'Medium',
                items: ['Low', 'Medium', 'High', 'Urgent']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Assignee'),
                value: DummyDataProvider.employees.first.name,
                items: DummyDataProvider.employees
                    .map((e) => DropdownMenuItem(value: e.name, child: Text(e.name)))
                    .toList(),
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tugas berhasil dibuat'), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
            },
            child: const Text('Buat'),
          ),
        ],
      ),
    );
  }
}
