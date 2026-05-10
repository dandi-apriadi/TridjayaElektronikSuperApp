import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../models/notification_model.dart' as notif;
import '../providers/notification_provider.dart';

/// ============================================================
/// 🔔 NOTIFICATION CENTER SCREEN
/// Pusat Notifikasi Aplikasi
/// ============================================================

class NotificationCenterScreen extends ConsumerStatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  ConsumerState<NotificationCenterScreen> createState() => _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends ConsumerState<NotificationCenterScreen> {
  String _selectedFilter = 'Semua';
  
  final List<String> _filters = ['Semua', 'Job Desk', 'Absensi', 'Approval', 'Sistem'];

  @override
  Widget build(BuildContext context) {
    final notificationsData = ref.watch(notificationsProvider(null));
    final unreadCount = ref.watch(unreadCountProvider);
    
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
              unreadCount.when(
                data: (count) => Text(
                  '$count belum dibaca',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                loading: () => Text(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
                error: (err, stack) => Text(
                  '0 belum dibaca',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => _markAllAsRead(ref),
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
              child: notificationsData.when(
                data: (response) {
                  final filtered = _filterNotifications(response.notifications);
                  if (filtered.isEmpty) {
                    return _buildEmptyState();
                  }
                  return _buildNotificationList(filtered, ref);
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (err, stack) => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 80,
                        color: AppColors.error.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Gagal Memuat Notifikasi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textHint,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        err.toString(),
                        style: TextStyle(
                          color: AppColors.textHint,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ref.refresh(notificationsProvider(null));
                          ref.refresh(unreadCountProvider);
                        },
                        child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              ),
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

  Widget _buildNotificationList(List<notif.Notification> notifications, WidgetRef ref) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification, ref);
      },
    );
  }

  Widget _buildNotificationCard(notif.Notification notification, WidgetRef ref) {
    final notificationType = notification.type;
    final iconColor = notificationType.color;
    
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
      onDismissed: (_) => _deleteNotification(notification.id, ref),
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
          onTap: () => _handleNotificationTap(notification, ref),
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
                  child: Icon(notificationType.icon, color: iconColor, size: 24),
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
                            _formatTimestamp(notification.createdAt),
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
                              notificationType.label,
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

  List<notif.Notification> _filterNotifications(List<notif.Notification> notifications) {
    if (_selectedFilter == 'Semua') return notifications;
    
    return notifications.where((n) {
      switch (_selectedFilter) {
        case 'Job Desk':
          return n.type == notif.NotificationType.jobdesk;
        case 'Absensi':
          return n.type == notif.NotificationType.attendance;
        case 'Approval':
          return n.type == notif.NotificationType.approval;
        case 'Sistem':
          return n.type == notif.NotificationType.system || n.type == notif.NotificationType.announcement;
        default:
          return true;
      }
    }).toList();
  }

  void _handleNotificationTap(notif.Notification notification, WidgetRef ref) async {
    // Mark as read if not already read
    if (!notification.isRead) {
      await ref
          .read(notificationNotifierProvider.notifier)
          .markAsRead(notification.id);
    }
    
    // Navigate if action route exists
    if (notification.actionRoute != null && context.mounted) {
      context.push(notification.actionRoute!);
    }
  }

  void _markAllAsRead(WidgetRef ref) async {
    await ref
        .read(notificationNotifierProvider.notifier)
        .markAllAsRead();
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua notifikasi ditandai dibaca'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _deleteNotification(String id, WidgetRef ref) async {
    await ref
        .read(notificationNotifierProvider.notifier)
        .deleteNotification(id);
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notifikasi dihapus'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
