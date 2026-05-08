import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _selectedFilter = 'Semua';
  final List<String> _filters = ['Semua', 'Tugas', 'Sistem', 'Laporan'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Notifikasi', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: () => _markAllAsRead(),
            child: const Text('Tandai Baca', style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: AppTextStyles.bodyMedium,
          tabs: const [
            Tab(text: 'Semua'),
            Tab(text: 'Belum Dibaca'),
          ],
        ),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationList(showUnreadOnly: false),
                _buildNotificationList(showUnreadOnly: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _filters.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final filter = _filters[i];
            final isSelected = _selectedFilter == filter;
            return GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationList({required bool showUnreadOnly}) {
    final notifications = _getDummyNotifications()
        .where((n) => !showUnreadOnly || !n.isRead)
        .where((n) => _selectedFilter == 'Semua' || n.category == _selectedFilter)
        .toList();

    if (notifications.isEmpty) {
      return _buildEmptyState(showUnreadOnly);
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notifications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) => _buildNotificationCard(notifications[i]),
    );
  }

  Widget _buildNotificationCard(_NotificationItem notification) {
    final iconData = _getCategoryIcon(notification.category);
    final iconColor = _getCategoryColor(notification.category);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) => _deleteNotification(notification.id),
      child: GestureDetector(
        onTap: () => _handleNotificationTap(notification),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notification.isRead ? AppColors.surface : AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: notification.isRead
                ? null
                : Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(iconData, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: AppTextStyles.caption,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      notification.timeAgo,
                      style: AppTextStyles.caption.copyWith(
                        fontSize: 11,
                        color: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isUnreadTab) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isUnreadTab ? Icons.mark_email_read_outlined : Icons.notifications_none_outlined,
            size: 64,
            color: AppColors.textHint,
          ),
          const SizedBox(height: 16),
          Text(
            isUnreadTab ? 'Tidak ada notifikasi belum dibaca' : 'Tidak ada notifikasi',
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 8),
          Text(
            isUnreadTab ? 'Semua notifikasi sudah dibaca' : 'Notifikasi akan muncul di sini',
            style: AppTextStyles.caption,
          ),
        ],
      ),
    );
  }

  void _handleNotificationTap(_NotificationItem notification) {
    setState(() {
      notification.isRead = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📩 ${notification.title}'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _markAllAsRead() {
    setState(() {
      for (final n in _getDummyNotifications()) {
        n.isRead = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ Semua notifikasi ditandai sudah dibaca'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _deleteNotification(String id) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('🗑️ Notifikasi dihapus'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Batal',
          onPressed: () {
            // Undo delete logic
          },
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Tugas':
        return Icons.assignment_outlined;
      case 'Sistem':
        return Icons.info_outline;
      case 'Laporan':
        return Icons.description_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Tugas':
        return AppColors.warning;
      case 'Sistem':
        return AppColors.info;
      case 'Laporan':
        return AppColors.success;
      default:
        return AppColors.primary;
    }
  }

  List<_NotificationItem> _getDummyNotifications() {
    return [
      _NotificationItem(
        id: '1',
        title: 'Tugas Baru',
        message: 'Anda mendapatkan tugas follow-up prospek dari Kepala Cabang',
        category: 'Tugas',
        timeAgo: '5 menit lalu',
        isRead: false,
      ),
      _NotificationItem(
        id: '2',
        title: 'Stok Rendah',
        message: 'Aki GS NS40 hanya tersisa 3 unit di Cabang Pusat',
        category: 'Sistem',
        timeAgo: '1 jam lalu',
        isRead: false,
      ),
      _NotificationItem(
        id: '3',
        title: 'Laporan Disetujui',
        message: 'Laporan harian Anda tanggal 8 Mei telah disetujui',
        category: 'Laporan',
        timeAgo: '3 jam lalu',
        isRead: true,
      ),
      _NotificationItem(
        id: '4',
        title: 'Prospek Baru',
        message: 'Anda memiliki prospek baru: Budi Santoso - HP Xiaomi',
        category: 'Tugas',
        timeAgo: '5 jam lalu',
        isRead: true,
      ),
      _NotificationItem(
        id: '5',
        title: 'Pengingat Check-in',
        message: 'Jangan lupa check-in sebelum jam 09:00',
        category: 'Sistem',
        timeAgo: '1 hari lalu',
        isRead: true,
      ),
    ];
  }
}

class _NotificationItem {
  final String id;
  final String title;
  final String message;
  final String category;
  final String timeAgo;
  bool isRead;

  _NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.category,
    required this.timeAgo,
    this.isRead = false,
  });
}
