-- 각 파티별 생성 주기에 맞춘 매달 정산 자동 갱신 스케줄러
DELIMITER //

CREATE EVENT monthly_party_settlement_generator
ON SCHEDULE EVERY 1 DAY -- 매일 자정에 체크
STARTS CURDATE() + INTERVAL 1 DAY
DO
BEGIN
    -- 모집 중인 파티 중 오늘이 파티 결제일인 파티들만 정산서 새로 생성
    INSERT INTO party_settlement (party_id, settlement_month, total_amount, settlement_status)
    SELECT 
        p.party_id,
        DATE_FORMAT(NOW(), '%Y-%m') AS settlement_month, 
        op.monthly_price AS total_amount,
        'PENDING' AS settlement_status
    FROM party p
    JOIN ott_plan op ON p.ott_plan_id = op.ott_plan_id
    WHERE p.party_status IN ('RECRUITING', 'CLOSED')

     -- 짧은 달(28, 29, 30일) 결제일 누락 방지 예외 처리 조건 추가
      AND (
          DAY(p.created_at) = DAY(NOW()) -- 일반적인 경우: 생성일과 오늘 일자가 같을 때
          OR (
              LAST_DAY(NOW()) = DATE(NOW()) -- 혹은 오늘이 이번 달의 진짜 마지막 날이고,
              AND DAY(p.created_at) > DAY(NOW()) -- 파티 생성일이 그 마지막 날보다 큰 숫자일 때 (ex. 2월 28일에 29, 30, 31일 팀들 구제)
          )
      )
    
      -- 중복 생성 방지
      AND NOT EXISTS (
          SELECT 1 FROM party_settlement ps 
          WHERE ps.party_id = p.party_id 
            AND ps.settlement_month = DATE_FORMAT(NOW(), '%Y-%m')
      );
END//

DELIMITER ;
