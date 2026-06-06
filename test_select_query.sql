USE ott_party_db;

-- 1. 전체 회원 조회
SELECT * FROM member;

-- 2. OTT 서비스 및 요금제 조회
SELECT 
    o.service_name,
    op.plan_name,
    op.monthly_price,
    op.max_members,
    FLOOR(op.monthly_price / op.max_members) AS expected_price_per_member
FROM ott o
JOIN ott_plan op
ON o.ott_service_id = op.ott_service_id;

-- 3. 모집 중인 파티 목록 조회
SELECT 
    p.party_id,
    p.party_name,
    o.service_name,
    op.plan_name,
    op.monthly_price,
    op.max_members,
    COUNT(pm.member_id) AS current_members,
    FLOOR(op.monthly_price / op.max_members) AS expected_price_per_member,
    m.nickname AS host_name,
    m.reliability_score AS host_reliability
FROM party p
JOIN ott_plan op ON p.ott_plan_id = op.ott_plan_id
JOIN ott o ON op.ott_service_id = o.ott_service_id
JOIN member m ON p.leader_id = m.member_id
LEFT JOIN party_member pm ON p.party_id = pm.party_id
WHERE p.party_status = 'RECRUITING'
GROUP BY 
    p.party_id, p.party_name, o.service_name, op.plan_name,
    op.monthly_price, op.max_members, m.nickname, m.reliability_score;

-- 4. 파티 가입 신청자 조회
SELECT 
    jr.join_request_id,
    p.party_name,
    m.nickname AS applicant_name,
    m.reliability_score,
    jr.request_status,
    jr.requested_at
FROM join_request jr
JOIN party p ON jr.party_id = p.party_id
JOIN member m ON jr.member_id = m.member_id
ORDER BY jr.requested_at;

-- 5. 납부 현황 조회
SELECT
    m.nickname,
    p.party_name,
    ps.settlement_month,
    mp.payment_amount,
    mp.payment_status,
    mp.payment_date
FROM member_payment mp
JOIN member m ON mp.member_id = m.member_id
JOIN party_settlement ps ON mp.party_settlement_id = ps.party_settlement_id
JOIN party p ON ps.party_id = p.party_id
ORDER BY ps.settlement_month, m.member_id;

-- 6. 미납 사용자 조회
SELECT
    m.nickname,
    p.party_name,
    mp.payment_amount,
    mp.payment_status
FROM member_payment mp
JOIN member m ON mp.member_id = m.member_id
JOIN party_settlement ps ON mp.party_settlement_id = ps.party_settlement_id
JOIN party p ON ps.party_id = p.party_id
WHERE mp.payment_status = 'UNPAID';

-- 7. 신뢰도 변동 이력 조회
SELECT
    m.nickname,
    rh.before_score,
    rh.change_score,
    rh.after_score,
    rh.reason,
    rh.created_at
FROM reliability_history rh
JOIN member m ON rh.member_id = m.member_id
ORDER BY rh.created_at DESC;

-- 8. 알림 조회
SELECT
    m.nickname,
    n.notification_type,
    n.content,
    n.target_url,
    n.is_read,
    n.created_at
FROM notification n
JOIN member m ON n.member_id = m.member_id
ORDER BY n.created_at DESC;
