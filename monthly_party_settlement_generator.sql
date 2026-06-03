-- 각 파티별 생성 주기에 맞춘 매달 정산 자동 갱신 스케줄러
SET GLOBAL event_scheduler = ON;

DELIMITER //

CREATE EVENT monthly_party_settlement_generator
ON SCHEDULE EVERY 1 DAY -- 매일 자정에 체크
STARTS CURRENT_TIMESTAMP
DO
BEGIN
    -- 모집 중인 파티 중 오늘이 파티 결제일인 파티들만 정산서 새로 생성
    INSERT INTO party_settlement (party_id, settlement_month, total_amount, settlement_status)
    SELECT 
        p.party_id,
        DATE_FORMAT(NOW(), '%Y-%m') AS settlement_month, 
        op.monthly_price AS total_amount,
        'pending' AS settlement_status
    FROM party p
    JOIN ott_plan op ON p.ott_plan_id = op.ott_plan_id
    WHERE p.party_status IN ('recruiting', 'closed')
      AND DAY(p.created_at) = DAY(NOW())
      -- 중복 생성 방지
      AND NOT EXISTS (
          SELECT 1 FROM party_settlement ps 
          WHERE ps.party_id = p.party_id 
            AND ps.settlement_month = DATE_FORMAT(NOW(), '%Y-%m')
      );
END//

DELIMITER ;
