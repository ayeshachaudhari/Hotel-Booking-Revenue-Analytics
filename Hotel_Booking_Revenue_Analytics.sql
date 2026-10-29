-- PROJECT: HOTEL BOOKING & REVENUE OPTIMIZATION

-- STEP 1: CREATE DATABASE

CREATE DATABASE hotel_analytics;

USE hotel_analytics;

-- Verify selected database
SELECT DATABASE();

-- 1. CUSTOMERS
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    gender VARCHAR(20),
    country VARCHAR(50),
    city VARCHAR(50),
    registration_date DATE,
    customer_type VARCHAR(30)
);

-- 2. HOTELS
CREATE TABLE hotels (
    hotel_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_name VARCHAR(100) NOT NULL,
    city VARCHAR(50),
    country VARCHAR(50),
    star_rating DECIMAL(2,1),
    hotel_type VARCHAR(50),
    total_rooms INT,
    opening_date DATE
);

-- 3. ROOM TYPES
CREATE TABLE room_types (
    room_type_id INT PRIMARY KEY AUTO_INCREMENT,
    room_type_name VARCHAR(50) NOT NULL,
    base_price DECIMAL(10,2),
    max_guests INT,
    description VARCHAR(255)
);

-- 4. ROOMS
CREATE TABLE rooms (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT NOT NULL,
    room_type_id INT NOT NULL,
    room_number VARCHAR(10) NOT NULL,
    floor_number INT,
    room_status VARCHAR(30),
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id),
    FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id),
    UNIQUE (hotel_id, room_number)
);

-- 5. BOOKINGS
CREATE TABLE bookings (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    hotel_id INT NOT NULL,
    booking_source_id INT,
    booking_date DATE NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    number_of_guests INT,
    booking_status VARCHAR(30),
    total_amount DECIMAL(12,2),
    discount_amount DECIMAL(12,2) DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
);

-- 6. BOOKING ROOMS
CREATE TABLE booking_rooms (
    booking_room_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    room_id INT NOT NULL,
    nightly_rate DECIMAL(10,2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- 7. PAYMENTS
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    payment_date DATE,
    payment_method VARCHAR(30),
    payment_amount DECIMAL(12,2),
    payment_status VARCHAR(30),
    transaction_reference VARCHAR(100),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- 8. CANCELLATIONS
CREATE TABLE cancellations (
    cancellation_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    cancellation_date DATE,
    cancellation_reason VARCHAR(255),
    refund_amount DECIMAL(12,2) DEFAULT 0,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id)
);

-- 9. REVIEWS
CREATE TABLE reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    customer_id INT NOT NULL,
    rating DECIMAL(2,1),
    review_date DATE,
    review_text VARCHAR(500),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 10. SERVICES
CREATE TABLE services (
    service_id INT PRIMARY KEY AUTO_INCREMENT,
    service_name VARCHAR(100) NOT NULL,
    service_category VARCHAR(50),
    service_price DECIMAL(10,2)
);

-- 11. SERVICE USAGE
CREATE TABLE service_usage (
    usage_id INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    service_id INT NOT NULL,
    usage_date DATE,
    quantity INT DEFAULT 1,
    total_cost DECIMAL(10,2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (service_id) REFERENCES services(service_id)
);

-- 12. EMPLOYEES
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT NOT NULL,
    employee_name VARCHAR(100),
    job_title VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(12,2),
    hire_date DATE,
    employment_status VARCHAR(30),
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
);

-- 13. EXPENSES
CREATE TABLE expenses (
    expense_id INT PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT NOT NULL,
    expense_date DATE,
    expense_category VARCHAR(50),
    expense_description VARCHAR(255),
    expense_amount DECIMAL(12,2),
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id)
);

-- 14. MARKETING CAMPAIGNS
CREATE TABLE marketing_campaigns (
    campaign_id INT PRIMARY KEY AUTO_INCREMENT,
    campaign_name VARCHAR(100),
    marketing_channel VARCHAR(50),
    start_date DATE,
    end_date DATE,
    campaign_budget DECIMAL(12,2)
);

-- 15. BOOKING SOURCES
CREATE TABLE booking_sources (
    booking_source_id INT PRIMARY KEY AUTO_INCREMENT,
    source_name VARCHAR(50) NOT NULL,
    commission_percentage DECIMAL(5,2),
    source_category VARCHAR(50)
);

-- VERIFY TABLES
SHOW TABLES;


-- 1. HOTELS

INSERT INTO hotels
(hotel_name, city, country, star_rating, hotel_type, total_rooms, opening_date)
VALUES
('Grand Palace Hotel', 'Mumbai', 'India', 5.0, 'Luxury', 120, '2018-01-15'),
('Sea View Resort', 'Goa', 'India', 4.0, 'Resort', 90, '2019-06-10'),
('Royal Comfort Inn', 'Delhi', 'India', 3.0, 'Business', 80, '2020-03-20'),
('Mountain Escape', 'Manali', 'India', 4.0, 'Resort', 65, '2021-05-12'),
('City Business Hotel', 'Bengaluru', 'India', 4.0, 'Business', 100, '2017-11-01');

-- 2. ROOM TYPES
INSERT INTO room_types
(room_type_name, base_price, max_guests, description)
VALUES
('Standard', 2500, 2, 'Comfortable standard room'),
('Deluxe', 4000, 3, 'Premium deluxe room'),
('Suite', 8000, 4, 'Luxury suite'),
('Family Room', 6000, 5, 'Room for families'),
('Executive', 5500, 2, 'Business executive room');

-- 3. BOOKING SOURCES
INSERT INTO booking_sources
(source_name, commission_percentage, source_category)
VALUES
('Hotel Website', 0.00, 'Direct'),
('Mobile App', 0.00, 'Direct'),
('Booking.com', 15.00, 'OTA'),
('MakeMyTrip', 18.00, 'OTA'),
('Travel Agent', 10.00, 'Agent');

-- 4. SERVICES
INSERT INTO services
(service_name, service_category, service_price)
VALUES
('Breakfast', 'Food', 500),
('Spa', 'Wellness', 2000),
('Laundry', 'Housekeeping', 300),
('Airport Transfer', 'Transport', 1500),
('Room Service', 'Food', 700);

-- 5. MARKETING CAMPAIGNS
INSERT INTO marketing_campaigns
(campaign_name, marketing_channel, start_date, end_date, campaign_budget)
VALUES
('Summer Getaway', 'Social Media', '2025-04-01', '2025-06-30', 150000),
('Festive Offers', 'Email', '2025-10-01', '2025-11-15', 100000),
('Winter Escape', 'Search Ads', '2025-12-01', '2026-02-28', 200000),
('Weekend Deals', 'Mobile App', '2026-01-01', '2026-12-31', 75000);


SELECT * FROM hotels;
SELECT * FROM room_types;
SELECT * FROM booking_sources;
SELECT * FROM services;
SELECT * FROM marketing_campaigns;

-- 6. CUSTOMERS
INSERT INTO customers
(first_name, last_name, email, phone, gender, country, city,
 registration_date, customer_type)
VALUES
('Aarav', 'Shah', 'aarav.shah@example.com', '9000000001', 'Male', 'India', 'Mumbai', '2025-01-05', 'Regular'),
('Priya', 'Patel', 'priya.patel@example.com', '9000000002', 'Female', 'India', 'Mumbai', '2025-01-10', 'Premium'),
('Rahul', 'Verma', 'rahul.verma@example.com', '9000000003', 'Male', 'India', 'Delhi', '2025-01-15', 'Regular'),
('Sneha', 'Rao', 'sneha.rao@example.com', '9000000004', 'Female', 'India', 'Bengaluru', '2025-02-01', 'Premium'),
('Kabir', 'Mehta', 'kabir.mehta@example.com', '9000000005', 'Male', 'India', 'Pune', '2025-02-10', 'Regular'),
('Ananya', 'Das', 'ananya.das@example.com', '9000000006', 'Female', 'India', 'Kolkata', '2025-02-15', 'Regular'),
('Vikram', 'Singh', 'vikram.singh@example.com', '9000000007', 'Male', 'India', 'Jaipur', '2025-03-01', 'Premium'),
('Isha', 'Kapoor', 'isha.kapoor@example.com', '9000000008', 'Female', 'India', 'Chandigarh', '2025-03-05', 'Regular'),
('Rohan', 'Nair', 'rohan.nair@example.com', '9000000009', 'Male', 'India', 'Kochi', '2025-03-10', 'Premium'),
('Meera', 'Joshi', 'meera.joshi@example.com', '9000000010', 'Female', 'India', 'Nashik', '2025-03-15', 'Regular'),
('Aditya', 'Gupta', 'aditya.gupta@example.com', '9000000011', 'Male', 'India', 'Lucknow', '2025-04-01', 'Regular'),
('Kavya', 'Iyer', 'kavya.iyer@example.com', '9000000012', 'Female', 'India', 'Chennai', '2025-04-05', 'Premium'),
('Arjun', 'Malhotra', 'arjun.malhotra@example.com', '9000000013', 'Male', 'India', 'Mumbai', '2025-04-10', 'Regular'),
('Neha', 'Kulkarni', 'neha.kulkarni@example.com', '9000000014', 'Female', 'India', 'Pune', '2025-04-15', 'Premium'),
('Dev', 'Khanna', 'dev.khanna@example.com', '9000000015', 'Male', 'India', 'Delhi', '2025-05-01', 'Regular'),
('Pooja', 'Sharma', 'pooja.sharma@example.com', '9000000016', 'Female', 'India', 'Jaipur', '2025-05-05', 'Regular'),
('Karan', 'Desai', 'karan.desai@example.com', '9000000017', 'Male', 'India', 'Surat', '2025-05-10', 'Premium'),
('Riya', 'Fernandes', 'riya.fernandes@example.com', '9000000018', 'Female', 'India', 'Goa', '2025-05-15', 'Regular'),
('Yash', 'Chopra', 'yash.chopra@example.com', '9000000019', 'Male', 'India', 'Noida', '2025-06-01', 'Premium'),
('Simran', 'Kaur', 'simran.kaur@example.com', '9000000020', 'Female', 'India', 'Amritsar', '2025-06-05', 'Regular');

-- 7.ROOMS

