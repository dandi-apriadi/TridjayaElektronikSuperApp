import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/inventory_models.dart';
import '../providers/inventory_provider.dart';

/// ============================================================
/// 📦 INVENTORY DETAIL SCREEN
/// Detail & Edit barang untuk Admin - Connected to Real API
/// ============================================================

class InventoryDetailScreen extends ConsumerStatefulWidget {
  final String itemId;
  final bool isEdit;

  const InventoryDetailScreen({
    super.key,
    required this.itemId,
    this.isEdit = false,
  });

  @override
  ConsumerState<InventoryDetailScreen> createState() => _InventoryDetailScreenState();
}

class _InventoryDetailScreenState extends ConsumerState<InventoryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final itemAsync = ref.watch(inventoryItemDetailProvider(widget.itemId));
    final transactionsAsync = ref.watch(stockTransactionsProvider({'item_id': widget.itemId}));

    return itemAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Memuat...', style: TextStyle(color: Colors.white)),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text('Error', style: TextStyle(color: Colors.white)),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: 12),
              Text('Gagal memuat detail item', style: AppTextStyles.heading3),
              const SizedBox(height: 8),
              Text(error.toString(), style: AppTextStyles.caption, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(inventoryItemDetailProvider(widget.itemId)),
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      ),
      data: (item) => _buildContent(item, transactionsAsync),
    );
  }

  Widget _buildContent(InventoryItem item, AsyncValue<List<StockTransaction>> transactionsAsync) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Detail Barang',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.info), text: 'Info'),
              Tab(icon: Icon(Icons.history), text: 'Riwayat'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildInfoTab(item),
            _buildHistoryTab(transactionsAsync),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTab(InventoryItem item) {
    final isLowStock = item.currentStock <= item.minimumStock;

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(inventoryItemDetailProvider(widget.itemId));
      },
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Stock Status Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isLowStock ? AppColors.error.withOpacity(0.1) : AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isLowStock ? AppColors.error.withOpacity(0.3) : AppColors.success.withOpacity(0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      isLowStock ? Icons.warning : Icons.check_circle,
                      color: isLowStock ? AppColors.error : AppColors.success,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isLowStock ? 'Stok Rendah!' : 'Stok Aman',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: isLowStock ? AppColors.error : AppColors.success,
                          ),
                        ),
                        Text(
                          '${item.currentStock} ${item.unit} tersedia',
                          style: const TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isLowStock) ...[
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () => _showAddStockDialog(item),
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah Stok'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Item Details
          _buildDetailSection('Informasi Dasar', [
            _buildDetailRow('Nama Barang', item.name),
            _buildDetailRow('SKU', item.sku),
            _buildDetailRow('Kategori', item.category),
            _buildDetailRow('Satuan', item.unit),
          ]),

          _buildDetailSection('Stok', [
            _buildDetailRow('Stok Saat Ini', '${item.currentStock} ${item.unit}'),
            _buildDetailRow('Minimal Stok', '${item.minimumStock} ${item.unit}'),
            _buildDetailRow('Maksimal Stok', '${item.maximumStock} ${item.unit}'),
          ]),

          _buildDetailSection('Harga', [
            _buildDetailRow(
              'Harga per Unit',
              item.pricePerUnit != null
                  ? 'Rp ${NumberFormat('#,###').format(item.pricePerUnit!.toInt())}'
                  : '-',
            ),
            _buildDetailRow(
              'Total Nilai Stok',
              item.pricePerUnit != null
                  ? 'Rp ${NumberFormat('#,###').format((item.pricePerUnit! * item.currentStock).toInt())}'
                  : '-',
            ),
          ]),

          if (item.notes.isNotEmpty)
            _buildDetailSection('Catatan', [
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  item.notes,
                  style: const TextStyle(color: AppColors.textSecondary, height: 1.5),
                ),
              ),
            ]),

          _buildDetailSection('Informasi Sistem', [
            _buildDetailRow('Dibuat', _formatDate(item.createdAt)),
            _buildDetailRow('Terakhir Update', _formatDate(item.updatedAt)),
            _buildDetailRow('Status', item.isActive ? 'Aktif' : 'Nonaktif'),
          ]),

          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showAddStockDialog(item),
                  icon: const Icon(Icons.add),
                  label: const Text('Stok Masuk'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.success,
                    side: const BorderSide(color: AppColors.success),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showRemoveStockDialog(item),
                  icon: const Icon(Icons.remove),
                  label: const Text('Stok Keluar'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab(AsyncValue<List<StockTransaction>> transactionsAsync) {
    return transactionsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 12),
            Text('Gagal memuat riwayat: $error', style: AppTextStyles.caption),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ref.invalidate(stockTransactionsProvider({'item_id': widget.itemId})),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
      data: (transactions) {
        if (transactions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history, size: 48, color: AppColors.textHint),
                SizedBox(height: 12),
                Text('Belum ada riwayat transaksi'),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(stockTransactionsProvider({'item_id': widget.itemId}));
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              return _buildHistoryCard(transactions[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildHistoryCard(StockTransaction transaction) {
    final isAdd = transaction.type == 'add';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppShadows.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isAdd ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                isAdd ? Icons.add : Icons.remove,
                color: isAdd ? AppColors.success : AppColors.error,
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAdd ? 'Stok Masuk' : 'Stok Keluar',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isAdd ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  transaction.reason,
                  style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '${transaction.quantity} unit',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isAdd ? AppColors.success : AppColors.error,
                      ),
                    ),
                    if (transaction.oldQuantity != null && transaction.newQuantity != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        '(${transaction.oldQuantity} → ${transaction.newQuantity})',
                        style: const TextStyle(fontSize: 11, color: AppColors.textHint),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            _formatDate(transaction.createdAt),
            style: const TextStyle(fontSize: 11, color: AppColors.textHint),
          ),
        ],
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
            style: const TextStyle(
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
              boxShadow: AppShadows.sm,
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddStockDialog(InventoryItem item) {
    final qtyCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Stok'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)),
            child: Text(item.name, style: AppTextStyles.bodyMedium),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: qtyCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(labelText: 'Jumlah', hintText: 'Jumlah yang ditambahkan'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: reasonCtrl,
            decoration: const InputDecoration(labelText: 'Keterangan', hintText: 'Sumber stok / supplier'),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final qty = int.tryParse(qtyCtrl.text);
              if (qty == null || qty <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Jumlah harus lebih dari 0'), backgroundColor: AppColors.error),
                );
                return;
              }

              Navigator.pop(ctx);

              try {
                final request = AddStockRequest(
                  itemId: item.id,
                  quantity: qty,
                  reason: reasonCtrl.text.isNotEmpty ? reasonCtrl.text : 'Stok masuk',
                );
                await ref.read(addStockProvider(request).future);

                // Refresh data
                ref.invalidate(inventoryItemDetailProvider(widget.itemId));
                ref.invalidate(stockTransactionsProvider({'item_id': widget.itemId}));

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Berhasil menambah $qty ${item.unit} ${item.name}'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal: $e'), backgroundColor: AppColors.error),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  void _showRemoveStockDialog(InventoryItem item) {
    final qtyCtrl = TextEditingController();
    final reasonCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kurangi Stok'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.surfaceVariant, borderRadius: BorderRadius.circular(8)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(item.name, style: AppTextStyles.bodyMedium),
                Text('Stok: ${item.currentStock}', style: AppTextStyles.caption),
              ],
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: qtyCtrl,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: 'Jumlah',
              hintText: 'Maks: ${item.currentStock}',
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: reasonCtrl,
            decoration: const InputDecoration(labelText: 'Alasan', hintText: 'Alasan pengurangan stok'),
          ),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final qty = int.tryParse(qtyCtrl.text);
              if (qty == null || qty <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Jumlah harus lebih dari 0'), backgroundColor: AppColors.error),
                );
                return;
              }
              if (qty > item.currentStock) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Stok tidak cukup (tersedia: ${item.currentStock})'), backgroundColor: AppColors.error),
                );
                return;
              }

              Navigator.pop(ctx);

              try {
                final request = RemoveStockRequest(
                  itemId: item.id,
                  quantity: qty,
                  reason: reasonCtrl.text.isNotEmpty ? reasonCtrl.text : 'Stok keluar',
                );
                await ref.read(removeStockProvider(request).future);

                // Refresh data
                ref.invalidate(inventoryItemDetailProvider(widget.itemId));
                ref.invalidate(stockTransactionsProvider({'item_id': widget.itemId}));

                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Berhasil mengurangi $qty ${item.unit} ${item.name}'),
                      backgroundColor: AppColors.warning,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal: $e'), backgroundColor: AppColors.error),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Kurangi'),
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      return dateStr;
    }
  }
}
