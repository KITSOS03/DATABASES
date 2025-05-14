CREATE DATABASE db1;
USE db1;

CREATE TABLE Location (
    location_id INT AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL, 
    address VARCHAR(255), 
    city VARCHAR(100), 
    country VARCHAR(100), 
    continent VARCHAR(50), 
    latitude DECIMAL(11,8), 
    longitude DECIMAL(11,8), 
    PRIMARY KEY(location_id)
);

CREATE TABLE Festival (
    festival_id INT AUTO_INCREMENT, 
    name VARCHAR(255) NOT NULL, 
    festival_year INT NOT NULL, 
    festival_image LONGBLOB, 
    location_id INT, 
    PRIMARY KEY(festival_id), 
    FOREIGN KEY(location_id) REFERENCES Location(location_id) ON DELETE RESTRICT
);

CREATE TABLE Stage (
    stage_id INT AUTO_INCREMENT, 
    name VARCHAR(255) NOT NULL, 
    description TEXT, 
    capacity INT NOT NULL, 
    location_id INT, 
    PRIMARY KEY(stage_id), 
    FOREIGN KEY(location_id) REFERENCES Location(location_id) ON DELETE RESTRICT
);

CREATE TABLE Event (
    event_id INT AUTO_INCREMENT, 
    name VARCHAR(255) NOT NULL, 
    date_time DATETIME NOT NULL, 
    festival_id INT, 
    stage_id INT, 
    PRIMARY KEY(event_id), 
    FOREIGN KEY(festival_id) REFERENCES Festival(festival_id) ON DELETE CASCADE, 
    FOREIGN KEY(stage_id)   REFERENCES Stage(stage_id)     ON DELETE RESTRICT
);

CREATE TABLE Artist (
    artist_id INT AUTO_INCREMENT, 
    first_name VARCHAR(255) NOT NULL, 
    last_name VARCHAR(255) NOT NULL, 
    stage_name VARCHAR(255), 
    birth_date DATE, 
    genre VARCHAR(255), 
    sub_genre VARCHAR(255), 
    instagram VARCHAR(255), 
    website VARCHAR(255), 
    artist_image LONGBLOB, 
    PRIMARY KEY(artist_id)
);

CREATE TABLE Band (
    band_id INT AUTO_INCREMENT, 
    name VARCHAR(255) NOT NULL, 
    formation_date DATE, 
    instagram VARCHAR(255), 
    website VARCHAR(255), 
    PRIMARY KEY(band_id)
);

CREATE TABLE Artist_Band (
    artist_id INT, 
    band_id   INT, 
    PRIMARY KEY(artist_id, band_id), 
    FOREIGN KEY(artist_id) REFERENCES Artist(artist_id) ON DELETE CASCADE, 
    FOREIGN KEY(band_id)   REFERENCES Band(band_id)     ON DELETE CASCADE
);

CREATE TABLE Performance_Type (
    type_id INT AUTO_INCREMENT,
    name    VARCHAR(50),
    PRIMARY KEY(type_id)
);

CREATE TABLE Performance (
    performance_id INT AUTO_INCREMENT,
    type_id        INT,
    start_time     DATETIME NOT NULL,
    duration       INT CHECK(duration BETWEEN 1 AND 180),
    event_id       INT,
    artist_id      INT,
    band_id        INT,
    PRIMARY KEY(performance_id),
    
    
    FOREIGN KEY(type_id)   REFERENCES Performance_Type(type_id) ON DELETE RESTRICT,
    FOREIGN KEY(event_id)  REFERENCES Event(event_id)           ON DELETE CASCADE,
    FOREIGN KEY(artist_id) REFERENCES Artist(artist_id)         ON DELETE CASCADE,
    FOREIGN KEY(band_id)   REFERENCES Band(band_id)             ON DELETE CASCADE,

    
    CONSTRAINT chk_artist_or_band
      CHECK (
        (artist_id IS NOT NULL AND band_id IS NULL)
        OR
        (artist_id IS NULL     AND band_id IS NOT NULL)
      )
);

CREATE TABLE Visitor (
    visitor_id   INT AUTO_INCREMENT, 
    first_name   VARCHAR(255) NOT NULL, 
    last_name    VARCHAR(255) NOT NULL, 
    age          INT CHECK(age >= 0), 
    contact_info VARCHAR(255), 
    PRIMARY KEY(visitor_id)
);

CREATE TABLE Ticket_Category (
    category_id INT AUTO_INCREMENT,
    name        VARCHAR(50),
    PRIMARY KEY(category_id)    
);

CREATE TABLE Payment_Method (
    payment_method_id INT AUTO_INCREMENT,
    name              VARCHAR(50),
    PRIMARY KEY(payment_method_id)    
);

