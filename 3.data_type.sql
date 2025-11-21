-- tinyint : 1바이트 사용 -128~127 까지의 정수표현 가능. (unsigned시에 0~255)
-- author 테이블에 age 추가
alter table author add column age tinyint unsigned;
insert into author(id, name, email, age) values(6,'홍길동2', 'aa@naver.com', 200);

-- int : 4바이트 사용. 대략 40억 숫자범위 표현 가능.

-- bigint: 8바이트사용.
-- author, post테이블의 id 값을 bigint로 변경
-- foreign key 같은 제약조건이 걸려있을 시 변경 불가 제약조건 해제 후 재설정
alter table post modify column author_id bigint;
alter table author modify column id bigint;
alter table post modify column id bigint;

-- decimal(총자리수, 소수부자리수)
alter table author add column height decimal(4, 1);
-- 정상적인 insert
insert into author(id,name,email,height) values(7,'홍길동3','sss@naver.com',175.5);
-- 데이터가 잘리도록 insert
insert into author(id,name,email,height) values(8,'홍길동4','ddd@naver.com',175.55);

-- 문자 타입 --

-- 길이가 딱 정해진 짧은 단어 : char , varchar
-- 장문의 데이터 : text,varchar
-- 그외 전부 : varchar


-- char : 고정길이
alter table author add column id_number char(16);


-- varchar : 가변길이, 최대길이지정가능, 메모리 저장, 빈번히 조회되는 짧은 데이터 저장에 용이

-- text : 가변길이, 최대길이지정불가, storage 저장, 빈번히 조회되지 않는 장문의 데이터 저장에 용이
alter table author add column self_introduction text;


-- blob(바이너리데이터) 실습
-- 일반적으로 blob으로 저장하기 보다는, 이미지를 별도로 저장하고, 이미지경로를 varchar로 저장한다.
alter table author add column profile_image longblob;
insert into author(id,name,email,profile_image) values(9,'abc','abc2@naver.com', LOAD_FILE('C:\\scs.png'));

-- enum : 삽입 될 수 있는 데이터의 종류를 한정하는 데이터 타입
-- role 컬럼추가
alter table author add column role enum('admin','user') not null default 'user';
-- enum에서 지정된 role을 insert 
insert into author(id,name,email,role) values(7,'홍길동4','ss1s@naver.com','admin');
-- enum에서 지정되지 않은 값을 insert --> error 발생
insert into author(id,name,email,height) values(9,'홍길동6','ss2s@naver.com','superadmin');
-- role을 지정하지 않고 insert
insert into author(id,name,email) values(8,'홍길동5','s4ss@naver.com');

-- data(연월일)와 datetime(연월일시분초)
-- 날짜타입의 입력,수정,조회시에는 문자열 형식을 사용
alter table author add column birthday date;
alter table post add column created_time datetime;
insert into post(id,title,contents,author_id,created_time) values(4,'hihello','ntmy',1,'2019-01-01 14:00:30');
insert into author(id,name,email,birthday) values(9,'홍길동6','asd@naver.com','2020-05-07'); 

-- datetime과 default 현재시간 입력은 많이 사용되는 패턴
alter table post modify column created_time datetime default current_timestamp();

-- 비교연산자 between
select * from author where id>=2 and id<=4;
select * from author where id between 2 and 4;

-- like : 특정 문자를 포함하는 데이터를 조회하기 위한 키워드
select * from post where title like 'h%';
select * from post where title like '%h';
select * from post where title like '%h%';

-- regexp : 정규표현식을 활용한 조회
select * from author where name regexp '[a-z]'; --이름에 소문자 알파벳이 포함된 경우
select * from author where name regexp '[가-힣]'; --이름에 한글이 포함된 경우

-- 타입변환 - cast
-- 문자 -> 숫자
select cast('12' unsigned int)
-- 숫자 -> 날짜
select cast(20200101 as date);
-- 문자 -> 날짜
select cast('20200101' as date);

-- 날짜 타입 변환 : date_format(Y,m,d,H,i,s)
select date_format(created_time, '%Y-%m-%d') from post;
select date_format(created_time, '%H-%i-%s') from post;
select * from post where date_format(created_time, '%Y')='2025';
select * from post where date_format(created_time, '%Y')='2025';
select * from post where date_format(created_time, '%m')='01';
select * from post where cast(date_format(created_time, '%m') as unsigned) =1;

-- 실습 : 2025년 11월 게시글 조회
select * from post where date_format(created_time, '%Y-%m')='2025-11';
select * from post where created_time like '2025-11%';

-- 실습 : 2025년11월1일부터 11월 19일 까지의 데이터를 조회
select * from post where created_time>=2025-11-01 and created_time<=2025-11-19; -- 뒤에 00:00:00이 붙는다.
-- 날짜데이터 범위 조회는 위 방식이 가장 적절하다.


