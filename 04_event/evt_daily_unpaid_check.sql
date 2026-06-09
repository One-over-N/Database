SET GLOBAL event_scheduler = ON;

DROP EVENT IF EXISTS evt_daily_unpaid_check;

-- 매일 오전 0시 정각에 새 프로시저를 호출하도록 등록
CREATE EVENT evt_daily_unpaid_check
    ON SCHEDULE EVERY 1 DAY
    STARTS '2026-06-04 00:00:00' 
DO
    CALL user_payment_punish_unpaid_members();
