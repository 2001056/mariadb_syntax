-- database는 멀티스레드로 설계
-- 동시성 문제 존재
-- 해결책 1. 베타락 (select for update) => 조회시에 특정행에 lock

-- read uncommited : 커밋되지 않은 데이터 read 가능 -> dirty read 문제 발생
-- 실습 절차
-- 1) 워크벤치에서 auto_commit 해제, update 실행, commit 하지 않음 (transaction1)
-- 2) 터미널을 열어  select 했을 때 위 update 변경사항이 읽히는지 확인 (transaction2)
-- 결론 : mariadb는 기본이 repeatable read 이므로 dirty read 발생 x.

-- read commited : 커밋한 데이터만 read 가능 -> phantom read 발생(또는 non-repeatable read)
-- 실습절차
-- 1)워크벤치에서 아래 코드실행
-- 2) 터미널을 열어 아래 코드실행
-- 결론 : mariadb는 기본이 repeatable read 이므로 phantom read 발생 X

-- repeatable read : 읽기의 일관성 보장 -> lost update문제 발생 -> 베타lock(베타적 잠금)으로 해결
-- lost update 문제 발생하는 상황

-- 베타락을 통해 lost update문제를 해결한상황
-- select for update를 하게되면 트랜잭션이 실행되는동안 lock을 걸고 , 트랜잭션 종료 후 lock이 풀림

-- serializable : 모든 트랜잭션 순차적 실행 -> 동시성문제없음(성능저하)
