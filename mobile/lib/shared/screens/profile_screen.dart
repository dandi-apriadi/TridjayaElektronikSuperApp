import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/user_model.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../providers/leave_request_provider.dart';
import 'notification_settings_screen.dart';
import 'penalty_screen.dart';
import 'personal_info_screen.dart';
import 'security_settings_screen.dart';
import 'help_support_screen.dart';
import 'leave_request_dialog.dart';
import 'leave_history_screen.dart';
import 'leave_approval_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final color = _roleColor(user.role);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfileHeader(user.username, user.role, user.branchName ?? 'N/A', color),
              const SizedBox(height: 20),
              _buildStatsRow(context),
              const SizedBox(height: 20),
              _buildQuickActionsSection(context, color, user.role, user.id),
              const SizedBox(height: 20),
              _buildSettingsSection(context, ref, color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String name, UserRole role, String branch, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
              ),
              child: Center(child: Text(name.substring(0, 1).toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700))),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Row(children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: Text(role.displayName, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ]),
              const SizedBox(height: 6),
              Row(children: [
                const Icon(Icons.store_outlined, color: Colors.white70, size: 14),
                const SizedBox(width: 4),
                Text(branch, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ]),
            ])),
          ]),
        ]),
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.task_alt,
            value: '12',
            label: 'Task Selesai',
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.pending_actions,
            value: '3',
            label: 'Menunggu',
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.star,
            value: '95%',
            label: 'Performa',
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context, Color color, UserRole role, String userId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Menu Cepat',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        // Row 1: Notifikasi & Denda
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.notifications_active,
                title: 'Notifikasi',
                subtitle: 'Pengingat Task',
                color: AppColors.info,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.warning_amber,
                title: 'Denda',
                subtitle: 'Lihat Pelanggaran',
                color: AppColors.error,
                badge: '2',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PenaltyScreen()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Row 2: Pengajuan OFF/Sakit & Persetujuan (untuk Kepala Cabang/PIC)
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                icon: Icons.event_busy,
                title: 'OFF / Sakit',
                subtitle: 'Ajukan Izin',
                color: AppColors.warning,
                onTap: () => _showLeaveRequestDialog(context, userId),
              ),
            ),
            const SizedBox(width: 12),
            // Tombol Persetujuan hanya untuk Kepala Cabang/PIC/Owner
            if (role.canApproveLeave)
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final pendingCount = ref.watch(pendingApprovalsCountProvider);
                    return _buildQuickActionCard(
                      icon: Icons.fact_check,
                      title: 'Persetujuan',
                      subtitle: 'Menunggu: $pendingCount',
                      color: AppColors.success,
                      badge: pendingCount > 0 ? pendingCount.toString() : null,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LeaveApprovalScreen()),
                      ),
                    );
                  },
                ),
              )
            else
              Expanded(
                child: _buildQuickActionCard(
                  icon: Icons.history,
                  title: 'Riwayat',
                  subtitle: 'Pengajuan Saya',
                  color: AppColors.primary,
                  onTap: () => _showMyLeaveHistory(context, userId),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    String? badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppShadows.sm,
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                if (badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pengaturan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: AppShadows.sm,
          ),
          child: Column(children: [
            _settingsTile(
              Icons.person_outline,
              'Informasi Pribadi',
              'Nama, email, no. telepon',
              color,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
              ),
            ),
            const Divider(height: 1, indent: 72, endIndent: 16),
            _settingsTile(
              Icons.lock_outline,
              'Keamanan',
              'Ubah password, PIN, biometric',
              AppColors.warning,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecuritySettingsScreen()),
              ),
            ),
            const Divider(height: 1, indent: 72, endIndent: 16),
            _settingsTile(
              Icons.help_outline,
              'Bantuan & Dukungan',
              'Pusat bantuan, hubungi kami',
              AppColors.success,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
              ),
            ),
            const Divider(height: 1, indent: 16, endIndent: 16),
            _logoutTile(context, ref),
          ]),
        ),
      ],
    );
  }

  Widget _settingsTile(IconData icon, String title, String subtitle, Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 2),
            Text(subtitle, style: AppTextStyles.caption),
          ])),
          const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: AppColors.textHint),
        ]),
      ),
    );
  }

  Widget _logoutTile(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => _confirmLogout(context, ref),
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: AppColors.error.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.logout_rounded, size: 20, color: AppColors.error),
          ),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Logout', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text('Keluar dari akun', style: AppTextStyles.caption),
          ])),
        ]),
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Anda yakin ingin keluar dari akun?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authNotifierProvider.notifier).logout();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Color _roleColor(UserRole role) {
    switch (role) {
      case UserRole.owner: return AppColors.ownerColor;
      case UserRole.kepalaCabang: return AppColors.kepalaCabangColor;
      case UserRole.admin: return AppColors.adminColor;
      case UserRole.sales: return AppColors.salesColor;
      default: return AppColors.driverColor;
    }
  }

  /// Show leave request submission dialog
  void _showLeaveRequestDialog(BuildContext context, String userId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LeaveRequestDialog(employeeId: userId),
    );
  }

  /// Show user's leave history
  void _showMyLeaveHistory(BuildContext context, String userId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LeaveHistoryScreen(employeeId: userId),
      ),
    );
  }
}
