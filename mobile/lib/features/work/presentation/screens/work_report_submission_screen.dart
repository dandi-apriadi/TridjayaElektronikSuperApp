import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_theme.dart';

/// ============================================================
/// 📝 WORK REPORT SUBMISSION SCREEN
/// Input Laporan Kerja Harian (IDG)
/// ============================================================

class WorkReportSubmissionScreen extends ConsumerStatefulWidget {
  final String? editReportId;
  
  const WorkReportSubmissionScreen({
    super.key,
    this.editReportId,
  });

  @override
  ConsumerState<WorkReportSubmissionScreen> createState() => _WorkReportSubmissionScreenState();
}

class _WorkReportSubmissionScreenState extends ConsumerState<WorkReportSubmissionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _achievementsController = TextEditingController();
  final _challengesController = TextEditingController();
  final _nextPlanController = TextEditingController();
  
  final ImagePicker _picker = ImagePicker();
  List<XFile> _photos = [];
  bool _isSubmitting = false;
  bool _isDraft = false;

  @override
  void dispose() {
    _contentController.dispose();
    _achievementsController.dispose();
    _challengesController.dispose();
    _nextPlanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Laporan Kerja Harian',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _saveDraft,
            child: const Text(
              'Simpan Draft',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date Card
              _buildDateCard(),
              const SizedBox(height: 16),
              
              // Main Content
              _buildTextField(
                controller: _contentController,
                label: 'Kegiatan Hari Ini *',
                hint: 'Ceritakan kegiatan kerja Anda hari ini secara detail...\n\nContoh:\n- Kunjungan ke 5 prospek\n- Follow up 10 calon konsumen\n- Membuat laporan penjualan',
                minLines: 6,
                validator: (v) => v?.trim().isEmpty == true 
                    ? 'Kegiatan tidak boleh kosong' 
                    : null,
              ),
              const SizedBox(height: 16),
              
              // Achievements
              _buildTextField(
                controller: _achievementsController,
                label: 'Pencapaian (Opsional)',
                hint: 'Apa yang berhasil Anda capai hari ini?',
              ),
              const SizedBox(height: 16),
              
              // Challenges
              _buildTextField(
                controller: _challengesController,
                label: 'Kendala (Opsional)',
                hint: 'Kesulitan atau kendala yang dihadapi...',
              ),
              const SizedBox(height: 16),
              
              // Next Plan
              _buildTextField(
                controller: _nextPlanController,
                label: 'Rencana Besok (Opsional)',
                hint: 'Rencana kegiatan untuk besok...',
              ),
              const SizedBox(height: 24),
              
              // Photo Section
              _buildPhotoSection(),
              const SizedBox(height: 32),
              
              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Kirim Laporan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateCard() {
    final now = DateTime.now();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B8EEF), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.calendar_today,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tanggal Laporan',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(now),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int minLines = 3,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          minLines: minLines,
          maxLines: null,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 13,
              color: AppColors.textHint.withOpacity(0.6),
              height: 1.5,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.divider),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.divider),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.photo_camera, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Foto Bukti (Opsional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Tambahkan foto sebagai bukti kegiatan',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textHint,
          ),
        ),
        const SizedBox(height: 12),
        
        // Photo Grid
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // Add Photo Button
            InkWell(
              onTap: _showPhotoOptions,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.3),
                    style: BorderStyle.solid,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tambah',
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Selected Photos
            ..._photos.asMap().entries.map((entry) {
              return Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(entry.value.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removePhoto(entry.key),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto'),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    try {
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (photo != null) {
        setState(() => _photos.add(photo));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final photos = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      if (photos.isNotEmpty) {
        setState(() => _photos.addAll(photos));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _removePhoto(int index) {
    setState(() => _photos.removeAt(index));
  }

  void _saveDraft() {
    // TODO: Save draft to local storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft disimpan'),
        backgroundColor: Colors.orange,
      ),
    );
    context.pop();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSubmitting = true);
    
    // TODO: Submit to backend
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isSubmitting = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Laporan berhasil dikirim!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    }
  }
}