INSERT INTO rooms
(hotel_id, room_type_id, room_number, floor_number, room_status)
VALUES
(1, 1, '101', 1, 'Available'),
(1, 2, '102', 1, 'Available'),
(1, 3, '201', 2, 'Available'),
(1, 4, '202', 2, 'Available'),
(1, 5, '301', 3, 'Available'),
(2, 1, '101', 1, 'Available'),
(2, 2, '102', 1, 'Available'),
(2, 3, '201', 2, 'Available'),
(2, 4, '202', 2, 'Available'),
(2, 5, '301', 3, 'Available'),
(3, 1, '101', 1, 'Available'),
(3, 2, '102', 1, 'Available'),
(3, 3, '201', 2, 'Available'),
(3, 4, '202', 2, 'Available'),
(3, 5, '301', 3, 'Available'),
(4, 1, '101', 1, 'Available'),
(4, 2, '102', 1, 'Available'),
(4, 3, '201', 2, 'Available'),
(4, 4, '202', 2, 'Available'),
(4, 5, '301', 3, 'Available'),
(5, 1, '101', 1, 'Available'),
(5, 2, '102', 1, 'Available'),
(5, 3, '201', 2, 'Available'),
(5, 4, '202', 2, 'Available'),
(5, 5, '301', 3, 'Available');

-- 8.EMPLOYEES

INSERT INTO employees
(hotel_id, employee_name, job_title, department, salary,
 hire_date, employment_status)
VALUES
(1, 'Amit Sharma', 'Manager', 'Management', 75000, '2022-01-10', 'Active'),
(1, 'Neel Patel', 'Receptionist', 'Front Office', 30000, '2023-03-15', 'Active'),
(1, 'Sara Khan', 'Chef', 'Food', 40000, '2023-06-01', 'Active'),
(2, 'Ramesh Naik', 'Manager', 'Management', 65000, '2022-05-12', 'Active'),
(2, 'Anjali Rao', 'Receptionist', 'Front Office', 28000, '2023-07-20', 'Active'),
(2, 'John Dsouza', 'Chef', 'Food', 38000, '2024-01-05', 'Active'),
(3, 'Vivek Gupta', 'Manager', 'Management', 60000, '2021-08-10', 'Active'),
(3, 'Pallavi Das', 'Receptionist', 'Front Office', 27000, '2024-02-15', 'Active'),
(3, 'Manoj Kumar', 'Housekeeping Staff', 'Housekeeping', 22000, '2024-05-01', 'Active'),
(4, 'Suresh Thakur', 'Manager', 'Management', 62000, '2022-11-10', 'Active'),
(4, 'Nisha Verma', 'Receptionist', 'Front Office', 29000, '2023-09-15', 'Active'),
(4, 'Deepak Joshi', 'Chef', 'Food', 36000, '2024-04-01', 'Active'),
(5, 'Kiran Shetty', 'Manager', 'Management', 68000, '2020-12-10', 'Active'),
(5, 'Maya Iyer', 'Receptionist', 'Front Office', 31000, '2022-08-15', 'Active'),
(5, 'Rohit Singh', 'Housekeeping Staff', 'Housekeeping', 24000, '2024-06-01', 'Active');


SELECT COUNT(*) AS total_customers FROM customers;
SELECT COUNT(*) AS total_rooms FROM rooms;
SELECT COUNT(*) AS total_employees FROM employees;

-- 9.BOOKINGS

-- Link booking sources with bookings
ALTER TABLE bookings
ADD CONSTRAINT fk_bookings_source
FOREIGN KEY (booking_source_id)
REFERENCES booking_sources(booking_source_id);

-- Insert booking records
INSERT INTO bookings
(customer_id, hotel_id, booking_source_id, booking_date,
 check_in_date, check_out_date, number_of_guests,
 booking_status, total_amount, discount_amount)
VALUES
(1,1,1,'2025-01-05','2025-01-10','2025-01-12',2,'Completed',8000,500),
(2,1,3,'2025-01-08','2025-01-15','2025-01-18',2,'Completed',15000,1000),
(3,2,2,'2025-01-10','2025-01-20','2025-01-23',3,'Completed',12000,500),
(4,5,4,'2025-01-15','2025-01-25','2025-01-27',2,'Completed',11000,0),
(5,3,1,'2025-01-20','2025-02-01','2025-02-03',2,'Completed',5000,300),
(6,2,3,'2025-01-25','2025-02-05','2025-02-09',4,'Cancelled',18000,1000),
(7,4,2,'2025-02-01','2025-02-10','2025-02-13',2,'Completed',12000,500),
(8,1,5,'2025-02-05','2025-02-15','2025-02-17',2,'Completed',16000,1000),
(9,5,1,'2025-02-10','2025-02-20','2025-02-22',2,'Completed',11000,0),
(10,3,3,'2025-02-15','2025-02-25','2025-02-28',3,'Cancelled',9000,500),
(11,2,4,'2025-02-20','2025-03-01','2025-03-04',2,'Completed',12000,500),
(12,1,2,'2025-02-25','2025-03-05','2025-03-08',2,'Completed',24000,2000),
(13,5,3,'2025-03-01','2025-03-10','2025-03-12',2,'Completed',11000,500),
(14,4,1,'2025-03-05','2025-03-15','2025-03-18',4,'Completed',18000,1000),
(15,3,5,'2025-03-10','2025-03-20','2025-03-22',2,'Completed',5000,0),
(16,2,2,'2025-03-15','2025-03-25','2025-03-28',3,'Cancelled',12000,500),
(17,1,4,'2025-03-20','2025-04-01','2025-04-04',2,'Completed',24000,1500),
(18,2,3,'2025-03-25','2025-04-05','2025-04-08',2,'Completed',12000,500),
(19,5,1,'2025-04-01','2025-04-10','2025-04-12',2,'Completed',11000,0),
(20,4,5,'2025-04-05','2025-04-15','2025-04-19',5,'Completed',24000,1000),
(1,3,2,'2025-04-10','2025-04-20','2025-04-22',2,'Completed',5000,200),
(2,2,3,'2025-04-15','2025-04-25','2025-04-28',3,'Cancelled',12000,500),
(3,1,1,'2025-04-20','2025-05-01','2025-05-04',2,'Completed',24000,1000),
(4,5,4,'2025-04-25','2025-05-05','2025-05-07',2,'Completed',11000,500),
(5,4,2,'2025-05-01','2025-05-10','2025-05-12',2,'Completed',8000,0),
(6,1,3,'2025-05-05','2025-05-15','2025-05-18',2,'Cancelled',24000,2000),
(7,2,1,'2025-05-10','2025-05-20','2025-05-23',3,'Completed',12000,500),
(8,5,5,'2025-05-15','2025-05-25','2025-05-27',2,'Completed',11000,0),
(9,3,4,'2025-05-20','2025-06-01','2025-06-04',2,'Completed',7500,500),
(10,4,2,'2025-05-25','2025-06-05','2025-06-08',4,'Completed',18000,1000);


SELECT COUNT(*) AS total_bookings
FROM bookings;

SELECT booking_status, COUNT(*) AS total
FROM bookings
GROUP BY booking_status;

SELECT *
FROM bookings
ORDER BY booking_id;

-- 10.BOOKINGS ROOMS
INSERT INTO booking_rooms
(booking_id, room_id, nightly_rate)
VALUES
(1,1,4000),
(2,2,5000),
(3,6,4000),
(4,22,5500),
(5,11,2500),
(6,7,4500),
(7,16,4000),
(8,3,8000),
(9,23,5500),
(10,12,3000),
(11,8,4000),
(12,4,8000),
(13,24,5500),
(14,19,6000),
(15,13,2500),
(16,9,4000),
(17,5,8000),
(18,10,4000),
(19,25,5500),
(20,20,6000),
(21,14,2500),
(22,6,4000),
(23,3,8000),
(24,21,5500),
(25,17,4000),
(26,4,8000),
(27,7,4000),
(28,22,5500),
(29,15,2500),
(30,18,4000);

SELECT COUNT(*) AS total_booking_rooms
FROM booking_rooms;


-- 11.PAYMENTS
INSERT INTO payments
(booking_id, payment_date, payment_method,
 payment_amount, payment_status, transaction_reference)
VALUES
(1,'2025-01-05','Credit Card',7500,'Paid','TXN1001'),
(2,'2025-01-08','UPI',14000,'Paid','TXN1002'),
(3,'2025-01-10','Debit Card',11500,'Paid','TXN1003'),
(4,'2025-01-15','Credit Card',11000,'Paid','TXN1004'),
(5,'2025-01-20','UPI',4700,'Paid','TXN1005'),
(6,'2025-01-25','UPI',0,'Refunded','TXN1006'),
(7,'2025-02-01','Credit Card',11500,'Paid','TXN1007'),
(8,'2025-02-05','Debit Card',15000,'Paid','TXN1008'),
(9,'2025-02-10','UPI',11000,'Paid','TXN1009'),
(10,'2025-02-15','UPI',0,'Refunded','TXN1010'),
(11,'2025-02-20','Credit Card',11500,'Paid','TXN1011'),
(12,'2025-02-25','Credit Card',22000,'Paid','TXN1012'),
(13,'2025-03-01','UPI',10500,'Paid','TXN1013'),
(14,'2025-03-05','Debit Card',17000,'Paid','TXN1014'),
(15,'2025-03-10','Cash',5000,'Paid','TXN1015'),
(16,'2025-03-15','UPI',0,'Refunded','TXN1016'),
(17,'2025-03-20','Credit Card',22500,'Paid','TXN1017'),
(18,'2025-03-25','UPI',11500,'Paid','TXN1018'),
(19,'2025-04-01','Debit Card',11000,'Paid','TXN1019'),
(20,'2025-04-05','Credit Card',23000,'Paid','TXN1020'),
(21,'2025-04-10','UPI',4800,'Paid','TXN1021'),
(22,'2025-04-15','UPI',0,'Refunded','TXN1022'),
(23,'2025-04-20','Credit Card',23000,'Paid','TXN1023'),
(24,'2025-04-25','Debit Card',10500,'Paid','TXN1024'),
(25,'2025-05-01','UPI',8000,'Paid','TXN1025'),
(26,'2025-05-05','Credit Card',22000,'Paid','TXN1026'),
(27,'2025-05-10','UPI',11500,'Paid','TXN1027'),
(28,'2025-05-15','Debit Card',11000,'Paid','TXN1028'),
(29,'2025-05-20','Cash',7000,'Pending','TXN1029'),
(30,'2025-05-25','Credit Card',18000,'Pending','TXN1030');

