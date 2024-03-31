CREATE OR REPLACE FUNCTION showIncomplete()
RETURNS TABLE ( prod_id INTEGER, prod_name CHARACTER VARYING (200), prod_img_url CHARACTER VARYING (200),
    prod_brand CHARACTER VARYING (200), prod_range CHARACTER VARYING (100), prod_desc CHARACTER VARYING (5000),
    prod_size CHARACTER VARYING (30), prod_type CHARACTER VARYING (30), animal_type CHARACTER VARYING (20),
    prod_barcode CHARACTER VARYING (12), price INTEGER) AS
    $$
    BEGIN
        RETURN QUERY
        SELECT * FROM products as p
        WHERE p.prod_img_url = '' OR p.prod_brand = '' OR p.prod_range = '' OR p.prod_desc = ''
          OR p.prod_type = '' OR p.animal_type = '' OR p.prod_barcode = '';
    END;
    $$ LANGUAGE PLPGSQL;

SELECT * FROM showIncomplete();

--function to update new product information
create or replace procedure updateProduct(product_name varchar,product_img_URL varchar, product_brand varchar, product_range varchar, product_desc varchar, product_size varchar, product_type varchar, animal_type varchar, product_barcode varchar, product_price INTEGER) as
    $$
    BEGIN
        PERFORM 1
        FROM products
        WHERE prod_name = product_name AND prod_size = product_size;

        IF FOUND THEN
            -- Update existing products
            UPDATE products
            SET prod_img_url = product_img_URL,
                prod_brand = product_brand,
                prod_desc = product_desc,
                prod_range = product_range,
                prod_type = product_type,
                animal_type = updateProduct.animal_type,
                prod_barcode = product_barcode,
                price = product_price
            WHERE prod_name = product_name AND prod_size = product_size;
        END IF;
    END;
    $$ LANGUAGE PLPGSQL;
--test function