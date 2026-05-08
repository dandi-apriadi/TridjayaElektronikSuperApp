import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../core/theme/app_theme.dart';

class OfflineIndicator extends StatefulWidget {
  final Widget child;
  const OfflineIndicator({super.key, required this.child});

  @override
  State<OfflineIndicator> createState() => _OfflineIndicatorState();
}

class _OfflineIndicatorState extends State<OfflineIndicator> {
  bool _isOffline = false;
  bool _showBanner = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
    Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final isOffline = result == ConnectivityResult.none;
    if (mounted) {
      setState(() {
        _isOffline = isOffline;
        _showBanner = isOffline;
      });
    }
  }

  void _dismissBanner() {
    setState(() => _showBanner = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_showBanner)
          Material(
            elevation: 2,
            child: Container(
              color: AppColors.warning,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SafeArea(
                bottom: false,
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tidak ada koneksi internet',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                          ),
                          Text(
                            'Data ditampilkan dari cache',
                            style: TextStyle(color: Colors.white70, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                      onPressed: _dismissBanner,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Expanded(child: widget.child),
      ],
    );
  }
}

class OfflineAwareWidget extends StatelessWidget {
  final Widget online;
  final Widget offline;
  final Widget? loading;

  const OfflineAwareWidget({
    super.key,
    required this.online,
    required this.offline,
    this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ConnectivityResult>(
      stream: Connectivity().onConnectivityChanged,
      initialData: ConnectivityResult.mobile,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && loading != null) {
          return loading!;
        }

        final isOffline = snapshot.data == ConnectivityResult.none;
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: isOffline ? offline : online,
        );
      },
    );
  }
}

class CachedDataIndicator extends StatelessWidget {
  final DateTime? lastUpdated;
  final bool isVisible;

  const CachedDataIndicator({
    super.key,
    this.lastUpdated,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.info.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.info.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sync_outlined, size: 14, color: AppColors.info),
          const SizedBox(width: 8),
          Text(
            lastUpdated != null
                ? 'Data terakhir: ${_formatTime(lastUpdated!)}'
                : 'Data dari cache',
            style: TextStyle(fontSize: 11, color: AppColors.info),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);

    if (diff.inMinutes < 1) return 'baru saja';
    if (diff.inHours < 1) return '${diff.inMinutes}m lalu';
    if (diff.inDays < 1) return '${diff.inHours}j lalu';
    return '${diff.inDays}h lalu';
  }
}
