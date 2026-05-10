-- Seed Data Migration for TE SuperApp
-- Initial data: branches, users, job desk templates

-- ===========================================
-- BRANCHES (Cabang)
-- ===========================================
INSERT INTO branches (code, name, address, phone, email, status) VALUES
('SR', 'Sam Ratulangi', 'Jl. Sam Ratulangi No. 123, Manado', '0431-123456', 'sr@tridjayamanado.com', 'active'),
('BH', 'Bahu', 'Jl. Bahu No. 45, Manado', '0431-234567', 'bahu@tridjayamanado.com', 'active'),
('MH', 'Malahayati', 'Jl. Malalayang No. 67, Manado', '0431-345678', 'malahayati@tridjayamanado.com', 'active'),
('TD', 'Tondano', 'Jl. Yos Sudarso No. 89, Tondano', '0431-456789', 'tondano@tridjayamanado.com', 'active');

-- ===========================================
-- OWNER (Super User)
-- ===========================================
INSERT INTO users (email, password_hash, full_name, role, status, phone, department, position)
VALUES (
    'owner@tridjayamanado.com',
    '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.VDQns9/1GKZ1Li', -- password: 'owner123'
    'Bapak Owner',
    'owner',
    'active',
    '0812-3456-7890',
    'Management',
    'Owner'
);

-- ===========================================
-- KEPALA CABANG
-- ===========================================
INSERT INTO users (email, password_hash, full_name, role, status, phone, branch_id, department, position)
VALUES 
    ('hendra@tridjayamanado.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.VDQns9/1GKZ1Li', 'Pak Hendra', 'kepala_cabang', 'active', '0812-1111-2222', (SELECT id FROM branches WHERE code = 'SR'), 'Management', 'Kepala Cabang Sam Ratulangi'),
    ('surya@tridjayamanado.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.VDQns9/1GKZ1Li', 'Pak Surya', 'kepala_cabang', 'active', '0812-2222-3333', (SELECT id FROM branches WHERE code = 'BH'), 'Management', 'Kepala Cabang Bahu'),
    ('kevin@tridjayamanado.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.VDQns9/1GKZ1Li', 'Kevin', 'kepala_cabang', 'active', '0812-3333-4444', (SELECT id FROM branches WHERE code = 'MH'), 'Management', 'Kepala Cabang Malahayati');

-- ===========================================
-- SALES
-- ===========================================
INSERT INTO users (email, password_hash, full_name, role, status, phone, branch_id, department, position)
VALUES
    ('budi@tridjayamanado.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.VDQns9/1GKZ1Li', 'Budi Santoso', 'sales', 'active', '0813-1111-2222', (SELECT id FROM branches WHERE code = 'SR'), 'Sales', 'Sales Marketing'),
    ('siti@tridjayamanado.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.VDQns9/1GKZ1Li', 'Siti Aminah', 'sales', 'active', '0813-2222-3333', (SELECT id FROM branches WHERE code = 'BH'), 'Sales', 'Sales Marketing');

-- ===========================================
-- ADMIN
-- ===========================================
INSERT INTO users (email, password_hash, full_name, role, status, phone, branch_id, department, position)
VALUES
    ('ahmad@tridjayamanado.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.VDQns9/1GKZ1Li', 'Ahmad Fauzi', 'admin', 'active', '0814-1111-2222', (SELECT id FROM branches WHERE code = 'SR'), 'Administration', 'Admin Kasir'),
    ('dewi@tridjayamanado.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.VDQns9/1GKZ1Li', 'Dewi Lestari', 'admin', 'active', '0814-2222-3333', (SELECT id FROM branches WHERE code = 'BH'), 'Administration', 'Admin Kasir');

