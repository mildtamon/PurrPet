-- 1. function to call when store the the transaction of order product
CREATE OR REPLACE PROCEDURE orderProduct(order_id VARCHAR, receipt_img_URL VARCHAR, product_name VARCHAR, product_size VARCHAR, exp_date DATE, amt INTEGER, cost_per_unit INTEGER, stock_loc varchar) AS
    $$
    DECLARE
        new_prod_id INTEGER;
    BEGIN
        -- Check if the product exists in the products table
        SELECT prod_id INTO new_prod_id
        FROM products
        WHERE prod_name = product_name AND prod_size = product_size
        LIMIT 1;

        -- If the product doesn't exist, insert it into the products table
        IF new_prod_id IS NULL THEN
            INSERT INTO products(prod_name, prod_img_URL, prod_brand, prod_range, prod_desc, prod_size, prod_type, animal_type, prod_barcode, price) VALUES
                (product_name, '', '', '', '', product_size, '', '', '', 0)
            RETURNING prod_id INTO new_prod_id;
        END IF;

        -- Insert a new order for the product
        INSERT INTO orders(trans_id, receipt_img_URL, prod_id, prod_name, trans_date, exp_date, amount, cost_per_unit, total_cost) VALUES
            (order_id, orderProduct.receipt_img_URL, new_prod_id, product_name, CURRENT_DATE, orderProduct.exp_date, amt, orderProduct.cost_per_unit, orderProduct.cost_per_unit * amt);

        -- Insert the product into the warehouse stock
        INSERT INTO stocks(prod_id, branch_id, display_location, stock_location, lot_number, amount) VALUES
            (new_prod_id, 1, NULL, stock_loc, order_id, amt);
    END;
    $$
    LANGUAGE PLPGSQL;
-- test function
call orderProduct('t1','bit.ly/324324','SmartHeart Roast Beef Flavor', '500 g','2025-3-1',100,23,'storage #1 shelf #1');
