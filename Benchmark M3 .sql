USE ToysGroup;

CREATE DATABASE IF NOT EXISTS ToysGroup;
USE ToysGroup;


CREATE TABLE IF NOT EXISTS Category (
    CategoryID INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName VARCHAR(255) NOT NULL
);


CREATE TABLE IF NOT EXISTS Product (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);


CREATE TABLE IF NOT EXISTS Region (
    RegionID INT AUTO_INCREMENT PRIMARY KEY,
    RegionName VARCHAR(255) NOT NULL
);


CREATE TABLE IF NOT EXISTS State (
    StateID INT AUTO_INCREMENT PRIMARY KEY,
    StateName VARCHAR(255) NOT NULL,
    RegionID INT,
    FOREIGN KEY (RegionID) REFERENCES Region(RegionID)
);


CREATE TABLE IF NOT EXISTS Sales (
    SalesID INT AUTO_INCREMENT PRIMARY KEY,
    ProductID INT,
    StateID INT,
    Date DATE NOT NULL,
    Amount INT NOT NULL,
    FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
    FOREIGN KEY (StateID) REFERENCES State(StateID)
);

INSERT INTO Category (CategoryName) VALUES
('Videogiochi'),
('Giochi di società'),
('Giochi educativi');


INSERT INTO Product (Name, Price, CategoryID) VALUES
('Console di gioco', 299.99, 1),
('Scacchi', 19.99, 2),
('Mattoncini educativi', 29.99, 3);


INSERT INTO Region (RegionName) VALUES
('Europa Occidentale'),
('Europa Meridionale');


INSERT INTO State (StateName, RegionID) VALUES
('Francia', 1),
('Germania', 1),
('Italia', 2),
('Grecia', 2);


INSERT INTO Sales (ProductID, StateID, Date, Amount) VALUES
(1, 1, '2023-05-10', 100),
(2, 2, '2023-06-15', 50),
(1, 3, '2023-07-20', 150),
(3, 4, '2023-08-25', 80),
(2, 1, '2023-09-30', 30);

SELECT * FROM Product WHERE ProductID = 1;
SET FOREIGN_KEY_CHECKS=0;
SET FOREIGN_KEY_CHECKS=1;

SELECT 
    p.Name AS ProductName,
    YEAR(s.Date) AS Year,
    SUM(s.Amount * p.Price) AS TotalRevenue
FROM Sales s
JOIN Product p ON s.ProductID = p.ProductID
GROUP BY p.Name, YEAR(s.Date);

SELECT 
    st.StateName AS State,
    YEAR(s.Date) AS Year,
    SUM(s.Amount * p.Price) AS TotalRevenue
FROM Sales s
JOIN State st ON s.StateID = st.StateID
JOIN Product p ON s.ProductID = p.ProductID
GROUP BY st.StateName, YEAR(s.Date)
ORDER BY YEAR(s.Date), TotalRevenue DESC;

SELECT 
    c.CategoryName,
    SUM(s.Amount) AS TotalSold
FROM Sales s
JOIN Product p ON s.ProductID = p.ProductID
JOIN Category c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY TotalSold DESC
LIMIT 1;

SELECT 
    p.Name AS ProductName
FROM Product p
LEFT JOIN Sales s ON p.ProductID = s.ProductID
WHERE s.SalesID IS NULL;

SELECT 
    p.Name AS ProductName
FROM Product p
WHERE NOT EXISTS (
    SELECT 1 FROM Sales s WHERE s.ProductID = p.ProductID
);

SELECT 
    s.SalesID AS SalesCode,
    s.Date,
    p.Name AS ProductName,
    c.CategoryName,
    st.StateName,
    r.RegionName,
    CASE 
        WHEN DATEDIFF(CURDATE(), s.Date) > 180 THEN TRUE
        ELSE FALSE
    END AS Over180Days
FROM Sales s
JOIN Product p ON s.ProductID = p.ProductID
JOIN Category c ON p.CategoryID = c.CategoryID
JOIN State st ON s.StateID = st.StateID
JOIN Region r ON st.RegionID = r.RegionID;

