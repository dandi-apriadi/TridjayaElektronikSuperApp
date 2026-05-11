# Dokumen Perencanaan Prototype Sistem ERP Tridjaya

Dokumen ini merinci rancangan teknis dan fungsional untuk sistem manajemen terpadu yang akan dikembangkan menggunakan **Rust** sebagai backend dan **Flutter** sebagai aplikasi mobile. Sistem ini dirancang untuk mengintegrasikan operasional cabang, manajemen karyawan, dan otomasi pemasaran dalam satu ekosistem mandiri.

## 1. Arsitektur Teknologi
* **Backend:** Rust (Framework: Axum / Tokyo) - Dipilih untuk performansi tinggi, keamanan memori, dan efisiensi resource.
* **Database:** PostgreSQL (Data Relasional) & Redis (Caching & Message Queue untuk WhatsApp).
* **Mobile App:** Flutter (Android/iOS) - Single codebase untuk semua level pengguna.
* **Automation:** Integrasi N8N (Self-hosted) untuk alur kerja AI dan Webhook WhatsApp.
* **Infrastructure:** Ubuntu Server / Docker (untuk skalabilitas antar cabang).

---

## 2. Rincian Fitur & Modul Utama

### A. Manajemen Operasional & Inventori
1.  **Pelaporan Karyawan:** Input laporan kerja harian dengan dukungan lampiran foto/dokumen.
2.  **Pelaporan Stok Terintegrasi:** Monitoring stok Aki, TV, dan HP secara real-time per cabang dengan fitur *low-stock alert*.
3.  **Dashboard Semua Cabang:** Visualisasi data agregat dari seluruh lokasi untuk memantau performa bisnis secara keseluruhan.
4.  **Jadwal Pengiriman:** Manajemen logistik pengiriman barang harian untuk setiap cabang, terintegrasi dengan tugas Driver.

### B. CRM & Otomasi WhatsApp (Self-Hosted)
5.  **Pengambilan Data Prospek:** Database calon pembeli yang dikumpulkan dari berbagai channel penjualan.
6.  **WhatsApp Bomber (Bulk Messaging):** Sistem pengiriman pesan massal terukur dengan fitur *rate-limiting* untuk menghindari pemblokiran nomor.
7.  **WhatsApp AI Chatbot:** Otomasi layanan pelanggan menggunakan AI yang terintegrasi dengan alur kerja N8N untuk menjawab pertanyaan umum secara otomatis.
8.  **Notifikasi Reminder:** Pengiriman pesan otomatis via WhatsApp ke karyawan jika terdapat tugas yang mendekati tenggat waktu atau belum diselesaikan.

### C. Manajemen SDM (HRIS)
9.  **Absensi Karyawan:** Absensi berbasis lokasi (Geo-fencing) dan foto selfie untuk memastikan validitas kehadiran di cabang masing-masing.
10. **Dashboard Karyawan & Task List:** Panel pribadi bagi setiap staf untuk melihat daftar tugas harian dan status pencapaian target.
11. **Role-Based Access Control (RBAC):** Pembagian hak akses yang ketat sesuai peran:
    * **Owner:** Akses penuh ke seluruh laporan keuangan dan performa semua cabang.
    * **Kepala Cabang (Kecab):** Manajemen operasional, stok, dan staf di cabang spesifik.
    * **Admin:** Penginputan data teknis dan manajemen inventori.
    * **Sales:** Manajemen prospek dan pelaporan penjualan.
    * **Driver:** Akses jadwal dan rute pengiriman barang.

### D. Digital & Social Media Monitoring
12. **Dashboard Growth Sosial Media:** Integrasi API untuk memantau pertumbuhan pengikut, interaksi, dan performa iklan (Meta/TikTok) di seluruh akun cabang dalam satu tampilan.

---

## 3. Penyempurnaan & Rekomendasi Tambahan
Untuk memperkuat sistem, berikut adalah poin-poin tambahan yang disarankan:

* **Offline First Capability (Flutter):** Mengingat kondisi koneksi yang mungkin bervariasi di lapangan, aplikasi Flutter sebaiknya memiliki fitur simpan lokal yang akan sinkronisasi otomatis saat mendapat sinyal.
* **Audit Log:** Fitur untuk mencatat setiap perubahan data penting (seperti perubahan stok atau hapus data) demi transparansi dan keamanan data dari manipulasi.
* **Internal Chat / Memo:** Fitur komunikasi internal antar karyawan dalam aplikasi agar koordinasi kerja tidak terpecah di aplikasi chat pribadi.
* **Laporan Otomatis ke Owner:** Sistem secara otomatis mengirimkan ringkasan performa harian/mingguan via PDF melalui WhatsApp Gateway ke Owner setiap jam operasional berakhir.

---

## 4. Tahapan Pengembangan (Milestones)
1.  **Fase 1 (Core):** Setup Backend Rust, Database, dan Autentikasi (RBAC).
2.  **Fase 2 (Operation):** Modul Absensi, Task List, dan Pelaporan Stok di Flutter.
3.  **Fase 3 (Integration):** Implementasi WhatsApp Gateway, AI Chatbot, dan Notifikasi Reminder.
4.  **Fase 4 (Analytics):** Pengembangan Dashboard Cabang dan Integrasi Growth Sosial Media.