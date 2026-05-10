import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';

/// ============================================================
/// 📢 CAMPAIGN LIST SCREEN
/// Daftar kampanye marketing untuk Sales
/// ============================================================

class CampaignListScreen extends ConsumerStatefulWidget {
  const CampaignListScreen({super.key});

  @override
  ConsumerState<CampaignListScreen> createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends ConsumerState<CampaignListScreen> {
  String _selectedFilter = 'all'; // all, active, scheduled, completed

  // Dummy campaigns
  final List<Map<String, dynamic>> _campaigns = [
    {
      'id': '1',
      'name': 'Mega Sale Lebaran',
      'description': 'Diskon hingga 50% untuk semua produk elektronik',
      'type': 'Discount',
      'status': 'active',
      'startDate': DateTime.now().subtract(const Duration(days: 5)),
      'endDate': DateTime.now().add(const Duration(days: 10)),
      'targetAudience': 'Semua Pelanggan',
      'budget': 50000000,
      'leadsGenerated': 245,
      'conversions': 89,
      'channels': ['WhatsApp', 'Facebook', 'Instagram'],
      'createdBy': 'Pak Iwan',
      'branchId': '1',
    },
    {
      'id': '2',
      'name': 'Program Cicilan 0%',
      'description': 'Cicilan 0% DP untuk TV dan Kulkas',
      'type': 'Promo',
      'status': 'active',
      'startDate': DateTime.now().subtract(const Duration(days: 10)),
      'endDate': DateTime.now().add(const Duration(days: 20)),
      'targetAudience': 'Karyawan Swasta',
      'budget': 30000000,
      'leadsGenerated': 189,
      'conversions': 56,
      'channels': ['WhatsApp', 'Flyer'],
      'createdBy': 'Sales Team',
      'branchId': '1',
    },
    {
      'id': '3',
      'name': 'Bundle Akhir Tahun',
      'description': 'Beli TV gratis Soundbar',
      'type': 'Bundle',
      'status': 'scheduled',
      'startDate': DateTime.now().add(const Duration(days: 15)),
      'endDate': DateTime.now().add(const Duration(days: 45)),
      'targetAudience': 'High-End Customers',
      'budget': 25000000,
      'leadsGenerated': 0,
      'conversions': 0,
      'channels': ['Email', 'Instagram', 'TikTok'],
      'createdBy': 'Marketing',
      'branchId': '1',
    },
    {
      'id': '4',
      'name': 'Flash Sale Weekend',
      'description': 'Diskon 30% khusus weekend',
      'type': 'Flash Sale',
      'status': 'completed',
      'startDate': DateTime.now().subtract(const Duration(days: 20)),
      'endDate': DateTime.now().subtract(const Duration(days: 15)),
      'targetAudience': 'Online Customers',
      'budget': 15000000,
      'leadsGenerated': 420,
      'conversions': 156,
      'channels': ['Shopee', 'Tokopedia', 'WhatsApp'],
      'createdBy': 'Admin',
      'branchId': '1',
    },
    {
      'id': '5',
      'name': 'Trade-In Program',
      'description': 'Tukar tambah TV lama dengan yang baru',
      'type': 'Trade-In',
      'status': 'draft',
      'startDate': DateTime.now().add(const Duration(days: 30)),
      'endDate': DateTime.now().add(const Duration(days: 60)),
      'targetAudience': 'Existing Customers',
      'budget': 20000000,
      'leadsGenerated': 0,
      'conversions': 0,
      'channels': ['SMS', 'WhatsApp'],
      'createdBy': 'Pak Iwan',
      'branchId': '1',
    },
  ];

  List<Map<String, dynamic>> get _filteredCampaigns {
    if (_selectedFilter == 'all') return _campaigns;
    return _campaigns.where((c) => c['status'] == _selectedFilter).toList();
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
          'Kampanye Marketing',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          _buildSummaryCards(),

          // Filter Chips
          _buildFilterChips(),

          // Campaign List
          Expanded(
            child: _filteredCampaigns.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredCampaigns.length,
                    itemBuilder: (context, index) {
                      return _buildCampaignCard(_filteredCampaigns[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/sales/campaigns/add'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Buat Kampanye'),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final active = _campaigns.where((c) => c['status'] == 'active').length;
    final scheduled = _campaigns.where((c) => c['status'] == 'scheduled').length;
    final completed = _campaigns.where((c) => c['status'] == 'completed').length;
    final totalLeads = _campaigns.fold(0, (sum, c) => sum + (c['leadsGenerated'] as int));

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          _buildSummaryItem(
            label: 'Aktif',
            value: '$active',
            color: AppColors.success,
          ),
          _buildSummaryItem(
            label: 'Terjadwal',
            value: '$scheduled',
            color: AppColors.warning,
          ),
          _buildSummaryItem(
            label: 'Selesai',
            value: '$completed',
            color: AppColors.info,
          ),
          _buildSummaryItem(
            label: 'Total Leads',
            value: '$totalLeads',
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('Semua', 'all', Icons.all_inclusive),
          const SizedBox(width: 8),
          _buildFilterChip('Aktif', 'active', Icons.play_circle_fill),
          const SizedBox(width: 8),
          _buildFilterChip('Terjadwal', 'scheduled', Icons.schedule),
          const SizedBox(width: 8),
          _buildFilterChip('Selesai', 'completed', Icons.check_circle),
          const SizedBox(width: 8),
          _buildFilterChip('Draft', 'draft', Icons.edit),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, IconData icon) {
    final isSelected = _selectedFilter == value;

    Color chipColor;
    switch (value) {
      case 'active':
        chipColor = AppColors.success;
        break;
      case 'scheduled':
        chipColor = AppColors.warning;
        break;
      case 'completed':
        chipColor = AppColors.info;
        break;
      case 'draft':
        chipColor = AppColors.textHint;
        break;
      default:
        chipColor = AppColors.primary;
    }

    return FilterChip(
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _selectedFilter = value);
      },
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selectedColor: chipColor.withOpacity(0.1),
      checkmarkColor: chipColor,
      labelStyle: TextStyle(
        color: isSelected ? chipColor : AppColors.textPrimary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
            'Tidak Ada Kampanye',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Buat kampanye pertama Anda',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/sales/campaigns/add'),
            icon: const Icon(Icons.add),
            label: const Text('Buat Kampanye'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampaignCard(Map<String, dynamic> campaign) {
    final status = campaign['status'] as String;
    final dateFormat = DateFormat('dd MMM yyyy', 'id_ID');

    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    switch (status) {
      case 'active':
        statusColor = AppColors.success;
        statusLabel = 'Berjalan';
        statusIcon = Icons.play_circle_fill;
        break;
      case 'scheduled':
        statusColor = AppColors.warning;
        statusLabel = 'Terjadwal';
        statusIcon = Icons.schedule;
        break;
      case 'completed':
        statusColor = AppColors.info;
        statusLabel = 'Selesai';
        statusIcon = Icons.check_circle;
        break;
      case 'draft':
        statusColor = AppColors.textHint;
        statusLabel = 'Draft';
        statusIcon = Icons.edit;
        break;
      default:
        statusColor = AppColors.primary;
        statusLabel = status;
        statusIcon = Icons.info;
    }

    final conversionRate = campaign['leadsGenerated'] > 0
        ? (campaign['conversions'] / campaign['leadsGenerated'] * 100).toStringAsFixed(1)
        : '0.0';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: InkWell(
        onTap: () => _showCampaignDetail(campaign),
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(statusIcon, color: statusColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          campaign['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                statusLabel,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                campaign['type'],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        context.push('/sales/campaigns/edit/${campaign['id']}');
                      } else if (value == 'duplicate') {
                        _duplicateCampaign(campaign);
                      } else if (value == 'delete') {
                        _showDeleteConfirmation(campaign);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'duplicate',
                        child: Row(
                          children: [
                            Icon(Icons.copy, size: 18),
                            SizedBox(width: 8),
                            Text('Duplikat'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: AppColors.error),
                            SizedBox(width: 8),
                            Text('Hapus', style: TextStyle(color: AppColors.error)),
                          ],
                        ),
                      ),
                    ],
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
                    campaign['description'],
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 16),

                  // Date Range
                  Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        size: 16,
                        color: AppColors.textHint,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${dateFormat.format(campaign['startDate'])} - ${dateFormat.format(campaign['endDate'])}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textHint,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Channels
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: (campaign['channels'] as List<String>)
                        .map((channel) => _buildChannelChip(channel))
                        .toList(),
                  ),

                  const SizedBox(height: 16),

                  // Stats
                  if (campaign['leadsGenerated'] > 0) ...[
                    const Divider(height: 1),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            icon: Icons.people,
                            label: 'Leads',
                            value: '${campaign['leadsGenerated']}',
                            color: AppColors.info,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            icon: Icons.check_circle,
                            label: 'Closing',
                            value: '${campaign['conversions']}',
                            color: AppColors.success,
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            icon: Icons.trending_up,
                            label: 'Konversi',
                            value: '$conversionRate%',
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelChip(String channel) {
    IconData icon;
    switch (channel.toLowerCase()) {
      case 'whatsapp':
        icon = Icons.chat;
        break;
      case 'facebook':
        icon = Icons.facebook;
        break;
      case 'instagram':
        icon = Icons.camera_alt;
        break;
      case 'email':
        icon = Icons.email;
        break;
      case 'sms':
        icon = Icons.sms;
        break;
      default:
        icon = Icons.campaign;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textHint),
          const SizedBox(width: 4),
          Text(
            channel,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textHint,
          ),
        ),
      ],
    );
  }

  void _showCampaignDetail(Map<String, dynamic> campaign) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          final dateFormat = DateFormat('EEEE, dd MMMM yyyy', 'id_ID');

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

                // Header
                Text(
                  campaign['name'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 16),

                // Details
                _buildDetailSection('Informasi Kampanye', [
                  _buildDetailRow(Icons.category, 'Tipe', campaign['type']),
                  _buildDetailRow(Icons.business, 'Cabang', campaign['branchId']),
                  _buildDetailRow(Icons.person, 'Dibuat Oleh', campaign['createdBy']),
                  _buildDetailRow(Icons.people_outline, 'Target', campaign['targetAudience']),
                ]),

                _buildDetailSection('Periode', [
                  _buildDetailRow(Icons.play_arrow, 'Mulai', dateFormat.format(campaign['startDate'])),
                  _buildDetailRow(Icons.stop, 'Selesai', dateFormat.format(campaign['endDate'])),
                ]),

                _buildDetailSection('Budget & Hasil', [
                  _buildDetailRow(
                    Icons.account_balance_wallet,
                    'Budget',
                    'Rp ${NumberFormat('#,###').format(campaign['budget'])}',
                  ),
                  if (campaign['leadsGenerated'] > 0) ...[
                    _buildDetailRow(Icons.people, 'Leads Generated', '${campaign['leadsGenerated']}'),
                    _buildDetailRow(Icons.check_circle, 'Conversions', '${campaign['conversions']}'),
                  ],
                ]),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => context.pop(),
                        icon: const Icon(Icons.close),
                        label: const Text('Tutup'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          context.pop();
                          context.push('/sales/campaigns/edit/${campaign['id']}');
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    // Show filter options
  }

  void _duplicateCampaign(Map<String, dynamic> campaign) {
    // Duplicate campaign logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ Kampanye "${campaign['name']}" diduplikat'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> campaign) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Kampanye?'),
        content: Text(
          'Apakah Anda yakin ingin menghapus kampanye "${campaign['name']}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _campaigns.removeWhere((c) => c['id'] == campaign['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🗑️ Kampanye dihapus'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
