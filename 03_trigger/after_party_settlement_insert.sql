-- 멤버별 1/N 청구 생성 트리거
DELIMITER //

CREATE TRIGGER after_party_settlement_insert
AFTER INSERT ON party_settlement
FOR EACH ROW
BEGIN
    -- 트리거에서 사용할 변수 선언
    DECLARE total_members INT;
    
    -- 해당 파티에 현재 참여 중인 총 멤버 수 조회
    SELECT COUNT(*) INTO total_members 
    FROM party_member 
    WHERE party_id = NEW.party_id;
    
    -- 파티원이 1명이라도 존재할 때만 실행
    IF total_members > 0 THEN
        -- member_payment 테이블에 파티원별 1/N 청구 내역 자동 삽입
        INSERT INTO member_payment (party_settlement_id, member_id, payment_amount, payment_status, payment_date)
        SELECT 
            NEW.party_settlement_id,
            pm.member_id,
            FLOOR(NEW.target_amount / total_members) AS payment_amount, -- 소수점 버림
            'unpaid' AS payment_status,
            NULL AS paid_at
        FROM party_member pm
        WHERE pm.party_id = NEW.party_id;
    END IF;
END //

DELIMITER ;
