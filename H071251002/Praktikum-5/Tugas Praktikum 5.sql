SET search_path to classicmodels;
-- NO 1
SELECT c.contactfirstname AS nama_depan,
    o.city,
    c.customername AS nama_lengkap, 
    CONCAT(e.firstname, ' ', e.lastname) AS sales_rep_name
FROM customers c
JOIN employees e
ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN offices o
ON e.officecode = o.officecode
WHERE c.contactfirstname ILIKE 'A%' AND o.city != 'NYC'
ORDER BY nama_lengkap ASC;

-- NO 2
SELECT c.customername,
    SUM(p.amount) AS total_payment, 
    MAX(p.amount) AS  max_single_payment
FROM customers c
JOIN payments p
    ON c.customernumber = p.customernumber
GROUP BY c.customername, c.customernumber
HAVING SUM(p.amount) >50000
ORDER BY total_payment DESC;

-- NO 3
SELECT c.customername AS nama_customer, 
    COUNT (DISTINCT o.orderNumber) AS total_order,
    ROUND(AVG(od.quantityOrdered),2) AS avg_quantity_per_order
FROM customers c
JOIN orders o
    ON c.customernumber = o.customernumber
JOIN orderdetails od
    ON o.ordernumber = od.ordernumber
GROUP BY c.customername
HAVING COUNT (DISTINCT o.orderNumber) > 3 AND ROUND(AVG(od.quantityOrdered),2) > 35
ORDER BY total_order DESC, avg_quantity_per_order DESC;


-- NO 4
SELECT p.productline, 
    SUM (od.quantityOrdered) AS total_terjual,
    ROUND (AVG(priceEach),2) AS rata_rata_harga,
    ROUND(AVG(((MSRP-priceEach)/MSRP)*100),2) AS avg_discount_percentage
FROM Orderdetails od
JOIN Products p
    ON od.productcode = p.productcode
GROUP BY p.productline
HAVING SUM (od.quantityOrdered) > 3000 AND ROUND (AVG(priceEach),2) >80
ORDER BY total_terjual DESC;

-- NO 5
SELECT c.customername, SUM(od.quantityordered * od.priceeach) AS total_transaksi,
    COUNT(DISTINCT (o.status = 'Shipped', o.ordernumber)) AS total_shipped_orders,
    ROUND(SUM(od.quantityordered * od.priceeach) / COUNT(DISTINCT o.ordernumber), 2) AS avg_transaction_per_order
FROM customers AS c
JOIN orders AS o
    ON c.customernumber = o.customernumber
JOIN orderdetails AS od
    ON o.ordernumber = od.ordernumber
GROUP BY c.customername
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM o.orderdate)) > 1
ORDER BY total_transaksi DESC
LIMIT 5;

-- NO 6
SELECT c.customername, 
    c.city AS customer_city, 
    o.city AS office_city, 
    SUM(od.quantityOrdered) AS total_unit_terjual,
    ROUND(SUM(od.quantityordered*od.priceeach)/COUNT(DISTINCT ord.ordernumber),2) AS avg_nilai_per_order
FROM customers c
JOIN employees e
    ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN offices o
    ON e.officecode = o.officecode
JOIN orders ord
    ON c.customernumber = ord.customernumber
JOIN orderdetails od
    ON ord.ordernumber = od.ordernumber
WHERE o.territory = 'EMEA'
GROUP BY c.customername, o.city, c.city
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM ord.orderDate)) > 2 AND 
    SUM(od.quantityOrdered) > 1000 AND 
    ROUND(SUM(od.quantityordered*od.priceeach)/COUNT(DISTINCT ord.ordernumber),2) >10000
ORDER BY avg_nilai_per_order DESC;


-- STUDY CASE
SELECT c.customername AS nama_perusahaan,
    c.country AS negara_asal,
    CONCAT(e.firstname, ' ', e.lastname) AS nama_lengkap_karyawan,
    COUNT (p.amount) AS frekuensi_pembayaran,
    SUM (p.amount) AS total_pembayaran
FROM customers c
JOIN employees e
    ON c.salesrepemployeenumber = e.employeenumber
JOIN payments p
    ON c.customernumber = p.customernumber
WHERE c.contactfirstname ILIKE '%a%' AND c.country != 'USA'
GROUP BY c.customername, c.country, nama_lengkap_karyawan
HAVING SUM (p.amount) > 50000 AND COUNT (p.amount) >= 2
ORDER BY total_pembayaran DESC;


SELECT pro.productline AS lini_produk,
    COUNT (DISTINCT o.ordernumber) as jumlah_nota_unik,
    SUM(od.quantityOrdered) as barang_terjual,
    ROUND(AVG(od.priceEach),2) as rata_rata,
    SUM(od.quantityordered * od.priceEach) as omzet   
FROM products pro
JOIN orderdetails od
ON pro.productcode = od.productcode    
JOIN orders o
ON o.ordernumber = od.ordernumber
JOIN payments p
on o.customernumber = p.customernumber
WHERE pro.buyPrice > 30 AND o.status = 'Shipped'
GROUP BY pro.productline 
HAVING SUM(od.quantityOrdered) > 20000 AND ROUND(AVG(od.priceEach),2) > 85
ORDER BY omzet DESC
LIMIT 3;

SELECT * FROM orderdetails;