import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/connection_provider.dart';

/// Widget untuk menampilkan status koneksi ke server
class ConnectionStatusWidget extends StatelessWidget {
  final bool showLabel;
  final bool showError;
  final VoidCallback? onRetry;

  const ConnectionStatusWidget({
    Key? key,
    this.showLabel = true,
    this.showError = true,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectionProvider>(
      builder: (context, connection, child) {
        // Sedang cek koneksi
        if (connection.isChecking) {
          return _buildStatus(
            icon: Icons.sync,
            color: Colors.orange,
            label: 'Mengecek koneksi...',
          );
        }

        // Terkoneksi
        if (connection.isConnected) {
          return _buildStatus(
            icon: Icons.wifi,
            color: Colors.green,
            label: 'Terhubung ke server',
          );
        }

        // Tidak terkoneksi
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatus(
              icon: Icons.wifi_off,
              color: Colors.red,
              label: 'Tidak terhubung ke server',
            ),
            if (showError && connection.lastError.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                connection.lastError,
                style: TextStyle(
                  color: Colors.red[700],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Coba Lagi'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildStatus({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 16),
        if (showLabel) ...[
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }
}

/// Dialog untuk menampilkan detail koneksi
class ConnectionStatusDialog extends StatelessWidget {
  const ConnectionStatusDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.network_check),
          SizedBox(width: 8),
          Text('Status Koneksi'),
        ],
      ),
      content: Consumer<ConnectionProvider>(
        builder: (context, connection, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Status
              Row(
                children: [
                  Icon(
                    connection.isConnected ? Icons.check_circle : Icons.error,
                    color: connection.isConnected ? Colors.green : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    connection.isConnected ? 'Terhubung' : 'Tidak Terhubung',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: connection.isConnected ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
              const Divider(height: 16),
              // Server Info
              if (connection.serverInfo.isNotEmpty) ...[
                _buildInfoRow('Status:', connection.serverInfo['status']?.toString() ?? '-'),
                _buildInfoRow('Database:', connection.serverInfo['database']?.toString() ?? '-'),
                _buildInfoRow('Versi:', connection.serverInfo['version']?.toString() ?? '-'),
                _buildInfoRow('Timestamp:', connection.serverInfo['timestamp']?.toString() ?? '-'),
              ],
              // Error
              if (!connection.isConnected && connection.lastError.isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text(
                  'Error:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  connection.lastError,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ],
          );
        },
      ),
      actions: [
        TextButton.icon(
          onPressed: () {
            context.read<ConnectionProvider>().checkConnection();
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Cek Ulang'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Tutup'),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}
