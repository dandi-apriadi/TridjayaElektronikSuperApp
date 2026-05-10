import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/app_theme.dart';

/// ============================================================
/// 📸 PHOTO GUIDELINE SCREEN
/// Guidelines untuk foto bukti job desk sebelum kamera
/// ============================================================

class PhotoGuidelineScreen extends ConsumerStatefulWidget {
  final String taskName;
  final String taskType;
  
  const PhotoGuidelineScreen({
    super.key,
    required this.taskName,
    required this.taskType,
  });

  @override
  ConsumerState<PhotoGuidelineScreen> createState() => _PhotoGuidelineScreenState();
}

class _PhotoGuidelineScreenState extends ConsumerState<PhotoGuidelineScreen> {
  final ImagePicker _picker = ImagePicker();
  bool _showFullGuidelines = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: const Text(
          'Panduan Foto',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            _buildHeaderCard(),
            
            // Guidelines
            _buildGuidelinesSection(),
            
            // Example Photos
            _buildExamplePhotos(),
            
            // Camera Button
            _buildCameraButton(),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6B8EEF), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.camera_alt, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.taskName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Butuh foto bukti',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Foto yang baik akan mempercepat proses verifikasi',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuidelinesSection() {
    final guidelines = _getGuidelinesForTaskType();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.checklist, color: Color(0xFF6B8EEF)),
              SizedBox(width: 8),
              Text(
                'Standar Foto Wajib',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...guidelines.take(_showFullGuidelines ? guidelines.length : 4).map(
            (g) => _buildGuidelineItem(g['icon'] as IconData, g['text'] as String),
          ),
          if (guidelines.length > 4)
            TextButton(
              onPressed: () => setState(() => _showFullGuidelines = !_showFullGuidelines),
              child: Text(
                _showFullGuidelines ? 'Sembunyikan' : 'Lihat semua ${guidelines.length} panduan',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getGuidelinesForTaskType() {
    final commonGuidelines = [
      {'icon': Icons.lightbulb, 'text': 'Pastikan pencahayaan cukup terang'},
      {'icon': Icons.center_focus_strong, 'text': 'Objek utama berada di tengah frame'},
      {'icon': Icons.high_quality, 'text': 'Foto tidak blur dan tidak terpotong'},
      {'icon': Icons.water_drop, 'text': 'Lens kamera bersih dari debu/air'},
    ];

    final specificGuidelines = switch (widget.taskType) {
      'broadcast' => [
        {'icon': Icons.groups, 'text': 'Foto layar WA menunjukkan jumlah kontak (minimal 200)'},
        {'icon': Icons.timer, 'text': 'Screenshot diambil setelah broadcast selesai'},
        {'icon': Icons.crop, 'text': 'Tanggal dan waktu terlihat jelas di screenshot'},
      ],
      'kunjungan' => [
        {'icon': Icons.person_pin, 'text': 'Foto selfie dengan calon customer'},
        {'icon': Icons.location_on, 'text': 'Background menunjukkan lokasi kunjungan'},
        {'icon': Icons.business, 'text': 'Foto tanda pengenal/jam kerja (jika diminta)'},
      ],
      'kontak' => [
        {'icon': Icons.contact_phone, 'text': 'Foto layar kontak baru di HP'},
        {'icon': Icons.save, 'text': 'Tunjukkan nama dan nomor sudah tersimpan'},
        {'icon': Icons.date_range, 'text': 'Foto before-after tambah kontak'},
      ],
      'tiktok' => [
        {'icon': Icons.play_circle, 'text': 'Screenshot halaman video TikTok'},
        {'icon': Icons.visibility, 'text': 'Judul dan durasi video terlihat jelas'},
        {'icon': Icons.link, 'text': 'Link video bisa diakses publik'},
      ],
      _ => [
        {'icon': Icons.photo_camera, 'text': 'Foto sesuai dengan instruksi tugas'},
        {'icon': Icons.check_circle, 'text': 'Semua elemen yang diminta terlihat jelas'},
      ],
    };

    return [...commonGuidelines, ...specificGuidelines];
  }

  Widget _buildGuidelineItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(icon, size: 16, color: AppColors.success),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExamplePhotos() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contoh Foto yang Benar',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildExampleCard(
                  '✅ Benar',
                  'Terang, fokus, lengkap',
                  Icons.check_circle,
                  AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildExampleCard(
                  '❌ Salah',
                  'Blur, gelap, terpotong',
                  Icons.cancel,
                  AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(String label, String desc, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            style: TextStyle(
              fontSize: 11,
              color: AppColors.textHint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCameraButton() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: _takePhoto,
              icon: const Icon(Icons.camera_alt),
              label: const Text(
                'Ambil Foto Sekarang',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _pickFromGallery,
              icon: const Icon(Icons.photo_library),
              label: const Text('Pilih dari Galeri'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (photo != null && mounted) {
        context.push('/jobdesk/photo-preview', extra: {
          'path': photo.path,
          'taskName': widget.taskName,
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (photo != null && mounted) {
        context.push('/jobdesk/photo-preview', extra: {
          'path': photo.path,
          'taskName': widget.taskName,
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
