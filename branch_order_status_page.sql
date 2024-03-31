-- gives order requests made by this shop
SELECT s.prod_id, p.prod_name, p.prod_size, amount, s.status_id
FROM (SELECT d.dist_id, d.prod_id, d.amount, r.status_id FROM distributions d
    INNER JOIN requests r ON r.request_id = d.request_id) as s,
    products p where s.prod_id = p.prod_id
