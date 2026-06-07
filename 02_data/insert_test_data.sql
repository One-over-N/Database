USE railway;

INSERT INTO member (email, password, nickname, reliability_score)
VALUES
('user1@test.com', '1234', '나성', 80),
('user2@test.com', '1234', '서현', 95),
('user3@test.com', '1234', '예빈', 70),
('user4@test.com', '1234', '선영', 60),
('user5@test.com', '1234', '민수', 50),
('user6@test.com', '1234', '지우', 40),
('user7@test.com', '1234', '하린', 88),
('user8@test.com', '1234', '도윤', 76),
('user9@test.com', '1234', '수빈', 65),
('user10@test.com', '1234', '현우', 92);

INSERT INTO ott (ott_name, image_url)
VALUES
('Netflix', '/images/netflix.webp'),
('Disney+', '/images/disney_plus.webp'),
('Wavve', '/images/wave.webp'),
('Tving', '/images/tving.webp'),
('Watcha', '/images/watcha.webp'),
('Coupang Play', '/images/coupang_play.webp');

INSERT INTO ott_plan (ott_id, plan_name, monthly_price, max_members)
VALUES
(1, 'Netflix Standard', 13500, 2),
(1, 'Netflix Premium', 17000, 4),
(2, 'Disney+ Standard', 9900, 2),
(2, 'Disney+ Premium', 13900, 4),
(3, 'Wavve Basic', 7900, 1),
(3, 'Wavve Standard', 10900, 2),
(3, 'Wavve Premium', 13900, 4),
(4, 'Tving Basic', 9500, 1),
(4, 'Tving Standard', 13500, 2),
(4, 'Tving Premium', 17000, 4),
(5, 'Watcha Basic', 7900, 1),
(5, 'Watcha Premium', 12900, 4),
(6, 'Coupang Play Basic', 7890, 1);

INSERT INTO party (
    ott_plan_id, leader_id, party_name,
    ott_account_id, ott_account_password,
    bank, bank_account, party_status, started_at
)
VALUES
(2, 1, '넷플릭스 프리미엄 같이 봐요', 'netflix01', 'pw1111', '국민은행', '123-456', 'RECRUITING', '2026-05-01 10:00:00'),
(1, 2, '넷플릭스 스탠다드 파티', 'netflix02', 'pw2222', '신한은행', '222-333', 'RECRUITING', '2026-05-02 11:00:00'),
(3, 3, '디즈니 플러스 2인 파티', 'disney01', 'pw3333', '카카오뱅크', '333-444', 'RECRUITING', '2026-05-03 12:00:00'),
(4, 4, '디즈니 프리미엄 모집', 'disney02', 'pw4444', '토스뱅크', '444-555', 'CLOSED', '2026-05-04 13:00:00'),
(7, 5, '웨이브 드라마 같이 봐요', 'wavve01', 'pw5555', '우리은행', '555-666', 'RECRUITING', '2026-05-05 14:00:00'),
(6, 6, '웨이브 스탠다드 파티', 'wavve02', 'pw6666', '하나은행', '666-777', 'RECRUITING', '2026-05-07 09:00:00'),
(10, 7, '티빙 프리미엄 예능팟', 'tving01', 'pw7777', '농협은행', '777-888', 'RECRUITING', '2026-05-10 12:00:00'),
(9, 8, '티빙 스탠다드 모집', 'tving02', 'pw8888', '기업은행', '888-999', 'CLOSED', '2026-05-12 18:30:00'),
(12, 9, '왓챠 프리미엄 파티', 'watcha01', 'pw9999', '국민은행', '999-000', 'RECRUITING', '2026-05-15 20:00:00'),
(13, 10, '쿠팡플레이 같이 써요', 'coupang01', 'pw1010', '신한은행', '101-202', 'RECRUITING', '2026-05-20 13:40:00');

INSERT INTO party_member (party_id, member_id)
VALUES
(1,1), (1,2), (1,3),
(2,2), (2,4),
(3,3), (3,5),
(4,4), (4,6), (4,7), (4,8),
(5,5), (5,1), (5,9),
(6,6), (6,10),
(7,7), (7,2), (7,4),
(8,8), (8,3),
(9,9), (9,5),
(10,10);

INSERT INTO join_request (party_id, member_id, request_status, processed_at)
VALUES
(1,4,'PENDING',NULL),
(1,5,'APPROVED','2026-05-21 11:30:00'),
(2,6,'PENDING',NULL),
(2,7,'REJECTED','2026-05-22 10:50:00'),
(3,8,'PENDING',NULL),
(5,10,'APPROVED','2026-05-24 15:20:00'),
(6,1,'PENDING',NULL),
(7,9,'REJECTED','2026-05-25 16:40:00'),
(9,2,'PENDING',NULL),
(10,3,'PENDING',NULL);

