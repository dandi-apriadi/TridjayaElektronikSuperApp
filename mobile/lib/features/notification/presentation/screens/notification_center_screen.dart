import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';
import '../../shared/widgets/app_scaffold.dart';

/// ============================================================
/// 🔔 NOTIFICATION CENTER SCREEN
/// Pusat Notifikasi Aplikasi
/// ============================================================

enum NotificationType {
  jobdesk,
  attendance,
  approval,
  system,
  announcement,
}

class NotificationItem {
  final String id;
  final NotificationType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final bool isRead;
  final String? actionRoute;
  final Map<String, dynamic>? actionParams;

  NotificationItem({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.isRead = false,
    this.actionRoute,
    this.actionParams,
  });
}

class NotificationCenterScreen extends ConsumerStatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  ConsumerState<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends ConsumerState<NotificationCenterScreen> {
  String _selectedFilter = 'Semua';
  
  final List<String> _filters = ['Semua', 'Job Desk', 'Absensi', 'Approval', 'Sistem'];
  
  // Dummy notifications
  List<NotificationItem> get _dummyNotifications {
    final now = DateTime.now();
    return [
      NotificationItem(
        id: 'n001',
        type: NotificationType.approval,
        title: 'Laporan Disetujui',
        message: 'Laporan kerja Anda tanggal 10 Mei 2024 telah disetujui oleh Pak Hendra',
        timestamp: now.subtract(const Duration(minutes: 5)),
        isRead: false,
        actionRoute: '/work-reports',
      ),
      NotificationItem(
        id: 'n002',
        type: NotificationType.jobdesk,
        title: 'Reminder Job Desk',
        message: 'Anda belum mengisi job desk hari ini. Deadline: 09:00 WITA',
        timestamp: now.subtract(const Duration(hours: 2)),
        isRead: false,
        actionRoute: '/my-jobdesk',
      ),
      NotificationItem(
        id: 'n003',
        type: NotificationType.attendance,
        title: 'Check-in Berhasil',
        message: 'Anda telah check-in di Cabang Pusat pada 08:15 WITA',
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: true,
      ),
      NotificationItem(
        id: 'n004',
        type: NotificationType.system,
        title: 'Pembaruan Aplikasi',
        message: 'Versi 1.2.0 telah tersedia dengan fitur baru. Update sekarang!',
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
      ),
      NotificationItem(
        id: 'n005',
        type: NotificationType.approval,
        title: 'Cuti Disetujui',
        message: 'Pengajuan cuti Anda untuk tanggal 15-17 Mei telah disetujui',
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
        actionRoute: '/leave-requests',
      ),
      NotificationItem(
        id: 'n006',
        type: NotificationType.announcement,
        title: 'Pengumuman Penting',
        message: 'Rapat bulanan akan diadakan pada tanggal 20 Mei 2024 pukul 09:00',
        timestamp: now.subtract(const Duration(days: 3)),
        isRead: true,
        actionRoute: '/announcements',
      ),
      NotificationItem(
        id: 'n007',
        type: NotificationType.jobdesk,
        title: 'Job Desk Terverifikasi',
        message: 'Selamat! Semua tugas job desk Anda hari ini telah terverifikasi',
        timestamp: now.subtract(const Duration(days: 4)),
        isRead: true,
      ),
    ];
  }

  List<NotificationItem> get _filteredNotifications {
    if (_selectedFilter == 'Semua') return _dummyNotifications;
    
    return _dummyNotifications.where((n) {
      switch (_selectedFilter) {
        case 'Job Desk':
          return n.type == NotificationType.jobdesk;
        case 'Absensi':
          return n.type == NotificationType.attendance;
        case 'Approval':
          return n.type == NotificationType.approval;
        case 'Sistem':
          return n.type == NotificationType.system || n.type == NotificationType.announcement;
        default:
          return true;
      }
    }).toList();
  }

  int get _unreadCount => _dummyNotifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentRoute: '/notifications',
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notifikasi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                '$_unreadCount belum dibaca',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Tandai Semua',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // Filter Chips
            _buildFilterChips(),
            
            // Notification List
            Expanded(
              child: _filteredNotifications.isEmpty
                  ? _buildEmptyState()
                  : _buildNotificationList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _filters.map((filter) {
            final isSelected = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: isSelected,
                label: Text(filter),
                onSelected: (selected) {
                  setState(() => _selectedFilter = filter);
                },
                backgroundColor: AppColors.surface,
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildNotificationList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _filteredNotifications.length,
      itemBuilder: (context, index) {
        final notification = _filteredNotifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    final iconData = _getIconForType(notification.type);
    final iconColor = _getColorForType(notification.type);
    
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _deleteNotification(notification.id),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: notification.isRead 
                ? AppColors.divider 
                : AppColors.primary.withOpacity(0.3),
            width: notification.isRead ? 1 : 2,
          ),
        ),
        color: notification.isRead ? Colors.white : AppColors.primary.withOpacity(0.05),
        child: InkWell(
          onTap: () => _handleNotificationTap(notification),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(iconData, color: iconColor, size: 24),
                ),
                const SizedBox(width: 12),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: notification.isRead 
                                    ? FontWeight.w500 
                                    : FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 12,
                            color: AppColors.textHint,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatTimestamp(notification.timestamp),
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textHint,
                            ),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: iconColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              _getTypeLabel(notification.type),
                              style: TextStyle(
                                fontSize: 10,
                                color: iconColor,
                                fontWeight: FontWeight.w500,
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
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: AppColors.textHint.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak Ada Notifikasi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Anda akan menerima notifikasi di sini',
            style: TextStyle(
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.jobdesk:
        return Icons.assignment_turned_in;
      case NotificationType.attendance:
        return Icons.access_time;
      case NotificationType.approval:
        return Icons.check_circle;
      case NotificationType.system:
        return Icons.system_update;
      case NotificationType.announcement:
        return Icons.campaign;
    }
  }

  Color _getColorForType(NotificationType type) {
    switch (type) {
      case NotificationType.jobdesk:
        return Colors.blue;
      case NotificationType.attendance:
        return Colors.orange;
      case NotificationType.approval:
        return Colors.green;
      case NotificationType.system:
        return Colors.purple;
      case NotificationType.announcement:
        return Colors.red;
    }
  }

  String _getTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.jobdesk:
        return 'Job Desk';
      case NotificationType.attendance:
        return 'Absensi';
      case NotificationType.approval:
        return 'Approval';
      case NotificationType.system:
        return 'Sistem';
      case NotificationType.announcement:
        return 'Pengumuman';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final diff = now.difference(timestamp);
    
    if (diff.inMinutes < 1) {
      return 'Baru saja';
    } else if (diff.inHours < 1) {
      return '${diff.inMinutes} menit lalu';
    } else if (diff.inDays < 1) {
      return '${diff.inHours} jam lalu';
    } else if (diff.inDays == 1) {
      return 'Kemarin';
    } else {
      return DateFormat('dd MMM', 'id_ID').format(timestamp);
    }
  }

  void _handleNotificationTap(NotificationItem notification) {
    // Mark as read
    // TODO: Update notification status in backend
    
    // Navigate if action route exists
    if (notification.actionRoute != null) {
      context.push(notification.actionRoute!);
    }
  }

  void _markAllAsRead() {
    // TODO: Mark all as read in backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua notifikasi ditandai dibaca'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _deleteNotification(String id) {
    // TODO: Delete from backend
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notifikasi dihapus'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
