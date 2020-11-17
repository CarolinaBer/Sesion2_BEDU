-- Sesión 2  Agrupamientos y subconsultas--
/* Búsqueda por patrones en lugar de igualdades, LIKE nos permite utilizar comodines
en la cláusula WHERE de la instrucción SELECT , así que LIKE permite realizar la búsqueda de 
patrones. 'B%' busca todas las cadenas que inician con 'B',representa 0 o más caracteres
 mientras que '_' se utiliza para un solo caracter. Podemos utilizar '' o bien " "  */ 

-- Ejemplo 1--
USE tienda;
SELECT *
FROM empleado WHERE nombre LIKE 'M%'; -- Muestra todos los empleados cuyo nombre inicia con M

SELECT *
FROM empleado WHERE nombre LIKE '%a'; -- Muestra todos los empleados cuyo nombre termina con a

SELECT *
FROM empleado WHERE nombre LIKE 'M%a'; -- Muestra todos los empleados cuyo nombre inicia con M ytermina con a

-- Es por eso que es más flexible que WHERE al buscar patrones
SELECT *
FROM empleado WHERE nombre LIKE 'M_losa'; -- Aquí '_' se puede sustituir por cualquier caracter

-- '%Ejecutivo%' puede tener como resultados ["Director Ejecutivo", "Ejecutivo de ventas"]
/* LIKE es una cláusula case-insensitive lo cual quiere decir que le es indistinto al uso de 
mayúsculas o minúsculas*/
  
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

-- Los espacios se tienen que colocar explícitamente

# Ejemplo 2: Funciones de agrupamiento 
/* función es un conjunto de procesos que relacionan un input con un output y son replicables.
 Las "funciones de agrupamiento" (también conocidas como de agregación)  permiten realizar cálculos sobre 
 los valores de una columna(completa) y regresan un único valor.
 Existen  distintos operadores aritméticos, tales como sumas, restas, multiplicaciones y divisiones.*/ 

 -- Algunas son SUM(), COUNT(), MIN(), MAX(), AVG().
SELECT (1 + 7) * (10 / (6 - 4)); -- Posibles operaciones aritméticas 
SELECT avg(precio) AS promedio_precio
FROM articulo;

SELECT count(*) AS conteo_articulos
FROM articulo;

SELECT min(precio) AS precio_min
FROM articulo;

SELECT max(precio) AS precio_max
FROM articulo;

SELECT sum(precio) AS suma_precio
FROM articulo;
DESCRIBE puesto;

#RETO 2 : Funciones de agrupamiento 
#¿Cuál es el promedio de salario de los puestos?
SELECT avg(salario) AS promedio_salario
FROM puesto;

#¿Cuál es el salario mínimo y máximo?
SELECT max(salario) AS salario_max, min(salario) AS salario_min
FROM puesto;

#¿Cuántos artículos incluyen la palabra Pasta en su nombre?
SELECT count(*) AS numero_de_articulos -- count cuenta todas las filas así que no importa la columna
FROM articulo WHERE nombre LIKE '%Pasta%';

#¿Cuál es la suma del salario de los últimos cinco puestos agregados?
SELECT max(id_puesto) - 5
FROM puesto;
SELECT sum(salario)
FROM puesto
WHERE id_puesto > 995;

SELECT count(id_puesto) - 5
FROM puesto;

#Agrupamientos 
/* Columna categórica quiere decir que tenemos un número prestablecido de valores(predeterminados), 
sabemos las posibilidades que tenemos.
La cláusula GROUP BY es usada dentro de SELECT para agrupar registros(filas) 
que contengan el mismo valor de una columna dada , normalmente necesitamos una
variable categórica para ello. Se obtiene una fila que agrupa y representa a la variable.
Hay que agrupar los registros y luego utilizar la función para obtener la tabla */
/* La cláusula GROUP BY es usada dentro de la instrucción SELECT para recolectar datos a partir 
de varios registros y agruparlos en una o más columnas.*/