CREATE TABLE Ticket (
    ticket_id         INT AUTO_INCREMENT, 
    category_id       INT, 
    purchase_date     DATETIME NOT NULL, 
    price             DECIMAL(10,2) NOT NULL, 
    payment_method_id INT, 
    EAN13_code        VARCHAR(13) UNIQUE NOT NULL, 
    is_activated      BOOLEAN DEFAULT FALSE, 
    event_id          INT, 
    visitor_id        INT, 
    PRIMARY KEY(ticket_id), 
    FOREIGN KEY(category_id)       REFERENCES Ticket_Category(category_id) ON DELETE RESTRICT,
    FOREIGN KEY(payment_method_id) REFERENCES Payment_Method(payment_method_id) ON DELETE RESTRICT,
    FOREIGN KEY(event_id)          REFERENCES Event(event_id)           ON DELETE CASCADE, 
    FOREIGN KEY(visitor_id)        REFERENCES Visitor(visitor_id)       ON DELETE RESTRICT
);

CREATE TABLE Review (
    review_id             INT AUTO_INCREMENT, 
    performance_score     INT CHECK(performance_score BETWEEN 1 and 5), 
    organization_score    INT CHECK(organization_score BETWEEN 1 and 5), 
    sound_lighting_score  INT CHECK(sound_lighting_score BETWEEN 1 and 5), 
    stage_presence_score  INT CHECK(stage_presence_score BETWEEN 1 and 5), 
    overall_score         INT CHECK(overall_score BETWEEN 1 and 5), 
    ticket_id             INT, 
    PRIMARY KEY(review_id), 
    FOREIGN KEY(ticket_id) REFERENCES Ticket(ticket_id) ON DELETE RESTRICT
);

CREATE TABLE Resale_Status (
    status_id INT AUTO_INCREMENT,
    name      VARCHAR(50),
    PRIMARY KEY(status_id)
);

CREATE TABLE Resale_queue (
    resale_id  INT AUTO_INCREMENT, 
    status_id  INT DEFAULT 1, 
    queue_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, 
    ticket_id  INT UNIQUE, 
    PRIMARY KEY(resale_id), 
    FOREIGN KEY(status_id) REFERENCES Resale_Status(status_id) ON DELETE RESTRICT,
    FOREIGN KEY(ticket_id) REFERENCES Ticket(ticket_id)      ON DELETE CASCADE
);

CREATE TABLE Staff_Role (
    role_id INT AUTO_INCREMENT,
    name    VARCHAR(50),
    PRIMARY KEY(role_id)
);

CREATE TABLE Experience_Level (
    experience_level_id INT AUTO_INCREMENT,
    degree              INT,
    PRIMARY KEY(experience_level_id)
);

CREATE TABLE Staff (
    staff_id             INT AUTO_INCREMENT, 
    first_name           VARCHAR(255) NOT NULL, 
    last_name            VARCHAR(255) NOT NULL, 
    age                  INT CHECK(age >= 18), 
    role_id              INT,
    experience_level_id  INT,
    PRIMARY KEY(staff_id),
    FOREIGN KEY(role_id)              REFERENCES Staff_Role(role_id)        ON DELETE RESTRICT,
    FOREIGN KEY(experience_level_id)  REFERENCES Experience_Level(experience_level_id) ON DELETE RESTRICT
);

CREATE TABLE Employment (
    staff_id INT,
    event_id INT,
    PRIMARY KEY(staff_id, event_id),
    FOREIGN KEY(staff_id) REFERENCES Staff(staff_id) ON DELETE CASCADE,
    FOREIGN KEY(event_id) REFERENCES Event(event_id) ON DELETE CASCADE
);

CREATE TABLE Equipment_Type (
    equipment_type_id INT AUTO_INCREMENT,
    name              VARCHAR(50),
    PRIMARY KEY(equipment_type_id)
);

CREATE TABLE Equipment (
    equipment_id      INT AUTO_INCREMENT, 
    name              VARCHAR(255) NOT NULL, 
    equipment_type_id INT, 
    description       TEXT, 
    quantity          INT NOT NULL CHECK(quantity>=1), 
    PRIMARY KEY(equipment_id),
    FOREIGN KEY(equipment_type_id) REFERENCES Equipment_Type(equipment_type_id) ON DELETE RESTRICT
);

CREATE TABLE Stage_Equipment (
    stage_id     INT, 
    equipment_id INT, 
    quantity     INT NOT NULL CHECK(quantity>=1), 
    PRIMARY KEY(stage_id, equipment_id),  
    FOREIGN KEY(stage_id)     REFERENCES Stage(stage_id)     ON DELETE RESTRICT, 
    FOREIGN KEY(equipment_id) REFERENCES Equipment(equipment_id) ON DELETE RESTRICT
);

