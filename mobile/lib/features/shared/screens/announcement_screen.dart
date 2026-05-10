import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:te_superapp/core/theme/app_theme.dart';

/// ============================================================
/// 📢 ANNOUNCEMENT SCREEN
/// Pengumuman perusahaan dari Owner/Admin
/// ============================================================

class AnnouncementScreen extends ConsumerStatefulWidget {
  const AnnouncementScreen({super.key});

  @override
  ConsumerState<AnnouncementScreen> createState() => _AnnouncementScreenState();
}

class _AnnouncementScreenState extends ConsumerState<AnnouncementScreen> {
  String _selectedCategory = 'all'; // all, general, policy, event, urgent

  // Dummy announcements
  final List<Map<String, dynamic>> _announcements = [
    {
      'id': '1',
      'title': 'Libur Hari Raya Idul Fitri',
      'content': 'Diumumkan kepada seluruh karyawan bahwa perusahaan akan libur pada tanggal 10-14 April 2024 dalam rangka Hari Raya Idul Fitri 1445 H. Selamat berlebaran! Mohon maaf lahir dan batin.',
      'category': 'event',
      'priority': 'high',
      'author': {'name': 'Pak Iwan', 'role': 'Owner', 'avatar': 'PI'},
      'createdAt': DateTime.now().subtract(const Duration(days: 2)),
      'views': 156,
      'isRead': true,
      'attachments': [],
    },
    {
      'id': '2',
      'title': 'Perubahan Kebijakan Cuti Tahunan',
      'content': 'Mulai tanggal 1 Mei 2024, kebijakan cuti tahunan mengalami perubahan:\n\n• Cuti tahunan maksimal 12 hari kerja\n• Minimal pengajuan 3 hari sebelumnya\n• Approval dari Kepala Cabang wajib\n• Cuti tidak bisa diuangkan\n\nMohon dipahami dan ditaati. Terima kasih.',
      'category': 'policy',
      'priority': 'high',
      'author': {'name': 'HR Department', 'role': 'Admin', 'avatar': 'HR'},
      'createdAt': DateTime.now().subtract(const Duration(days: 5)),
      'views': 245,
      'isRead': false,
      'attachments': ['Kebijakan_Cuti_2024.pdf'],
    },
    {
      'id': '3',
      'title': 'Team Building Akhir Tahun',
      'content': 'Halo team! Kita akan mengadakan team building pada tanggal 20-21 Juli 2024 di Lembang, Bandung. Acara ini wajib diikuti oleh seluruh karyawan.\n\nAgenda:\n• Outbound activities\n• Barbecue party\n• Awarding session\n\nPendaftaran: hubungi HRD paling lambat 15 Juli.',
      'category': 'event',
      'priority': 'normal',
      'author': {'name': 'Eka Putri', 'role': 'Admin', 'avatar': 'EP'},
      'createdAt': DateTime.now().subtract(const Duration(days: 8)),
      'views': 189,
      'isRead': false,
      'attachments': [],
    },
    {
      'id': '4',
      'title': 'Pemeliharaan Server Maintenance',
      'content': 'Akan dilakukan maintenance server pada hari Minggu, 12 Mei 2024 pukul 00:00 - 06:00 WIB. Selama maintenance, aplikasi mungkin tidak dapat diakses. Mohon maaf atas ketidaknyamanannya.',
      'category': 'urgent',
      'priority': 'urgent',
      'author': {'name': 'IT Support', 'role': 'Admin', 'avatar': 'IT'},
      'createdAt': DateTime.now().subtract(const Duration(hours: 5)),
      'views': 89,
      'isRead': false,
      'attachments': [],
    },
    {
      'id': '5',
      'title': 'Selamat kepada Tim Sales Bandung!',
      'content': 'Tim Sales Bandung berhasil mencapai target Q1 2024 dengan penjualan 150% dari target! 🎉\n\nTop Performers:\n🥇 Ahmad Santoso - Rp 2.5M\n🥈 Budi Wijaya - Rp 2.1M\n🥉 Citra Dewi - Rp 1.8M\n\nBonus akan dibayarkan bersama gaji bulan ini.',
      'category': 'general',
      'priority': 'normal',
      'author': {'name': 'Pak Iwan', 'role': 'Owner', 'avatar': 'PI'},
      'createdAt': DateTime.now().subtract(const Duration(days: 12)),
      'views': 312,
      'isRead': true,
      'attachments': [],
    },
  ];

  final List<Map<String, dynamic>> _categories = [
    {'id': 'all', 'name': 'Semua', 'icon': Icons.all_inclusive, 'color': AppColors.primary},
    {'id': 'general', 'name': 'Umum', 'icon': Icons.info, 'color': Colors.blue},
    {'id': 'policy', 'name': 'Kebijakan', 'icon': Icons.policy, 'color': Colors.orange},
    {'id': 'event', 'name': 'Acara', 'icon': Icons.event, 'color': Colors.green},
    {'id': 'urgent', 'name': 'Darurat', 'icon': Icons.warning, 'color': Colors.red},
  ];