SELECT payment_status, COUNT(*) AS payment_count,
       SUM(payment_amount) AS total_payment
FROM payments
GROUP BY payment_status;

SELECT
    b.booking_id,
    h.hotel_name,
    p.payment_amount,
    p.payment_status
FROM bookings b
JOIN hotels h
    ON b.hotel_id = h.hotel_id
JOIN payments p
    ON b.booking_id = p.booking_id
ORDER BY b.booking_id;

-- 12.CANCELLATIONS
INSERT INTO cancellations
(booking_id, cancellation_date, cancellation_reason, refund_amount)
VALUES
(6, '2025-01-28', 'Change in travel plan', 18000),
(10, '2025-02-20', 'Booking made by mistake', 9000),
(16, '2025-03-18', 'Unexpected emergency', 12000),
(22, '2025-04-18', 'Date change required', 12000),
(26, '2025-05-10', 'Personal reasons', 24000);

-- 13.REVIEWS
INSERT INTO reviews
(booking_id, customer_id, rating, review_date, review_text)
VALUES
(1, 1, 4.5, '2025-01-12', 'Excellent service and clean room'),
(2, 2, 5.0, '2025-01-18', 'Amazing luxury experience'),
(3, 3, 4.0, '2025-01-23', 'Comfortable stay'),
(4, 4, 3.5, '2025-01-27', 'Good location but slow service'),
(5, 5, 4.0, '2025-02-03', 'Value for money'),
(7, 7, 4.5, '2025-02-13', 'Beautiful resort'),
(8, 8, 5.0, '2025-02-17', 'Outstanding hospitality'),
(9, 9, 4.0, '2025-02-22', 'Nice business hotel'),
(11, 11, 3.0, '2025-03-04', 'Average room service'),
(12, 12, 4.5, '2025-03-08', 'Spacious and comfortable suite'),
(13, 13, 4.0, '2025-03-12', 'Good overall experience'),
(14, 14, 4.5, '2025-03-18', 'Great family stay'),
(15, 15, 3.5, '2025-03-22', 'Room was a little small'),
(17, 17, 5.0, '2025-04-04', 'Excellent staff and facilities'),
(18, 18, 4.0, '2025-04-08', 'Enjoyed the stay'),
(19, 19, 4.5, '2025-04-12', 'Very clean hotel'),
(20, 20, 5.0, '2025-04-19', 'Perfect family vacation'),
(21, 1, 4.0, '2025-04-22', 'Good value'),
(23, 3, 4.5, '2025-05-04', 'Would visit again'),
(24, 4, 3.5, '2025-05-07', 'Could improve breakfast');

-- 14.SERVICE USAGE
INSERT INTO service_usage
(booking_id, service_id, usage_date, quantity, total_cost)
VALUES
(1, 1, '2025-01-11', 2, 1000),
(2, 2, '2025-01-16', 1, 2000),
(3, 1, '2025-01-21', 3, 1500),
(4, 4, '2025-01-26', 1, 1500),
(5, 3, '2025-02-02', 2, 600),
(7, 1, '2025-02-11', 2, 1000),
(8, 2, '2025-02-16', 1, 2000),
(9, 5, '2025-02-21', 2, 1400),
(11, 4, '2025-03-02', 1, 1500),
(12, 1, '2025-03-06', 2, 1000),
(13, 3, '2025-03-11', 1, 300),
(14, 1, '2025-03-16', 4, 2000),
(15, 5, '2025-03-21', 1, 700),
(17, 2, '2025-04-02', 1, 2000),
(18, 4, '2025-04-06', 1, 1500),
(19, 1, '2025-04-11', 2, 1000),
(20, 5, '2025-04-16', 3, 2100),
(21, 3, '2025-04-21', 1, 300),
(23, 2, '2025-05-02', 1, 2000),
(24, 1, '2025-05-06', 2, 1000);

-- 15.EXPENSES
INSERT INTO expenses
(hotel_id, expense_date, expense_category, expense_description, expense_amount)
VALUES
(1, '2025-01-31', 'Utilities', 'Electricity and water', 25000),
(1, '2025-02-28', 'Maintenance', 'Room maintenance', 12000),
(1, '2025-03-31', 'Staff', 'Monthly operating payroll', 90000),
(1, '2025-04-30', 'Marketing', 'Online promotions', 15000),
(2, '2025-01-31', 'Utilities', 'Electricity and water', 18000),
(2, '2025-02-28', 'Maintenance', 'Pool and room maintenance', 10000),
(2, '2025-03-31', 'Staff', 'Monthly operating payroll', 75000),
(2, '2025-04-30', 'Marketing', 'Travel promotions', 12000),
(3, '2025-01-31', 'Utilities', 'Electricity and water', 14000),
(3, '2025-02-28', 'Maintenance', 'Room maintenance', 8000),
(3, '2025-03-31', 'Staff', 'Monthly operating payroll', 65000),
(3, '2025-04-30', 'Marketing', 'Business travel campaign', 10000),
(4, '2025-01-31', 'Utilities', 'Electricity and water', 16000),
(4, '2025-02-28', 'Maintenance', 'Property maintenance', 9000),
(4, '2025-03-31', 'Staff', 'Monthly operating payroll', 70000),
(4, '2025-04-30', 'Marketing', 'Holiday promotions', 11000),
(5, '2025-01-31', 'Utilities', 'Electricity and water', 20000),
(5, '2025-02-28', 'Maintenance', 'Room maintenance', 11000),
(5, '2025-03-31', 'Staff', 'Monthly operating payroll', 85000),
(5, '2025-04-30', 'Marketing', 'Corporate promotions', 14000);


SELECT COUNT(*) AS total_cancellations FROM cancellations;
SELECT COUNT(*) AS total_reviews FROM reviews;
SELECT COUNT(*) AS total_service_usage FROM service_usage;
SELECT COUNT(*) AS total_expenses FROM expenses;

-- Final data checks
-- 1. Check all tables and row counts

SELECT 'customers' AS table_name, COUNT(*) AS total_rows FROM customers
UNION ALL
SELECT 'hotels', COUNT(*) FROM hotels
UNION ALL
SELECT 'rooms', COUNT(*) FROM rooms
UNION ALL
SELECT 'bookings', COUNT(*) FROM bookings
UNION ALL
SELECT 'booking_rooms', COUNT(*) FROM booking_rooms
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'cancellations', COUNT(*) FROM cancellations
UNION ALL
SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL
SELECT 'service_usage', COUNT(*) FROM service_usage
UNION ALL
SELECT 'employees', COUNT(*) FROM employees
UNION ALL
SELECT 'expenses', COUNT(*) FROM expenses;

-- 2. Check invalid date ranges
SELECT booking_id, check_in_date, check_out_date
FROM bookings
WHERE check_out_date <= check_in_date;

-- 3. Check bookings without a matching hotel
SELECT b.booking_id, b.hotel_id
FROM bookings b
LEFT JOIN hotels h
    ON b.hotel_id = h.hotel_id
WHERE h.hotel_id IS NULL;

-- QUESTION 1: Comprehensive Hotel Revenue & Performance Optimization Report

WITH
-- SECTION 1: REPORTING PERIOD
report_period AS (
    SELECT
        DATE('2025-01-01') AS start_date,
        DATE('2025-05-31') AS end_date
),


-- SECTION 2: HOTEL MASTER INFORMATION

hotel_base AS (
    SELECT
        h.hotel_id,
        h.hotel_name,
        h.city,
        h.country,
        h.star_rating,
        h.hotel_type,
        h.total_rooms
    FROM hotels h
),


-- SECTION 3: OVERALL BOOKING PERFORMANCE

booking_summary AS (
    SELECT
        b.hotel_id,
        COUNT(*) AS total_bookings,
        SUM(
            CASE
                WHEN b.booking_status = 'Completed'
                THEN 1 ELSE 0
            END
        ) AS completed_bookings,
        SUM(
            CASE
                WHEN b.booking_status = 'Cancelled'
                THEN 1 ELSE 0
            END
        ) AS cancelled_bookings,
        SUM(
            CASE
                WHEN b.booking_status = 'Pending'
                THEN 1 ELSE 0
            END
        ) AS pending_bookings,
        SUM(
            CASE
                WHEN b.booking_status = 'Confirmed'
                THEN 1 ELSE 0
            END
        ) AS confirmed_bookings,
        COUNT(DISTINCT b.customer_id) AS unique_customers,
        SUM(b.number_of_guests) AS total_guests
    FROM bookings b
    CROSS JOIN report_period rp
    WHERE b.booking_date BETWEEN rp.start_date AND rp.end_date
    GROUP BY b.hotel_id
),


-- SECTION 4: COMPLETED BOOKING REVENUE

completed_revenue AS (
    SELECT
        b.hotel_id,
        SUM(b.total_amount) AS gross_booking_value,
        SUM(b.discount_amount) AS total_discounts,
        SUM(b.total_amount - b.discount_amount)
            AS net_booking_revenue,
        AVG(b.total_amount - b.discount_amount)
            AS average_booking_value,
        AVG(b.discount_amount) AS average_discount,
        MAX(b.total_amount - b.discount_amount)
            AS highest_booking_value,
        MIN(b.total_amount - b.discount_amount)
            AS lowest_booking_value
    FROM bookings b
    CROSS JOIN report_period rp
    WHERE b.booking_status = 'Completed'
      AND b.booking_date BETWEEN rp.start_date AND rp.end_date
    GROUP BY b.hotel_id
),


-- SECTION 5: PAYMENT COLLECTION PERFORMANCE

