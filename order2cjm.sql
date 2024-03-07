-- training.cjm.
-- 년, 월, 일
with ymd_orders as (
	SELECT SUBSTR(ORDER_DATE,1,4) AS YEAR,  SUBSTR(ORDER_DATE,6,2) AS MONTH, SUBSTR(ORDER_DATE,9,2) AS day, *
	FROM training.cjm.orders
)

-- 고객별 총 매출
SELECT concat(c.FIRST_NAME, ' ', c.LAST_NAME) AS CUSTOMER_NAME, sum(oi.QUANTITY * oi.UNIT_PRICE) TOTAL_SALES
FROM training.cjm.CONTACTS c 
JOIN training.cjm.CUSTOMERS c2 
	ON c.CUSTOMER_ID = c2.CUSTOMER_ID 
JOIN training.cjm.ORDERS o 
	ON c2.CUSTOMER_ID = o.CUSTOMER_ID 
JOIN training.cjm.ORDER_ITEMS oi 
	ON o.ORDER_ID  = oi.ORDER_ID 
GROUP BY c.FIRST_NAME, c.LAST_NAME
ORDER BY TOTAL_SALES DESC 

--직원별 어떤상품을 많이 팔았는지
WITH RANK_T as(
SELECT (e.FIRST_NAME || ' ' || e.LAST_NAME) EMPLOYEES_NAME, ROW_NUMBER() OVER (PARTITION BY oi.PRODUCT_ID ORDER BY oi.QUANTITY) AS SALE_RANK, pc.CATEGORY_NAME AS CATEGORY, p.PRODUCT_NAME AS PRODUCT_NAME
FROM training.cjm.EMPLOYEES e 
JOIN training.cjm.ORDERS o 
	ON e.EMPLOYEE_ID = o.SALESMAN_ID 
JOIN training.cjm.ORDER_ITEMS oi 
	ON o.ORDER_ID = oi.ORDER_ID 
JOIN training.cjm.PRODUCTS p 
	ON oi.PRODUCT_ID = p.PRODUCT_ID 
JOIN training.cjm.PRODUCT_CATEGORIES pc 
	ON p.CATEGORY_ID = pc.CATEGORY_ID 
)
SELECT EMPLOYEES_NAME, CATEGORY, PRODUCT_NAME
FROM RANK_T
WHERE SALE_RANK = 1

-- 매니저마다 몇명의 직원을 관리하는지
SELECT (m.FIRST_NAME || ' ' || m.LAST_NAME) MANAGER_NAME, count(e.FIRST_NAME || ' ' || e.LAST_NAME) EMPLOYEES_COUNT
FROM training.cjm.EMPLOYEES e
INNER JOIN training.cjm.EMPLOYEES m 
	ON e.MANAGER_ID = m.EMPLOYEE_ID
GROUP BY (m.FIRST_NAME || ' ' || m.LAST_NAME)
ORDER BY EMPLOYEES_COUNT DESC

-- 직원별 산술 통계
with ymd_orders as (
	SELECT SUBSTR(ORDER_DATE,1,4) AS YEAR,  SUBSTR(ORDER_DATE,6,2) AS MONTH, SUBSTR(ORDER_DATE,9,2) AS day, *
	FROM training.cjm.orders
)
SELECT (e.FIRST_NAME || ' ' || e.LAST_NAME) EMPLOYEES_NAME, SUM(oi.QUANTITY * oi.UNIT_PRICE) sum
, avg(oi.QUANTITY * oi.UNIT_PRICE) avg, max(oi.QUANTITY * oi.UNIT_PRICE) max, min(oi.QUANTITY * oi.UNIT_PRICE) min
, COUNT(oi.QUANTITY * oi.UNIT_PRICE) COUNT, stddev(oi.QUANTITY * oi.UNIT_PRICE) stddev 
FROM training.cjm.EMPLOYEES e 
JOIN training.cjm.ORDERS o 
	ON e.EMPLOYEE_ID = o.SALESMAN_ID 
JOIN training.cjm.ORDER_ITEMS oi 
	ON o.ORDER_ID = oi.ORDER_ID 
GROUP BY (e.FIRST_NAME || ' ' || e.LAST_NAME)

-- 상품별 총 매출
with ymd_orders as (
	SELECT SUBSTR(ORDER_DATE,1,4) AS YEAR,  SUBSTR(ORDER_DATE,6,2) AS MONTH, SUBSTR(ORDER_DATE,9,2) AS day, *
	FROM training.cjm.orders
)
SELECT p.PRODUCT_NAME, SUM(oi.QUANTITY * oi.UNIT_PRICE) AS TOTAL
FROM training.cjm.ORDERS o 
JOIN training.cjm.ORDER_ITEMS oi 
	ON o.ORDER_ID = oi.ORDER_ID 
JOIN training.cjm.PRODUCTS p 
	ON oi.PRODUCT_ID = p.PRODUCT_ID 
GROUP BY p.PRODUCT_NAME

-- 도시별 매출

SELECT c.COUNTRY_NAME, l.CITY, SUM(oi.QUANTITY * oi.UNIT_PRICE) total
FROM training.cjm.ORDERS o 
JOIN training.cjm.ORDER_ITEMS oi
	ON o.ORDER_ID = oi.ORDER_ID 
JOIN training.cjm.PRODUCTS p 
	ON oi.PRODUCT_ID = p.PRODUCT_ID 
JOIN training.cjm.INVENTORIES i 
	ON p.PRODUCT_ID = i.PRODUCT_ID 
JOIN training.cjm.WAREHOUSES w 
	ON i.WAREHOUSE_ID = w.WAREHOUSE_ID 
JOIN training.cjm.LOCATIONS l 
	ON w.LOCATION_ID = l.LOCATION_ID 
JOIN training.cjm.COUNTRIES c 
	ON l.COUNTRY_ID = c.COUNTRY_ID 
JOIN training.cjm.REGIONS r 
	ON c.REGION_ID = r.REGION_ID 
GROUP BY c.COUNTRY_NAME, l.CITY
ORDER BY total desc








-- 고객별 매출
with ymd_orders as (
	SELECT SUBSTR(ORDER_DATE,1,4) AS YEAR,  SUBSTR(ORDER_DATE,6,2) AS MONTH, SUBSTR(ORDER_DATE,9,2) AS day, *
	FROM training.cjm.orders
)
SELECT concat(c.FIRST_NAME, ' ', c.LAST_NAME) AS CUSTOMER_NAME, YEAR, MONTH, day, sum(oi.QUANTITY * oi.UNIT_PRICE) TOTAL_SALES
FROM training.cjm.CONTACTS c 
JOIN training.cjm.CUSTOMERS c2 
	ON c.CUSTOMER_ID = c2.CUSTOMER_ID 
JOIN ymd_orders o 
	ON c2.CUSTOMER_ID = o.CUSTOMER_ID 
JOIN training.cjm.ORDER_ITEMS oi 
	ON o.ORDER_ID  = oi.ORDER_ID 
GROUP BY c.FIRST_NAME, c.LAST_NAME, YEAR, MONTH, day
ORDER BY TOTAL_SALES DESC 





