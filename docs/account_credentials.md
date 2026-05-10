# Tridjaya Elektronik SuperApp - Login Credentials

Semua akun di bawah ini menggunakan password yang sama untuk keperluan testing.

**Password:** `123`

---

## 1. Akun Divisi Utama (Akses Spesifik)
Akun-akun ini mewakili berbagai peran kunci dalam sistem:

| Email | Role | Deskripsi |
|-------|------|-----------|
| `owner@gmail.com` | Owner | Akses penuh ke seluruh dashboard cabang dan metrik pusat. |
| `kevin@gmail.com` | Kepala Cabang | PIC utama untuk verifikasi laporan kerja & jobdesk seluruh divisi. |
| `koordinator@gmail.com` | Sales | Koordinator Sales di Cabang 1. |
| `sales@gmail.com` | Sales | Staff Sales di Cabang 1. |
| `driver@gmail.com` | Driver | Driver di Cabang 1. |
| `pdi@gmail.com` | Sales | Staff PDI di Cabang 2. |
| `admin.pencairan@gmail.com` | Admin | Admin Pencairan di Cabang 1. |
| `admin.spk@gmail.com` | Admin | Admin SPK di Cabang 2. |
| `kasir@gmail.com` | Admin | Kasir di Cabang 3. |
| `admin.stok@gmail.com` | Admin | Admin Stok di Cabang 4. |
| `support.konten@gmail.com` | Sales | Support Konten di Cabang 3. |
| `admin.general@gmail.com` | Admin | Admin General di Cabang 5. |
| `support.online@gmail.com" | Sales | Support Online di Cabang 4. |
| `support.event@gmail.com` | Sales | Support Event di Cabang 5. |
| `supervisor@gmail.com` | Sales | Supervisor di Cabang 2. |
| `general.cashier@gmail.com` | Admin | General Cashier di Cabang 6. |
| `support.marketplace@gmail.com` | Sales | Support Marketplace di Cabang 6. |
| `onwil@gmail.com` | Sales | Onwil di Cabang 3. |
| `crm@gmail.com` | Sales | Staff CRM di Cabang 7. |
| `poling@gmail.com` | Sales | Staff Poling di Cabang 8. |
| `desk.call@gmail.com` | Sales | Staff Desk Call di Cabang 9. |

---

## 2. Akun Karyawan Massal (Bulk Users)
Terdapat **330 akun tambahan** yang tersebar secara acak di 16 cabang dengan role acak (Sales, Driver, Admin, Kepala_Cabang).

**Format Email:** `user_001@gmail.com` sampai `user_330@gmail.com`

**Contoh Akun:**
- `user_001@gmail.com`
- `user_050@gmail.com`
- `user_100@gmail.com`
- `user_330@gmail.com`

---

## 3. Cara Menggunakan
1. Pastikan Backend sudah berjalan (`cargo run` atau `reset_and_run.bat`).
2. Pastikan HP Fisik terhubung dan `adb reverse tcp:8080 tcp:8080` sudah dijalankan.
3. Masukkan Email dan Password di aplikasi Flutter.
