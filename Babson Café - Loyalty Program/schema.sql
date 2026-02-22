PRAGMA foreign_keys = ON;

-- ====================================
-- Customers table (loyalty members)
-- ====================================
CREATE TABLE Customers (
    customer_id      INTEGER PRIMARY KEY,
    first_name       TEXT        NOT NULL,
    last_name        TEXT        NOT NULL,
    email            TEXT        NOT NULL UNIQUE,
    phone            TEXT,
    loyalty_points   INTEGER     DEFAULT 0,
    join_date        TEXT        -- stored as 'YYYY-MM-DD'
);

-- ====================================
-- Employees table (staff)
-- ====================================
CREATE TABLE Employees (
    employee_id   INTEGER PRIMARY KEY,
    first_name    TEXT        NOT NULL,
    last_name     TEXT        NOT NULL,
    role          TEXT        NOT NULL,      -- e.g. 'Barista', 'Manager'
    hire_date     TEXT        NOT NULL,      -- 'YYYY-MM-DD'
    hourly_wage   REAL        NOT NULL       -- e.g. 27.16
);

-- ====================================
-- Menu_Items table (products sold)
-- ====================================
CREATE TABLE Menu_Items (
    item_id     INTEGER PRIMARY KEY,
    item_name   TEXT        NOT NULL,
    category    TEXT        NOT NULL,        -- 'Coffee', 'Bakery', etc.
    price       REAL        NOT NULL,        -- menu price ($3–$9)
    cost        REAL        NOT NULL,        -- internal cost ($1–$4)
    is_active   INTEGER     NOT NULL         -- 1=true, 0=false
);

-- ====================================
-- Orders table (transactions)
-- ====================================
CREATE TABLE Orders (
    order_id         INTEGER PRIMARY KEY,
    customer_id      INTEGER,               -- can be NULL if non-loyalty walk-in
    employee_id      INTEGER    NOT NULL,   -- who handled the order
    order_datetime   TEXT       NOT NULL,   -- 'YYYY-MM-DD' or 'YYYY-MM-DD HH:MM'
    payment_method   TEXT       NOT NULL,   -- 'card', 'cash', 'mobile'
    order_channel    TEXT,                  -- 'in-store', 'app'
    coupon_code      TEXT,
    campaign_name    TEXT,
    points_redeemed  INTEGER,
    order_total      REAL       NOT NULL,

    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

-- ====================================
-- Order_Items table (line-level detail per order)
-- ====================================
CREATE TABLE Order_Items (
    order_item_id  INTEGER PRIMARY KEY,
    order_id       INTEGER    NOT NULL,
    item_id        INTEGER    NOT NULL,
    quantity       INTEGER    NOT NULL,
    unit_price     REAL,
    line_total     REAL,
    custom_notes   TEXT,

    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (item_id)  REFERENCES Menu_Items(item_id)
);