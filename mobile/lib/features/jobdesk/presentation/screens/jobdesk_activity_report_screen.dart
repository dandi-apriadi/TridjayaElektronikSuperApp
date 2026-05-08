import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/jobdesk_activity_dummy_data.dart';
import '../../models/jobdesk_activity_models.dart';
import '../../models/jobdesk_models.dart';

/// ============================================================
/// 📊 JOB DESK ACTIVITY REPORT SCREEN
/// ============================================================
/// 
/// Pelaporan aktivitas Job Desk dengan filter berbasis role:
/// - Owner: Lihat SEMUA cabang
/// - Kepala Cabang: Lihat cabang sendiri saja
/// - PIC: Lihat SEMUA (untuk verifikasi & penilaian)
/// 
/// Author: TE SuperApp Team
/// Created: May 2026
/// 
/// ============================================================

class JobDeskActivityReportScreen extends ConsumerStatefulWidget {
  final UserRole userRole;
  final String? branchId; // For Kepala Cabang - their branch
  final String? picId; // For PIC identification

  const JobDeskActivityReportScreen({
    super.key,
    required this.userRole,
    this.branchId,
    this.picId,
  });

  @override
  ConsumerState<JobDeskActivityReportScreen> createState() => _JobDeskActivityReportScreenState();
}

