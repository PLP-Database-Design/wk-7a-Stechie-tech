-- question 1
SELECT 
    OrderID,
    CustomerName,
    TRIM(product) AS Product
FROM (
    SELECT 
        OrderID,
        CustomerName,
        jt.product
    FROM ProductDetail,
    JSON_TABLE(
        CONCAT('["', REPLACE(Products, ',', '","'), '"]'),
        '$[*]' COLUMNS(product VARCHAR(100) PATH '$')
    ) AS jt
) AS normalized;

-- question 2

CREATE TABLE Orders (
  OrderID        INT         PRIMARY KEY,
  CustomerName   VARCHAR(100) NOT NULL
);

CREATE TABLE OrderItems (
  OrderID  INT,
  Product  VARCHAR(100),
  Quantity INT,
  PRIMARY KEY (OrderID, Product),
  FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);


INSERT INTO Orders (OrderID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

INSERT INTO OrderItems (OrderID, Product, Quantity)
SELECT OrderID, Product, Quantity
FROM OrderDetails;


SELECT 
  o.OrderID,
  o.CustomerName,
  i.Product,
  i.Quantity
FROM Orders AS o
JOIN OrderItems AS i USING (OrderID)
ORDER BY o.OrderID;

