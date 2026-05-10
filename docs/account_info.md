# 🔐 Informasi Akun Login (TE SuperApp)
*Terakhir Diperbarui: 10 Mei 2026*

Dokumen ini berisi informasi kredensial untuk keperluan testing aplikasi **Tridjaya Elektronik SuperApp** dengan skala data 16 cabang dan 350 karyawan.

---

## 🔑 Akun Akses Utama
Semua akun menggunakan password default: **`123456`**

| Role | Username | Cabang | Keterangan |
| :--- | :--- | :--- | :--- |
| **Owner** | `owner` | - | Akses penuh (Dashboard & AI Chat) |
| **Kepala Cabang** | `pak_iwan` | Sam Ratulangi | PIC Verifikasi Pelaporan |
| **Kepala Cabang** | `kepala_cabang` | Bahu | Contoh Kepala Cabang |
| **Admin** | `admin` | Sam Ratulangi | Akses Inventori & Admin |

---

## 👥 Akun Karyawan (347 Karyawan)
Akun karyawan digenerate secara otomatis untuk simulasi skala besar.

- **Username**: `user_001` sampai `user_347`
- **Password**: `123456`
- **Role**: Acak (Sales, Driver, Admin, Kepala Cabang)
- **Cabang**: Tersebar di 16 cabang Tridjaya

---

## 🏢 Daftar 16 Cabang Tridjaya
Aplikasi kini mendukung 16 titik operasional berikut:

1.  **Tridjaya Elektronik Sam Ratulangi** (Pusat)
2.  **Tridjaya Elektronik Bahu**
3.  **Tridjaya Elektronik Pamanukan**
4.  **Tridjaya Elektronik Pagaden**
5.  **Tridjaya Elektronik Patokbeusi**
6.  **Tridjaya Elektronik Haurgeulis**
7.  **Tridjaya Elektronik Cimalaka**
8.  **Tridjaya Elektronik Cikampek**
9.  **Tridjaya Elektronik Cibaduyut**
10. **Tridjaya Elektronik Arjasari**
11. **Tridjaya Elektronik Subang Kota**
12. **Tridjaya Elektronik Purwakarta**
13. **Tridjaya Elektronik Sumedang Kota**
14. **Tridjaya Elektronik Karawang**
15. **Tridjaya Elektronik Indramayu Kota**
16. **Tridjaya Elektronik Bandung Main**

---

## 📊 Data Simulasi (1 Tahun)
Setiap akun karyawan di atas telah memiliki:
- **~30 Laporan Kerja** yang tersebar dalam 1 tahun terakhir.
- **Riwayat Izin/Cuti** acak untuk keperluan testing dashboard.

> [!IMPORTANT]
> Jangan lupa untuk mematikan dan menyalakan kembali backend (`cargo run`) jika database di-reset untuk memastikan data ini ter-load kembali.