CREATE INDEX idx_performance_artist       ON Performance(artist_id);
CREATE INDEX idx_performance_event        ON Performance(event_id);
CREATE INDEX idx_ticket_event             ON Ticket(event_id);
CREATE INDEX idx_review_ticket            ON Review(ticket_id);
CREATE INDEX idx_artist_id                ON Artist(artist_id);
CREATE INDEX idx_ticket_visitor_event     ON Ticket(visitor_id, event_id);
CREATE INDEX idx_event_festival           ON Event(festival_id);

-- Stored Procedures & Triggers 

-- 1) Procedure staff_validation
DELIMITER $$
CREATE PROCEDURE staff_validation(IN e_id INT)
BEGIN 
    DECLARE total_capacity INT DEFAULT 0; 
    DECLARE required_security INT;
    DECLARE required_support INT;
    DECLARE actual_security INT;
    DECLARE actual_support INT;

    SELECT SUM(s.capacity) INTO total_capacity
    FROM Event e
    JOIN Stage s ON e.stage_id = s.stage_id
    WHERE e.event_id = e_id;

    SET required_security = CEIL(total_capacity * 0.05);
    SET required_support  = CEIL(total_capacity * 0.02);

    SELECT COUNT(*) INTO actual_security
    FROM Employment em
    JOIN Staff st      ON em.staff_id = st.staff_id
    JOIN Staff_Role sr ON st.role_id = sr.role_id
    WHERE em.event_id = e_id
      AND UPPER(sr.name) = 'SECURITY';

    SELECT COUNT(*) INTO actual_support
    FROM Employment em
    JOIN Staff st      ON em.staff_id = st.staff_id
    JOIN Staff_Role sr ON st.role_id = sr.role_id
    WHERE em.event_id = e_id
      AND UPPER(sr.name) = 'SUPPORT';

    IF actual_security < required_security THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Security Staff Is Not Enough';
    END IF; 

    IF actual_support < required_support THEN 
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Support Staff Is Not Enough';
    END IF; 
END$$
DELIMITER ;

-- 2) Procedure Call_Staff_Validation
DELIMITER $$
CREATE PROCEDURE Call_Staff_Validation(IN n INT)
BEGIN 
    DECLARE i INT DEFAULT 1;
    WHILE i <= n DO 
        CALL staff_validation(n);
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;

-- 3) Trigger Check_vip_ticket
DELIMITER $$
CREATE TRIGGER Check_vip_ticket
BEFORE INSERT ON Ticket
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Ticket_Category tc
        WHERE tc.category_id = NEW.category_id
          AND UPPER(tc.name) = 'VIP'
    ) THEN 
        IF (
            SELECT COUNT(*) + 1
            FROM Ticket t
            JOIN Event e   ON t.event_id = e.event_id
            JOIN Stage s   ON e.stage_id = s.stage_id
            JOIN Ticket_Category tc ON t.category_id = tc.category_id
            WHERE UPPER(tc.name) = 'VIP'
              AND e.stage_id = (
                  SELECT stage_id
                  FROM Event
                  WHERE event_id = NEW.event_id
              )
        ) > (
            SELECT CEIL(s.capacity * 0.1)
            FROM Event e
            JOIN Stage s ON e.stage_id = s.stage_id
            WHERE e.event_id = NEW.event_id
        ) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VIP ticket limit exceeded';
        END IF;
    END IF;
END$$
DELIMITER ;

-- 4) Trigger Check_stage_capacity
DELIMITER $$
CREATE TRIGGER Check_stage_capacity
BEFORE INSERT ON Ticket
FOR EACH ROW
BEGIN
    DECLARE v_stage_id     INT;
    DECLARE v_capacity     INT;
    DECLARE v_sold_tickets INT;

    SELECT e.stage_id INTO v_stage_id
    FROM Event e
    WHERE e.event_id = NEW.event_id;

    SELECT s.capacity INTO v_capacity
    FROM Stage s
    WHERE s.stage_id = v_stage_id;

    SELECT COALESCE(SUM(IF(is_activated,1,0)),0) INTO v_sold_tickets
    FROM Ticket t
    WHERE t.event_id = NEW.event_id;

    IF v_sold_tickets + 1 > v_capacity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot sell more tickets. Capacity is over.';
    END IF;
END$$
DELIMITER ;

DELIMITER $$

