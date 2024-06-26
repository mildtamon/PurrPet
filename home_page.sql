-- return table of all product in that shop given the shop_id
CREATE OR REPLACE FUNCTION allProdInBranch(id INTEGER)
    RETURNS TABLE(prod_id INTEGER, prod_name varchar, prod_img_url varchar, amount INTEGER) AS
    $$
        SELECT s.prod_id, p.prod_name, p.prod_img_url, SUM(s.amount) AS total_amount
        FROM stocks s
        INNER JOIN products p ON s.prod_id = p.prod_id
        WHERE id = s.branch_id
        GROUP BY s.prod_id, s.branch_id, p.prod_name, p.prod_img_url
        ORDER BY prod_id;
    $$ LANGUAGE SQL;

-- search bar
CREATE OR REPLACE FUNCTION searchBy(t TEXT, branch_id INTEGER)
    RETURNS TABLE(prod_id INTEGER, prod_name varchar) AS
    $$
    BEGIN
        RETURN QUERY
            SELECT p.prod_id, p.prod_name
            FROM allProdInBranch(branch_id) p
            WHERE p.prod_name LIKE '%' || t || '%';
    END;
    $$ LANGUAGE plpgsql;

-- test function
SELECT * FROM allProdInBranch(2);
SELECT * FROM allProdInBranch(3);
SELECT * FROM searchBy('Smart', 2)