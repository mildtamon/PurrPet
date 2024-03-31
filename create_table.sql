DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS purchasing CASCADE;
DROP TABLE IF EXISTS distributions CASCADE;
DROP TABLE IF EXISTS stocks CASCADE;
DROP TABLE IF EXISTS shops CASCADE;
DROP TABLE IF EXISTS staffs CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS sales CASCADE;
DROP TABLE IF EXISTS sales_detail CASCADE;
DROP TABLE IF EXISTS requests CASCADE;
DROP TABLE IF EXISTS order_status CASCADE;

CREATE TABLE products (
	prod_id SERIAL PRIMARY KEY,
	prod_name CHARACTER VARYING (200),
    prod_img_URL CHARACTER VARYING (200),
    prod_brand CHARACTER VARYING (200),
    prod_range CHARACTER VARYING (100),
	prod_desc CHARACTER VARYING (5000),
    prod_size CHARACTER VARYING (30),
	prod_type CHARACTER VARYING (30),
	animal_type CHARACTER VARYING (20),
    prod_barcode CHARACTER VARYING (12),
    price INTEGER
);

CREATE TABLE orders (
	trans_id CHARACTER VARYING (20) PRIMARY KEY,
    receipt_img_URL CHARACTER VARYING (200),
    prod_id INTEGER,
    prod_name CHARACTER VARYING (200),
	trans_date DATE,
	exp_date DATE,
	amount INTEGER,
    cost_per_unit INTEGER,
    total_cost INTEGER,
	FOREIGN KEY (prod_id) REFERENCES products (prod_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE distributions (
	dist_id SERIAL PRIMARY KEY,
    prod_id INTEGER,
	branch_id INTEGER,
    trans_date TIMESTAMP,
	trans_id CHARACTER VARYING (20),
	amount INTEGER,
	FOREIGN KEY (prod_id) REFERENCES products (prod_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (trans_id) REFERENCES orders (trans_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE stocks (
	prod_id INTEGER,
    branch_id INTEGER,
    display_location CHARACTER VARYING (50),
    stock_location CHARACTER VARYING (50),
	lot_number CHARACTER VARYING (20),
	amount INTEGER,
    FOREIGN KEY (prod_id) REFERENCES products (prod_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE shops (
	shop_id SERIAL PRIMARY KEY,
	shop_name CHARACTER VARYING (200),
	shop_location CHARACTER VARYING (200)
);

CREATE TABLE staffs (
	staff_id SERIAL PRIMARY KEY,
	staff_name CHARACTER VARYING (200),
	staff_citizen_id CHAR (13),
    staff_email CHARACTER VARYING (50),
    staff_contact CHAR (10),
    staff_bank_book CHAR (12),
    staff_address CHARACTER VARYING (200),
    staff_type CHARACTER VARYING (20),
    workplace INTEGER,
    salary INTEGER,
    FOREIGN KEY (workplace) REFERENCES shops (shop_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE customers (
	customer_id SERIAL PRIMARY KEY,
	customer_name CHARACTER VARYING (50),
	customer_email CHARACTER VARYING (50),
    customer_contact CHAR (10)
);

-- sub table
CREATE TABLE sales (
    id SERIAL PRIMARY KEY,
    c_id INTEGER,
    date DATE,
    FOREIGN KEY (c_id) REFERENCES customers (customer_id) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Where 1 order show many product
CREATE TABLE sales_detail(
    sale_detail_id INTEGER,
    shop_id INTEGER,
    staff_id INTEGER,
    customer_id INTEGER,
    prod_id INTEGER,
    amount INTEGER,
    price INTEGER,
    payment_method CHARACTER VARYING (10),
    FOREIGN KEY (sale_detail_id) REFERENCES sales (id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (shop_id) REFERENCES shops (shop_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staffs (staff_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (prod_id) REFERENCES products (prod_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE order_status (
    status_id SERIAL PRIMARY KEY,
    status_name CHARACTER VARYING(50) NOT NULL
);

CREATE TABLE requests
(
    request_id SERIAL PRIMARY KEY,
    prod_id INTEGER,
    shop_id INTEGER,
    amount INTEGER,
    status_id INTEGER,
    FOREIGN KEY (prod_id) REFERENCES products (prod_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (status_id) REFERENCES order_status (status_id) ON UPDATE CASCADE ON DELETE CASCADE
);
