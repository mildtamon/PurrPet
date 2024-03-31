SELECT a.prod_id, a.prod_name, a.prod_img_url, a.amount, p.price FROM allProdInBranch(2) a
    INNER JOIN products p ON a.prod_id = p.prod_id;

CREATE OR REPLACE FUNCTION update_stock()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE stocks
    SET amount = amount - NEW.amount
    WHERE prod_id = NEW.prod_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER sales_detail_after_insert
AFTER INSERT ON sales_detail
FOR EACH ROW
EXECUTE FUNCTION update_stock();

-- Recreate the procedure with the new name
CREATE OR REPLACE PROCEDURE InsertOrderWithProducts (
    shop_id INTEGER,
    staff_id INTEGER,
    customer_id_value INTEGER,
    product_ids INTEGER[],
    quantities INTEGER[],
    payment_method VARCHAR(10),
    OUT total_price INTEGER,
    INOUT stock_updates stocks
)
LANGUAGE plpgsql
AS $$
DECLARE
    order_id_value INT;
    i INT;
    total INTEGER := 0;
BEGIN
    -- Inserting the order
    INSERT INTO sales (c_id, date)
    VALUES (customer_id_value, CURRENT_DATE)
    RETURNING id INTO order_id_value;

    -- Loop through the arrays and insert order products
    FOR i IN 1..array_length(product_ids, 1) LOOP
        -- Inserting order products
        INSERT INTO sales_detail (sale_detail_id, shop_id, staff_id, customer_id, prod_id, amount, price, payment_method)
        VALUES (order_id_value, shop_id, staff_id, customer_id_value, product_ids[i], quantities[i], (SELECT price FROM products WHERE prod_id = product_ids[i]), payment_method);

        -- Calculate total price
        total := total + (quantities[i] * (SELECT price FROM products WHERE prod_id = product_ids[i]));

        -- Update stock
        UPDATE stocks
        SET amount = amount - quantities[i]
        WHERE prod_id = product_ids[i] AND branch_id = shop_id;

        -- Update stock_updates
        stock_updates := (SELECT * FROM stocks WHERE prod_id = product_ids[i] AND branch_id = shop_id);
    END LOOP;

    -- Set the total price output parameter
    total_price := total;
END;
$$;


call InsertOrderWithProducts(2, 2, 1, ARRAY[1, 2], ARRAY[2, 1], 'Cash', 0);
