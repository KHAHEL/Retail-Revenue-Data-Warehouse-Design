-- ============================================================
-- DATA WAREHOUSE - PT Nusantara Retail Indonesia
-- Snowflake Schema DDL Script
-- Mata Kuliah: ETL & Data Warehouse - Kelompok 1
-- ============================================================
 
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'DW_NusantaraRetail')
BEGIN
    CREATE DATABASE DW_NusantaraRetail;
END
GO
 
USE DW_NusantaraRetail;
GO
 
-- ============================================================
-- DROP TABLES
-- ============================================================
IF OBJECT_ID('dbo.Fact_Revenue',    'U') IS NOT NULL DROP TABLE dbo.Fact_Revenue;
IF OBJECT_ID('dbo.Dim_Cabang',      'U') IS NOT NULL DROP TABLE dbo.Dim_Cabang;
IF OBJECT_ID('dbo.Dim_Tipe_Cabang', 'U') IS NOT NULL DROP TABLE dbo.Dim_Tipe_Cabang;
IF OBJECT_ID('dbo.Dim_Wilayah',     'U') IS NOT NULL DROP TABLE dbo.Dim_Wilayah;
IF OBJECT_ID('dbo.Dim_Kota',        'U') IS NOT NULL DROP TABLE dbo.Dim_Kota;
IF OBJECT_ID('dbo.Dim_Provinsi',    'U') IS NOT NULL DROP TABLE dbo.Dim_Provinsi;
IF OBJECT_ID('dbo.Dim_Region',      'U') IS NOT NULL DROP TABLE dbo.Dim_Region;
IF OBJECT_ID('dbo.Dim_Waktu',       'U') IS NOT NULL DROP TABLE dbo.Dim_Waktu;
IF OBJECT_ID('dbo.Dim_Bulan',       'U') IS NOT NULL DROP TABLE dbo.Dim_Bulan;
IF OBJECT_ID('dbo.Dim_Kuartal',     'U') IS NOT NULL DROP TABLE dbo.Dim_Kuartal;
GO
 
-- ============================================================
-- DIMENSI WILAYAH
-- ============================================================
 
CREATE TABLE dbo.Dim_Provinsi (
    ID_Provinsi     VARCHAR(20) PRIMARY KEY,  -- Format: PROV_1, PROV_2, ...
    Nama_Provinsi   VARCHAR(100) NOT NULL
);
 
CREATE TABLE dbo.Dim_Region (
    ID_Region       VARCHAR(20) PRIMARY KEY,
    Nama_Region     VARCHAR(100) NOT NULL
);
 
CREATE TABLE dbo.Dim_Kota (
    ID_Kota         VARCHAR(20) PRIMARY KEY,
    Nama_Kota       VARCHAR(100) NOT NULL
);
 
CREATE TABLE dbo.Dim_Wilayah (
    ID_Wilayah          VARCHAR(20) PRIMARY KEY,
    Nama_Wilayah        VARCHAR(150) NOT NULL,
    Populasi_Wilayah    INT,
    ID_Kota             VARCHAR(20) NOT NULL REFERENCES dbo.Dim_Kota(ID_Kota),
    ID_Provinsi         VARCHAR(20) NOT NULL REFERENCES dbo.Dim_Provinsi(ID_Provinsi),
    ID_Region           VARCHAR(20) NOT NULL REFERENCES dbo.Dim_Region(ID_Region)
);
 
-- ============================================================
-- DIMENSI CABANG
-- ============================================================
 
CREATE TABLE dbo.Dim_Tipe_Cabang (
    ID_Tipe         VARCHAR(20) PRIMARY KEY,
    Nama_Tipe       VARCHAR(50) NOT NULL
);
 
CREATE TABLE dbo.Dim_Cabang (
    ID_Cabang       VARCHAR(20) PRIMARY KEY,
    Nama_Cabang     VARCHAR(150) NOT NULL,
    Kode_Cabang     VARCHAR(20)  NOT NULL,
    Status_Aktif    BIT          NOT NULL DEFAULT 1,
    ID_Tipe         VARCHAR(20) NOT NULL REFERENCES dbo.Dim_Tipe_Cabang(ID_Tipe)
);
 
-- ============================================================
-- DIMENSI WAKTU
-- ============================================================
 
CREATE TABLE dbo.Dim_Kuartal (
    ID_Kuartal      VARCHAR(20) PRIMARY KEY,
    Nama_Kuartal    VARCHAR(30) NOT NULL
);
 
CREATE TABLE dbo.Dim_Bulan (
    ID_Bulan        VARCHAR(20) PRIMARY KEY,
    Nama_Bulan      VARCHAR(20) NOT NULL
);
 
