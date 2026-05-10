import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/shared/widgets/app_scaffold.dart';

/// ============================================================
/// 👤 USER PROFILE SCREEN
/// Profil Pengguna & Pengaturan Akun
/// ============================================================

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: '/profile',
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPersonalInfoSection(),
                    const SizedBox(height: 24),
                    _buildWorkInfoSection(),
                    const SizedBox(height: 24),
                    _buildSettingsSection(),
                    const SizedBox(height: 24),
                    _buildActionsSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, bottom: 30, left: 16, right: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B8EEF), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          // Edit Button
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: Icon(
                _isEditing ? Icons.check : Icons.edit,
                color: Colors.white,
              ),
              onPressed: () => setState(() => _isEditing = !_isEditing),
            ),
          ),
          
          // Avatar
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: Color(0xFF6B8EEF),
                  ),
                ),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 20,
                      color: Color(0xFF6B8EEF),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Name
          const Text(
            'Ahmad Santoso',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          
          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Sales Executive',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          
          // Branch
          Text(
            'Cabang Pusat - Sam Ratulangi',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    return _buildSection(
      title: 'Informasi Pribadi',
      icon: Icons.person_outline,
      child: Column(
        children: [
          _buildInfoTile(
            icon: Icons.email_outlined,
            label: 'Email',
            value: 'ahmad.santoso@tridjaya.com',
            editable: _isEditing,
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.phone_outlined,
            label: 'Telepon',
            value: '+62 812-3456-7890',
            editable: _isEditing,
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.cake_outlined,
            label: 'Tanggal Lahir',
            value: '15 Januari 1990',
            editable: _isEditing,
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.location_on_outlined,
            label: 'Alamat',
            value: 'Jl. Sudirman No. 123, Manado',
            editable: _isEditing,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkInfoSection() {
    return _buildSection(
      title: 'Informasi Pekerjaan',
      icon: Icons.work_outline,
      child: Column(
        children: [
          _buildInfoTile(
            icon: Icons.badge_outlined,
            label: 'ID Karyawan',
            value: 'EMP-2024-001',
            editable: false,
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.calendar_today_outlined,
            label: 'Tanggal Bergabung',
            value: '1 Maret 2022',
            editable: false,
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.supervisor_account_outlined,
            label: 'Atasan Langsung',
            value: 'Pak Hendra (Kepala Cabang)',
            editable: false,
          ),
          _buildDivider(),
          _buildInfoTile(
            icon: Icons.assignment_ind_outlined,
            label: 'Status',
            value: 'Karyawan Tetap',
            editable: false,
            valueColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection() {
    return _buildSection(
      title: 'Pengaturan',
      icon: Icons.settings_outlined,
      child: Column(
        children: [
          _buildSwitchTile(
            icon: Icons.notifications_outlined,
            title: 'Notifikasi',
            subtitle: 'Aktifkan notifikasi aplikasi',
            value: _notificationsEnabled,
            onChanged: (v) => setState(() => _notificationsEnabled = v),
          ),
          _buildDivider(),
          _buildSwitchTile(
            icon: Icons.dark_mode_outlined,
            title: 'Mode Gelap',
            subtitle: 'Gunakan tema gelap',
            value: _darkModeEnabled,
            onChanged: (v) => setState(() => _darkModeEnabled = v),
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.lock_outline,
            title: 'Ubah Password',
            onTap: () => _showChangePasswordDialog(),
          ),
          _buildDivider(),
          _buildActionTile(
            icon: Icons.language_outlined,
            title: 'Bahasa',
            subtitle: 'Bahasa Indonesia',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionsSection() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => _showLogoutConfirmation(),
            icon: const Icon(Icons.logout),
            label: const Text('Keluar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'Versi 1.0.0 (Build 2024.05.10)',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textHint,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 20, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
    required bool editable,
    Color? valueColor,
  }) {
    return ListTile(
      leading: Icon(icon, size: 22, color: AppColors.textHint),
      title: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textHint,
        ),
      ),
      subtitle: editable
          ? TextFormField(
              initialValue: value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: valueColor ?? AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
            )
          : Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: valueColor ?? AppColors.textPrimary,
              ),
            ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppColors.textHint),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.textHint,
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primary,
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textHint),
      title: Text(title),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textHint,
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      indent: 56,
      color: AppColors.divider.withOpacity(0.5),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password Lama',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password Baru',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Password Baru',
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Password berhasil diubah'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Clear auth state
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }
}
