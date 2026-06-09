USE railway;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE notification;
TRUNCATE TABLE reliability_history;
TRUNCATE TABLE member_payment;
TRUNCATE TABLE party_settlement;
TRUNCATE TABLE join_request;
TRUNCATE TABLE party_member;
TRUNCATE TABLE party;
TRUNCATE TABLE ott_plan;
TRUNCATE TABLE ott;
TRUNCATE TABLE member;
SET FOREIGN_KEY_CHECKS = 1;

-- member
INSERT INTO member (email, password, nickname)
VALUES
    ('user1@test.com',  '1234', '나성'),
    ('user2@test.com',  '1234', '서현'),
    ('user3@test.com',  '1234', '예빈'),
    ('user4@test.com',  '1234', '선영'),
    ('user5@test.com',  '1234', '민수'),
    ('user6@test.com',  '1234', '지우'),
    ('user7@test.com',  '1234', '하린'),
    ('user8@test.com',  '1234', '도윤'),
    ('user9@test.com',  '1234', '수빈'),
    ('user10@test.com', '1234', '현우');

-- ott
INSERT INTO ott (ott_name, image_url)
VALUES
    ('Netflix',       '/api/images/netflix.webp'),
    ('Disney+',       '/api/images/disney_plus.webp'),
    ('Wavve',         '/api/images/wavve.webp'),
    ('Tving',         '/api/images/tving.webp'),
    ('Watcha',        '/api/images/watcha.webp'),
    ('Coupang Play',  '/api/images/coupang_play.webp');

-- ott_plan
INSERT INTO ott_plan (ott_id, plan_name, monthly_price, max_members)
VALUES
    (1, 'Netflix Standard',   13500, 2),   -- plan_id 1
    (1, 'Netflix Premium',    17000, 4),   -- plan_id 2
    (2, 'Disney+ Standard',    9900, 2),   -- plan_id 3
    (2, 'Disney+ Premium',    13900, 4),   -- plan_id 4
    (3, 'Wavve Standard',     10900, 2),   -- plan_id 5
    (3, 'Wavve Premium',      13900, 4),   -- plan_id 6
    (4, 'Tving Standard',     13500, 2),   -- plan_id 7
    (4, 'Tving Premium',      17000, 4),   -- plan_id 8
    (5, 'Watcha Standard',     7900, 2),   -- plan_id 9
    (5, 'Watcha Premium',     12900, 4),   -- plan_id 10
    (6, 'Coupang Play Basic',  7890, 2);   -- plan_id 11

-- party
INSERT INTO party (
    ott_plan_id, leader_id, party_name,
    ott_account_id, ott_account_password,
    bank, bank_account, party_status, started_at
)
VALUES
    (2,  1, '넷플릭스 프리미엄 같이 봐요', 'netflix01',  'pw1111', '국민은행',   '123-456', 'CLOSED',     '2026-04-01 10:00:00'), -- party_id 1
    (1,  2, '넷플릭스 스탠다드 파티',       'netflix02',  'pw2222', '신한은행',   '222-333', 'CLOSED',     '2026-04-05 11:00:00'), -- party_id 2
    (3,  3, '디즈니 플러스 2인 파티',       'disney01',   'pw3333', '카카오뱅크', '333-444', 'CLOSED',     '2026-04-08 12:00:00'), -- party_id 3
    (4,  4, '디즈니 프리미엄 모집',         'disney02',   'pw4444', '토스뱅크',   '444-555', 'CLOSED',     '2026-04-10 13:00:00'), -- party_id 4
    (6,  5, '웨이브 프리미엄 같이 봐요',    'wavve01',    'pw5555', '우리은행',   '555-666', 'RECRUITING', '2026-05-05 14:00:00'), -- party_id 5
    (5,  6, '웨이브 스탠다드 파티',         'wavve02',    'pw6666', '하나은행',   '666-777', 'CLOSED',     '2026-04-15 09:00:00'), -- party_id 6
    (8,  7, '티빙 프리미엄 예능팟',         'tving01',    'pw7777', '농협은행',   '777-888', 'RECRUITING', '2026-05-10 12:00:00'), -- party_id 7
    (7,  8, '티빙 스탠다드 모집',           'tving02',    'pw8888', '기업은행',   '888-999', 'CLOSED',     '2026-04-20 18:30:00'), -- party_id 8
    (10, 9, '왓챠 프리미엄 파티',           'watcha01',   'pw9999', '국민은행',   '999-000', 'RECRUITING', '2026-05-15 20:00:00'), -- party_id 9
    (11,10, '쿠팡플레이 같이 써요',         'coupang01',  'pw1010', '신한은행',   '101-202', 'RECRUITING', '2026-05-20 13:40:00'); -- party_id 10

