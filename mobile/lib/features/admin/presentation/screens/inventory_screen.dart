import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/chart_widgets.dart';
import '../../../../shared/widgets/stat_card.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  String _selectedCategory = 'Semua';
  final _searchController = TextEditingController();

  final List<_InventoryItem> _items = [
    _InventoryItem('Aki GS NS40', 'Aki', 145, 20, 'GS Astra', 285000),
    _InventoryItem('Aki GS MF 55B24R', 'Aki', 87, 15, 'GS Astra', 485000),
    _InventoryItem('Aki Yuasa YB12', 'Aki', 32, 10, 'Yuasa', 320000),
    _InventoryItem('Aki Amaron GO', 'Aki', 5, 10, 'Amaron', 520000),
    _InventoryItem('TV Samsung 43" Smart', 'TV', 12, 5, 'Samsung', 4500000),
    _InventoryItem('TV LG 32" HD', 'TV', 22, 5, 'LG', 2800000),
    _InventoryItem('TV Sony Bravia 55"', 'TV', 3, 3, 'Sony', 8900000),
    _InventoryItem('HP Samsung A15', 'HP', 78, 10, 'Samsung', 2100000),
    _InventoryItem('HP Xiaomi Note 13', 'HP', 2, 10, 'Xiaomi', 2800000),
    _InventoryItem('HP Realme C65', 'HP', 45, 10, 'Realme', 1800000),
    _InventoryItem('HP Oppo A18', 'HP', 33, 10, 'Oppo', 1900000),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var filtered = _items.where((item) {
      final matchCat = _selectedCategory == 'Semua' || item.category == _selectedCategory;
      final matchSearch = _searchController.text.isEmpty ||
          item.name.toLowerCase().contains(_searchController.text.toLowerCase());
      return matchCat && matchSearch;
    }).toList();

    final lowStockCount = _items.where((i) => i.stock <= i.minStock).length;

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

  Widget _buildStockDonut(List<_InventoryItem> items) {
    final akiTotal = _items.where((i) => i.category == 'Aki').fold(0, (s, i) => s + i.stock);
    final tvTotal = _items.where((i) => i.category == 'TV').fold(0, (s, i) => s + i.stock);
    final hpTotal = _items.where((i) => i.category == 'HP').fold(0, (s, i) => s + i.stock);
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

  Widget _buildSummaryCards(List<_InventoryItem> items) {
    final total = items.fold(0, (s, i) => s + i.stock);
    final lowStock = items.where((i) => i.stock <= i.minStock).length;
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

  Widget _buildItemCard(BuildContext context, _InventoryItem item) {
    final isLow = item.stock <= item.minStock;
    final stockPct = (item.stock / (item.minStock * 5)).clamp(0.0, 1.0);
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
              Text('${item.brand} • ${_formatCurrency(item.price)}', style: AppTextStyles.caption),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('${item.stock} unit', style: AppTextStyles.subtitle.copyWith(
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
            Text('Min: ${item.minStock}', style: AppTextStyles.caption),
          ]),
        ]),
      ),
    );
  }

  void _showItemDetail(BuildContext context, _InventoryItem item) {
    final isLow = item.stock <= item.minStock;
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
              Text('${item.brand} • ${item.category}', style: AppTextStyles.caption),
            ])),
          ]),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(12)),
            child: Column(children: [
              _detailRow('Stok Saat Ini', '${item.stock} unit'),
              const Divider(height: 14),
              _detailRow('Stok Minimum', '${item.minStock} unit'),
              const Divider(height: 14),
              _detailRow('Harga Jual', _formatCurrency(item.price)),
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

  void _showStockForm(BuildContext context, {required bool isAdd, _InventoryItem? item}) {
    final qtyCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isAdd ? 'Tambah Stok' : 'Kurangi Stok'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          if (item == null)
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Pilih Item'),
              value: _items.first.name,
              items: _items.map((i) => DropdownMenuItem(value: i.name, child: Text(i.name, style: const TextStyle(fontSize: 13)))).toList(),
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
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(isAdd ? 'Stok berhasil ditambahkan' : 'Stok berhasil dikurangi'),
                backgroundColor: isAdd ? AppColors.success : AppColors.warning,
                behavior: SnackBarBehavior.floating,
              ));
            },
            style: ElevatedButton.styleFrom(backgroundColor: isAdd ? AppColors.success : AppColors.error),
            child: Text(isAdd ? 'Tambah' : 'Kurangi'),
          ),
        ],
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

class _InventoryItem {
  final String name, category, brand;
  final int stock, minStock, price;
  const _InventoryItem(this.name, this.category, this.stock, this.minStock, this.brand, this.price);
}
