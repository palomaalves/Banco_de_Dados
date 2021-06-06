-- OBS.: FEITO NO MYSQL WORKBENCH!

-- EXERCICIOS DE SQL – NORTHWIND

USE northwind;

-- 1- Quais as informações existentes na tabela de categorias?
SELECT * 
FROM categories;
-- Reposta: CategoryID, CategoryName, Description, Picture.

-- 2- Liste o Código do Produto e o Nome do Produto.
SELECT ProductID, ProductName 
FROM products;

-- 3- Liste o Código do Produto e o Nome do Produto em ordem alfabética.
SELECT ProductID, ProductName 
FROM products 
ORDER BY ProductName ASC;

-- 4- Liste o Código do Produto e o Nome do Produto em ordem decrescente de preço 
-- unitário.
SELECT ProductID, ProductName, UnitPrice 
FROM products 
ORDER BY UnitPrice DESC;

-- 5- Liste o Código do Produto e o Nome do Produto acima de R$ 50,00 em ordem 
-- decrescente de preço.
SELECT ProductID, ProductName, UnitPrice 
FROM products 
WHERE UnitPrice>50
ORDER BY UnitPrice DESC;

-- 6- Liste o Código do Produto e o Nome do Produto em ordem crescente dos produtos maior ou igual a R$ 50,00 e menor ou igual a R$ 200,00.
SELECT ProductID, ProductName, UnitPrice 
FROM products 
WHERE UnitPrice BETWEEN 50 AND 200
ORDER BY UnitPrice ASC;

-- 7- Liste o Código do Produto, Nome do Produto e o Código da Categoria dos produtos 
-- pertencentes às categorias 2,4 e 6.
SELECT ProductID, ProductName, CategoryID  
FROM products 
WHERE CategoryID IN(2, 4, 6)
ORDER BY CategoryID;

-- 8- Liste o Código do Produto, Nome do Produto e o Código da Categoria dos produtos 
-- pertencentes à categoria 5.
SELECT ProductID, ProductName, CategoryID  
FROM products 
WHERE CategoryID IN(5);

-- 9- Liste o Código do Produto, Nome do Produto e o Código da Categoria dos produtos 
-- pertencentes, com nome do produto igual a “TOFU”.
SELECT ProductID, ProductName, CategoryID  
FROM products 
WHERE ProductName IN('TOFU');

-- 10- Liste o Código do Produto, Nome do Produto e o Código da Categoria dos 
-- produtos iniciados pela letra “T”.
SELECT ProductID, ProductName, CategoryID  
FROM products 
WHERE ProductName LIKE 't%';

-- 11- Liste o Código do Produto, Nome do Produto e o Código da Categoria dos 
-- produtos com 4 letras.
SELECT ProductID, ProductName, CategoryID  
FROM products 
WHERE ProductName LIKE '____';

-- 12- Qual o maior Código de Produto?
SELECT MAX(ProductID) AS 'Biggest Product ID'
FROM products;

-- 13- Sabendo-se que o valor em estoque de cada produto é dado pela fórmula:
-- (UNIDADES EM ESTOQUE + UNIDADES PEDIDAS) * PREÇO UNITÁRIO,
-- informar qual o valor total do estoque.
SELECT SUM((UnitsInStock+UnitsOnOrder)*UnitPrice) AS TotalStockValue 
FROM products;

-- 14- Listar o Nome do Produto e o Valor de Estoque desse produto, classificado pelo Valor.
SELECT ProductName, (UnitsInStock+UnitsOnOrder)*UnitPrice AS StockValue 
FROM products 
ORDER BY StockValue ASC;

-- 15- Listar o Menor Preço, o Maior Preço e o Preço Médio dos produtos da categoria 5.
SELECT MAX(UnitPrice) AS MaxPrice, MIN(UnitPrice) AS MinPrice, AVG(UnitPrice) AS AvgPrice 
FROM products 
WHERE CategoryID IN(5);

-- 16- Listar o Menor Preço, o Maior Preço e o Preço Médio dos produtos de todas as
-- categorias.
SELECT MAX(UnitPrice) AS MaxPrice, MIN(UnitPrice) AS MinPrice, AVG(UnitPrice) AS AvgPrice 
FROM products;

