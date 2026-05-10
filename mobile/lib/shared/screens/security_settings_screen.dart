import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';

/// ============================================================
/// 🔒 SECURITY SETTINGS SCREEN
/// Pengaturan keamanan akun
/// ============================================================

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  ConsumerState<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends ConsumerState<SecuritySettingsScreen> {
  bool _isLoading = false;
  bool _biometricEnabled = false;
  bool _pinEnabled = true;
  bool _twoFactorEnabled = false;

  void _showChangePasswordDialog() {
    final currentPassController = TextEditingController();
    final newPassController = TextEditingController();
    final confirmPassController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Password'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password Saat Ini',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password Baru',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPassController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password Baru',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
            ],
          ),
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
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _showChangePINDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah PIN'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Masukkan PIN baru 6 digit'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _PinDot(),
                _PinDot(),
                _PinDot(),
                _PinDot(),
                _PinDot(),
                _PinDot(),
              ],
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
                  content: Text('PIN berhasil diubah'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Keamanan',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Security Section
            _buildSectionHeader('Keamanan Akun'),
            const SizedBox(height: 12),
            _buildCard([
              _buildActionTile(
                icon: Icons.lock_outline,
                iconColor: AppColors.primary,
                title: 'Ubah Password',
                subtitle: 'Terakhir diubah 3 bulan lalu',
                onTap: _showChangePasswordDialog,
              ),
              const Divider(height: 1, indent: 72),
              _buildActionTile(
                icon: Icons.pin_outlined,
                iconColor: AppColors.warning,
                title: 'Ubah PIN',
                subtitle: 'PIN 6 digit untuk akses cepat',
                onTap: _showChangePINDialog,
              ),
              const Divider(height: 1, indent: 72),
              _buildSwitchTile(
                icon: Icons.fingerprint,
                iconColor: AppColors.success,
                title: 'Biometric / Sidik Jari',
                subtitle: 'Login dengan sidik jari atau Face ID',
                value: _biometricEnabled,
                onChanged: (value) {
                  setState(() => _biometricEnabled = value);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(value 
                        ? 'Biometric diaktifkan' 
                        : 'Biometric dinonaktifkan'),
                    ),
                  );
                },
              ),
            ]),

            const SizedBox(height: 24),

            // Two Factor Authentication
            _buildSectionHeader('Autentikasi Dua Faktor'),
            const SizedBox(height: 12),
            _buildCard([
              _buildSwitchTile(
                icon: Icons.security,
                iconColor: AppColors.info,
                title: 'Verifikasi 2 Langkah',
                subtitle: 'Tambahan keamanan dengan kode OTP',
                value: _twoFactorEnabled,
                onChanged: (value) {
                  setState(() => _twoFactorEnabled = value);
                  if (value) {
                    _showEnable2FADialog();
                  }
                },
              ),
              if (_twoFactorEnabled) ...[
                const Divider(height: 1, indent: 72),
                _buildActionTile(
                  icon: Icons.phone_android,
                  iconColor: AppColors.success,
                  title: 'Metode Verifikasi',
                  subtitle: 'SMS ke 0812****7890',
                  onTap: () {},
                ),
              ],
            ]),

            const SizedBox(height: 24),

            // Login History
            _buildSectionHeader('Riwayat Login'),
            const SizedBox(height: 12),
            _buildCard([
              _buildLoginHistoryTile(
                device: 'iPhone 13 Pro',
                location: 'Jakarta, Indonesia',
                time: 'Sekarang',
                isCurrent: true,
              ),
              const Divider(height: 1, indent: 72),
              _buildLoginHistoryTile(
                device: 'Chrome - Windows',
                location: 'Jakarta, Indonesia',
                time: 'Kemarin, 18:30',
                isCurrent: false,
              ),
              const Divider(height: 1, indent: 72),
              _buildLoginHistoryTile(
                device: 'Samsung Galaxy S21',
                location: 'Bandung, Indonesia',
                time: '2 hari lalu, 09:15',
                isCurrent: false,
              ),
            ]),

            const SizedBox(height: 24),

            // Active Sessions
            _buildSectionHeader('Sesi Aktif'),
            const SizedBox(height: 12),
            _buildCard([
              _buildSessionTile(
                device: 'Mobile App - iOS',
                location: 'Jakarta',
                lastActive: 'Aktif sekarang',
              ),
              const Divider(height: 1, indent: 72),
              _buildSessionTile(
                device: 'Web Browser - Chrome',
                location: 'Jakarta',
                lastActive: '30 menit lalu',
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () {
                  _showLogoutAllDialog();
                },
                icon: const Icon(Icons.logout, color: AppColors.error, size: 18),
                label: const Text(
                  'Keluar dari Semua Perangkat',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ]),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showEnable2FADialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Aktifkan 2FA'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.security, size: 64, color: AppColors.success),
            const SizedBox(height: 16),
            const Text(
              'Pilih metode verifikasi:',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.sms, color: AppColors.primary),
              title: const Text('SMS'),
              subtitle: const Text('Kirim kode ke nomor telepon'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kode verifikasi SMS dikirim')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.email, color: AppColors.info),
              title: const Text('Email'),
              subtitle: const Text('Kirim kode ke email'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kode verifikasi Email dikirim')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text(
          'Anda akan keluar dari semua perangkat kecuali perangkat ini. Lanjutkan?'
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
                  content: Text('Semua sesi lain telah dikeluarkan'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Keluar Semua'),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
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
            const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginHistoryTile({
    required String device,
    required String location,
    required String time,
    required bool isCurrent,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isCurrent 
                ? AppColors.success.withOpacity(0.1) 
                : AppColors.textHint.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isCurrent ? Icons.phone_android : Icons.devices,
              color: isCurrent ? AppColors.success : AppColors.textHint,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      device,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Aktif',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.success,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '$location • $time',
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
    );
  }

  Widget _buildSessionTile({
    required String device,
    required String location,
    required String lastActive,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.devices,
              color: AppColors.primary,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$location • $lastActive',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Perangkat dikeluarkan')),
              );
            },
            child: const Text(
              'Keluarkan',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PinDot extends StatelessWidget {
  const _PinDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary),
      ),
    );
  }
}
