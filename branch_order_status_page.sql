-- gives order requests made by this shop
CREATE OR REPLACE FUNCTION shoprequest(shop INTEGER)
    RETURNS TABLE(prod_id INTEGER, prod_name varchar, prod_size varchar, amount INTEGER, status INTEGER) AS
    $$
        SELECT r.prod_id, p.prod_name, p.prod_size, amount, r.status_id FROM requests r
        INNER JOIN public.products p on p.prod_id = r.prod_id
        WHERE r.shop_id = shop;
    $$ LANGUAGE sql;

-- test function
SELECT * FROM shoprequest(3);
