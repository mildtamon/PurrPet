CREATE OR REPLACE FUNCTION ProductsLocationInShop(id INTEGER)
RETURNS TABLE (
    prod_id INTEGER,
    prod_img_URL CHARACTER VARYING (200),
    prod_name CHARACTER VARYING (200),
    display_location CHARACTER VARYING (50),
    stock_location CHARACTER VARYING (50),
    lot_number CHARACTER VARYING (20),
    amount INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        p.prod_id,
        p.prod_img_URL,
        p.prod_name,
        s.display_location,
        s.stock_location,
        s.lot_number,
        s.amount
    FROM
        products p
    JOIN
        stocks s ON p.prod_id = s.prod_id
    JOIN
        shops sh ON s.branch_id = sh.shop_id
    WHERE
        sh.shop_id = ProductsLocationInShop.id;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM ProductsLocationInShop(2);


create or replace procedure updateLocation(prod_id INTEGER,display_lo varchar, stock_lo varchar) as
    $$
    BEGIN
        PERFORM 1
        FROM stocks
        WHERE stocks.prod_id = updateLocation.prod_id;

        IF FOUND THEN
            -- Update existing products
            UPDATE stocks
            SET display_location = display_lo,
                stock_location = stock_lo
            WHERE stocks.prod_id = updateLocation.prod_id;
        END IF;
    END;
    $$ LANGUAGE PLPGSQL;

call updateLocation(1,'','');

SELECT * FROM ProductsLocationInShop(2);

call updateLocation(1,'zone A shelf #1','back office shelf #1');

SELECT * FROM ProductsLocationInShop(2);