INSERT INTO party_settlement (party_id, target_date, target_amount, settlement_status)
VALUES
(1, '2026-05-25 00:00:00', 17000, 'PENDING'),
(2, '2026-05-25 00:00:00', 13500, 'COMPLETED'),
(3, '2026-05-25 00:00:00', 9900, 'PENDING'),
(4, '2026-05-25 00:00:00', 13900, 'COMPLETED'),
(5, '2026-05-25 00:00:00', 13900, 'PENDING'),
(6, '2026-05-25 00:00:00', 10900, 'PENDING'),
(7, '2026-05-25 00:00:00', 17000, 'PENDING'),
(8, '2026-05-25 00:00:00', 13500, 'COMPLETED'),
(9, '2026-05-25 00:00:00', 12900, 'PENDING'),
(10, '2026-05-25 00:00:00', 7890, 'PENDING'),
(1, '2026-06-25 00:00:00', 17000, 'PENDING'),
(5, '2026-06-25 00:00:00', 13900, 'PENDING');

INSERT INTO member_payment (
    party_settlement_id, member_id, payment_amount, payment_status, paid_at, penalty_applied
)
VALUES
(1,1,4250,'PAID','2026-05-10 10:00:00',FALSE),
(1,2,4250,'PAID','2026-05-10 10:30:00',FALSE),
(1,3,4250,'UNPAID',NULL,FALSE),
(2,2,6750,'PAID','2026-05-11 09:00:00',FALSE),
(2,4,6750,'PAID','2026-05-11 09:30:00',FALSE),
(3,3,4950,'UNPAID',NULL,FALSE),
(3,5,4950,'PAID','2026-05-12 16:00:00',FALSE),
(4,4,3475,'PAID','2026-05-13 10:00:00',FALSE),
(4,6,3475,'PAID','2026-05-13 11:00:00',FALSE),
(4,7,3475,'PAID','2026-05-13 11:30:00',FALSE),
(4,8,3475,'PAID','2026-05-13 12:00:00',FALSE),
(5,5,3475,'PAID','2026-05-14 09:00:00',FALSE),
(5,1,3475,'UNPAID',NULL,TRUE),
(5,9,3475,'PAID','2026-05-14 09:30:00',FALSE),
(6,6,5450,'UNPAID',NULL,FALSE),
(6,10,5450,'PAID','2026-05-15 17:00:00',FALSE),
(7,7,4250,'PAID','2026-05-16 13:00:00',FALSE),
(7,2,4250,'PAID','2026-05-16 13:30:00',FALSE),
(7,4,4250,'UNPAID',NULL,FALSE),
(8,8,6750,'PAID','2026-05-17 15:00:00',FALSE),
(8,3,6750,'PAID','2026-05-17 15:30:00',FALSE);

INSERT INTO reliability_history (
    member_id, change_score, after_score, reason
)
VALUES
(1,5,80,'정상 납부'),
(2,5,95,'정상 납부'),
(3,-10,70,'미납 발생'),
(4,-10,60,'미납 발생'),
(5,5,50,'정상 납부'),
(6,-10,40,'납부 지연'),
(7,5,88,'정상 납부'),
(8,5,76,'정상 납부'),
(9,-10,65,'가입 거절'),
(10,5,92,'정상 납부');

INSERT INTO notification (
    member_id, notification_type, content, target_url, is_read
)
VALUES
(1,'PAYMENT_REQUEST','2026년 5월 정산 요청이 도착했습니다.','/payments',FALSE),
(2,'JOIN_REQUEST','새로운 파티 가입 신청이 있습니다.','/parties/1/requests',FALSE),
(3,'JOIN_APPROVED','파티 가입 신청이 승인되었습니다.','/parties/1',TRUE),
(4,'PAYMENT_REQUEST','미납된 정산 내역이 있습니다.','/payments',FALSE),
(5,'JOIN_REQUEST','가입 신청이 접수되었습니다.','/parties/2/requests',TRUE),
(6,'PAYMENT_REQUEST','납부 기한이 지난 정산 내역이 있습니다.','/payments',FALSE),
(7,'JOIN_APPROVED','파티 가입이 승인되었습니다.','/parties/3',TRUE),
(8,'PAYMENT_REQUEST','이번 달 정산 금액을 확인해주세요.','/payments',FALSE),
(9,'JOIN_REQUEST','새로운 가입 신청이 접수되었습니다.','/parties/5/requests',FALSE),
(10,'PAYMENT_REQUEST','정산 요청 알림이 도착했습니다.','/payments',FALSE);
