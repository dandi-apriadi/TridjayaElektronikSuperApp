import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/connection_provider.dart';
import '../widgets/connection_status_widget.dart';

/// Splash screen dengan pengecekan koneksi server
class SplashScreenWithConnection extends StatefulWidget {
  final VoidCallback onConnectionSuccess;
  
  const SplashScreenWithConnection({
    Key? key,
    required this.onConnectionSuccess,
  }) : super(key: key);

  @override
  State<SplashScreenWithConnection> createState() => _SplashScreenWithConnectionState();
}

class _SplashScreenWithConnectionState extends State<SplashScreenWithConnection> {
  bool _isChecking = true;
  String _statusMessage = 'Menghubungkan ke server...';

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  Future<void> _checkConnection() async {
    final connection = context.read<ConnectionProvider>();
    
    setState(() {
      _isChecking = true;
      _statusMessage = 'Mengecek koneksi ke server...';
    });

    final isConnected = await connection.checkConnection();

    if (mounted) {
      if (isConnected) {
        setState(() {
          _statusMessage = 'Berhasil terhubung ke server!';
        });
        // Tunggu sebentar lalu lanjut
        await Future.delayed(const Duration(seconds: 1));
        widget.onConnectionSuccess();
      } else {
        setState(() {
          _isChecking = false;
          _statusMessage = 'Gagal terhubung ke server';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.local_shipping,
                  size: 60,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 32),
              // Title
              Text(
                'Tridjaya Elektronik',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Super App',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 48),
              // Connection Status
              if (_isChecking) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  _statusMessage,
                  style: const TextStyle(color: Colors.grey),
                ),
              ] else ...[
                ConnectionStatusWidget(
                  showLabel: true,
                  showError: true,
                  onRetry: _checkConnection,
                ),
                const SizedBox(height: 24),
                if (!_isChecking && 
                    !context.select((ConnectionProvider c) => c.isConnected))
                  ElevatedButton.icon(
                    onPressed: _checkConnection,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
              ],
              const SizedBox(height: 16),
              // Manual check button
              TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => const ConnectionStatusDialog(),
                  );
                },
                child: const Text('Detail Koneksi'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
