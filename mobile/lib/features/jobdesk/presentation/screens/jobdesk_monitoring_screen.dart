import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/jobdesk_dummy_data.dart';
import '../../models/jobdesk_models.dart';

/// ============================================================
/// 📊 JOB DESK MONITORING SCREEN - Owner/Superadmin
/// ============================================================
/// Dashboard monitoring untuk melihat progress semua karyawan
/// - Overview completion rate
/// - List karyawan dengan progress
/// - Filter by role/branch/date
/// ============================================================

class JobDeskMonitoringScreen extends ConsumerStatefulWidget {
  const JobDeskMonitoringScreen({super.key});

  @override
  ConsumerState<JobDeskMonitoringScreen> createState() => _JobDeskMonitoringScreenState();
}

class _JobDeskMonitoringScreenState extends ConsumerState<JobDeskMonitoringScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedPeriod = 'Hari Ini';
  final List<String> _periods = ['Hari Ini', 'Minggu Ini', 'Bulan Ini', 'Kustom'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final summaries = JobDeskDummyData.getDummyEmployeeSummaries();
    
    // Calculate overall stats
    final totalEmployees = summaries.length;
    final completedAll = summaries.where((s) => s.completionRate == 100).length;
    final avgCompletion = summaries.isEmpty 
        ? 0.0
        : summaries.fold(0.0, (sum, s) => sum + s.completionRate) / summaries.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.ownerColor,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Monitoring Job Desk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: AppTextStyles.bodyMedium,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Per Karyawan'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(totalEmployees, completedAll, avgCompletion),
          _buildEmployeeListTab(summaries),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(int totalEmployees, int completedAll, double avgCompletion) {
    return CustomScrollView(
      slivers: [
        // Period Filter
        SliverToBoxAdapter(
          child: _buildPeriodFilter(),
        ),
        
        // Stats Cards
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Total Karyawan',
                        value: '$totalEmployees',
                        icon: Icons.people_outline,
                        color: AppColors.info,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Lengkap 100%',
                        value: '$completedAll',
                        icon: Icons.check_circle_outline,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        title: 'Rata-rata',
                        value: '${avgCompletion.toInt()}%',
                        icon: Icons.analytics_outlined,
                        color: AppColors.ownerColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        title: 'Perlu Perhatian',
                        value: '${totalEmployees - completedAll}',
                        icon: Icons.warning_amber_outlined,
                        color: AppColors.warning,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Completion Chart Placeholder
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Distribusi Completion Rate', style: AppTextStyles.subtitle),
                  const SizedBox(height: 16),
                  _buildDistributionBar(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildLegendItem('100%', AppColors.success, '3 orang'),
                      _buildLegendItem('75-99%', const Color(0xFF86EFAC), '5 orang'),
                      _buildLegendItem('50-74%', AppColors.warning, '8 orang'),
                      _buildLegendItem('<50%', AppColors.error, '4 orang'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Top Performers
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Top Performers 🔥', style: AppTextStyles.subtitle),
                const SizedBox(height: 12),
                _buildTopPerformerCard('Citra Dewi', 'Support Online', 'Cabang Selatan', 12, 100.0),
                const SizedBox(height: 8),
                _buildTopPerformerCard('Ahmad Santoso', 'Support Online', 'Cabang Pusat', 5, 85.0),
                const SizedBox(height: 8),
                _buildTopPerformerCard('Budi Wijaya', 'Sales', 'Cabang Pusat', 3, 80.0),
              ],
            ),
          ),
        ),
        
        const SliverToBoxAdapter(
          child: SizedBox(height: 100),
        ),
      ],
    );
  }

  Widget _buildPeriodFilter() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _periods.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final period = _periods[index];
            final isSelected = _selectedPeriod == period;
            return GestureDetector(
              onTap: () => setState(() => _selectedPeriod = period),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.ownerColor : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  Widget _buildDistributionBar() {
    return Column(
      children: [
        _buildDistributionSegment(0.15, AppColors.success, '100%'),
        const SizedBox(height: 8),
        _buildDistributionSegment(0.25, const Color(0xFF86EFAC), '75-99%'),
        const SizedBox(height: 8),
        _buildDistributionSegment(0.40, AppColors.warning, '50-74%'),
        const SizedBox(height: 8),
        _buildDistributionSegment(0.20, AppColors.error, '<50%'),
      ],
    );
  }

  Widget _buildDistributionSegment(double percentage, Color color, String label) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color, String count) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              count,
              style: TextStyle(
                fontSize: 10,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopPerformerCard(
    String name,
    String role,
    String branch,
    int streak,
    double completion,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD93D).withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFFD93D), Color(0xFFFFA726)],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Center(
              child: Text(
                name[0],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.bodyMedium),
                Text('$role • $branch', style: AppTextStyles.caption),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$streak',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ownerColor,
                    ),
                  ),
                ],
              ),
              Text(
                '${completion.toInt()}%',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeListTab(List<JobDeskEmployeeSummary> summaries) {
    return Column(
      children: [
        // Filter Chips
        Container(
          color: AppColors.surface,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: const Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari karyawan...',
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Employee List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: summaries.length,
            itemBuilder: (context, index) {
              return _buildEmployeeCard(summaries[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmployeeCard(JobDeskEmployeeSummary summary) {
    final color = summary.completionRate >= 80
        ? AppColors.success
        : summary.completionRate >= 50
            ? AppColors.warning
            : AppColors.error;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showEmployeeDetail(summary),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar with progress
              SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: summary.completionRate / 100,
                      strokeWidth: 4,
                      backgroundColor: AppColors.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                    Center(
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: color.withOpacity(0.1),
                        child: Text(
                          summary.userName[0],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      summary.userName,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${summary.role} • ${summary.branchName}',
                      style: AppTextStyles.caption,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${summary.completedToday}/${summary.totalTasks}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: color,
                            ),
                          ),
                        ),
                        if (summary.streakDays > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.local_fire_department,
                                  size: 12,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  '${summary.streakDays}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.orange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              
              // Completion %
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${summary.completionRate.toInt()}%',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                  if (summary.lastSubmission != null)
                    Text(
                      '${_getTimeAgo(summary.lastSubmission!)}',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textHint,
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

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    
    if (diff.inMinutes < 60) return '${diff.inMinutes}m lalu';
    if (diff.inHours < 24) return '${diff.inHours}j lalu';
    return '${diff.inDays}h lalu';
  }

  void _showEmployeeDetail(JobDeskEmployeeSummary summary) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.ownerColor.withOpacity(0.1),
              child: Text(
                summary.userName[0],
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ownerColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(summary.userName, style: AppTextStyles.heading3),
            Text('${summary.role} • ${summary.branchName}', style: AppTextStyles.caption),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildDetailMetric('Tasks', '${summary.completedToday}/${summary.totalTasks}'),
                _buildDetailMetric('Completion', '${summary.completionRate.toInt()}%'),
                _buildDetailMetric('Streak', '${summary.streakDays} hari'),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to employee job desk detail
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.ownerColor,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: const Text('Lihat Detail Job Desk'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailMetric(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.ownerColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
