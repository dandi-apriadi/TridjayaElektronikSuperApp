import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/attendance_model.dart';
import '../providers/attendance_provider.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  bool _isLoading = false;
  Position? _currentPosition;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCurrentLocation();
  }

  Future<void> _loadCurrentLocation() async {
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _currentPosition = null;
            _errorMessage = 'Izin lokasi belum diberikan';
          });
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _currentPosition = position;
          _errorMessage = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Gagal mendapatkan lokasi: $e';
        });
      }
    }
  }

  Future<void> _handleCheckIn() async {
    await _performAttendanceAction(isCheckIn: true);
  }

  Future<void> _handleCheckOut() async {
    await _performAttendanceAction(isCheckIn: false);
  }

  Future<void> _performAttendanceAction({required bool isCheckIn}) async {
    if (_currentPosition == null) {
      await _loadCurrentLocation();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menunggu lokasi GPS...')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final notifier = ref.read(attendanceNotifierProvider.notifier);
      if (isCheckIn) {
        final response = await notifier.checkIn(
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        final response = await notifier.checkOut(
          latitude: _currentPosition!.latitude,
          longitude: _currentPosition!.longitude,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${response.message} (${response.workingHours})'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }

      ref.invalidate(todayAttendanceProvider);
      ref.invalidate(attendanceSummaryProvider);
      ref.invalidate(refreshableAttendanceHistoryProvider(null));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final todayAttendance = ref.watch(todayAttendanceProvider);
    final summary = ref.watch(attendanceSummaryProvider);
    final history = ref.watch(refreshableAttendanceHistoryProvider(null));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Absensi'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadCurrentLocation,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(todayAttendanceProvider);
          ref.invalidate(attendanceSummaryProvider);
          ref.invalidate(refreshableAttendanceHistoryProvider(null));
          await _loadCurrentLocation();
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildStatusCard(todayAttendance),
            const SizedBox(height: 16),
            _buildLocationCard(),
            const SizedBox(height: 16),
            summary.when(
              data: _buildSummaryCard,
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => _buildMessageCard('Gagal memuat ringkasan: $error'),
            ),
            const SizedBox(height: 16),
            _buildActionButtons(todayAttendance),
            const SizedBox(height: 16),
            _buildHistorySection(history),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(AsyncValue<Attendance?> todayAttendance) {
    return todayAttendance.when(
      data: (attendance) {
        final isCheckedIn = attendance?.isCheckedIn ?? false;
        final hasCheckedOut = attendance?.hasClockOut ?? false;

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primary, AppColors.primary.withOpacity(0.85)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Status Hari Ini', style: TextStyle(color: Colors.white70, fontSize: 12)),
              const SizedBox(height: 8),
              Text(
                isCheckedIn
                    ? (hasCheckedOut ? 'Sudah Check Out' : 'Sedang Bekerja')
                    : 'Belum Check In',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                attendance == null
                    ? 'Belum ada absensi tercatat'
                    : 'Status: ${attendance.statusLabel}${attendance.isLate ? ' · Terlambat' : ''}',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => _buildMessageCard('Gagal memuat status hari ini: $error'),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, color: AppColors.primary),
              const SizedBox(width: 8),
              const Text('Lokasi Perangkat', style: TextStyle(fontWeight: FontWeight.w700)),
              const Spacer(),
              if (_currentPosition != null)
                const Icon(Icons.check_circle, color: AppColors.success, size: 18),
            ],
          ),
          const SizedBox(height: 8),
          if (_errorMessage != null)
            Text(_errorMessage!, style: const TextStyle(color: AppColors.error))
          else if (_currentPosition != null)
            Text(
              'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}\nLng: ${_currentPosition!.longitude.toStringAsFixed(6)}',
              style: TextStyle(color: AppColors.textSecondary),
            )
          else
            const Text('Mencari lokasi GPS...'),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(AttendanceSummary summary) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ringkasan Absensi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildMetricTile('Hadir', summary.totalPresent.toString(), AppColors.success)),
              const SizedBox(width: 8),
              Expanded(child: _buildMetricTile('Terlambat', summary.totalLate.toString(), AppColors.warning)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildMetricTile('Izin', summary.totalLeave.toString(), AppColors.info)),
              const SizedBox(width: 8),
              Expanded(child: _buildMetricTile('Rate', summary.attendanceRateString, AppColors.primary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AsyncValue<Attendance?> todayAttendance) {
    return todayAttendance.when(
      data: (attendance) {
        final canCheckIn = attendance == null || !attendance.isCheckedIn;
        final canCheckOut = attendance != null && attendance.isCheckedIn && !attendance.hasClockOut;

        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: (_isLoading || !canCheckIn) ? null : _handleCheckIn,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(_isLoading ? 'Memproses...' : 'Check In'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: (_isLoading || !canCheckOut) ? null : _handleCheckOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(_isLoading ? 'Memproses...' : 'Check Out'),
              ),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => _buildMessageCard('Gagal memuat tombol aksi: $error'),
    );
  }

  Widget _buildHistorySection(AsyncValue<List<Attendance>> history) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Riwayat Absensi', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          history.when(
            data: (items) {
              if (items.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('Belum ada riwayat absensi.'),
                );
              }

              return Column(
                children: items.map(_buildHistoryItem).toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text('Gagal memuat riwayat: $error'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(Attendance attendance) {
    final date = DateTime.tryParse(attendance.date) ?? DateTime.now();
    final displayDate = DateFormat('dd MMM yyyy', 'id_ID').format(date);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              DateFormat('dd').format(date),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(displayDate, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('Status: ${attendance.statusLabel}'),
                const SizedBox(height: 4),
                Text(
                  'Masuk: ${attendance.clockIn ?? '-'}  Keluar: ${attendance.clockOut ?? '-'}',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                if (attendance.workingHours != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Jam kerja: ${attendance.workingHours}',
                    style: const TextStyle(fontSize: 12, color: AppColors.primary),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard(String message) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Text(message),
    );
  }
}