-- ===========================================
-- DRIVER
-- ===========================================
INSERT INTO users (email, password_hash, full_name, role, status, phone, branch_id, department, position)
VALUES
    ('eko@tridjayamanado.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.VDQns9/1GKZ1Li', 'Eko Prasetyo', 'driver', 'active', '0815-1111-2222', (SELECT id FROM branches WHERE code = 'SR'), 'Logistics', 'Driver Pengiriman'),
    ('fajar@tridjayamanado.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/X4.VDQns9/1GKZ1Li', 'Fajar Nugraha', 'driver', 'active', '0815-2222-3333', (SELECT id FROM branches WHERE code = 'BH'), 'Logistics', 'Driver Pengiriman');

-- ===========================================
-- JOB DESK TEMPLATES (20 Divisi)
-- ===========================================

-- 1. Sales Marketing
INSERT INTO jobdesk_templates (division, department, title, description, tasks, photo_requirements) VALUES
('Sales Marketing', 'Sales', 'Sales Marketing Harian', 'Template job desk untuk tim sales marketing', 
'[
    {"id": "1", "task": "Mengikuti briefing pagi", "required": true},
    {"id": "2", "task": "Update catatan harian di CRM/Slip", "required": true},
    {"id": "3", "task": "Membuat laporan bulanan", "required": false}
]'::jsonb,
'[
    {"type": "briefing_pagi", "description": "Foto saat briefing pagi bersama tim", "required": true},
    {"type": "update_crm", "description": "Screenshot update CRM/slip", "required": true}
]'::jsonb
);

-- 2. Sales Lapangan
INSERT INTO jobdesk_templates (division, department, title, description, tasks, photo_requirements) VALUES
('Sales Lapangan', 'Sales', 'Sales Lapangan Harian', 'Template untuk sales yang kerja lapangan',
'[
    {"id": "1", "task": "Berangkat kerja", "required": true},
    {"id": "2", "task": "Cek jadwal pengiriman", "required": true},
    {"id": "3", "task": "Bertemu dengan customer/prospek", "required": true},
    {"id": "4", "task": "Laporan kunjungan customer", "required": true},
    {"id": "5", "task": "Input hasil kunjungan ke Excel/CRM", "required": true}
]'::jsonb,
'[
    {"type": "berangkat_kerja", "description": "Foto berangkat kerja dari rumah", "required": true},
    {"type": "kunjungan_customer", "description": "Foto bertemu customer dengan geotag", "required": true}
]'::jsonb
);

-- 3. Sales Counter
INSERT INTO jobdesk_templates (division, department, title, description, tasks, photo_requirements) VALUES
('Sales Counter', 'Sales', 'Sales Counter Harian', 'Template untuk sales counter',
'[
    {"id": "1", "task": "Cek stok barang di counter", "required": true},
    {"id": "2", "task": "Bersihkan dan rapihkan barang display", "required": true},
    {"id": "3", "task": "Melayani customer di counter", "required": true},
    {"id": "4", "task": "Mengisi slip penjualan", "required": true}
]'::jsonb,
'[
    {"type": "cek_stok", "description": "Foto saat cek stok barang", "required": true},
    {"type": "layanan_customer", "description": "Foto melayani customer", "required": true}
]'::jsonb
);

-- 4. Admin Kasir
INSERT INTO jobdesk_templates (division, department, title, description, tasks, photo_requirements) VALUES
('Admin Kasir', 'Administration', 'Admin Kasir Harian', 'Template untuk admin kasir',
'[
    {"id": "1", "task": "Membuka toko (Open Store)", "required": true},
    {"id": "2", "task": "Stock opname barang masuk/keluar", "required": true},
    {"id": "3", "task": "Pengecekan display barang", "required": true},
    {"id": "4", "task": "Menutup toko (Close Store)", "required": true}
]'::jsonb,
'[
    {"type": "open_store", "description": "Foto saat membuka toko", "required": true},
    {"type": "stock_opname", "description": "Foto saat stock opname", "required": true},
    {"type": "close_store", "description": "Foto saat menutup toko", "required": true}
]'::jsonb
);

