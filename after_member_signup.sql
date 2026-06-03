-- 가입 시 신뢰도 내역 자동 초기화(50)

-- 동일 이름 트리거 있을 시 제거
DROP TRIGGER IF EXISTS after_member_signup;

DELIMITER //

CREATE TRIGGER after_member_signup
AFTER INSERT ON member
FOR EACH ROW
BEGIN
    INSERT INTO reliability_history(
        change_score,
        reason,
        created_at,
        updated_at,
        member_id
    )
    VALUES (
        50,
        '가입 기본 점수',
        NOW(),
        NOW(),
        NEW.member_id
    );
END //

DELIMITER ;