payment_summary AS (
    SELECT
        b.hotel_id,
        COUNT(p.payment_id) AS payment_records,
        SUM(
            CASE
                WHEN p.payment_status = 'Paid'
                THEN p.payment_amount ELSE 0
            END
        ) AS successful_collections,
        SUM(
            CASE
                WHEN p.payment_status = 'Pending'
                THEN p.payment_amount ELSE 0
            END
        ) AS pending_payment_amount,
        SUM(
            CASE
                WHEN p.payment_status = 'Refunded'
                THEN p.payment_amount ELSE 0
            END
        ) AS refunded_payment_records_amount,
        SUM(
            CASE
                WHEN p.payment_status = 'Failed'
                THEN 1 ELSE 0
            END
        ) AS failed_payments,
        COUNT(
            DISTINCT CASE
                WHEN p.payment_status = 'Paid'
                THEN p.payment_method
            END
        ) AS payment_methods_used
    FROM bookings b
    JOIN payments p
        ON b.booking_id = p.booking_id
    CROSS JOIN report_period rp
    WHERE b.booking_date BETWEEN rp.start_date AND rp.end_date
    GROUP BY b.hotel_id
),


-- SECTION 6: CANCELLATION ANALYSIS

cancellation_summary AS (
    SELECT
        b.hotel_id,
        COUNT(c.cancellation_id) AS cancellation_records,
        SUM(COALESCE(c.refund_amount, 0))
            AS total_refund_amount,
        AVG(COALESCE(c.refund_amount, 0))
            AS average_refund_amount
    FROM bookings b
    JOIN cancellations c
        ON b.booking_id = c.booking_id
    CROSS JOIN report_period rp
    WHERE b.booking_date BETWEEN rp.start_date AND rp.end_date
    GROUP BY b.hotel_id
),


-- SECTION 7: CUSTOMER REVIEW ANALYSIS

review_summary AS (
    SELECT
        b.hotel_id,
        COUNT(r.review_id) AS total_reviews,
        ROUND(AVG(r.rating), 2) AS average_rating,
        SUM(
            CASE WHEN r.rating >= 4 THEN 1 ELSE 0 END
        ) AS positive_reviews,
        SUM(
            CASE WHEN r.rating < 3 THEN 1 ELSE 0 END
        ) AS low_rating_reviews,
        MAX(r.rating) AS highest_rating,
        MIN(r.rating) AS lowest_rating
    FROM bookings b
    JOIN reviews r
        ON b.booking_id = r.booking_id
    CROSS JOIN report_period rp
    WHERE b.booking_date BETWEEN rp.start_date AND rp.end_date
    GROUP BY b.hotel_id
),


-- SECTION 8: ADDITIONAL SERVICE REVENUE

service_summary AS (
    SELECT
        b.hotel_id,
        COUNT(su.usage_id) AS service_transactions,
        SUM(COALESCE(su.quantity, 0)) AS services_quantity,
        SUM(COALESCE(su.total_cost, 0))
            AS additional_service_revenue,
        AVG(su.total_cost) AS average_service_transaction
    FROM bookings b
    JOIN service_usage su
        ON b.booking_id = su.booking_id
    CROSS JOIN report_period rp
    WHERE b.booking_date BETWEEN rp.start_date AND rp.end_date
      AND b.booking_status = 'Completed'
    GROUP BY b.hotel_id
),


-- SECTION 9: OPERATING EXPENSE ANALYSIS

expense_summary AS (
    SELECT
        e.hotel_id,
        SUM(e.expense_amount) AS total_operating_expenses,
        AVG(e.expense_amount) AS average_expense,
        COUNT(*) AS expense_records,
        SUM(
            CASE
                WHEN e.expense_category = 'Utilities'
                THEN e.expense_amount ELSE 0
            END
        ) AS utility_expenses,
        SUM(
            CASE
                WHEN e.expense_category = 'Maintenance'
                THEN e.expense_amount ELSE 0
            END
        ) AS maintenance_expenses,
        SUM(
            CASE
                WHEN e.expense_category = 'Staff'
                THEN e.expense_amount ELSE 0
            END
        ) AS staff_expenses,
        SUM(
            CASE
                WHEN e.expense_category = 'Marketing'
                THEN e.expense_amount ELSE 0
            END
        ) AS marketing_expenses
    FROM expenses e
    CROSS JOIN report_period rp
    WHERE e.expense_date BETWEEN rp.start_date AND rp.end_date
    GROUP BY e.hotel_id
),


-- SECTION 10: BOOKING SOURCE ANALYSIS

source_summary AS (
    SELECT
        b.hotel_id,
        COUNT(*) AS sourced_bookings,
        COUNT(DISTINCT bs.source_name) AS sources_used,
        SUM(
            CASE
                WHEN bs.source_category = 'Direct'
                THEN 1 ELSE 0
            END
        ) AS direct_bookings,
        SUM(
            CASE
                WHEN bs.source_category = 'OTA'
                THEN 1 ELSE 0
            END
        ) AS ota_bookings,
        AVG(bs.commission_percentage)
            AS average_source_commission_pct
    FROM bookings b
    JOIN booking_sources bs
        ON b.booking_source_id = bs.booking_source_id
    CROSS JOIN report_period rp
    WHERE b.booking_date BETWEEN rp.start_date AND rp.end_date
    GROUP BY b.hotel_id
),


-- SECTION 11: LENGTH OF STAY ANALYSIS
stay_summary AS (
    SELECT
        b.hotel_id,
        SUM(
            DATEDIFF(b.check_out_date, b.check_in_date)
        ) AS completed_room_nights_booked,
        AVG(
            DATEDIFF(b.check_out_date, b.check_in_date)
        ) AS average_length_of_stay,
        MAX(
            DATEDIFF(b.check_out_date, b.check_in_date)
        ) AS longest_stay,
        MIN(
            DATEDIFF(b.check_out_date, b.check_in_date)
        ) AS shortest_stay
    FROM bookings b
    CROSS JOIN report_period rp
    WHERE b.booking_status = 'Completed'
      AND b.booking_date BETWEEN rp.start_date AND rp.end_date
      AND b.check_out_date > b.check_in_date
    GROUP BY b.hotel_id
),

-- SECTION 12: BOOKING LEAD TIME
lead_time_summary AS (
    SELECT
        b.hotel_id,
        AVG(
            DATEDIFF(b.check_in_date, b.booking_date)
        ) AS average_lead_time_days,
        MAX(
            DATEDIFF(b.check_in_date, b.booking_date)
        ) AS maximum_lead_time_days,
        MIN(
            DATEDIFF(b.check_in_date, b.booking_date)
        ) AS minimum_lead_time_days
    FROM bookings b
    CROSS JOIN report_period rp
    WHERE b.booking_date BETWEEN rp.start_date AND rp.end_date
      AND b.check_in_date >= b.booking_date
    GROUP BY b.hotel_id
),

-- SECTION 13: ROOM TYPE PERFORMANCE
room_type_summary AS (
    SELECT
        b.hotel_id,
        COUNT(br.booking_room_id) AS room_assignments,
        COUNT(DISTINCT rt.room_type_id) AS room_types_booked,
        SUM(
            COALESCE(br.nightly_rate, 0)
            * DATEDIFF(b.check_out_date, b.check_in_date)
        ) AS estimated_room_charge,
        AVG(br.nightly_rate) AS average_nightly_rate
    FROM bookings b
    JOIN booking_rooms br
        ON b.booking_id = br.booking_id
    JOIN rooms r
        ON br.room_id = r.room_id
    JOIN room_types rt
        ON r.room_type_id = rt.room_type_id
    CROSS JOIN report_period rp
    WHERE b.booking_status = 'Completed'
      AND b.booking_date BETWEEN rp.start_date AND rp.end_date
    GROUP BY b.hotel_id
),

-- SECTION 14: MONTHLY REVENUE
monthly_revenue AS (
    SELECT
        b.hotel_id,
        DATE_FORMAT(b.booking_date, '%Y-%m') AS revenue_month,
        SUM(b.total_amount - b.discount_amount)
            AS monthly_net_revenue,
        COUNT(*) AS monthly_completed_bookings
    FROM bookings b
    CROSS JOIN report_period rp
    WHERE b.booking_status = 'Completed'
      AND b.booking_date BETWEEN rp.start_date AND rp.end_date
    GROUP BY
        b.hotel_id,
        DATE_FORMAT(b.booking_date, '%Y-%m')
),

-- SECTION 15: MONTH-OVER-MONTH REVENUE GROWTH
monthly_growth AS (
    SELECT
        hotel_id,
        revenue_month,
        monthly_net_revenue,
        monthly_completed_bookings,
        LAG(monthly_net_revenue) OVER (
            PARTITION BY hotel_id
            ORDER BY revenue_month
        ) AS previous_month_revenue,
        LAG(monthly_completed_bookings) OVER (
            PARTITION BY hotel_id
            ORDER BY revenue_month
        ) AS previous_month_bookings
    FROM monthly_revenue
),


-- SECTION 16: MOST RECENT MONTHLY PERFORMANCE

latest_month AS (
    SELECT
        mg.*,
        ROW_NUMBER() OVER (
            PARTITION BY hotel_id
            ORDER BY revenue_month DESC
        ) AS month_rank
    FROM monthly_growth mg
),

-- SECTION 17: CUSTOMER RETENTION
customer_repeat_summary AS (
    SELECT
        b.hotel_id,
        COUNT(*) AS completed_customer_bookings,
        COUNT(DISTINCT b.customer_id) AS distinct_completed_customers,
        SUM(
            CASE
                WHEN customer_booking_counts.booking_count > 1
                THEN 1 ELSE 0
            END
        ) AS repeat_customer_bookings
    FROM bookings b
    JOIN (
        SELECT
            customer_id,
            COUNT(*) AS booking_count
        FROM bookings
        WHERE booking_status = 'Completed'
        GROUP BY customer_id
    ) customer_booking_counts
        ON b.customer_id = customer_booking_counts.customer_id
    CROSS JOIN report_period rp
    WHERE b.booking_status = 'Completed'
      AND b.booking_date BETWEEN rp.start_date AND rp.end_date
    GROUP BY b.hotel_id
),


-- SECTION 18: DISCOUNT PERFORMANCE

discount_summary AS (
    SELECT
        b.hotel_id,
        COUNT(*) AS discounted_bookings,
        SUM(b.discount_amount) AS total_discount_given,
        AVG(
            CASE
                WHEN b.total_amount > 0
                THEN b.discount_amount / b.total_amount * 100
                ELSE 0
            END
        ) AS average_discount_pct
    FROM bookings b
    CROSS JOIN report_period rp
    WHERE b.booking_status = 'Completed'
      AND b.booking_date BETWEEN rp.start_date AND rp.end_date
    GROUP BY b.hotel_id
),


