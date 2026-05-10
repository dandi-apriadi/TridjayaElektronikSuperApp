# 📡 Connection Monitoring - Dokumentasi

## Fitur yang Ditambahkan

### 1. Backend Endpoints

```
GET /api/health  → Health check dengan detail server status
GET /api/ping    → Quick ping untuk test koneksi (pong response)
```

### 2. Flutter DioClient Methods

```dart
// Quick ping
bool isConnected = await DioClient().pingServer();

// Health check dengan detail
Map<String, dynamic> health = await DioClient().healthCheck();
// Returns: { connected: true/false, status, database, timestamp, version, error? }
```

### 3. Riverpod Provider

```dart
// Watch connection state
final connection = ref.watch(connectionProvider);
print(connection.isConnected);  // bool
print(connection.lastError);    // String

// Check connection
await ref.read(connectionProvider.notifier).checkConnection();

// Start auto monitoring (ping setiap 30 detik)
ref.read(connectionProvider.notifier).startMonitoring(interval: Duration(seconds: 30));

// Stop monitoring
ref.read(connectionProvider.notifier).stopMonitoring();
```

### 4. Widgets

```dart
// Simple status widget
const ConnectionStatusWidget()

// With retry button
ConnectionStatusWidget(
  onRetry: () => ref.read(connectionProvider.notifier).checkConnection(),
)

// Detail dialog
showDialog(
  context: context,
  builder: (_) => const ConnectionStatusDialog(),
);
```

## Cara Penggunaan di App

### Opsi 1: Splash Screen dengan Cek Koneksi

```dart
// Di router atau main.dart
MaterialApp(
  home: SplashScreen(
    onConnectionSuccess: () {
      // Navigate ke login/home
      Navigator.pushReplacementNamed(context, '/login');
    },
  ),
)
```

### Opsi 2: Monitoring di Background

```dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Start monitoring saat app jalan
    useEffect(() {
      ref.read(connectionProvider.notifier).startMonitoring();
      return () => ref.read(connectionProvider.notifier).stopMonitoring();
    }, []);

    return MaterialApp(...);
  }
}
```

### Opsi 3: Cek Sebelum API Call

```dart
Future<void> login() async {
  // Cek koneksi dulu
  final isConnected = await DioClient().pingServer();
  if (!isConnected) {
    showError('Tidak ada koneksi ke server');
    return;
  }
  
  // Lanjutkan login
  final response = await dio.post('/api/auth/login', ...);
}
```

## File yang Dibuat

### Backend
- `src/handlers/mod.rs` → Tambahan `health_check` dan `ping` handlers
- `src/main.rs` → Register public routes untuk `/api/health` dan `/api/ping`

### Flutter
- `lib/core/providers/connection_provider_riverpod.dart` → Riverpod state management
- `lib/shared/widgets/connection_status_widget_riverpod.dart` → UI widgets
- `lib/features/splash/screens/splash_screen.dart` → Splash screen dengan cek koneksi

## Test Endpoints

```bash
# Test ping
curl http://localhost:8080/api/ping

# Test health check
curl http://localhost:8080/api/health
```

## Troubleshooting

### Server tidak terdeteksi
- Cek IP address di `DioClient._fallbackUrls`
- Untuk Android Emulator: gunakan `10.0.2.2`
- Untuk device fisik: gunakan IP komputer

### CORS error
- Pastikan backend sudah setup CORS dengan benar
- Check browser console untuk detail error

### Timeout
- Tingkatkan timeout duration di `DioClient`
- Cek firewall Windows
