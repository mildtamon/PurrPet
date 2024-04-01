-- THESE FUNCTIONS WILL BE CALLED WHEN DISTRIBUTING PRODUCT BETWEEN WAREHOUSE AND SHOPS (BRANCHES)

-- when warehouse deliver product to shop (branch), the amount of product in warehouse will be reduced
-- and the request status will be changed to 'shipping'
create or replace procedure distribute(request_id INTEGER) as
   $$
    DECLARE
    v_prod_id INTEGER;
    v_shop_id INTEGER;
    v_amount INTEGER;
    v_lot varchar;

    BEGIN
        SELECT prod_id, shop_id, amount
        INTO v_prod_id, v_shop_id, v_amount
        FROM requests
        WHERE requests.request_id = distribute.request_id;

        SELECT lot_number into v_lot FROM stocks
        WHERE stocks.prod_id = v_prod_id and stocks.amount >= v_amount;

        UPDATE stocks
        SET amount = amount - v_amount
        WHERE prod_id = v_prod_id AND branch_id = 1 AND lot_number = v_lot;

        INSERT INTO distributions(prod_id, request_id, branch_id, trans_date, trans_id, amount)
        VALUES (v_prod_id, distribute.request_id, v_shop_id, CURRENT_TIMESTAMP, v_lot, v_amount);

--         UPDATE requests
--         SET status_id = 2
--         WHERE requests.request_id = distribute.request_id;
    END;
    $$ LANGUAGE PLPGSQL;

-- test function
call distribute(1);

-- after the product is delivered to the shop, the amount of product in the shop will be added
-- and the request status will be changed to 'completed'
create or replace procedure shipping_complete(dist_id INTEGER) as
    $$
    DECLARE
    v_prod_id INTEGER;
    v_shop_id INTEGER;
    v_amount INTEGER;
    v_lot varchar;
    v_request_id INTEGER;

    BEGIN
        SELECT prod_id, branch_id, amount, trans_id, request_id
        INTO v_prod_id, v_shop_id, v_amount, v_lot, v_request_id
        FROM distributions
        WHERE distributions.dist_id = shipping_complete.dist_id;

        RAISE NOTICE 'Product ID: %, Shop ID: %, Amount: %, lot %, req %', v_prod_id, v_shop_id, v_amount, v_lot, v_request_id;

        -- Check if exists
        PERFORM 1
        FROM stocks
        WHERE prod_id = v_prod_id AND branch_id = v_shop_id AND lot_number = v_lot;

        IF FOUND THEN
            -- Update existing stock
            UPDATE stocks
            SET amount = amount + v_amount
            WHERE prod_id = v_prod_id AND branch_id = v_shop_id AND lot_number = v_lot;
        ELSE
            -- Insert new record
            INSERT INTO stocks (prod_id, branch_id, display_location, stock_location, lot_number, amount)
            VALUES (v_prod_id, v_shop_id, '', '', v_lot, v_amount);
        END IF;

        UPDATE requests
        SET status_id = 3
        WHERE requests.request_id = v_request_id;
    END;
    $$ LANGUAGE PLPGSQL;

-- test function
call shipping_complete(1);

-- trigger for checking if the amount < 0
CREATE OR REPLACE FUNCTION less_than_zero()
	RETURNS TRIGGER
	AS $$
	BEGIN
	    IF EXISTS(SELECT 1 FROM stocks WHERE NEW.amount < 0)
	        THEN RETURN OLD;
	    ELSE
	        RETURN NEW;
	    END IF;
	END;
	$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_stock_update
	BEFORE UPDATE
	ON stocks
	FOR EACH ROW
	EXECUTE PROCEDURE less_than_zero();
