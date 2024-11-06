/*---1---
Создайте таблицу EmployeeDetails для хранения информации о
сотрудниках. Таблица должна содержать следующие столбцы:
● EmployeeID (INTEGER, PRIMARY KEY)
● EmployeeName (TEXT)
● Position (TEXT)
● HireDate (DATE)
● Salary (NUMERIC)
После создания таблицы добавьте в неё три записи с произвольными данными о
сотрудниках*/

CREATE TABLE EmployeeDetails (
EmployeeID INTEGER PRIMARY KEY AUTOINCREMENT, 
EmployeeName TEXT,
Position TEXT,
HireDate DATE,
Salary NUMERIC
);

INSERT INTO EmployeeDetails (EmployeeName, Position, HireDate, Salary) 
VALUES ('Иванов А.Б', 'Инженер', '2001-08-22', 25000),
('Петров В.Г', 'Специалист 1кат', '2004-06-25', 55000),
('Сидоров Д.Е', 'Наладчик', '2003-02-05', 18000);

/*---2---
Создайте представление HighValueOrders для отображения всех заказов,
сумма которых превышает 10000. В представлении должны быть следующие столбцы:
● OrderID (идентификатор заказа),
● OrderDate (дата заказа),
● TotalAmount (общая сумма заказа, вычисленная как сумма всех Quantity *
Price).
Используйте таблицы Orders, OrderDetails и Products.
Подсказки:
1. Используйте JOIN для объединения таблиц.
2. Используйте функцию SUM() для вычисления общей суммы заказа.
*/

CREATE VIEW HighValueOrders AS
WITH ord_TotalAmount AS (
SELECT OrderID, SUM(Quantity * Price) AS TotalAmount FROM OrderDetails od
JOIN Products p ON p.ProductID = od.ProductID
GROUP BY OrderID
)
SELECT o.OrderID, OrderDate, TotalAmount FROM ord_TotalAmount ot
JOIN  Orders o ON o.OrderID = ot.OrderID
WHERE TotalAmount > 10000
ORDER BY OrderDate;


/*---3---
Удалите все записи из таблицы EmployeeDetails, где Salary меньше
50000. Затем удалите таблицу EmployeeDetails из базы данных.
Подсказки:
1. Используйте команду DELETE FROM для удаления данных.
2. Используйте команду DROP TABLE для удаления таблицы.*/

DELETE FROM EmployeeDetails WHERE Salary < 50000;
DROP TABLE IF EXISTS EmployeeDetails;

/*---4---
Создайте хранимую процедуру GetProductSales с одним параметром
ProductID. Эта процедура должна возвращать список всех заказов, в которых
участвует продукт с заданным ProductID, включая следующие столбцы:
● OrderID (идентификатор заказа),
● OrderDate (дата заказа),
● CustomerID (идентификатор клиента).
Подсказки:
1. Используйте команду CREATE PROCEDURE для создания процедуры.
2. Используйте JOIN для объединения таблиц и WHERE для фильтрации данных по
ProductID.
*/

CREATE PROCEDURE GetProductSales @ProductID INT
AS
BEGIN
	DECLARE @query VARCHAR(1000)
	SET @query = 
	'SELECT od.OrderID, OrderDate, CustomerID FROM Orders o
	JOIN OrderDetails od ON od.OrderID = o.OrderID
	WHERE ProductID =' + CAST(@ProductID AS VARCHAR(10))
	EXEC (@query)
END;

-- GetProductSales @ProductID = 33;