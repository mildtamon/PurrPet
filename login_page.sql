-- check if staff belongs to the shop
CREATE OR REPLACE FUNCTION login(name varchar, assigned_shop varchar) RETURNS TABLE(success BOOLEAN, id INTEGER) AS
    $$
    BEGIN
        RETURN QUERY
            SELECT EXISTS (
                SELECT 1 FROM
                    (SELECT staffs.staff_name, shops.shop_name, shops.shop_id FROM staffs, shops
                    WHERE staffs.workplace = shops.shop_id) as a
                WHERE staff_name = name
                AND assigned_shop = shop_name),
            (SELECT shop_id FROM shops WHERE shop_name = assigned_shop);
    END;
    $$ LANGUAGE plpgsql;

-- test function
SELECT login('mild', 'Samyan pet shop');    -- false
SELECT login('mild', 'Salaya pet shop');    -- true
SELECT login('max', 'Samyan pet shop');     -- true
SELECT login('john','Ladkrabang warehouse') --true