CREATE OR REPLACE FUNCTION allProdInWarehouse()
    RETURNS TABLE(prod_id INTEGER, prod_name varchar, prod_size varchar, cost_unit INTEGER, stock_location varchar,
                  transaction_id varchar, receipt_img varchar, exp_date DATE, amount INTEGER) AS
    $$
        SELECT p.prod_id, p.prod_name, p.prod_size, o.cost_per_unit, s.stock_location, o.trans_id,
               o.receipt_img_url, o.exp_date, o.amount FROM products p
        INNER JOIN stocks s ON s.prod_id = p.prod_id
        INNER JOIN orders o ON o.trans_id = s.lot_number AND o.prod_id = p.prod_id
        WHERE s.branch_id = 1
        ORDER BY p.prod_id
    $$ LANGUAGE SQL;

SELECT * FROM allProdInWarehouse()