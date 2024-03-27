-- TODO: add order to warehouse,
--       INSERT INTO orders(trans_id, prod_id, trans_date, exp_date, amount, cost)
--       and INSERT INTO products(...) [auto increment pk] if not exist in products table already.
-- 1. function to call when store the the transaction of order product
CREATE OR REPLACE PROCEDURE orderProduct(receipt_img_URL varchar, product_name varchar, exp_date date, amount INTEGER, cost_per_unit INTEGER) AS
    $$
    BEGIN
        -- Check if the product exists in the products table
        PERFORM 1
        FROM products
        WHERE prod_name = product_name;

        -- If the product doesn't exist, insert it into the products table
        IF NOT FOUND THEN
            INSERT INTO products(prod_name, prod_img_URL, prod_brand, prod_range, prod_desc, prod_size, prod_type, animal_type, prod_barcode, price)
            SELECT product_name, '', 'Brand Name', 'Product Range', 'Product Description', '', '', '', '', amount;
        END IF;

--         SELECT prod_id FROM products WHERE prod_name == product_name;

    -- Insert a new order for the product
    INSERT INTO orders(receipt_img_URL, prod_id, trans_date, exp_date, amount, cost_per_unit, total_cost)
    VALUES (receipt_img_URL, DEFAULT, CURRENT_DATE, exp_date, amount, cost_per_unit, cost_per_unit*amount);

    -- Insert the product into the warehouse stock
    INSERT INTO stocks(goods_id, branch_id, display_location, stock_location, lot_number, amount)
    VALUES (DEFAULT, 1, NULL, '', 't....', amount);
    END;
    $$ LANGUAGE PLPGSQL;

-- test function
call orderProduct('bit.ly/ashkasdlj','coolest dog food','2025-08-11',100,70);


-- 2. function to call when order product (add the amount to stocks branch 1 (warehouse))
create or replace procedure addToWarehouse(product_id INTEGER, stock_loc varchar, lot varchar, amount INTEGER) as
    $$
    BEGIN
        INSERT INTO stocks(goods_id, branch_id, display_location, stock_location, lot_number, amount) VALUES
        (product_id, 1, NULL, stock_loc, lot, addToWarehouse.amount);
    END;
    $$ LANGUAGE PLPGSQL;

-- test function
-- call addToWarehouse(1,'storage #1 shelf #2','t00001',100);

--Suggest from GPT
-- CREATE OR REPLACE PROCEDURE orderProduct(receipt_img_URL VARCHAR, product_name VARCHAR, exp_date DATE, amount INTEGER, cost_per_unit INTEGER, OUT new_prod_id INTEGER) AS
-- $$
-- BEGIN
--     -- Check if the product exists in the products table
--     PERFORM prod_id
--     FROM products
--     WHERE prod_name = product_name
--     LIMIT 1 INTO new_prod_id;
--
--     -- If the product doesn't exist, insert it into the products table
--     IF new_prod_id IS NULL THEN
--         INSERT INTO products(prod_name, prod_img_URL, prod_brand, prod_range, prod_desc, prod_size, prod_type, animal_type, prod_barcode, price)
--         VALUES (product_name, '', 'Brand Name', 'Product Range', 'Product Description', '', '', '', '', amount)
--         RETURNING prod_id INTO new_prod_id;
--     END IF;
--
--     -- Insert a new order for the product
--     INSERT INTO orders(receipt_img_URL, prod_id, trans_date, exp_date, amount, cost_per_unit, total_cost)
--     VALUES (receipt_img_URL, new_prod_id, CURRENT_DATE, exp_date, amount, cost_per_unit, cost_per_unit * amount);
--
--     -- Insert the product into the warehouse stock
--     INSERT INTO stocks(goods_id, branch_id, display_location, stock_location, lot_number, amount)
--     VALUES (new_prod_id, 1, NULL, '', 't....', amount);
-- END;
-- $$ LANGUAGE PLPGSQL;

