-- check if staff belongs to the shop
CREATE OR REPLACE FUNCTION login(name varchar, assigned_shop varchar) RETURNS BOOLEAN AS
    $$
    SELECT EXISTS (
            SELECT 1 FROM
                (SELECT staffs.staff_name, shops.shop_name FROM staffs, shops
                WHERE staffs.workplace = shops.shop_id) as a
            WHERE staff_name = name
            AND assigned_shop = shop_name);
    $$ LANGUAGE SQL;

-- test function
SELECT * FROM shops;
SELECT login('mild', 'Samyan pet shop');    -- false
SELECT login('mild', 'Salaya pet shop');    -- true
SELECT login('max', 'Samyan pet shop');     -- true