  List<Map<String, dynamic>> get _filteredAnnouncements {
    if (_selectedCategory == 'all') return _announcements;
    return _announcements.where((a) => a['category'] == _selectedCategory).toList();
  }

  int get _unreadCount {
    return _announcements.where((a) => !a['isRead']).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Pengumuman',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          if (_unreadCount > 0)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                '$_unreadCount belum dibaca',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category['id'];
                final color = category['color'] as Color;

                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = category['id']),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? color : AppColors.surface,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ] : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          category['icon'],
                          size: 18,
                          color: isSelected ? Colors.white : color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category['name'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Announcements List
          Expanded(
            child: _filteredAnnouncements.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredAnnouncements.length,
                    itemBuilder: (context, index) {
                      return _buildAnnouncementCard(_filteredAnnouncements[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateAnnouncementDialog(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Buat Pengumuman'),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.campaign_outlined,
            size: 80,
            color: AppColors.textHint.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak Ada Pengumuman',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Belum ada pengumuman di kategori ini',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementCard(Map<String, dynamic> announcement) {
    final category = _categories.firstWhere((c) => c['id'] == announcement['category']);
    final color = category['color'] as Color;
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');
    final isRead = announcement['isRead'] as bool;
    final priority = announcement['priority'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: InkWell(
        onTap: () => _showAnnouncementDetail(announcement),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with color indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      category['icon'],
                      color: color,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 12,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          dateFormat.format(announcement['createdAt']),
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (priority == 'urgent')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.priority_high, size: 14, color: Colors.red),
                          const SizedBox(width: 2),
                          Text(
                            'URGENT',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!isRead)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    announcement['title'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    announcement['content'],
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),

                  // Attachments
                  if ((announcement['attachments'] as List).isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.attach_file, size: 16, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          '${(announcement['attachments'] as List).length} lampiran',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 12),

                  // Footer
                  Row(
                    children: [
                      // Author
                      CircleAvatar(
                        radius: 14,
                        backgroundColor: AppColors.primary.withOpacity(0.2),
                        child: Text(
                          announcement['author']['avatar'],
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              announcement['author']['name'],
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              announcement['author']['role'],
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Views
                      Icon(Icons.visibility, size: 16, color: AppColors.textHint),
                      const SizedBox(width: 4),
                      Text(
                        '${announcement['views']}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textHint,
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
    );
  }

  void _showAnnouncementDetail(Map<String, dynamic> announcement) {
    // Mark as read
    if (!announcement['isRead']) {
      setState(() => announcement['isRead'] = true);
    }

    final category = _categories.firstWhere((c) => c['id'] == announcement['category']);
    final color = category['color'] as Color;
    final dateFormat = DateFormat('EEEE, dd MMMM yyyy, HH:mm', 'id_ID');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: ListView(
              controller: scrollController,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Category Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(category['icon'], size: 16, color: color),
                      const SizedBox(width: 6),
                      Text(
                        category['name'],
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Title
                Text(
                  announcement['title'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 8),

                // Date
                Text(
                  dateFormat.format(announcement['createdAt']),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),

                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),

                // Content
                Text(
                  announcement['content'],
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.8,
                  ),
                ),

                // Attachments
                if ((announcement['attachments'] as List).isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  _buildDetailSection('Lampiran', [
                    ...((announcement['attachments'] as List).map((file) =>
                      _buildAttachmentRow(file),
                    )),
                  ]),
                ],

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),

                // Author
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      child: Text(
                        announcement['author']['avatar'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Diposting oleh',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textHint,
                            ),
                          ),
                          Text(
                            announcement['author']['name'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            announcement['author']['role'],
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.visibility, size: 18, color: AppColors.textHint),
                            const SizedBox(width: 4),
                            Text(
                              '${announcement['views']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textHint,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'dibaca',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.textHint,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Share
                        },
                        icon: const Icon(Icons.share),
                        label: const Text('Bagikan'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.check),
                        label: const Text('Tutup'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.textHint,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildAttachmentRow(String filename) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Icon(Icons.insert_drive_file, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              filename,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download, color: AppColors.primary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void _showCreateAnnouncementDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Buat Pengumuman'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Fitur ini tersedia untuk Owner, Admin, dan Kepala Cabang.'),
            SizedBox(height: 8),
            Text('Anda akan dialihkan ke halaman pembuatan pengumuman.'),
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
              // Navigate to create announcement
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Lanjutkan'),
          ),
        ],
      ),
    );
  }
}