-- SECTION 19: COMBINE HOTEL PERFORMANCE METRICS

hotel_metrics AS (
    SELECT
        hb.hotel_id,
        hb.hotel_name,
        hb.city,
        hb.star_rating,
        hb.hotel_type,
        hb.total_rooms,

        COALESCE(bs.total_bookings, 0) AS total_bookings,
        COALESCE(bs.completed_bookings, 0) AS completed_bookings,
        COALESCE(bs.cancelled_bookings, 0) AS cancelled_bookings,
        COALESCE(bs.unique_customers, 0) AS unique_customers,
        COALESCE(bs.total_guests, 0) AS total_guests,

        COALESCE(cr.gross_booking_value, 0) AS gross_booking_value,
        COALESCE(cr.total_discounts, 0) AS total_discounts,
        COALESCE(cr.net_booking_revenue, 0) AS net_booking_revenue,
        COALESCE(cr.average_booking_value, 0) AS average_booking_value,

        COALESCE(ps.successful_collections, 0) AS successful_collections,
        COALESCE(ps.pending_payment_amount, 0) AS pending_payment_amount,
        COALESCE(ps.failed_payments, 0) AS failed_payments,

        COALESCE(cs.total_refund_amount, 0) AS total_refund_amount,

        COALESCE(rs.average_rating, 0) AS average_rating,
        COALESCE(rs.total_reviews, 0) AS total_reviews,
        COALESCE(rs.low_rating_reviews, 0) AS low_rating_reviews,

        COALESCE(ss.additional_service_revenue, 0)
            AS additional_service_revenue,

        COALESCE(es.total_operating_expenses, 0)
            AS total_operating_expenses,
        COALESCE(es.utility_expenses, 0) AS utility_expenses,
        COALESCE(es.maintenance_expenses, 0) AS maintenance_expenses,
        COALESCE(es.staff_expenses, 0) AS staff_expenses,
        COALESCE(es.marketing_expenses, 0) AS marketing_expenses,

        COALESCE(src.direct_bookings, 0) AS direct_bookings,
        COALESCE(src.ota_bookings, 0) AS ota_bookings,

        COALESCE(st.completed_room_nights_booked, 0)
            AS completed_room_nights_booked,
        COALESCE(st.average_length_of_stay, 0)
            AS average_length_of_stay,

        COALESCE(lt.average_lead_time_days, 0)
            AS average_lead_time_days,

        COALESCE(rt.estimated_room_charge, 0)
            AS estimated_room_charge,

        COALESCE(dc.average_discount_pct, 0)
            AS average_discount_pct,

        lm.revenue_month AS latest_revenue_month,
        lm.monthly_net_revenue AS latest_month_revenue,
        lm.previous_month_revenue,

        CASE
            WHEN lm.previous_month_revenue IS NULL THEN NULL
            WHEN lm.previous_month_revenue = 0 THEN NULL
            ELSE ROUND(
                (
                    lm.monthly_net_revenue
                    - lm.previous_month_revenue
                ) / lm.previous_month_revenue * 100,
                2
            )
        END AS latest_month_growth_pct

    FROM hotel_base hb

    LEFT JOIN booking_summary bs
        ON hb.hotel_id = bs.hotel_id

    LEFT JOIN completed_revenue cr
        ON hb.hotel_id = cr.hotel_id

    LEFT JOIN payment_summary ps
        ON hb.hotel_id = ps.hotel_id

    LEFT JOIN cancellation_summary cs
        ON hb.hotel_id = cs.hotel_id

    LEFT JOIN review_summary rs
        ON hb.hotel_id = rs.hotel_id

    LEFT JOIN service_summary ss
        ON hb.hotel_id = ss.hotel_id

    LEFT JOIN expense_summary es
        ON hb.hotel_id = es.hotel_id

    LEFT JOIN source_summary src
        ON hb.hotel_id = src.hotel_id

    LEFT JOIN stay_summary st
        ON hb.hotel_id = st.hotel_id

    LEFT JOIN lead_time_summary lt
        ON hb.hotel_id = lt.hotel_id

    LEFT JOIN room_type_summary rt
        ON hb.hotel_id = rt.hotel_id

    LEFT JOIN discount_summary dc
        ON hb.hotel_id = dc.hotel_id

    LEFT JOIN latest_month lm
        ON hb.hotel_id = lm.hotel_id
       AND lm.month_rank = 1
),

-- SECTION 20: CALCULATE BUSINESS KPIs
hotel_kpis AS (
    SELECT
        hm.*,

        ROUND(
            100.0 * cancelled_bookings
            / NULLIF(total_bookings, 0),
            2
        ) AS cancellation_rate_pct,

        ROUND(
            100.0 * completed_bookings
            / NULLIF(total_bookings, 0),
            2
        ) AS completion_rate_pct,

        ROUND(
            100.0 * successful_collections
            / NULLIF(net_booking_revenue, 0),
            2
        ) AS payment_collection_pct,

        ROUND(
            100.0 * completed_room_nights_booked
            / NULLIF(total_rooms * 151, 0),
            2
        ) AS estimated_occupancy_pct,

        ROUND(
            net_booking_revenue
            / NULLIF(completed_bookings, 0),
            2
        ) AS revenue_per_completed_booking,

        ROUND(
            net_booking_revenue
            / NULLIF(total_rooms * 151, 0),
            2
        ) AS revenue_per_available_room_night,

        ROUND(
            net_booking_revenue
            + additional_service_revenue
            - total_operating_expenses,
            2
        ) AS operating_surplus_proxy,

        ROUND(
            100.0 * (
                net_booking_revenue
                + additional_service_revenue
                - total_operating_expenses
            ) / NULLIF(
                net_booking_revenue + additional_service_revenue,
                0
            ),
            2
        ) AS operating_surplus_margin_pct

    FROM hotel_metrics hm
)


-- SECTION 21: FINAL HOTEL PERFORMANCE REPORT

SELECT
    hotel_id,
    hotel_name,
    city,
    star_rating,
    hotel_type,

    total_bookings,
    completed_bookings,
    cancelled_bookings,
    unique_customers,
    total_guests,

    gross_booking_value,
    total_discounts,
    net_booking_revenue,
    average_booking_value,

    successful_collections,
    pending_payment_amount,
    total_refund_amount,
    payment_collection_pct,

    cancellation_rate_pct,
    completion_rate_pct,

    completed_room_nights_booked,
    estimated_occupancy_pct,
    revenue_per_completed_booking,
    revenue_per_available_room_night,

    additional_service_revenue,
    total_operating_expenses,
    utility_expenses,
    maintenance_expenses,
    staff_expenses,
    marketing_expenses,

    operating_surplus_proxy,
    operating_surplus_margin_pct,

    average_rating,
    total_reviews,
    low_rating_reviews,

    direct_bookings,
    ota_bookings,
    average_discount_pct,
    average_length_of_stay,
    average_lead_time_days,

    latest_revenue_month,
    latest_month_revenue,
    previous_month_revenue,
    latest_month_growth_pct,

    CASE
        WHEN cancellation_rate_pct >= 25
            THEN 'High Cancellation Risk'
        WHEN payment_collection_pct < 80
            THEN 'Payment Collection Needs Review'
        WHEN average_rating > 0 AND average_rating < 3.5
            THEN 'Customer Satisfaction Needs Improvement'
        WHEN operating_surplus_proxy < 0
            THEN 'Operating Loss Risk'
        WHEN estimated_occupancy_pct < 10
            THEN 'Low Estimated Occupancy'
        ELSE 'Monitor and Optimize'
    END AS recommended_action

FROM hotel_kpis
ORDER BY
    operating_surplus_proxy DESC,
    net_booking_revenue DESC;
    
-- QUESTION 2 — Hotel Profitability & Cancellation Risk Analysis

WITH hotel_booking_metrics AS (
    SELECT
        h.hotel_id,
        h.hotel_name,
        h.city,
        h.star_rating,
        h.total_rooms,

        COUNT(b.booking_id) AS total_bookings,

        SUM(
            CASE
                WHEN b.booking_status = 'Completed' THEN 1
                ELSE 0
            END
        ) AS completed_bookings,

        SUM(
            CASE
                WHEN b.booking_status = 'Cancelled' THEN 1
                ELSE 0
            END
        ) AS cancelled_bookings,

        SUM(
            CASE
                WHEN b.booking_status = 'Completed'
                THEN COALESCE(b.total_amount, 0)
                ELSE 0
            END
        ) AS completed_booking_revenue

    FROM hotels h
    LEFT JOIN rooms r
        ON h.hotel_id = r.hotel_id
    LEFT JOIN booking_rooms br
        ON r.room_id = br.room_id
    LEFT JOIN bookings b
        ON br.booking_id = b.booking_id

    GROUP BY
        h.hotel_id,
        h.hotel_name,
        h.city,
        h.star_rating,
        h.total_rooms
),

hotel_expense_metrics AS (
    SELECT
        h.hotel_id,
        COALESCE(SUM(e.expense_amount), 0) AS total_expenses
    FROM hotels h
    LEFT JOIN expenses e
        ON h.hotel_id = e.hotel_id
    GROUP BY h.hotel_id
),

hotel_risk_analysis AS (
    SELECT
        hb.hotel_id,
        hb.hotel_name,
        hb.city,
        hb.star_rating,
        hb.total_rooms,
        hb.total_bookings,
        hb.completed_bookings,
        hb.cancelled_bookings,
        hb.completed_booking_revenue,
        he.total_expenses,

        ROUND(
            100.0 * hb.cancelled_bookings
            / NULLIF(hb.total_bookings, 0),
            2
        ) AS cancellation_rate_pct,

        ROUND(
            hb.completed_booking_revenue
            - he.total_expenses,
            2
        ) AS revenue_after_expenses_proxy

    FROM hotel_booking_metrics hb
    JOIN hotel_expense_metrics he
        ON hb.hotel_id = he.hotel_id
)

SELECT
    hotel_name,
    city,
    star_rating,
    total_bookings,
    completed_bookings,
    cancelled_bookings,
    completed_booking_revenue,
    total_expenses,
    cancellation_rate_pct,
    revenue_after_expenses_proxy,

    CASE
        WHEN cancellation_rate_pct >= 30
             AND revenue_after_expenses_proxy < 0
            THEN 'High Risk'

        WHEN cancellation_rate_pct >= 20
            THEN 'Cancellation Risk'

        WHEN revenue_after_expenses_proxy < 0
            THEN 'Expense Risk'

        ELSE 'Healthy Performance'
    END AS hotel_performance_status