-- 17- Listar os campos Menor Preço, o Maior Preço e o Preço Médio dos produtos de 
-- todas as categorias em cada categoria.
SELECT categories.CategoryID, CategoryName, MAX(UnitPrice) AS MaxPrice, MIN(UnitPrice) AS MinPrice, AVG(UnitPrice) AS AvgPrice 
FROM products, categories 
WHERE categories.CategoryID = products.CategoryID 
GROUP BY CategoryName;

-- 18- Quantos produtos têm cada categoria?
SELECT categories.CategoryID, CategoryName, COUNT(ProductID) AS QuantityProductsPerCategory 
FROM products, categories 
WHERE categories.CategoryID = products.CategoryID 
GROUP BY CategoryID;

-- 19- Quantos produtos eu tenho?
SELECT COUNT(ProductID) AS QuantityTotalProducts 
FROM products;

-- 20- De cada Fornecedor, quantos produtos ele fornece de cada categoria?
SELECT SupplierID, categories.CategoryID, CategoryName, COUNT(ProductID) AS SupplierQuantityProductsPerCategory 
FROM products, categories 
WHERE categories.CategoryID = products.CategoryID 
GROUP BY SupplierID, CategoryID
ORDER BY SupplierID ASC;

-- 21- Quantos produtos de cada mercadoria cada fornecedor fornece, das categorias 2, 4 ou 6?
SELECT SupplierID, CategoryID, COUNT(ProductID) AS 'SupplierQuantityProductsCategory2-4-6' 
FROM products 
WHERE CategoryID IN(2, 4, 6) 
GROUP BY SupplierID, CategoryID 
ORDER BY SupplierID ASC;

-- 22- Quais os Fornecedores que fornecem mais de 3 Produtos?
SELECT SupplierID, COUNT(ProductID) AS 'SupplierQuantityProductsCategory>3'
FROM products 
GROUP BY SupplierID
HAVING COUNT(ProductID)>3 
ORDER BY SupplierID ASC;

-- 23- Qual o Produto mais caro? 
SELECT UnitPrice AS ExpensiveValueProduct, ProductName 
FROM products 
WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM products);

-- 24- Quais os produtos que são da mesma categoria do produto TOFU?
SELECT ProductID, ProductName, CategoryID 
FROM products 
WHERE CategoryID = (SELECT CategoryID FROM products WHERE ProductName IN('TOFU'));

-- 25- Todos os produtos da categoria TOFU menos ele.
-- Três resoluções :)
SELECT ProductName, CategoryID 
FROM products 
WHERE CategoryID = (SELECT CategoryID FROM products WHERE ProductName IN('TOFU')) 
AND NOT ProductName = 'TOFU';

SELECT ProductName, CategoryID 
FROM products 
WHERE CategoryID = (SELECT CategoryID FROM products WHERE ProductName IN('TOFU')) 
AND ProductName != 'TOFU';

SELECT ProductName, CategoryID 
FROM products 
WHERE CategoryID = (SELECT CategoryID FROM products WHERE ProductName IN('TOFU')) 
AND ProductName <> 'TOFU';

-- 26- A quantidade de itens e o valor de cada pedido e quem pediu.
SELECT OrderID, COUNT(*) AS QuantityOfItens, SUM((Quantity*UnitPrice)*(1-Discount)) AS TotalOrderValue 
FROM `order details`
GROUP BY OrderID;

-- 27- Os produtos que tem o Preço Unitário maior que o Preço Médio.
SELECT ProductName, UnitPrice AS MoreThanAvgPrice 
FROM products 
WHERE UnitPrice>(SELECT AVG(UnitPrice) FROM products) 
ORDER BY UnitPrice;

-- 28- Todos os produtos cujo Preço Unitário seja maior que o Preço Médio da categoria do produto mais caro.
SELECT ProductName, CategoryID, UnitPrice AS MoreThanAvgPrice 
FROM products 
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM products WHERE CategoryID = (SELECT CategoryID FROM products WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM products)))
ORDER BY UnitPrice;

-- 29- Todos os pedidos de clientes de país de origem BRASIL.
SELECT OrderID, customers.CustomerID, customers.Country
FROM orders, customers 
WHERE orders.CustomerID = customers.CustomerID 
AND customers.Country IN('Brazil')
ORDER BY customers.CustomerID;

