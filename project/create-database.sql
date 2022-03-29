-- Create database
CREATE DATABASE food_delivery;
USE food_delivery;

-- Create tables
CREATE TABLE location
(
    location_id      INT NOT NULL AUTO_INCREMENT,
    location_country VARCHAR(50),
    location_region  VARCHAR(50),
    PRIMARY KEY (location_id)
);

CREATE TABLE address
(
    address_id          INT NOT NULL AUTO_INCREMENT,
    address_street      VARCHAR(50),
    address_number      VARCHAR(10),
    address_location_id INT,
    PRIMARY KEY (address_id),
    FOREIGN KEY (address_location_id) REFERENCES location (location_id)
);

CREATE TABLE user
(
    user_id         INT NOT NULL AUTO_INCREMENT,
    user_name       VARCHAR(50),
    user_phone      VARCHAR(20),
    user_address_id INT,
    PRIMARY KEY (user_id),
    FOREIGN KEY (user_address_id) REFERENCES address (address_id)
);

CREATE TABLE deliveryman
(
    deliveryman_id          INT NOT NULL AUTO_INCREMENT,
    deliveryman_name        VARCHAR(50),
    deliveryman_phone       VARCHAR(20),
    deliveryman_location_id INT,
    PRIMARY KEY (deliveryman_id),
    FOREIGN KEY (deliveryman_location_id) REFERENCES location (location_id)
);

CREATE TABLE business
(
    business_id         INT NOT NULL AUTO_INCREMENT,
    business_name       VARCHAR(50),
    business_phone      VARCHAR(20),
    business_type       VARCHAR(20),
    business_address_id INT,
    PRIMARY KEY (business_id),
    FOREIGN KEY (business_address_id) REFERENCES address (address_id)
);

CREATE TABLE reservation
(
    reservation_id                  INT NOT NULL AUTO_INCREMENT,
    reservation_user_id             INT,
    reservation_deliveryman_id      INT,
    reservation_business_id         INT,
    reservation_delivery_address_id INT,
    reservation_pickup_address_id   INT,
    PRIMARY KEY (reservation_id),
    FOREIGN KEY (reservation_user_id) REFERENCES user (user_id),
    FOREIGN KEY (reservation_deliveryman_id) REFERENCES deliveryman (deliveryman_id),
    FOREIGN KEY (reservation_business_id) REFERENCES business (business_id),
    FOREIGN KEY (reservation_delivery_address_id) REFERENCES user (user_address_id),
    FOREIGN KEY (reservation_pickup_address_id) REFERENCES business (business_address_id)
);

CREATE TABLE product
(
    product_id          INT NOT NULL AUTO_INCREMENT,
    product_name        VARCHAR(50),
    product_description VARCHAR(255),
    product_price       SMALLINT,
    product_stock       SMALLINT,
    product_business_id INT,
    PRIMARY KEY (product_id),
    FOREIGN KEY (product_business_id) REFERENCES business (business_id)
);

CREATE TABLE reservation_product
(
    reservation_product_id   INT NOT NULL AUTO_INCREMENT,
    reservation_product_r_id INT,
    reservation_product_p_id INT,
    PRIMARY KEY (reservation_product_id),
    FOREIGN KEY (reservation_product_r_id) REFERENCES reservation (reservation_id),
    FOREIGN KEY (reservation_product_p_id) REFERENCES product (product_id)
);

-- Insert dummy data
INSERT INTO location (location_country, location_region)
VALUES ('Sweden', 'Västra Götaland'),
       ('Sweden', 'Skåne'),
       ('Sweden', 'Gotland'),
       ('Norway', 'Oslo');

INSERT INTO address (address_street, address_number, address_location_id)
VALUES ('Storgatan', '21A', 1),
       ('Quarl Ankas Väg', '3', 1),
       ('Karl Gustavsgatan', '10', 1),
       ('Lilla Bergsgatan', '5', 1),
       ('Koppasbergsgatan', '13', 2),
       ('Skultunagatan', '50f', 2),
       ('Wilhelms gate', '8b', 4),
       ('Nordahl Bruns gate', '20', 4);

INSERT INTO user (user_name, user_phone, user_address_id)
VALUES ('Svante Jonsson', '0706220045', 2),
       ('Linus Romland', '0706208912', 7),
       ('Markus Simonsen', '0706324505', 6);

INSERT INTO deliveryman (deliveryman_name, deliveryman_phone, deliveryman_location_id)
VALUES ('Andreas Vins', '0506340549', 1),
       ('Anton Helenius', '0703477839', 1),
       ('John Doe', '0649388560', 2),
       ('Jan Emanuel Johansson', '0709593208', 4);

INSERT INTO business (business_name, business_phone, business_type, business_address_id)
VALUES ('Brödernas Nordstan', '4504293023', 'Burgers', 1),
       ('Burger King Avenyn', '4503954023', 'Burgers', 3),
       ('La Gondola', '0459325478', 'Italian', 4),
       ('Al Habesha', '0649382910', 'African', 5),
       ('Hjørnets Grill Kebab', '0669282610', 'Kebab', 8);

INSERT INTO product (product_name, product_description, product_price, product_stock, product_business_id)
VALUES ('Ostburgare', 'Kött, cheddarost, husets majjo, salladsblad & silverlök.', 99, 50, 1),
       ('Chiliburgare', 'Kött, cheddarost, färsk chili, chilimajjo, salladsblad & silverlök.', 109, 43, 1),
       ('Tryffelburgare', 'Kött, tryffelost, lökring, karamelliserad lök, tryffelmajjo, salladsblad & silverlök.', 114, 20, 1),
       ('POLLO E PESTO', 'Kyckling, pesto, grädde, parmesan & ruccola.', 199, 15, 3),
       ('CON FILETTO E PEPE', 'Oxfilé, tärnad paprika, rödlök, svamp & krämig pepparsås.', 239, 23, 3),
       ('Kebabtallrik', 'Pommes frites, Kebabkött, Sallad, Lök, Gurka, Tomat & Kebabsås.', 98, 100, 5);

INSERT INTO reservation (reservation_user_id, reservation_deliveryman_id, reservation_business_id,
                         reservation_delivery_address_id, reservation_pickup_address_id)
VALUES (1, 2, 1, 2, 1),
       (2, 4, 5, 7, 8);

INSERT INTO reservation_product (reservation_product_r_id, reservation_product_p_id)
VALUES (1, 1),
       (1, 3),
       (2, 6);