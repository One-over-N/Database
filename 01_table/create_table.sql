CREATE DATABASE IF NOT EXISTS ott_party_db;
USE ott_party_db;

CREATE TABLE member (
    member_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nickname VARCHAR(50) NOT NULL,
    reliability_score INT NOT NULL DEFAULT 50,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ott (
    ott_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    ott_name VARCHAR(100) NOT NULL,
    image_url VARCHAR(512) NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE ott_plan (
    ott_plan_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    plan_name VARCHAR(100) NOT NULL,
    monthly_price INT NOT NULL,
    max_members INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ott_id BIGINT NOT NULL,
    FOREIGN KEY (ott_id) REFERENCES ott(ott_id) ON DELETE CASCADE
);

CREATE TABLE party (
    party_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    party_name VARCHAR(100) NOT NULL,
    ott_account_id VARCHAR(100) NOT NULL,
    ott_account_password VARCHAR(255) NOT NULL,
    bank VARCHAR(100) NOT NULL,
    bank_account VARCHAR(100) NOT NULL,
    party_status ENUM('RECRUITING', 'CLOSED') NOT NULL DEFAULT 'RECRUITING',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    started_at DATETIME NULL,
    ott_plan_id BIGINT NOT NULL,
    leader_id BIGINT NULL,
    FOREIGN KEY (ott_plan_id) REFERENCES ott_plan(ott_plan_id) ON DELETE CASCADE,
    FOREIGN KEY (leader_id) REFERENCES member(member_id) ON DELETE SET NULL
);

CREATE TABLE party_member (
    party_member_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    party_id BIGINT NOT NULL,
    member_id BIGINT NOT NULL,
    FOREIGN KEY (party_id) REFERENCES party(party_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE,
    UNIQUE (party_id, member_id)
);

CREATE TABLE join_request (
    join_request_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    request_status ENUM('PENDING', 'APPROVED', 'REJECTED') NOT NULL DEFAULT 'PENDING',
    processed_at DATETIME NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    member_id BIGINT NOT NULL,
    party_id BIGINT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE,
    FOREIGN KEY (party_id) REFERENCES party(party_id) ON DELETE CASCADE,
    UNIQUE (party_id, member_id)
);

CREATE TABLE party_settlement (
    party_settlement_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    settlement_status ENUM('PENDING', 'COMPLETED') NOT NULL DEFAULT 'PENDING',
    target_date DATETIME NOT NULL,
    target_amount INT NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    party_id BIGINT NULL,
    FOREIGN KEY (party_id) REFERENCES party(party_id) ON DELETE CASCADE
    UNIQUE (party_settlement_id, member_id)
);

CREATE TABLE member_payment (
    member_payment_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    payment_amount INT NOT NULL,
    paid_at DATETIME NULL,
    payment_status ENUM('PAID', 'UNPAID') NOT NULL DEFAULT 'UNPAID',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    penalty_applied BOOLEAN NOT NULL DEFAULT FALSE,
    party_settlement_id BIGINT NULL,
    member_id BIGINT NULL,
    FOREIGN KEY (party_settlement_id) REFERENCES party_settlement(party_settlement_id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
);

CREATE TABLE reliability_history (
    reliability_history_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    change_score INT NOT NULL,
    after_score INT NOT NULL,
    reason VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    member_id BIGINT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
);

CREATE TABLE notification (
    notification_id BIGINT AUTO_INCREMENT PRIMARY KEY,
    notification_type ENUM('PAYMENT_REQUEST', 'JOIN_REQUEST', 'JOIN_APPROVED') NOT NULL,
    content VARCHAR(255) NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    target_url VARCHAR(255) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    member_id BIGINT NOT NULL,
    FOREIGN KEY (member_id) REFERENCES member(member_id) ON DELETE CASCADE
);