#GROUP BY 
# Se añade un alias a la consulta para hacer más entendible el nombre de la columna. Para añadir un alias se debe usar la primitiva AS. 
#Recuerda que los campos antes de las funciones de agregación son los que deben aparecer en la cláusula GROUP BY.
SELECT * 
FROM articulo;

SELECT nombre, sum(precio) AS precio_total
FROM articulo GROUP BY nombre;

SELECT nombre, count(*) AS cantidad -- No. de repeticiones que hay por cada grupo
FROM articulo GROUP BY nombre ORDER BY cantidad DESC; -- Hasta arriba aparecen los que más se repiten

SELECT nombre, min(salario) AS salario_min, max(salario)  AS salario_max
 FROM puesto GROUP BY nombre; -- A group by le asignamos una columna con valores repetidos, eso permite agrupar los valores
 
 SELECT *
 FROM puesto ORDER BY nombre ;
 -- Aquí se puede notar que hay varios registros con el mismo nombre, así que se pueden agrupar mediante GROUP BY
 -- GROUP BY y ORDER BY se pueden utilizar juntos.
 -- Primero se utilza GROUP BY y despues ORDER BY, se deben usar con campos mencionados en SELECT 
 -- GROUP BY se puede utilizar con funciones de agrupamiento
 
 # RETO 3
 # ¿Cuántos registros hay por cada uno de los puestos?
 SELECT nombre,count(*) AS total_registros
 FROM puesto  GROUP BY nombre ;
 /* Seleccionamos de la tabla puesto el nombre y el número de registros (filas) usando count(*)  
 mediante SELECT nombre, count(*) y se agrupan mediante GROUP BY por el campo nombre.
 Así obtenemos el número de registros que tiene cada puesto*/
 
/* SELECT nombre,count(*) AS total_registros
 FROM puesto  GROUP BY nombre ORDER BY nombre;*/
 
 #¿Cuánto dinero se paga en total por puesto?
 SELECT nombre, sum(salario) AS pago_total
 FROM puesto GROUP BY nombre;
 -- Similar al anterior, pero en lugar de contar los registros, suma los datos de la columna salario para cada nombre (puesto) 
 SHOW TABLES;
 DESCRIBE venta;
 # ¿Cuál es el número total de ventas por vendedor?
 SELECT id_empleado AS vendedor, COUNT(id_venta) AS total_ventas-- cuenta el número de ventas ya que está agrupado
 FROM venta GROUP BY id_empleado;-- en lugar de id_empleado podemos usar el alias asignado
 
 #¿Cuál es el número total de ventas por artículo?
 SELECT id_articulo AS Articulo, count(*) AS total_ventas -- El contador ya es el número total de ventas, count(*) cuenta los registros
 FROM venta GROUP BY id_articulo;
 

-- Ejercicios
/* 1. Dentro de la tabla employees, obten el número de empleado, apellido y nombre de todos los empleados cuyo nombre empiece con a.
2.Dentro de la tabla employees, obten el número de empleado, apellido y nombre de todos los empleados cuyo nombre termina con on.
3.Dentro de la tabla employees, obten el número de empleado, apellido y nombre de todos los empleados cuyo nombre incluye la cadena on.
4. Dentro de la tabla employees, obten el número de empleado, apellido y nombre de todos los empleados cuyos nombres tienen tres letras e inician con T y finalizan con m. 
5.Dentro de la tabla employees, obten el número de empleado, apellido y nombre de todos los empleados cuyo nombre no inicia con B.
6.Dentro de la tabla products, obten el código de producto y nombre de los productos cuyo código incluye la cadena _20.
7.Dentro de la tabla orderdetails, obten el total de cada orden.
8. Dentro de la tabla orders obten el número de órdenes por año.
9.Obten el apellido y nombre de los empleados cuya oficina está ubicada en USA.
10. Obten el número de cliente, número de cheque y cantidad del cliente que ha realizado el pago más alto.
11. Obten el número de cliente, número de cheque y cantidad de aquellos clientes cuyo pago es más alto que el promedio.
12. Obten el nombre de aquellos clientes que no han hecho ninguna orden.
13.Obten el máximo, mínimo y promedio del número de productos en las órdenes de venta.
14.Dentro de la tabla orders, obten el número de órdenes que hay por cada estado. */
SHOW DATABASES;
USE classicmodels;
SHOW TABLES;
DESCRIBE employees;
# 1
SELECT employeeNumber, lastName, firstName
FROM employees
WHERE firstName LIKE 'a%'; 
# 2 
SELECT employeeNumber, lastName, firstName
FROM employees
WHERE firstName LIKE '%on'; 
#3
SELECT employeeNumber, lastName, firstName
FROM employees
WHERE firstName LIKE '%on%'; 
# 4
SELECT employeeNumber, lastName, firstName
FROM employees
WHERE firstName LIKE 'T_m'; 
#5
SELECT employeeNumber, lastName, firstName
FROM employees
WHERE firstName NOT LIKE 'B%'; 