CREATE TABLE dbo.Dim_Waktu (
    ID_Waktu        VARCHAR(20) PRIMARY KEY,
    Hari_Kerja      INT NOT NULL,
    ID_Bulan        VARCHAR(20) NOT NULL REFERENCES dbo.Dim_Bulan(ID_Bulan),
    ID_Kuartal      VARCHAR(20) NOT NULL REFERENCES dbo.Dim_Kuartal(ID_Kuartal)
);
 
-- ============================================================
-- TABEL FAKTA
-- ============================================================
 
CREATE TABLE dbo.Fact_Revenue (
    ID_Revenue              VARCHAR(20) PRIMARY KEY,
    ID_Wilayah              VARCHAR(20) NOT NULL REFERENCES dbo.Dim_Wilayah(ID_Wilayah),
    ID_Cabang               VARCHAR(20) NOT NULL REFERENCES dbo.Dim_Cabang(ID_Cabang),
    ID_Waktu                VARCHAR(20) NOT NULL REFERENCES dbo.Dim_Waktu(ID_Waktu),
    Total_Revenue_Rp        BIGINT        NOT NULL,
    Jumlah_Cabang_Aktif     INT           NOT NULL,
    Revenue_Per_Cabang      DECIMAL(20,2) NOT NULL
);
GO
 
-- ============================================================
-- INSERT DATA - Dim_Provinsi
-- ============================================================
INSERT INTO dbo.Dim_Provinsi VALUES
('PROV_1',  'DKI Jakarta'),
('PROV_2',  'Jawa Barat'),
('PROV_3',  'Jawa Timur'),
('PROV_4',  'Jawa Tengah'),
('PROV_5',  'Banten'),
('PROV_6',  'Sumatera Utara'),
('PROV_7',  'Sulawesi Selatan'),
('PROV_8',  'Kalimantan Timur'),
('PROV_9',  'Bali'),
('PROV_10', 'Riau');
 
-- ============================================================
-- INSERT DATA - Dim_Region
-- ============================================================
INSERT INTO dbo.Dim_Region VALUES
('REG_1', 'Region Barat'),
('REG_2', 'Region Timur'),
('REG_3', 'Region Tengah'),
('REG_4', 'Region Utara'),
('REG_5', 'Region Selatan');
 
-- ============================================================
-- INSERT DATA - Dim_Kota
-- ============================================================
INSERT INTO dbo.Dim_Kota VALUES
('KOTA_1',  'Jakarta Pusat'),
('KOTA_2',  'Bandung'),
('KOTA_3',  'Surabaya'),
('KOTA_4',  'Semarang'),
('KOTA_5',  'Tangerang'),
('KOTA_6',  'Medan'),
('KOTA_7',  'Makassar'),
('KOTA_8',  'Balikpapan'),
('KOTA_9',  'Denpasar'),
('KOTA_10', 'Pekanbaru');
 
-- ============================================================
-- INSERT DATA - Dim_Wilayah
-- ============================================================
INSERT INTO dbo.Dim_Wilayah VALUES
('WIL_1',  'Wilayah Jakarta Pusat', 2500000, 'KOTA_1',  'PROV_1',  'REG_1'),
('WIL_2',  'Wilayah Bandung',       1800000, 'KOTA_2',  'PROV_2',  'REG_2'),
('WIL_3',  'Wilayah Surabaya',      2100000, 'KOTA_3',  'PROV_3',  'REG_3'),
('WIL_4',  'Wilayah Semarang',      1500000, 'KOTA_4',  'PROV_4',  'REG_4'),
('WIL_5',  'Wilayah Tangerang',     2000000, 'KOTA_5',  'PROV_1',  'REG_5'),
('WIL_6',  'Wilayah Medan',         1700000, 'KOTA_6',  'PROV_6',  'REG_4'),
('WIL_7',  'Wilayah Makassar',      1300000, 'KOTA_7',  'PROV_7',  'REG_2'),
('WIL_8',  'Wilayah Balikpapan',    1100000, 'KOTA_8',  'PROV_8',  'REG_2'),
('WIL_9',  'Wilayah Bali',          1600000, 'KOTA_9',  'PROV_9',  'REG_2'),
('WIL_10', 'Wilayah Pekanbaru',     1200000, 'KOTA_10', 'PROV_10', 'REG_4');
 
-- ============================================================
-- INSERT DATA - Dim_Tipe_Cabang
-- ============================================================
INSERT INTO dbo.Dim_Tipe_Cabang VALUES
('TIPE_1', 'Cabang Utama'),
('TIPE_2', 'Cabang Pembantu'),
('TIPE_3', 'Kantor Kas');
 
