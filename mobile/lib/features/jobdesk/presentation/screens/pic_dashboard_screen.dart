import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/jobdesk_scoring_dummy_data.dart';
import '../../models/jobdesk_scoring_models.dart';

/// ============================================================
/// 👔 PIC DASHBOARD SCREEN - Verification & Scoring
/// ============================================================
/// Dashboard khusus PIC untuk:
/// - Melihat semua submission dengan prioritas
/// - Review foto satu per satu
/// - Memberikan nilai
/// - Melihat recap harian
/// - Manage cutoff time
/// ============================================================

class PicDashboardScreen extends ConsumerStatefulWidget {
  const PicDashboardScreen({super.key});

  @override
  ConsumerState<PicDashboardScreen> createState() => _PicDashboardScreenState();
}

class _PicDashboardScreenState extends ConsumerState<PicDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedDate = 'Hari Ini';
  String _priorityFilter = 'all';
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final queue = JobDeskScoringDummyData.getVerificationQueue();
    final recap = JobDeskScoringDummyData.getDailyRecap(DateTime.now());
    
    final urgentCount = queue.where((q) => q.priority == VerificationPriority.urgent).length;
    final pendingCount = queue.length;
    final verifiedToday = recap.employeeScores.where((s) => s.isVerified).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.ownerColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'PIC Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          // Cutoff Timer
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.timer_outlined, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Cutoff: 09:00 WITA',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: AppTextStyles.bodyMedium,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Verifikasi'),
                  if (pendingCount > 0) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$pendingCount',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(text: 'Rekap Harian'),
            Tab(text: 'Prioritas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVerificationTab(queue, urgentCount),
          _buildRecapTab(recap),
          _buildPriorityTab(queue),
        ],
      ),
    );
  }

  /// ============================================================
  /// TAB 1: VERIFICATION QUEUE
  /// ============================================================
  Widget _buildVerificationTab(List<JobDeskVerificationQueueItem> queue, int urgentCount) {
    return Column(
      children: [
        // Date Selector & Stats
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Date Picker
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary),
                          const SizedBox(width: 8),
                          Text(
                            _selectedDate,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Quick Stats
              Row(
                children: [
                  _buildQuickStat(
                    label: 'URGENT',
                    value: '$urgentCount',
                    color: const Color(0xFFE53935),
                  ),
                  const SizedBox(width: 12),
                  _buildQuickStat(
                    label: 'PENDING',
                    value: '${queue.length}',
                    color: AppColors.warning,
                  ),
                  const SizedBox(width: 12),
                  _buildQuickStat(
                    label: 'VERIFIED',
                    value: '12',
                    color: AppColors.success,
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Priority Filter
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPriorityFilterChip('Semua', 'all'),
                const SizedBox(width: 8),
                _buildPriorityFilterChip('URGENT', 'urgent', const Color(0xFFE53935)),
                const SizedBox(width: 8),
                _buildPriorityFilterChip('HIGH', 'high', const Color(0xFFFF9800)),
                const SizedBox(width: 8),
                _buildPriorityFilterChip('NORMAL', 'normal', const Color(0xFFFFC107)),
                const SizedBox(width: 8),
                _buildPriorityFilterChip('LOW', 'low', const Color(0xFF4CAF50)),
              ],
            ),
          ),
        ),
        
        // Queue List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: queue.length,
            itemBuilder: (context, index) {
              final item = queue[index];
              // Filter
              if (_priorityFilter != 'all' && 
                  item.priority.name != _priorityFilter) {
                return const SizedBox.shrink();
              }
              return _buildVerificationQueueCard(item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStat({
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: color.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityFilterChip(String label, String value, [Color? color]) {
    final isSelected = _priorityFilter == value;
    final chipColor = color ?? AppColors.primary;
    
    return GestureDetector(
      onTap: () => setState(() => _priorityFilter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? chipColor : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? chipColor : AppColors.divider,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationQueueCard(JobDeskVerificationQueueItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: item.priorityColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: () => _navigateToPhotoReview(item),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  // Priority Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: item.priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.priorityLabel,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: item.priorityColor,
                      ),
                    ),
                  ),
                  
                  const Spacer(),
                  
                  // Time
                  Text(
                    '${_getTimeAgo(item.submittedAt)}',
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // User Info
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: item.priorityColor.withOpacity(0.1),
                    child: Text(
                      item.userAvatar,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: item.priorityColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.userName,
                          style: AppTextStyles.bodyMedium,
                        ),
                        Text(
                          '${item.role} • ${item.branchName}',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                  
                  // Completion Circle
                  SizedBox(
                    width: 44,
                    height: 44,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: item.completionRate / 100,
                          strokeWidth: 4,
                          backgroundColor: AppColors.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            item.completionRate >= 80 
                                ? AppColors.success 
                                : item.completionRate >= 50 
                                    ? AppColors.warning 
                                    : AppColors.error,
                          ),
                        ),
                        Center(
                          child: Text(
                            '${item.completionRate}%',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),
              
              // Task Info
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.taskName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (item.taskDescription != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            item.taskDescription!,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textHint,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Footer Info
              Row(
                children: [
                  // Photo Count
                  if (item.hasPhoto)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.photo_camera_outlined,
                            size: 12,
                            color: AppColors.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.photoUrls?.length ?? 0} foto',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  
                  const SizedBox(width: 8),
                  
                  // Pending Tasks
                  if (item.pendingTasks > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${item.pendingTasks} task pending',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.warning,
                        ),
                      ),
                    ),
                  
                  const Spacer(),
                  
                  // Auto Score
                  Text(
                    'Auto: ${item.autoScore}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Action Button
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _navigateToPhotoReview(item),
                      icon: const Icon(Icons.visibility_outlined, size: 16),
                      label: const Text('Review'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.ownerColor,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Quick Score
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Nilai:',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.autoScore}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _getScoreColor(item.autoScore),
                          ),
                        ),
                      ],
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

  Color _getScoreColor(int score) {
    if (score >= 90) return AppColors.success;
    if (score >= 80) return const Color(0xFF86EFAC);
    if (score >= 70) return AppColors.warning;
    if (score >= 60) return const Color(0xFFFFA726);
    return AppColors.error;
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    
    if (diff.inMinutes < 60) return '${diff.inMinutes}m lalu';
    if (diff.inHours < 24) return '${diff.inHours}j lalu';
    return '${diff.inDays}h lalu';
  }

  void _navigateToPhotoReview(JobDeskVerificationQueueItem item) {
    context.push('/jobdesk/verify/${item.submissionId}');
  }

  /// ============================================================
  /// TAB 2: DAILY RECAP
  /// ============================================================
  Widget _buildRecapTab(JobDeskDailyRecap recap) {
    final rankedScores = recap.rankedScores;
    
    return CustomScrollView(
      slivers: [
        // Recap Header
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.ownerColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.white, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            '${recap.date.day}/${recap.date.month}/${recap.date.year}',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.lock_outline, color: Colors.white, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            recap.isFinal ? 'FINAL' : 'DRAFT',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Rata-rata: ${recap.branchAverage.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Dibuat: ${recap.generatedBy ?? 'Sistem'}',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Rankings
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final score = rankedScores[index];
                return _buildRankingCard(score);
              },
              childCount: rankedScores.length,
            ),
          ),
        ),
        
        // Export Button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('📄 Export laporan...')),
                );
              },
              icon: const Icon(Icons.download_outlined),
              label: const Text('Export Laporan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ),
        ),
        
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildRankingCard(JobDeskEmployeeScore score) {
    final medalColor = score.rank == 1
        ? const Color(0xFFFFD700) // Gold
        : score.rank == 2
            ? const Color(0xFFC0C0C0) // Silver
            : score.rank == 3
                ? const Color(0xFFCD7F32) // Bronze
                : AppColors.surfaceVariant;
    
    final medalTextColor = score.rank <= 3 ? Colors.white : AppColors.textSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: score.rank <= 3
              ? medalColor.withOpacity(0.5)
              : AppColors.divider,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank Badge
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: medalColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${score.rank}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: medalTextColor,
                  ),
                ),
              ),
            ),
            
            const SizedBox(width: 12),
            
            // User Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    score.userName,
                    style: AppTextStyles.bodyMedium,
                  ),
                  Text(
                    score.role,
                    style: AppTextStyles.caption,
                  ),
                  if (score.overallComment != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      score.overallComment!,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textHint,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            
            // Score
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${score.totalScore}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: _getScoreColor(score.totalScore),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: _getScoreColor(score.totalScore).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    score.grade ?? score.calculateGrade(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _getScoreColor(score.totalScore),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================================
  /// TAB 3: PRIORITY ALGORITHM
  /// ============================================================
  Widget _buildPriorityTab(List<JobDeskVerificationQueueItem> queue) {
    // Group by priority
    final urgent = queue.where((q) => q.priority == VerificationPriority.urgent).toList();
    final high = queue.where((q) => q.priority == VerificationPriority.high).toList();
    final normal = queue.where((q) => q.priority == VerificationPriority.normal).toList();
    final low = queue.where((q) => q.priority == VerificationPriority.low).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Algorithm Explanation
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.info.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.info.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.psychology_outlined, color: AppColors.info),
                  const SizedBox(width: 8),
                  Text(
                    'Algoritma Prioritas',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.info,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Prioritas ditentukan berdasarkan:\n'
                '• Completion Rate (rendah = urgent)\n'
                '• Waktu submit (lama = urgent)\n'
                '• Jumlah task pending\n'
                '• Historical performance',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Priority Groups
        _buildPriorityGroup('URGENT - Dicek Dulu', urgent, const Color(0xFFE53935)),
        _buildPriorityGroup('HIGH - Perlu Perhatian', high, const Color(0xFFFF9800)),
        _buildPriorityGroup('NORMAL - Standard Queue', normal, const Color(0xFFFFC107)),
        _buildPriorityGroup('LOW - Sudah Lengkap', low, const Color(0xFF4CAF50)),
      ],
    );
  }

  Widget _buildPriorityGroup(
    String title,
    List<JobDeskVerificationQueueItem> items,
    Color color,
  ) {
    if (items.isEmpty) return const SizedBox.shrink();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${items.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...items.map((item) => _buildMiniQueueItem(item)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMiniQueueItem(JobDeskVerificationQueueItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: item.priorityColor.withOpacity(0.1),
            child: Text(
              item.userAvatar,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: item.priorityColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.userName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${item.taskName} • ${item.completionRate}%',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios, size: 16),
            onPressed: () => _navigateToPhotoReview(item),
          ),
        ],
      ),
    );
  }
}
