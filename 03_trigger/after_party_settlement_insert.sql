-- party_settlement 생성 시 member_payment 생성 

DROP TRIGGER IF EXISTS after_party_settlement_insert;

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
        INSERT INTO member_payment (party_settlement_id, member_id, payment_amount, payment_status, paid_at)
        SELECT 
            NEW.party_settlement_id,
            pm.member_id,
            FLOOR(NEW.target_amount / total_members) AS payment_amount, -- 소수점 버림
            'UNPAID' AS payment_status,
            NULL AS paid_at
        FROM party_member pm
        WHERE pm.party_id = NEW.party_id;
    END IF;
END //

DELIMITER ;