SELECT *
FROM orders
WHERE CustomerID IN(SELECT CustomerID FROM customers WHERE Country='Brazil');

-- 30- Qual o produto mais caro enviado para o BRASIL?
SELECT ProductName, products.UnitPrice AS Price, orders.OrderID, orders.ShipCountry
FROM orders, `order details`, products
WHERE products.ProductID = `order details`.ProductID
AND `order details`.OrderID = orders.OrderID
AND products.UnitPrice = (SELECT MAX(UnitPrice) FROM products)
AND orders.ShipCountry IN('Brazil');

SELECT *
FROM products
WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM `order details` WHERE OrderId IN(SELECT OrderID FROM orders WHERE ShipCountry='Brazil'));

-- 31- Liste as categorias que tenham mais produtos do que a categoria do produto mais barato.
SELECT COUNT(CategoryID) AS CountCategoryID, CategoryID
FROM products
GROUP BY CategoryID
HAVING COUNT(CategoryID) > (SELECT COUNT(CategoryID) FROM products WHERE CategoryID = (SELECT CategoryID FROM products WHERE UnitPrice = (SELECT MIN(UnitPrice) FROM products)));

-- 32- Listar o nome do funcionário que tenha o mesmo supervisor que o funcionário 6.
SELECT FirstName, EmployeeID, ReportsTo AS Supervisor
FROM employees 
WHERE ReportsTo = (SELECT ReportsTo FROM employees WHERE EmployeeID = 6);

-- 33- Listar o nome do supervisor do funcionário 6.
SELECT EmployeeID AS SupervisorID, FirstName AS NameSupervisor 
FROM employees 
WHERE EmployeeID = (SELECT ReportsTo FROM employees WHERE EmployeeID = 6);

-- 34- Liste o código da categoria, o nome da categoria e a quantidade de produtos na categoria
SELECT CategoryName, categories.CategoryID, COUNT(categories.CategoryID) AS CountCategoryID
FROM products
JOIN categories 
ON products.CategoryID = categories.CategoryID
GROUP BY CategoryName;

-- 35- Listar o nome do cliente e o nome dos produtos que ele comprou, classificado por 
-- nome do cliente e nome do produto. O uso da cláusula DISTINCT no SELECT faz com 
-- que as linhas exatamente iguais não sejam repetidas.
SELECT DISTINCT CompanyName, ProductName
FROM customers AS c
JOIN orders AS o 
ON o.CustomerID = c.CustomerID
JOIN `order details` AS od
ON od.OrderID = o.OrderID
JOIN products AS p
ON p.ProductID = od.ProductID
ORDER BY CompanyName ASC;

-- 36- Listar o nome do funcionário, seu sobrenome e o nome e sobrenome do seu chefe.
SELECT DISTINCT e.FirstName AS 'EmployeeFirstName', e.LastName AS 'EmployeeLastName', s.FirstName AS 'SupervisorFirstName', s.LastName AS 'SupervisorLastName'
FROM employees AS e, employees AS s
WHERE e.ReportsTo = s.EmployeeID;

-- 37- Listar o nome do funcionário, seu sobrenome e o nome e sobrenome do seu chefe, 
-- inclusive o nome do chefe como funcionário.
SELECT DISTINCT e.FirstName AS 'EmployeeFirstName', e.LastName AS 'EmployeeLastName', s.FirstName AS 'SupervisorFirstName', s.LastName AS 'SupervisorLastName'
FROM employees AS e, employees AS s
WHERE e.ReportsTo = s.EmployeeID
UNION
SELECT DISTINCT e.FirstName, e.LastName, ' ', ' '
FROM employees AS e
WHERE ReportsTo IS NULL;

-- 38- Qual o produto mais caro?
SELECT UnitPrice AS ExpensiveValueProduct, ProductName 
FROM products
WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM products);

-- 39- Quais os 2 produtos mais caros?
-- Modo easy ;D
SELECT UnitPrice AS ExpensiveValueProduct, ProductName 
FROM products
ORDER BY UnitPrice DESC
LIMIT 2;

SELECT UnitPrice AS ExpensiveValueProduct, ProductName 
FROM products
WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM products WHERE UnitPrice <> (SELECT MAX(UnitPrice) FROM products))
UNION
SELECT UnitPrice, ProductName 
FROM products
WHERE UnitPrice = (SELECT MAX(UnitPrice) FROM products);

