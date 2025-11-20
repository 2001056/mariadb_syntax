-- MariaDB 서버에 터미널 창에서 접속 (DB GUI 툴로 접속 시 커넥션 객체 생성하여 연결)
mariadb -u root -p -- 엔터 후 비밀번호 별도 입력

-- 스키마(Database) 생성
create database board;

-- 스키마 목록 조회
show databases;

-- 스키마 선택
use 스키마명;

-- 문자 인코딩 설정 조회 (암기 X)
show variables like 'character_set_server';

-- 문자 인코딩 설정 변경
alter database board default character set = utf8mb4;

-- 테이블 목록 조회
show tables;

-- SQL 문은 대문자 관례이고 시스템 상에서 대소문자 구분 X
-- 테이블명/컬럼명 등은 소문자가 관례이고 대소문자 구분 O
-- 테이블 생성
create table author(id int primary key,name varchar(255),email varchar(255),
password varchar(255));

-- 테이블 컬럼 정보 조회
describe author;

-- 테이블 데이터 전체 조회
select * from author;

-- 테이블 생성 명령문 조회(중요하지 않음)
show create table author;

-- 1. 간단한 제약 조건 : 컬럼 옆에  
-- 2. 복잡한 제약 조건 : 테이블 차원에 

-- posts 테이블 신규 생성(id, title, contents, author_id)
create table posts(id int,title varchar(255),contents varchar(255),author_id int, primary key(id), foreign key(author_id) references author(id));

-- 테이블 제약 조건 조회
select * from information_schema.key_column_usage where table_name ='posts';

-- 테이블 인덱스 조회
show index from posts;

-- alter : 테이블의 구조를 변경
-- 테이블 이름 변경
alter table posts rename post;

-- 테이블 컬럼 추가
alter table author add column age int;

-- 테이블 컬럼 삭제
alter table author drop column age;

-- 테이블 컬럼명 변경
alter table post change column contents content varchar(255);

-- 테이블 컬럼의 타입과 제약 조건 변경
alter table post modify column content varchar(3000);
alter table author modify column email varchar(255) not null unique;

-- 실습 1. author 테이블에 address 컬럼 추가(varchar(255)). name은 not null
alter table author add column address varchar(255);
alter table author modify column name varchar(100) not null;

-- 실습 2. post 테이블에서 title을 not null로 변경, content는 contents로 이름 변경
alter table post modify column title varchar(255) not null;
alter table post change column content contents varchar(3000);

-- 테이블 삭제
drop table abc;

-- 일련의 쿼리를 실행시킬 때 특정 쿼리에서 에러가 나지 않도록 if exists를 많이 사용
drop table if exists abc;


-- DML 구조
-- 삽입 : insert vs create
-- 수정 : update vs alter
-- 삭제 : delete vs drop
-- 조회 : select 