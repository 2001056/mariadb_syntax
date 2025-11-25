-- 기본 순서 
-- select from join on where 조건 group by having oder by
-- 셀 프 조인 왜 글 해 요 

-- case 1 : author inner join post
-- 글쓴 적이 있는 글쓴이와 그 글쓴이가 쓴 글 조회
select * from author inner join post on author.id = post.author_id;
-- as 생략 가능
select * from author a inner join post p on a.id = p.author_id;
-- 필터링은 하되 글쓴이만 조회하기
select a.* from author a inner join post p on a.id = p.author_id;
-- 글쓴이가 있는 글만 조회하기
select p.* from author a inner join post p on a.id = p.author_id;


-- case 2 : post inner join author
-- 글쓴이가 있는 글과 그 글의 글쓴이 조회
select * from post inner join author on post.author_id = author.id;
select * from post p inner join author a on p.author_id = a.id;
-- 글쓴이가 있는 글 전체 정보와 글쓴이의 이메일만 출력
select p.*,a.email from post p inner join author a on p.author_id = a.id;
-- case 3 : author left join post
-- 글쓴이는 모두 조회하되, 만약 쓴글이 있따면 글도 함께 조회
select * from author a left join post p on a.id = p.author_id;

-- case 4 : post left join author
-- 글을 모두 조회하되, 글쓴이가 있다면 함께 조회
select * from post p left join author a on p.author_id = a.id;

-- 글쓴이가 있는 글 중에서 제목과 저자의 email 저자의나이 출력 하되, 저자의 나이가 30세 이상인 글만 출력
select p.title,a.name,a.email,a.age from post p inner join author a on p.author_id = a.id where a.age>29;

-- 실습) 글의 저자의 이름이 빈값이 아닌 글 목록 만을 출력.
select p.* from post p inner join author a on p.author_id = a.id where a.name is not null;

-- 조건의 맞는 도서와 저자 리스트 출력
SELECT B.BOOK_ID,A.AUTHOR_NAME,DATE_FORMAT(B.PUBLISHED_DATE,'%Y-%m-%d') as PUBLISHED_DATE
FROM BOOK B INNER JOIN AUTHOR A 
ON B.AUTHOR_ID = A.AUTHOR_ID 
WHERE B.CATEGORY = '경제' 
order by B.PUBLISHED_DATE ASC;
-- 없어진 기록 찾기
SELECT O.ANIMAL_ID, O.NAME
FROM ANIMAL_OUTS O
LEFT JOIN ANIMAL_INS I 
ON O.ANIMAL_ID = I.ANIMAL_ID
WHERE I.ANIMAL_ID IS NULL;

-- union : 두테이블의 select결과를 횡으로 결합
-- union 시킬때 컬럼의 개수와 컬럼의 타입이 같아야함
select name,email from author union select title,contents from post;
-- union은 기본적으로 distinct 적용, 중복 허용 하려면 union all 사용
select name,email from author union all select title,contents from post;

-- 서브쿼리 : select 문 안에 또다른 select 문을 서브쿼리함
-- where절 안에 서브쿼리
-- 한번이라도 글을 쓴 author의 목록 조회 (중복 없이)
select distinct a.* from author a inner join post p on a.id=p.author_id;
-- null 값은 in 조건절에서 자동으로 제외
select * from author a where a.id in(select author_id from post);

-- column 위치에 서브쿼리
-- 회원 별로 본인의 쓴 글의 개수를 출력 출력 예시 email, post count
-- 서브쿼리 사용
select email,(select count(*)from post p where p.author_id=a.id) as count from author a;

-- from절 위치에 서브쿼리 
select a.* from (select * from author) as a;

-- group by 컬럼명 : 특정 컬럼으로 데이터를 그룹화 하여 하나의 행(row)처럼 취급한다
select author_id from post group by author_id;
select author_id,count(*) from post group by author_id;