-- 40- Quais os produtos mais caros que a média de sua categoria
SELECT ProductName, c.CategoryID
FROM products AS p
JOIN categories AS c
ON c.CategoryID = p.CategoryID
WHERE UnitPrice > (SELECT AVG(UnitPrice) FROM products);

-- 41- Listar nome do cliente, nome do produto, nome categoria, nome da transportadora 
-- e nome do funcionário que vendeu, produtos pedidos em outubro de 2008 -> 1998, começando 
-- com a letra A.
SELECT DISTINCT c.CompanyName, ProductName, CategoryName, s.CompanyName AS 'Shipping Company', FirstName AS EmployeeFirstName, o.OrderDate
FROM customers AS c
JOIN orders AS o 
ON o.CustomerID = c.CustomerID
JOIN shippers AS s
ON s.ShipperID = o.ShipVia
JOIN employees AS e
ON e.EmployeeID = o.EmployeeID
JOIN `order details` AS od
ON od.OrderID = o.OrderID
JOIN products AS p
ON p.ProductID = od.ProductID
JOIN categories AS ca
ON ca.CategoryID = p.CategoryID
WHERE p.ProductName LIKE 'A%'
-- AND o.OrderDate = '1997-10-01 00:00:00'
ORDER BY c.CompanyName ASC;

-- 42- Quantos pedidos cada transportadora transportou – Nome da transportadora e Nº 
-- de Pedidos.
SELECT s.CompanyName AS 'Shipping Company', COUNT(OrderID) AS 'Number Of Orders'
FROM orders AS o
JOIN shippers AS s
ON s.ShipperID = o.ShipVia
GROUP BY s.CompanyName;

-- 43- Listar todos os pedidos cujo destinatário seja diferente do cliente.
SELECT DISTINCT o.OrderID, o.ShipName, c.CompanyName
FROM orders AS o
JOIN customers AS c
ON c.CustomerID = o.CustomerID
WHERE CompanyName != ShipName
ORDER BY OrderID;

-- 44- Listar a quantidade de clientes no Brasil.
SELECT COUNT(CustomerID) AS BrazilClients
FROM customers
WHERE Country = 'Brazil';

-- 45- Quantos produtos têm o nome terminado com “X”?
SELECT COUNT(ProductID) AS 'Quantity Of Products With "X" At The End'
FROM products
WHERE ProductName LIKE '%x';

-- 46- Quais os fornecedores que fornecem produtos com exatamente 4 letras?
SELECT s.CompanyName, p.ProductName
FROM suppliers AS s 
JOIN products AS p
ON p.SupplierID = s.SupplierID
WHERE ProductName LIKE '____';

-- 47- Listar os funcionários com data de admissão maior que a data de admissão de seu 
-- chefe.
SELECT DISTINCT e.FirstName AS 'Employee', e.HireDate AS 'Employee HireDate', s.FirstName AS 'Supervisor', s.HireDate AS 'Supervisor HireDate'
FROM employees AS e, employees AS s
WHERE e.ReportsTo = s.EmployeeID
AND e.HireDate > s.HireDate;

-- FALTA VER ESSE!!!! 
-- I
-- V
-- 48- Listar os produtos que a transportadora “Federal Shipping” ainda não entregou.
SELECT DISTINCT p.ProductID, p.ProductName, s.CompanyName AS 'Shipping Company', o.ShippedDate, o.ShipName
FROM products AS p
JOIN `order details` AS od
ON od.ProductID = p.ProductID
JOIN orders AS o
ON o.OrderID = od.OrderID
JOIN shippers AS s
ON s.ShipperID = o.ShipVia
WHERE s.CompanyName = 'Federal Shipping'
AND o.ShippedDate IS NULL;

-- 49- Listar o nome dos clientes e o nome das categorias que ele comprou.
SELECT DISTINCT c.CompanyName, ct.CategoryName
FROM customers AS c
JOIN orders AS o
ON o.CustomerID = c.CustomerID
JOIN `order details` AS od
ON od.OrderID = o.OrderID
JOIN products AS p
ON p.ProductID = od.ProductID
JOIN categories AS ct
ON ct.CategoryID = p.CategoryID;

