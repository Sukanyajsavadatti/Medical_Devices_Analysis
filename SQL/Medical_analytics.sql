CREATE DATABASE medical_device_analytics;

USE medical_device_analytics;

CREATE TABLE devices (
    Device_ID VARCHAR(10) PRIMARY KEY,
    Device_Name VARCHAR(100),
    Device_Category VARCHAR(50),
    Manufacturer VARCHAR(100),
    Model VARCHAR(100),
    Unit_Price DECIMAL(15,2),
    Warranty_Years INT
);

CREATE TABLE hospitals (
    Hospital_ID VARCHAR(10) PRIMARY KEY,
    Hospital_Name VARCHAR(150),
    Hospital_Type VARCHAR(50),
    City VARCHAR(50),
    State VARCHAR(50),
    Region VARCHAR(20),
    Bed_Count INT
);

CREATE TABLE sales (
    Sale_ID VARCHAR(10) PRIMARY KEY,
    Hospital_ID VARCHAR(10),
    Device_ID VARCHAR(10),
    Sales_Date DATE,
    Quantity INT,
    Unit_Price DECIMAL(15,2),
    Discount_Percent DECIMAL(5,2),
    Sales_Amount DECIMAL(15,2),
    Salesperson VARCHAR(20),
    Sales_Channel VARCHAR(30),
    FOREIGN KEY (Hospital_ID) REFERENCES hospitals(Hospital_ID),
    FOREIGN KEY (Device_ID) REFERENCES devices(Device_ID)
);

CREATE TABLE service_cases (
    Service_ID VARCHAR(10) PRIMARY KEY,
    Hospital_ID VARCHAR(10),
    Device_ID VARCHAR(10),
    Service_Date DATE,
    Service_Type VARCHAR(50),
    Issue_Category VARCHAR(50),
    Priority VARCHAR(20),
    Downtime_Hours DECIMAL(10,1),
    Resolution_Days INT,
    Warranty_Status VARCHAR(30),
    Service_Cost DECIMAL(15,2),
    Resolution_Status VARCHAR(30),
    Customer_Satisfaction INT,
    FOREIGN KEY (Hospital_ID) REFERENCES hospitals(Hospital_ID),
    FOREIGN KEY (Device_ID) REFERENCES devices(Device_ID)
);

SELECT COUNT(*) FROM devices;
SELECT COUNT(*) FROM hospitals;
SELECT COUNT(*) FROM sales;
SELECT COUNT(*) FROM service_cases;

SELECT * FROM devices LIMIT 5;
SELECT * FROM hospitals LIMIT 5;
SELECT * FROM sales LIMIT 5;
SELECT * FROM service_cases LIMIT 5;



-- ============================================================
-- SECTION 1: DATA OVERVIEW
-- ============================================================
-- 1. Total number of devices
SELECT COUNT(*) AS total_devices
FROM devices;
-- 2. Total number of hospitals
SELECT COUNT(*) AS total_hospitals
FROM hospitals;
-- 3. Total sales transactions
SELECT COUNT(*) AS total_sales_transactions
FROM sales;
-- 4. Total service cases
SELECT COUNT(*) AS total_service_cases
FROM service_cases;


-- ============================================================
-- SECTION 2: SALES PERFORMANCE
-- ============================================================
-- 5. Total sales revenue
SELECT
    ROUND(SUM(Sales_Amount), 2) AS total_revenue
FROM sales;
-- 6. Total units sold
SELECT
    SUM(Quantity) AS total_units_sold
FROM sales;
-- 7. Average sales transaction value
SELECT
    ROUND(AVG(Sales_Amount), 2) AS average_transaction_value
FROM sales;
-- 8. Revenue by device category
SELECT
    d.Device_Category,
    ROUND(SUM(s.Sales_Amount), 2) AS total_revenue
FROM sales s
JOIN devices d
    ON s.Device_ID = d.Device_ID
GROUP BY d.Device_Category
ORDER BY total_revenue DESC;


-- ============================================================
-- SECTION 3: DEVICE PERFORMANCE
-- ============================================================
-- 9. Revenue by device
SELECT
    d.Device_Name,
    d.Device_Category,
    d.Manufacturer,
    ROUND(SUM(s.Sales_Amount), 2) AS total_revenue
FROM sales s
JOIN devices d
    ON s.Device_ID = d.Device_ID
