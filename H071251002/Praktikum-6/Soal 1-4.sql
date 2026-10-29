SET SEARCH_PATH TO classicmodels;

-- NO 1.
SELECT productCode AS kode_produk, productName AS nama_produk, quantityinStock AS jumlah_stok, 
CASE 
    WHEN MSRP < 50 AND quantityinStock > 500 THEN 'Ekonomis - Stok Tinggi'
    WHEN MSRP < 50 AND quantityinStock >= 500 THEN 'Ekonomis - Stok Rendah'
    WHEN MSRP BETWEEN 50 AND 100 AND quantityinStock > 500 THEN 'Harga Menengah'
    ELSE 'Harga Premium' 
END AS kategori
FROM products 
ORDER BY MSRP DESC;

-- NO 2.
SELECT productCode AS kode_produk, SUM(quantityOrdered) AS total_terjual, COUNT (DISTINCT orderNumber) AS jumlah_pesanan
FROM orderDetails
GROUP BY productCode
HAVING SUM (quantityordered) > (
    SELECT AVG(quantityOrdered) FROM orderdetails ) AND
    COUNT (ordernumber) > 10
ORDER BY total_terjual DESC;


-- NO 3.
SELECT productCode as kode_produk, productname as nama_produk, quantityInstock AS jumlah_stok, MSRP 
FROM products
WHERE quantityInstock > (SELECT AVG (quantityInStock) FROM products) 
       AND MSRP > (SELECT AVG (MSRP) FROM products)
ORDER BY jumlah_stok DESC;

-- 1. Menampilkan data pesanan sebelum dilakukan perubahan
SELECT orderNumber AS nomor_pesanan, status 
FROM orders
WHERE orderNumber = 10100;

-- 2. Memulai transaksi
BEGIN;

-- 3. Mengubah status menjadi Pengiriman
UPDATE orders
SET status = 'Pengiriman'
WHERE orderNumber = 10100;

-- 4. Membuat SAVEPOINT
SAVEPOINT status_pengiriman;

-- 5. Mengubah status menjadi Batal
UPDATE orders
SET status = 'Batal'
WHERE orderNumber = 10100;

-- 6. Membatalkan perubahan setelah SAVEPOINT
ROLLBACK TO SAVEPOINT status_pengiriman;

-- 7. Memeriksa status setelah rollback
SELECT orderNumber AS nomor_pesanan, status
FROM orders
WHERE orderNumber = 10100;

ROLLBACK;

-- 8. Menyimpan perubahan yang dipertahankan
COMMIT;



