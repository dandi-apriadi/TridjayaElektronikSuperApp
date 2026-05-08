import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/user_model.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/superadmin_dummy_data.dart';
import '../../models/superadmin_models.dart';

/// ============================================================
/// 👑 SUPER ADMIN DASHBOARD SCREEN
/// ============================================================
/// Dashboard utama Super Admin dengan kontrol penuh:
/// - System overview & stats
/// - User management
/// - Branch management
/// - Audit logs
/// - Security monitoring
/// - Feature flags
/// - System configuration
/// ============================================================

class SuperAdminDashboardScreen extends ConsumerStatefulWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  ConsumerState<SuperAdminDashboardScreen> createState() =>
      _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState
    extends ConsumerState<SuperAdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late SuperAdminDashboardStats _stats;
  late List<SuperAdminUserManagement> _users;
  late List<SecurityAlert> _alerts;
  late SystemConfig _config;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _loadData();
  }

  void _loadData() {
    _stats = SuperAdminDummyData.getDashboardStats();
    _users = SuperAdminDummyData.getAllUsers();
    _alerts = SuperAdminDummyData.getSecurityAlerts();
    _config = SuperAdminDummyData.getSystemConfig();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1A1A2E), // Dark admin color
        systemOverlayStyle: SystemUiOverlayStyle.light,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.admin_panel_settings,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Super Admin',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'System Control Center',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Critical Alert Badge
          if (_stats.criticalAlerts > 0)
            Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning, color: Colors.white, size: 14),
                  const SizedBox(width: 4),
                  Text(
                    '${_stats.criticalAlerts}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          
          // Settings
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () => context.push('/superadmin/settings'),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.w600),
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.dashboard_outlined, size: 18),
                  const SizedBox(width: 6),
                  const Text('Overview'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.people_outlined, size: 18),
                  const SizedBox(width: 6),
                  Text('Users (${_stats.totalUsers})'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.account_tree_outlined, size: 18),
                  const SizedBox(width: 6),
                  Text('Branches'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.security_outlined, size: 18),
                  const SizedBox(width: 6),
                  Text('Security'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.receipt_long_outlined, size: 18),
                  const SizedBox(width: 6),
                  const Text('Audit Logs'),
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.tune_outlined, size: 18),
                  const SizedBox(width: 6),
                  const Text('System'),
                ],
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildUsersTab(),
          _buildBranchesTab(),
          _buildSecurityTab(),
          _buildAuditLogsTab(),
          _buildSystemTab(),
        ],
      ),
    );
  }

  /// ============================================================
  /// TAB 1: OVERVIEW
  /// ============================================================
  Widget _buildOverviewTab() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() => _loadData());
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Critical Alerts Banner
            if (_stats.criticalAlerts > 0)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.warning_amber,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_stats.criticalAlerts} Critical Alert${_stats.criticalAlerts > 1 ? 's' : ''}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Immediate attention required. Review security tab.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => _tabController.animateTo(3),
                      child: const Text('View'),
                    ),
                  ],
                ),
              ),

            // Quick Stats Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.4,
              children: [
                _buildStatCard(
                  title: 'Total Users',
                  value: '${_stats.totalUsers}',
                  subtitle: '${_stats.activeUsers} active',
                  icon: Icons.people_alt,
                  color: const Color(0xFF6366F1),
                  onTap: () => _tabController.animateTo(1),
                ),
                _buildStatCard(
                  title: 'Active Sessions',
                  value: '${_stats.activeSessions}',
                  subtitle: 'Currently online',
                  icon: Icons.online_prediction,
                  color: const Color(0xFF10B981),
                  onTap: () {},
                ),
                _buildStatCard(
                  title: 'Branches',
                  value: '${_stats.activeBranches}/${_stats.totalBranches}',
                  subtitle: 'Active/Total',
                  icon: Icons.account_tree,
                  color: const Color(0xFFF59E0B),
                  onTap: () => _tabController.animateTo(2),
                ),
                _buildStatCard(
                  title: 'System Uptime',
                  value: '${_stats.systemUptime.toStringAsFixed(2)}%',
                  subtitle: 'Last 30 days',
                  icon: Icons.timer,
                  color: const Color(0xFF3B82F6),
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Role Distribution
            _buildSectionTitle('Role Distribution'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: _stats.loginsByRole.entries.map((entry) {
                  return _buildDistributionRow(
                    label: entry.key,
                    count: entry.value,
                    total: _stats.totalUsers,
                    color: _getRoleColor(entry.key),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Recent Activity
            _buildSectionTitle('Recent Activity'),
            const SizedBox(height: 12),
            ..._stats.recentActivity.map((activity) => _buildActivityItem(activity)),

            const SizedBox(height: 20),

            // Quick Actions
            _buildSectionTitle('Quick Actions'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildQuickActionButton(
                  label: 'Add User',
                  icon: Icons.person_add,
                  color: const Color(0xFF6366F1),
                  onTap: () => context.push('/superadmin/users/create'),
                ),
                _buildQuickActionButton(
                  label: 'System Config',
                  icon: Icons.settings,
                  color: const Color(0xFF10B981),
                  onTap: () => _tabController.animateTo(5),
                ),
                _buildQuickActionButton(
                  label: 'Export Data',
                  icon: Icons.download,
                  color: const Color(0xFFF59E0B),
                  onTap: () => _showExportDialog(),
                ),
                _buildQuickActionButton(
                  label: 'Maintenance',
                  icon: Icons.build,
                  color: const Color(0xFFEF4444),
                  onTap: () => _showMaintenanceDialog(),
                ),
              ],
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
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
                  child: Icon(icon, size: 20, color: color),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textHint),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDistributionRow({
    required String label,
    required int count,
    required int total,
    required Color color,
  }) {
    final percentage = total > 0 ? (count / total) : 0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage.toDouble(),
              backgroundColor: AppColors.surfaceVariant,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'SuperAdmin':
        return const Color(0xFF8B5CF6);
      case 'Owner':
        return const Color(0xFFEC4899);
      case 'KepalaCabang':
        return const Color(0xFF3B82F6);
      case 'Admin':
        return const Color(0xFF10B981);
      case 'Sales':
        return const Color(0xFFF59E0B);
      case 'Driver':
        return const Color(0xFF6366F1);
      default:
        return AppColors.textHint;
    }
  }

  Widget _buildActivityItem(Map<String, dynamic> activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.circle,
              size: 8,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['action'],
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${activity['user']} → ${activity['target']}',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity['time'],
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  /// ============================================================
  /// TAB 2: USERS MANAGEMENT
  /// ============================================================
  Widget _buildUsersTab() {
    return Column(
      children: [
        // Search & Filter
        Container(
          padding: const EdgeInsets.all(16),
          color: AppColors.surface,
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search users...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: AppColors.surfaceVariant,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', true),
                    _buildFilterChip('Active', false),
                    _buildFilterChip('Inactive', false),
                    _buildFilterChip('Suspended', false),
                    _buildFilterChip('SuperAdmin', false),
                    _buildFilterChip('Owner', false),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Users List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _users.length,
            itemBuilder: (context, index) {
              return _buildUserCard(_users[index]);
            },
          ),
        ),
        
        // Floating Action Button
        Padding(
          padding: const EdgeInsets.all(16),
          child: FloatingActionButton.extended(
            onPressed: () => context.push('/superadmin/users/create'),
            icon: const Icon(Icons.add),
            label: const Text('Add User'),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {},
        selectedColor: AppColors.primary.withOpacity(0.2),
        checkmarkColor: AppColors.primary,
      ),
    );
  }

  Widget _buildUserCard(SuperAdminUserManagement user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: _getRoleColor(user.role.name).withOpacity(0.1),
          child: Text(
            user.fullName.substring(0, 1),
            style: TextStyle(
              color: _getRoleColor(user.role.name),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        title: Text(
          user.fullName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          '${user.role.displayName} • ${user.branchName ?? "No Branch"}',
          style: TextStyle(fontSize: 12, color: AppColors.textHint),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: user.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            user.statusLabel,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: user.isActive ? Colors.green : Colors.red,
            ),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                const Divider(),
                _buildUserInfoRow('Email', user.email),
                _buildUserInfoRow('Phone', user.phone ?? 'Not set'),
                _buildUserInfoRow('Username', user.username),
                _buildUserInfoRow('Total Logins', '${user.totalLogins}'),
                _buildUserInfoRow(
                  'Last Login',
                  user.lastLoginAt != null
                      ? '${user.lastLoginAt!.day}/${user.lastLoginAt!.month}/${user.lastLoginAt!.year}'
                      : 'Never',
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showUserActions(user),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Edit'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showUserActions(user),
                        icon: const Icon(Icons.more_vert, size: 16),
                        label: const Text('Actions'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.surfaceVariant,
                          foregroundColor: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUserActions(SuperAdminUserManagement user) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit User'),
              onTap: () {
                Navigator.pop(context);
                context.push('/superadmin/users/${user.userId}/edit');
              },
            ),
            ListTile(
              leading: const Icon(Icons.key),
              title: const Text('Reset Password'),
              onTap: () {
                Navigator.pop(context);
                _showPasswordResetDialog(user);
              },
            ),
            ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text('Verify Account'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.block, color: Colors.red),
              title: const Text('Suspend User', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showSuspendDialog(user);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('Delete User', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteDialog(user);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================================
  /// TAB 3: BRANCHES
  /// ============================================================
  Widget _buildBranchesTab() {
    final branches = SuperAdminDummyData.getAllBranches();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: branches.length,
      itemBuilder: (context, index) {
        return _buildBranchCard(branches[index]);
      },
    );
  }

  Widget _buildBranchCard(BranchManagement branch) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: branch.isActive
                      ? AppColors.success.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.business,
                  color: branch.isActive ? AppColors.success : Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branch.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Code: ${branch.code}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: branch.isActive
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  branch.isActive ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: branch.isActive ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            branch.address,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildBranchStat('Users', '${branch.activeUsers}/${branch.totalUsers}'),
              _buildBranchStat('Manager', branch.managerName ?? 'Not assigned'),
              _buildBranchStat('Performance', '${branch.performanceScore.toStringAsFixed(1)}%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBranchStat(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textHint,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// ============================================================
  /// TAB 4: SECURITY
  /// ============================================================
  Widget _buildSecurityTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _alerts.length,
      itemBuilder: (context, index) {
        return _buildSecurityAlertCard(_alerts[index]);
      },
    );
  }

  Widget _buildSecurityAlertCard(SecurityAlert alert) {
    Color severityColor;
    IconData severityIcon;
    
    switch (alert.severity) {
      case SecurityAlertSeverity.critical:
        severityColor = Colors.red;
        severityIcon = Icons.error;
        break;
      case SecurityAlertSeverity.high:
        severityColor = Colors.orange;
        severityIcon = Icons.warning;
        break;
      case SecurityAlertSeverity.medium:
        severityColor = Colors.yellow;
        severityIcon = Icons.info;
        break;
      case SecurityAlertSeverity.low:
        severityColor = Colors.blue;
        severityIcon = Icons.info_outline;
        break;
      case SecurityAlertSeverity.info:
        severityColor = Colors.grey;
        severityIcon = Icons.info_outline;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: alert.isResolved ? Colors.grey : severityColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: severityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(severityIcon, color: severityColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      alert.type.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        color: severityColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              if (alert.isResolved)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Resolved',
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            alert.description,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          if (alert.userName != null) ...[
            const SizedBox(height: 8),
            Text(
              'User: ${alert.userName}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
          ],
          if (!alert.isResolved)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _resolveAlert(alert),
                      child: const Text('Mark Resolved'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _investigateAlert(alert),
                      child: const Text('Investigate'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _resolveAlert(SecurityAlert alert) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Alert ${alert.id} marked as resolved')),
    );
  }

  void _investigateAlert(SecurityAlert alert) {
    context.push('/superadmin/security/${alert.id}');
  }

  /// ============================================================
  /// TAB 5: AUDIT LOGS
  /// ============================================================
  Widget _buildAuditLogsTab() {
    final logs = SuperAdminDummyData.getAuditLogs();
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        return _buildAuditLogCard(logs[index]);
      },
    );
  }

  Widget _buildAuditLogCard(AuditLogEntry log) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                  color: log.isCritical ? Colors.red.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  log.isCritical ? Icons.warning : Icons.history,
                  size: 16,
                  color: log.isCritical ? Colors.red : AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      log.actionLabel,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${log.userName} • ${_getTimeAgo(log.timestamp)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${log.targetType}: ${log.targetName}',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          if (log.reason != null) ...[
            const SizedBox(height: 4),
            Text(
              'Reason: ${log.reason}',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textHint,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  /// ============================================================
  /// TAB 6: SYSTEM
  /// ============================================================
  Widget _buildSystemTab() {
    final features = SuperAdminDummyData.getFeatureFlags();
    final backups = SuperAdminDummyData.getBackups();
    
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // System Status
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'System Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              _buildSystemStatusRow('App Version', _config.appVersion),
              _buildSystemStatusRow('Maintenance Mode', _config.maintenanceMode ? 'ON' : 'OFF'),
              _buildSystemStatusRow('New Registrations', _config.allowNewRegistrations ? 'Open' : 'Closed'),
              _buildSystemStatusRow('Default Timezone', _config.defaultTimezone),
              _buildSystemStatusRow('Max Login Attempts', '${_config.maxLoginAttempts}'),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Feature Flags
        _buildSectionTitle('Feature Flags'),
        const SizedBox(height: 12),
        ...features.map((feature) => _buildFeatureFlagCard(feature)),
        
        const SizedBox(height: 20),
        
        // Backups
        _buildSectionTitle('Backups'),
        const SizedBox(height: 12),
        ...backups.map((backup) => _buildBackupCard(backup)),
      ],
    );
  }

  Widget _buildSystemStatusRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureFlagCard(FeatureFlag feature) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: feature.isEnabled
                  ? Colors.green.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              feature.isEnabled ? Icons.check_circle : Icons.cancel,
              size: 16,
              color: feature.isEnabled ? Colors.green : Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  feature.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: feature.isEnabled,
            onChanged: (value) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${feature.name} ${value ? "enabled" : "disabled"}')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBackupCard(BackupInfo backup) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backup.status == 'completed'
                  ? Colors.blue.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              backup.status == 'completed' ? Icons.backup : Icons.hourglass_top,
              size: 16,
              color: backup.status == 'completed' ? Colors.blue : Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  backup.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${backup.sizeFormatted} • ${backup.type}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: backup.status == 'completed' ? () {} : null,
            child: Text(backup.status == 'completed' ? 'Download' : backup.status),
          ),
        ],
      ),
    );
  }

  /// ============================================================
  /// HELPERS
  /// ============================================================
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('All Users'),
              subtitle: const Text('CSV format'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Exporting users...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Audit Logs'),
              subtitle: const Text('PDF format'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Analytics Report'),
              subtitle: const Text('Excel format'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showMaintenanceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Maintenance Mode'),
        content: const Text(
          'Enable maintenance mode? This will prevent all users except Super Admin from accessing the system.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Maintenance mode enabled')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  void _showPasswordResetDialog(SuperAdminUserManagement user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reset Password - ${user.fullName}'),
        content: const Text(
          'This will generate a new temporary password and send it to the user\'s email.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Password reset email sent to ${user.email}')),
              );
            },
            child: const Text('Reset Password'),
          ),
        ],
      ),
    );
  }

  void _showSuspendDialog(SuperAdminUserManagement user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Suspend User - ${user.fullName}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Suspension reason (required):'),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Enter reason...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user.fullName} has been suspended')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Suspend'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(SuperAdminUserManagement user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete User - ${user.fullName}?'),
        content: const Text(
          'WARNING: This action cannot be undone. All user data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${user.fullName} has been deleted')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
