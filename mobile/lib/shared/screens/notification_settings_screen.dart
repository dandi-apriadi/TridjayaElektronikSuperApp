import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/models/user_settings_model.dart';

/// ============================================================
/// 🔔 NOTIFICATION SETTINGS SCREEN
/// Pengaturan notifikasi dan reminder untuk pengguna
/// ============================================================

class NotificationSettingsScreen extends ConsumerStatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  ConsumerState<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends ConsumerState<NotificationSettingsScreen> {
  late UserSettings _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    // TODO: Load from provider/storage
    setState(() {
      _settings = UserSettings(userId: 'current_user');
      _isLoading = false;
    });
  }

  void _saveSettings() {
    // TODO: Save to provider/storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pengaturan berhasil disimpan'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _selectReminderTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _settings.reminderTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: AppColors.surface,
              hourMinuteTextColor: AppColors.textPrimary,
              dialHandColor: AppColors.primary,
              dialBackgroundColor: AppColors.primary.withOpacity(0.1),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _settings.reminderTime) {
      setState(() {
        _settings = _settings.copyWith(reminderTime: picked);
      });
      _saveSettings();
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Pengaturan Notifikasi',
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
            // Task Reminder Section
            _buildSectionHeader('⏰ Pengingat Task'),
            const SizedBox(height: 12),
            _buildCard([
              _buildSwitchTile(
                icon: Icons.notifications_active,
                iconColor: AppColors.primary,
                title: 'Pengingat Task Harian',
                subtitle: 'Dapatkan notifikasi untuk task yang belum selesai',
                value: _settings.taskReminderEnabled,
                onChanged: (value) {
                  setState(() {
                    _settings = _settings.copyWith(taskReminderEnabled: value);
                  });
                  _saveSettings();
                },
              ),
              if (_settings.taskReminderEnabled) ...[
                const Divider(height: 1, indent: 72),
                _buildTimePickerTile(
                  icon: Icons.access_time,
                  iconColor: AppColors.warning,
                  title: 'Waktu Pengingat',
                  subtitle: 'Notifikasi akan muncul setiap hari pada waktu ini',
                  time: _settings.reminderTime,
                  onTap: _selectReminderTime,
                ),
              ],
            ]),

            const SizedBox(height: 24),

            // Deadline Reminder Section
            _buildSectionHeader('📅 Pengingat Deadline'),
            const SizedBox(height: 12),
            _buildCard([
              _buildSwitchTile(
                icon: Icons.event_busy,
                iconColor: AppColors.error,
                title: 'Pengingat Sebelum Deadline',
                subtitle: 'Notifikasi beberapa hari sebelum deadline task',
                value: _settings.remindBeforeDeadline,
                onChanged: (value) {
                  setState(() {
                    _settings = _settings.copyWith(remindBeforeDeadline: value);
                  });
                  _saveSettings();
                },
              ),
              if (_settings.remindBeforeDeadline) ...[
                const Divider(height: 1, indent: 72),
                _buildNumberPickerTile(
                  icon: Icons.date_range,
                  iconColor: AppColors.info,
                  title: 'Hari Sebelum Deadline',
                  subtitle: 'Berapa hari sebelumnya ingin diingatkan',
                  value: _settings.reminderDaysBefore,
                  onChanged: (value) {
                    setState(() {
                      _settings = _settings.copyWith(reminderDaysBefore: value);
                    });
                    _saveSettings();
                  },
                ),
              ],
            ]),

            const SizedBox(height: 24),

            // Notification Channels
            _buildSectionHeader('📱 Channel Notifikasi'),
            const SizedBox(height: 12),
            _buildCard([
              _buildSwitchTile(
                icon: Icons.phone_android,
                iconColor: AppColors.success,
                title: 'Push Notification',
                subtitle: 'Notifikasi langsung ke perangkat Anda',
                value: _settings.pushNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _settings = _settings.copyWith(pushNotificationsEnabled: value);
                  });
                  _saveSettings();
                },
              ),
              const Divider(height: 1, indent: 72),
              _buildSwitchTile(
                icon: Icons.email,
                iconColor: AppColors.info,
                title: 'Email',
                subtitle: 'Kirim notifikasi ke email Anda',
                value: _settings.emailNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _settings = _settings.copyWith(emailNotificationsEnabled: value);
                  });
                  _saveSettings();
                },
              ),
              const Divider(height: 1, indent: 72),
              _buildSwitchTile(
                icon: Icons.sms,
                iconColor: AppColors.warning,
                title: 'SMS',
                subtitle: 'Kirim notifikasi via SMS',
                value: _settings.smsNotificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _settings = _settings.copyWith(smsNotificationsEnabled: value);
                  });
                  _saveSettings();
                },
              ),
            ]),

            const SizedBox(height: 24),

            // Additional Settings
            _buildSectionHeader('⚙️ Pengaturan Lainnya'),
            const SizedBox(height: 12),
            _buildCard([
              _buildSwitchTile(
                icon: Icons.summarize,
                iconColor: AppColors.primary,
                title: 'Ringkasan Harian',
                subtitle: 'Dapatkan ringkasan task setiap hari',
                value: _settings.remindDailySummary,
                onChanged: (value) {
                  setState(() {
                    _settings = _settings.copyWith(remindDailySummary: value);
                  });
                  _saveSettings();
                },
              ),
            ]),

            const SizedBox(height: 32),

            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Notifikasi akan muncul pada waktu yang telah ditentukan. Pastikan pengaturan notifikasi perangkat Anda diizinkan.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
            activeTrackColor: AppColors.primary.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePickerTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required TimeOfDay time,
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatTime(time),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right, color: AppColors.textHint, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildNumberPickerTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required int value,
    required ValueChanged<int> onChanged,
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
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: value > 1 ? () => onChanged(value - 1) : null,
                icon: Icon(Icons.remove_circle_outline,
                  color: value > 1 ? AppColors.primary : AppColors.divider),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '$value hari',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              IconButton(
                onPressed: value < 7 ? () => onChanged(value + 1) : null,
                icon: Icon(Icons.add_circle_outline,
                  color: value < 7 ? AppColors.primary : AppColors.divider),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