DESCRIBE products;
# 6 
SELECT productCode, productName
FROM products
WHERE productCode LIKE '%_20%';

DESCRIBE orderdetails;
#7 Queremos el total de cada orden
SELECT *
FROM orderdetails;

SELECT orderNumber, productCode, quantityOrdered*priceEach AS total_producto
FROM orderdetails;
-- Este es el paso anterior para realizar la subconsulta, obteniendo el total para despues sumarlo y agruparlo
-- Esto ya que tenemos un número de productos y su precio individual
SELECT orderNumber AS No_orden,sum(total_producto) AS total_orden
FROM  (SELECT orderNumber, productCode, quantityOrdered*priceEach AS total_producto
FROM orderdetails) AS subconsulta -- Aquí es donde se agrega el alias, a la ''nueva tabla ''
GROUP BY orderNumber ;
-- Aquí ya lo agrupamos y sumamos cada uno a su número de orden correspondiente para obtener el total
# En este tipo de consultas MySQL pide poner un nombre a la subconsulta para poder referenciar, en caso de que sea necesario.
# Es necesario agregar un alias a la subconsulta que sería nuestra nueva tabla

#La consulta es la sig:
SELECT orderNumber AS No_orden,sum(total_producto) AS total_orden
FROM  (SELECT orderNumber, productCode, quantityOrdered*priceEach AS total_producto
FROM orderdetails) AS subconsulta 
GROUP BY orderNumber ;

DESCRIBE orders;
SELECT *
FROM orders;
#8
SELECT  YEAR(orderDate) AS año, count(orderNumber) AS No_ordenes
FROM orders
GROUP BY año;
-- Se obtiene el año de orderDate y se cuentan las filas que lo contienen y después se agrupan

# 9 Queremos nombre y apellido de los empleados que trabajan en USA
SELECT  lastName, firstName, officeCode
FROM employees
WHERE officeCode IN (SELECT officeCode  -- únicamente utilizamos la columna officeCode
FROM offices WHERE country = 'USA');

/* La subconsulta consiste en lo siguiente: tenemos la tabla offices con la información
de officeCode y country de la cual buscamos obtener las oficinas de USA, así que utilizamos WHERE para encontrarlas.
Posteriormente tenemos la tabla employees con la info lastName, firstName y officeCode,
del paso anterior conocemos cuales oficinas (officeCode) están en USA las cuales son 1,2 y 3.
Usando WHERE obtenemos el apellido y nombre de los empleados que trabajan en dichas oficinas */
SELECT officeCode, country
FROM offices
WHERE country = 'USA'; -- officeCode 1,2 y 3 son de USA

SELECT  lastName, firstName,officeCode
FROM employees
WHERE officeCode IN (1,2,3);

-- Este sería el procedimiento manual o desglosado. Arriba se muestra la subconsulta.La solución es:
SELECT  lastName AS Apellido, firstName AS Nombre
FROM employees
WHERE officeCode IN (SELECT officeCode  
FROM offices WHERE country = 'USA');

#10
SELECT customerNumber,checkNumber,amount
FROM payments
ORDER BY amount DESC LIMIT 1;