-- 5. Driver
INSERT INTO jobdesk_templates (division, department, title, description, tasks, photo_requirements) VALUES
('Driver', 'Logistics', 'Driver Harian', 'Template untuk driver pengiriman',
'[
    {"id": "1", "task": "Berangkat dari kantor/cabang", "required": true},
    {"id": "2", "task": "Mengecek kendaraan dan bahan bakar", "required": true},
    {"id": "3", "task": "Menjalankan rute pengiriman", "required": true},
    {"id": "4", "task": "Mengantar barang ke customer", "required": true},
    {"id": "5", "task": "Foto dokumentasi pengiriman", "required": true}
]'::jsonb,
'[
    {"type": "berangkat", "description": "Foto saat berangkat dari kantor", "required": true},
    {"type": "pengiriman", "description": "Foto saat pengiriman dengan geotag", "required": true}
]'::jsonb
);

-- Add more templates for remaining divisions (simplified)
INSERT INTO jobdesk_templates (division, department, title, description, tasks, photo_requirements) VALUES
('Teknisi', 'Technical', 'Teknisi Harian', 'Template untuk teknisi service', '[{"id": "1", "task": "Penerimaan barang service", "required": true}, {"id": "2", "task": "Proses perbaikan", "required": true}, {"id": "3", "task": "Testing hasil perbaikan", "required": true}]'::jsonb, '[{"type": "penerimaan", "description": "Foto barang yang diterima", "required": true}, {"type": "proses", "description": "Foto proses perbaikan", "required": true}]'::jsonb),
('PPIC', 'Operations', 'PPIC Harian', 'Template untuk PPIC', '[{"id": "1", "task": "Monitoring stok", "required": true}, {"id": "2", "task": "Koordinasi pengiriman", "required": true}]'::jsonb, '[{"type": "monitoring", "description": "Foto monitoring", "required": true}]'::jsonb),
('Gudang', 'Operations', 'Gudang Harian', 'Template untuk gudang', '[{"id": "1", "task": "Penerimaan barang", "required": true}, {"id": "2", "task": "Penyimpanan", "required": true}, {"id": "3", "task": "Pengeluaran barang", "required": true}]'::jsonb, '[{"type": "penerimaan", "description": "Foto penerimaan", "required": true}, {"type": "pengeluaran", "description": "Foto pengeluaran", "required": true}]'::jsonb),
('Call Center', 'Support', 'Call Center Harian', 'Template untuk call center', '[{"id": "1", "task": "Menerima telepon customer", "required": true}, {"id": "2", "task": "Input data ke sistem", "required": true}]'::jsonb, '[{"type": "layanan", "description": "Foto saat melayani", "required": true}]'::jsonb),
('Kurir', 'Logistics', 'Kurir Harian', 'Template untuk kurir', '[{"id": "1", "task": "Pick up barang", "required": true}, {"id": "2", "task": "Delivery ke customer", "required": true}]'::jsonb, '[{"type": "pickup", "description": "Foto pick up", "required": true}, {"type": "delivery", "description": "Foto delivery", "required": true}]'::jsonb),
('Security', 'Security', 'Security Harian', 'Template untuk security', '[{"id": "1", "task": "Patroli area", "required": true}, {"id": "2", "task": "Cek keluar masuk", "required": true}]'::jsonb, '[{"type": "patroli", "description": "Foto patroli", "required": true}]'::jsonb),
('Helper', 'Support', 'Helper Harian', 'Template untuk helper', '[{"id": "1", "task": "Bantu proses barang", "required": true}, {"id": "2", "task": "Bersihkan area", "required": true}]'::jsonb, '[{"type": "kerja", "description": "Foto saat bekerja", "required": true}]'::jsonb),
('Packing', 'Operations', 'Packing Harian', 'Template untuk packing', '[{"id": "1", "task": "Terima barang untuk packing", "required": true}, {"id": "2", "task": "Proses packing", "required": true}, {"id": "3", "task": "Labeling", "required": true}]'::jsonb, '[{"type": "packing", "description": "Foto proses packing", "required": true}]'::jsonb),
('Admin Marketing', 'Marketing', 'Admin Marketing Harian', 'Template untuk admin marketing', '[{"id": "1", "task": "Update sosial media", "required": true}, {"id": "2", "task": "Balas DM dan komentar", "required": true}]'::jsonb, '[{"type": "update", "description": "Screenshot update", "required": true}]'::jsonb),
('Upload Shopee', 'E-commerce', 'Upload Shopee Harian', 'Template untuk upload Shopee', '[{"id": "1", "task": "Upload produk baru", "required": true}, {"id": "2", "task": "Update stok", "required": true}]'::jsonb, '[{"type": "upload", "description": "Screenshot upload", "required": true}]'::jsonb),
('Content Creator', 'Marketing', 'Content Creator Harian', 'Template untuk content creator', '[{"id": "1", "task": "Buat konten foto/video", "required": true}, {"id": "2", "task": "Edit dan upload", "required": true}]'::jsonb, '[{"type": "konten", "description": "Foto/video konten", "required": true}]'::jsonb),
('Checkin Online', 'E-commerce', 'Checkin Online Harian', 'Template untuk checkin online', '[{"id": "1", "task": "Cek pesanan online", "required": true}, {"id": "2", "task": "Proses pesanan", "required": true}]'::jsonb, '[{"type": "proses", "description": "Screenshot proses", "required": true}]'::jsonb),
('Cs Shopee', 'E-commerce', 'CS Shopee Harian', 'Template untuk CS Shopee', '[{"id": "1", "task": "Balas chat customer", "required": true}, {"id": "2", "task": "Proses komplain", "required": true}]'::jsonb, '[{"type": "layanan", "description": "Screenshot chat", "required": true}]'::jsonb),
('Cs Tiktok', 'E-commerce', 'CS Tiktok Harian', 'Template untuk CS Tiktok', '[{"id": "1", "task": "Balas komentar", "required": true}, {"id": "2", "task": "Proses pesanan", "required": true}]'::jsonb, '[{"type": "layanan", "description": "Screenshot layanan", "required": true}]'::jsonb),
('Dana Karyawan', 'Finance', 'Dana Karyawan', 'Template untuk admin dana karyawan', '[{"id": "1", "task": "Proses pinjaman", "required": true}, {"id": "2", "task": "Update laporan", "required": true}]'::jsonb, '[{"type": "dokumentasi", "description": "Foto dokumentasi", "required": true}]'::jsonb),
('Pemasangan', 'Technical', 'Pemasangan Harian', 'Template untuk teknisi pemasangan', '[{"id": "1", "task": "Survey lokasi", "required": true}, {"id": "2", "task": "Proses pemasangan", "required": true}, {"id": "3", "task": "Testing hasil", "required": true}]'::jsonb, '[{"type": "pemasangan", "description": "Foto pemasangan", "required": true}]'::jsonb),
('Komplain Online', 'Support', 'Komplain Online Harian', 'Template untuk komplain online', '[{"id": "1", "task": "Terima komplain", "required": true}, {"id": "2", "task": "Proses solusi", "required": true}]'::jsonb, '[{"type": "proses", "description": "Screenshot proses", "required": true}]'::jsonb),
('Retur', 'Operations', 'Retur Harian', 'Template untuk retur', '[{"id": "1", "task": "Terima barang retur", "required": true}, {"id": "2", "task": "Cek kondisi", "required": true}, {"id": "3", "task": "Proses retur", "required": true}]'::jsonb, '[{"type": "retur", "description": "Foto barang retur", "required": true}]'::jsonb),
('Setor Nota', 'Finance', 'Setor Nota Harian', 'Template untuk setor nota', '[{"id": "1", "task": "Kumpulkan nota", "required": true}, {"id": "2", "task": "Rekap nota", "required": true}]'::jsonb, '[{"type": "nota", "description": "Foto nota", "required": true}]'::jsonb),
('Angsuran', 'Finance', 'Angsuran Harian', 'Template untuk angsuran', '[{"id": "1", "task": "Cek jadwal angsuran", "required": true}, {"id": "2", "task": "Proses pembayaran", "required": true}]'::jsonb, '[{"type": "angsuran", "description": "Foto proses", "required": true}]'::jsonb);
