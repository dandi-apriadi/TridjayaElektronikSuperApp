import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/user_model.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    final color = _roleColor(user.role.displayName);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            elevation: 0,
            backgroundColor: color,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildHeader(user.username, user.role.displayName, user.branchName, color),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                _buildInfoSection(user.username, user.role.displayName, user.branchName ?? '-', color),
                const SizedBox(height: 16),
                _buildSettingsSection(context, ref, color),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String name, String role, String? branch, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(children: [
        Positioned(top: -30, right: -30,
          child: Container(width: 160, height: 160,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.06)))),
        Positioned(bottom: -20, left: -20,
          child: Container(width: 100, height: 100,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.04)))),
        SafeArea(child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 5))],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Center(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '?',
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: color),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
              child: Text(role, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
            ),
            if (branch != null) ...[
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.store_outlined, color: Colors.white70, size: 14),
                const SizedBox(width: 4),
                Text(branch, style: const TextStyle(color: Colors.white70, fontSize: 13)),
              ]),
            ],
          ]),
        )),
      ]),
    );
  }

  Widget _buildInfoSection(String username, String role, String branch, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Column(children: [
        _infoTile(Icons.person_outline_rounded, 'Username', username, color),
        const Divider(height: 1, indent: 62, endIndent: 16),
        _infoTile(Icons.badge_outlined, 'Role', role, color),
        const Divider(height: 1, indent: 62, endIndent: 16),
        _infoTile(Icons.store_outlined, 'Cabang', branch, color),
      ]),
    );
  }

  Widget _infoTile(IconData icon, String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        Container(
          width: 38, height: 38,
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: AppTextStyles.caption),
          Text(value, style: AppTextStyles.bodyMedium),
        ]),
      ]),
    );
  }

  Widget _buildSettingsSection(BuildContext context, WidgetRef ref, Color color) {
    final items = [
      (Icons.notifications_outlined, 'Notifikasi', 'Kelola preferensi notifikasi', AppColors.info,
          () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengaturan Notifikasi — Coming Soon'), behavior: SnackBarBehavior.floating))),
      (Icons.lock_outline_rounded, 'Ubah Password', 'Ganti password akun Anda', AppColors.warning,
          () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ubah Password — Coming Soon'), behavior: SnackBarBehavior.floating))),
      (Icons.help_outline_rounded, 'Bantuan', 'Panduan penggunaan aplikasi', AppColors.success,
          () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bantuan — Coming Soon'), behavior: SnackBarBehavior.floating))),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Column(children: [
        ...items.asMap().entries.map((e) {
          final i = e.key;
          final item = e.value;
          return Column(children: [
            _settingsTile(item.$1, item.$2, item.$3, item.$4, item.$5),
            if (i < items.length - 1) const Divider(height: 1, indent: 62, endIndent: 16),
          ]);
        }),
        const Divider(height: 1, indent: 16, endIndent: 16),
        _logoutTile(context, ref),
      ]),
    );
  }

  Widget _settingsTile(IconData icon, String title, String subtitle, Color iconColor, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: iconColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppTextStyles.bodyMedium),
            Text(subtitle, style: AppTextStyles.caption),
          ])),
          const Icon(Icons.arrow_forward_ios_rounded, size: 13, color: AppColors.textHint),
        ]),
      ),
    );
  }

  Widget _logoutTile(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () => _confirmLogout(context, ref),
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.logout_rounded, size: 18, color: AppColors.error),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Logout', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
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

  Color _roleColor(String role) {
    switch (role) {
      case 'Owner': return AppColors.ownerColor;
      case 'Kepala Cabang': return AppColors.kepalaCabangColor;
      case 'Admin': return AppColors.adminColor;
      case 'Sales': return AppColors.salesColor;
      default: return AppColors.driverColor;
    }
  }
}
