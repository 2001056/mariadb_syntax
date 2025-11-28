-- view : 실제 데이터를 참조만 하는 가상의 테이블  SELECT만 가능
-- 사용목적 : 1) 권한분리 2) 복잡한 쿼리를 사전 생성

-- view 생성
create view author_view as select name, email from author;

create view author_view2 as select p.title, a.name, a,email from post p inner join author a on p.author_id =a.id;

-- view 조회 (테이블 조회와 동일 )
select * fron author_view;

-- view에 대한 권한 부여
grant select on board.author_view to 'marketing'@'%';

-- view 삭제
drop view author_view;

-- 프로시저 생성
delimiter //
create procedure hello_procedure()
begin
    select "hello world";

end
// delimiter ;

-- 프로시저 호출
call hello_procedure();

-- 프로시저 삭제
drop procedure hello_procedure;

-- 회원목록조회 프로시저생성
delimiter //
create procedure 회원목록조회()
begin
    select * from author;

end
// delimiter ;

/* 회원 상세 조회 -> 
input(매개변수)값 여러개 사용가능 -> 
프로시저 호출시 순서에 맞게 매개변수 입력
*/

d
create procedure 회원상세조회(in idInput bigint)
begin
    select * from author where id = idInput;
end
// delimiter ;

-- 전체 회원 수 조회 -> 변수 사용

delimiter //
create procedure 전체회원수조회()
begin
    -- 변수 선언
    declare authorCount bigint;
    -- into를 통해 변수에 값 할당 
    select count(*) into authorCount from author;
    -- 변수 값 사용
    select authorCount;
end
// delimiter ;

-- 글쓰기
delimiter //
-- 사용자가 title, contents,본인의 email 값을 입력
delimiter //
create procedure 글쓰기(in titleInput varchar(255),in contentsInput varchar(3000),in emailInput varchar(255))
begin
    -- begin 밑에 dclare를 통해 변수 선언 
    -- email로 회원 아이디 찾기
    declare authorid bigint;
    declare postid bigint;
    -- 아래 declare는 변수선언과는 상관없는 예외관련 특수문법
    declare exit handler for SQLEXEPTION;
    begin 
        rollback
    end;
    start transaction;
        select author.id into authorid from author where email = emailInput limit 1;
        -- post 테이블에 insert
        insert into post(title,contents) values(titleInput,contentsInput); 
        -- post테이블에 insert 된 id값 구하기
        select post.id into postid from post order by post.id desc limit 1;
        -- author_post_list 테이블에 insert하기
        insert into author_post_list(author_id,post_id) values(authorid,postid);
    commit;
    
end
// delimiter ;

-- 글 삭제 -> if else문
delimiter //
create procedure 글삭제(in postIdInput bigint,in authorIdInput bigint)
begin
    -- 참여자의 수 조회
    declare authorCount bigint;
    select count(*) into authorCount from author_post_list where post_id = postIdInput;

    if authorCount=1 then
        delete from author_post_list where post_id=postIdInput and author_id=authorIdInput;
        delete from post where id= postIdInput;
    else
        delete from author_post_list where post_id=postIdInput and author_id=authorIdInput
    end if;
end
// delimiter ;

-- 대량 글쓰기 -> while
delimiter //
create procedure 대량글쓰기(in count bigint, in emailInput varchar(255))
begin
    declare authorid bigint;
    declare postid bigint;
    declare countValue bigint default 0;
    while  countValue < count do
        select author.id into authorid from author where email = emailInput;
        insert into post(title) values('안녕하세요'); 
        select post.id into postid from post order by post.id desc limit 1;
        insert into author_post_list(author_id,post_id) values(authorid,postid);
        set countValue = countValue + 1;
    end while;
end
// delimiter ;