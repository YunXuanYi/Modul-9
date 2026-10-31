-- MODUL 9: REDUNDANSI DAN DENORMALISASI
-- 1. TAHAP 1: Query JOIN sebelum dengan Agregasi
SELECT 
    c.customerNumber,
    c.customerName,
    COUNT(p.checkNumber) AS total_transaksi,
    SUM(p.amount) AS total_belanja
FROM 
    customers c
JOIN 
    payments p ON c.customerNumber = p.customerNumber
GROUP BY 
    c.customerNumber, 
    c.customerName
ORDER BY 
    total_belanja DESC;


-- 2. TAHAP 2: Denormalisasi (DDL & Update Data)
ALTER TABLE customers 
ADD COLUMN total_belanja DECIMAL(15,2) DEFAULT 0;

-- Mengisi/memperbarui data kolom turunan berdasarkan hasil agregasi tabel payments
UPDATE customers c
JOIN (
    SELECT customerNumber, SUM(amount) AS total
    FROM payments
    GROUP BY customerNumber
) p ON c.customerNumber = p.customerNumber
SET c.total_belanja = p.total;


-- 3. TAHAP 3: Memanggil data langsung dari tabel master yang sudah didenormalisasi
SELECT customerNumber, customerName, total_belanja 
FROM customers 
WHERE total_belanja > 0;
