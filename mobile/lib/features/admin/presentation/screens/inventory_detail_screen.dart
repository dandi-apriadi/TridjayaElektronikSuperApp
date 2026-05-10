import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';

/// ============================================================
/// 📦 INVENTORY DETAIL SCREEN
/// Detail & Edit barang untuk Admin
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
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _skuController = TextEditingController();
  final _priceController = TextEditingController();
  final _minStockController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'AKI';
  String _selectedUnit = 'Unit';
  bool _isActive = true;
  bool _isLoading = false;

  final List<String> _categories = ['AKI', 'TV', 'HP', 'Audio', 'Lainnya'];
  final List<String> _units = ['Unit', 'Pcs', 'Set', 'Box', 'Pack'];

  // Dummy item data
  late Map<String, dynamic> _item;
  late List<Map<String, dynamic>> _stockHistory;

  @override
  void initState() {
    super.initState();
    _loadItemData();
  }

  void _loadItemData() {
    _item = {
      'id': widget.itemId,
      'name': 'AKI GS Astra 12V 45Ah',
      'sku': 'AKI-GS-45AH-001',
      'category': 'AKI',
      'currentStock': 25,
      'minStock': 10,
      'price': 850000,
      'unit': 'Unit',
      'description': 'Aki mobil GS Astra dengan daya 12V 45Ah, cocok untuk mobil city car',
      'isActive': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 180)),
      'updatedAt': DateTime.now().subtract(const Duration(days: 5)),
    };

    _stockHistory = [
      {
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'type': 'in',
        'qty': 20,
        'notes': 'Pembelian dari supplier GS Astra',
        'user': 'Admin',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 5)),
        'type': 'out',
        'qty': 5,
        'notes': 'Penjualan ke customer',
        'user': 'Sales - Ahmad',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 10)),
        'type': 'out',
        'qty': 3,
        'notes': 'Retur rusak ke supplier',
        'user': 'Admin',
      },
      {
        'date': DateTime.now().subtract(const Duration(days: 15)),
        'type': 'in',
        'qty': 15,
        'notes': 'Restock bulanan',
        'user': 'Admin',
      },
    ];

    // Set controllers
    _nameController.text = _item['name'];
    _skuController.text = _item['sku'];
    _priceController.text = _item['price'].toString();
    _minStockController.text = _item['minStock'].toString();
    _descriptionController.text = _item['description'];
    _selectedCategory = _item['category'];
    _selectedUnit = _item['unit'];
    _isActive = _item['isActive'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _skuController.dispose();
    _priceController.dispose();
    _minStockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            widget.isEdit ? 'Edit Barang' : 'Detail Barang',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
          bottom: widget.isEdit
              ? null
              : const TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: [
                    Tab(icon: Icon(Icons.info), text: 'Info'),
                    Tab(icon: Icon(Icons.history), text: 'Riwayat'),
                  ],
                ),
          actions: [
            if (!widget.isEdit)
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white),
                onPressed: () {
                  // Navigate to edit mode
                },
              ),
          ],
        ),
        body: widget.isEdit ? _buildEditForm() : _buildDetailTabs(),
      ),
    );
  }

  Widget _buildDetailTabs() {
    return TabBarView(
      children: [
        _buildInfoTab(),
        _buildHistoryTab(),
      ],
    );
  }

  Widget _buildInfoTab() {
    final isLowStock = _item['currentStock'] <= _item['minStock'];

    return ListView(
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
                        '${_item['currentStock']} ${_item['unit']} tersedia',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (isLowStock) ...[
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => context.push('/admin/stock-in'),
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
          _buildDetailRow('Nama Barang', _item['name']),
          _buildDetailRow('SKU', _item['sku']),
          _buildDetailRow('Kategori', _item['category']),
          _buildDetailRow('Satuan', _item['unit']),
        ]),

        _buildDetailSection('Stok', [
          _buildDetailRow('Stok Saat Ini', '${_item['currentStock']} ${_item['unit']}'),
          _buildDetailRow('Minimal Stok', '${_item['minStock']} ${_item['unit']}'),
        ]),

        _buildDetailSection('Harga', [
          _buildDetailRow(
            'Harga Jual',
            'Rp ${NumberFormat('#,###').format(_item['price'])}',
          ),
        ]),

        if (_item['description']?.isNotEmpty ?? false)
          _buildDetailSection('Deskripsi', [
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _item['description'],
                style: TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
            ),
          ]),

        _buildDetailSection('Informasi Sistem', [
          _buildDetailRow(
            'Dibuat',
            DateFormat('dd MMM yyyy').format(_item['createdAt']),
          ),
          _buildDetailRow(
            'Terakhir Update',
            DateFormat('dd MMM yyyy').format(_item['updatedAt']),
          ),
          _buildDetailRow('Status', _item['isActive'] ? 'Aktif' : 'Nonaktif'),
        ]),

        const SizedBox(height: 20),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.push('/admin/stock-in'),
                icon: const Icon(Icons.add),
                label: const Text('Stok Masuk'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.success,
                  side: BorderSide(color: AppColors.success),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => context.push('/admin/stock-out'),
                icon: const Icon(Icons.remove),
                label: const Text('Stok Keluar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(color: AppColors.error),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _stockHistory.length,
      itemBuilder: (context, index) {
        return _buildHistoryCard(_stockHistory[index]);
      },
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> history) {
    final isIn = history['type'] == 'in';
    final dateFormat = DateFormat('dd MMM yyyy, HH:mm');

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
              color: isIn ? AppColors.success.withOpacity(0.1) : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(
                isIn ? Icons.add : Icons.remove,
                color: isIn ? AppColors.success : AppColors.error,
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
                  isIn ? 'Stok Masuk' : 'Stok Keluar',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: isIn ? AppColors.success : AppColors.error,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  history['notes'],
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${history['qty']} ${_item['unit']} • ${history['user']}',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textHint,
                  ),
                ),
              ],
            ),
          ),
          Text(
            dateFormat.format(history['date']),
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textHint,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Basic Info Section
          _buildFormSectionTitle('Informasi Dasar'),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _nameController,
            label: 'Nama Barang *',
            icon: Icons.inventory_2,
            validator: (value) => value?.isEmpty ?? true ? 'Nama wajib diisi' : null,
          ),

          const SizedBox(height: 16),

          _buildTextField(
            controller: _skuController,
            label: 'SKU / Kode Barang',
            icon: Icons.qr_code,
          ),

          const SizedBox(height: 16),

          // Category Dropdown
          _buildDropdownField(
            label: 'Kategori *',
            value: _selectedCategory,
            items: _categories,
            icon: Icons.category,
            onChanged: (value) => setState(() => _selectedCategory = value!),
          ),

          const SizedBox(height: 16),

          // Unit Dropdown
          _buildDropdownField(
            label: 'Satuan *',
            value: _selectedUnit,
            items: _units,
            icon: Icons.scale,
            onChanged: (value) => setState(() => _selectedUnit = value!),
          ),

          const SizedBox(height: 24),

          // Pricing Section
          _buildFormSectionTitle('Harga'),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _priceController,
            label: 'Harga Jual *',
            icon: Icons.monetization_on,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            prefixText: 'Rp ',
            validator: (value) => value?.isEmpty ?? true ? 'Harga wajib diisi' : null,
          ),

          const SizedBox(height: 24),

          // Stock Section
          _buildFormSectionTitle('Pengaturan Stok'),
          const SizedBox(height: 16),

          _buildTextField(
            controller: _minStockController,
            label: 'Minimal Stok *',
            icon: Icons.warning_amber,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) => value?.isEmpty ?? true ? 'Minimal stok wajib diisi' : null,
          ),

          const SizedBox(height: 24),

          // Description Section
          _buildFormSectionTitle('Deskripsi'),
          const SizedBox(height: 16),

          TextFormField(
            controller: _descriptionController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Deskripsi barang...',
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

          // Status Toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.divider),
            ),
            child: Row(
              children: [
                Icon(
                  _isActive ? Icons.check_circle : Icons.cancel,
                  color: _isActive ? AppColors.success : AppColors.error,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status Barang',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        _isActive ? 'Aktif (Tampil di aplikasi)' : 'Nonaktif (Disembunyikan)',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _isActive,
                  onChanged: (value) => setState(() => _isActive = value),
                  activeColor: AppColors.success,
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _isLoading ? null : _save,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save),
              label: Text(
                _isLoading ? 'Menyimpan...' : 'Simpan Perubahan',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
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
    );
  }

  Widget _buildFormSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
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
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? prefixText,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        prefixText: prefixText,
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
      validator: validator,
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
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
      ),
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (mounted) {
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
              const Text(
                'Perubahan Disimpan!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
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
