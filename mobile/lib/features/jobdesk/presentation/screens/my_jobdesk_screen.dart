import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/models/leave_request_model.dart';
import '../../../../shared/providers/leave_request_provider.dart';
import '../../data/jobdesk_dummy_data.dart';
import '../../models/jobdesk_models.dart';

/// ============================================================
/// 👤 MY JOB DESK SCREEN - Dashboard Job Desk Karyawan
/// ============================================================
/// Screen utama untuk karyawan melihat:
/// - Progress ring hari ini
/// - List tugas yang harus dikerjakan
/// - Status submission
/// - Riwayat pengisian
/// ============================================================

class MyJobDeskScreen extends ConsumerStatefulWidget {
  const MyJobDeskScreen({super.key});

  @override
  ConsumerState<MyJobDeskScreen> createState() => _MyJobDeskScreenState();
}

class _MyJobDeskScreenState extends ConsumerState<MyJobDeskScreen> {
  late JobDeskTemplate _template;
  late List<JobDeskSubmission> _todaySubmissions;

  @override
  void initState() {
    super.initState();
    // TODO: Get actual user role from auth provider
    _template = JobDeskDummyData.supportOnlineTemplate;
    _todaySubmissions = JobDeskDummyData.getDummySubmissionsForToday(_template);
  }

  // TODO: Get actual user ID from auth provider
  String get _currentUserId => 'emp001';
  
  int get _completedCount => _todaySubmissions.where((s) => s.isCompleted || s.isVerified).length;
  int get _pendingCount => _todaySubmissions.where((s) => s.isPending).length;
  double get _completionRate => _todaySubmissions.isEmpty 
      ? 0 
      : (_completedCount / _todaySubmissions.length) * 100;

  @override
  Widget build(BuildContext context) {
    // Watch for active leave today
    final activeLeave = ref.watch(activeLeaveTodayProvider(_currentUserId));
    final hasActiveLeave = activeLeave != null;

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
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
        },
        color: AppColors.primary,
        child: CustomScrollView(
          slivers: [
            // Show Leave Banner if has active leave
            if (hasActiveLeave)
              SliverToBoxAdapter(
                child: _buildLeaveBanner(activeLeave),
              ),

            // Progress Header (only show if no active leave)
            if (!hasActiveLeave)
              SliverToBoxAdapter(
                child: _buildProgressHeader(),
              ),

            // Filter Chips (only show if no active leave)
            if (!hasActiveLeave)
              SliverToBoxAdapter(
                child: _buildFilterChips(),
              ),

            // Show "No Tasks" message if has active leave
            if (hasActiveLeave)
              SliverToBoxAdapter(
                child: _buildNoTasksMessage(activeLeave),
              )
            else
              // Task List
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final submission = _todaySubmissions[index];
                      return _buildTaskCard(submission);
                    },
                    childCount: _todaySubmissions.length,
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
      // Hide FAB if has active leave
      floatingActionButton: !hasActiveLeave && _pendingCount > 0
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/jobdesk/today'),
              backgroundColor: AppColors.primary,
              icon: const Icon(Icons.edit_note_rounded),
              label: Text('Isi Sekarang ($_pendingCount)'),
            )
          : null,
    );
  }
  
  Widget _buildProgressHeader() {
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
                      value: _completionRate / 100,
                      strokeWidth: 10,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_completionRate.toInt()}%',
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
                    Text(
                      _template.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatRow(
                      icon: Icons.check_circle_outline,
                      label: 'Selesai',
                      value: '$_completedCount/${_todaySubmissions.length}',
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),
                    _buildStatRow(
                      icon: Icons.pending_outlined,
                      label: 'Pending',
                      value: '$_pendingCount',
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
  
  String _filter = 'all'; // all, pending, completed
  
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
  
  Widget _buildTaskCard(JobDeskSubmission submission) {
    final task = submission.taskItem!;
    final isCompleted = submission.isCompleted || submission.isVerified;
    final isPending = submission.isPending;
    final isRejected = submission.isRejected;
    
    // Filter
    if (_filter == 'pending' && !isPending) return const SizedBox.shrink();
    if (_filter == 'completed' && isPending) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: task.isHighlighted ? const Color(0xFFFFF9E6) : AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: task.isHighlighted 
              ? const Color(0xFFFFD93D) 
              : isRejected 
                  ? AppColors.error.withOpacity(0.3)
                  : isCompleted
                      ? AppColors.success.withOpacity(0.3)
                      : AppColors.divider,
        ),
      ),
      child: InkWell(
        onTap: () => _navigateToTaskDetail(submission),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Task Number Badge
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
                  
                  // Task Type Badge
                  if (task.requiresProof)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _getProofIcon(task.proofType),
                            size: 12,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Bukti',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  // Mandatory Badge
                  if (task.isMandatory)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Wajib',
                        style: TextStyle(
                          fontSize: 10,
                          color: AppColors.error,
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
              
              // Task Name
              Text(
                task.taskName,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: isCompleted ? FontWeight.w500 : FontWeight.w700,
                  color: isCompleted ? AppColors.textSecondary : AppColors.textPrimary,
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                ),
              ),
              
              // Description
              if (task.description != null) ...[
                const SizedBox(height: 4),
                Text(
                  task.description!,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
              
              // Target Value
              if (task.type == JobDeskTaskType.counter && task.targetValue != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.flag_outlined,
                      size: 14,
                      color: AppColors.textHint,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Target: ${task.targetValue} ${task.targetUnit ?? ''}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                    if (submission.actualValue != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '• Tercapai: ${submission.actualValue}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              
              // Rejection Reason
              if (isRejected && submission.rejectionReason != null) ...[
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
                          submission.rejectionReason!,
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
    return Text(
      '${_todaySubmissions.indexWhere((s) => s.taskItemId == s.taskItemId) + 1}',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.warning,
      ),
    );
  }
  
  String _getStatusText(bool completed, bool pending, bool rejected) {
    if (rejected) return 'Ditolak';
    if (completed) return 'Selesai';
    return 'Pending';
  }
  
  IconData _getProofIcon(JobDeskProofType? type) {
    switch (type) {
      case JobDeskProofType.photo:
        return Icons.camera_alt_outlined;
      case JobDeskProofType.document:
        return Icons.description_outlined;
      case JobDeskProofType.link:
        return Icons.link_outlined;
      case JobDeskProofType.screenshot:
        return Icons.screenshot_outlined;
      default:
        return Icons.attachment_outlined;
    }
  }
  
  void _navigateToTaskDetail(JobDeskSubmission submission) {
    // Navigate to task submission screen with photo upload
    context.push('/jobdesk/submit/${submission.taskItemId}?submission=${submission.id}');
  }
}
