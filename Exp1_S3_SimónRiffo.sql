-- 1) Productos por categoría, ordenados por precio mayor a menor
SELECT categoria, UPPER(nombre) AS nombre, precio
FROM Productos
ORDER BY categoria, precio DESC;

-- 2) Promedio de ventas mensuales y mes con mayores ventas
SELECT TO_CHAR(fecha, 'MM-YYYY') AS mes_anio, AVG(cantidad) AS promedio_mensual
FROM Ventas
GROUP BY TO_CHAR(fecha, 'MM-YYYY')
ORDER BY promedio_mensual DESC
FETCH FIRST 1 ROWS ONLY;

-- 3) Cliente que ha gastado más plata en el último año
SELECT c.cliente_id, CONCAT(CONCAT(c.nombre, ' - '), c.ciudad) AS cliente_ciudad, SUM(v.cantidad * p.precio) AS total_gastado
FROM Ventas v
JOIN Productos p ON v.producto_id = p.producto_id
JOIN Clientes c ON v.cliente_id = c.cliente_id
GROUP BY c.cliente_id, CONCAT(CONCAT(c.nombre, ' - '), c.ciudad)
ORDER BY total_gastado DESC
FETCH FIRST 1 ROWS ONLY;

-- 4)Total de ventas por cliente con monto mínimo
SELECT c.cliente_id, c.nombre, SUM(v.cantidad * p.precio) AS total_compras
FROM Ventas v
JOIN Productos p ON v.producto_id = p.producto_id
JOIN Clientes c ON v.cliente_id = c.cliente_id
GROUP BY c.cliente_id, c.nombre
HAVING SUM(v.cantidad * p.precio) > 1000;

-- 5) Precio mínimo, máximo y promedio de los productos por categoría
SELECT categoria, MIN(precio) AS precio_minimo, MAX(precio) AS precio_maximo, AVG(precio) AS precio_promedio
FROM Productos
GROUP BY categoria;

-- 6) Ventas por ciudad
SELECT c.ciudad, SUM(v.cantidad * p.precio) AS total_ventas
FROM Ventas v
JOIN Clientes c ON v.cliente_id = c.cliente_id
JOIN Productos p ON v.producto_id = p.producto_id
GROUP BY c.ciudad
ORDER BY total_ventas DESC;

-- 7) Análisis de antiguedad de cleintes
SELECT c.cliente_id, c.nombre, c.ciudad, ROUND((SYSDATE - c.fecha_registro) / 365, 1) AS antiguedad_anios
FROM Clientes c
WHERE (SYSDATE - c.fecha_registro) / 365 > 1
ORDER BY antiguedad_anios DESC;