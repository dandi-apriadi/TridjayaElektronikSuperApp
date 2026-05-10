import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../../core/theme/app_theme.dart';
import '../../core/network/dio_client.dart';

/// ============================================================
/// 🌐 NETWORK DIAGNOSTICS SCREEN
/// Tools untuk diagnosa koneksi jaringan
/// ============================================================

class NetworkDiagnosticsScreen extends ConsumerStatefulWidget {
  const NetworkDiagnosticsScreen({super.key});

  @override
  ConsumerState<NetworkDiagnosticsScreen> createState() => _NetworkDiagnosticsScreenState();
}

class _NetworkDiagnosticsScreenState extends ConsumerState<NetworkDiagnosticsScreen> {
  bool _isLoading = false;
  List<DiagnosticResult> _results = [];

  @override
  void initState() {
    super.initState();
    _runDiagnostics();
  }

  Future<void> _runDiagnostics() async {
    setState(() {
      _isLoading = true;
      _results = [];
    });

    final dioClient = ref.read(dioClientProvider);
    final dio = dioClient.dio;

    // Test 1: Check current base URL
    final baseUrl = dio.options.baseUrl;
    _addResult('Base URL', baseUrl, DiagnosticStatus.info);

    // Test 2: Check platform
    String platform;
    if (Platform.isAndroid) platform = 'Android';
    else if (Platform.isIOS) platform = 'iOS';
    else platform = 'Other';
    _addResult('Platform', platform, DiagnosticStatus.info);

    // Test 3: Test connection to health endpoint
    try {
      final response = await dio.get('/health');
      if (response.statusCode == 200) {
        _addResult('Health Check', '✅ Server aktif', DiagnosticStatus.success);
      } else {
        _addResult('Health Check', '⚠️ Status: ${response.statusCode}', DiagnosticStatus.warning);
      }
    } on DioException catch (e) {
      String errorMsg;
      if (e.type == DioExceptionType.connectionError) {
        errorMsg = '❌ Tidak dapat terhubung. Server mungkin mati atau URL salah.';
      } else if (e.type == DioExceptionType.connectionTimeout) {
        errorMsg = '⏱️ Timeout koneksi. Server lambat atau tidak merespons.';
      } else {
        errorMsg = '❌ ${e.type}: ${e.message}';
      }
      _addResult('Health Check', errorMsg, DiagnosticStatus.error);
    } catch (e) {
      _addResult('Health Check', '❌ Error: $e', DiagnosticStatus.error);
    }

    // Test 4: Test all fallback URLs
    final fallbackUrls = [
      'http://10.0.2.2:8080/api',
      'http://localhost:8080/api',
      'http://127.0.0.1:8080/api',
    ];

    for (final url in fallbackUrls) {
      try {
        final testDio = Dio(BaseOptions(
          baseUrl: url,
          connectTimeout: const Duration(seconds: 3),
        ));
        await testDio.get('/health');
        _addResult('Test $url', '✅ OK', DiagnosticStatus.success);
      } catch (e) {
        _addResult('Test $url', '❌ Failed', DiagnosticStatus.error);
      }
    }

    setState(() => _isLoading = false);
  }

  void _addResult(String name, String message, DiagnosticStatus status) {
    setState(() {
      _results.add(DiagnosticResult(name: name, message: message, status: status));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text(
          'Diagnosa Jaringan',
          style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _runDiagnostics,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.network_check, color: AppColors.primary, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Status Koneksi',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isLoading ? 'Sedang menguji...' : '${_results.length} tes selesai',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Troubleshooting Guide
            _buildSectionHeader('Petunjuk Troubleshooting'),
            const SizedBox(height: 12),
            _buildCard([
              _buildTroubleshootingItem(
                icon: Icons.wifi_tethering_error,
                color: AppColors.error,
                title: 'Tidak dapat terhubung?',
                subtitle: 'Pastikan server backend berjalan dan dapat diakses dari jaringan yang sama.',
              ),
              const Divider(height: 1, indent: 56),
              _buildTroubleshootingItem(
                icon: Icons.phone_android,
                color: AppColors.info,
                title: 'Android Emulator',
                subtitle: 'Gunakan 10.0.2.2 untuk mengakses localhost komputer host.',
              ),
              const Divider(height: 1, indent: 56),
              _buildTroubleshootingItem(
                icon: Icons.phone_iphone,
                color: AppColors.success,
                title: 'Device Fisik',
                subtitle: 'Gunakan IP jaringan lokal (192.168.x.x) bukan localhost.',
              ),
              const Divider(height: 1, indent: 56),
              _buildTroubleshootingItem(
                icon: Icons.edit_note,
                color: AppColors.warning,
                title: 'Ubah Base URL',
                subtitle: 'Edit file .env atau modifikasi dio_client.dart dengan IP yang benar.',
              ),
            ]),

            const SizedBox(height: 24),

            // Test Results
            _buildSectionHeader('Hasil Pengujian'),
            const SizedBox(height: 12),
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_results.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Belum ada hasil'),
                ),
              )
            else
              _buildCard(_results.map((r) => _buildResultItem(r)).toList()),

            const SizedBox(height: 24),

            // Quick Fix Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showQuickFixDialog,
                icon: const Icon(Icons.build_circle),
                label: const Text('Quick Fix Koneksi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppShadows.sm,
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTroubleshootingItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultItem(DiagnosticResult result) {
    Color color;
    IconData icon;
    switch (result.status) {
      case DiagnosticStatus.success:
        color = AppColors.success;
        icon = Icons.check_circle;
        break;
      case DiagnosticStatus.warning:
        color = AppColors.warning;
        icon = Icons.warning;
        break;
      case DiagnosticStatus.error:
        color = AppColors.error;
        icon = Icons.error;
        break;
      case DiagnosticStatus.info:
        color = AppColors.info;
        icon = Icons.info;
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result.name, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(result.message, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showQuickFixDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quick Fix Koneksi'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih environment:'),
            const SizedBox(height: 16),
            _buildFixOption('Android Emulator', '10.0.2.2:8080'),
            _buildFixOption('iOS Simulator', 'localhost:8080'),
            _buildFixOption('Device Fisik (IP Komputer)', '192.168.1.x:8080'),
            _buildFixOption('Production', 'api.tridjaya.co.id'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  Widget _buildFixOption(String label, String url) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(url, style: const TextStyle(fontSize: 12)),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Copy $url dan paste ke .env file')),
        );
      },
    );
  }
}

enum DiagnosticStatus { success, warning, error, info }

class DiagnosticResult {
  final String name;
  final String message;
  final DiagnosticStatus status;

  DiagnosticResult({required this.name, required this.message, required this.status});
}
