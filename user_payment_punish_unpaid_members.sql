-- 미납시 -10

-- 동일 이름 트리거 있을 시 제거
DROP PROCEDURE IF EXISTS user_payment_punish_unpaid_members;

DELIMITER //

CREATE PROCEDURE user_payment_punish_unpaid_members()
BEGIN
		-- 데이터 수정하므로 트랜잭션 적용
    START TRANSACTION;
    
		-- 대상이 되는 미납 ID와 회원 ID, 파티명을 임시 테이블에 저장
    CREATE TEMPORARY TABLE IF NOT EXISTS temp_unpaid_targets AS
    SELECT
        mp.member_payment_id,
        mp.member_id,
        p.party_name
    FROM member_payment mp
             JOIN party_settlement ps ON mp.party_settlement_id = ps.party_settlement_id
             JOIN party p ON ps.party_id = p.party_id
    WHERE ps.target_date < NOW()
      AND mp.payment_status = 'UNPAID'
      AND mp.penalty_applied = FALSE;

    -- member 테이블의 relaibility_score 갱신
    UPDATE member m
        JOIN (
            SELECT member_id, COUNT(*) AS unpaid_cnt
            FROM temp_unpaid_targets
            GROUP BY member_id
        ) t ON m.member_id = t.member_id
    SET m.reliability_score = m.reliability_score - (t.unpaid_cnt * 10),
        m.updated_at = NOW();

    -- reliability_history 테이블 생성
    INSERT INTO reliability_history (
        change_score,
        reason,
        created_at,
        updated_at,
        member_id
    )
    SELECT
        -10,
        CONCAT(party_name, ' 미납 패널티'),
        NOW(),
        NOW(),
        member_id
    FROM temp_unpaid_targets;

    -- 중복 방지 처리
    UPDATE member_payment mp
        JOIN temp_unpaid_targets t ON mp.member_payment_id = t.member_payment_id
    SET mp.penalty_applied = TRUE,
        mp.updated_at = NOW();

    -- 임시 테이블 삭제
    DROP TEMPORARY TABLE IF EXISTS temp_unpaid_targets;

    COMMIT;
END//

DELIMITER ;
