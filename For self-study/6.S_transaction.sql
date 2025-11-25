-- 트랜잭션 상황 1. 글을쓴다 2. 글쓴이의 count 컬럼을 증가시킨다.
-- 회원 -> count 컬럼 : 쓴 글의 개수
-- post -> 글쓰기 
-- 테스트를 위한 컬럼추가

-- 트랜잭션 실습
-- post에 글쓰기(insert), authordml post_count +1을 update하는 작업. 2개를 한 트랜잭션으로 처리
-- start transaction 실질적인 의미는 없고, 트랜잭션의 시작이라는 상징적인 의미만 있는 코드

-- 위 트랜잭션은 실패시 자동으로 rollback이 어려움.
-- stored 프로시저를 활용하여 성공시에는 commit, 실패시에는 rollback 등 동적인 프로그래밍이 가능하도록 한다

--프로시저 호출