GROUP BY
    d.Device_ID,
    d.Device_Name,
    d.Device_Category,
    d.Manufacturer
ORDER BY total_revenue DESC;
-- 10. Units sold by manufacturer
SELECT
    d.Manufacturer,
    SUM(s.Quantity) AS total_units_sold
FROM sales s
JOIN devices d
    ON s.Device_ID = d.Device_ID
GROUP BY d.Manufacturer
ORDER BY total_units_sold DESC;


-- ============================================================
-- SECTION 4: HOSPITAL & REGIONAL ANALYSIS
-- ============================================================
-- 11. Revenue by region
SELECT
    h.Region,
    ROUND(SUM(s.Sales_Amount), 2) AS total_revenue
FROM sales s
JOIN hospitals h
    ON s.Hospital_ID = h.Hospital_ID
GROUP BY h.Region
ORDER BY total_revenue DESC;
-- 12. Revenue by hospital type
SELECT
    h.Hospital_Type,
    ROUND(SUM(s.Sales_Amount), 2) AS total_revenue
FROM sales s
JOIN hospitals h
    ON s.Hospital_ID = h.Hospital_ID
GROUP BY h.Hospital_Type
ORDER BY total_revenue DESC;
-- 13. Top 10 hospitals by revenue
SELECT
    h.Hospital_Name,
    h.City,
    h.State,
    ROUND(SUM(s.Sales_Amount), 2) AS total_revenue
FROM sales s
JOIN hospitals h
    ON s.Hospital_ID = h.Hospital_ID
GROUP BY
    h.Hospital_ID,
    h.Hospital_Name,
    h.City,
    h.State
ORDER BY total_revenue DESC
LIMIT 10;


-- ============================================================
-- SECTION 5: SERVICE & MAINTENANCE ANALYSIS
-- ============================================================
-- 14. Total service cost
SELECT
    ROUND(SUM(Service_Cost), 2) AS total_service_cost
FROM service_cases;
-- 15. Average service resolution time
SELECT
    ROUND(AVG(Resolution_Days), 2) AS average_resolution_days
FROM service_cases;
-- 16. Average device downtime
SELECT
    ROUND(AVG(Downtime_Hours), 2) AS average_downtime_hours
FROM service_cases;
-- 17. Service cases by service type
SELECT
    Service_Type,
    COUNT(*) AS service_case_count
FROM service_cases
GROUP BY Service_Type
ORDER BY service_case_count DESC;
-- 18. Service cases by issue category
SELECT
    Issue_Category,
    COUNT(*) AS service_case_count
FROM service_cases
GROUP BY Issue_Category
ORDER BY service_case_count DESC;
-- 19. Service cases by priority
SELECT
    Priority,
    COUNT(*) AS service_case_count
FROM service_cases
GROUP BY Priority
ORDER BY service_case_count DESC;
-- 20. Service cases by warranty status
SELECT
    Warranty_Status,
    COUNT(*) AS service_case_count,
    ROUND(SUM(Service_Cost), 2) AS total_service_cost
FROM service_cases
GROUP BY Warranty_Status
ORDER BY service_case_count DESC;
-- 21. Service cases by resolution status
SELECT
    Resolution_Status,
    COUNT(*) AS service_case_count
FROM service_cases
GROUP BY Resolution_Status
ORDER BY service_case_count DESC;
-- 22. Average customer satisfaction
SELECT
    ROUND(AVG(Customer_Satisfaction), 2) AS average_customer_satisfaction
FROM service_cases;


-- ============================================================
-- SECTION 6: DEVICE SERVICE PERFORMANCE
-- ============================================================
-- 23. Service cases by device category
SELECT
    d.Device_Category,
    COUNT(*) AS service_case_count
FROM service_cases sc
JOIN devices d
    ON sc.Device_ID = d.Device_ID
GROUP BY d.Device_Category
ORDER BY service_case_count DESC;
-- 24. Average downtime by device category
SELECT
    d.Device_Category,
    ROUND(AVG(sc.Downtime_Hours), 2) AS average_downtime_hours
FROM service_cases sc
JOIN devices d
    ON sc.Device_ID = d.Device_ID
GROUP BY d.Device_Category
ORDER BY average_downtime_hours DESC;
-- 25. Average resolution time by device category
SELECT
    d.Device_Category,
    ROUND(AVG(sc.Resolution_Days), 2) AS average_resolution_days
