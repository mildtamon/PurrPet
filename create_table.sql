DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS purchasing CASCADE;
DROP TABLE IF EXISTS distributions CASCADE;
DROP TABLE IF EXISTS stocks CASCADE;
DROP TABLE IF EXISTS shops CASCADE;
DROP TABLE IF EXISTS staffs CASCADE;
DROP TABLE IF EXISTS customers CASCADE;
DROP TABLE IF EXISTS sales CASCADE;


CREATE TABLE products (
	prod_id CHARACTER VARYING (20) PRIMARY KEY,
	prod_name CHARACTER VARYING (200),
    prod_brand CHARACTER VARYING (200),
    prod_range CHARACTER VARYING (12),
	prod_desc CHARACTER VARYING (500),
	prod_type CHARACTER VARYING (30),
	animal_type CHARACTER VARYING (20),
    prod_barcode CHARACTER VARYING (12),
    price INTEGER
);

CREATE TABLE orders (
	trans_id CHARACTER VARYING (20) PRIMARY KEY,
    prod_id CHARACTER VARYING (20),
	trans_date TIMESTAMP,
	lot_number CHARACTER VARYING (20),
	exp_date DATE,
	amount INTEGER,
    cost INTEGER,
	FOREIGN KEY (prod_id) REFERENCES products (prod_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE distributions (
	dist_id CHARACTER VARYING (20) PRIMARY KEY,
    prod_id CHARACTER VARYING (20),
	branch_id CHARACTER VARYING (5),
    trans_date TIMESTAMP,
	trans_id CHARACTER VARYING (20),
	amount INTEGER,
	FOREIGN KEY (prod_id) REFERENCES products (prod_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (trans_id) REFERENCES orders (trans_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE stocks (
	goods_id CHARACTER VARYING (6),
    branch_id CHARACTER VARYING (5),
    display_location CHARACTER VARYING (50),
    stock_location CHARACTER VARYING (50),
	lot_number CHARACTER VARYING (20),
	amount INTEGER,
    FOREIGN KEY (goods_id) REFERENCES products (prod_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE shops (
	shop_id CHARACTER VARYING (3) PRIMARY KEY,
	shop_name CHARACTER VARYING (200),
	shop_location CHARACTER VARYING (200)
);

CREATE TABLE staffs (
	staff_id CHARACTER VARYING (5) PRIMARY KEY,
	staff_name CHARACTER VARYING (200),
	staff_citizen_id CHAR (200),
    staff_email CHARACTER VARYING (50),
    staff_contact CHAR (10),
    staff_bank_book CHAR (12),
    staff_address CHARACTER VARYING (200),
    staff_type CHARACTER VARYING (20),
    staff_password CHARACTER VARYING (10)
);

CREATE TABLE customers (
	customer_id CHARACTER VARYING (5) PRIMARY KEY,
	customer_name CHARACTER VARYING (50),
	customer_email CHARACTER VARYING (50),
    customer_contact CHAR (10)
);

CREATE TABLE sales (
	sell_id CHARACTER VARYING (10) PRIMARY KEY,
    sell_date TIMESTAMP,
    shop_id CHARACTER VARYING (3),
    staff_id CHARACTER VARYING (5),
    customer_id CHARACTER VARYING (5),
    goods_id CHARACTER VARYING (6),
    goods_name CHARACTER VARYING (200),
	amount INTEGER,
    price INTEGER,
    payment_method CHARACTER VARYING (10),
	FOREIGN KEY (shop_id) REFERENCES shops (shop_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (staff_id) REFERENCES staffs (staff_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (goods_id) REFERENCES products (prod_id) ON UPDATE CASCADE ON DELETE CASCADE
);