FROM hotel_risk_analysis
ORDER BY
    cancellation_rate_pct DESC,
    revenue_after_expenses_proxy ASC;
    
-- QUESTION 3 — Hotel Revenue Trends & Month-over-Month Growth Analysis

WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(booking_date, '%Y-%m') AS booking_month,

        COUNT(*) AS total_bookings,

        SUM(
            CASE
                WHEN booking_status = 'Completed'
                THEN COALESCE(total_amount, 0)
                ELSE 0
            END
        ) AS completed_revenue,

        SUM(
            CASE
                WHEN booking_status = 'Completed' THEN 1
                ELSE 0
            END
        ) AS completed_bookings,

        SUM(
            CASE
                WHEN booking_status = 'Cancelled' THEN 1
                ELSE 0
            END
        ) AS cancelled_bookings

    FROM bookings
    WHERE booking_date >= '2025-01-01'
      AND booking_date < '2026-01-01'
    GROUP BY DATE_FORMAT(booking_date, '%Y-%m')
),

monthly_growth AS (
    SELECT
        booking_month,
        total_bookings,
        completed_revenue,
        completed_bookings,
        cancelled_bookings,

        LAG(completed_revenue) OVER (
            ORDER BY booking_month
        ) AS previous_month_revenue,

        LAG(total_bookings) OVER (
            ORDER BY booking_month
        ) AS previous_month_bookings

    FROM monthly_revenue
)

SELECT
    booking_month,
    total_bookings,
    completed_bookings,
    cancelled_bookings,
    ROUND(completed_revenue, 2) AS completed_revenue,
    ROUND(previous_month_revenue, 2) AS previous_month_revenue,

    ROUND(
        100.0 * (completed_revenue - previous_month_revenue)
        / NULLIF(previous_month_revenue, 0),
        2
    ) AS revenue_growth_pct,

    previous_month_bookings,

    CASE
        WHEN previous_month_revenue IS NULL
            THEN 'First Month'
        WHEN completed_revenue > previous_month_revenue
            THEN 'Revenue Increased'
        WHEN completed_revenue < previous_month_revenue
            THEN 'Revenue Decreased'
        ELSE 'No Change'
    END AS revenue_trend

FROM monthly_growth
ORDER BY booking_month;


-- QUESTION  4 — Booking Source & Marketing Channel Performance Analysis.

WITH source_metrics AS (
    SELECT
        bs.booking_source_id,
        bs.source_name,
        bs.source_category,
        bs.commission_percentage,

        COUNT(b.booking_id) AS total_bookings,

        SUM(
            CASE
                WHEN b.booking_status = 'Completed' THEN 1
                ELSE 0
            END
        ) AS completed_bookings,

        SUM(
            CASE
                WHEN b.booking_status = 'Cancelled' THEN 1
                ELSE 0
            END
        ) AS cancelled_bookings,

        SUM(
            CASE
                WHEN b.booking_status = 'Completed'
                THEN COALESCE(b.total_amount, 0)
                ELSE 0
            END
        ) AS completed_revenue,

        AVG(
            CASE
                WHEN b.booking_status = 'Completed'
                THEN b.total_amount
            END
        ) AS average_booking_value

    FROM booking_sources bs
    LEFT JOIN bookings b
        ON bs.booking_source_id = b.booking_source_id

    GROUP BY
        bs.booking_source_id,
        bs.source_name,
        bs.source_category,
        bs.commission_percentage
),

source_analysis AS (
    SELECT
        *,
        ROUND(
            completed_revenue
            * COALESCE(commission_percentage, 0) / 100,
            2
        ) AS estimated_commission,

        ROUND(
            100.0 * cancelled_bookings
            / NULLIF(total_bookings, 0),
            2
        ) AS cancellation_rate_pct,

        ROUND(
            100.0 * completed_bookings
            / NULLIF(total_bookings, 0),
            2
        ) AS completion_rate_pct

    FROM source_metrics
)

SELECT
    source_name,
    source_category,
    commission_percentage,
    total_bookings,
    completed_bookings,
    cancelled_bookings,
    ROUND(completed_revenue, 2) AS completed_revenue,
    ROUND(average_booking_value, 2) AS average_booking_value,
    estimated_commission,
    cancellation_rate_pct,
    completion_rate_pct,

    DENSE_RANK() OVER (
        ORDER BY completed_revenue DESC
    ) AS revenue_rank,

    CASE
        WHEN cancellation_rate_pct >= 30
            THEN 'High Cancellation Risk'
        WHEN completed_revenue >= 50000
            THEN 'High Revenue Source'
        ELSE 'Needs Improvement'
    END AS source_performance

FROM source_analysis
ORDER BY completed_revenue DESC;

-- QUESTION 5 — Customer Lifetime Value (CLV) & Repeat Booking Analysis.

WITH customer_metrics AS (
    SELECT
        c.customer_id,
        CONCAT(
            c.first_name,
            ' ',
            COALESCE(c.last_name, '')
        ) AS customer_full_name,
        c.city,
        c.country,
        c.customer_type AS registered_customer_type,

        COUNT(b.booking_id) AS total_bookings,

        SUM(
            CASE
                WHEN b.booking_status = 'Completed' THEN 1
                ELSE 0
            END
        ) AS completed_bookings,

        SUM(
            CASE
                WHEN b.booking_status = 'Cancelled' THEN 1
                ELSE 0
            END
        ) AS cancelled_bookings,

        SUM(
            CASE
                WHEN b.booking_status = 'Completed'
                THEN COALESCE(b.total_amount, 0)
                ELSE 0
            END
        ) AS customer_lifetime_revenue,

        MIN(
            CASE
                WHEN b.booking_status = 'Completed'
                THEN b.booking_date
            END
        ) AS first_completed_booking,

        MAX(
            CASE
                WHEN b.booking_status = 'Completed'
                THEN b.booking_date
            END
        ) AS latest_completed_booking

    FROM customers c
    LEFT JOIN bookings b
        ON c.customer_id = b.customer_id

    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name,
        c.city,
        c.country,
        c.customer_type
),

customer_analysis AS (
    SELECT
        *,
        ROUND(
            customer_lifetime_revenue
            / NULLIF(completed_bookings, 0),
            2
        ) AS average_booking_value,

        DATEDIFF(
            latest_completed_booking,
            first_completed_booking
        ) AS customer_booking_span_days

    FROM customer_metrics
)

SELECT
    customer_id,
    customer_full_name,
    city,
    country,
    registered_customer_type,
    total_bookings,
    completed_bookings,
    cancelled_bookings,
    ROUND(customer_lifetime_revenue, 2)
        AS customer_lifetime_revenue,
    average_booking_value,
    first_completed_booking,
    latest_completed_booking,
    customer_booking_span_days,

    DENSE_RANK() OVER (
        ORDER BY customer_lifetime_revenue DESC
    ) AS customer_revenue_rank,

    CASE
        WHEN customer_lifetime_revenue >= 30000
            THEN 'High Value Customer'
        WHEN customer_lifetime_revenue >= 15000
            THEN 'Medium Value Customer'
        ELSE 'Low Value Customer'
    END AS customer_value_segment,

    CASE
        WHEN completed_bookings >= 2
            THEN 'Repeat Customer'
        WHEN completed_bookings = 1
            THEN 'One-Time Customer'
        ELSE 'No Completed Booking'
    END AS booking_behavior

FROM customer_analysis
ORDER BY
    customer_lifetime_revenue DESC,
    completed_bookings DESC;
    
-- QUESTION 6 — Room Type Revenue & Demand Analysis

WITH room_type_metrics AS (
    SELECT
        rt.room_type_id,
        rt.room_type_name,
        rt.base_price,
        rt.max_guests,

        COUNT(DISTINCT r.room_id) AS total_rooms,

        COUNT(DISTINCT b.booking_id) AS total_bookings,

        COUNT(
            DISTINCT CASE
                WHEN b.booking_status = 'Completed'
                THEN b.booking_id
            END
        ) AS completed_bookings,

        COUNT(
            DISTINCT CASE
                WHEN b.booking_status = 'Cancelled'
                THEN b.booking_id
            END
        ) AS cancelled_bookings,

        SUM(
            CASE
                WHEN b.booking_status = 'Completed'
                THEN COALESCE(b.total_amount, 0)
                ELSE 0
            END
        ) AS completed_revenue

    FROM room_types rt
    LEFT JOIN rooms r
        ON rt.room_type_id = r.room_type_id
    LEFT JOIN booking_rooms br
        ON r.room_id = br.room_id
    LEFT JOIN bookings b
        ON br.booking_id = b.booking_id

    GROUP BY
        rt.room_type_id,
        rt.room_type_name,
        rt.base_price,
        rt.max_guests
),

room_type_analysis AS (
    SELECT
        *,
        ROUND(
            completed_revenue
            / NULLIF(completed_bookings, 0),
            2
        ) AS average_revenue_per_booking,

        ROUND(
            100.0 * completed_bookings
            / NULLIF(total_bookings, 0),
            2
        ) AS completion_rate_pct

    FROM room_type_metrics
)

SELECT
    room_type_name,
    base_price,
    max_guests,
    total_rooms,
    total_bookings,
    completed_bookings,
    cancelled_bookings,
    ROUND(completed_revenue, 2) AS completed_revenue,
    average_revenue_per_booking,
    completion_rate_pct,

    DENSE_RANK() OVER (
        ORDER BY completed_revenue DESC
    ) AS revenue_rank,

    CASE
        WHEN completed_revenue >= 50000
            THEN 'High Revenue Room Type'
        WHEN completed_revenue >= 20000
            THEN 'Medium Revenue Room Type'
        ELSE 'Low Revenue Room Type'
    END AS revenue_category

FROM room_type_analysis
ORDER BY completed_revenue DESC;

-- QUESTION 7 — Hotel Cancellation & Refund Risk Analysis.