-- 50- Listar os países com mais de 5 clientes.
SELECT Country, COUNT(Country) AS 'Country That Has More Than 5 Customers'
FROM customers
GROUP BY Country
HAVING COUNT(Country)>5
ORDER BY COUNT(Country);

-- 51- Listar os produtos com necessidade de pedidos ao fornecedor:
-- (UNIDADES EMESTOQUE + UNIDADESPEDIDAS) < NÍVELDEREPOSIÇÃO.
SELECT ProductID, ProductName
FROM products
WHERE (UnitsInStock + UnitsOnOrder) < ReorderLevel;

-- 52- Qual o pedido que teve a maior quantidade de um mesmo item?
SELECT OrderID, ProductID, Quantity
FROM `order details`
WHERE Quantity = (SELECT MAX(Quantity) FROM `order details`);

-- 53- Quais são os pedidos com date de entrega 30 dias depois da data do pedido? 
-- Função: TIMESTAMPDIFF((HOUR ou MINUTE ou SECOND ou DAY ou MONTH ou YEAR), data1, data2) -> calcula a diferença entre datas
SELECT DISTINCT od.OrderID, -TIMESTAMPDIFF(DAY, RequiredDate, OrderDate) AS 'Orders With Delivery Date 30 Days After Order Date'
FROM `order details` AS od
JOIN orders AS o
ON o.OrderID = od.OrderID
WHERE -TIMESTAMPDIFF(DAY, RequiredDate, OrderDate) >= 30
ORDER BY od.OrderID ASC;

-- 54- Para emitir Nota Fiscal são necessários o Cliente, o endereço, o código do 
-- produto, o nome do produto, a quantidade, o preço unitário, o desconto e o total.
SELECT DISTINCT c.CompanyName, c.Address, p.ProductID, p.ProductName, od.Quantity, p.UnitPrice, (od.UnitPrice*od.Discount)*od.Quantity AS 'Discount',  (od.UnitPrice*od.Quantity)*(1-od.Discount) AS 'Total'
FROM customers AS c
JOIN orders AS o
ON o.CustomerID = c.CustomerID
JOIN `order details` AS od
ON od.OrderID = o.OrderID
JOIN products AS p
ON p.ProductID = od.ProductID
ORDER BY CompanyName;

-- 55- Liste Cliente, pedido, produto, valor de venda (quantidade * preço)-desconto, valor 
-- real (quantidade * preço).
SELECT c.CompanyName, o.OrderID, p.ProductName, (od.UnitPrice*od.Quantity)*(1-od.Discount) AS 'Sale Value', od.UnitPrice*Quantity AS 'Original Value'
FROM customers AS c
JOIN orders AS o
ON o.CustomerID = c.CustomerID
JOIN `order details` AS od
ON od.OrderID = o.OrderID
JOIN products AS p
ON p.ProductID = od.ProductID
ORDER BY OrderID;

-- 56- Calcule, por País de venda, o total de perda financeira com descontos.
SELECT o.ShipCountry, SUM((od.UnitPrice*od.Quantity)-((od.UnitPrice*od.Quantity)*(1-od.Discount))) AS 'Financial Loss'
FROM customers AS c
JOIN orders AS o
ON o.CustomerID = c.CustomerID
JOIN `order details` AS od
ON od.OrderID = o.OrderID
WHERE od.Discount != 0.00
GROUP BY ShipCountry
ORDER BY ShipCountry ASC;

-- 57- Liste os pedidos que foram atendidos por um supervisor.
-- Supervisores (ID = 2 e 5) Andrew (Vice-Presidente) e Steven (Gerente)
SELECT DISTINCT OrderID, FirstName AS 'Supervisor'
FROM orders AS o
JOIN employees AS e
ON e.EmployeeID = o.EmployeeID
WHERE o.EmployeeID IN(SELECT ReportsTo FROM employees)
ORDER BY OrderID;

-- 58- Liste a categoria, o produto, quantidade em estoque, quantidade pedida, nível de 
-- reposição e fornecedor.
SELECT DISTINCT c.CategoryName, p.ProductName, p.UnitsInStock, p.UnitsOnOrder, p.ReorderLevel, s.CompanyName AS 'Supplier'
FROM categories AS c
JOIN products AS p
ON p.CategoryID = c.CategoryID
JOIN suppliers AS s
ON s.SupplierID = p.SupplierID
ORDER BY CategoryName ASC;

