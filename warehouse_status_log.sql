CREATE OR REPLACE VIEW allDistribution AS
SELECT
    d.dist_id AS dist_id,
    p.prod_name AS prod_name,
    p.prod_size AS prod_size,
    d.branch_id AS to_branch,
    s.lot_number AS lot_number,
    d.amount AS amount,
    o.status_name AS status FROM distributions d
    INNER JOIN order_status o ON d.request_id = o.status_id
    INNER JOIN products p ON d.prod_id = p.prod_id
    INNER JOIN stocks s ON s.prod_id = d.prod_id;

SELECT * FROM allDistribution;
