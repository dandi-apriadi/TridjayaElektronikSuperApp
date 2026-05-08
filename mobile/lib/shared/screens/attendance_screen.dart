import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../shared/widgets/stat_card.dart';

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({super.key});

  @override
  ConsumerState<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool _checkedIn = false;
  bool _checkedOut = false;
  String? _checkInTime;
  String? _checkOutTime;

  final List<_AttendanceRecord> _history = [
    _AttendanceRecord('Senin, 5 Mei 2025', '08:02', '17:05', '9j 3m', false, true),
    _AttendanceRecord('Selasa, 6 Mei 2025', '07:55', '17:00', '9j 5m', false, false),
    _AttendanceRecord('Rabu, 7 Mei 2025', '08:35', '17:10', '8j 35m', true, false),
    _AttendanceRecord('Kamis, 8 Mei 2025', '08:00', '16:58', '8j 58m', false, false),
    _AttendanceRecord('Jumat, 9 Mei 2025', '07:50', '17:15', '9j 25m', false, false),
    _AttendanceRecord('Senin, 12 Mei 2025', '09:10', '17:00', '7j 50m', true, false),
    _AttendanceRecord('Selasa, 13 Mei 2025', '-', '-', '-', false, true),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _now() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final roleColor = _getRoleColor(user?.role?.name);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            elevation: 0,
            backgroundColor: roleColor,
            systemOverlayStyle: SystemUiOverlayStyle.light,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [roleColor, roleColor.withOpacity(0.75)],
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(children: [
                  Positioned(top: -30, right: -30,
                    child: Container(width: 140, height: 140,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.06)))),
                  SafeArea(child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text('Absensi', style: AppTextStyles.heading3.copyWith(color: Colors.white)),
                      Text(user?.username ?? '', style: AppTextStyles.caption.copyWith(color: Colors.white.withOpacity(0.7))),
                    ]),
                  )),
                ]),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(46),
              child: Container(
                color: AppColors.surface,
                child: TabBar(
                  controller: _tabController,
                  labelColor: roleColor,
                  unselectedLabelColor: AppColors.textSecondary,
                  indicatorColor: roleColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: AppTextStyles.bodyMedium,
                  tabs: const [Tab(text: 'Check-In/Out'), Tab(text: 'Riwayat')],
                ),
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildCheckInTab(context, user?.username ?? '', roleColor),
            _buildHistoryTab(roleColor),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'owner': return AppColors.ownerColor;
      case 'kepalaCabang': return AppColors.kepalaCabangColor;
      case 'admin': return AppColors.adminColor;
      case 'sales': return AppColors.salesColor;
      case 'driver': return AppColors.driverColor;
      default: return AppColors.primary;
    }
  }

  Widget _buildCheckInTab(BuildContext context, String username, Color roleColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildStatusCard(roleColor),
          const SizedBox(height: 16),
          _buildLocationCard(),
          const SizedBox(height: 16),
          if (!_checkedIn) _buildActionButton(
            context, 'Check-In Sekarang', Icons.login_rounded, AppColors.success, isCheckIn: true),
          if (_checkedIn && !_checkedOut) ...[
            const SizedBox(height: 12),
            _buildActionButton(context, 'Check-Out', Icons.logout_rounded, AppColors.error, isCheckIn: false),
          ],
          const SizedBox(height: 20),
          _buildTodaySummary(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatusCard(Color roleColor) {
    final now = DateTime.now();
    final List<Color> gradient = _checkedIn && !_checkedOut
        ? [AppColors.success, const Color(0xFF15803D)]
        : _checkedOut
            ? [AppColors.textSecondary, AppColors.textHint]
            : [roleColor, roleColor.withOpacity(0.75)];
    final statusText = _checkedOut ? 'Sudah Check-Out' : _checkedIn ? 'Sedang Bekerja' : 'Belum Check-In';
    final statusIcon = _checkedOut ? Icons.check_circle_rounded : _checkedIn ? Icons.work_rounded : Icons.fingerprint_rounded;
    final months = ['', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppShadows.colored(gradient.first),
      ),
      child: Column(children: [
        Container(
          width: 64, height: 64,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
          child: Icon(statusIcon, color: Colors.white, size: 32),
        ),
        const SizedBox(height: 14),
        Text(statusText, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text('${now.day} ${months[now.month]} ${now.year}  •  ${_now()}',
            style: const TextStyle(color: Colors.white70, fontSize: 13)),
        if (_checkInTime != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
            child: Text(
              'Masuk: $_checkInTime${_checkOutTime != null ? '   |   Pulang: $_checkOutTime' : ''}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ]),
    );
  }

  Widget _buildLocationCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_rounded, color: AppColors.success, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Dalam Area Kantor', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.success)),
                Text('Cabang Pusat — 45m dari titik absensi', style: AppTextStyles.caption),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: AppColors.success, borderRadius: BorderRadius.circular(6)),
            child: const Text('Valid', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, String label, IconData icon, Color color, {required bool isCheckIn}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppShadows.colored(color),
      ),
      child: ElevatedButton.icon(
        onPressed: () => _showSelfieDialog(context, isCheckIn: isCheckIn),
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    );
  }

  void _showSelfieDialog(BuildContext context, {required bool isCheckIn}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isCheckIn ? 'Selfie Check-In' : 'Selfie Check-Out'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.camera_alt_outlined, size: 48, color: AppColors.textHint),
                  const SizedBox(height: 8),
                  Text('Kamera Preview', style: AppTextStyles.caption),
                  Text('(Simulasi)', style: AppTextStyles.caption),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(isCheckIn ? 'Ambil foto selfie untuk verifikasi check-in Anda.' : 'Ambil foto selfie untuk verifikasi check-out Anda.',
                style: AppTextStyles.caption, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                if (isCheckIn) {
                  _checkedIn = true;
                  _checkInTime = _now();
                } else {
                  _checkedOut = true;
                  _checkOutTime = _now();
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(isCheckIn ? 'Check-In berhasil pukul ${_now()}' : 'Check-Out berhasil pukul ${_now()}'),
                backgroundColor: AppColors.success,
                behavior: SnackBarBehavior.floating,
              ));
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Ambil Foto'),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaySummary() {
    return Row(
      children: [
        Expanded(child: StatCard(title: 'Hadir Bulan Ini', value: '18', subtitle: 'dari 22 hari', icon: Icons.calendar_today_outlined, color: AppColors.success)),
        const SizedBox(width: 12),
        Expanded(child: StatCard(title: 'Terlambat', value: '2', subtitle: 'kali bulan ini', icon: Icons.schedule_outlined, color: AppColors.warning)),
      ],
    );
  }

  Widget _buildHistoryTab(Color roleColor) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _history.length + 1,
      itemBuilder: (_, i) {
        if (i == 0) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(children: [
              Expanded(child: StatCard(title: 'Hadir Bulan Ini', value: '18', subtitle: 'dari 22 hari', icon: Icons.calendar_today_outlined, color: AppColors.success)),
              const SizedBox(width: 12),
              Expanded(child: StatCard(title: 'Terlambat', value: '2', subtitle: 'kali bulan ini', icon: Icons.schedule_outlined, color: AppColors.warning)),
            ]),
          );
        }
        final rec = _history[i - 1];
        final statusColor = rec.isAbsent ? AppColors.error : rec.isLate ? AppColors.warning : AppColors.success;
        final statusLabel = rec.isAbsent ? 'Absen' : rec.isLate ? 'Terlambat' : 'Hadir';
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            boxShadow: AppShadows.sm,
            border: Border.all(color: statusColor.withOpacity(0.15)),
          ),
          child: Row(children: [
            Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                rec.isAbsent ? Icons.close_rounded : rec.isLate ? Icons.access_time_rounded : Icons.check_rounded,
                color: statusColor, size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(rec.date, style: AppTextStyles.bodyMedium),
              if (!rec.isAbsent)
                Text('${rec.checkIn} – ${rec.checkOut}  •  ${rec.duration}', style: AppTextStyles.caption),
            ])),
            StatusBadge(label: statusLabel, color: statusColor),
          ]),
        );
      },
    );
  }
}

class _AttendanceRecord {
  final String date, checkIn, checkOut, duration;
  final bool isLate, isAbsent;
  const _AttendanceRecord(this.date, this.checkIn, this.checkOut, this.duration, this.isLate, this.isAbsent);
}
