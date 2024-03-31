-- filter by product category (food, toy, house, medicine)
CREATE OR REPLACE FUNCTION category(category varchar, shop_id INTEGER)
    RETURNS TABLE(prod_id INTEGER, prod_name varchar, prod_img_url varchar, amount INTEGER) AS
    $$
        SELECT a.prod_id, a.prod_name, a.prod_img_url, a.amount FROM allprodinbranch(shop_id) a
        INNER JOIN products p ON p.prod_id = a.prod_id
        WHERE p.prod_type = category
    $$ LANGUAGE sql;

-- test function
SELECT * FROM category('food', 2)