class _JobDeskActivityReportScreenState extends ConsumerState<JobDeskActivityReportScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedBranchIndex = 0;
  String? _selectedRole;
  ActivityStatus? _selectedStatus;
  bool _showOnlyPendingVerification = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.userRole == UserRole.kepalaCabang ? 2 : 3,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Get accessible branches based on role
  List<Map<String, dynamic>> get _accessibleBranches {
    switch (widget.userRole) {
      case UserRole.owner:
      case UserRole.superAdmin:
      case UserRole.kepalaCabang: // PIC sees all but mainly focused on verification
        return JobDeskActivityDummyData.branches;
      case UserRole.kepalaCabang:
        // Kepala Cabang only sees their own branch
        return JobDeskActivityDummyData.branches
            .where((b) => b['id'] == widget.branchId)
            .toList();
      default:
        return [];
    }
  }

  /// Get activities based on role and filters
  List<EmployeeJobDeskActivity> get _filteredActivities {
    List<EmployeeJobDeskActivity> activities;

    // Get base activities based on role
    switch (widget.userRole) {
      case UserRole.owner:
      case UserRole.superAdmin:
        activities = JobDeskActivityDummyData.getAllActivities();
        break;
      case UserRole.kepalaCabang:
        // Kepala Cabang only sees their branch
        activities = _getActivitiesForBranch(widget.branchId ?? 'branch_001');
        break;
      default:
        activities = [];
    }

    // Apply branch filter
    if (_selectedBranchIndex > 0 && widget.userRole != UserRole.kepalaCabang) {
      final selectedBranchId = _accessibleBranches[_selectedBranchIndex]['id'];
      activities = activities.where((a) => a.branchId == selectedBranchId).toList();
    }

    // Apply role filter
    if (_selectedRole != null) {
      activities = activities.where((a) => a.role == _selectedRole).toList();
    }

    // Apply status filter
    if (_selectedStatus != null) {
      activities = activities.where((a) => a.status == _selectedStatus).toList();
    }

    // Apply pending verification filter
    if (_showOnlyPendingVerification) {
      activities = activities.where((a) => a.needsVerification).toList();
    }

    // Apply search
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      activities = activities.where((a) =>
        a.userName.toLowerCase().contains(query) ||
        a.role.toLowerCase().contains(query) ||
        a.branchName.toLowerCase().contains(query)
      ).toList();
    }

    return activities;
  }

  List<EmployeeJobDeskActivity> _getActivitiesForBranch(String branchId) {
    switch (branchId) {
      case 'branch_001':
        return JobDeskActivityDummyData.getCabangPusatActivities();
      case 'branch_002':
        return JobDeskActivityDummyData.getCabangSelatanActivities();
      case 'branch_003':
        return JobDeskActivityDummyData.getCabangUtaraActivities();
      case 'branch_004':
        return JobDeskActivityDummyData.getCabangBaratActivities();
      default:
        return [];
    }
  }

  /// Get role-based title
  String get _pageTitle {
    switch (widget.userRole) {
      case UserRole.owner:
        return 'Laporan Job Desk - Semua Cabang';
      case UserRole.superAdmin:
        return 'Monitoring Job Desk - System Wide';
      case UserRole.kepalaCabang:
        return 'Laporan Job Desk - Cabang ${_accessibleBranches.first['name']}';
      default:
        return 'Laporan Job Desk';
    }
  }

  @override
  Widget build(BuildContext context) {
    final activities = _filteredActivities;
    final dailyReport = JobDeskActivityDummyData.getDailyReport('System');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _pageTitle,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Hari ini, ${_formatDate(DateTime.now())}',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
          tabs: [
            Tab(icon: Icon(Icons.dashboard_outlined), text: 'Overview'),
            Tab(icon: Icon(Icons.people_outline), text: 'Karyawan'),
            if (widget.userRole != UserRole.kepalaCabang)
              Tab(icon: Icon(Icons.business_outlined), text: 'Cabang'),
          ],
        ),
        actions: [
          // Export button
          IconButton(
            icon: Icon(Icons.download_outlined, color: AppColors.primary),
            onPressed: () => _showExportDialog(),
            tooltip: 'Export Laporan',
          ),
          SizedBox(width: 8),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Overview
          _buildOverviewTab(dailyReport),
          
          // Tab 2: Employee List
          _buildEmployeeTab(activities),
          
          // Tab 3: Branch Summary (only for Owner/SuperAdmin)
          if (widget.userRole != UserRole.kepalaCabang)
            _buildBranchTab(dailyReport.branchSummaries),
        ],
      ),
    );
  }

  // ============================================================================
  // TAB 1: OVERVIEW
  // ============================================================================

  Widget _buildOverviewTab(DailyJobDeskReport report) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Summary Cards
          _buildOverviewCards(report),
          SizedBox(height: 20),
          
          // Role Breakdown
          _buildRoleBreakdown(report.roleStats),
          SizedBox(height: 20),
          
          // Alerts/Issues
          _buildAlertsSection(report.alerts),
        ],
      ),
    );
  }

  Widget _buildOverviewCards(DailyJobDeskReport report) {
    return GridView.count(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        _buildStatCard(
          title: 'Total Karyawan',
          value: '${report.totalEmployees}',
          subtitle: 'Aktif hari ini',
          icon: Icons.people_alt_outlined,
          color: AppColors.primary,
        ),
        _buildStatCard(
          title: 'Task Selesai',
          value: '${report.completedTasks}',
          subtitle: 'dari ${report.totalTasks} task',
          icon: Icons.check_circle_outlined,
          color: AppColors.success,
        ),
        _buildStatCard(
          title: 'Completion Rate',
          value: '${report.overallCompletionRate.toStringAsFixed(1)}%',
          subtitle: 'Rata-rata harian',
          icon: Icons.trending_up_outlined,
          color: AppColors.warning,
        ),
        _buildStatCard(
          title: 'Terverifikasi',
          value: '${report.verifiedTasks}',
          subtitle: 'Sudah dinilai PIC',
          icon: Icons.verified_outlined,
          color: AppColors.info,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBreakdown(Map<String, RoleActivityStats> roleStats) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistik per Role',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 16),
          ...roleStats.entries.map((entry) {
            final stats = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          stats.roleName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '${stats.employeeCount} karyawan',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        LinearProgressIndicator(
                          value: stats.completionRate / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getCompletionColor(stats.completionRate),
                          ),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '${stats.completedTasks}/${stats.totalTasks} (${stats.completionRate.toStringAsFixed(1)}%)',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildAlertsSection(List<ActivityAlert> alerts) {
    final criticalAlerts = alerts.where((a) => 
      a.type == AlertType.noActivity || 
      a.type == AlertType.lowCompletion
    ).toList();
    
    final verificationAlerts = alerts.where((a) => 
      a.type == AlertType.pendingVerification
    ).toList();
    
    final goodAlerts = alerts.where((a) => 
      a.type == AlertType.excellentPerformance
    ).toList();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Peringatan & Notifikasi',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '${alerts.length} item',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          
          if (criticalAlerts.isNotEmpty) ...[
            _buildAlertCategory(
              title: '⚠️ Perlu Perhatian',
              alerts: criticalAlerts,
              color: AppColors.error,
            ),
            SizedBox(height: 12),
          ],
          
          if (verificationAlerts.isNotEmpty) ...[
            _buildAlertCategory(
              title: '🔍 Menunggu Verifikasi',
              alerts: verificationAlerts,
              color: AppColors.warning,
            ),
            SizedBox(height: 12),
          ],
          
          if (goodAlerts.isNotEmpty) ...[
            _buildAlertCategory(
              title: '⭐ Performa Baik',
              alerts: goodAlerts,
              color: AppColors.success,
            ),
          ],
          
          if (alerts.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Tidak ada peringatan',
                  style: TextStyle(color: AppColors.textHint),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAlertCategory({
    required String title,
    required List<ActivityAlert> alerts,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        SizedBox(height: 8),
        ...alerts.take(3).map((alert) => Container(
          margin: EdgeInsets.only(bottom: 8),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '${alert.employeeName} • ${alert.branchName}',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),
        if (alerts.length > 3)
          TextButton(
            onPressed: () {},
            child: Text('+${alerts.length - 3} lainnya'),
          ),
      ],
    );
  }

  // ============================================================================
  // TAB 2: EMPLOYEE LIST
  // ============================================================================

  Widget _buildEmployeeTab(List<EmployeeJobDeskActivity> activities) {
    return Column(
      children: [
        // Filters
        _buildEmployeeFilters(),
        
        // Employee List
        Expanded(
          child: activities.isEmpty
              ? _buildEmptyState('Tidak ada data karyawan')
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: activities.length,
                  itemBuilder: (context, index) {
                    final activity = activities[index];
                    return _buildEmployeeCard(activity);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmployeeFilters() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Cari karyawan...',
              prefixIcon: Icon(Icons.search, color: AppColors.textHint),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
          SizedBox(height: 12),
          
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Branch filter (for Owner/SuperAdmin)
                if (widget.userRole != UserRole.kepalaCabang) ...[
                  _buildFilterChip(
                    label: _selectedBranchIndex == 0 
                        ? 'Semua Cabang' 
                        : _accessibleBranches[_selectedBranchIndex]['name'],
                    icon: Icons.business,
                    onTap: () => _showBranchFilter(),
                  ),
                  SizedBox(width: 8),
                ],
                
                // Role filter
                _buildFilterChip(
                  label: _selectedRole ?? 'Semua Role',
                  icon: Icons.work_outline,
                  onTap: () => _showRoleFilter(),
                ),
                SizedBox(width: 8),
                
                // Status filter
                _buildFilterChip(
                  label: _selectedStatus?.name ?? 'Semua Status',
                  icon: Icons.filter_list,
                  onTap: () => _showStatusFilter(),
                ),
                SizedBox(width: 8),
                
                // Verification filter
                if (widget.userRole == UserRole.kepalaCabang)
                  FilterChip(
                    label: Text('Butuh Verifikasi'),
                    selected: _showOnlyPendingVerification,
                    onSelected: (value) => setState(() => _showOnlyPendingVerification = value),
                    selectedColor: AppColors.warning.withOpacity(0.2),
                    checkmarkColor: AppColors.warning,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.divider),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.textSecondary),
            SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 16, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  Widget _buildEmployeeCard(EmployeeJobDeskActivity activity) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showEmployeeDetail(activity),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  // Avatar
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        activity.userName.substring(0, 1).toUpperCase(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  
                  // Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          activity.userName,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: _getRoleColor(activity.role).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                activity.role,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _getRoleColor(activity.role),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            if (widget.userRole != UserRole.kepalaCabang)
                              Text(
                                activity.branchName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Score Badge
                  if (activity.dailyScore != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getScoreColor(activity.dailyScore!).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${activity.dailyScore}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: _getScoreColor(activity.dailyScore!),
                            ),
                          ),
                          Text(
                            'Nilai',
                            style: TextStyle(
                              fontSize: 10,
                              color: _getScoreColor(activity.dailyScore!),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),
              
              // Progress
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Progress',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              '${activity.completedTasks}/${activity.totalTasks}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        LinearProgressIndicator(
                          value: activity.completionRate / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getCompletionColor(activity.completionRate),
                          ),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  
                  // Status
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor(activity.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      activity.statusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _getStatusColor(activity.status),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Verification needed indicator
              if (activity.needsVerification) ...[
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.timer_outlined, size: 16, color: AppColors.warning),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${activity.completedTasks - activity.verifiedTasks} task menunggu verifikasi',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                      if (widget.userRole == UserRole.kepalaCabang)
                        TextButton(
                          onPressed: () {
                            // Navigate to verification
                            context.push('/jobdesk/pic');
                          },
                          child: Text('Verifikasi'),
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

  // ============================================================================
  // TAB 3: BRANCH SUMMARY (Owner/SuperAdmin only)
  // ============================================================================

  Widget _buildBranchTab(List<BranchJobDeskSummary> branches) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: branches.length,
      itemBuilder: (context, index) {
        final branch = branches[index];
        return _buildBranchCard(branch);
      },
    );
  }

  Widget _buildBranchCard(BranchJobDeskSummary branch) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _getBranchHealthColor(branch.health).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.business,
                      color: _getBranchHealthColor(branch.health),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        branch.branchName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Kepala: ${branch.managerName}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getBranchHealthColor(branch.health).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _getBranchHealthLabel(branch.health),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _getBranchHealthColor(branch.health),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Stats Row
            Row(
              children: [
                _buildBranchStat(
                  label: 'Karyawan',
                  value: '${branch.activeEmployees}/${branch.totalEmployees}',
                  icon: Icons.people_outline,
                ),
                _buildBranchStat(
                  label: 'Completion',
                  value: '${branch.branchCompletionRate.toStringAsFixed(0)}%',
                  icon: Icons.check_circle_outline,
                ),
                _buildBranchStat(
                  label: 'Verifikasi',
                  value: '${branch.pendingVerificationCount}',
                  icon: Icons.pending_actions_outlined,
                ),
              ],
            ),
            SizedBox(height: 16),
            
            // Progress
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Progress Task Hari Ini',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${branch.completedTasks}/${branch.totalTasksToday}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 6),
                LinearProgressIndicator(
                  value: branch.branchCompletionRate / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getBranchHealthColor(branch.health),
                  ),
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            ),
            
            // Needs attention
            if (branch.needsAttention.isNotEmpty) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.error.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_outlined, size: 16, color: AppColors.error),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${branch.needsAttention.length} karyawan perlu perhatian',
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
    );
  }

  Widget _buildBranchStat({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.textHint),
          SizedBox(width: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: AppColors.textHint,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_outlined,
            size: 64,
            color: AppColors.textHint.withOpacity(0.5),
          ),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              color: AppColors.textHint,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _showBranchFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Cabang',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.all_inclusive),
              title: Text('Semua Cabang'),
              selected: _selectedBranchIndex == 0,
              onTap: () {
                setState(() => _selectedBranchIndex = 0);
                Navigator.pop(context);
              },
            ),
            ..._accessibleBranches.asMap().entries.map((entry) {
              final index = entry.key + 1;
              final branch = entry.value;
              return ListTile(
                leading: Icon(Icons.business),
                title: Text(branch['name']),
                subtitle: Text('Kode: ${branch['code']}'),
                selected: _selectedBranchIndex == index,
                onTap: () {
                  setState(() => _selectedBranchIndex = index);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showRoleFilter() {
    final roles = ['Support Online', 'Sales', 'Admin', 'Driver'];
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Role',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.group),
              title: Text('Semua Role'),
              selected: _selectedRole == null,
              onTap: () {
                setState(() => _selectedRole = null);
                Navigator.pop(context);
              },
            ),
            ...roles.map((role) => ListTile(
              leading: Icon(Icons.work_outline),
              title: Text(role),
              selected: _selectedRole == role,
              onTap: () {
                setState(() => _selectedRole = role);
                Navigator.pop(context);
              },
            )).toList(),
          ],
        ),
      ),
    );
  }

  void _showStatusFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.filter_list_off),
              title: Text('Semua Status'),
              selected: _selectedStatus == null,
              onTap: () {
                setState(() => _selectedStatus = null);
                Navigator.pop(context);
              },
            ),
            ...ActivityStatus.values.map((status) => ListTile(
              leading: Icon(_getStatusIcon(status)),
              title: Text(_getStatusLabel(status)),
              selected: _selectedStatus == status,
              onTap: () {
                setState(() => _selectedStatus = status);
                Navigator.pop(context);
              },
            )).toList(),
          ],
        ),
      ),
    );
  }

  void _showEmployeeDetail(EmployeeJobDeskActivity activity) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Handle
                Container(
                  margin: EdgeInsets.only(top: 8),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                // Header
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            activity.userName.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              activity.userName,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${activity.role} • ${activity.branchName}',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                // Content
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    padding: EdgeInsets.all(16),
                    children: [
                      // Stats
                      Row(
                        children: [
                          _buildDetailStat('Completion', '${activity.completionRate.toStringAsFixed(0)}%'),
                          _buildDetailStat('Tasks', '${activity.completedTasks}/${activity.totalTasks}'),
                          _buildDetailStat('Score', activity.dailyScore?.toString() ?? '-'),
                        ],
                      ),
                      SizedBox(height: 20),
                      
                      // Submissions
                      Text(
                        'Detail Submissions',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      ...activity.submissions.map((sub) => Container(
                        margin: EdgeInsets.only(bottom: 12),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.divider),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    sub.taskName,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _getSubmissionStatusColor(sub.status).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    sub.status.name.toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: _getSubmissionStatusColor(sub.status),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (sub.actualValue != null) ...[
                              SizedBox(height: 4),
                              Text(
                                '${sub.actualValue}${sub.targetUnit != null ? ' ${sub.targetUnit}' : ''} ${sub.targetValue != null ? '/${sub.targetValue}' : ''}',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                            if (sub.picComment != null) ...[
                              SizedBox(height: 8),
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.comment_outlined, size: 14, color: AppColors.textHint),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        sub.picComment!,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      )).toList(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailStat(String label, String value) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Export Laporan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.picture_as_pdf, color: AppColors.error),
              title: Text('Export PDF'),
              subtitle: Text('Laporan lengkap dengan grafik'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mengexport PDF...')),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.table_chart, color: AppColors.success),
              title: Text('Export Excel'),
              subtitle: Text('Data tabel untuk analisis'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Mengexport Excel...')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
        ],
      ),
    );
  }

  // ============================================================================
  // COLOR & UTILITY METHODS
  // ============================================================================

  Color _getCompletionColor(double rate) {
    if (rate >= 80) return AppColors.success;
    if (rate >= 50) return AppColors.warning;
    return AppColors.error;
  }

  Color _getStatusColor(ActivityStatus status) {
    switch (status) {
      case ActivityStatus.notStarted:
        return Colors.grey;
      case ActivityStatus.pending:
        return AppColors.warning;
      case ActivityStatus.inProgress:
        return AppColors.info;
      case ActivityStatus.pendingVerification:
        return AppColors.warning;
      case ActivityStatus.verified:
        return AppColors.success;
      case ActivityStatus.rejected:
        return AppColors.error;
    }
  }

  String _getStatusLabel(ActivityStatus status) {
    switch (status) {
      case ActivityStatus.notStarted:
        return 'Belum Mulai';
      case ActivityStatus.pending:
        return 'Pending';
      case ActivityStatus.inProgress:
        return 'Sedang Dikerjakan';
      case ActivityStatus.pendingVerification:
        return 'Menunggu Verifikasi';
      case ActivityStatus.verified:
        return 'Terverifikasi';
      case ActivityStatus.rejected:
        return 'Ditolak';
    }
  }

  IconData _getStatusIcon(ActivityStatus status) {
    switch (status) {
      case ActivityStatus.notStarted:
        return Icons.schedule;
      case ActivityStatus.pending:
        return Icons.hourglass_empty;
      case ActivityStatus.inProgress:
        return Icons.work;
      case ActivityStatus.pendingVerification:
        return Icons.pending_actions;
      case ActivityStatus.verified:
        return Icons.verified;
      case ActivityStatus.rejected:
        return Icons.cancel;
    }
  }

  Color _getScoreColor(int score) {
    if (score >= 90) return AppColors.success;
    if (score >= 80) return AppColors.primary;
    if (score >= 70) return AppColors.warning;
    if (score >= 60) return Colors.orange;
    return AppColors.error;
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'Support Online':
        return AppColors.info;
      case 'Sales':
        return AppColors.success;
      case 'Admin':
        return AppColors.primary;
      case 'Driver':
        return AppColors.warning;
      default:
        return AppColors.textSecondary;
    }
  }

  Color _getBranchHealthColor(BranchHealth health) {
    switch (health) {
      case BranchHealth.excellent:
        return AppColors.success;
      case BranchHealth.good:
        return AppColors.primary;
      case BranchHealth.average:
        return AppColors.warning;
      case BranchHealth.poor:
        return AppColors.error;
    }
  }

  String _getBranchHealthLabel(BranchHealth health) {
    switch (health) {
      case BranchHealth.excellent:
        return 'Sangat Baik';
      case BranchHealth.good:
        return 'Baik';
      case BranchHealth.average:
        return 'Cukup';
      case BranchHealth.poor:
        return 'Kurang';
    }
  }

  Color _getSubmissionStatusColor(JobDeskStatus status) {
    switch (status) {
      case JobDeskStatus.pending:
        return AppColors.warning;
      case JobDeskStatus.completed:
        return AppColors.info;
      case JobDeskStatus.verified:
        return AppColors.success;
      case JobDeskStatus.rejected:
        return AppColors.error;
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}
