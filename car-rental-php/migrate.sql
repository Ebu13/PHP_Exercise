CREATE DATABASE IF NOT EXISTS carjack;
USE carjack;

CREATE TABLE address
(
  _id INT PRIMARY KEY AUTO_INCREMENT,
  street VARCHAR(100) NOT NULL,
  city VARCHAR(100) NOT NULL,
  state VARCHAR(100) NOT NULL,
  country VARCHAR(100) NOT NULL,
  zip INT NOT NULL
);

CREATE TABLE user
(
  _id INT PRIMARY KEY AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(50) NOT NULL,
  username VARCHAR(30) NOT NULL,
  password VARCHAR(255) NOT NULL,
  ph_no VARCHAR(10),
  gender ENUM('m', 'f', 'u') DEFAULT 'u',
  join_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  address_id INT,
  avatar VARCHAR(500) DEFAULT 'https://ssl.gstatic.com/images/branding/product/1x/avatar_circle_blue_512dp.png',
  CONSTRAINT user_address_id_fk FOREIGN KEY (address_id) REFERENCES address (_id) ON DELETE SET NULL ON UPDATE CASCADE
);
CREATE UNIQUE INDEX user_email_uindex ON user (email);
CREATE UNIQUE INDEX user_username_uindex ON user (username);

