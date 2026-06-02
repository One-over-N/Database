CREATE DATABASE IF NOT EXISTS ott_party_db;
USE ott_party_db;

CREATE TABLE member (
    member_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nickname VARCHAR(50) NOT NULL,
    reliability_score INT DEFAULT 50,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ott (
    ott_service_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(50) NOT NULL,
    image_url VARCHAR(255)
);

CREATE TABLE ott_plan (
    ott_plan_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ott_service_id BIGINT NOT NULL,
    plan_name VARCHAR(100) NOT NULL,
    monthly_price INT NOT NULL,
    max_members INT NOT NULL,
    FOREIGN KEY (ott_service_id) REFERENCES ott(ott_service_id)
);

CREATE TABLE party (
    party_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ott_plan_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    party_name VARCHAR(100) NOT NULL,
    ott_account_id VARCHAR(100),
    ott_account_pw VARCHAR(100),
    bank_account VARCHAR(100),
    party_status ENUM('recruiting', 'closed') DEFAULT 'recruiting',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ott_plan_id) REFERENCES ott_plan(ott_plan_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id)
);

CREATE TABLE party_member (
    party_member_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    party_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    joined_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (party_id) REFERENCES party(party_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id),
    UNIQUE (party_id, member_id)
);

CREATE TABLE join_request (
    join_request_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    party_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    request_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    requested_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (party_id) REFERENCES party(party_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id),
    UNIQUE (party_id, member_id)
);

CREATE TABLE party_settlement (
    settlement_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    party_id BIGINT NOT NULL,
    settlement_month VARCHAR(7) NOT NULL,
    total_amount INT NOT NULL,
    settlement_status ENUM('pending', 'completed') DEFAULT 'pending',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (party_id) REFERENCES party(party_id),
    UNIQUE (party_id, settlement_month)
);

CREATE TABLE member_payment (
    payment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    settlement_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    payment_amount INT NOT NULL,
    payment_status ENUM('paid', 'unpaid') DEFAULT 'unpaid',
    payment_date DATETIME,
    FOREIGN KEY (settlement_id) REFERENCES party_settlement(settlement_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id),
    UNIQUE (settlement_id, member_id)
);

CREATE TABLE reliability_history (
    reliability_history_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    member_id BIGINT NOT NULL,
    before_score INT NOT NULL,
    change_score INT NOT NULL,
    after_score INT NOT NULL,
    reason VARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES member(member_id)
);

CREATE TABLE notification (
    notification_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    member_id BIGINT NOT NULL,
    notification_type ENUM('payment_request', 'join_request', 'join_approved') NOT NULL,
    message VARCHAR(255) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES member(member_id)
);