CREATE TRIGGER Check_duplicate_ticket
BEFORE INSERT ON Ticket
FOR EACH ROW
BEGIN
    DECLARE event_date DATE;
    DECLARE existing_ticket_id INT DEFAULT NULL;

    -- Λήψη ημερομηνίας του event
    SELECT DATE(e.date_time)
    INTO event_date
    FROM Event e
    WHERE e.event_id = NEW.event_id;

    -- Έλεγχος για διπλό εισιτήριο
    SELECT t.ticket_id
    INTO existing_ticket_id
    FROM Ticket t
    JOIN Event e2 ON t.event_id = e2.event_id
    WHERE t.visitor_id = NEW.visitor_id
      AND DATE(e2.date_time) = event_date
    LIMIT 1;

    -- Εμφάνιση γενικού σφάλματος (χωρίς δυναμικές τιμές)
    IF existing_ticket_id IS NOT NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Duplicate ticket for same visitor on the same day.';
    END IF;
END$$

DELIMITER ;

-- 6) Trigger Check_artist_double_performance
DELIMITER $$
CREATE TRIGGER Check_artist_double_performance
BEFORE INSERT ON Performance
FOR EACH ROW
BEGIN
    DECLARE event_dt DATETIME;
    SELECT e.date_time INTO event_dt
    FROM Event e
    WHERE e.event_id = NEW.event_id;

    IF EXISTS (
        SELECT 1
        FROM Performance p
        JOIN Event e2 ON p.event_id = e2.event_id
        WHERE p.artist_id = NEW.artist_id
          AND e2.stage_id <> (
              SELECT stage_id FROM Event WHERE event_id = NEW.event_id
          )
          AND e2.date_time = event_dt
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Artist cannot perform on two stages at the same time';
    END IF;
END$$
DELIMITER ;

-- 7) Trigger No_4th_continuous_year (παράδειγμα για καλλιτέχη ή συγκρότημα)
DELIMITER $$
CREATE TRIGGER No_4th_continuous_year
BEFORE INSERT ON Performance
FOR EACH ROW
BEGIN
    DECLARE v_year INT;
    SELECT f.festival_year INTO v_year
    FROM Event e
    JOIN Festival f ON e.festival_id = f.festival_id
    WHERE e.event_id = NEW.event_id;

    IF NEW.artist_id IS NOT NULL THEN
        IF EXISTS(
            SELECT 1
            FROM Performance p
            JOIN Event e1 ON p.event_id = e1.event_id
            JOIN Festival f1 ON e1.festival_id = f1.festival_id
            WHERE p.artist_id = NEW.artist_id
              AND f1.festival_year = v_year - 1
        )
        AND EXISTS(
            SELECT 1
            FROM Performance p
            JOIN Event e2 ON p.event_id = e2.event_id
            JOIN Festival f2 ON e2.festival_id = f2.festival_id
            WHERE p.artist_id = NEW.artist_id
              AND f2.festival_year = v_year - 2
        )
        AND EXISTS(
            SELECT 1
            FROM Performance p
            JOIN Event e3 ON p.event_id = e3.event_id
            JOIN Festival f3 ON e3.festival_id = f3.festival_id
            WHERE p.artist_id = NEW.artist_id
              AND f3.festival_year = v_year - 3
        ) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Artist cannot perform for 4th continuous year';
        END IF;
    END IF;

    IF NEW.band_id IS NOT NULL THEN
        IF EXISTS(
            SELECT 1
            FROM Performance p
            JOIN Event e1 ON p.event_id = e1.event_id
            JOIN Festival f1 ON e1.festival_id = f1.festival_id
            WHERE p.band_id = NEW.band_id
              AND f1.festival_year = v_year - 1
        )
        AND EXISTS(
            SELECT 1
            FROM Performance p
            JOIN Event e2 ON p.event_id = e2.event_id
            JOIN Festival f2 ON e2.festival_id = f2.festival_id
            WHERE p.band_id = NEW.band_id
              AND f2.festival_year = v_year - 2
        )
        AND EXISTS(
            SELECT 1
            FROM Performance p
            JOIN Event e3 ON p.event_id = e3.event_id
            JOIN Festival f3 ON e3.festival_id = f3.festival_id
            WHERE p.band_id = NEW.band_id
              AND f3.festival_year = v_year - 3
        ) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Band cannot perform for 4th continuous year';
        END IF;
    END IF;
END$$
DELIMITER ;

DELIMITER $$

DELIMITER $$



DELIMITER $$
CREATE PROCEDURE Call_All_Staff_Validation()
BEGIN
  DECLARE ev_id INT DEFAULT 0;
  DECLARE max_e INT;

  SELECT MAX(event_id) INTO max_e FROM Event;
  WHILE ev_id < max_e DO
    SET ev_id = ev_id + 1;
    CALL staff_validation(ev_id);
  END WHILE;
END$$
DELIMITER ;
