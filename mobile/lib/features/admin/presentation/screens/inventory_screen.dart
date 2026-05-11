import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/chart_widgets.dart';
import '../../../../shared/widgets/stat_card.dart';
import '../../models/inventory_models.dart';
import '../providers/inventory_provider.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  String _selectedCategory = 'Semua';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = InventoryFilter(
      category: _selectedCategory,
      searchQuery: _searchController.text,
    );
    final itemsAsync = ref.watch(inventoryItemsProvider(filter.toParams()));

    return itemsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, _) => Scaffold(body: Center(child: Text('Error: $err'))),
      data: (items) {
        var filtered = items.where((item) {
          final matchCat = _selectedCategory == 'Semua' || item.category == _selectedCategory;
          final matchSearch = _searchController.text.isEmpty ||
              item.name.toLowerCase().contains(_searchController.text.toLowerCase());
          return matchCat && matchSearch;
        }).toList();

        final lowStockCount = items.where((i) => i.currentStock <= i.minimumStock).length;

        return Scaffold(
          backgroundColor: AppColors.background,
          floatingActionButton: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                heroTag: 'remove',
                mini: true,
                backgroundColor: AppColors.error,
                onPressed: () => _showStockForm(context, isAdd: false),
                child: const Icon(Icons.remove_rounded),
              ),
              const SizedBox(height: 8),
              FloatingActionButton.extended(
                heroTag: 'add',
                backgroundColor: AppColors.success,
                onPressed: () => _showStockForm(context, isAdd: true),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Tambah Stok'),
              ),
            ],
          ),
          body: NestedScrollView(
            headerSliverBuilder: (_, __) => [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor: AppColors.adminColor,
                systemOverlayStyle: SystemUiOverlayStyle.light,
                title: const Text('Daftar Inventori', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                iconTheme: const IconThemeData(color: Colors.white),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(60),
                  child: Container(
                    color: AppColors.surface,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Cari produk...',
                        prefixIcon: const Icon(Icons.search_rounded, size: 20),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(icon: const Icon(Icons.clear_rounded, size: 18), onPressed: () { _searchController.clear(); setState(() {}); })
                            : null,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        filled: true,
                        fillColor: AppColors.surfaceVariant,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.adminColor, width: 1.5)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
            body: Column(children: [
              _buildCategoryFilter(),
              if (lowStockCount > 0) _buildLowStockBanner(lowStockCount),
              _buildSummaryCards(filtered),
              _buildStockDonut(filtered),
              Expanded(
                child: filtered.isEmpty
                    ? _buildEmpty()
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => _buildItemCard(context, filtered[i]),
                      ),
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
      child: SizedBox(
        height: 34,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: ['Semua', 'Aki', 'TV', 'HP'].map((cat) {
            final isSelected = _selectedCategory == cat;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.adminColor : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(cat, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isSelected ? Colors.white : AppColors.textSecondary)),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLowStockBanner(int count) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(children: [
        const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 16),
        const SizedBox(width: 8),
        Text('$count item stok rendah — segera restock!', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error)),
      ]),
    );
  }

  Widget _buildStockDonut(List<InventoryItem> items) {
    final akiTotal = items.where((i) => i.category == 'Aki').fold(0, (s, i) => s + i.currentStock);
    final tvTotal = items.where((i) => i.category == 'TV').fold(0, (s, i) => s + i.currentStock);
    final hpTotal = items.where((i) => i.category == 'HP').fold(0, (s, i) => s + i.currentStock);
    final grandTotal = akiTotal + tvTotal + hpTotal;
    if (_selectedCategory != 'Semua') return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: DonutChartCard(
        title: 'Distribusi Stok',
        centerLabel: 'Total',
        centerValue: '$grandTotal',
        size: 120,
        data: [
          ChartPieData(label: 'Aki', value: akiTotal.toDouble(), color: AppColors.warning),
          ChartPieData(label: 'TV', value: tvTotal.toDouble(), color: AppColors.info),
          ChartPieData(label: 'HP', value: hpTotal.toDouble(), color: AppColors.success),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(List<InventoryItem> items) {
    final total = items.fold(0, (s, i) => s + i.currentStock);
    final lowStock = items.where((i) => i.currentStock <= i.minimumStock).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Row(children: [
        Expanded(child: StatCard(title: 'Total Item', value: '${items.length}', icon: Icons.inventory_2_outlined, color: AppColors.adminColor)),
        const SizedBox(width: 10),
        Expanded(child: StatCard(title: 'Total Stok', value: '$total', icon: Icons.numbers_rounded, color: AppColors.info)),
        const SizedBox(width: 10),
        Expanded(child: StatCard(title: 'Stok Rendah', value: '$lowStock', icon: Icons.warning_amber_outlined, color: AppColors.error)),
      ]),
    );
  }

  Widget _buildItemCard(BuildContext context, InventoryItem item) {
    final isLow = item.currentStock <= item.minimumStock;
    final stockPct = (item.currentStock / (item.minimumStock * 5)).clamp(0.0, 1.0);
    final catColor = _categoryColor(item.category);
    return GestureDetector(
      onTap: () => _showItemDetail(context, item),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: AppShadows.sm,
          border: Border.all(color: isLow ? AppColors.error.withOpacity(0.25) : AppColors.divider),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(color: catColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Icon(_categoryIcon(item.category), color: catColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.name, style: AppTextStyles.bodyMedium),
              Text('${item.sku} • ${_formatCurrency((item.pricePerUnit ?? 0).toInt())}', style: AppTextStyles.caption),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('${item.currentStock} unit', style: AppTextStyles.subtitle.copyWith(
                color: isLow ? AppColors.error : AppColors.success,
              )),
              if (isLow)
                Container(
                  margin: const EdgeInsets.only(top: 2),
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(color: AppColors.errorBg, borderRadius: BorderRadius.circular(6)),
                  child: const Text('Stok Rendah', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.error)),
                ),
            ]),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: stockPct,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(isLow ? AppColors.error : AppColors.success),
                  minHeight: 7,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text('Min: ${item.minimumStock}', style: AppTextStyles.caption),
          ]),
        ]),
      ),
    );
  }

  void _showItemDetail(BuildContext context, InventoryItem item) {
    final isLow = item.currentStock <= item.minimumStock;
    final catColor = _categoryColor(item.category);
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
            Container(width: 44, height: 44,
              decoration: BoxDecoration(color: catColor.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
              child: Icon(_categoryIcon(item.category), color: catColor, size: 22)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.name, style: AppTextStyles.heading3),
              Text('${item.sku} • ${item.category}', style: AppTextStyles.caption),
            ])),
          ]),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              _detailRow('Stok Saat Ini', '${item.currentStock} unit'),
              const Divider(height: 14),
              _detailRow('Stok Minimum', '${item.minimumStock} unit'),
              const Divider(height: 14),
              _detailRow('Harga Jual', _formatCurrency((item.pricePerUnit ?? 0).toInt())),
              const Divider(height: 14),
              _detailRow('Status', isLow ? '⚠️ Stok Rendah' : '✅ Aman'),
            ]),
          ),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: OutlinedButton.icon(
              onPressed: () { Navigator.pop(context); _showStockForm(context, isAdd: false, item: item); },
              icon: const Icon(Icons.remove_rounded, size: 16),
              label: const Text('Kurangi'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: const BorderSide(color: AppColors.error),
                minimumSize: const Size(0, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            )),
            const SizedBox(width: 10),
            Expanded(child: ElevatedButton.icon(
              onPressed: () { Navigator.pop(context); _showStockForm(context, isAdd: true, item: item); },
              icon: const Icon(Icons.add_rounded, size: 16),
              label: const Text('Tambah'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                minimumSize: const Size(0, 46),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
            )),
          ]),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(label, style: AppTextStyles.caption),
        Text(value, style: AppTextStyles.bodyMedium),
      ]),
    );
  }

  void _showStockForm(BuildContext context, {required bool isAdd, InventoryItem? item}) {
    final qtyCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          bool isLoading = false;
          return AlertDialog(
            title: Text(isAdd ? 'Tambah Stok' : 'Kurangi Stok'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              if (item == null)
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Pilih Item'),
                  value: null,
                  items: const [],
                  onChanged: (_) {},
                ),
              if (item != null)
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)),
                  child: Text(item.name, style: AppTextStyles.bodyMedium),
                ),
              const SizedBox(height: 12),
              TextFormField(
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Jumlah', hintText: isAdd ? 'Jumlah yang ditambahkan' : 'Jumlah yang dikurangi'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: reasonCtrl,
                decoration: InputDecoration(labelText: 'Keterangan', hintText: isAdd ? 'Sumber stok / supplier' : 'Alasan pengurangan'),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Kamera — Coming Soon'), behavior: SnackBarBehavior.floating)),
                child: Container(
                  height: 50, width: double.infinity,
                  decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.border)),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.camera_alt_outlined, color: AppColors.textHint, size: 18),
                    const SizedBox(width: 8),
                    Text('Foto Bukti (Opsional)', style: AppTextStyles.caption),
                  ]),
                ),
              ),
            ]),
            actions: [
              TextButton(onPressed: isLoading ? null : () => Navigator.pop(ctx), child: const Text('Batal')),
              ElevatedButton(
                onPressed: isLoading ? null : () async {
                  final qty = int.tryParse(qtyCtrl.text);
                  if (qty == null || qty <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Jumlah harus berupa angka positif'), behavior: SnackBarBehavior.floating),
                    );
                    return;
                  }
                  if (reasonCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Keterangan wajib diisi'), behavior: SnackBarBehavior.floating),
                    );
                    return;
                  }
                  if (item == null || item.id.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Item belum dipilih'), behavior: SnackBarBehavior.floating),
                    );
                    return;
                  }

                  setState(() => isLoading = true);

                  try {
                    if (isAdd) {
                      final request = AddStockRequest(
                        itemId: item.id,
                        quantity: qty,
                        reason: reasonCtrl.text.trim(),
                      );
                      await ref.read(addStockProvider(request).future);
                    } else {
                      final request = RemoveStockRequest(
                        itemId: item.id,
                        quantity: qty,
                        reason: reasonCtrl.text.trim(),
                      );
                      await ref.read(removeStockProvider(request).future);
                    }

                    if (context.mounted) {
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(isAdd ? 'Stok berhasil ditambahkan' : 'Stok berhasil dikurangi'),
                        backgroundColor: isAdd ? AppColors.success : AppColors.warning,
                        behavior: SnackBarBehavior.floating,
                      ));
                      ref.invalidate(inventoryItemsProvider);
                      ref.invalidate(inventoryStatsProvider);
                      ref.invalidate(inventoryAlertsProvider);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      setState(() => isLoading = false);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Gagal: ${e.toString()}'),
                        backgroundColor: AppColors.error,
                        behavior: SnackBarBehavior.floating,
                      ));
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: isAdd ? AppColors.success : AppColors.error),
                child: isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : Text(isAdd ? 'Tambah' : 'Kurangi'),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.inventory_2_outlined, size: 56, color: AppColors.textHint),
      const SizedBox(height: 12),
      Text('Tidak ada item ditemukan', style: AppTextStyles.body),
    ]));
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'Aki': return AppColors.warning;
      case 'TV': return AppColors.info;
      default: return AppColors.success;
    }
  }

  IconData _categoryIcon(String cat) {
    switch (cat) {
      case 'Aki': return Icons.battery_charging_full_rounded;
      case 'TV': return Icons.tv_outlined;
      default: return Icons.smartphone_outlined;
    }
  }

  String _formatCurrency(int price) {
    return 'Rp ${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';
  }
}

// Replaced by InventoryItem model from real API
