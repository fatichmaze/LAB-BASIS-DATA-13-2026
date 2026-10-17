SET search_path TO classicmodels;

-- 1
SELECT 
customerNumber AS "Nomor Identifikasi",
SUM (amount) AS "Akumulasi Dana", 
count (DcheckNumber) AS "Frekuensi Transaksi",
MAX(amount) AS "Transaksi Terbesar"
FROM payments
GROUP BY customerNumber
HAVING count(DISTINCT checkNumber) > 4 and AVG(amount)>20000;

SELECT * FROM payments;

-- 2.

SELECT customerNumber AS "Nomor Identifikasi Pelanggan",
SUM (amount) AS "Total Setoran"
FROM payments
GROUP BY customerNumber
HAVING sum (amount) >80000
ORDER BY "Total Setoran" DESC;

-- 3.

SELECT productLine AS "Nama Kategori Barang", 
COUNT (ProductLine) AS "Jumlah Ragam Produk",
ROUND(AVG(MSRP),2) AS "Rata-rata Harga Jual",
STRING_AGG (productName, ', ' ORDER BY productName) AS "Nama-nama Produk"
FROM products
GROUP BY productLine
HAVING COUNT (ProductLine) > 10;

-- 4

SELECT DISTINCT reportsTo AS "Daftar Penerima Tunjangan"
FROM employees
WHERE reportsTo IS NOT NULL
EXCEPT
SELECT employeeNumber
FROM employees
WHERE jobtitle ILIKE '%VP%' OR jobtitle ILIKE '%President%';


-- 5.

SELECT ProductCode AS  "Kode Identifikasi", 
SUM(quantityOrdered) AS "total unit fisik terjual", 
ROUND(AVG(PriceEach), 2) AS "rata-rata harga riil"
FROM orderDetails
WHERE priceEach > 100
GROUP BY productCode
HAVING SUM(quantityOrdered)  > 50
ORDER BY  "total unit fisik terjual" DESC;


-- 6.

SELECT productCode AS "Kode Identifikasi",
SUM(quantityOrdered)AS  "Total yang dipesan", 
SUM(quantityOrdered * priceEach) AS "Estimasi pendapatan kotor",
ROUND (AVG(priceEach), 2) AS "Rata-rata harga riil",
MAX(priceEach)-MIN(priceEach) AS "Rentang volatilitas"
FROM orderDetails
WHERE quantityOrdered > 20
GROUP BY productCode
HAVING SUM(quantityOrdered * priceEach) > 50000
ORDER BY "Estimasi pendapatan kotor" DESC;

-- 7.

SELECT customerNumber
FROM customers
WHERE creditLimit > 80000
INTERSECT 
SELECT customerNumber
FROM orders
WHERE Status ='Cancelled' OR Status ='On Hold'
EXCEPT 
SELECT customerNumber
FROM payments
GROUP BY customerNumber
HAVING SUM(amount) >100000;


SELECT * FROM CUSTOMERS;