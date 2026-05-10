import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:te_superapp/core/theme/app_theme.dart';

/// ============================================================
/// ⚙️ SETTINGS SCREEN
/// Pengaturan aplikasi per user
/// ============================================================

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;
  bool _darkMode = false;
  bool _biometricAuth = false;
  String _selectedLanguage = 'id';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Pengaturan',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Account Section
          _buildSectionHeader('Akun'),
          _buildSettingsCard([
            _buildListTile(
              icon: Icons.person,
              title: 'Profil',
              subtitle: 'Edit informasi profil',
              onTap: () => context.push('/profile'),
            ),
            _buildListTile(
              icon: Icons.lock,
              title: 'Ubah Password',
              subtitle: 'Ganti password akun',
              onTap: () => context.push('/auth/change-password'),
            ),
            _buildListTile(
              icon: Icons.fingerprint,
              title: 'Autentikasi Biometrik',
              subtitle: 'Login dengan fingerprint/face ID',
              trailing: Switch(
                value: _biometricAuth,
                onChanged: (value) => setState(() => _biometricAuth = value),
                activeColor: AppColors.primary,
              ),
            ),
          ]),

          const SizedBox(height: 24),

          // Notifications Section
          _buildSectionHeader('Notifikasi'),
          _buildSettingsCard([
            _buildListTile(
              icon: Icons.notifications,
              title: 'Push Notification',
              subtitle: 'Notifikasi real-time',
              trailing: Switch(
                value: _pushNotifications,
                onChanged: (value) => setState(() => _pushNotifications = value),
                activeColor: AppColors.primary,
              ),
            ),
            _buildListTile(
              icon: Icons.email,
              title: 'Email Notification',
              subtitle: 'Kirim notifikasi ke email',
              trailing: Switch(
                value: _emailNotifications,
                onChanged: (value) => setState(() => _emailNotifications = value),
                activeColor: AppColors.primary,
              ),
            ),
            _buildListTile(
              icon: Icons.volume_up,
              title: 'Suara',
              subtitle: 'Aktifkan suara notifikasi',
              trailing: Switch(
                value: _soundEnabled,
                onChanged: (value) => setState(() => _soundEnabled = value),
                activeColor: AppColors.primary,
              ),
            ),
            _buildListTile(
              icon: Icons.vibration,
              title: 'Getar',
              subtitle: 'Getar saat notifikasi',
              trailing: Switch(
                value: _vibrationEnabled,
                onChanged: (value) => setState(() => _vibrationEnabled = value),
                activeColor: AppColors.primary,
              ),
            ),
          ]),

          const SizedBox(height: 24),

          // Appearance Section
          _buildSectionHeader('Tampilan'),
          _buildSettingsCard([
            _buildListTile(
              icon: _darkMode ? Icons.dark_mode : Icons.light_mode,
              title: 'Mode Gelap',
              subtitle: 'Tema gelap untuk aplikasi',
              trailing: Switch(
                value: _darkMode,
                onChanged: (value) => setState(() => _darkMode = value),
                activeColor: AppColors.primary,
              ),
            ),
            _buildListTile(
              icon: Icons.language,
              title: 'Bahasa',
              subtitle: _selectedLanguage == 'id' ? 'Bahasa Indonesia' : 'English',
              trailing: const Icon(Icons.chevron_right),
              onTap: _showLanguageDialog,
            ),
          ]),

          const SizedBox(height: 24),

          // Privacy & Security
          _buildSectionHeader('Privasi & Keamanan'),
          _buildSettingsCard([
            _buildListTile(
              icon: Icons.shield,
              title: 'Kebijakan Privasi',
              subtitle: 'Baca kebijakan privasi kami',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.description,
              title: 'Syarat & Ketentuan',
              subtitle: 'Ketentuan penggunaan aplikasi',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.security,
              title: 'Keamanan Akun',
              subtitle: 'Pengaturan keamanan tambahan',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 24),

          // Support Section
          _buildSectionHeader('Bantuan'),
          _buildSettingsCard([
            _buildListTile(
              icon: Icons.help,
              title: 'Pusat Bantuan',
              subtitle: 'FAQ dan panduan penggunaan',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.chat,
              title: 'Hubungi Support',
              subtitle: 'Chat dengan tim support',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            _buildListTile(
              icon: Icons.bug_report,
              title: 'Laporkan Bug',
              subtitle: 'Laporkan masalah aplikasi',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 24),

          // About Section
          _buildSectionHeader('Tentang'),
          _buildSettingsCard([
            _buildListTile(
              icon: Icons.info,
              title: 'Versi Aplikasi',
              subtitle: 'v1.0.0 (Build 2024.06.01)',
            ),
            _buildListTile(
              icon: Icons.update,
              title: 'Cek Update',
              subtitle: 'Periksa versi terbaru',
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'Terbaru',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ),
            ),
          ]),

          const SizedBox(height: 32),

          // Logout Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _showLogoutConfirmation,
              icon: const Icon(Icons.logout),
              label: const Text('Keluar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: AppColors.textHint,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.divider.withOpacity(0.5),
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            trailing ?? const SizedBox(),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pilih Bahasa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              title: const Text('Bahasa Indonesia'),
              value: 'id',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
                Navigator.pop(context);
              },
            ),
            RadioListTile(
              title: const Text('English'),
              value: 'en',
              groupValue: _selectedLanguage,
              onChanged: (value) {
                setState(() => _selectedLanguage = value!);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar?'),
        content: const Text('Anda akan keluar dari aplikasi. Lanjutkan?'),
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
