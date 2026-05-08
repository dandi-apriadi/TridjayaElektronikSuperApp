import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/dummy_data/dummy_data.dart';
import '../../../../shared/widgets/stat_card.dart';

class ProspectScreen extends StatefulWidget {
  const ProspectScreen({super.key});

  @override
  State<ProspectScreen> createState() => _ProspectScreenState();
}

class _ProspectScreenState extends State<ProspectScreen> {
  String _selectedStatus = 'Semua';
  final _searchCtrl = TextEditingController();
  final List<String> _statuses = ['Semua', 'New', 'Contacted', 'Negotiation', 'Closed', 'Lost'];

  Color _statusColor(String s) {
    switch (s) {
      case 'New': return AppColors.info;
      case 'Contacted': return AppColors.primary;
      case 'Negotiation': return AppColors.warning;
      case 'Closed': return AppColors.success;
      case 'Lost': return AppColors.error;
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
    var prospects = DummyDataProvider.prospects.toList();
    if (_selectedStatus != 'Semua') {
      prospects = prospects.where((p) => p.status == _selectedStatus).toList();
    }
    if (_searchCtrl.text.isNotEmpty) {
      prospects = prospects.where((p) =>
          p.name.toLowerCase().contains(_searchCtrl.text.toLowerCase()) ||
          p.phone.contains(_searchCtrl.text)).toList();
    }

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
        body: Column(children: [
          _buildSummaryRow(),
          _buildStatusFilter(),
          Expanded(
            child: prospects.isEmpty
                ? _buildEmpty()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: prospects.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) => _buildProspectCard(context, prospects[i]),
                  ),
          ),
        ]),
      ),
    );
  }

  Widget _buildSummaryRow() {
    final all = DummyDataProvider.prospects;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(children: [
        Expanded(child: StatCard(title: 'Total', value: '${all.length}', icon: Icons.people_outline_rounded, color: AppColors.salesColor)),
        const SizedBox(width: 8),
        Expanded(child: StatCard(title: 'Aktif', value: '${all.where((p) => p.status != "Closed" && p.status != "Lost").length}', icon: Icons.trending_up_rounded, color: AppColors.info)),
        const SizedBox(width: 8),
        Expanded(child: StatCard(title: 'Closed', value: '${all.where((p) => p.status == "Closed").length}', icon: Icons.check_circle_outline, color: AppColors.success)),
      ]),
    );
  }

  Widget _buildStatusFilter() {
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
                child: Text(s, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textSecondary)),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProspectCard(BuildContext context, DummyProspect p) {
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
              Text(p.productInterest, style: AppTextStyles.caption),
            ]),
          ])),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            StatusBadge(label: p.status, color: sc),
            const SizedBox(height: 8),
            Row(mainAxisSize: MainAxisSize.min, children: [
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hubungi — Coming Soon'), behavior: SnackBarBehavior.floating)),
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

  void _showProspectDetail(BuildContext context, DummyProspect p) {
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
              _detailRow(Icons.inventory_2_outlined, 'Minat Produk', p.productInterest),
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

  void _showEditProspect(BuildContext context, DummyProspect p) {
    _showAddProspectSheet(context, prospect: p);
  }

  void _showAddProspectSheet(BuildContext context, {DummyProspect? prospect}) {
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
