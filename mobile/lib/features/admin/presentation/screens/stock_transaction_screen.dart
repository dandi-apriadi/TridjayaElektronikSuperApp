import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';

/// ============================================================
/// 📦 STOCK TRANSACTION SCREEN
/// Form tambah/kurangi stok barang
/// ============================================================

class StockTransactionScreen extends ConsumerStatefulWidget {
  final String? itemId; // null = stock in, not null = specific item
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
  final _priceController = TextEditingController();
  final _notesController = TextEditingController();
  final _supplierController = TextEditingController();

  String _selectedCategory = 'AKI';
  String _selectedItem = 'AKI GS Astra 12V 45Ah';
  DateTime _transactionDate = DateTime.now();
  bool _isLoading = false;

  final List<String> _categories = ['AKI', 'TV', 'HP', 'Lainnya'];

  final Map<String, List<Map<String, dynamic>>> _items = {
    'AKI': [
      {'name': 'AKI GS Astra 12V 45Ah', 'currentStock': 25},
      {'name': 'AKI Yuasa 12V 60Ah', 'currentStock': 18},
      {'name': 'AKI Incoe 12V 40Ah', 'currentStock': 30},
      {'name': 'AKI Amaron 12V 55Ah', 'currentStock': 12},
    ],
    'TV': [
      {'name': 'TV Samsung 32" LED', 'currentStock': 15},
      {'name': 'TV LG 43" Smart TV', 'currentStock': 8},
      {'name': 'TV Polytron 24"', 'currentStock': 20},
      {'name': 'TV Sharp 50" 4K', 'currentStock': 5},
    ],
    'HP': [
      {'name': 'Samsung Galaxy A14', 'currentStock': 35},
      {'name': 'Xiaomi Redmi Note 12', 'currentStock': 28},
      {'name': 'OPPO A78', 'currentStock': 22},
      {'name': 'Vivo Y22', 'currentStock': 18},
    ],
    'Lainnya': [
      {'name': 'Kulkas 2 Pintu', 'currentStock': 10},
      {'name': 'Mesin Cuci', 'currentStock': 8},
      {'name': 'Microwave', 'currentStock': 15},
    ],
  };

  @override
  void initState() {
    super.initState();
    if (widget.itemId != null) {
      // Pre-fill item if editing
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    _notesController.dispose();
    _supplierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isStockIn = widget.transactionType == TransactionType.in_;
    final color = isStockIn ? AppColors.success : AppColors.error;
    final title = isStockIn ? 'Tambah Stok Masuk' : 'Kurangi Stok Keluar';
    final icon = isStockIn ? Icons.add_circle : Icons.remove_circle;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: color,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
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
                          isStockIn
                              ? 'Stok Masuk (Barang Datang)'
                              : 'Stok Keluar (Barang Keluar)',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isStockIn
                              ? 'Catat barang yang masuk dari supplier'
                              : 'Catat barang yang keluar (rusak/retur/pinjaman)',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Transaction Date
            _buildSectionTitle('Tanggal Transaksi'),
            const SizedBox(height: 8),
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.divider),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        DateFormat('EEEE, dd MMMM yyyy', 'id_ID')
                            .format(_transactionDate),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,
                        size: 16, color: AppColors.textHint),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Item Selection
            _buildSectionTitle('Pilih Barang'),
            const SizedBox(height: 16),

            // Category Dropdown
            _buildDropdownField(
              label: 'Kategori',
              value: _selectedCategory,
              items: _categories,
              icon: Icons.category,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                  _selectedItem = _items[_selectedCategory]!.first['name'];
                });
              },
            ),

            const SizedBox(height: 16),

            // Item Dropdown
            _buildDropdownField(
              label: 'Nama Barang',
              value: _selectedItem,
              items: _items[_selectedCategory]!.map((i) => i['name'] as String).toList(),
              icon: Icons.inventory_2,
              onChanged: (value) => setState(() => _selectedItem = value!),
            ),

            const SizedBox(height: 12),

            // Current Stock Info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 18, color: AppColors.info),
                  const SizedBox(width: 8),
                  Text(
                    'Stok saat ini: ${_getCurrentStock()} unit',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.info,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Quantity
            _buildSectionTitle('Jumlah'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                hintText: 'Masukkan jumlah ${isStockIn ? 'masuk' : 'keluar'}',
                suffixText: 'unit',
                prefixIcon: Icon(
                  isStockIn ? Icons.add : Icons.remove,
                  color: color,
                ),
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
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Jumlah wajib diisi';
                }
                final qty = int.tryParse(value!);
                if (qty == null || qty <= 0) {
                  return 'Jumlah harus lebih dari 0';
                }
                if (!isStockIn) {
                  final current = _getCurrentStock();
                  if (qty > current) {
                    return 'Stok tidak mencukupi (tersedia: $current)';
                  }
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Price (only for stock in)
            if (isStockIn) ...[
              _buildSectionTitle('Harga Beli per Unit'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                  hintText: 'Masukkan harga beli',
                  prefixText: 'Rp ',
                  prefixIcon: Icon(Icons.monetization_on, color: AppColors.primary),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Supplier
              _buildSectionTitle('Supplier (Opsional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _supplierController,
                decoration: InputDecoration(
                  hintText: 'Nama supplier',
                  prefixIcon: Icon(Icons.business, color: AppColors.primary),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Reason (only for stock out)
            if (!isStockIn) ...[
              _buildSectionTitle('Alasan Stok Keluar'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildReasonChip('Rusak', Icons.broken_image),
                  _buildReasonChip('Retur', Icons.assignment_return),
                  _buildReasonChip('Pinjaman', Icons.handshake),
                  _buildReasonChip('Display', Icons.visibility),
                  _buildReasonChip('Lainnya', Icons.more_horiz),
                ],
              ),
              const SizedBox(height: 24),
            ],

            // Notes
            _buildSectionTitle('Catatan (Opsional)'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Tambahkan catatan transaksi...',
                prefixIcon: Icon(Icons.notes, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.primary, width: 2),
                ),
              ),
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
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(icon),
                label: Text(
                  _isLoading
                      ? 'Menyimpan...'
                      : isStockIn
                          ? 'Simpan Stok Masuk'
                          : 'Simpan Stok Keluar',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
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
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textHint,
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: value,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
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
      selected: false,
      onSelected: (selected) {
        _notesController.text = label;
      },
    );
  }

  int _getCurrentStock() {
    final categoryItems = _items[_selectedCategory] ?? [];
    final item = categoryItems.firstWhere(
      (i) => i['name'] == _selectedItem,
      orElse: () => {'currentStock': 0},
    );
    return item['currentStock'] as int;
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _transactionDate,
      firstDate: DateTime.now().subtract(const Duration(days: 7)),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _transactionDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
      final isStockIn = widget.transactionType == TransactionType.in_;
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
                child: const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.success,
                  size: 64,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                isStockIn ? 'Stok Masuk Tersimpan!' : 'Stok Keluar Tercatat!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_quantityController.text} unit $_selectedItem\ntelah dicatat.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                ),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
}

enum TransactionType { in_, out }
