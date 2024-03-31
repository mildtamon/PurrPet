-- only select all information of branches except warehouse (shop_id = 1)
SELECT * FROM shops
WHERE shop_id != 1