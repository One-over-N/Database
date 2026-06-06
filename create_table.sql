CREATE DATABASE IF NOT EXISTS ott_party_db;
USE ott_party_db;

CREATE TABLE member (
    member_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nickname VARCHAR(50) NOT NULL,
    reliability_score INT DEFAULT 50,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ott (
    ott_service_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    service_name VARCHAR(50) NOT NULL,
    image_url VARCHAR(255),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ott_plan (
    ott_plan_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ott_service_id BIGINT NOT NULL,
    plan_name VARCHAR(100) NOT NULL,
    monthly_price INT NOT NULL,
    max_members INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ott_service_id) REFERENCES ott(ott_service_id)
);

CREATE TABLE party (
    party_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ott_plan_id BIGINT NOT NULL,
    leader_id BIGINT NOT NULL,
    party_name VARCHAR(100) NOT NULL,
    ott_account_id VARCHAR(100) NOT NULL,
    ott_account_password VARCHAR(255) NOT NULL,
    bank VARCHAR(100) NOT NULL,
    bank_account VARCHAR(100) NOT NULL,
    party_status ENUM('RECRUITING', 'CLOSED') DEFAULT 'RECRUITING',
    started_at DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ott_plan_id) REFERENCES ott_plan(ott_plan_id),
    FOREIGN KEY (leader_id) REFERENCES member(member_id)
);

CREATE TABLE party_member (
    party_member_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    party_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    joined_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (party_id) REFERENCES party(party_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id),
    UNIQUE (party_id, member_id),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE join_request (
    join_request_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    party_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    request_status ENUM('PENDING', 'APPROVED', 'REJECTED') DEFAULT 'PENDING',
    requested_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (party_id) REFERENCES party(party_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id),
    UNIQUE (party_id, member_id),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE party_settlement (
    party_settlement_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    party_id BIGINT NOT NULL,
    settlement_month VARCHAR(7) NOT NULL,
    total_amount INT NOT NULL,
    settlement_status ENUM('PENDING', 'COMPLETED') DEFAULT 'PENDING',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (party_id) REFERENCES party(party_id),
    UNIQUE (party_id, settlement_month)
);

CREATE TABLE member_payment (
    member_payment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    party_settlement_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    payment_amount INT NOT NULL,
    payment_status ENUM('PAID', 'UNPAID') DEFAULT 'UNPAID',
    payment_date DATETIME,
    penalty_applied BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (party_settlement_id) REFERENCES party_settlement(party_settlement_id),
    FOREIGN KEY (member_id) REFERENCES member(member_id),
    UNIQUE (party_settlement_id, member_id),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reliability_history (
    reliability_history_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    member_id BIGINT NOT NULL,
    before_score INT NOT NULL,
    change_score INT NOT NULL,
    after_score INT NOT NULL,
    reason VARCHAR(100) NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES member(member_id)
);

CREATE TABLE notification (
    notification_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    member_id BIGINT NOT NULL,
    notification_type ENUM('PAYMENT_REQUEST', 'JOIN_REQUEST', 'JOIN_APPROVED') NOT NULL,
    content VARCHAR(255) NOT NULL,
    target_url VARCHAR(255) NOT NULL,
    is_read BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES member(member_id)
);
