-- not null 제약 조건 추가
alter table author modify name varchar(255) not null;
-- not null 제약 조건 제거
alter table author modify name varchar(255);

--제약 조건 확인
select * from information_schema.key_column_usage where table_name='post';


-- not null,unique 동시 추가
alter table author modify email varchar(255) not null unique;

-- pk,fk 추가 및 제거
-- pk 제약조건 삭제
alter table post drop primary key;
-- fk 제약조건 삭제
alter table post drop foreign key fk명;
-- pk 제약조건 추가
alter table post add constraint post_pk primary key(id);
-- fk 제약조건 추가
alter table post add constraint post_fk foreign key(author_id) references author(id);
-- not null -> modify column
-- unique 추가 -> modify column 제거 -> index에서 제거

-- on delete/on update 제약 조건 변경
alter table post add constraint post_fk foreign key(author_id) references author(id) on delete set null on update cascade;

-- 기존 fk 삭제 새로운 fk 추가 새로운 fk에 맞는 테스트 
alter table post drop foreign key post_fk;
alter table post add constraint post_fk foreign key(author_id) references author(id) on delete set null on update cascade;
-- 삭제테스트 -> 기존 author 테이블에 id 1번 과 연결돼있는 칼럼의 author_id가 null로 변경 됨
delete from author where id=1; 
-- 수정 테스트 -> 기존 author 테이블에 id2번과 연결되있는 글들의 author_id가 2에서 12로 변경됨
update author set id='12', email='honggildong12100@naver.com' where id=2;

-- default 옵션
-- 어떤 컬럼이든 default 지정이 가능하지만, 일반적으로 enum 타입 및 현재시간에서 많이 사용
alter table author modify column name varchar(255) default 'anonymous';
-- auto_increment : 숫자값을 입력 안했을때, 마지막에 입력 된 가장 큰 값에 +1 만큼 자동으로 증가 된 숫자값 자동으로 적용 
alter table author modify column id bigint auto_increment;
alter table post modify column id bigint auto_increment;
-- uuid
alter table post add column user_id char(36) default(uuid());