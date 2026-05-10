import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';

/// ============================================================
/// 👥 PROSPECT LIST SCREEN - CRM
/// Daftar prospek untuk Sales
/// ============================================================

class ProspectListScreen extends ConsumerStatefulWidget {
  const ProspectListScreen({super.key});

  @override
  ConsumerState<ProspectListScreen> createState() => _ProspectListScreenState();
}

class _ProspectListScreenState extends ConsumerState<ProspectListScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'all'; // all, hot, warm, cold, converted, lost
  String _selectedSort = 'newest'; // newest, name, followUp

  // Dummy prospects data
  final List<Map<String, dynamic>> _prospects = [
    {
      'id': '1',
      'name': 'Budi Santoso',
      'phone': '081234567890',
      'email': 'budi@email.com',
      'address': 'Jl. Sudirman No. 123, Bandung',
      'status': 'hot',
      'source': 'Referral',
      'interest': 'TV 32 inch',
      'budget': 3000000,
      'notes': 'Berminat serius, mau visit showroom',
      'lastContact': DateTime.now().subtract(const Duration(hours: 2)),
      'nextFollowUp': DateTime.now().add(const Duration(days: 1)),
      'createdAt': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'id': '2',
      'name': 'Siti Aminah',
      'phone': '082345678901',
      'email': 'siti@email.com',
      'address': 'Jl. Dago No. 45, Bandung',
      'status': 'warm',
      'source': 'Walk-in',
      'interest': 'AKI Mobil',
      'budget': 1500000,
      'notes': 'Banding-banding harga dulu',
      'lastContact': DateTime.now().subtract(const Duration(days: 2)),
      'nextFollowUp': DateTime.now().add(const Duration(days: 3)),
      'createdAt': DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      'id': '3',
      'name': 'Ahmad Wijaya',
      'phone': '083456789012',
      'email': null,
      'address': 'Komplek Cibaduyut Indah',
      'status': 'cold',
      'source': 'Facebook Ads',
      'interest': 'HP Android',
      'budget': 2000000,
      'notes': 'Belum responsif',
      'lastContact': DateTime.now().subtract(const Duration(days: 7)),
      'nextFollowUp': DateTime.now().add(const Duration(days: 7)),
      'createdAt': DateTime.now().subtract(const Duration(days: 14)),
    },
    {
      'id': '4',
      'name': 'Dewi Kurniawati',
      'phone': '084567890123',
      'email': 'dewi@company.com',
      'address': 'Ruko Setiabudi',
      'status': 'converted',
      'source': 'Telemarketing',
      'interest': 'TV + Soundbar',
      'budget': 5000000,
      'notes': 'Sudah closing, tunggu delivery',
      'lastContact': DateTime.now().subtract(const Duration(days: 1)),
      'nextFollowUp': null,
      'createdAt': DateTime.now().subtract(const Duration(days: 10)),
    },
    {
      'id': '5',
      'name': 'Rudi Hartono',
      'phone': '085678901234',
      'email': null,
      'address': 'Perumahan Buah Batu',
      'status': 'lost',
      'source': 'Referral',
      'interest': 'Kulkas',
      'budget': 4000000,
      'notes': 'Pilih kompetitor karena harga',
      'lastContact': DateTime.now().subtract(const Duration(days: 5)),
      'nextFollowUp': null,
      'createdAt': DateTime.now().subtract(const Duration(days: 20)),
    },
  ];

  List<Map<String, dynamic>> get _filteredProspects {
    var filtered = _prospects.where((p) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final name = p['name'].toString().toLowerCase();
        final phone = p['phone'].toString().toLowerCase();
        final interest = p['interest'].toString().toLowerCase();
        if (!name.contains(query) &&
            !phone.contains(query) &&
            !interest.contains(query)) {
          return false;
        }
      }

      // Status filter
      if (_selectedFilter != 'all' && p['status'] != _selectedFilter) {
        return false;
      }

      return true;
    }).toList();

    // Sort
    switch (_selectedSort) {
      case 'newest':
        filtered.sort((a, b) =>
            (b['createdAt'] as DateTime).compareTo(a['createdAt'] as DateTime));
        break;
      case 'name':
        filtered.sort((a, b) =>
            (a['name'] as String).compareTo(b['name'] as String));
        break;
      case 'followUp':
        filtered.sort((a, b) {
          final aDate = a['nextFollowUp'] as DateTime?;
          final bDate = b['nextFollowUp'] as DateTime?;
          if (aDate == null) return 1;
          if (bDate == null) return -1;
          return aDate.compareTo(bDate);
        });
        break;
    }

    return filtered;
  }

  Map<String, int> get _statusCounts {
    return {
      'all': _prospects.length,
      'hot': _prospects.where((p) => p['status'] == 'hot').length,
      'warm': _prospects.where((p) => p['status'] == 'warm').length,
      'cold': _prospects.where((p) => p['status'] == 'cold').length,
      'converted': _prospects.where((p) => p['status'] == 'converted').length,
      'lost': _prospects.where((p) => p['status'] == 'lost').length,
    };
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
          'Data Prospek',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: _showFilterBottomSheet,
          ),
          IconButton(
            icon: const Icon(Icons.sort, color: Colors.white),
            onPressed: _showSortBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          _buildSummaryCards(),

          // Search Bar
          _buildSearchBar(),

          // Filter Chips
          _buildFilterChips(),

          // Prospects List
          Expanded(
            child: _filteredProspects.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredProspects.length,
                    itemBuilder: (context, index) {
                      return _buildProspectCard(_filteredProspects[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/sales/prospects/add'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add),
        label: const Text('Tambah Prospek'),
      ),
    );
  }

  Widget _buildSummaryCards() {
    final counts = _statusCounts;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSummaryCard(
              label: 'Total',
              value: counts['all'].toString(),
              color: Colors.white,
            ),
            _buildSummaryCard(
              label: 'Hot',
              value: counts['hot'].toString(),
              color: AppColors.error,
            ),
            _buildSummaryCard(
              label: 'Warm',
              value: counts['warm'].toString(),
              color: AppColors.warning,
            ),
            _buildSummaryCard(
              label: 'Converted',
              value: counts['converted'].toString(),
              color: AppColors.success,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
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
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadows.sm,
      ),
      child: TextField(
        onChanged: (value) => setState(() => _searchQuery = value),
        decoration: InputDecoration(
          hintText: 'Cari prospek...',
          hintStyle: TextStyle(color: AppColors.textHint),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          _buildFilterChip('Semua', 'all', '${_statusCounts['all']}'),
          const SizedBox(width: 8),
          _buildFilterChip('Hot Lead', 'hot', '${_statusCounts['hot']}'),
          const SizedBox(width: 8),
          _buildFilterChip('Warm', 'warm', '${_statusCounts['warm']}'),
          const SizedBox(width: 8),
          _buildFilterChip('Cold', 'cold', '${_statusCounts['cold']}'),
          const SizedBox(width: 8),
          _buildFilterChip('Closing', 'converted', '${_statusCounts['converted']}'),
          const SizedBox(width: 8),
          _buildFilterChip('Lost', 'lost', '${_statusCounts['lost']}'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, String count) {
    final isSelected = _selectedFilter == value;

    Color chipColor;
    switch (value) {
      case 'hot':
        chipColor = AppColors.error;
        break;
      case 'warm':
        chipColor = AppColors.warning;
        break;
      case 'cold':
        chipColor = AppColors.info;
        break;
      case 'converted':
        chipColor = AppColors.success;
        break;
      case 'lost':
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
          Text(label),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white : chipColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isSelected ? chipColor : chipColor,
              ),
            ),
          ),
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
            Icons.people_outline,
            size: 80,
            color: AppColors.textHint.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'Tidak Ada Prospek',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan prospek baru\natau ubah filter pencarian',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push('/sales/prospects/add'),
            icon: const Icon(Icons.person_add),
            label: const Text('Tambah Prospek Baru'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProspectCard(Map<String, dynamic> prospect) {
    final status = prospect['status'] as String;
    final nextFollowUp = prospect['nextFollowUp'] as DateTime?;
    final lastContact = prospect['lastContact'] as DateTime?;
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    switch (status) {
      case 'hot':
        statusColor = AppColors.error;
        statusLabel = 'Hot Lead';
        statusIcon = Icons.local_fire_department;
        break;
      case 'warm':
        statusColor = AppColors.warning;
        statusLabel = 'Warm';
        statusIcon = Icons.whatshot;
        break;
      case 'cold':
        statusColor = AppColors.info;
        statusLabel = 'Cold';
        statusIcon = Icons.ac_unit;
        break;
      case 'converted':
        statusColor = AppColors.success;
        statusLabel = 'Closing';
        statusIcon = Icons.check_circle;
        break;
      case 'lost':
        statusColor = AppColors.textHint;
        statusLabel = 'Lost';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = AppColors.primary;
        statusLabel = 'New';
        statusIcon = Icons.person;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: InkWell(
        onTap: () => _showProspectDetail(prospect),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: statusColor.withOpacity(0.1),
                    child: Icon(statusIcon, color: statusColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prospect['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          prospect['interest'],
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusLabel,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(color: AppColors.divider.withOpacity(0.5)),
              const SizedBox(height: 12),

              // Info Row
              Row(
                children: [
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.phone,
                      label: prospect['phone'],
                    ),
                  ),
                  Expanded(
                    child: _buildInfoItem(
                      icon: Icons.monetization_on,
                      label: 'Rp ${NumberFormat('#,###').format(prospect['budget'])}',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Follow up info
              if (nextFollowUp != null && status != 'converted' && status != 'lost')
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.warning.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.alarm, size: 16, color: AppColors.warning),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Follow up: ${dateFormat.format(nextFollowUp)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.warning,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              if (lastContact != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'Kontak terakhir: ${_getTimeAgo(lastContact)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textHint,
                    ),
                  ),
                ),

              // Notes
              if (prospect['notes'] != null && prospect['notes'].isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.notes, size: 14, color: AppColors.textHint),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            prospect['notes'],
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _quickCall(prospect['phone']),
                      icon: const Icon(Icons.phone, size: 16),
                      label: const Text('Telepon'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _quickWhatsApp(prospect['phone']),
                      icon: const Icon(Icons.chat, size: 16),
                      label: const Text('WhatsApp'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF25D366),
                        side: const BorderSide(color: Color(0xFF25D366)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        context.push('/sales/prospects/edit/${prospect['id']}');
                      } else if (value == 'status') {
                        _showChangeStatusDialog(prospect);
                      } else if (value == 'followup') {
                        _showAddFollowUpDialog(prospect);
                      } else if (value == 'delete') {
                        _showDeleteConfirmation(prospect);
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
                        value: 'status',
                        child: Row(
                          children: [
                            Icon(Icons.sync, size: 18),
                            SizedBox(width: 8),
                            Text('Ubah Status'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'followup',
                        child: Row(
                          children: [
                            Icon(Icons.alarm_add, size: 18),
                            SizedBox(width: 8),
                            Text('Jadwalkan Follow Up'),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textHint),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return DateFormat('dd MMM yyyy').format(dateTime);
    }
  }

  void _showProspectDetail(Map<String, dynamic> prospect) {
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
                Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Icon(Icons.person, color: AppColors.primary, size: 32),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prospect['name'],
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              prospect['source'],
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Contact Info
                _buildDetailSection(
                  title: 'Informasi Kontak',
                  items: [
                    if (prospect['phone'] != null)
                      _buildDetailItem(Icons.phone, prospect['phone']),
                    if (prospect['email'] != null)
                      _buildDetailItem(Icons.email, prospect['email']),
                    if (prospect['address'] != null)
                      _buildDetailItem(Icons.location_on, prospect['address']),
                  ],
                ),

                // Interest Info
                _buildDetailSection(
                  title: 'Minat',
                  items: [
                    _buildDetailItem(Icons.shopping_bag, prospect['interest']),
                    _buildDetailItem(
                      Icons.monetization_on,
                      'Budget: Rp ${NumberFormat('#,###').format(prospect['budget'])}',
                    ),
                  ],
                ),

                // Notes
                if (prospect['notes'] != null && prospect['notes'].isNotEmpty)
                  _buildDetailSection(
                    title: 'Catatan',
                    items: [
                      _buildDetailItem(Icons.notes, prospect['notes']),
                    ],
                  ),

                const SizedBox(height: 24),

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _quickCall(prospect['phone']),
                        icon: const Icon(Icons.phone),
                        label: const Text('Telepon'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _quickWhatsApp(prospect['phone']),
                        icon: const Icon(Icons.chat),
                        label: const Text('WhatsApp'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25D366),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildDetailSection({
    required String title,
    required List<Widget> items,
  }) {
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
            child: Column(children: items),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  void _quickCall(String phone) {
    // Launch phone dialer
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Memanggil $phone...')),
    );
  }

  void _quickWhatsApp(String phone) {
    // Launch WhatsApp
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Membuka WhatsApp $phone...')),
    );
  }

  void _showFilterBottomSheet() {
    // Show filter options
  }

  void _showSortBottomSheet() {
    // Show sort options
  }

  void _showChangeStatusDialog(Map<String, dynamic> prospect) {
    // Show status change dialog
  }

  void _showAddFollowUpDialog(Map<String, dynamic> prospect) {
    // Show follow up scheduling dialog
  }

  void _showDeleteConfirmation(Map<String, dynamic> prospect) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Prospek?'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${prospect['name']} dari daftar prospek?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _prospects.removeWhere((p) => p['id'] == prospect['id']);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('🗑️ Prospek dihapus'),
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
