-- Membuat atau menggantikan tabel pada dataset kf_analisis
CREATE OR REPLACE TABLE `rakamin-kf-analytics-467707.kimia_farma.kf_analisis` AS
SELECT
  ft.transaction_id,                         -- ID transaksi
  ft.date,                                   -- Tanggal transaksi
  kc.branch_id,                              -- ID cabang
  kc.branch_name,                            -- Nama cabang
  kc.kota,                                   -- Kota cabang
  kc.provinsi,                               -- Provinsi cabang
  kc.rating AS rating_cabang,                -- Rating cabang dari tabel kc
  ft.customer_name,                          -- Nama pelanggan
  p.product_id,                              -- ID produk
  p.product_name,                            -- Nama produk
  ft.price AS actual_price,                  -- Harga sebelum diskon
  ft.discount_percentage,                    -- Diskon (%)
  ft.rating AS rating_transaksi,             -- Rating yang diberikan untuk transaksi

  -- Harga setelah diskon
  (ft.price - (ft.price * ft.discount_percentage / 100)) AS nett_sales,

  -- Persentase gross laba berdasarkan kategori harga
  CASE
    WHEN ft.price <= 50000 THEN 0.10
    WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
    WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
    WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
    ELSE 0.30
  END AS persentase_gross_laba,

  -- Nett profit = nett_sales * persentase_gross_laba
  ((ft.price - (ft.price * ft.discount_percentage / 100)) *
    CASE
      WHEN ft.price <= 50000 THEN 0.10
      WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
      WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
      WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
      ELSE 0.30
    END) AS nett_profit

FROM `rakamin-kf-analytics-467707.kimia_farma.kf_final_transaction` ft
JOIN `rakamin-kf-analytics-467707.kimia_farma.kf_product` p 
  ON ft.product_id = p.product_id            -- Join produk untuk ambil nama
JOIN `rakamin-kf-analytics-467707.kimia_farma.kf_kantor_cabang` kc 
  ON ft.branch_id = kc.branch_id             -- Join cabang untuk ambil detail lokasi
