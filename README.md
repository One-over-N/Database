# 🗄️ 엔분의일 (One Over N) - Database Infrastructure

<div align="center">
  <img src="https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=MySQL&logoColor=white"/>
  <img src="https://img.shields.io/badge/ERDCloud-명세서-0078D4?style=for-the-badge&logo=databricks&logoColor=white"/>
</div>

<br>

> **"관계형 정규화 및 데이터베이스 스케줄링·프로그래밍 기반 데이터 인프라 구축"**
> 1/N 정산 시스템의 핵심 비즈니스 정산 프로세스, 실시간 가감 연동 신뢰도 변동 이력 및 미납자 제어를 물리 데이터베이스 계층에서 무결성 있게 자동 제어하는 **독립 데이터 자산 저장소**입니다.  
> 본 프로젝트는 **2026-1 이화여자대학교 데이터베이스 수업 프로젝트 11조** 결과물입니다.

---

## 🗓️ 설계 및 가동 기간
- **프로젝트 기간**: 2026년 5월 ~ 2026년 6월

---

## 👥 팀원 소개

| 이름 | 역할 | GitHub |
| :---: | :---: | :---: |
| **고예빈** | Back-End | [@KoYebin](https://github.com/KoYebin) |
| **김나성** | Back-End | [@na0302](https://github.com/na0302) |
| **김서현** | Front-End / Back-End | [@seohyeonS2](https://github.com/seohyeonS2) |
| **박선영** | Front-End / Back-End | [@kakao3838](https://github.com/kakao3838) |

---

## ⚙️ 데이터베이스 오브젝트 구동 명세

본 저장소의 데이터 인프라는 애플리케이션 서버의 부하를 줄이고 데이터의 무결성을 영속적으로 보장하기 위해 트리거, 프로시저, 이벤트를 활용한 절차적 데이터베이스 프로그래밍으로 통합 설계되었습니다.

### 1. 테이블 스키마 빌드 (`01_table`)
- `create_table.sql`: 회원, 파티, OTT 요금제, 정산 및 대금 수납 관계를 정규화하여 외래키(FK) 제약조건 및 영속성 레이아웃 설계

### 2. 실시간 비즈니스 트리거 인프라 (`02_trigger`)
- `after_member_signup.sql`: 신규 회원가입 시 기본 신뢰도 점수 및 공간 인프라 초기화 데이터 생성
- `after_join_request_accept.sql`: 파티 가입 신청 수락 시 해당 파티 인원 카운트 트리거링 및 자동 마감 제어
- `after_party_settlement_insert.sql`: 월별 정산서 개설 트리거링 발생 시 파티 멤버별 분할 청구 내역 계산 및 매핑
- `after_member_payment_update.sql`: 파티원의 수납 완료 상태 전환 시 실시간 신뢰 지수 가산 및 파티 전원 납부 완료 트랜잭션 검증

### 3. 절차적 저장 프로시저 (`03_procedure`)
- `proc_make_monthly_settlement.sql`: 각 파티의 결제 주기를 계산하여 매달 정산서 데이터를 일괄적으로 산출 및 생성
- `user_payment_punish_unpaid_members.sql`: 정산 기한을 초과한 미납 대상자를 조회하여 신뢰 지수 차등 감점 및 패널티 이력 적재

### 4. 자동화 배치 스케줄링 이벤트 (`04_event`)
- `make_monthly_party_settlement.sql`: 주기적인 파티 정산서 생성을 위한 월 단위 자동 가동 이벤트 배치
- `evt_daily_unpaid_check.sql`: 매일 자정 미납자 패널티 부여 프로시저를 주기적으로 가동 및 동기화하는 영속적 이벤트 링커

### 5. 가시성 확보 및 성능 튜닝 (`05_data`, `06_query`, `07_index`)
- **테스트 데이터 세팅 (`05_data`)**: 비즈니스 시나리오 검증용 테스트 데이터 셋 영속화
- **쿼리 검증 (`06_query`)**: 도메인 성능 검증용 복합 선택 쿼리 테스트 검증 완료
- **인덱스 성능 튜닝 (`07_index`)**: 대용량 매칭 및 조회 트래픽 병목을 원천 방지하기 위한 복합 물리 인덱스 설계
  - `idx_join_request_member_party_created`: 가입 신청 내역 조회 고속화
  - `idx_member_payment_integrated`: 회원별 정산 수납 상태 추적 가속화
  - `idx_party_ott_status`: OTT 플랫폼 및 상태별 파티 필터링 최적화

---

## 🗺️ 도메인 모델 및 아키텍처 (ERD)

```text
==========================================================================================
                                 [ 1/N SYSTEM ERD STRUCTURE ]
==========================================================================================

  [1. 회원 및 신뢰도 시스템]
  - Member             : 유저 고유 식별 정보, 패스워드, 이메일, 계좌 정보 및 현재 신뢰도 지수
  - ReliabilityHistory : 정산 연체/완료 등에 따른 유저별 신뢰 지수 변동 이력 및 사유 관리

  [2. OTT 플랫폼 기반 데이터]
  - Ott                : 서비스하는 OTT 종류 (Netflix, Tving, Disney+, Watcha, Wavve 등)
  - OttPlan            : 각 OTT 플랫폼별 커스텀 요금제 메타데이터 (이름, 월 금액, 최대 동시 접속자 수)

  [3. 파티 모집 및 매칭 가동]
  - Party              : OTT 플랫폼 요금제 기반 개설된 방 정보, 파티장 ID, 매칭 상태(PartyStatus)
  - JoinRequest        : 일반 유저가 파티에 가입 신청을 넣은 상태 제어 (PENDING, ACCEPTED, REJECTED)
  - PartyMember        : 파티에 소속 완료된 멤버 매핑 데이터 테이블

  [4. 정산 및 대금 수납 시스템]
  - PartySettlement    : 특정 파티에서 매달 생성되는 총액 정산 단위 데이터 (정산 상태 관리)
  - MemberPayment      : 해당 정산 회차에 파티원 개개인이 납부해야 하는 상태 제어 (PAID, UNPAID)

==========================================================================================
```
> [!NOTE]
> 아래 배지나 링크를 클릭하시면 ERDCloud 공식 사이트에서 정규화된 테이블 구조 및 실시간 컬럼 명세를 상세히 확인하실 수 있습니다.

<a href="https://www.erdcloud.com/d/qpuDCWpzuEu2NLBSz" target="_blank">
  <img src="https://img.shields.io/badge/ERDCloud-실시간%20ERD%20확인하기-0078D4?style=for-the-badge&logo=databricks&logoColor=white"/>
</a>

---

## 🛠️ 데이터베이스 빌드 및 초기화 방법
MySQL 전용 클라이언트 GUI 툴(HeidiSQL, MySQL Workbench 등)을 통해 해당 DB 서버에 root 권한으로 접속한 뒤, 객체 간 참조 무결성 오류 및 컴파일 의존성 에러를 완벽하게 차단하기 위해 반드시 아래에 명시된 서브 디렉토리 일련번호 순서에 맞춰 스크립트를 순차적으로 실행합니다.

```Bash
# 1단계: 핵심 물리 테이블 스키마 빌드 및 도메인 제약조건 수립
mysql> source 01_table/create_table.sql;

# 2단계: 동적 상호작용 및 수납 연동 제어 트리거 4종 컴파일 등록
mysql> source 02_trigger/after_member_signup.sql;
mysql> source 02_trigger/after_join_request_accept.sql;
mysql> source 02_trigger/after_party_settlement_insert.sql;
mysql> source 02_trigger/after_member_payment_update.sql;

# 3단계: 월별 정산 및 미납자 패널티 처리 코어 프로시저 2종 등록
mysql> source 03_procedure/proc_make_monthly_settlement.sql;
mysql> source 03_procedure/user_payment_punish_unpaid_members.sql;

# 4단계: 자정 주기 배치 및 월 단위 결제 스케줄러 자동화 이벤트 2종 활성화
mysql> source 04_event/make_monthly_party_settlement.sql;
mysql> source 04_event/evt_daily_unpaid_check.sql;

# 5단계: 알고리즘 검증용 테스트 기초 데이터 적재
mysql> source 05_data/insert_test_data.sql;

# 6단계: 복합 조건 탐색 가속화를 위한 도메인별 복합 인덱스 3종 구축
mysql> source 07_index/idx_join_request_member_party_created.sql;
mysql> source 07_index/idx_member_payment_integrated.sql;
mysql> source 07_index/idx_party_ott_status.sql;
```