-- 59- Quais as transportadoras que tem pedidos não enviados?
SELECT DISTINCT s.CompanyName AS 'Shipping Company', o.OrderID, ProductName, o.ShippedDate
FROM orders AS o
JOIN `order details` AS od
ON od.OrderID = o.OrderID
JOIN shippers AS s
ON s.ShipperID = o.ShipVia
JOIN products AS p
ON p.ProductID = od.ProductID
WHERE o.ShippedDate IS NULL
ORDER BY s.CompanyName ASC;

-- 60- Qual o pedido que está a mais tempo sem ser enviado?
SELECT *
FROM orders
WHERE OrderDate = (SELECT MIN(OrderDate) FROM orders WHERE ShippedDate IS NULL)
AND ShippedDate IS NULL;

-- 61- Quem fez o primeiro pedido (menor numero do pedido) e qual o funcionário que 
-- atendeu?
SELECT o.OrderID, c.CustomerID, CompanyName, FirstName AS 'Employee Name'
FROM customers AS c
JOIN orders AS o
ON o.CustomerID = c.CustomerID
JOIN employees AS e
ON e.EmployeeID = o.EmployeeID
WHERE o.OrderID = (SELECT MIN(OrderID) FROM orders);

-- 62- Quantos pedidos cada transportadora transportou?
SELECT s.CompanyName, COUNT(OrderID) AS 'Number Of Orders Of Each Shipping Company'
FROM orders AS o
JOIN shippers AS s
ON s.ShipperID = o.ShipVia
GROUP BY s.CompanyName;

-- 63- Faça uma agenda contendo: País, Cidade, Empresa, Contato, Endereço, (Cliente 
-- ou Fornecedor) conforme o caso, classificada por País, Cidade, Empresa.
SELECT Country, City, CompanyName, Phone, Address, ContactName
FROM customers
UNION
SELECT Country, City, CompanyName, Phone, Address, ContactName
FROM suppliers
ORDER BY Country, City, CompanyName;

-- 64- Dê uma redução de 20% para todos os produtos que foram enviados ao Brasil.
SET SQL_SAFE_UPDATES=0;
UPDATE products AS p 
JOIN `order details` AS od
ON od.ProductID = p.ProductID
JOIN orders AS o
ON o.OrderID = od.OrderID
SET p.UnitPrice = p.UnitPrice*0.8
WHERE o.ShipCountry = 'Brazil';
SET SQL_SAFE_UPDATES=1;

SELECT DISTINCT p.ProductID, p.UnitPrice AS 'Products UnitPrice', od.UnitPrice 'Order Details UnitPrice', o.ShipCountry
FROM products AS p
JOIN `order details` AS od
ON od.ProductID = p.ProductID
JOIN orders AS o
ON o.OrderID = od.OrderID
WHERE o.ShipCountry = 'Brazil';

-- 65- Delete todos os detalhes e, posteriormente, todos os pedidos feitos entre maio e 
-- junho de 1996.
-- OBS.: No nosso banco na data de 1996, começa a partir do mês 07!!!
-- Mudaremos para 1997.
DELETE
FROM `order details` AS od
WHERE od.OrderID IN(SELECT OrderID FROM orders WHERE OrderDate >= '1997-05-01 00:00:00' AND OrderDate <= '1997-06-30 00:00:00');

