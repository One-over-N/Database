USE ott_party_db;

INSERT INTO member (email, password, nickname, reliability_score)
VALUES
('user1@test.com', '1234', '나성', 80),
('user2@test.com', '1234', '서현', 95),
('user3@test.com', '1234', '예빈', 70),
('user4@test.com', '1234', '선영', 60),
('user5@test.com', '1234', '민수', 50),
('user6@test.com', '1234', '지우', 40);

INSERT INTO ott (service_name, image_url)
VALUES
('Netflix', '/images/netflix.webp'),
('Disney+', '/images/disney_plus.webp'),
('Wavve', '/images/wavve.webp'),
('Tving', '/images/tving.webp'),
('Watcha', '/images/watcha.webp'),
('Coupang Play', '/images/coupang_play.webp');

INSERT INTO ott_plan (ott_service_id, plan_name, monthly_price, max_members)
VALUES
(1, 'Netflix Premium', 17000, 4),
(2, 'Disney+ Standard', 9900, 2),
(3, 'Wavve Premium', 13900, 4),
(4, 'Tving Standard', 13500, 4),
(5, 'Watcha Premium', 12900, 4),
(6, 'Coupang Play Basic', 7890, 2);

INSERT INTO party (
    ott_plan_id, member_id, party_name,
    ott_account_id, ott_account_pw, bank_account, party_status
)
VALUES
(1,1,'넷플릭스 같이 봐요','netflix01','pw1111','국민 123-456','RECRUITING'),
(2,2,'디즈니 플러스 파티','disney01','pw2222','신한 222-333','RECRUITING'),
(3,3,'웨이브 드라마 파티','wavve01','pw3333','우리 333-444','CLOSED'),
(4,4,'티빙 예능 파티','tving01','pw4444','하나 444-555','RECRUITING');

INSERT INTO party_member (party_id, member_id)
VALUES
(1,1),
(1,2),
(2,2),
(2,3),
(3,3),
(3,4),
(3,5),
(4,4);

INSERT INTO join_request (party_id, member_id, request_status)
VALUES
(1,3,'PENDING'),
(1,4,'APPROVED'),
(2,5,'PENDING'),
(2,6,'REJECTED'),
(4,1,'PENDING');

INSERT INTO party_settlement (party_id, settlement_month, total_amount, settlement_status)
VALUES
(1, '2026-05', 17000, 'PENDING'),
(2, '2026-05', 9900, 'COMPLETED'),
(3, '2026-05', 13900, 'PENDING'),
(4, '2026-05', 13500, 'PENDING');

INSERT INTO member_payment (
    settlement_id, member_id, payment_amount, payment_status, payment_date
)
VALUES
(1, 1, 4250, 'PAID', '2026-05-10 10:00:00'),
(1, 2, 4250, 'PAID', '2026-05-10 10:30:00'),
(1, 3, 4250, 'UNPAID', NULL),
(2, 2, 4950, 'PAID', '2026-05-05 09:00:00'),
(2, 3, 4950, 'PAID', '2026-05-05 09:30:00');

INSERT INTO reliability_history (
    member_id, before_score, change_score, after_score, reason
)
VALUES
(1, 75, 5, 80, '정상 납부'),
(2, 100, -5, 95, '납부 지연'),
(3, 80, -10, 70, '미납 발생'),
(4, 50, 10, 60, '정상 납부'),
(5, 50, 0, 50, '가입 대기'),
(6, 50, -10, 40, '가입 거절');

INSERT INTO notification (
    member_id, notification_type, message, is_read
)
VALUES
(1, 'PAYMENT_REQUEST', '2026년 5월 정산 요청이 도착했습니다.', FALSE),
(2, 'JOIN_REQUEST', '새로운 파티 가입 신청이 있습니다.', FALSE),
(3, 'JOIN_APPROVED', '파티 가입 신청이 승인되었습니다.', TRUE),
(4, 'PAYMENT_REQUEST', '미납된 정산 내역이 있습니다.', FALSE),
(5, 'JOIN_REQUEST', '가입 신청이 접수되었습니다.', TRUE);