-- party_member
INSERT INTO party_member (party_id, member_id)
VALUES
(1,1),(1,2),(1,3),(1,7),
(2,2),(2,4),
(3,3),(3,5),
(4,4),(4,6),(4,7),(4,8),
(5,5),(5,1),(5,9),
(6,6),(6,10),
(7,7),(7,2),(7,4),
(8,8),(8,3),
(9,9),(9,5),(9,1),
(10,10);


-- join_request
INSERT INTO join_request (party_id, member_id, request_status, processed_at)
VALUES
(5,  2,  'PENDING',  NULL),                      -- join_request_id 1
(5,  8,  'PENDING',  NULL),                      -- join_request_id 2
(7,  6,  'PENDING',  NULL),                      -- join_request_id 3
(7,  10, 'PENDING',  NULL),                      -- join_request_id 4
(9,  2,  'PENDING',  NULL),                      -- join_request_id 5
(9,  3,  'PENDING',  NULL),                      -- join_request_id 6
(10, 3,  'PENDING',  NULL),                      -- join_request_id 7
(10, 4,  'PENDING',  NULL),                      -- join_request_id 8
(1,  5,  'REJECTED', '2026-04-01 12:00:00'),
(1,  6,  'REJECTED', '2026-04-01 12:30:00'),
(2,  6,  'REJECTED', '2026-04-05 14:00:00'),
(4,  9,  'REJECTED', '2026-04-10 15:00:00'),
(6,  8,  'REJECTED', '2026-04-15 11:00:00'),
(8,  1,  'REJECTED', '2026-04-20 20:00:00');

-- party_settlement
INSERT INTO party_settlement (party_id, target_date, target_amount, settlement_status)
VALUES
    (1,  '2026-05-01 10:00:00', 17000, 'PENDING'),    -- settlement_id 1  : party1 1회차
    (1,  '2026-06-01 10:00:00', 17000, 'PENDING'),    -- settlement_id 2  : party1 2회차
    (2,  '2026-05-05 11:00:00', 13500, 'PENDING'),    -- settlement_id 3  : party2 1회차
    (3,  '2026-05-08 12:00:00',  9900, 'PENDING'),    -- settlement_id 4  : party3 1회차
    (4,  '2026-05-10 13:00:00', 13900, 'PENDING'),    -- settlement_id 5  : party4 1회차
    (6,  '2026-05-15 09:00:00', 10900, 'PENDING'),    -- settlement_id 6  : party6 1회차 (원래 7)
    (8,  '2026-05-20 18:30:00', 13500, 'PENDING');    -- settlement_id 7  : party8 1회차 (원래 9)


-- member_payment 상태 UPDATE
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-05-01 10:30:00' WHERE party_settlement_id = 1 AND member_id = 1;
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-05-01 11:00:00' WHERE party_settlement_id = 1 AND member_id = 2;
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-05-02 09:00:00' WHERE party_settlement_id = 1 AND member_id = 3;
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-05-01 12:00:00' WHERE party_settlement_id = 1 AND member_id = 7;
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-06-01 10:30:00' WHERE party_settlement_id = 2 AND member_id = 1;
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-06-02 09:00:00' WHERE party_settlement_id = 2 AND member_id = 2;
UPDATE member_payment SET penalty_applied = TRUE WHERE party_settlement_id = 2 AND member_id IN (3, 7);
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-05-05 11:30:00' WHERE party_settlement_id = 3 AND member_id = 2;
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-05-05 12:00:00' WHERE party_settlement_id = 3 AND member_id = 4;
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-05-08 12:30:00' WHERE party_settlement_id = 4 AND member_id = 3;
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-05-08 13:00:00' WHERE party_settlement_id = 4 AND member_id = 5;
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-05-10 13:30:00' WHERE party_settlement_id = 5 AND member_id = 4;
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-05-10 14:00:00' WHERE party_settlement_id = 5 AND member_id = 6;
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-05-10 14:30:00' WHERE party_settlement_id = 5 AND member_id = 7;
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-05-10 15:00:00' WHERE party_settlement_id = 5 AND member_id = 8;
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-05-15 09:30:00' WHERE party_settlement_id = 6 AND member_id = 6;
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-05-15 10:00:00' WHERE party_settlement_id = 6 AND member_id = 10;
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-05-20 19:00:00' WHERE party_settlement_id = 7 AND member_id = 8;
UPDATE member_payment SET payment_status = 'PAID', paid_at = '2026-05-20 19:30:00' WHERE party_settlement_id = 7 AND member_id = 3;