WITH cancellation_summary AS (
    SELECT
        b.booking_id,
        b.booking_status,
        b.total_amount,
        b.booking_source_id,
        h.hotel_id,
        h.hotel_name,
        c.cancellation_reason,
        COALESCE(c.refund_amount, 0) AS refund_amount
    FROM bookings b
    JOIN booking_rooms br
        ON b.booking_id = br.booking_id
    JOIN rooms r
        ON br.room_id = r.room_id
    JOIN hotels h
        ON r.hotel_id = h.hotel_id
    LEFT JOIN cancellations c
        ON b.booking_id = c.booking_id
),
hotel_risk AS (
    SELECT
        hotel_id,
        hotel_name,
        COUNT(DISTINCT booking_id) AS total_bookings,
        COUNT(DISTINCT CASE
            WHEN booking_status = 'Cancelled'
            THEN booking_id
        END) AS cancelled_bookings,
        SUM(DISTINCT 0) AS placeholder
    FROM cancellation_summary
    GROUP BY hotel_id, hotel_name
),
refund_summary AS (
    SELECT
        hotel_id,
        hotel_name,
        SUM(CASE
            WHEN booking_status = 'Cancelled'
            THEN refund_amount
            ELSE 0
        END) AS total_refund_amount
    FROM (
        SELECT DISTINCT
            booking_id,
            hotel_id,
            hotel_name,
            booking_status,
            refund_amount
        FROM cancellation_summary
    ) x
    GROUP BY hotel_id, hotel_name
),
reason_summary AS (
    SELECT
        hotel_id,
        hotel_name,
        COUNT(*) AS cancellation_records,
        GROUP_CONCAT(
            DISTINCT cancellation_reason
            ORDER BY cancellation_reason
            SEPARATOR ', '
        ) AS cancellation_reasons
    FROM (
        SELECT DISTINCT
            booking_id,
            hotel_id,
            hotel_name,
            cancellation_reason
        FROM cancellation_summary
        WHERE cancellation_reason IS NOT NULL
    ) y
    GROUP BY hotel_id, hotel_name
)
SELECT
    hr.hotel_name,
    hr.total_bookings,
    hr.cancelled_bookings,
    ROUND(
        hr.cancelled_bookings * 100.0 /
        NULLIF(hr.total_bookings, 0), 2
    ) AS cancellation_rate_pct,
    rs.total_refund_amount,
    COALESCE(re.cancellation_records, 0) AS cancellation_records,
    COALESCE(re.cancellation_reasons, 'No recorded reason')
        AS cancellation_reasons,
    CASE
        WHEN hr.cancelled_bookings * 100.0 /
             NULLIF(hr.total_bookings, 0) >= 30
            THEN 'High Cancellation Risk'
        WHEN hr.cancelled_bookings * 100.0 /
             NULLIF(hr.total_bookings, 0) >= 15
            THEN 'Medium Cancellation Risk'
        ELSE 'Low Cancellation Risk'
    END AS cancellation_risk
FROM hotel_risk hr
JOIN refund_summary rs
    ON hr.hotel_id = rs.hotel_id
LEFT JOIN reason_summary re
    ON hr.hotel_id = re.hotel_id
ORDER BY
    cancellation_rate_pct DESC,
    total_refund_amount DESC;

-- QUESTION 8 — Hotel Customer Review & Satisfaction Analysis

WITH hotel_reviews AS (
    SELECT
        h.hotel_id,
        h.hotel_name,
        rv.review_id,
        rv.rating,
        rv.review_text
    FROM reviews rv
    JOIN bookings b
        ON rv.booking_id = b.booking_id
    JOIN booking_rooms br
        ON b.booking_id = br.booking_id
    JOIN rooms r
        ON br.room_id = r.room_id
    JOIN hotels h
        ON r.hotel_id = h.hotel_id
),
review_summary AS (
    SELECT
        hotel_id,
        hotel_name,
        COUNT(DISTINCT review_id) AS total_reviews,
        ROUND(AVG(rating), 2) AS average_rating,
        SUM(CASE WHEN rating >= 4 THEN 1 ELSE 0 END)
            AS positive_reviews,
        SUM(CASE WHEN rating < 3 THEN 1 ELSE 0 END)
            AS negative_reviews,
        SUM(CASE WHEN rating >= 3 AND rating < 4
            THEN 1 ELSE 0 END) AS neutral_reviews
    FROM hotel_reviews
    GROUP BY hotel_id, hotel_name
)
SELECT
    hotel_name,
    total_reviews,
    average_rating,
    positive_reviews,
    neutral_reviews,
    negative_reviews,
    ROUND(
        positive_reviews * 100.0 /
        NULLIF(total_reviews, 0), 2
    ) AS positive_review_pct,
    CASE
        WHEN average_rating >= 4.5
            THEN 'Excellent Satisfaction'
        WHEN average_rating >= 4.0
            THEN 'Good Satisfaction'
        WHEN average_rating >= 3.0
            THEN 'Average Satisfaction'
        ELSE 'Needs Improvement'
    END AS satisfaction_level
FROM review_summary
ORDER BY average_rating DESC, total_reviews DESC;

-- QUESTION 9 — Hotel Operating Expenses & Cost Efficiency Analysis.

WITH revenue_summary AS (
    SELECT
        h.hotel_id,
        h.hotel_name,
        SUM(
            CASE
                WHEN b.booking_status = 'Completed'
                THEN b.total_amount
                ELSE 0
            END
        ) AS completed_revenue,
        COUNT(
            DISTINCT CASE
                WHEN b.booking_status = 'Completed'
                THEN b.booking_id
            END
        ) AS completed_bookings
    FROM hotels h
    LEFT JOIN rooms r
        ON h.hotel_id = r.hotel_id
    LEFT JOIN booking_rooms br
        ON r.room_id = br.room_id
    LEFT JOIN bookings b
        ON br.booking_id = b.booking_id
    GROUP BY h.hotel_id, h.hotel_name
),
expense_summary AS (
    SELECT
        hotel_id,
        SUM(expense_amount) AS total_expenses,
        COUNT(*) AS expense_records
    FROM expenses
    GROUP BY hotel_id
)
SELECT
    h.hotel_name,
    COALESCE(rs.completed_bookings, 0) AS completed_bookings,
    COALESCE(rs.completed_revenue, 0) AS completed_revenue,
    COALESCE(es.total_expenses, 0) AS total_operating_expenses,
    COALESCE(es.expense_records, 0) AS expense_records,
    COALESCE(rs.completed_revenue, 0)
        - COALESCE(es.total_expenses, 0)
        AS revenue_after_expenses_proxy,
    ROUND(
        COALESCE(es.total_expenses, 0) * 100.0 /
        NULLIF(rs.completed_revenue, 0),
        2
    ) AS expense_to_revenue_pct,
    CASE
        WHEN COALESCE(rs.completed_revenue, 0) = 0
            THEN 'No Revenue'
        WHEN COALESCE(es.total_expenses, 0) * 100.0 /
             NULLIF(rs.completed_revenue, 0) <= 40
            THEN 'High Cost Efficiency'
        WHEN COALESCE(es.total_expenses, 0) * 100.0 /
             NULLIF(rs.completed_revenue, 0) <= 70
            THEN 'Moderate Cost Efficiency'
        ELSE 'Low Cost Efficiency'
    END AS cost_efficiency_status
FROM hotels h
LEFT JOIN revenue_summary rs
    ON h.hotel_id = rs.hotel_id
LEFT JOIN expense_summary es
    ON h.hotel_id = es.hotel_id
ORDER BY expense_to_revenue_pct DESC;

-- QUESTION 10 — Hotel Booking Lead Time & Customer Booking Behavior Analysis.

WITH booking_lead_time AS (
    SELECT
        booking_id,
        hotel_id,
        booking_date,
        check_in_date,
        booking_status,
        total_amount,
        DATEDIFF(check_in_date, booking_date) AS lead_time_days,
        CASE
            WHEN DATEDIFF(check_in_date, booking_date) <= 3
                THEN 'Last-Minute Booking'
            WHEN DATEDIFF(check_in_date, booking_date) <= 14
                THEN 'Short-Advance Booking'
            WHEN DATEDIFF(check_in_date, booking_date) <= 30
                THEN 'Medium-Advance Booking'
            ELSE 'Early Booking'
        END AS booking_group
    FROM bookings
),
lead_time_summary AS (
    SELECT
        booking_group,
        COUNT(*) AS total_bookings,
        SUM(CASE
            WHEN booking_status = 'Completed' THEN 1
            ELSE 0
        END) AS completed_bookings,
        SUM(CASE
            WHEN booking_status = 'Cancelled' THEN 1
            ELSE 0
        END) AS cancelled_bookings,
        ROUND(AVG(lead_time_days), 2) AS average_lead_time_days,
        ROUND(AVG(total_amount), 2) AS average_booking_value,
        SUM(CASE
            WHEN booking_status = 'Completed' THEN total_amount
            ELSE 0
        END) AS completed_revenue
    FROM booking_lead_time
    GROUP BY booking_group
)
SELECT
    booking_group,
    total_bookings,
    completed_bookings,
    cancelled_bookings,
    average_lead_time_days,
    average_booking_value,
    completed_revenue,
    ROUND(
        cancelled_bookings * 100.0 /
        NULLIF(total_bookings, 0), 2
    ) AS cancellation_rate_pct,
    CASE
        WHEN cancelled_bookings * 100.0 /
             NULLIF(total_bookings, 0) >= 30
            THEN 'High Cancellation Risk'
        WHEN cancelled_bookings * 100.0 /
             NULLIF(total_bookings, 0) >= 15
            THEN 'Medium Cancellation Risk'
        ELSE 'Low Cancellation Risk'
    END AS cancellation_risk
FROM lead_time_summary
ORDER BY average_lead_time_days;

-- QUESTION 11 — Hotel Room Occupancy & Availability Analysis

