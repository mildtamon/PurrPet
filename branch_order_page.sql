SELECT good_id, prod_name, prod_img_url, amount  FROM allProdInBranch(2);

CREATE OR REPLACE FUNCTION orderToBranch(product_id INTEGER, amt INTEGER) RETURNS BOOLEAN AS
    $$
    declare numInWarehouse INTEGER;
    BEGIN
        SELECT SUM(s.amount) INTO numInWarehouse
        FROM stocks as s
        WHERE goods_id = product_id AND branch_id = 1;

        IF numInWarehouse >= amt THEN
            RETURN TRUE;
        ELSE
            RETURN FALSE;
        end if;
    END;
    $$ LANGUAGE PLPGSQL;

--test function
SELECT orderToBranch(1,300);