-- ============================================================
-- INSERT DATA - Dim_Cabang
-- ============================================================
INSERT INTO dbo.Dim_Cabang VALUES
('CAB_1',  'Cabang Jakarta Pusat',  'CB-JKT-001', 1, 'TIPE_1'),
('CAB_2',  'Cabang Gajah Mada',     'CB-JKT-002', 1, 'TIPE_1'),
('CAB_3',  'Cabang Bandung Kota',   'CB-BDG-001', 1, 'TIPE_2'),
('CAB_4',  'Cabang Dago',           'CB-BDG-002', 1, 'TIPE_2'),
('CAB_5',  'Cabang Surabaya Raya',  'CB-SBY-001', 1, 'TIPE_1'),
('CAB_6',  'Kas Semarang Tengah',   'CB-SMG-001', 1, 'TIPE_3'),
('CAB_7',  'Cabang Tangerang',      'CB-TNG-001', 1, 'TIPE_1'),
('CAB_8',  'Cabang Medan Kota',     'CB-MDN-001', 1, 'TIPE_2'),
('CAB_9',  'Cabang Makassar',       'CB-MKS-001', 1, 'TIPE_1'),
('CAB_10', 'Cabang Balikpapan',     'CB-BPP-001', 0, 'TIPE_2'),
('CAB_11', 'Cabang Denpasar',       'CB-DPS-001', 1, 'TIPE_1'),
('CAB_12', 'Kas Pekanbaru',         'CB-PKU-001', 1, 'TIPE_3');
 
-- ============================================================
-- INSERT DATA - Dim_Kuartal
-- ============================================================
INSERT INTO dbo.Dim_Kuartal VALUES
('KUA_1', 'Q1 - Jan s/d Mar'),
('KUA_2', 'Q2 - Apr s/d Jun'),
('KUA_3', 'Q3 - Jul s/d Sep'),
('KUA_4', 'Q4 - Okt s/d Des');
 
-- ============================================================
-- INSERT DATA - Dim_Bulan
-- ============================================================
INSERT INTO dbo.Dim_Bulan VALUES
('BLN_1',  'Januari'),  ('BLN_2',  'Februari'), ('BLN_3',  'Maret'),
('BLN_4',  'April'),    ('BLN_5',  'Mei'),       ('BLN_6',  'Juni'),
('BLN_7',  'Juli'),     ('BLN_8',  'Agustus'),   ('BLN_9',  'September'),
('BLN_10', 'Oktober'),  ('BLN_11', 'November'),  ('BLN_12', 'Desember');
 
-- ============================================================
-- INSERT DATA - Dim_Waktu
-- ============================================================
INSERT INTO dbo.Dim_Waktu VALUES
('WKT_1',  22, 'BLN_1',  'KUA_1'),
('WKT_2',  20, 'BLN_2',  'KUA_1'),
('WKT_3',  21, 'BLN_3',  'KUA_1'),
('WKT_4',  22, 'BLN_4',  'KUA_2'),
('WKT_5',  23, 'BLN_5',  'KUA_2'),
('WKT_6',  20, 'BLN_6',  'KUA_2'),
('WKT_7',  23, 'BLN_7',  'KUA_3'),
('WKT_8',  22, 'BLN_8',  'KUA_3'),
('WKT_9',  21, 'BLN_9',  'KUA_3'),
('WKT_10', 23, 'BLN_10', 'KUA_4'),
('WKT_11', 21, 'BLN_11', 'KUA_4'),
('WKT_12', 22, 'BLN_12', 'KUA_4');
 
