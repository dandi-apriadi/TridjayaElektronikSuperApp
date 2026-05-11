import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/sales_models.dart';
import '../providers/sales_provider.dart';
import '../../../../shared/widgets/stat_card.dart';

class ProspectScreen extends ConsumerStatefulWidget {
  const ProspectScreen({super.key});

  @override
  ConsumerState<ProspectScreen> createState() => _ProspectScreenState();
}

class _ProspectScreenState extends ConsumerState<ProspectScreen> {
  String _selectedStatus = 'Semua';
  final _searchCtrl = TextEditingController();
  final List<String> _statuses = ['Semua', 'New', 'Contacted', 'Negotiation', 'Closed', 'Lost'];

  List<Prospect> _filteredProspects(List<Prospect> prospects) {
    return prospects.where((p) {
      final matchStatus = _selectedStatus == 'Semua' || p.status.toLowerCase() == _selectedStatus.toLowerCase();
      final query = _searchCtrl.text.toLowerCase();
      final matchSearch = query.isEmpty ||
          p.name.toLowerCase().contains(query) ||
          p.phone.toLowerCase().contains(query);
      return matchStatus && matchSearch;
    }).toList();
  }

  Color _statusColor(String s) {
    switch (s.toLowerCase()) {
      case 'new': return AppColors.info;
      case 'contacted': return AppColors.primary;
      case 'negotiation': return AppColors.warning;
      case 'closed': return AppColors.success;
      case 'lost': return AppColors.error;
      default: return AppColors.textSecondary;
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prospectsAsync = ref.watch(prospectsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddProspectSheet(context),
        icon: const Icon(Icons.person_add_outlined),
        label: const Text('Tambah Prospek'),
        backgroundColor: AppColors.salesColor,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.salesColor,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            title: const Text('Manajemen Prospek', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
            iconTheme: const IconThemeData(color: Colors.white),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Container(
                color: AppColors.surface,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Cari nama atau nomor...',
                    prefixIcon: const Icon(Icons.search_rounded, size: 20),
                    suffixIcon: _searchCtrl.text.isNotEmpty
                        ? IconButton(icon: const Icon(Icons.clear_rounded, size: 18), onPressed: () { _searchCtrl.clear(); setState(() {}); })
                        : null,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    filled: true,
                    fillColor: AppColors.surfaceVariant,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.salesColor, width: 1.5)),
                  ),
                ),
              ),
            ),
          ),
        ],
        body: prospectsAsync.when(
          data: (prospects) {
            final filtered = _filteredProspects(prospects);
            return Column(children: [
              _buildSummaryRow(prospects),
              _buildStatusFilter(prospects),
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmpty()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => _buildProspectCard(context, filtered[i]),
                      ),
              ),
            ]);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => Center(child: Text('Gagal memuat prospek: $error')),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(List<Prospect> all) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(children: [
        Expanded(child: StatCard(title: 'Total', value: '${all.length}', icon: Icons.people_outline_rounded, color: AppColors.salesColor)),
        const SizedBox(width: 8),
        Expanded(child: StatCard(title: 'Aktif', value: '${all.where((p) => p.status != "closed" && p.status != "lost").length}', icon: Icons.trending_up_rounded, color: AppColors.info)),
        const SizedBox(width: 8),
        Expanded(child: StatCard(title: 'Closed', value: '${all.where((p) => p.status == "closed").length}', icon: Icons.check_circle_outline, color: AppColors.success)),
      ]),
    );
  }

  Widget _buildStatusFilter(List<Prospect> prospects) {
    final counts = {
      'Semua': prospects.length,
      'New': prospects.where((p) => p.status == 'new').length,
      'Contacted': prospects.where((p) => p.status == 'contacted').length,
      'Negotiation': prospects.where((p) => p.status == 'negotiation').length,
      'Closed': prospects.where((p) => p.status == 'closed').length,
      'Lost': prospects.where((p) => p.status == 'lost').length,
    };
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: SizedBox(
        height: 34,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _statuses.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final s = _statuses[i];
            final isSelected = _selectedStatus == s;
            final chipColor = s == 'Semua' ? AppColors.salesColor : _statusColor(s);
            return GestureDetector(
              onTap: () => setState(() => _selectedStatus = s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? chipColor : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(s, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textSecondary)),
                  const SizedBox(width: 4),
                  Text('(${counts[s] ?? 0})', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textHint)),
                ]),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProspectCard(BuildContext context, Prospect p) {
    final sc = _statusColor(p.status);
    return GestureDetector(
      onTap: () => _showProspectDetail(context, p),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppShadows.sm,
          border: Border.all(color: sc.withOpacity(0.2)),
        ),
        child: Row(children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: sc.withOpacity(0.12), shape: BoxShape.circle),
            child: Center(child: Text(p.name[0], style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: sc))),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(p.name, style: AppTextStyles.bodyMedium),
            const SizedBox(height: 3),
            Row(children: [
              const Icon(Icons.phone_outlined, size: 12, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text(p.phone, style: AppTextStyles.caption),
            ]),
            const SizedBox(height: 2),
            Row(children: [
              const Icon(Icons.inventory_2_outlined, size: 12, color: AppColors.textHint),
              const SizedBox(width: 4),
              Text(p.productInterest ?? '-', style: AppTextStyles.caption),
            ]),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            StatusBadge(label: p.status, color: sc),
            const SizedBox(height: 8),
            Row(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                onTap: () => _showContactOptions(context, p),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(color: AppColors.success.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.phone_rounded, size: 16, color: AppColors.success),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () => _showEditProspect(context, p),
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(color: AppColors.info.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.edit_outlined, size: 16, color: AppColors.info),
                ),
              ),
            ]),
          ]),
        ]),
      ),
    );
  }

  void _showProspectDetail(BuildContext context, Prospect p) {
    final sc = _statusColor(p.status);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          Row(children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(color: sc.withOpacity(0.12), shape: BoxShape.circle),
              child: Center(child: Text(p.name[0], style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: sc))),
            ),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.name, style: AppTextStyles.heading3),
              const SizedBox(height: 4),
              StatusBadge(label: p.status, color: sc),
            ])),
          ]),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              _detailRow(Icons.phone_outlined, 'Telepon', p.phone),
              const Divider(height: 14),
              _detailRow(Icons.inventory_2_outlined, 'Minat Produk', p.productInterest ?? '-'),
              const Divider(height: 14),
              _detailRow(Icons.business_outlined, 'Cabang', 'Cabang Pusat'),
            ]),
          ),
          const SizedBox(height: 16),
          Text('Ubah Status', style: AppTextStyles.subtitle),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8, children: ['New', 'Contacted', 'Negotiation', 'Closed', 'Lost'].map((s) =>
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Status diubah ke $s'), behavior: SnackBarBehavior.floating));
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: p.status == s ? _statusColor(s) : _statusColor(s).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(s, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: p.status == s ? Colors.white : _statusColor(s))),
              ),
            )).toList(),
          ),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [
        Icon(icon, size: 16, color: AppColors.textHint),
        const SizedBox(width: 8),
        Text('$label: ', style: AppTextStyles.caption),
        Text(value, style: AppTextStyles.bodyMedium),
      ]),
    );
  }

  Widget _buildEmpty() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.people_outline_rounded, size: 56, color: AppColors.textHint),
      const SizedBox(height: 12),
      Text('Tidak ada prospek $_selectedStatus', style: AppTextStyles.body.copyWith(color: AppColors.textSecondary)),
    ]));
  }

  void _showEditProspect(BuildContext context, Prospect p) {
    _showAddProspectSheet(context, prospect: p);
  }

  void _showContactOptions(BuildContext context, Prospect p) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'Hubungi ${p.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.phone,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.phone, color: AppColors.success),
              title: const Text('Telepon'),
              subtitle: const Text('Hubungi via panggilan telepon'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Menelepon ${p.phone}...'), behavior: SnackBarBehavior.floating),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.message, color: AppColors.info),
              title: const Text('SMS'),
              subtitle: const Text('Kirim pesan SMS'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka aplikasi SMS...'), behavior: SnackBarBehavior.floating),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble, color: Color(0xFF25D366)),
              title: const Text('WhatsApp'),
              subtitle: const Text('Chat via WhatsApp'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuka WhatsApp...'), behavior: SnackBarBehavior.floating),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.content_copy, color: AppColors.textHint),
              title: const Text('Salin Nomor'),
              subtitle: const Text('Salin nomor ke clipboard'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Nomor telepon disalin'),
                    backgroundColor: AppColors.success,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAddProspectSheet(BuildContext context, {Prospect? prospect}) {
    final nameCtrl = TextEditingController(text: prospect?.name);
    final phoneCtrl = TextEditingController(text: prospect?.phone);
    String selectedProduct = prospect?.productInterest ?? 'Aki';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(ctx).viewInsets.bottom + 24),
        child: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 20),
            Text(prospect == null ? 'Tambah Prospek Baru' : 'Edit Prospek', style: AppTextStyles.heading3),
            const SizedBox(height: 16),
            TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama Lengkap', prefixIcon: Icon(Icons.person_outline_rounded))),
            const SizedBox(height: 12),
            TextFormField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: 'Nomor WhatsApp', prefixIcon: Icon(Icons.phone_outlined))),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: selectedProduct,
              decoration: const InputDecoration(labelText: 'Minat Produk'),
              items: ['Aki', 'TV', 'HP'].map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
              onChanged: (v) => selectedProduct = v!,
            ),
            const SizedBox(height: 12),
            TextFormField(maxLines: 3, decoration: const InputDecoration(labelText: 'Catatan (opsional)', hintText: 'Informasi tambahan tentang prospek...')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(prospect == null ? 'Prospek berhasil ditambahkan' : 'Prospek berhasil diperbarui'),
                    backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating,
                  ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.salesColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: Text(prospect == null ? 'Tambah Prospek' : 'Simpan Perubahan'),
              ),
            ),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
  }
}
