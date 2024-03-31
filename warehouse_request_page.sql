-- get all request (that hasn't been delivered or rejected yet)
-- with the product name and shop name (easier for frontend to retrieve and show data)
SELECT request_id, requests.prod_id, p.prod_name, requests.shop_id, s.shop_name, amount, status_id FROM requests
INNER JOIN products p on requests.prod_id = p.prod_id
INNER JOIN shops s on requests.shop_id = s.shop_id
WHERE status_id = 1;

-- after clicking deliver, it will change status_id to 1 (shipping) and trigger function distribute()
-- if clicking reject, it will change status_id to 4 (rejected)
CREATE OR REPLACE FUNCTION order_responds(request_id INTEGER, status INTEGER) RETURNS void AS
    $$
        BEGIN
            UPDATE requests
            SET status_id = status
            WHERE requests.request_id = order_responds.request_id;

            IF status = 2 THEN
                call distribute(request_id);
            END IF;
        END;
    $$ LANGUAGE PLPGSQL;
