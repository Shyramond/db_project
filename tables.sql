CREATE TABLE Trainers (
    trainer_id INT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE Classes (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(100) NOT NULL,
    capacity INT NOT NULL
);

CREATE TABLE ClassSchedule (
    schedule_id INT PRIMARY KEY,
    class_id INT NOT NULL,
    trainer_id INT NOT NULL,
    day_of_week VARCHAR(20) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (class_id) REFERENCES Classes(class_id),
    FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id)
);

CREATE TABLE Clients (
    client_id INT PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    phone_number VARCHAR(20) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    registration_date DATE NOT NULL,
    medical_conditions TEXT
);

CREATE TABLE Memberships (
    membership_id INT PRIMARY KEY,
    membership_type VARCHAR(100) NOT NULL,
    duration INT NOT NULL
);

CREATE TABLE MembershipPriceHistory (
    price_history_id INT PRIMARY KEY,
    membership_id INT NOT NULL,
    price INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    FOREIGN KEY (membership_id) REFERENCES Memberships(membership_id)
);

CREATE TABLE ClassEnrollments (
    enrollment_id INT PRIMARY KEY,
    schedule_id INT NOT NULL,
    client_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL,
    FOREIGN KEY (schedule_id) REFERENCES ClassSchedule(schedule_id),
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    UNIQUE (schedule_id, client_id)
);

CREATE TABLE ClientMemberships (
    client_membership_id INT PRIMARY KEY,
    client_id INT NOT NULL,
    membership_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    remaining_sessions INT,
    FOREIGN KEY (client_id) REFERENCES Clients(client_id),
    FOREIGN KEY (membership_id) REFERENCES Memberships(membership_id)
);

CREATE TABLE TrainerSalaryHistory (
    salary_history_id INT PRIMARY KEY,
    trainer_id INT NOT NULL,
    salary INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    FOREIGN KEY (trainer_id) REFERENCES Trainers(trainer_id)
);