SELECT
    h.hotel_name,
    COUNT(DISTINCT r.room_id) AS total_rooms,
    COUNT(DISTINCT CASE
        WHEN b.booking_status = 'Completed'
        THEN r.room_id
    END) AS rooms_with_completed_bookings,
    COUNT(DISTINCT CASE
        WHEN b.booking_status = 'Cancelled'
        THEN r.room_id
    END) AS rooms_with_cancelled_bookings,
    ROUND(
        COUNT(DISTINCT CASE
            WHEN b.booking_status = 'Completed'
            THEN r.room_id
        END) * 100.0 /
        NULLIF(COUNT(DISTINCT r.room_id), 0),
        2
    ) AS room_utilization_pct,
    CASE
        WHEN COUNT(DISTINCT CASE
            WHEN b.booking_status = 'Completed'
            THEN r.room_id
        END) * 100.0 /
        NULLIF(COUNT(DISTINCT r.room_id), 0) >= 80
            THEN 'High Utilization'
        WHEN COUNT(DISTINCT CASE
            WHEN b.booking_status = 'Completed'
            THEN r.room_id
        END) * 100.0 /
        NULLIF(COUNT(DISTINCT r.room_id), 0) >= 50
            THEN 'Moderate Utilization'
        ELSE 'Low Utilization'
    END AS utilization_status
FROM hotels h
LEFT JOIN rooms r
    ON h.hotel_id = r.hotel_id
LEFT JOIN booking_rooms br
    ON r.room_id = br.room_id
LEFT JOIN bookings b
    ON br.booking_id = b.booking_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY room_utilization_pct DESC;

-- QUESTION 12 — Payment Collection & Outstanding Revenue Analysis.

WITH payment_summary AS (
    SELECT
        booking_id,
        COUNT(*) AS payment_records,
        SUM(CASE
            WHEN payment_status = 'Paid'
            THEN COALESCE(payment_amount, 0)
            ELSE 0
        END) AS collected_amount,
        SUM(CASE
            WHEN payment_status = 'Pending'
            THEN COALESCE(payment_amount, 0)
            ELSE 0
        END) AS pending_amount,
        SUM(CASE
            WHEN payment_status = 'Refunded'
            THEN COALESCE(payment_amount, 0)
            ELSE 0
        END) AS refunded_amount
    FROM payments
    GROUP BY booking_id
)
SELECT
    h.hotel_name,
    COUNT(DISTINCT b.booking_id) AS total_bookings,
    SUM(COALESCE(ps.payment_records, 0)) AS payment_records,
    SUM(COALESCE(ps.collected_amount, 0)) AS total_collected,
    SUM(COALESCE(ps.pending_amount, 0)) AS total_pending,
    SUM(COALESCE(ps.refunded_amount, 0)) AS total_refunded,
    SUM(COALESCE(b.total_amount, 0)) AS total_booking_value,
    SUM(COALESCE(b.total_amount, 0))
        - SUM(COALESCE(ps.collected_amount, 0))
        AS booking_value_not_marked_paid,
    ROUND(
        SUM(COALESCE(ps.collected_amount, 0)) * 100.0 /
        NULLIF(SUM(COALESCE(b.total_amount, 0)), 0),
        2
    ) AS collection_rate_pct,
    CASE
        WHEN SUM(COALESCE(b.total_amount, 0)) = 0
            THEN 'No Booking Value'
        WHEN SUM(COALESCE(ps.collected_amount, 0)) * 100.0 /
             NULLIF(SUM(COALESCE(b.total_amount, 0)), 0) >= 90
            THEN 'High Collection'
        WHEN SUM(COALESCE(ps.collected_amount, 0)) * 100.0 /
             NULLIF(SUM(COALESCE(b.total_amount, 0)), 0) >= 60
            THEN 'Moderate Collection'
        ELSE 'Low Collection'
    END AS collection_status
FROM hotels h
LEFT JOIN bookings b
    ON h.hotel_id = b.hotel_id
LEFT JOIN payment_summary ps
    ON b.booking_id = ps.booking_id
GROUP BY h.hotel_id, h.hotel_name
ORDER BY collection_rate_pct DESC;

-- QUESTION 13 — Hotel Additional Services & Customer Spending Analysis.


WITH service_summary AS (
    SELECT
        s.service_id,
        s.service_name,
        s.service_category,
        s.service_price,
        COUNT(su.usage_id) AS total_usage_records,
        SUM(COALESCE(su.quantity, 0)) AS total_quantity,
        SUM(COALESCE(su.total_cost, 0)) AS total_service_revenue,
        COUNT(DISTINCT su.booking_id) AS unique_bookings
    FROM services s
    LEFT JOIN service_usage su
        ON s.service_id = su.service_id
    GROUP BY
        s.service_id,
        s.service_name,
        s.service_category,
        s.service_price
),
ranked_services AS (
    SELECT
        *,
        DENSE_RANK() OVER (
            ORDER BY total_service_revenue DESC
        ) AS revenue_rank
    FROM service_summary
)
SELECT
    service_name,
    service_category,
    service_price,
    total_usage_records,
    total_quantity,
    unique_bookings,
    total_service_revenue,
    ROUND(
        total_service_revenue /
        NULLIF(total_usage_records, 0),
        2
    ) AS avg_revenue_per_usage,
    revenue_rank,
    CASE
        WHEN total_service_revenue >= 10000
            THEN 'High Revenue Service'
        WHEN total_service_revenue >= 5000
            THEN 'Medium Revenue Service'
        ELSE 'Low Revenue Service'
    END AS service_performance
FROM ranked_services
ORDER BY total_service_revenue DESC;

-- QUESTION 14 — Hotel-wise Performance Ranking & KPI Comparison.

WITH booking_kpis AS (
    SELECT
        hotel_id,
        COUNT(*) AS total_bookings,
        SUM(CASE
            WHEN booking_status = 'Completed' THEN 1
            ELSE 0
        END) AS completed_bookings,
        SUM(CASE
            WHEN booking_status = 'Cancelled' THEN 1
            ELSE 0
        END) AS cancelled_bookings,
        SUM(CASE
            WHEN booking_status = 'Completed'
            THEN total_amount
            ELSE 0
        END) AS completed_revenue
    FROM bookings
    GROUP BY hotel_id
),
review_kpis AS (
    SELECT
        h.hotel_id,
        ROUND(AVG(rv.rating), 2) AS average_rating
    FROM hotels h
    LEFT JOIN rooms r
        ON h.hotel_id = r.hotel_id
    LEFT JOIN booking_rooms br
        ON r.room_id = br.room_id
    LEFT JOIN reviews rv
        ON br.booking_id = rv.booking_id
    GROUP BY h.hotel_id
),
expense_kpis AS (
    SELECT
        hotel_id,
        SUM(expense_amount) AS total_expenses
    FROM expenses
    GROUP BY hotel_id
),
hotel_performance AS (
    SELECT
        h.hotel_id,
        h.hotel_name,
        COALESCE(bk.total_bookings, 0) AS total_bookings,
        COALESCE(bk.completed_bookings, 0) AS completed_bookings,
        COALESCE(bk.cancelled_bookings, 0) AS cancelled_bookings,
        COALESCE(bk.completed_revenue, 0) AS completed_revenue,
        COALESCE(rk.average_rating, 0) AS average_rating,
        COALESCE(ek.total_expenses, 0) AS total_expenses,
        ROUND(
            COALESCE(bk.cancelled_bookings, 0) * 100.0 /
            NULLIF(bk.total_bookings, 0), 2
        ) AS cancellation_rate_pct,
        COALESCE(bk.completed_revenue, 0)
            - COALESCE(ek.total_expenses, 0)
            AS revenue_after_expenses_proxy
    FROM hotels h
    LEFT JOIN booking_kpis bk
        ON h.hotel_id = bk.hotel_id
    LEFT JOIN review_kpis rk
        ON h.hotel_id = rk.hotel_id
    LEFT JOIN expense_kpis ek
        ON h.hotel_id = ek.hotel_id
)
SELECT
    hotel_name,
    total_bookings,
    completed_bookings,
    cancelled_bookings,
    completed_revenue,
    cancellation_rate_pct,
    average_rating,
    total_expenses,
    revenue_after_expenses_proxy,
    DENSE_RANK() OVER (
        ORDER BY completed_revenue DESC
    ) AS revenue_rank,
    CASE
        WHEN cancellation_rate_pct >= 30
            THEN 'High Cancellation Risk'
        WHEN average_rating >= 4.5
             AND cancellation_rate_pct < 15
            THEN 'Strong Performance'
        WHEN revenue_after_expenses_proxy < 0
            THEN 'Cost Improvement Needed'
        ELSE 'Moderate Performance'
    END AS performance_category
FROM hotel_performance
ORDER BY revenue_rank;


-- QUESTION 15 — Final Hotel Business Performance Summary


USE hotel_analytics;

WITH booking_summary AS (
    SELECT
        COUNT(*) AS total_bookings,
        SUM(CASE
            WHEN booking_status = 'Completed' THEN 1
            ELSE 0
        END) AS completed_bookings,
        SUM(CASE
            WHEN booking_status = 'Cancelled' THEN 1
            ELSE 0
        END) AS cancelled_bookings,
        SUM(CASE
            WHEN booking_status = 'Completed'
            THEN total_amount
            ELSE 0
        END) AS completed_revenue
    FROM bookings
),
payment_summary AS (
    SELECT
        SUM(CASE
            WHEN payment_status = 'Paid'
            THEN payment_amount
            ELSE 0
        END) AS total_collected
    FROM payments
),
review_summary AS (
    SELECT
        ROUND(AVG(rating), 2) AS average_customer_rating,
        COUNT(*) AS total_reviews
    FROM reviews
),
expense_summary AS (
    SELECT
        SUM(expense_amount) AS total_operating_expenses
    FROM expenses
),
service_summary AS (
    SELECT
        SUM(total_cost) AS additional_service_revenue
    FROM service_usage
)
SELECT
    (SELECT COUNT(*) FROM hotels) AS total_hotels,
    bs.total_bookings,
    bs.completed_bookings,
    bs.cancelled_bookings,
    bs.completed_revenue,
    ROUND(
        bs.cancelled_bookings * 100.0 /
        NULLIF(bs.total_bookings, 0), 2
    ) AS cancellation_rate_pct,
    ps.total_collected,
    rs.average_customer_rating,
    rs.total_reviews,
    es.total_operating_expenses,
    ss.additional_service_revenue,
    bs.completed_revenue
        + COALESCE(ss.additional_service_revenue, 0)
        - COALESCE(es.total_operating_expenses, 0)
        AS revenue_after_expenses_proxy
FROM booking_summary bs
CROSS JOIN payment_summary ps
CROSS JOIN review_summary rs
CROSS JOIN expense_summary es
CROSS JOIN service_summary ss;
