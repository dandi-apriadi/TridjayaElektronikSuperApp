# Informasi Akun Login - TE SuperApp

Berikut adalah daftar akun yang tersedia di database untuk keperluan login dan testing.

## Password Default
Semua akun di bawah ini menggunakan password default yang sama:
**Password:** `123456`

## Daftar Pengguna

| Username | Role | Branch / Cabang | Deskripsi |
|----------|------|-----------------|-----------|
| `owner` | Owner | - | Hak akses penuh ke seluruh sistem. |
| `pak_iwan` | PIC (Kepala Cabang) | Kantor Pusat | **PIC Utama** untuk verifikasi dan penilaian seluruh laporan karyawan. |
| `kepala_cabang` | Kepala Cabang | Cabang Bandung | Pengelola operasional di tingkat cabang. |
| `admin` | Admin | Kantor Pusat | Administrator sistem (Inventori) di kantor pusat. |
| `sales1` | Sales | Cabang Bandung | Staff penjualan di Cabang Bandung. |
| `sales2` | Sales | Kantor Pusat | Staff penjualan di Kantor Pusat. |
| `driver1` | Driver | Cabang Bandung | Driver pengiriman di Cabang Bandung. |
| `driver2` | Driver | Kantor Pusat | Driver pengiriman di Kantor Pusat. |

## Informasi Database
- **Database Type:** SQLite
- **File:** `backend/te_superapp.db`
- **Tabel Utama:** `users`, `branches`, `refresh_tokens`

---
*Catatan: Akun `pak_iwan` telah ditambahkan sebagai PIC sesuai dengan kebutuhan sistem pelaporan.*