SELECT customerNumber, checkNumber, amount
FROM payments
WHERE amount IN (SELECT max(amount)
FROM payments);
-- Son dos formas alternativas de obtener el resultado de la consulta

#11
SELECT AVG (amount)
FROM payments;

SELECT customerNumber, checkNumber, amount
FROM payments
WHERE amount > (SELECT AVG(amount)
FROM payments);

#12 Aquellos clientes que no han ordenado (nombres)

DESCRIBE customers; -- De la tabla customers obtenemos el customerNumber
DESCRIBE orders; -- Esta llave de customerNumber también está relacionada con orders siendo MUL o llave foránea para esta tabla
SELECT COUNT(DISTINCT customerNumber)
FROM orders; -- 98 clientes han ordenado 
# Para saber si estamos bien podemos contar el número de clientes que han ordenado, para ello buscamos 
#de la tabla orders tosos los números de cliente distintos y los contamos
SELECT *
FROM customers; -- hay 122 clientes
 # De la tabla customers conocemos el número total de clientes que tenemos 
 SELECT customerName AS Nombre
 FROM customers 
 WHERE customerNumber NOT IN ( SELECT customerNumber
 FROM orders); -- 24 clientes no han ordenado
 
 #para encontrar los clientes que no han pedido buscamos aquellos cuyo número de cliente no aparece en las ordenes pues no ha ordenado
 # Así sabemos que 24 clientes no han ordenado y 98 sí. La suma da 122 que son los clientes registrados congruentemente

 #13 Obten el máximo, mínimo y promedio del número de productos en las órdenes de venta
 USE classicmodels;
 DESCRIBE orderdetails; -- orderNumber, productCode,quantityOrdered, priceEach
 SELECT * FROM products;
 SELECT * FROM orderdetails;
 -- La consulta es la siguiente:
 SELECT MAX(ordered_products) AS max_prod, MIN(ordered_products) AS min_prod, AVG(ordered_products) AS average
 FROM (SELECT orderNumber, SUM(quantityOrdered) AS ordered_products
 FROM orderdetails GROUP BY orderNumber) AS product_tot;
 
 SELECT orderNumber, SUM(quantityOrdered) AS ordered_products
 FROM orderdetails
 GROUP BY orderNumber;
 
 SELECT AVG(ordered_products)
 FROM ( SELECT orderNumber, SUM(quantityOrdered) AS ordered_products
 FROM orderdetails
 GROUP BY orderNumber) AS prod;
 
 
 #14 Dentro de la tabla orders, obten el número de órdenes que hay por cada estado.
 SELECT *
 FROM customers; -- info de customerNumber y state
 SELECT * 
 FROM orders ORDER BY customerNumber; -- Se liga la info de customerNumber
 DESCRIBE orders; -- para orders customerNumber es una llave foránea 
 
 SELECT customerNumber, count(customerNumber) AS total_orders
 FROM orders
 GROUP BY customerNumber; -- Aquí obtenemos el número de cliente y cuántas veces aparece (ha ordenado)
 
 SELECT customerNumber, state
 FROM customers
 ORDER BY customerNumber; -- Aquí obtenemos el número de cliente y a qué estado corresponde
 
SELECT customerNumber, count(customerNumber) AS total_orders, c.state
FROM customers AS c
JOIN orders AS o
USING(customerNumber)
WHERE c.state IS NOT NULL
GROUP BY customerNumber; -- 46 rows returned

SELECT customerNumber, count(customerNumber) AS total_orders, c.state
FROM customers AS c
JOIN orders AS o
USING(customerNumber)
WHERE c.state IS NULL
GROUP BY customerNumber; -- 52 rows returned 

SELECT customerNumber, count(customerNumber) AS total_orders, c.state
FROM customers AS c
JOIN orders AS o
USING(customerNumber)
GROUP BY customerNumber; -- 98 rows returned 
-- En este caso es por que algunos de los clientes no cuentan con la información del estado 

SELECT * FROM orders;
SELECT status, count(status) AS order_total
FROM orders 
GROUP BY status;
 


 
 
 
 

 
 
