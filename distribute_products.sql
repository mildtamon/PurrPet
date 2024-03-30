-- 1. function to call when distribute product, will automatically update stock for warehouse and shop
--      1. update amount of warehouse stock -= distributed number
--      2. update amount of shop_id stock += distributed number
create or replace procedure distribute(to_branch INTEGER, product_id INTEGER, dist_amount INTEGER, lot varchar) as
   $$
    BEGIN
        -- Check if exists
        PERFORM 1
        FROM stocks
        WHERE goods_id = product_id AND branch_id = to_branch AND lot_number = lot;

        IF FOUND THEN
            -- Update existing stock
            UPDATE stocks
            SET amount = amount + dist_amount
            WHERE goods_id = product_id AND branch_id = to_branch AND lot_number = lot;
        ELSE
            -- Insert new record
            INSERT INTO stocks (goods_id, branch_id, display_location, stock_location, lot_number, amount)
            VALUES (product_id, to_branch, '', '', lot, dist_amount);
        END IF;

        -- Reduce amount from warehouse
        UPDATE stocks
        SET amount = amount - dist_amount
        WHERE goods_id = product_id AND branch_id = 1 AND lot_number = lot;

        -- Create distributions
        INSERT INTO distributions(prod_id, branch_id, trans_date, trans_id, amount)
        VALUES (product_id, to_branch, CURRENT_TIMESTAMP, lot, dist_amount);
    END;
    $$ LANGUAGE PLPGSQL;

-- test function
call distribute(3, 1, 5, 't00001');