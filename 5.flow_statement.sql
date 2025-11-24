-- 흐름제어 : if, ifnull, case when
-- if(a,b,c) : a 조건이 참이면 b반환, 그렇지 않으면 c를 반환
select id, if(name is null,'익명사용자',name) as name from author;

-- ifnull(a,b) : a가 null이면 b를 반환, null이 아니면 a를 그대로 반환
select id, ifnull(name,'익명사용자') as name from author;

-- case when end
select id, 
case
when name is null then '익명사용자'
when name= 'hong1' then '홍길동1'
when name= 'hong2' then '홍길동2'
else name
end
as name
from author;

-- 경기도에 위치한 식품창고 목록 출력하기
select 
    WAREHOUSE_ID,
    WAREHOUSE_NAME,
    ADDRESS,
    if(FREEZER_YN is null, 'N', FREEZER_YN) as FREEZER_YN
from FOOD_WAREHOUSE
where WAREHOUSE_NAME like '%경기%';
-- 조건에 부합하는 중고거래 상태 조회하기
-- 코드를 입력하세요
SELECT
BOARD_ID,
WRITER_ID,
TITLE,
PRICE,
case
when STATUS='SALE' then '판매중'
when STATUS='RESERVED' then '예약중'
when STATUS='DONE' then '거래완료'
end
as STATUS
from USED_GOODS_BOARD
where date_format(CREATED_DATE,'%Y-%m-%d')='2022-10-05'
ORDER BY BOARD_ID desc;
-- 12세 이하인 여자 환자 목록 출력 하기
-- 코드를 입력하세요
select
PT_NAME,
PT_NO, 
GEND_CD,
AGE, 
if(TLNO is null,'NONE',TLNO) as TLNO
from PATIENT
where GEND_CD = 'W' and
age <= 12 
order by age desc,
PT_NAME asc;