FROM service_cases sc
JOIN devices d
    ON sc.Device_ID = d.Device_ID
GROUP BY d.Device_Category
ORDER BY average_resolution_days DESC;
-- 26. Service cases by manufacturer
SELECT
    d.Manufacturer,
    COUNT(*) AS service_case_count
FROM service_cases sc
JOIN devices d
    ON sc.Device_ID = d.Device_ID
GROUP BY d.Manufacturer
ORDER BY service_case_count DESC;


-- ============================================================
-- SECTION 7: ADVANCED BUSINESS ANALYSIS
-- ============================================================

-- 27. Revenue and service cases by device category
SELECT
    d.Device_Category,
    ROUND(SUM(s.Sales_Amount), 2) AS total_revenue,
    COUNT(sc.Service_ID) AS service_case_count
FROM devices d
LEFT JOIN sales s
    ON d.Device_ID = s.Device_ID
LEFT JOIN service_cases sc
    ON d.Device_ID = sc.Device_ID
GROUP BY d.Device_Category
ORDER BY total_revenue DESC;


-- 28. Service cost by device category
SELECT
    d.Device_Category,
    ROUND(SUM(sc.Service_Cost), 2) AS total_service_cost
FROM service_cases sc
JOIN devices d
    ON sc.Device_ID = d.Device_ID
GROUP BY d.Device_Category
ORDER BY total_service_cost DESC;


-- 29. Average customer satisfaction by device category
SELECT
    d.Device_Category,
    ROUND(AVG(sc.Customer_Satisfaction), 2) AS average_customer_satisfaction
FROM service_cases sc
JOIN devices d
    ON sc.Device_ID = d.Device_ID
GROUP BY d.Device_Category
ORDER BY average_customer_satisfaction DESC;


-- 30. Device-wise sales and service performance
SELECT
    d.Device_ID,
    d.Device_Name,
    d.Device_Category,
    d.Manufacturer,
    COALESCE(SUM(s.Sales_Amount), 0) AS total_revenue,
    COUNT(sc.Service_ID) AS service_case_count,
    ROUND(AVG(sc.Downtime_Hours), 2) AS average_downtime_hours,
    ROUND(AVG(sc.Customer_Satisfaction), 2) AS average_customer_satisfaction
FROM devices d
LEFT JOIN sales s
    ON d.Device_ID = s.Device_ID
LEFT JOIN service_cases sc
    ON d.Device_ID = sc.Device_ID
GROUP BY
    d.Device_ID,
    d.Device_Name,
    d.Device_Category,
    d.Manufacturer
ORDER BY total_revenue DESC;


-- 31. Service performance by manufacturer
SELECT
    d.Manufacturer,
    COUNT(sc.Service_ID) AS service_case_count,
    ROUND(AVG(sc.Downtime_Hours), 2) AS average_downtime_hours,
    ROUND(AVG(sc.Resolution_Days), 2) AS average_resolution_days,
    ROUND(AVG(sc.Customer_Satisfaction), 2) AS average_customer_satisfaction
FROM service_cases sc
JOIN devices d
    ON sc.Device_ID = d.Device_ID
GROUP BY d.Manufacturer
ORDER BY service_case_count DESC;


-- 32. Hospital-wise sales revenue and service cases
SELECT
    h.Hospital_ID,
    h.Hospital_Name,
    h.City,
    h.Hospital_Type,
    COALESCE(SUM(s.Sales_Amount), 0) AS total_revenue,
    COUNT(sc.Service_ID) AS service_case_count
FROM hospitals h
LEFT JOIN sales s
    ON h.Hospital_ID = s.Hospital_ID
LEFT JOIN service_cases sc
    ON h.Hospital_ID = sc.Hospital_ID
GROUP BY
    h.Hospital_ID,
    h.Hospital_Name,
    h.City,
    h.Hospital_Type
ORDER BY total_revenue DESC;


-- 33. Service cost by warranty status
SELECT
    Warranty_Status,
    COUNT(*) AS service_case_count,
    ROUND(SUM(Service_Cost), 2) AS total_service_cost,
    ROUND(AVG(Service_Cost), 2) AS average_service_cost
FROM service_cases
GROUP BY Warranty_Status
ORDER BY total_service_cost DESC;