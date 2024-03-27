DROP VIEW IF EXISTS allProdInBranch;

-- return table of all product in that shop given the shop_id
CREATE OR REPLACE FUNCTION allProdInBranch(id INTEGER)
    RETURNS TABLE(good_id INTEGER, branch INTEGER, prod_name varchar, prod_img_url varchar, amount INTEGER) AS
    $$
        SELECT s.goods_id, s.branch_id, p.prod_name, p.prod_img_url, SUM(s.amount) AS total_amount
        FROM stocks s
        INNER JOIN products p ON s.goods_id = p.prod_id
        WHERE id = s.branch_id
        GROUP BY s.goods_id, s.branch_id, p.prod_name, p.prod_img_url;
    $$ LANGUAGE SQL;

-- test function
SELECT * FROM allProdInBranch(2);
SELECT * FROM allProdInBranch(3);