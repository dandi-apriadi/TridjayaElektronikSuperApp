import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../models/inventory_models.dart';
import '../providers/inventory_provider.dart';

/// ============================================================
/// 📦 STOCK TRANSACTION SCREEN
/// Form tambah/kurangi stok barang - Connected to Real API
/// ============================================================

class StockTransactionScreen extends ConsumerStatefulWidget {
  final String? itemId;
  final TransactionType transactionType;

  const StockTransactionScreen({
    super.key,
    this.itemId,
    this.transactionType = TransactionType.in_,
  });

  @override
  ConsumerState<StockTransactionScreen> createState() => _StockTransactionScreenState();
}

class _StockTransactionScreenState extends ConsumerState<StockTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  String? _selectedItemId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.itemId != null) {
      _selectedItemId = widget.itemId;
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isStockIn = widget.transactionType == TransactionType.in_;
    final color = isStockIn ? AppColors.success : AppColors.error;
    final title = isStockIn ? 'Tambah Stok Masuk' : 'Kurangi Stok Keluar';
    final icon = isStockIn ? Icons.add_circle : Icons.remove_circle;

    final itemsAsync = ref.watch(inventoryItemsProvider(null));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 32, color: color),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isStockIn ? 'Stok Masuk (Barang Datang)' : 'Stok Keluar (Barang Keluar)',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isStockIn
                              ? 'Catat barang yang masuk dari supplier'
                              : 'Catat barang yang keluar (rusak/retur/pinjaman)',
                          style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Item Selection
            _buildSectionTitle('Pilih Barang'),
            const SizedBox(height: 8),

            itemsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Gagal memuat item: $error', style: const TextStyle(color: AppColors.error)),
              data: (items) {
                if (items.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text('Tidak ada item tersedia'),
                  );
                }

                return Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedItemId,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.inventory_2, color: AppColors.primary),
                        hintText: 'Pilih barang',
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: color, width: 2),
                        ),
                      ),
                      items: items.map((item) {
                        return DropdownMenuItem(
                          value: item.id,
                          child: Text('${item.name} (${item.category})', overflow: TextOverflow.ellipsis),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _selectedItemId = value),
                      validator: (value) => value == null ? 'Pilih barang terlebih dahulu' : null,
                    ),

                    // Show current stock info
                    if (_selectedItemId != null) ...[
                      const SizedBox(height: 12),
                      Builder(builder: (context) {
                        final selectedItem = items.firstWhere(
                          (i) => i.id == _selectedItemId,
                          orElse: () => items.first,
                        );
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.info.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.info_outline, size: 18, color: AppColors.info),
                              const SizedBox(width: 8),
                              Text(
                                'Stok saat ini: ${selectedItem.currentStock} ${selectedItem.unit}',
                                style: const TextStyle(fontSize: 13, color: AppColors.info, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ],
                );
              },
            ),

            const SizedBox(height: 24),

            // Quantity
            _buildSectionTitle('Jumlah'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                hintText: 'Masukkan jumlah ${isStockIn ? 'masuk' : 'keluar'}',
                suffixText: 'unit',
                prefixIcon: Icon(isStockIn ? Icons.add : Icons.remove, color: color),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: color, width: 2)),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Jumlah wajib diisi';
                final qty = int.tryParse(value!);
                if (qty == null || qty <= 0) return 'Jumlah harus lebih dari 0';
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Reason / Notes
            _buildSectionTitle(isStockIn ? 'Keterangan' : 'Alasan'),
            const SizedBox(height: 8),

            if (!isStockIn) ...[
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildReasonChip('Rusak', Icons.broken_image),
                  _buildReasonChip('Retur', Icons.assignment_return),
                  _buildReasonChip('Pinjaman', Icons.handshake),
                  _buildReasonChip('Terjual', Icons.shopping_cart),
                  _buildReasonChip('Lainnya', Icons.more_horiz),
                ],
              ),
              const SizedBox(height: 12),
            ],

            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: isStockIn ? 'Sumber stok / supplier...' : 'Detail alasan...',
                prefixIcon: const Icon(Icons.notes, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.primary, width: 2)),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Keterangan wajib diisi';
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _submit,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Icon(icon),
                label: Text(
                  _isLoading
                      ? 'Menyimpan...'
                      : isStockIn ? 'Simpan Stok Masuk' : 'Simpan Stok Keluar',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Cancel Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: TextButton(
                onPressed: _isLoading ? null : () => context.pop(),
                child: const Text('Batal'),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700));
  }

  Widget _buildReasonChip(String label, IconData icon) {
    return FilterChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label),
        ],
      ),
      selected: _notesController.text == label,
      onSelected: (selected) {
        setState(() {
          _notesController.text = selected ? label : '';
        });
      },
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final isStockIn = widget.transactionType == TransactionType.in_;
      final qty = int.parse(_quantityController.text);
      final reason = _notesController.text;

      if (isStockIn) {
        final request = AddStockRequest(
          itemId: _selectedItemId!,
          quantity: qty,
          reason: reason,
        );
        await ref.read(addStockProvider(request).future);
      } else {
        final request = RemoveStockRequest(
          itemId: _selectedItemId!,
          quantity: qty,
          reason: reason,
        );
        await ref.read(removeStockProvider(request).future);
      }

      // Refresh inventory data
      ref.invalidate(inventoryItemsProvider);
      ref.invalidate(inventoryStatsProvider);

      if (mounted) {
        setState(() => _isLoading = false);
        _showSuccessDialog(isStockIn);
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showSuccessDialog(bool isStockIn) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle_outline, color: AppColors.success, size: 64),
            ),
            const SizedBox(height: 20),
            Text(
              isStockIn ? 'Stok Masuk Tersimpan!' : 'Stok Keluar Tercatat!',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              '${_quantityController.text} unit telah dicatat.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum TransactionType { in_, out }
