-- ===========================================
-- LET'S RIDE DATABASE
-- ===========================================

CREATE DATABASE IF NOT EXISTS lets_ride;
USE lets_ride;

-- ===========================================
-- USERS
-- ===========================================

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20) UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('customer','owner') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ===========================================
-- VEHICLES
-- ===========================================

CREATE TABLE vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,

    owner_id INT NOT NULL,

    make VARCHAR(50),
    model VARCHAR(50),
    year YEAR,

    category VARCHAR(50),

    color VARCHAR(50),

    plate_number VARCHAR(30) UNIQUE,

    registration_number VARCHAR(50),

    transmission ENUM('Manual','Automatic'),

    fuel_type ENUM('Petrol','Diesel','Electric','Hybrid'),

    seats INT,

    odometer INT,

    mileage INT,

    pickup_location VARCHAR(255),

    air_conditioning BOOLEAN DEFAULT FALSE,
    gps BOOLEAN DEFAULT FALSE,
    bluetooth BOOLEAN DEFAULT FALSE,
    rear_camera BOOLEAN DEFAULT FALSE,
    usb_charger BOOLEAN DEFAULT FALSE,
    spare_tire BOOLEAN DEFAULT FALSE,
    sunroof BOOLEAN DEFAULT FALSE,
    child_seat BOOLEAN DEFAULT FALSE,

    description TEXT,

    photo VARCHAR(255),

    daily_rate DECIMAL(10,2),

    security_deposit DECIMAL(10,2),

    availability ENUM('Available','Booked','Unavailable')
    DEFAULT 'Available',

    available_from DATE,

    available_to DATE,

    cancellation_policy ENUM(
        'Flexible',
        'Moderate',
        'Strict'
    ) DEFAULT 'Moderate',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(owner_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE
);

-- ===========================================
-- BOOKINGS
-- ===========================================

CREATE TABLE bookings (

    booking_id INT AUTO_INCREMENT PRIMARY KEY,

    vehicle_id INT NOT NULL,

    customer_id INT NOT NULL,

    pickup_date DATE,

    return_date DATE,

    total_days INT,

    total_amount DECIMAL(10,2),

    status ENUM(
        'Pending',
        'Approved',
        'Rejected',
        'Cancelled',
        'Completed'
    ) DEFAULT 'Pending',

    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(vehicle_id)
    REFERENCES vehicles(vehicle_id)
    ON DELETE CASCADE,

    FOREIGN KEY(customer_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE

);

-- ===========================================
-- PAYMENTS
-- ===========================================

CREATE TABLE payments (

    payment_id INT AUTO_INCREMENT PRIMARY KEY,

    booking_id INT NOT NULL,

    amount DECIMAL(10,2),

    payment_method ENUM(
        'Cash',
        'eSewa',
        'Khalti',
        'Card'
    ),

    payment_status ENUM(
        'Pending',
        'Paid',
        'Refunded'
    ) DEFAULT 'Pending',

    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(booking_id)
    REFERENCES bookings(booking_id)
    ON DELETE CASCADE

);

-- ===========================================
-- REVIEWS
-- ===========================================

CREATE TABLE reviews (

    review_id INT AUTO_INCREMENT PRIMARY KEY,

    booking_id INT,

    customer_id INT,

    vehicle_id INT,

    rating INT CHECK(rating BETWEEN 1 AND 5),

    review TEXT,

    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(booking_id)
    REFERENCES bookings(booking_id)
    ON DELETE CASCADE,

    FOREIGN KEY(customer_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE,

    FOREIGN KEY(vehicle_id)
    REFERENCES vehicles(vehicle_id)
    ON DELETE CASCADE

);

-- ===========================================
-- EARNINGS
-- ===========================================

CREATE TABLE earnings (

    earning_id INT AUTO_INCREMENT PRIMARY KEY,

    owner_id INT,

    booking_id INT,

    amount DECIMAL(10,2),

    earned_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY(owner_id)
    REFERENCES users(user_id)
    ON DELETE CASCADE,

    FOREIGN KEY(booking_id)
    REFERENCES bookings(booking_id)
    ON DELETE CASCADE

);

-- ===========================================
-- SAMPLE USERS
-- ===========================================

INSERT INTO users
(full_name,email,phone,password,role)
VALUES
('Admin Owner','owner@gmail.com','9800000001','owner123','owner'),

('Ram Sharma','ram@gmail.com','9800000002','ram123','customer'),

('Sita Thapa','sita@gmail.com','9800000003','sita123','customer');

-- ===========================================
-- SAMPLE VEHICLE
-- ===========================================

INSERT INTO vehicles
(
owner_id,
make,
model,
year,
category,
color,
plate_number,
registration_number,
transmission,
fuel_type,
seats,
odometer,
mileage,
pickup_location,
air_conditioning,
gps,
bluetooth,
rear_camera,
usb_charger,
spare_tire,
sunroof,
child_seat,
description,
photo,
daily_rate,
security_deposit,
availability,
available_from,
available_to,
cancellation_policy
)

VALUES
(
1,
'Honda',
'City',
2024,
'Sedan',
'White',
'BA-2-PA-1234',
'REG123456',
'Automatic',
'Petrol',
5,
12000,
18,
'Kathmandu',
1,
1,
1,
1,
1,
1,
0,
0,
'Well maintained vehicle',
'honda.jpg',
3500,
5000,
'Available',
'2026-07-01',
'2026-12-31',
'Flexible'
);

-- ===========================================
-- SAMPLE BOOKING
-- ===========================================

INSERT INTO bookings
(
vehicle_id,
customer_id,
pickup_date,
return_date,
total_days,
total_amount,
status
)

VALUES
(
1,
2,
'2026-07-10',
'2026-07-12',
2,
7000,
'Approved'
);

-- ===========================================
-- SAMPLE PAYMENT
-- ===========================================

INSERT INTO payments
(
booking_id,
amount,
payment_method,
payment_status
)

VALUES
(
1,
7000,
'eSewa',
'Paid'
);

-- ===========================================
-- SAMPLE REVIEW
-- ===========================================

INSERT INTO reviews
(
booking_id,
customer_id,
vehicle_id,
rating,
review
)

VALUES
(
1,
2,
1,
5,
'Excellent vehicle and smooth ride.'
);

-- ===========================================
-- SAMPLE EARNING
-- ===========================================

INSERT INTO earnings
(
owner_id,
booking_id,
amount
)

VALUES
(
1,
1,
7000
);