CREATE TABLE admins
(
  _id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  CONSTRAINT admins_user_id_fk FOREIGN KEY (user_id) REFERENCES user (_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE cars
(
  _id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(50) NOT NULL,
  pic VARCHAR(200),
  info TEXT,
  stock INT NOT NULL
);

CREATE TABLE car_rates
(
  car_id INT NOT NULL,
  rate_by_hour INT NOT NULL DEFAULT 100,
  rate_by_day INT NOT NULL DEFAULT 2000,
  rate_by_km INT NOT NULL DEFAULT 20,
  CONSTRAINT car_rates_car_id_fk FOREIGN KEY (car_id) REFERENCES cars (_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE transaction
(
  _id INT PRIMARY KEY AUTO_INCREMENT,
  user_id INT NOT NULL,
  car_id INT NOT NULL,
  mode ENUM('km', 'day', 'hour') NOT NULL,
  value INT NOT NULL,
  time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT transaction_user_id_fk FOREIGN KEY (user_id) REFERENCES user (_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT transaction_car_id_fk FOREIGN KEY (car_id) REFERENCES cars (_id) ON DELETE CASCADE ON UPDATE CASCADE
);

DELIMITER //
CREATE TRIGGER STOCK_UPDATE_DECREASE
AFTER INSERT
  ON transaction FOR EACH ROW
  BEGIN
    UPDATE cars SET stock = stock - 1 WHERE _id = NEW.car_id;
  END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER STOCK_UPDATE_INCREASE
AFTER DELETE
  ON transaction FOR EACH ROW
  BEGIN
    UPDATE cars SET stock = stock + 1 WHERE _id = OLD.car_id;
  END;
//
DELIMITER ;

INSERT INTO address (street, city, state, country, zip) VALUES ('22B-Bakers Street', 'London', 'London', 'England', 0);
INSERT INTO user (first_name, last_name, email, username, password, ph_no, gender, join_time, address_id, avatar) VALUES ('Admin', 'Account', 'admin@io.io', 'admin', '$2y$10$UPAMoof5OI7TrzXoTlvkMuLn9OVhQCgTOyXb4j5wStUXqzyGJ0UFa', '', 'u', CURRENT_TIMESTAMP, 1, 'https://ssl.gstatic.com/images/branding/product/1x/avatar_circle_blue_512dp.png');
INSERT INTO admins (user_id) VALUES (1);

INSERT INTO cars (name, pic, info, stock) VALUES ('Ford Mustang', 'https://www.carmax.com/~/media/images/carmax/com/Articles/10-best-sports-cars-for-2017/178392-01-ford-mustang.png?la=en&hash=24DFF4EF3A020F5E11569427B8A8C9BE0DAF208C', 'The current Mustang arrived in 2015, and brought with it a new range of engine choices. The 3.7L V6 became the base engine; it’s good for a not-at-all-shabby 300 horsepower. Next up is a 2.3L, turbocharged four-cylinder that makes 310 horsepower. Yes, only four cylinders, but it sprints from zero to 60 in less than six seconds! Topping the range is a 5.0L V8 good for over 400 horsepower. Transmission choices include a six-speed manual or an automatic with paddle shifters.', 13);
INSERT INTO cars (name, pic, info, stock) VALUES ('Chevrolet Camaro', 'https://www.carmax.com/~/media/images/carmax/com/Articles/10-best-sports-cars-for-2017/178392-02-chevrolet-camaro.png?la=en&hash=0804044937845D931041062E02647F870E11FB9B', 'The Camaro is available both as a rear-wheel-drive coupe and a convertible, and while both have a backseat, it probably works best as a shelf for your groceries. Before the 2016 refresh, the LS and LT trims got a 3.6L V6 rated at 312 horsepower, while the SS was powered by a mighty 426-horsepower,  6.2L V8. And if that wasn’t enough, for 2014, Chevy unveiled a Z/28 Camaro that packs a huge 7.0L V8 from the Corvette.', 31);
INSERT INTO cars (name, pic, info, stock) VALUES ('Dodge Challenger', 'https://www.carmax.com/~/media/images/carmax/com/Articles/10-best-sports-cars-for-2017/178392-03-dodge-challenger.png?la=en&hash=53C75E55875CA12FB856B318ADFBC427DA8E8685', 'The Challenger is Dodge’s flagship enthusiast vehicle. But is it a muscle car or is it a sports car? It has certainly got the brawn to launch it in a straight line (zero to 60 mph in a hair over six seconds, thanks to its big Hemi® engine), using its six-speed manual stickshift; the newer models’ independent suspension means the Challenger is a sportier handler than ever before. Some of the more tricked-out Challengers are factory-built hot rods; the Scat Pack option gives drivers nearly 500 horsepower.', 102);
INSERT INTO cars (name, pic, info, stock) VALUES ('Chevrolet Corvette', 'https://www.carmax.com/~/media/images/carmax/com/Articles/10-best-sports-cars-for-2017/178392-04-chevrolet-corvette.png?la=en&hash=47E4B5A259601EAA4249C2AEC95FC4CC9FC4964B', 'For a certain set of enthusiasts, the Corvette is more than a sports car — it’s American heritage on wheels. The Corvette has been in production since 1953 and the car is currently in its seventh (C7) generation, which hit showrooms in 2014. At an average price of close to $40,000 on our website, a used Corvette is the priciest sports car on this list; but then, you do get a lot for your money.', 43);
INSERT INTO cars (name, pic, info, stock) VALUES ('Nissan 370Z', 'https://www.carmax.com/~/media/images/carmax/com/Articles/10-best-sports-cars-for-2017/178392-05-nissan-370z.png?la=en&hash=F379B7A2F7868645923BBC1A4AE131D171629417', 'Launched in 2010, the 370Z replaced the visually similar 350Z and traces its lineage back to the 240Z of the early 1970s. Available as both a coupe or a roadster, this compact two-seater checks all the sports car boxes. Power comes from a 3.7L V6 that puts 330 horsepower to the rear wheels through a six-speed manual or a seven-speed automatic transmission (the auto gearbox version comes with paddle shifters). From standing still, this Nissan zooms to 60 mph in around five seconds. If that’s not fast enough you, seek out the NISMO models, which are sportier and make an extra heap of horsepower.', 72);

INSERT INTO car_rates (car_id, rate_by_hour, rate_by_day, rate_by_km) VALUES (1, 230, 2000, 56);
INSERT INTO car_rates (car_id, rate_by_hour, rate_by_day, rate_by_km) VALUES (2, 200, 1800, 60);
INSERT INTO car_rates (car_id, rate_by_hour, rate_by_day, rate_by_km) VALUES (3, 320, 2300, 75);
INSERT INTO car_rates (car_id, rate_by_hour, rate_by_day, rate_by_km) VALUES (4, 180, 1500, 50);
INSERT INTO car_rates (car_id, rate_by_hour, rate_by_day, rate_by_km) VALUES (5, 210, 2050, 45);
