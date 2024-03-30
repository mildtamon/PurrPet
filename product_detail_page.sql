-- return all product description, total amount, and first expired date
CREATE OR REPLACE FUNCTION prod_detail(product_id INTEGER, branch INTEGER)
    RETURNS TABLE(prod_id INTEGER, prod_name varchar, brand varchar, description varchar, animal varchar, range varchar, shelf_loc varchar, stock_loc varchar, barcode varchar, amount varchar, exp_date date, prod_price INTEGER, img_url varchar) AS
    $$
    SELECT s.prod_id, p.prod_name, p.prod_brand, p.prod_desc, p.animal_type, p.prod_range, s.display_location, s.stock_location , p.prod_barcode, pb.amount, s.exp_date, p.price, p.prod_img_url
    FROM (SELECT prod_id, prod_name, display_location, stock_location, exp_date, lot_number, stocks.amount FROM stocks
              INNER JOIN orders o ON lot_number = trans_id
              WHERE goods_id = product_id AND stocks.amount > 0 AND stocks.branch_id = branch) as s
    INNER JOIN products p ON p.prod_id = s.prod_id,
    allprodinbranch(branch) pb WHERE pb.good_id = product_id
    ORDER BY exp_date
    LIMIT 1
    $$ LANGUAGE SQL;

-- test function
SELECT * FROM prod_detail(1, 2);
