-- Adding sales report
-- task 1
CREATE VIEW OrdersView AS
SELECT OrderID, OrderQty, OrderTotalCost
FROM littlelemondb.order
WHERE OrderQty > 2;

-- task 2
SELECT c.CustomerID, c.CustomerName, o.OrderID, o.OrderTotalCost, m.MenuCuisine, mi.CourseName, mi.StarterName
FROM customer c
JOIN `order` o on o.CustomerID = c.CustomerID
JOIN menu m on o.MenuID = m.MenuID 
JOIN menuitems mi on mi.menuitemsID = m.menuitemsID
WHERE OrderTotalCost > 150
ORDER BY o.OrderTotalCost ASC;

-- task 3
SELECT MenuName
FROM menu
WHERE MenuID = ANY (
    SELECT MenuID
    FROM `order`
    WHERE OrderQty > 2
);	

-- Task 1: Stored Procedure
DELIMITER //
CREATE PROCEDURE GetMaxQuantity ()
BEGIN
SELECT MAX(OrderQty)
FROM `order`;
END //
DELIMITER ;
CALL GetMaxQuantity();

-- Task 2: Prepared Statement
PREPARE GetOrderDetail FROM 'SELECT OrderID, OrderQty, OrderTotalCost FROM `order` WHERE CustomerID = ?';
SET @CustomerID = 1;
EXECUTE GetOrderDetail USING @CustomerID;

-- Task 3: Stored Procedure
DELIMITER //
CREATE PROCEDURE CancelOrder(IN order_id INT)
BEGIN
DELETE FROM `order` WHERE OrderID = order_id;
END //
DELIMITER ;
CALL CancelOrder(5);

-- Table booking system
-- task 1
INSERT INTO customer (CustomerID, CustomerName, CustomerPhone, CustomerEmail) 
VALUES
	(1, 'John Doe', '1234567890', 'john.doe@example.com'),
	(2, 'Jane Smith', '2345678901', 'jane.smith@example.com'),
	(3, 'David Lee', '3456789012', 'david.lee@example.com'),
	(4, 'Sarah Chen', '4567890123', 'sarah.chen@example.com'),
	(5, 'Michael Kim', '5678901234','michael.kim@example.com');
    
INSERT INTO booking (BookingID, BookingTable, BookingDate, CustomerID) 
VALUES
	(1, 5, '2022-10-10', 1),
	(2, 3, '2022-11-12', 3),
	(3, 2, '2022-10-11', 2),
	(4, 2, '2022-10-13', 1)
    
-- task 2
DELIMITER //
CREATE PROCEDURE CheckBooking (
	IN BookingDate DATE,
	IN BookingTable INT
)
BEGIN
	-- Declare a variable to store the booking status
	DECLARE booking_status BOOL;

	-- Check if the table is already booked
	SELECT COUNT(*) INTO booking_status
	FROM booking
	WHERE bookingdate = @bookingdate AND bookingtable = @bookingtable;

	-- Output a message indicating whether the table is available or already booked
	IF booking_status = TRUE THEN
		SELECT CONCAT('Table ', bookingtable, ' is already booked') AS message;
	ELSE
		SELECT CONCAT('Table ', bookingtable, ' is available') AS message;
	END IF;
END //
DELIMITER ;
CALL CheckBooking('2023-03-15', 1);

-- task 1
DELIMITER //
CREATE PROCEDURE AddBooking (
	IN bookingtable INT,
	IN bookingdate DATE,
	IN customerid INT
)
BEGIN
	DECLARE booking_status BOOL;
	SELECT COUNT(*) INTO booking_status
	FROM booking
	WHERE BookingTable = BookingTable AND BookingDate = bookingdate;
	
	IF booking_status = 0 THEN
		INSERT INTO booking (BookingTable, BookingDate, CustomerID)
		VALUES (bookingtable, bookingdate, customerid);
		SELECT CONCAT('Booking for table ', bookingtable, ' on ', bookingdate, ' was successful') AS message;
	ELSE
		SELECT CONCAT('Table ', bookingtable, ' is already booked on ', bookingdate) AS message;
	END IF;
END //
DELIMITER ;
CALL AddBooking(1, '2023-03-10', 2);

-- task 2
DELIMITER //
CREATE PROCEDURE UpdateBooking(
	IN BookingID INT,
	IN UpdatedTable INT,
	IN UpdatedDate DATE
)
BEGIN
	UPDATE booking 
	SET BookingTable = UpdatedTable, BookingDate = UpdatedDate 
	WHERE BookingID = BookingID;
END //
DELIMITER ;
CALL UpdateBooking(1, 1, '2022-10-11');

-- task 3
DELIMITER //
CREATE PROCEDURE CancelBooking(IN bookingid INT)
BEGIN
DELETE FROM booking WHERE BookingID = bookingid;
END //
DELIMITER ;
CALL CancelBooking(2);