INSERT INTO notification (
    member_id, notification_type, message, target_url, is_read
)
VALUES
(2,  'JOIN_APPROVED', '넷플릭스 프리미엄 같이 봐요 파티 가입이 승인되었습니다.',  '/parties/1', TRUE),
(3,  'JOIN_APPROVED', '넷플릭스 프리미엄 같이 봐요 파티 가입이 승인되었습니다.',  '/parties/1', TRUE),
(7,  'JOIN_APPROVED', '넷플릭스 프리미엄 같이 봐요 파티 가입이 승인되었습니다.',  '/parties/1', TRUE),
(4,  'JOIN_APPROVED', '넷플릭스 스탠다드 파티 가입이 승인되었습니다.',             '/parties/2', TRUE),
(5,  'JOIN_APPROVED', '디즈니 플러스 2인 파티 가입이 승인되었습니다.',             '/parties/3', TRUE),
(6,  'JOIN_APPROVED', '디즈니 프리미엄 모집 파티 가입이 승인되었습니다.',          '/parties/4', TRUE),
(7,  'JOIN_APPROVED', '디즈니 프리미엄 모집 파티 가입이 승인되었습니다.',          '/parties/4', TRUE),
(8,  'JOIN_APPROVED', '디즈니 프리미엄 모집 파티 가입이 승인되었습니다.',          '/parties/4', TRUE),
(1,  'JOIN_APPROVED', '웨이브 프리미엄 같이 봐요 파티 가입이 승인되었습니다.',     '/parties/5', TRUE),
(9,  'JOIN_APPROVED', '웨이브 프리미엄 같이 봐요 파티 가입이 승인되었습니다.',     '/parties/5', TRUE),
(10, 'JOIN_APPROVED', '웨이브 스탠다드 파티 가입이 승인되었습니다.',               '/parties/6', TRUE),
(2,  'JOIN_APPROVED', '티빙 프리미엄 예능팟 파티 가입이 승인되었습니다.',          '/parties/7', FALSE),
(4,  'JOIN_APPROVED', '티빙 프리미엄 예능팟 파티 가입이 승인되었습니다.',          '/parties/7', FALSE),
(3,  'JOIN_APPROVED', '티빙 스탠다드 모집 파티 가입이 승인되었습니다.',            '/parties/8', TRUE),
(5,  'JOIN_APPROVED', '왓챠 프리미엄 파티 가입이 승인되었습니다.',                 '/parties/9', FALSE),
(1,  'JOIN_APPROVED', '왓챠 프리미엄 파티 가입이 승인되었습니다.',                 '/parties/9', FALSE),

-- JOIN_REJECTED
(5,  'JOIN_REJECTED', '넷플릭스 프리미엄 같이 봐요 파티 가입 신청이 거절되었습니다.', '/parties/1', TRUE),
(6,  'JOIN_REJECTED', '넷플릭스 프리미엄 같이 봐요 파티 가입 신청이 거절되었습니다.', '/parties/1', TRUE),
(6,  'JOIN_REJECTED', '넷플릭스 스탠다드 파티 가입 신청이 거절되었습니다.',           '/parties/2', TRUE),
(9,  'JOIN_REJECTED', '디즈니 프리미엄 모집 파티 가입 신청이 거절되었습니다.',        '/parties/4', TRUE),
(8,  'JOIN_REJECTED', '웨이브 스탠다드 파티 가입 신청이 거절되었습니다.',             '/parties/6', TRUE),
(1,  'JOIN_REJECTED', '티빙 스탠다드 모집 파티 가입 신청이 거절되었습니다.',          '/parties/8', TRUE),

-- JOIN_REQUEST
(5,  'JOIN_REQUEST', '사용자 ''서현''님이 ''웨이브 프리미엄 같이 봐요'' 파티 가입을 신청했습니다.', '/join-requests/1', FALSE),
(5,  'JOIN_REQUEST', '사용자 ''도윤''님이 ''웨이브 프리미엄 같이 봐요'' 파티 가입을 신청했습니다.', '/join-requests/2', FALSE),
(7,  'JOIN_REQUEST', '사용자 ''지우''님이 ''티빙 프리미엄 예능팟'' 파티 가입을 신청했습니다.',      '/join-requests/3', FALSE),
(7,  'JOIN_REQUEST', '사용자 ''현우''님이 ''티빙 프리미엄 예능팟'' 파티 가입을 신청했습니다.',      '/join-requests/4', FALSE),
(9,  'JOIN_REQUEST', '사용자 ''서현''님이 ''왓챠 프리미엄 파티'' 파티 가입을 신청했습니다.',        '/join-requests/5', FALSE),
(9,  'JOIN_REQUEST', '사용자 ''예빈''님이 ''왓챠 프리미엄 파티'' 파티 가입을 신청했습니다.',        '/join-requests/6', FALSE),
(10, 'JOIN_REQUEST', '사용자 ''예빈''님이 ''쿠팡플레이 같이 써요'' 파티 가입을 신청했습니다.',      '/join-requests/7', FALSE),
(10, 'JOIN_REQUEST', '사용자 ''선영''님이 ''쿠팡플레이 같이 써요'' 파티 가입을 신청했습니다.',      '/join-requests/8', FALSE);
