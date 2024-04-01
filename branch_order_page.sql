SELECT prod_id, prod_name, prod_img_url, amount  FROM allProdInBranch(2);

CREATE OR REPLACE FUNCTION orderToBranch(product_id INTEGER, amt INTEGER,to_branch INTEGER) RETURNS BOOLEAN AS
    $$
    declare numInWarehouse INTEGER;
    BEGIN
        SELECT SUM(s.amount) INTO numInWarehouse
        FROM stocks as s
        WHERE prod_id = product_id AND branch_id = 1;

        IF numInWarehouse >= amt THEN
            INSERT INTO requests(prod_id, shop_id, amount, status_id) VALUES
                (product_id,to_branch,amt,1);
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        end if;
    END;
    $$ LANGUAGE PLPGSQL;

--test function
SELECT orderToBranch(1,99,2);