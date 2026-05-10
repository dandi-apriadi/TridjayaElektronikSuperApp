/// ============================================================
/// 📋 JOB DESK SYSTEM - DUMMY DATA
/// Data dari file JOBDESK HARIAN TE.xlsx (20 Divisi)
/// ============================================================

import '../models/jobdesk_models.dart';

class JobDeskDummyData {
  static final koordinatorTemplate = JobDeskTemplate(
    id: 'tpl_koordinator_001',
    role: 'koordinator',
    name: 'Job Desk Koordinator Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'koordinator_001', taskName: 'Foto briefing dan doa pagi', sortOrder: 1),
      JobDeskTaskItem(id: 'koordinator_002', taskName: 'UPDATE KEBERSIHAN TOKO DAN DISPLAY', sortOrder: 2),
      JobDeskTaskItem(id: 'koordinator_003', taskName: 'HARGA TERPASANG SEMUA DAN PENUH DENGAN DISPLAY', sortOrder: 3),
      JobDeskTaskItem(id: 'koordinator_004', taskName: 'TAMBAH KONTAK WA MINIMAL 20-30 KONTAK PER HARI (SERTAKAN SCREENSHOOT)', sortOrder: 4),
      JobDeskTaskItem(id: 'koordinator_005', taskName: 'POSTING DI FB AKUN PRIBADI (2X)', sortOrder: 5),
      JobDeskTaskItem(id: 'koordinator_006', taskName: 'BC WA PRIBADI (100 ORANG)', sortOrder: 6),
      JobDeskTaskItem(id: 'koordinator_007', taskName: 'UPDATE STATUS WA PRIBADI (10X)', sortOrder: 7),
      JobDeskTaskItem(id: 'koordinator_008', taskName: 'ADD FRIEND FB 30 ORANG', sortOrder: 8),
      JobDeskTaskItem(id: 'koordinator_009', taskName: 'KBK ONLINE (PENAWARAN) (SCREENSHOOT CHAT 2X)', sortOrder: 9),
      JobDeskTaskItem(id: 'koordinator_010', taskName: 'Membuat video tiktok harian', sortOrder: 10),
      JobDeskTaskItem(id: 'koordinator_011', taskName: 'UPDATE KATALOG DENGAN DESIGN YANG TBARU DI WA BISNIS', sortOrder: 11),
      JobDeskTaskItem(id: 'koordinator_012', taskName: 'Update SPK ke grup teamtridjayaelektronik', sortOrder: 12),
      JobDeskTaskItem(id: 'koordinator_013', taskName: 'Broadcast RO', sortOrder: 13),
      JobDeskTaskItem(id: 'koordinator_014', taskName: 'Kunjungan ke channel', sortOrder: 14),
      JobDeskTaskItem(id: 'koordinator_015', taskName: 'Briefing pagi dengan team', sortOrder: 15),
      JobDeskTaskItem(id: 'koordinator_016', taskName: 'LAPORAN BUKU TAMU HARIAN', sortOrder: 16),
      JobDeskTaskItem(id: 'koordinator_017', taskName: 'LAPORAN PENJUALAN HARIAN', sortOrder: 17),
      JobDeskTaskItem(id: 'koordinator_018', taskName: 'LAPORAN FEEDBACK PROSPEK DI GROUP WA (SEMUA PROSPEK HARI INI)', sortOrder: 18),
    ],
  );

  static final support_elektronikTemplate = JobDeskTemplate(
    id: 'tpl_support_elektronik_001',
    role: 'support_elektronik',
    name: 'Job Desk Support Elektronik Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'support_elektronik_001', taskName: 'Foto briefing dan doa pagi', sortOrder: 1),
      JobDeskTaskItem(id: 'support_elektronik_002', taskName: 'POSTINGAN HARIAN DI MESIA SOSIAL TRIDJAYA ELEKTRONIK', sortOrder: 2),
      JobDeskTaskItem(id: 'support_elektronik_003', taskName: 'BUAT PRIZE TAG HARGA BARANG DISPLAY TE (HGL, PAGADEN,SOKLAT)', sortOrder: 3),
      JobDeskTaskItem(id: 'support_elektronik_004', taskName: 'NEMPELIN PRICETAG DI SEMUA BARANG DISPLAY (TE HGL)', sortOrder: 4),
      JobDeskTaskItem(id: 'support_elektronik_005', taskName: 'MERESPON CHAT YANG MASUK DI FP DAN IG', sortOrder: 5),
      JobDeskTaskItem(id: 'support_elektronik_006', taskName: 'MEMBALAS SETIAP KOMENTAR KONSUMEN DI SETIAP POSTINGAN', sortOrder: 6),
      JobDeskTaskItem(id: 'support_elektronik_007', taskName: 'VIDEO PERSIAPAN DAN WORO WORO SETIAP SORE HARI SPEAKER DAN MUSIK ON', sortOrder: 7),
      JobDeskTaskItem(id: 'support_elektronik_008', taskName: 'UPLOAD PRODUK DI SHOPEE/TOKPED', sortOrder: 8),
      JobDeskTaskItem(id: 'support_elektronik_009', taskName: 'MELAYANI KONSUMEN ONLINE DI SHOPEE/TOKPED', sortOrder: 9),
      JobDeskTaskItem(id: 'support_elektronik_010', taskName: 'MEMBUAT POSTER HARIAN UNTUK GEOCARL', sortOrder: 10),
      JobDeskTaskItem(id: 'support_elektronik_011', taskName: 'ADD contact WA 10 orang setiap hari, foto sebelum dan sesudah add', sortOrder: 11),
    ],
  );

  static final salesTemplate = JobDeskTemplate(
    id: 'tpl_sales_001',
    role: 'sales',
    name: 'Job Desk Sales Elektronik Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'sales_001', taskName: 'FOTO BERSIH2 DISPLAY SEMBARI MENGHAPAL PRODUCT KNOWLEDGE', sortOrder: 1),
      JobDeskTaskItem(id: 'sales_002', taskName: 'Komentar di FB minimal 5 (BUKTI BERUPA SCREENSHOT FB ANDA)', sortOrder: 2),
      JobDeskTaskItem(id: 'sales_003', taskName: 'Broadcast wa pribadi ke 100 orang (BELAJAR CARA BROADCAST KE REKAN SALES SENIOR)', sortOrder: 3),
      JobDeskTaskItem(id: 'sales_004', taskName: 'screnshot chat penawaran KBK KE RELASI & minta dia untuk posting pamflet promo TE di status wa dia', sortOrder: 4),
      JobDeskTaskItem(id: 'sales_005', taskName: 'Update katalog dengan design promo terbaru di katalog WA Business Anda', sortOrder: 5),
      JobDeskTaskItem(id: 'sales_006', taskName: 'Minta konsumen TAG AKUN INSTAGRAM @TRIDJAYAELEKTRONIK SESUAI AKUN INSTAGRAM CABANG ANDA', sortOrder: 6),
      JobDeskTaskItem(id: 'sales_007', taskName: 'Screnshot chat anda menggunakan trik psikologis di whatsapp (terbaik termurah, perbandingan, keterbatasan, bagi hari, ikut2an, benefit, BETUL)', sortOrder: 7),
      JobDeskTaskItem(id: 'sales_008', taskName: 'Laporan buku tamu harian walk in dan prospek harian anda', sortOrder: 8),
      JobDeskTaskItem(id: 'sales_009', taskName: 'Kenalan dan ngobrol minimal 10 orang per hari', sortOrder: 9),
      JobDeskTaskItem(id: 'sales_010', taskName: 'SHARE POSTINGAN KE LEBIH DARI 100 GRUP', sortOrder: 10),
      JobDeskTaskItem(id: 'sales_011', taskName: 'SS WA KE KO IWAN ATAU TEAM PUSAT, SS BUKTI KALIAN CARE/PEDULI UNTUK KEMAJUAN BERSAMA KE PIMPINAN', sortOrder: 11),
      JobDeskTaskItem(id: 'sales_012', taskName: 'upload video konten di tiktok setiap hari', sortOrder: 12),
      JobDeskTaskItem(id: 'sales_013', taskName: 'shareloc lokasi toko ke semua prospekan', sortOrder: 13),
      JobDeskTaskItem(id: 'sales_014', taskName: 'SEMUA SALES WAJIB MINTA KONSUMEN WALK IN SCAN QR Medsos cabang DAN ADD FRIENDS DI MEDSOS', sortOrder: 14),
      JobDeskTaskItem(id: 'sales_015', taskName: 'video woro woro di kerumunan', sortOrder: 15),
      JobDeskTaskItem(id: 'sales_016', taskName: 'setiap konsumen ambil sendiri minta konsumen: follow medsos outlet dan pusat, dan google review bintang 5', sortOrder: 16),
      JobDeskTaskItem(id: 'sales_017', taskName: 'kirim prospek min 20 per hari', sortOrder: 17),
    ],
  );

  static final driverTemplate = JobDeskTemplate(
    id: 'tpl_driver_001',
    role: 'driver',
    name: 'Job Desk Driver Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'driver_001', taskName: 'TELEPON CABANG TUJUAN/PENERIMA UNTUK MEMASTIKAN ADA TAMBAHAN LAINNYA ATAU TIDAK AGAR MOBIL TIDAK KOSONG DAN FOTO ST MUTASI', sortOrder: 1),
      JobDeskTaskItem(id: 'driver_002', taskName: 'LAPORAN PERAWATAN MOBIL PAGI HARI KE GRUP BERUPA VIDEO + FOTO STNK', sortOrder: 2),
      JobDeskTaskItem(id: 'driver_003', taskName: 'SERAH TERIMA UANG KE KASIR / ADMIN', sortOrder: 3),
      JobDeskTaskItem(id: 'driver_004', taskName: 'TAMBAH KONTAK MINIMAL 5', sortOrder: 4),
      JobDeskTaskItem(id: 'driver_005', taskName: 'VIDEO PENGANTARAN DENGAN MUSIK DAN WORO WORO', sortOrder: 5),
      JobDeskTaskItem(id: 'driver_006', taskName: 'MINIMAL 8 PENGIRIMAN PER HARI atau TIDAK ADA PENDINGAN', sortOrder: 6),
      JobDeskTaskItem(id: 'driver_007', taskName: 'LAPORAN KERJA HARIAN DAN minimal 2 IDG HARIAN', sortOrder: 7),
      JobDeskTaskItem(id: 'driver_008', taskName: 'Inisiatif/ kegiatan tambahan :…......', sortOrder: 8),
      JobDeskTaskItem(id: 'driver_009', taskName: 'SHARE POSTINGAN KE LEBIH DARI 100 GRUP', sortOrder: 9),
      JobDeskTaskItem(id: 'driver_010', taskName: 'SS WA KE KO IWAN ATAU TEAM PUSAT, SS BUKTI KALIAN CARE/PEDULI UNTUK KEMAJUAN BERSAMA KE PIMPINAN', sortOrder: 10),
      JobDeskTaskItem(id: 'driver_011', taskName: 'upload video konten di tiktok setiap hari', sortOrder: 11),
      JobDeskTaskItem(id: 'driver_012', taskName: 'foto dengan konsumen/tetangganya bagi brosur saat pengiriman min 10', sortOrder: 12),
      JobDeskTaskItem(id: 'driver_013', taskName: 'setiap pengantaran minta konsumen: follow medsos outlet dan pusat, dan google review bintang 5', sortOrder: 13),
      JobDeskTaskItem(id: 'driver_014', taskName: 'kirim prospek per hari minimal 5', sortOrder: 14),
    ],
  );

  static final pdiTemplate = JobDeskTemplate(
    id: 'tpl_pdi_001',
    role: 'pdi',
    name: 'Job Desk PDI Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'pdi_001', taskName: 'TERIMA DO DAN CEK KONDISI BARANG DATANG (JIKA ADA yang rusak PROSES AJUKAN RETUR dan lapor ke admin stok)', sortOrder: 1),
      JobDeskTaskItem(id: 'pdi_002', taskName: 'SEGERA HOME SERVICE KONSUMEN JIKA DIMINTA', sortOrder: 2),
      JobDeskTaskItem(id: 'pdi_003', taskName: 'TAMBAH KONTAK MINIMAL 5', sortOrder: 3),
      JobDeskTaskItem(id: 'pdi_004', taskName: 'MINIMAL 5 FOTO KENALAN DAN NGOBROL PER HARI BIAR NGGA CULUN', sortOrder: 4),
      JobDeskTaskItem(id: 'pdi_005', taskName: 'IDG DAN LAPORAN KERJA HARIAN', sortOrder: 5),
      JobDeskTaskItem(id: 'pdi_006', taskName: 'PENGELOLAAN UNIT RETUR DAN UPDATE KE ADMIN STOCK', sortOrder: 6),
      JobDeskTaskItem(id: 'pdi_007', taskName: 'REPAIR SEGERA MINIKMAL 1 UNIT PER HARI (JIKA ADA UNIT REPAIR)', sortOrder: 7),
      JobDeskTaskItem(id: 'pdi_008', taskName: 'Inisiatif/ kegiatan tambahan :…......', sortOrder: 8),
      JobDeskTaskItem(id: 'pdi_009', taskName: 'SHARE POSTINGAN KE LEBIH DARI 100 GRUP', sortOrder: 9),
      JobDeskTaskItem(id: 'pdi_010', taskName: 'SS WA KE KO IWAN ATAU TEAM PUSAT, SS BUKTI KALIAN CARE/PEDULI UNTUK KEMAJUAN BERSAMA KE PIMPINAN', sortOrder: 10),
      JobDeskTaskItem(id: 'pdi_011', taskName: 'upload video konten di tiktok setiap hari', sortOrder: 11),
      JobDeskTaskItem(id: 'pdi_012', taskName: 'kirim prospek per hari minimal 5', sortOrder: 12),
    ],
  );

  static final admin_pencairanTemplate = JobDeskTemplate(
    id: 'tpl_admin_pencairan_001',
    role: 'admin_pencairan',
    name: 'Job Desk Admin Pencairan Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'admin_pencairan_001', taskName: 'INPUT PENCAIRAN/PENAGIHAN LEASING (IN RV)', sortOrder: 1),
      JobDeskTaskItem(id: 'admin_pencairan_002', taskName: 'FOLLOWUP UNTUK PENCAIRAN SEMUA LEASING', sortOrder: 2),
      JobDeskTaskItem(id: 'admin_pencairan_003', taskName: 'UPDATE PENDINGAN BERKAS', sortOrder: 3),
      JobDeskTaskItem(id: 'admin_pencairan_004', taskName: 'FOLLOWUP TAGIHAN PENCAIRAN YANG BELUM CAIR', sortOrder: 4),
      JobDeskTaskItem(id: 'admin_pencairan_005', taskName: 'IDG DAN LKH', sortOrder: 5),
      JobDeskTaskItem(id: 'admin_pencairan_006', taskName: 'UPDATE STATUS WA DAN TAMBAH 3 KONTAK', sortOrder: 6),
      JobDeskTaskItem(id: 'admin_pencairan_007', taskName: 'POSTING MINIMAL 5 KONTEN PROMOSI DAN INFORMASI PENTING', sortOrder: 7),
      JobDeskTaskItem(id: 'admin_pencairan_008', taskName: 'BERIKAN MINIMAL 3 KOMENTAR AKTIF DI FB', sortOrder: 8),
      JobDeskTaskItem(id: 'admin_pencairan_009', taskName: 'Inisiatif/ kegiatan tambahan :…......', sortOrder: 9),
      JobDeskTaskItem(id: 'admin_pencairan_010', taskName: 'SHARE POSTINGAN KE LEBIH DARI 100 GRUP', sortOrder: 10),
      JobDeskTaskItem(id: 'admin_pencairan_011', taskName: 'SS WA KE KO IWAN ATAU TEAM PUSAT, SS BUKTI KALIAN CARE/PEDULI UNTUK KEMAJUAN BERSAMA KE PIMPINAN', sortOrder: 11),
      JobDeskTaskItem(id: 'admin_pencairan_012', taskName: 'upload video konten di tiktok setiap hari', sortOrder: 12),
      JobDeskTaskItem(id: 'admin_pencairan_013', taskName: 'SS WA CHAT KEJAR PENDINGAN UANG/PENDINGAN PENCAIRAN', sortOrder: 13),
      JobDeskTaskItem(id: 'admin_pencairan_014', taskName: 'kirim prospek per hari minimal 5', sortOrder: 14),
    ],
  );

  static final admin_spkTemplate = JobDeskTemplate(
    id: 'tpl_admin_spk_001',
    role: 'admin_spk',
    name: 'Job Desk Admin SPK Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'admin_spk_001', taskName: 'PASTIKAN SPK SEMUA TERINPUT TIDAK ADA CANCEL ATAU NULL', sortOrder: 1),
      JobDeskTaskItem(id: 'admin_spk_002', taskName: 'DATA KONSUMEN LENGKAP SEBELUM INPUT (KTP, NO HP)', sortOrder: 2),
      JobDeskTaskItem(id: 'admin_spk_003', taskName: 'IDG DAN LKH', sortOrder: 3),
      JobDeskTaskItem(id: 'admin_spk_004', taskName: 'KOMEN MINIMAL 3 KOMEN DI FB', sortOrder: 4),
      JobDeskTaskItem(id: 'admin_spk_005', taskName: 'TAMBAH KONTAK MINIMAL 5', sortOrder: 5),
      JobDeskTaskItem(id: 'admin_spk_006', taskName: 'BC konsumen lama/RO FiF. Minimal 20 konsumen', sortOrder: 6),
      JobDeskTaskItem(id: 'admin_spk_007', taskName: 'Inisiatif/ kegiatan tambahan :…......', sortOrder: 7),
      JobDeskTaskItem(id: 'admin_spk_008', taskName: 'SHARE POSTINGAN KE LEBIH DARI 100 GRUP', sortOrder: 8),
      JobDeskTaskItem(id: 'admin_spk_009', taskName: 'SS WA KE KO IWAN ATAU TEAM PUSAT, SS BUKTI KALIAN CARE/PEDULI UNTUK KEMAJUAN BERSAMA KE PIMPINAN', sortOrder: 9),
      JobDeskTaskItem(id: 'admin_spk_010', taskName: 'upload video konten di tiktok setiap hari', sortOrder: 10),
      JobDeskTaskItem(id: 'admin_spk_011', taskName: 'kirim prospek per hari minimal 5', sortOrder: 11),
    ],
  );

  static final kasirTemplate = JobDeskTemplate(
    id: 'tpl_kasir_001',
    role: 'kasir',
    name: 'Job Desk Kasir Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'kasir_001', taskName: 'PENERIMAAN PEMBAYARAN COCOKAN DENGAN SPK', sortOrder: 1),
      JobDeskTaskItem(id: 'kasir_002', taskName: 'SETOR UANG KE BANK DI HARI YANG SAMA', sortOrder: 2),
      JobDeskTaskItem(id: 'kasir_003', taskName: 'PENDINGAN UANG MUKA MAKSIMAL 1 HARI', sortOrder: 3),
      JobDeskTaskItem(id: 'kasir_004', taskName: 'BC konsumen lama/RO FiF. Minimal 20 konsumen', sortOrder: 4),
      JobDeskTaskItem(id: 'kasir_005', taskName: 'TAMBAH KONTAK MINIMAL 5', sortOrder: 5),
      JobDeskTaskItem(id: 'kasir_006', taskName: 'IDG DAN LKH', sortOrder: 6),
      JobDeskTaskItem(id: 'kasir_007', taskName: 'Inisiatif/ kegiatan tambahan :…......', sortOrder: 7),
      JobDeskTaskItem(id: 'kasir_008', taskName: 'SHARE POSTINGAN KE LEBIH DARI 100 GRUP', sortOrder: 8),
      JobDeskTaskItem(id: 'kasir_009', taskName: 'SS WA KE KO IWAN ATAU TEAM PUSAT, SS BUKTI KALIAN CARE/PEDULI UNTUK KEMAJUAN BERSAMA KE PIMPINAN', sortOrder: 9),
      JobDeskTaskItem(id: 'kasir_010', taskName: 'upload video konten di tiktok setiap hari', sortOrder: 10),
      JobDeskTaskItem(id: 'kasir_011', taskName: 'SS WA CHAT KEJAR PENDINGAN UANG/PENDINGAN PENCAIRAN', sortOrder: 11),
      JobDeskTaskItem(id: 'kasir_012', taskName: 'cek piutang di GS, fotokan dan tagih yang blm close ke driver/ owner', sortOrder: 12),
      JobDeskTaskItem(id: 'kasir_013', taskName: 'kirim prospek per hari minimal 5', sortOrder: 13),
    ],
  );

  static final admin_stokTemplate = JobDeskTemplate(
    id: 'tpl_admin_stok_001',
    role: 'admin_stok',
    name: 'Job Desk Admin Stok Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'admin_stok_001', taskName: 'LAPORAN MUTASI BARANG DAN REKAP MUTASI', sortOrder: 1),
      JobDeskTaskItem(id: 'admin_stok_002', taskName: 'STOCK OPNAME HARIAN DAN LAPORAN KE GRUP ( MINI SO )', sortOrder: 2),
      JobDeskTaskItem(id: 'admin_stok_003', taskName: 'UPDATE DATA INDENT HARUS KE GRUP', sortOrder: 3),
      JobDeskTaskItem(id: 'admin_stok_004', taskName: 'LAPORAN BARANG MASUK SHARE KE GRUP', sortOrder: 4),
      JobDeskTaskItem(id: 'admin_stok_005', taskName: 'BERSIH BERSIH DAN ISI DISPLAY KOSONG', sortOrder: 5),
      JobDeskTaskItem(id: 'admin_stok_006', taskName: 'FOTO SETELAH TERIMA MUTASI (UNIT, WRAPPER, SURAT JALAN)', sortOrder: 6),
      JobDeskTaskItem(id: 'admin_stok_007', taskName: 'PEMBAGIAN DAN PEMERATAAN UNIT STOCK KE CABANG', sortOrder: 7),
      JobDeskTaskItem(id: 'admin_stok_008', taskName: 'PAGI HARI SHARE STOCK BANYAK+HARGA, PROMO, FRESH SALE', sortOrder: 8),
      JobDeskTaskItem(id: 'admin_stok_009', taskName: 'SEMUA BARANG WAJIB ADA PRICE TAG', sortOrder: 9),
      JobDeskTaskItem(id: 'admin_stok_010', taskName: 'KENALAN 3 ORANG SETIAP HARI', sortOrder: 10),
      JobDeskTaskItem(id: 'admin_stok_011', taskName: 'MINIMAL ADA 3 KOMENTAR DI FB PRIBADI & SHARE POSTINGAN 100 GRUP', sortOrder: 11),
      JobDeskTaskItem(id: 'admin_stok_012', taskName: 'TAMBAH KONTAK MINIMAL 5', sortOrder: 12),
      JobDeskTaskItem(id: 'admin_stok_013', taskName: 'IDG DAN LKH', sortOrder: 13),
      JobDeskTaskItem(id: 'admin_stok_014', taskName: 'UPDATE STOK KE KRISNA UNTUK UPDATE STOK SISTEM', sortOrder: 14),
      JobDeskTaskItem(id: 'admin_stok_015', taskName: 'Inisiatif/ kegiatan tambahan :…......', sortOrder: 15),
      JobDeskTaskItem(id: 'admin_stok_016', taskName: 'SS WA KE KO IWAN ATAU TEAM PUSAT, SS BUKTI KALIAN CARE/PEDULI UNTUK KEMAJUAN BERSAMA KE PIMPINAN', sortOrder: 16),
      JobDeskTaskItem(id: 'admin_stok_017', taskName: 'share photo dan video stock semua handphone', sortOrder: 17),
      JobDeskTaskItem(id: 'admin_stok_018', taskName: 'upload video konten di tiktok setiap hari', sortOrder: 18),
      JobDeskTaskItem(id: 'admin_stok_019', taskName: 'kirim prospek per hari minimal 5', sortOrder: 19),
    ],
  );

  static final support_kontenTemplate = JobDeskTemplate(
    id: 'tpl_support_konten_001',
    role: 'support_konten',
    name: 'Job Desk Support Konten Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'support_konten_001', taskName: 'Membuat video atau konten harian (minimal 1 video per hari)', sortOrder: 1),
      JobDeskTaskItem(id: 'support_konten_002', taskName: 'Lelang barang baru di tiktok', sortOrder: 2),
      JobDeskTaskItem(id: 'support_konten_003', taskName: 'selalu edukasi di medsos bahwa harga barang di Tridjaya mulai dari 40rb saja', sortOrder: 3),
      JobDeskTaskItem(id: 'support_konten_004', taskName: 'Membuat video atau konten voucher 200/100/50  dan atau edukasi kan di medsos', sortOrder: 4),
      JobDeskTaskItem(id: 'support_konten_005', taskName: 'Mengurus akun FB, IG, Tiktok company  secara all out', sortOrder: 5),
      JobDeskTaskItem(id: 'support_konten_006', taskName: 'Melempar minimal 25 prospek per orang per hari', sortOrder: 6),
      JobDeskTaskItem(id: 'support_konten_007', taskName: 'IDG LKH harian', sortOrder: 7),
      JobDeskTaskItem(id: 'support_konten_008', taskName: 'Kenalan dan ngobrol offline minimal 5 orang per hari biar eksis selalu', sortOrder: 8),
      JobDeskTaskItem(id: 'support_konten_009', taskName: 'TAMBAH KONTAK MINIMAL 5', sortOrder: 9),
      JobDeskTaskItem(id: 'support_konten_010', taskName: 'broadcast database FGC', sortOrder: 10),
      JobDeskTaskItem(id: 'support_konten_011', taskName: 'Inisiatif/ kegiatan tambahan :…......', sortOrder: 11),
      JobDeskTaskItem(id: 'support_konten_012', taskName: 'SHARE POSTINGAN KE LEBIH DARI 100 GRUP', sortOrder: 12),
      JobDeskTaskItem(id: 'support_konten_013', taskName: 'SS WA KE KO IWAN ATAU TEAM PUSAT, SS BUKTI KALIAN CARE/PEDULI UNTUK KEMAJUAN BERSAMA KE PIMPINAN', sortOrder: 13),
      JobDeskTaskItem(id: 'support_konten_014', taskName: 'upload video konten di tiktok setiap hari', sortOrder: 14),
      JobDeskTaskItem(id: 'support_konten_015', taskName: 'live tiktok minimal sejam sehari', sortOrder: 15),
      JobDeskTaskItem(id: 'support_konten_016', taskName: 'MENGUCAPKAN SELAMAT ULLANG TAHUN KE SEMUA KONSUMEN SESUAI DATA ULANG TAHUN SETIAP HARI', sortOrder: 16),
    ],
  );

  static final admin_generalTemplate = JobDeskTemplate(
    id: 'tpl_admin_general_001',
    role: 'admin_general',
    name: 'Job Desk Admin General Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'admin_general_001', taskName: 'Membuat video atau konten harian (minimal 1 video per hari)', sortOrder: 1),
      JobDeskTaskItem(id: 'admin_general_002', taskName: 'Lelang barang baru di tiktok', sortOrder: 2),
      JobDeskTaskItem(id: 'admin_general_003', taskName: 'selalu edukasi di medsos bahwa harga barang di Tridjaya mulai dari 40rb saja', sortOrder: 3),
      JobDeskTaskItem(id: 'admin_general_004', taskName: 'Membuat video atau konten voucher 200/100/50  dan atau edukasi kan di medsos', sortOrder: 4),
      JobDeskTaskItem(id: 'admin_general_005', taskName: 'Mengurus akun FB, IG, Tiktok company  secara all out', sortOrder: 5),
      JobDeskTaskItem(id: 'admin_general_006', taskName: 'Melempar minimal 5 prospek per orang per hari', sortOrder: 6),
      JobDeskTaskItem(id: 'admin_general_007', taskName: 'IDG LKH harian', sortOrder: 7),
      JobDeskTaskItem(id: 'admin_general_008', taskName: 'Kenalan dan ngobrol offline minimal 5 orang per hari biar eksis selalu', sortOrder: 8),
      JobDeskTaskItem(id: 'admin_general_009', taskName: 'TAMBAH KONTAK 5', sortOrder: 9),
      JobDeskTaskItem(id: 'admin_general_010', taskName: 'broadcast database FGC', sortOrder: 10),
      JobDeskTaskItem(id: 'admin_general_011', taskName: 'Inisiatif/ kegiatan tambahan :…......', sortOrder: 11),
      JobDeskTaskItem(id: 'admin_general_012', taskName: 'LIVE TIKTOK', sortOrder: 12),
      JobDeskTaskItem(id: 'admin_general_013', taskName: 'SS WA KE KO IWAN ATAU TEAM PUSAT, SS BUKTI KALIAN CARE/PEDULI UNTUK KEMAJUAN BERSAMA KE PIMPINAN', sortOrder: 13),
      JobDeskTaskItem(id: 'admin_general_014', taskName: 'upload video konten di tiktok setiap hari', sortOrder: 14),
      JobDeskTaskItem(id: 'admin_general_015', taskName: 'TAMBAH FOLLOWER TIKTOK 5', sortOrder: 15),
      JobDeskTaskItem(id: 'admin_general_016', taskName: 'MENGUCAPKAN SELAMAT ULLANG TAHUN KE SEMUA KONSUMEN SESUAI DATA ULANG TAHUN SETIAP HARI', sortOrder: 16),
    ],
  );

  static final support_onlineTemplate = JobDeskTemplate(
    id: 'tpl_support_online_001',
    role: 'support_online',
    name: 'Job Desk Support Online Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'support_online_001', taskName: 'Update data pelamar', sortOrder: 1),
      JobDeskTaskItem(id: 'support_online_002', taskName: 'Broadcast minimal 200 orang', sortOrder: 2),
      JobDeskTaskItem(id: 'support_online_003', taskName: 'Mendapatkan 5 prospek per cabang per hari', sortOrder: 3),
      JobDeskTaskItem(id: 'support_online_004', taskName: 'Mengurus alur sosmed yang ada', sortOrder: 4),
      JobDeskTaskItem(id: 'support_online_005', taskName: 'Kenalan 5 orang per hari', sortOrder: 5),
      JobDeskTaskItem(id: 'support_online_006', taskName: 'TAMBAH KONTAK 5', sortOrder: 6),
      JobDeskTaskItem(id: 'support_online_007', taskName: 'IDG LKH harian', sortOrder: 7),
      JobDeskTaskItem(id: 'support_online_008', taskName: 'Inisiatif/ kegiatan tambahan :…......', sortOrder: 8),
      JobDeskTaskItem(id: 'support_online_009', taskName: 'SHARE POSTINGAN KE LEBIH DARI 100 GRUP', sortOrder: 9),
      JobDeskTaskItem(id: 'support_online_010', taskName: 'SS WA KE KO IWAN ATAU TEAM PUSAT, SS BUKTI KALIAN CARE/PEDULI UNTUK KEMAJUAN BERSAMA KE PIMPINAN', sortOrder: 10),
      JobDeskTaskItem(id: 'support_online_011', taskName: 'WA bomber sehari 3x share', sortOrder: 11),
      JobDeskTaskItem(id: 'support_online_012', taskName: 'upload video konten di tiktok setiap hari', sortOrder: 12),
      JobDeskTaskItem(id: 'support_online_013', taskName: 'live tiktok minimal sejam sehari', sortOrder: 13),
      JobDeskTaskItem(id: 'support_online_014', taskName: 'MENGUCAPKAN SELAMAT ULLANG TAHUN KE SEMUA KONSUMEN SESUAI DATA ULANG TAHUN SETIAP HARI', sortOrder: 14),
    ],
  );

  static final support_eventTemplate = JobDeskTemplate(
    id: 'tpl_support_event_001',
    role: 'support_event',
    name: 'Job Desk Support Event Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'support_event_001', taskName: 'DISPLAY motor dan sepeda listrik wajib minimal 5 unit', sortOrder: 1),
      JobDeskTaskItem(id: 'support_event_002', taskName: 'Display Elektronik fleksibel di stok sesuai tema event', sortOrder: 2),
      JobDeskTaskItem(id: 'support_event_003', taskName: 'Xbanner minimal 3 pcs', sortOrder: 3),
      JobDeskTaskItem(id: 'support_event_004', taskName: 'Tenda wajib BRANDING TRIDJAYA MOTOR &  ELEKTRONIK', sortOrder: 4),
      JobDeskTaskItem(id: 'support_event_005', taskName: 'Umbul2 minimal 5 dr motor dan Elektronik', sortOrder: 5),
      JobDeskTaskItem(id: 'support_event_006', taskName: 'Brosur wajib', sortOrder: 6),
      JobDeskTaskItem(id: 'support_event_007', taskName: 'Pricetag wajib', sortOrder: 7),
      JobDeskTaskItem(id: 'support_event_008', taskName: 'backdrop wajib ada', sortOrder: 8),
      JobDeskTaskItem(id: 'support_event_009', taskName: 'Promo spesial', sortOrder: 9),
      JobDeskTaskItem(id: 'support_event_010', taskName: 'Target KTP minimal 10 KTP di foto', sortOrder: 10),
      JobDeskTaskItem(id: 'support_event_011', taskName: 'Foto absen di event bersama team', sortOrder: 11),
      JobDeskTaskItem(id: 'support_event_012', taskName: 'Kontrol Chanel dan display minimal 3x smnggu', sortOrder: 12),
      JobDeskTaskItem(id: 'support_event_013', taskName: 'Inisiatif/ kegiatan tambahan :…......', sortOrder: 13),
      JobDeskTaskItem(id: 'support_event_014', taskName: 'SHARE POSTINGAN KE LEBIH DARI 100 GRUP', sortOrder: 14),
      JobDeskTaskItem(id: 'support_event_015', taskName: 'SS WA KE KO IWAN ATAU TEAM PUSAT, SS BUKTI KALIAN CARE/PEDULI UNTUK KEMAJUAN BERSAMA KE PIMPINAN', sortOrder: 15),
      JobDeskTaskItem(id: 'support_event_016', taskName: 'upload video konten di tiktok setiap hari', sortOrder: 16),
      JobDeskTaskItem(id: 'support_event_017', taskName: 'MENGUCAPKAN SELAMAT ULLANG TAHUN KE SEMUA KONSUMEN SESUAI DATA ULANG TAHUN SETIAP HARI', sortOrder: 17),
      JobDeskTaskItem(id: 'support_event_018', taskName: 'kirim prospek per hari minimal 5', sortOrder: 18),
    ],
  );

  static final supervisorTemplate = JobDeskTemplate(
    id: 'tpl_supervisor_001',
    role: 'supervisor',
    name: 'Job Desk Supervisor Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'supervisor_001', taskName: 'DISPLAY motor dan sepeda listrik wajib minimal 5 unit', sortOrder: 1),
      JobDeskTaskItem(id: 'supervisor_002', taskName: 'Display Elektronik fleksibel di stok sesuai tema event', sortOrder: 2),
      JobDeskTaskItem(id: 'supervisor_003', taskName: 'Xbanner minimal 3 pcs', sortOrder: 3),
      JobDeskTaskItem(id: 'supervisor_004', taskName: 'Tenda wajib BRANDING TRIDJAYA MOTOR &  ELEKTRONIK', sortOrder: 4),
      JobDeskTaskItem(id: 'supervisor_005', taskName: 'Umbul2 minimal 5 dr motor dan Elektronik', sortOrder: 5),
      JobDeskTaskItem(id: 'supervisor_006', taskName: 'Brosur wajib', sortOrder: 6),
      JobDeskTaskItem(id: 'supervisor_007', taskName: 'Pricetag wajib', sortOrder: 7),
      JobDeskTaskItem(id: 'supervisor_008', taskName: 'backdrop wajib ada', sortOrder: 8),
      JobDeskTaskItem(id: 'supervisor_009', taskName: 'Promo spesial', sortOrder: 9),
      JobDeskTaskItem(id: 'supervisor_010', taskName: 'Target KTP minimal 10 KTP di foto', sortOrder: 10),
      JobDeskTaskItem(id: 'supervisor_011', taskName: 'Foto absen di event bersama team', sortOrder: 11),
      JobDeskTaskItem(id: 'supervisor_012', taskName: 'Kontrol Chanel dan display minimal 3x smnggu', sortOrder: 12),
      JobDeskTaskItem(id: 'supervisor_013', taskName: 'Inisiatif/ kegiatan tambahan :…......', sortOrder: 13),
      JobDeskTaskItem(id: 'supervisor_014', taskName: 'SHARE POSTINGAN KE LEBIH DARI 100 GRUP', sortOrder: 14),
      JobDeskTaskItem(id: 'supervisor_015', taskName: 'SS WA KE KO IWAN ATAU TEAM PUSAT, SS BUKTI KALIAN CARE/PEDULI UNTUK KEMAJUAN BERSAMA KE PIMPINAN', sortOrder: 15),
      JobDeskTaskItem(id: 'supervisor_016', taskName: 'UPDATE STOCK DI APPS', sortOrder: 16),
      JobDeskTaskItem(id: 'supervisor_017', taskName: 'UNDANG PELAMAR DI GLINTZ', sortOrder: 17),
      JobDeskTaskItem(id: 'supervisor_018', taskName: 'upload video konten di tiktok setiap hari', sortOrder: 18),
      JobDeskTaskItem(id: 'supervisor_019', taskName: 'MENGUCAPKAN SELAMAT ULLANG TAHUN KE SEMUA KONSUMEN SESUAI DATA ULANG TAHUN SETIAP HARI', sortOrder: 19),
      JobDeskTaskItem(id: 'supervisor_020', taskName: 'kirim prospek per hari minimal 5', sortOrder: 20),
    ],
  );

  static final general_cashierTemplate = JobDeskTemplate(
    id: 'tpl_general_cashier_001',
    role: 'general_cashier',
    name: 'Job Desk General Cashier Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'general_cashier_001', taskName: 'Membuat grup wa dengan relasi, instansi dan pasang di profile picture GRUP WA tsb dengan foto bersama relasi tsb', sortOrder: 1),
      JobDeskTaskItem(id: 'general_cashier_002', taskName: 'Menyapa semua grup yang dibuat GC dengan menyebut nama di grup tsb dan forward pamflet online harian', sortOrder: 2),
      JobDeskTaskItem(id: 'general_cashier_003', taskName: 'TAMBAH KONTAK 5', sortOrder: 3),
      JobDeskTaskItem(id: 'general_cashier_004', taskName: 'Dapat coment FB minimal 3 orang', sortOrder: 4),
      JobDeskTaskItem(id: 'general_cashier_005', taskName: 'Broadcast minimal 30 orang per hari', sortOrder: 5),
      JobDeskTaskItem(id: 'general_cashier_006', taskName: 'Kenalan dan ngobrol minimal 5 orang per hari biar eksis selalu', sortOrder: 6),
      JobDeskTaskItem(id: 'general_cashier_007', taskName: 'PENTING = KUNJUNGAN MINIMAL 3 ELEMEN BAIK SWASTA MAUPUN PEMERINTAH / CAFÉ / RESTORAN / KOPERASI / DESA/ DLL', sortOrder: 7),
      JobDeskTaskItem(id: 'general_cashier_008', taskName: 'Inisiatif/ kegiatan tambahan :…......', sortOrder: 8),
      JobDeskTaskItem(id: 'general_cashier_009', taskName: 'SHARE POSTINGAN KE LEBIH DARI 100 GRUP', sortOrder: 9),
      JobDeskTaskItem(id: 'general_cashier_010', taskName: 'SS WA KE KO IWAN ATAU TEAM PUSAT, SS BUKTI KALIAN CARE/PEDULI UNTUK KEMAJUAN BERSAMA KE PIMPINAN', sortOrder: 10),
      JobDeskTaskItem(id: 'general_cashier_011', taskName: 'upload video konten di tiktok setiap hari', sortOrder: 11),
      JobDeskTaskItem(id: 'general_cashier_012', taskName: 'kirim prospek per hari minimal 5', sortOrder: 12),
    ],
  );

  static final support_marketplaceTemplate = JobDeskTemplate(
    id: 'tpl_support_marketplace_001',
    role: 'support_marketplace',
    name: 'Job Desk Support Marketplace Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'support_marketplace_001', taskName: 'Update product atau tambah product minimal 5 product', sortOrder: 1),
      JobDeskTaskItem(id: 'support_marketplace_002', taskName: 'Broadcast minimal 30 orang per hari', sortOrder: 2),
      JobDeskTaskItem(id: 'support_marketplace_003', taskName: 'Ada comment minimal 3 di Market Place', sortOrder: 3),
      JobDeskTaskItem(id: 'support_marketplace_004', taskName: 'Mengurus alur sosmed market place yang ada', sortOrder: 4),
      JobDeskTaskItem(id: 'support_marketplace_005', taskName: 'Kenalan 5 orang per hari', sortOrder: 5),
      JobDeskTaskItem(id: 'support_marketplace_006', taskName: 'TAMBAH 5 KONTAK', sortOrder: 6),
      JobDeskTaskItem(id: 'support_marketplace_007', taskName: 'IDG LKH harian', sortOrder: 7),
      JobDeskTaskItem(id: 'support_marketplace_008', taskName: 'Packing untuk paket ( Kondisional )', sortOrder: 8),
      JobDeskTaskItem(id: 'support_marketplace_009', taskName: 'Inisiatif/ kegiatan tambahan :…......', sortOrder: 9),
      JobDeskTaskItem(id: 'support_marketplace_010', taskName: 'SHARE POSTINGAN KE LEBIH DARI 100 GRUP', sortOrder: 10),
      JobDeskTaskItem(id: 'support_marketplace_011', taskName: 'SS WA KE KO IWAN ATAU TEAM PUSAT, SS BUKTI KALIAN CARE/PEDULI UNTUK KEMAJUAN BERSAMA KE PIMPINAN', sortOrder: 11),
      JobDeskTaskItem(id: 'support_marketplace_012', taskName: 'upload video konten di tiktok setiap hari', sortOrder: 12),
      JobDeskTaskItem(id: 'support_marketplace_013', taskName: 'live tiktok minimal sejam setiap hari', sortOrder: 13),
      JobDeskTaskItem(id: 'support_marketplace_014', taskName: 'MENGUCAPKAN SELAMAT ULLANG TAHUN KE SEMUA KONSUMEN SESUAI DATA ULANG TAHUN SETIAP HARI', sortOrder: 14),
      JobDeskTaskItem(id: 'support_marketplace_015', taskName: 'kirim prospek per hari minimal 5', sortOrder: 15),
    ],
  );

  static final onwilTemplate = JobDeskTemplate(
    id: 'tpl_onwil_001',
    role: 'onwil',
    name: 'Job Desk ON Wilayah Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'onwil_001', taskName: 'melakukan live 2-4 jam per hari (perakun)', sortOrder: 1),
      JobDeskTaskItem(id: 'onwil_002', taskName: 'membuat konten 5-6 perhari (team)', sortOrder: 2),
      JobDeskTaskItem(id: 'onwil_003', taskName: 'bantu upload konten di sodmed cabang dan individu', sortOrder: 3),
      JobDeskTaskItem(id: 'onwil_004', taskName: 'bantu woro woro ofline (individu)', sortOrder: 4),
      JobDeskTaskItem(id: 'onwil_005', taskName: 'canvasing/kenalan 5 orang perhari (individu)', sortOrder: 5),
      JobDeskTaskItem(id: 'onwil_006', taskName: 'report setelah live (per akun)', sortOrder: 6),
      JobDeskTaskItem(id: 'onwil_007', taskName: 'share promo ke 5 grup (individu)', sortOrder: 7),
      JobDeskTaskItem(id: 'onwil_008', taskName: 'broadcast story wa & tambah 5 kontak baru (individu)', sortOrder: 8),
      JobDeskTaskItem(id: 'onwil_009', taskName: 'membuat konten khusus youtube TE (team)', sortOrder: 9),
      JobDeskTaskItem(id: 'onwil_010', taskName: 'salin tautan 100x (individu)', sortOrder: 10),
      JobDeskTaskItem(id: 'onwil_011', taskName: '50 prospek/komen per hari (team)', sortOrder: 11),
      JobDeskTaskItem(id: 'onwil_012', taskName: 'prepare sebelim live (individu)', sortOrder: 12),
      JobDeskTaskItem(id: 'onwil_013', taskName: 'dokumentasi seputar live (individu)', sortOrder: 13),
      JobDeskTaskItem(id: 'onwil_014', taskName: 'IDG & LKH (individu)', sortOrder: 14),
      JobDeskTaskItem(id: 'onwil_015', taskName: 'Inisiatif', sortOrder: 15),
      JobDeskTaskItem(id: 'onwil_016', taskName: 'SS WA KE KO IWAN ATAU TEAM PUSAT, SS BUKTI KALIAN CARE/PEDULI UNTUK KEMAJUAN BERSAMA KE PIMPINAN', sortOrder: 16),
      JobDeskTaskItem(id: 'onwil_017', taskName: 'upload video konten di tiktok setiap hari', sortOrder: 17),
      JobDeskTaskItem(id: 'onwil_018', taskName: 'collect 2 pasword ke instansi/toko/café/apapun, kasih program ke instansi tsb', sortOrder: 18),
    ],
  );

  static final crmTemplate = JobDeskTemplate(
    id: 'tpl_crm_001',
    role: 'crm',
    name: 'Job Desk CRM Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'crm_001', taskName: 'Broadcast minimal 200 orang', sortOrder: 1),
      JobDeskTaskItem(id: 'crm_002', taskName: 'Mengurus alur sosmed yang ada', sortOrder: 2),
      JobDeskTaskItem(id: 'crm_003', taskName: 'TAMBAH 5 KONTAK', sortOrder: 3),
      JobDeskTaskItem(id: 'crm_004', taskName: 'IDG LKH harian', sortOrder: 4),
      JobDeskTaskItem(id: 'crm_005', taskName: 'Inisiatif/ kegiatan tambahan :…......', sortOrder: 5),
      JobDeskTaskItem(id: 'crm_006', taskName: 'SHARE POSTINGAN KE LEBIH DARI 100 GRUP', sortOrder: 6),
      JobDeskTaskItem(id: 'crm_007', taskName: 'SS WA KE KO IWAN ATAU TEAM PUSAT, SS BUKTI KALIAN CARE/PEDULI UNTUK KEMAJUAN BERSAMA KE PIMPINAN', sortOrder: 7),
      JobDeskTaskItem(id: 'crm_008', taskName: 'WA bomber sehari 3x share', sortOrder: 8),
      JobDeskTaskItem(id: 'crm_009', taskName: 'upload video konten di tiktok setiap hari', sortOrder: 9),
      JobDeskTaskItem(id: 'crm_010', taskName: 'MENGUCAPKAN SELAMAT ULLANG TAHUN KE SEMUA KONSUMEN SESUAI DATA ULANG TAHUN SETIAP HARI', sortOrder: 10),
      JobDeskTaskItem(id: 'crm_011', taskName: 'kirim prospek per hari minimal 5', sortOrder: 11),
    ],
  );

  static final polingTemplate = JobDeskTemplate(
    id: 'tpl_poling_001',
    role: 'poling',
    name: 'Job Desk Poling Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'poling_001', taskName: 'Update status order di Grup FIF Spektra', sortOrder: 1),
      JobDeskTaskItem(id: 'poling_002', taskName: 'Share hasil poling reject ke Grup Rejekkan Spektra dan tag sales', sortOrder: 2),
      JobDeskTaskItem(id: 'poling_003', taskName: 'Proses banding konsumen reject FIF', sortOrder: 3),
      JobDeskTaskItem(id: 'poling_004', taskName: 'Share delivery note (delnot) pengiriman', sortOrder: 4),
      JobDeskTaskItem(id: 'poling_005', taskName: 'Cek kesiapan unit kiriman', sortOrder: 5),
      JobDeskTaskItem(id: 'poling_006', taskName: 'Siapkan surat jalan untuk driver', sortOrder: 6),
      JobDeskTaskItem(id: 'poling_007', taskName: 'Update data pengiriman di sistem', sortOrder: 7),
      JobDeskTaskItem(id: 'poling_008', taskName: 'Monitor status pengiriman barang', sortOrder: 8),
      JobDeskTaskItem(id: 'poling_009', taskName: 'Kirim broadcast ke kontak WA konsumen', sortOrder: 9),
      JobDeskTaskItem(id: 'poling_010', taskName: 'Buat laporan harian pengiriman dan poling', sortOrder: 10),
      JobDeskTaskItem(id: 'poling_011', taskName: 'kirim prospek per hari minimal 5', sortOrder: 11),
    ],
  );

  static final desk_callTemplate = JobDeskTemplate(
    id: 'tpl_desk_call_001',
    role: 'desk_call',
    name: 'Job Desk Desk Call Harian',
    isActive: true,
    tasks: [
      JobDeskTaskItem(id: 'desk_call_001', taskName: 'Melakukan penarikan data penjualan seluruh cabang', sortOrder: 1),
      JobDeskTaskItem(id: 'desk_call_002', taskName: 'Mengikuti serta melaksanakan kegiatan Zoom Meeting', sortOrder: 2),
      JobDeskTaskItem(id: 'desk_call_003', taskName: 'Menghubungi konsumen terkait layanan purna jual (after sales)', sortOrder: 3),
      JobDeskTaskItem(id: 'desk_call_004', taskName: 'Mengerjakan rekapitulasi prospek all sales', sortOrder: 4),
      JobDeskTaskItem(id: 'desk_call_005', taskName: 'Mengerjakan rekapitulasi sarana dan prasarana', sortOrder: 5),
      JobDeskTaskItem(id: 'desk_call_006', taskName: 'membuat/share laporan terkait prospek all sales dan sarana prasarana di grup', sortOrder: 6),
      JobDeskTaskItem(id: 'desk_call_007', taskName: 'Melakukan kegiatan canvassing', sortOrder: 7),
      JobDeskTaskItem(id: 'desk_call_008', taskName: 'Melakukan broadcast pesan di WA', sortOrder: 8),
      JobDeskTaskItem(id: 'desk_call_009', taskName: 'Melakukan follow up konsumen', sortOrder: 9),
      JobDeskTaskItem(id: 'desk_call_010', taskName: 'Melakukan share promo disosial media', sortOrder: 10),
      JobDeskTaskItem(id: 'desk_call_011', taskName: 'kirim prospek per hari minimal 5', sortOrder: 11),
    ],
  );

  static List<JobDeskTemplate> get allTemplates => [
    koordinatorTemplate,
    support_elektronikTemplate,
    salesTemplate,
    driverTemplate,
    pdiTemplate,
    admin_pencairanTemplate,
    admin_spkTemplate,
    kasirTemplate,
    admin_stokTemplate,
    support_kontenTemplate,
    admin_generalTemplate,
    support_onlineTemplate,
    support_eventTemplate,
    supervisorTemplate,
    general_cashierTemplate,
    support_marketplaceTemplate,
    onwilTemplate,
    crmTemplate,
    polingTemplate,
    desk_callTemplate,
  ];

  static JobDeskTemplate getTemplateByRole(String role) {
    switch (role) {
      case 'koordinator': return koordinatorTemplate;
      case 'support_elektronik': return support_elektronikTemplate;
      case 'sales': return salesTemplate;
      case 'driver': return driverTemplate;
      case 'pdi': return pdiTemplate;
      case 'admin_pencairan': return admin_pencairanTemplate;
      case 'admin_spk': return admin_spkTemplate;
      case 'kasir': return kasirTemplate;
      case 'admin_stok': return admin_stokTemplate;
      case 'support_konten': return support_kontenTemplate;
      case 'admin_general': return admin_generalTemplate;
      case 'support_online': return support_onlineTemplate;
      case 'support_event': return support_eventTemplate;
      case 'supervisor': return supervisorTemplate;
      case 'general_cashier': return general_cashierTemplate;
      case 'support_marketplace': return support_marketplaceTemplate;
      case 'onwil': return onwilTemplate;
      case 'crm': return crmTemplate;
      case 'poling': return polingTemplate;
      case 'desk_call': return desk_callTemplate;
      default: return salesTemplate;
    }
  }

  static List<JobDeskSubmission> getDummySubmissionsForToday(JobDeskTemplate template) {
    return template.tasks.map((task) {
      final isCompleted = task.sortOrder % 3 != 0;
      return JobDeskSubmission(
        id: 'sub_${task.id}_${DateTime.now().millisecondsSinceEpoch}',
        assignmentId: 'assign_001',
        taskItemId: task.id,
        submissionDate: DateTime.now(),
        status: isCompleted ? JobDeskStatus.completed : JobDeskStatus.pending,
        actualValue: task.type == JobDeskTaskType.counter && isCompleted ? task.targetValue : null,
        taskItem: task,
      );
    }).toList();
  }

  static List<JobDeskSubmission> getDummySubmissionsHistory() => [];

  static List<JobDeskEmployeeSummary> getDummyEmployeeSummaries() => [
    JobDeskEmployeeSummary(userId: 'e1', userName: 'Ahmad', role: 'Sales', branchName: 'Sam Ratulangi', totalTasks: 17, completedToday: 14, pendingToday: 3, completionRate: 82.3, streakDays: 5),
    JobDeskEmployeeSummary(userId: 'e2', userName: 'Budi', role: 'Driver', branchName: 'Bahu', totalTasks: 14, completedToday: 12, pendingToday: 2, completionRate: 85.7, streakDays: 3),
  ];

  static List<JobDeskVerificationQueueItem> getDummyVerificationQueue() => [
    JobDeskVerificationQueueItem(submissionId: 's1', userId: 'e1', userName: 'Ahmad', userAvatar: 'A', submissionDate: DateTime.now(), submittedAt: DateTime.now(), taskName: 'Follow up prospek', taskType: JobDeskTaskType.checkbox, totalProofs: 1),
  ];
}
