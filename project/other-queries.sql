-- Update
START TRANSACTION;
UPDATE user
SET user_phone = '0706210013'
WHERE user_name = 'Svante Jonsson';
COMMIT;

-- Delete
START TRANSACTION;
DELETE
FROM deliveryman
WHERE deliveryman_name = 'John Doe';
ROLLBACK;

-- Views
CREATE VIEW all_addresses_in_sweden AS
SELECT address_street, address_number, location_region
FROM address
         INNER JOIN location
            ON address.address_location_id = location.location_id
WHERE location_country = 'Sweden';

SELECT *
FROM all_addresses_in_sweden;

-- Triggers
CREATE TRIGGER before_business_delete
    BEFORE DELETE
    ON business
    FOR EACH ROW
BEGIN
    DELETE rp
    FROM reservation_product rp
             INNER JOIN reservation r
                ON r.reservation_id = rp.reservation_product_r_id
    WHERE r.reservation_business_id = OLD.business_id;

    DELETE FROM reservation WHERE reservation_business_id = OLD.business_id;
    DELETE FROM product WHERE product_business_id = OLD.business_id;
END;

DELETE
FROM business
WHERE business_name LIKE 'Hj%';

-- Stored procedures
-- Get business products
CREATE PROCEDURE get_business_products(IN business_id INT)
BEGIN
    SELECT product_name, product_description, product_price, product_stock
    FROM product
    WHERE product.product_business_id = business_id;
END;

CALL get_business_products(1);

-- Get average product price of a business
CREATE PROCEDURE get_average_business_price(IN business_id INT, OUT average_price DOUBLE PRECISION)
BEGIN
    SELECT ROUND(AVG(product.product_price), 2)
    INTO average_price
    FROM business
             INNER JOIN product
                ON business.business_id = product.product_business_id
    WHERE product.product_business_id = business_id;
END;

CALL get_average_business_price(1, @average_price);
SELECT @average_price;


-- Display of many to many relation
CREATE VIEW all_reservations AS
SELECT r.*, u.*, d.*, b.*, au.address_id AS delivery_address_id, au.address_street AS delivery_address_street, au.address_number AS delivery_address_number, au.address_location_id AS delivery_address_location_id, ab.address_id AS pickup_address_id, ab.address_street AS pickup_address_street, ab.address_number AS pickup_address_number, ab.address_location_id AS pickup_address_location_id
FROM reservation AS r
    INNER JOIN user AS u
        ON u.user_id = r.reservation_user_id
    INNER JOIN deliveryman AS d
        ON d.deliveryman_id = r.reservation_deliveryman_id
    INNER JOIN business AS b
        ON b.business_id = r.reservation_business_id
    INNER JOIN address AS au
        ON u.user_address_id = au.address_id
    INNER JOIN address AS ab
        ON b.business_address_id = ab.address_id;

CREATE VIEW get_detailed_reservation AS
    SELECT *
    FROM reservation_product AS rp
        INNER JOIN all_reservations AS r
            ON r.reservation_id = rp.reservation_product_r_id
        INNER JOIN product AS p
            ON p.product_id = rp.reservation_product_p_id;

SELECT user_name, business_name, product_name, product_price FROM get_detailed_reservation
WHERE reservation_id = 1;