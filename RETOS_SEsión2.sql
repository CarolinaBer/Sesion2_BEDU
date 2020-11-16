 -- Retos Sesión 2: Agrupamientos y subconsultas
 
 -- % representa 0 o más caracteres y _ representa un único caracter
 
 -- RETO 1 Búsqueda de patrones mediante LIKE
  -- De la BD tienda responde lo siguiente:
  # ¿Qué artículos incluyen la palabra Pasta en su nombre?
  USE tienda;
  SHOW TABLES;
  DESCRIBE articulo;
  SELECT *
  FROM articulo WHERE nombre LIKE '%Pasta%';
  
# ¿Qué artículos incluyen la palabra Cannelloni en su nombre?
SELECT *
FROM articulo WHERE nombre LIKE '%Cannelloni%';

#¿Qué nombres están separados por un guión (-) por ejemplo Puree - Kiwi?
SELECT *
FROM articulo WHERE nombre LIKE '%-%';

#¿Qué puestos incluyen la palabra Designer?
SHOW tables;
SELECT *
FROM puesto  WHERE nombre LIKE '%Designer%';

# ¿Qué puestos incluyen la palabra Developer?
SELECT *
FROM puesto WHERE nombre LIKE '%Developer%';
/*  '*' muestra todas las columnas de la tabla, en estos ejemplos podemos utilizar SELECT nombre
 para que se nos indique el nombre del puesto. */
/* NOTA: LIKE es una cláusula case-insensitive lo cual quiere decir que le es indistinto al uso de 
mayúsculas o minúsculas.*/

#RETO 2 : Funciones de agrupamiento
#¿Cuál es el promedio de salario de los puestos?
SELECT avg(salario) AS promedio_salario
FROM puesto;

#¿Cuál es el salario mínimo y máximo?
SELECT max(salario) AS salario_max, min(salario) AS salario_min
FROM puesto;

#¿Cuántos artículos incluyen la palabra Pasta en su nombre?
SELECT count(*) AS numero_de_articulos -- count cuenta todas las filas así que no importa la columna que escogida
FROM articulo WHERE nombre LIKE '%Pasta%';

#¿Cuál es la suma del salario de los últimos cinco puestos agregados?
SELECT max(id_puesto) - 5
FROM puesto;
-- Sabemos que id_puesto un indicador que va en orden ascendente que se incrementa con cada registro
-- así que para encontrar los últimos 5 puestos es necesario encontrar el máximo 
SELECT sum(salario)
FROM puesto
WHERE id_puesto > 995;
-- Despues de esto realizamos la suma para obtener la consulta solicitada
SELECT count(id_puesto) - 5 AS ultimos_5
FROM puesto;
-- Aquí talmbien tenemos otra forma de obtener los últimos 5 
SELECT salario 
FROM puesto ORDER BY id_puesto DESC 
LIMIT 5;
-- También podemos contar el número de registros que hay y restar 5 para obtener los últimos 5 
# Lo anterior visto en una subconsulta sería lo siguiente:
#La suma del salario de los últimos cinco puestos agregados es:
SELECT sum(salario)
FROM puesto 
WHERE id_puesto > (SELECT max(id_puesto) - 5 
FROM puesto);
# Primero se realiza la primera subconsulta dentro de los paréntesis y se utiliza para la consulta 


# RETO 3: Agrupamientos. 
 # ¿Cuántos registros hay por cada uno de los puestos?
 SELECT nombre,count(*) AS total_registros
 FROM puesto GROUP BY nombre;
 /* Seleccionamos de la tabla puesto el nombre y el número de registros (filas) usando count(*)  
 mediante SELECT nombre, count(*) y se agrupan mediante GROUP BY por el campo nombre.
 Así obtenemos el número de registros que tiene cada puesto*/

 #¿Cuánto dinero se paga en total por puesto?
 SELECT nombre, sum(salario) AS pago_total
 FROM puesto GROUP BY nombre;
  -- Similar al anterior, pero en lugar de contar los registros, suma los datos de la columna 
  -- salario para cada nombre (puesto) 
 
 SHOW TABLES;
 DESCRIBE venta;
 # ¿Cuál es el número total de ventas por vendedor?
 SELECT id_empleado AS vendedor, COUNT(id_venta) AS total_ventas-- cuenta el número de ventas ya que está agrupado
 FROM venta GROUP BY id_empleado; -- en lugar de id_empleado podemos usar el alias asignado 
 
 #¿Cuál es el número total de ventas por artículo?
 SELECT id_articulo AS Articulo, count(*) AS total_ventas-- El contador es el número total de ventas
 FROM venta GROUP BY Articulo; -- Lo agrupamos por artículo para mostrar el total de ventas
 -- count(*) cuenta los registros 
 
 



