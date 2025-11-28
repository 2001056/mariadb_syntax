-- 회원 테이블 생성 
-- id(pk), email(unique,not null),name(not null),password(not null)
create table author(id bigint auto_increment primary key ,
email varchar(255) unique not null,
name varchar(255) not null, password varchar(255) not null);
-- 주소 테이블 생성 
-- id,country(not null),city(not null),street(not null),author_id(fk,not null)
create table address(id bigint primary key,country varchar(255) not null,
city varchar(255) not null, street varchar(255) not null,
author_id bigint not null unique ,
foreign key(author_id) references author(id));
-- post 테이블
-- id, title(not null), contents
create table post(id bigint auto_increment primary key,
title varchar(255) not null, contents varchar(3000));

-- 연결(junction) 테이블
-- author_post_list 테이블
-- id, post_id(not null), author_id(not null)
create table author_post_list(id bigint auto_increment primary key,
author_id bigint not null,
post_id bigint not null,
foreign key(author_id) references author(id),
foreign key(post_id) references post(id));

-- 복합키를 이용한 연결 테이블 생성
create table author_post_list(author_id bigint not null,
post_id bigint not null,
primary key(author_id,post_id),
foreign key(author_id) references author(id),
foreign key(post_id) references post(id));

-- 회원가입 및 주소 생성
insert into author(email,name,password) values('zxcx@naver.com','홍길동3','124351');
insert into address(country,city,street,author_id) values('USA','NEWYORK',(select id from author order by desc limit 1));
insert into address(country,city,street,author_id) values('JAPAN','DOKYO','asdf',3);
-- 글 쓰기 
insert into post(title,contents) values('hello1','heello');
insert into post(title,contents) values('hello2','heello');
insert into author_post_list(author_id,post_id) values(1,1);
insert into author_post_list(author_id,post_id) values(2,1);
insert into author_post_list(author_id,post_id) values(3,2);
insert into author_post_list(author_id,post_id) values(1,2);

-- 글 조회 : 제목, 내용, 글쓴이 이름이 조회가 되도록 select 쿼리 생성
--select p.title,p.contents,a.name 
--from post p 
--inner join author_post_list apl 
--inner join author a 
--on p.id=apl.post_id 
--and a.id=apl.author_id;
select p.title,p.contents,a.name 
from post p 
inner join author_post_list apl 
on p.id=apl.post_id 
inner join author a 
a.id=apl.author_id;

-- 실습
use online_shop;

-- user 테이블 생성
create table user(id bigint auto_increment primary key,
name varchar(255) not null,
phone varchar(255) not null,
role enum('s','u') not null default 'u');
-- 유저 정보 등록
insert into user(name,phone) values('홍길동1','010-1111-1111');
insert into user(name,phone) values('홍길동2','010-2222-2222');
insert into user(name,phone) values('홍길동3','010-3333-3333');
insert into user(name,phone) values('홍길동4','010-4444-4444');
insert into user(name,phone) values('홍길동5','010-5555-6666');
-- 판매자 구매자 구분
update user set role='s' where id=3;
update user set role='s' where id=5;
select * from user;
-- products 테이블 생성
create table products(id bigint auto_increment primary key,
user_id bigint not null,
name varchar(255) not null,
detail varchar(3000),
price bigint not null,
stock bigint not null,
foreign key(user_id) references user(id));
-- 상품 정보 등록
insert into products(user_id,name,detail,price,stock) values(3,'사과','사과입니다',500,8);
insert into products(user_id,name,price,stock) values(3,'배',600,9);
insert into products(user_id,name,detail,price,stock) values(5,'감자','감자입니다',700,8);
insert into products(user_id,name,detail,price,stock) values(5,'고구마','고구마입니다',1000,7);
insert into products(user_id,name,detail,price,stock) values(5,'오이','오이입니다',900,11);
-- 상품 재고 수정
update products set stock=5 where id = 1;
update products set stock=6 where id = 2;
update products set stock=5 where id = 3;
update products set stock=4 where id = 4;
update products set stock=8 where id = 5;
select * from products;
-- order_sheet
create table order_sheet(id bigint auto_increment primary key,
user_id bigint not null,
order_time datetime not null default current_timestamp(),
foreign key(user_id) references user(id));
-- 주문지 작성
insert into order_sheet(user_id) values(1);
insert into order_sheet(user_id) values(2);
insert into order_sheet(user_id) values(4);
select * from order_sheet;

-- address 
create table address(id bigint auto_increment primary key,
user_id bigint not null,
addr varchar(255) not null,
foreign key(user_id) references user(id));
-- 주소 등록
insert into address(user_id,addr) values(1,'서울시 대방동');
insert into address(user_id,addr) values(1,'서울시 강남구');
insert into address(user_id,addr) values(2,'서울시 구로구');
insert into address(user_id,addr) values(3,'경기도 남양주');
insert into address(user_id,addr) values(4,'서울시 노원구');
insert into address(user_id,addr) values(5,'부산시 사상구');
select * from address;
-- order_detail
create table order_detail(id bigint auto_increment primary key,
pro_id bigint not null,
order_id bigint not null,
qty bigint not null,           
foreign key(order_id) references order_sheet(id),
foreign key(pro_id) references products(id));
-- 주문 상세정보 등록
insert into order_detail(pro_id,order_id,qty) values(1,1,3);
insert into order_detail(pro_id,order_id,qty) values(2,1,3);
insert into order_detail(pro_id,order_id,qty) values(5,2,3);
insert into order_detail(pro_id,order_id,qty) values(4,3,3);
insert into order_detail(pro_id,order_id,qty) values(3,3,3);
select * from order_detail;
-- 주문 조회
select s.id,u.name,p.name,d.qty,p.stock,s.order_time 
from user u inner join order_sheet s on u.id = s.user_id 
inner join order_detail d on s.id = d.order_id 
inner join products p on d.pro_id = p.id;

-- 주소 조회
select u.name,a.addr from user u inner join address a on u.id = a.user_id; 


