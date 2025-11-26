-- 인덱스 생성: in,name,... 컬럼이 기준
-- 컬럼을 기준으로 목차생성
-- index를 활용하기 위해서는 where 컬럼=?;
-- 인덱스를 생성하면 조회성능이 향상, 삽입/수정/삭제는 성능하락
-- 조회가 빈번한 경우에 인덱스를 만드는것이 유리.

-- pk, fk,unique 제약조건 추가시에 해당컬럼에 대해 index페이지 자동생성
-- 별도의 컬럼에 대해 index 추가 생성 가능

-- index 조회
show index from author;

-- 기존 index 삭제
alter table author drop index 인덱스명;
alter table author drop index name_index;

-- 신규 index 생성
create index 인덱스명 on 테이블명(컬럼명);
create index name_index on author(name);

-- Cardinality : 데이터의 종류
-- cardinality가 낮은경우에는 index설정 쓸모 X


-- pk -> 제약조건 + 인덱스 생성 -> 인덱스만 별도 삭제 O -> 인덱스만 추가
-- fk -> 제약조건 + 인덱스 생성 -> 인덱스만 별도 삭제 O -> 인덱스만 추가
-- unique -> 제약조건 + 인덱스 생성 -> 인덱스와 제약조건 같이삭제
-- name -> 인덱스 인위적 추가 -> 인덱스만 따로 삭제 

-- index는 1컬럼 뿐만 아니라, 2컬럼을 대상으로 1개의 index를 설정하는것도 가능 
-- 이경우 두컬럼을 and조건으로 조회해야만 index를 사용
create index name_age_index on author(name,age);

-- index 성능 테스트 
-- 기존 테이블 삭제 후 간단한 테이블로 index 설정 또는 index 미설정 테스트 
drop table post;
drop table author;
create table author(
    id bigint auto_increment, 
    email varchar(255) unique, 
    name varchar(255),
    primary key(id)
    );
create table author(
    id bigint auto_increment, 
    email varchar(255), 
    name varchar(255), 
    primary key(id)
    );


-- 아래 프로시저를 통해 수십만건의 데이터 insert후에 index생성 전후에 따라 조회성능확인
DELIMITER //
CREATE PROCEDURE insert_authors()
BEGIN
    DECLARE i INT DEFAULT 1;
    DECLARE email VARCHAR(100);
    DECLARE batch_size INT DEFAULT 10000; -- 한 번에 삽입할 행 수
    DECLARE max_iterations INT DEFAULT 100; -- 총 반복 횟수 (1000000 / batch_size)
    DECLARE iteration INT DEFAULT 1;
    WHILE iteration <= max_iterations DO
        START TRANSACTION;
        WHILE i <= iteration * batch_size DO
            SET email = CONCAT('bradkim', i, '@naver.com');
            INSERT INTO author (email) VALUES (email);
            SET i = i + 1;
        END WHILE;
        COMMIT;
        SET iteration = iteration + 1;
        DO SLEEP(0.1); -- 각 트랜잭션 후 0.1초 지연
    END WHILE;
END //
DELIMITER ;

--테이블 만들고 테스트 쿼리 실행 >> db프로젝트 끝
-- 1. 회원가입,2.회원정보수정 등등 테스트쿼리

-- 회원 입장에서 게시글이 1:1인가 1:n인가
-- 회원 입장에서 게시글이 필수, 선택인가
-- 게시글입장에서 회원이 1:1인가 n:1인가
-- 게시글입장에서 회원이 필수, 선택인가

-- 자식에 FK설정
-- 누가 부모고, 누가 자식테이블인가.