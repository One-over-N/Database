-- 납부 완료 시 +5

-- 동일 이름 트리거 있을 시 제거
DROP TRIGGER IF EXISTS after_member_payment_update;

DELIMITER //

CREATE TRIGGER after_member_payment_update
    AFTER UPDATE ON member_payment
    FOR EACH ROW

BEGIN
    -- UNPAID -> PAID 로 바뀔 경우
    IF NEW.payment_status = 'PAID' AND OLD.payment_status = 'UNPAID' THEN

        -- member 테이블의 relaibility_score 갱신
        UPDATE member
        SET reliability_score = reliability_score + 5,
            updated_at = NOW()
        WHERE member_id = NEW.member_id;

        -- reliability_history 테이블 생성
        INSERT INTO reliability_history(
            change_score,
            reason,
            created_at,
            updated_at,
            member_id
        )
        VALUES (
                   5,
                   CONCAT(
                           (SELECT p.party_name
                            FROM party_settlement ps
                                     JOIN party p ON ps.party_id = p.party_id
                            WHERE ps.party_settlement_id = NEW.party_settlement_id),
                           ' 납부 완료'
                   ),
                   NOW(),
                   NOW(),
                   NEW.member_id
               );

        -- 관련 party_settlement_id를 가진 payment_status가 UNPAID인 것이 없을 때
        IF (SELECT COUNT(*)
            FROM member_payment
            WHERE party_settlement_id=NEW.party_settlement_id
                AND payment_status='UNPAID')=0 THEN

            -- party_settlement 상태 COMPLETED로 변경
            UPDATE party_settlement
            SET settlement_status='COMPLETED',
                updated_at=NOW()
            WHERE party_settlement_id=NEW.party_settlement_id;

        end if;

    END IF;

END//

DELIMITER ;
