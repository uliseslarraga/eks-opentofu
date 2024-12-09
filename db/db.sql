CREATE TABLE products (
  id BIGINT NOT NULL PRIMARY KEY,
  name VARCHAR(255)
);

INSERT INTO products (id, name) 
VALUES
  (100001, 'Apple'),
  (100002, 'Pears'),
  (100003, 'Banana'),
  (100004, 'Mango');

CREATE TABLE prices (
  product_id BIGINT REFERENCES products (id),
  price_amount DECIMAL(10,2),
  discount DECIMAL(10,2)
);

INSERT INTO prices (product_id, price_amount, discount)
VALUES
    (100001, 12.5, 2.5),
    (100002, 10.5, 2.1),
    (100003, 18.5, 2.0),
    (100004, 18.5, 2.0);