-- 66- Liste os pedidos sem itens.
-- Não há pedidos sem itens :(
SELECT o.OrderID
FROM orders AS o
WHERE o.OrderID NOT IN(SELECT od.OrderID FROM `order details` AS od);

-- 67- Deletar os pedidos sem itens.
-- Não há pedidos sem itens, então não há como deletar algo :(

-- 68- Dentro do pedido 10491 foi esquecido de colocar uma compra de 10 Tofus (código 
-- 14), vendidos ao preço de R$ 15,00, com 5% de desconto. Inclua esse item no Pedido 
-- 10491.
INSERT INTO `order details`
VALUES(10491, 14, 15, 10, 0.05);

-- 69- Altere todos os funcionários sob a supervisão de Fuller para o funcionário 7.
UPDATE employees
SET ReportsTo = 7
WHERE ReportsTo = 2;
-- WHERE ReportsTo = (SELECT EmployeeID FROM employees WHERE ReportsTo IS NULL);

SELECT EmployeeID, LastName, ReportsTo
FROM employees;

-- 70- Quais os produtos que não foram vendidos?
SELECT ProductID, ProductName
FROM products
WHERE ProductID NOT IN(SELECT ProductID FROM `order details`);

-- 71- Retire do detalhe dos pedidos todas as vendas de Tofu.
DELETE
FROM `order details` AS od
WHERE od.ProductID = (SELECT p.ProductID FROM products AS p WHERE p.ProductName LIKE 'TOFU');

-- INCOMPLETO -- 72- Delete todos os pedidos transportados pela “Federal Shipping”.
SELECT DISTINCT o.OrderID
FROM orders AS o
WHERE o.OrderID IN(SELECT OrderID FROM orders WHERE ShipVia = 3);

SET SQL_SAFE_UPDATES=0;
SET SQL_SAFE_UPDATES=1;

DELETE
FROM orders
WHERE ShipVia = 3;

-- 73- Criar uma tabela contendo: NÚMERO DO PEDIDO, VLR TOTAL DO PEDIDO, 
-- NOME DA EMPRESA, sendo que o número do pedido é inteiro, o nome da empresa é 
-- uma string de tamanho 40 e a chave será o número do pedido.
-- 74- Criar uma chave primária no número do pedido.
CREATE TABLE TotalOrders(
OrderID INTEGER NOT NULL PRIMARY KEY, 
TotalValue DECIMAL(10,4) NOT NULL DEFAULT 0, 
CompanyName VARCHAR(40) NOT NULL
);

-- 75- Criar um relacionamento entre a tabela “Total dos Pedidos” e a tabela Pedidos”.
ALTER TABLE `TotalOrders` ADD CONSTRAINT `FK_TotalOrders_Orders` 
FOREIGN KEY (`OrderID`) REFERENCES `orders` (`OrderID`);

ALTER TABLE `TotalOrders` ADD CONSTRAINT `FK_TotalOrders_Customers` 
FOREIGN KEY (`CompanyName`) REFERENCES `customers` (`CompanyName`);

-- INSERT INTO NOME_DA_TABELA_DESTINO (coluna1, coluna2, coluna3, ...., colunaN)
-- SELECT (coluna1, coluna2, coluna3, ..., colunaN)
-- FROM NOME_DA_TABELA_ORIGEM;

INSERT INTO totalorders (OrderID, TotalValue, CompanyName)
SELECT o.OrderID, (od.UnitPrice*od.Quantity)*(1-od.Discount) AS TotalValue, c.CompanyName
FROM orders AS o, `order details` AS od, customers AS c
WHERE c.CustomerID = o.CustomerID
AND o.OrderID = od.OrderID
GROUP BY o.OrderID;

-- 76- Carregue a tabela “Total dos Pedidos” com os dados do sistema.
SELECT * 
FROM totalorders;

-- 77- Criar uma tabela (“CHEFES”) contendo: Código do Funcionário (inteiro), Nome do 
-- Funcionário (caractere com 10) e Sobrenome do Funcionário (caractere com 20). 
-- Todos os campos são obrigatórios.
CREATE TABLE Boss(
EmployeeID INTEGER NOT NULL PRIMARY KEY,
FirstName VARCHAR(10) NOT NULL,
LastName VARCHAR(20) NOT NULL
);

ALTER TABLE `Boss` ADD CONSTRAINT `FK_Boss_Employees` 
FOREIGN KEY (`EmployeeID`) REFERENCES `employees` (`EmployeeID`);

-- 78- Carregue a tabela “CHEFES” com todos os supervisores.
INSERT INTO boss (EmployeeID, FirstName, LastName)
SELECT b.EmployeeID, b.FirstName, b.LastName
FROM employees AS e, employees AS b
WHERE e.ReportsTo = b.EmployeeID
GROUP BY b.EmployeeID;

SELECT *
FROM boss;

-- 79- Liste todos os produtos das categorias com mais de 5 fornecedores
SELECT *
FROM products
WHERE CategoryID IN(SELECT CategoryID FROM products AS p1 WHERE (SELECT COUNT(*) FROM products AS p2 WHERE p1.CategoryID=p2.CategoryID)>5);