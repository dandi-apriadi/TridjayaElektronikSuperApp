import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/leave_request_model.dart';
import '../../../../shared/providers/leave_request_provider.dart';
import '../../models/jobdesk_models.dart';
import '../providers/jobdesk_provider.dart';

/// ============================================================
/// 👤 MY JOB DESK SCREEN - Dashboard Job Desk Karyawan
/// ============================================================

class MyJobDeskScreen extends ConsumerStatefulWidget {
  const MyJobDeskScreen({super.key});

  @override
  ConsumerState<MyJobDeskScreen> createState() => _MyJobDeskScreenState();
}

class _MyJobDeskScreenState extends ConsumerState<MyJobDeskScreen> {
  String _filter = 'all'; // all, pending, completed

  @override
  Widget build(BuildContext context) {
    final assignmentsAsync = ref.watch(myJobdeskAssignmentsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Job Desk Saya',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.white),
            onPressed: () => context.push('/jobdesk/history'),
            tooltip: 'Riwayat',
          ),
        ],
      ),
      body: assignmentsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (assignments) {
          return _buildBody(assignments);
        },
      ),
    );
  }

  Widget _buildBody(List<JobDeskAssignment> assignments) {
    // Watch for active leave today (using first assignment userId or dummy)
    final currentUserId = assignments.isNotEmpty ? assignments.first.userId : 'emp001';
    final activeLeave = ref.watch(activeLeaveTodayProvider(currentUserId));
    final hasActiveLeave = activeLeave != null;

    final filteredAssignments = _applyFilter(assignments);
    final completedCount = assignments.where((a) => a.isCompleted).length;
    final pendingCount = assignments.where((a) => a.isPending).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myJobdeskAssignmentsProvider);
        },
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            // Show Leave Banner if has active leave
            if (hasActiveLeave)
              SliverToBoxAdapter(
                child: _buildLeaveBanner(activeLeave!),
              ),

            // Progress Header (only show if no active leave)
            if (!hasActiveLeave)
              SliverToBoxAdapter(
                child: _buildProgressHeader(assignments),
              ),

            // Filter Chips (only show if no active leave)
            if (!hasActiveLeave)
              SliverToBoxAdapter(
                child: _buildFilterChips(),
              ),

            // Show "No Tasks" message if has active leave
            if (hasActiveLeave)
              SliverToBoxAdapter(
                child: _buildNoTasksMessage(activeLeave!),
              )
            else if (filteredAssignments.isEmpty)
              SliverToBoxAdapter(
                child: _buildEmptyState(),
              )
            else
              // Task List
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final assignment = filteredAssignments[index];
                      return _buildTaskCard(assignment);
                    },
                    childCount: filteredAssignments.length,
                  ),
                ),
              ),

            // Bottom spacing
            const SliverToBoxAdapter(
              child: SizedBox(height: 100),
            ),
          ],
        ),
      ),
      floatingActionButton: !hasActiveLeave && pendingCount > 0
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/jobdesk/today'),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.edit_note_rounded),
              label: Text('Isi Sekarang ($pendingCount)'),
            )
          : null,
    );
  }

  List<JobDeskAssignment> _applyFilter(List<JobDeskAssignment> assignments) {
    if (_filter == 'pending') {
      return assignments.where((a) => a.isPending).toList();
    }
    if (_filter == 'completed') {
      return assignments.where((a) => a.isCompleted).toList();
    }
    return assignments;
  }
  
  Widget _buildProgressHeader(List<JobDeskAssignment> assignments) {
    final completedCount = assignments.where((a) => a.isCompleted).length;
    final pendingCount = assignments.where((a) => a.isPending).length;
    final completionRate = assignments.isEmpty
        ? 0.0
        : (completedCount / assignments.length) * 100;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Progress Ring
          Row(
            children: [
              // Circular Progress
              SizedBox(
                width: 100,
                height: 100,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: completionRate / 100,
                      strokeWidth: 10,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${completionRate.toInt()}%',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Selesai',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 20),
              
              // Stats
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Job Desk Hari Ini',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatRow(
                      icon: Icons.check_circle_outline,
                      label: 'Selesai',
                      value: '$completedCount/${assignments.length}',
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),
                    _buildStatRow(
                      icon: Icons.pending_outlined,
                      label: 'Pending',
                      value: '$pendingCount',
                      color: Colors.white70,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Streak Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_fire_department_rounded, color: Colors.orange, size: 20),
                SizedBox(width: 8),
                Text(
                  'Streak 5 Hari! 🔥',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 13,
            color: color.withOpacity(0.8),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          _buildFilterChip('Semua', 'all'),
          const SizedBox(width: 8),
          _buildFilterChip('Pending', 'pending'),
          const SizedBox(width: 8),
          _buildFilterChip('Selesai', 'completed'),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip(String label, String value) {
    final isSelected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  /// Build leave banner when user has approved leave today
  Widget _buildLeaveBanner(LeaveRequest leave) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: leave.type.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: leave.type.color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: leave.type.color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getLeaveIcon(leave.type),
              color: leave.type.color,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Izin ${leave.type.displayName} Aktif',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: leave.type.color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${leave.startDate.day}/${leave.startDate.month}/${leave.startDate.year} - '
                  '${leave.endDate.day}/${leave.endDate.month}/${leave.endDate.year}',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (leave.reason != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Alasan: ${leave.reason}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build no tasks message when user has approved leave
  Widget _buildNoTasksMessage(LeaveRequest leave) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: leave.type.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.beach_access,
              size: 64,
              color: leave.type.color,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Libur Hari Ini 🎉',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pengajuan ${leave.type.displayName} Anda telah disetujui oleh ${leave.approverName}.\n'
            'Tidak perlu melakukan Job Desk hari ini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, size: 16, color: AppColors.success),
                const SizedBox(width: 6),
                Text(
                  'Disetujui',
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getLeaveIcon(LeaveType type) {
    switch (type) {
      case LeaveType.off:
        return Icons.weekend;
      case LeaveType.sakit:
        return Icons.local_hospital;
      case LeaveType.izin:
        return Icons.assignment_ind;
      case LeaveType.cuti:
        return Icons.beach_access;
    }
  }
  
  Widget _buildTaskCard(JobDeskAssignment assignment) {
    final isCompleted = assignment.isCompleted;
    final isPending = assignment.isPending;
    final isRejected = assignment.isRejected;
    final isUrgent = assignment.priority == 'urgent' || assignment.priority == 'high';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isUrgent ? const Color(0xFFFFF9E6) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUrgent
              ? const Color(0xFFFFD93D)
              : isRejected
                  ? AppColors.error.withOpacity(0.3)
                  : isCompleted
                      ? AppColors.success.withOpacity(0.3)
                      : AppColors.divider,
        ),
      ),
      child: InkWell(
        onTap: () => _navigateToTaskDetail(assignment),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Status Badge Circle
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: _getStatusColor(isCompleted, isPending, isRejected).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: _getStatusIcon(isCompleted, isPending, isRejected),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Attachment Badge
                  if (assignment.hasAttachments)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.attachment_outlined,
                            size: 12,
                            color: AppColors.info,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Attachment',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.info,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Priority Badge
                  if (assignment.priority != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _priorityColor(assignment.priority!).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _capitalize(assignment.priority!),
                        style: TextStyle(
                          fontSize: 10,
                          color: _priorityColor(assignment.priority!),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  const Spacer(),

                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(isCompleted, isPending, isRejected).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _getStatusText(isCompleted, isPending, isRejected),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(isCompleted, isPending, isRejected),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Task Title
              Text(
                assignment.title ?? 'Tugas',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isCompleted ? FontWeight.w500 : FontWeight.w700,
                  color: isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),

              // Description
              if (assignment.description != null && assignment.description!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  assignment.description!,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],

              // Due Date
              if (assignment.dueDate != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Deadline: ${_formatDate(assignment.dueDate!)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ],

              // Rejection Reason
              if (isRejected && assignment.rejectionReason != null) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 14,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          assignment.rejectionReason!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Color _getStatusColor(bool completed, bool pending, bool rejected) {
    if (rejected) return AppColors.error;
    if (completed) return AppColors.success;
    return AppColors.warning;
  }
  
  Widget _getStatusIcon(bool completed, bool pending, bool rejected) {
    if (rejected) {
      return Icon(Icons.close, size: 14, color: AppColors.error);
    }
    if (completed) {
      return Icon(Icons.check, size: 14, color: AppColors.success);
    }
    return Icon(Icons.circle_outlined, size: 14, color: AppColors.warning);
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent': return AppColors.error;
      case 'high': return AppColors.warning;
      case 'normal': return AppColors.info;
      default: return AppColors.textHint;
    }
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
  
  String _getStatusText(bool completed, bool pending, bool rejected) {
    if (rejected) return 'Ditolak';
    if (completed) return 'Selesai';
    return 'Pending';
  }
  
  
  void _navigateToTaskDetail(JobDeskAssignment assignment) {
    // Navigate to task submission screen
    context.push('/jobdesk/submit/${assignment.id}');
  }

  Widget _buildEmptyState() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.task_alt_outlined,
            size: 64,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak ada tugas',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Semua tugas sudah selesai atau tidak ada job desk untuk hari ini.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