-- ============================================================
-- INSERT DATA - Fact_Revenue
-- ============================================================
INSERT INTO dbo.Fact_Revenue VALUES
('REV_1',  'WIL_2',  'CAB_1',  'WKT_12', 1737631933, 2, 868815966.50),
('REV_2',  'WIL_3',  'CAB_12', 'WKT_2',  3545147693, 5, 709029538.60),
('REV_3',  'WIL_2',  'CAB_10', 'WKT_7',  643022058,  1, 643022058.00),
('REV_4',  'WIL_4',  'CAB_4',  'WKT_9',  3209084281, 5, 641816856.20),
('REV_5',  'WIL_4',  'CAB_12', 'WKT_11', 3655962381, 4, 913990595.30),
('REV_6',  'WIL_4',  'CAB_8',  'WKT_10', 1751858187, 1, 1751858187.00),
('REV_7',  'WIL_3',  'CAB_12', 'WKT_7',  2031127324, 2, 1015563662.00),
('REV_8',  'WIL_4',  'CAB_6',  'WKT_2',  917356295,  1, 917356295.00),
('REV_9',  'WIL_6',  'CAB_6',  'WKT_10', 1690343902, 1, 1690343902.00),
('REV_10', 'WIL_8',  'CAB_9',  'WKT_2',  4879020938, 4, 1219755235.00),
('REV_11', 'WIL_2',  'CAB_9',  'WKT_5',  4232320989, 5, 846464197.80),
('REV_12', 'WIL_6',  'CAB_10', 'WKT_4',  3670573263, 1, 3670573263.00),
('REV_13', 'WIL_4',  'CAB_5',  'WKT_2',  4348929745, 1, 4348929745.00),
('REV_14', 'WIL_7',  'CAB_5',  'WKT_8',  3360579999, 3, 1120193333.00),
('REV_15', 'WIL_3',  'CAB_6',  'WKT_6',  1442781638, 3, 480927212.70),
('REV_16', 'WIL_2',  'CAB_10', 'WKT_11', 1270123917, 2, 635061958.50),
('REV_17', 'WIL_3',  'CAB_8',  'WKT_7',  1714765221, 5, 342953044.20),
('REV_18', 'WIL_4',  'CAB_11', 'WKT_6',  4292833641, 1, 4292833641.00),
('REV_19', 'WIL_4',  'CAB_1',  'WKT_6',  2305241542, 1, 2305241542.00),
('REV_20', 'WIL_4',  'CAB_10', 'WKT_12', 1916050464, 4, 479012616.00);
GO
 
-- ============================================================
-- VERIFIKASI DATA
-- ============================================================
SELECT 'Fact_Revenue'    AS Tabel, COUNT(*) AS JumlahBaris FROM dbo.Fact_Revenue    UNION ALL
SELECT 'Dim_Wilayah',              COUNT(*)               FROM dbo.Dim_Wilayah      UNION ALL
SELECT 'Dim_Provinsi',             COUNT(*)               FROM dbo.Dim_Provinsi     UNION ALL
SELECT 'Dim_Region',               COUNT(*)               FROM dbo.Dim_Region       UNION ALL
SELECT 'Dim_Kota',                 COUNT(*)               FROM dbo.Dim_Kota         UNION ALL
SELECT 'Dim_Cabang',               COUNT(*)               FROM dbo.Dim_Cabang       UNION ALL
SELECT 'Dim_Tipe_Cabang',          COUNT(*)               FROM dbo.Dim_Tipe_Cabang  UNION ALL
SELECT 'Dim_Waktu',                COUNT(*)               FROM dbo.Dim_Waktu        UNION ALL
SELECT 'Dim_Bulan',                COUNT(*)               FROM dbo.Dim_Bulan        UNION ALL
SELECT 'Dim_Kuartal',              COUNT(*)               FROM dbo.Dim_Kuartal;
GO
 
-- ============================================================
-- QUERY KPI - Total Revenue per Wilayah per Cabang
-- ============================================================
SELECT
    w.ID_Wilayah,
    w.Nama_Wilayah,
    p.ID_Provinsi,
    p.Nama_Provinsi,
    r.ID_Region,
    r.Nama_Region,
    c.ID_Cabang,
    c.Nama_Cabang,
    c.Kode_Cabang,
    t.ID_Tipe,
    t.Nama_Tipe        AS Tipe_Cabang,
    wt.ID_Waktu,
    b.ID_Bulan,
    b.Nama_Bulan,
    k.ID_Kuartal,
    k.Nama_Kuartal,
    f.Total_Revenue_Rp,
    f.Jumlah_Cabang_Aktif,
    f.Revenue_Per_Cabang
FROM dbo.Fact_Revenue f
JOIN dbo.Dim_Wilayah      w  ON f.ID_Wilayah  = w.ID_Wilayah
JOIN dbo.Dim_Provinsi     p  ON w.ID_Provinsi  = p.ID_Provinsi
JOIN dbo.Dim_Region       r  ON w.ID_Region    = r.ID_Region
JOIN dbo.Dim_Cabang       c  ON f.ID_Cabang    = c.ID_Cabang
JOIN dbo.Dim_Tipe_Cabang  t  ON c.ID_Tipe      = t.ID_Tipe
JOIN dbo.Dim_Waktu        wt ON f.ID_Waktu     = wt.ID_Waktu
JOIN dbo.Dim_Bulan        b  ON wt.ID_Bulan    = b.ID_Bulan
JOIN dbo.Dim_Kuartal      k  ON wt.ID_Kuartal  = k.ID_Kuartal
ORDER BY w.Nama_Wilayah, c.Nama_Cabang;
GO