-- 회원 별로 본인의 쓴 글의 개수를 출력 출력 예시 email, post count
-- left join 사용
select a.email,COUNT(p.author_id) as post_count
from author a left join post p
on a.id = p.author_id
group by a.email;
-- 내가 이해 안된 부분 
-- select a.email,COUNT(p.author_id) as post_count from author a left join post p on a.id = p.author_id group by p.author_id;
-- 위 코드로 짯을 시 글쓴적 없는 회원들중 한명만 출력 되고 나머지는 날아가는게 이해가 안됐지만 
-- 그림으로 보니 p.author_id 를 기준으로 잡을시 글을 쓴적이 없는 회원이 null 로 한묶음이 돼서 날아가는 걸 확인
-- post p left join author a 로 했을시에도 비슷한 맥락으로 날아감.


-- 집계 함수
select count(*) from author;
select sum(age) from author;
select avg(age) from author; 
-- 소수점 세번째 자리에서 반올림
select round(avg(agg),3) from author; 

-- group by와 집계함수
-- 회원의 이름 별 회원 수를 출력하고 이름별 나이의 평균값을 출력
select a.name,count(*) as count ,avg(a.age) as ag from author a group by name;

-- where group by
-- 날짜값이 null인 데이터는 제외하고  날짜별 post 글의 갯수 출력
select created_time as date,count(*) as date_count from post where created_time is not null group by date_format(created_time, '%Y-%m-%d') order by date_format(created_time, '%Y-%m-%d');
--                                                                                               앞에서 as date 치환 했기때문에 date로 치환가능


-- 자동차 종류 별 특정 옵션이 포함된 자동차 수 구하기 
SELECT CAR_TYPE,COUNT(*) AS CARS FROM CAR_RENTAL_COMPANY_CAR AS CAR 
WHERE OPTIONS LIKE '%통풍시트%'
OR OPTIONS LIKE '%열선시트%'
OR OPTIONS LIKE '%가죽시트%'
GROUP BY CAR_TYPE ORDER BY CAR_TYPE ASC;
-- 입양 시각 구하기(1)
SELECT date_format(DATETIME, '%H') as HOUR,COUNT(*) AS COUNT
FROM ANIMAL_OUTS 
WHERE DATE_FORMAT(DATETIME,'%H') < '20'
AND DATE_FORMAT(DATETIME,'%H') >= '09'
GROUP BY HOUR
ORDER BY HOUR;

-- group by 와 having 
-- having은 group by를 통해 나온 집계값에 대한 조건
-- ex 글을 3번이상 쓴 사람 id찾기
select author_id  from post group by author_id having count(*) >=3;

-- 지금까지 배운거 다쓰는 법  코테에서 이정도는 나온다. 
select aa,count(*) from A inner join B on where bb='xx' xx group by aa having count(*)>=2 order by yy limit 1;

-- 동명 동물 수 찾기 --> having
SELECT NAME,COUNT(*) AS COUNT FROM ANIMAL_INS WHERE NAME IS NOT NULL GROUP BY NAME HAVING COUNT(*)>=2 ORDER BY NAME;
-- 카테고리 별 도서 판매량 집계하기 -> 다나옴
SELECT B.CATEGORY,sum(S.SALES) AS TOTAL_SALES 
FROM BOOK B INNER JOIN BOOK_SALES S ON B.BOOK_ID=S.BOOK_ID 
WHERE DATE_FORMAT(S.SALES_DATE, '%Y-%m') = '2022-01' 
GROUP BY B.CATEGORY
ORDER BY B.CATEGORY;
-- 조건에 맞는 사용자의 총 거래금액 조회하기 -> 다나옴 
SELECT U.USER_ID,U.NICKNAME,SUM(B.PRICE) AS TOTAL_SALES FROM USED_GOODS_BOARD B INNER JOIN USED_GOODS_USER U
ON U.USER_ID = B.WRITER_ID
WHERE STATUS = 'DONE'
GROUP BY U.USER_ID
HAVING SUM(B.PRICE) >= 700000
ORDER BY SUM(B.PRICE);
