-- 파티 마감 전환 트리거

-- 동일 이름 트리거 있을 시 제거
DROP TRIGGER IF EXISTS after_join_request_accept;


DELIMITER //

CREATE TRIGGER after_join_request_accept
AFTER UPDATE ON join_request -- join_request 테이블이 UPDATE 될 시
FOR EACH ROW
BEGIN
    -- 트리거에서 사용할 변수 선언
    DECLARE current_members INT;
    DECLARE max_members INT;

    -- join_request가 새로 APPROVED로 변경되었을 때
    IF NEW.request_status='APPROVED' AND OLD.request_status!='APPROVED' THEN

        -- 현재 party member 수 조회
        SELECT COUNT(*) INTO current_members
        FROM party_member pm
        WHERE pm.party_id=NEW.party_id;

        -- 해당 party의 최대 인원 조회(ott_plan)
        SELECT op.max_members INTO max_members
        FROM party p
        JOIN ott_plan op ON p.ott_plan_id=op.ott_plan_id
        WHERE p.party_id=NEW.party_id;

        -- 이미 정원이 다 찼는지 확인
        IF current_members>=max_members THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = '파티 정원을 초과하여 승인할 수 없습니다.';
        END IF;

        -- party의 party_status를 CLOSED로 변경
        IF current_members+1>=max_members THEN
            UPDATE party
            SET party_status='CLOSED',
		            started_at = NOW(),
                updated_at = NOW() 
            WHERE party_id=NEW.party_id;
        END IF;

    END IF;
END //

DELIMITER ;
