 --nhuser
/*
iolist 테이블과 Prod 테이블간의 상품으로 JOIN을 하여 Null값이 없는걸로 확인되었다.

1. iolist 테이블에 상품코드 칼럼을 추가
2. product table에서 상품코드를 가져와 iolist 테이블에 저장
3. iolist 테이블과 prod 테이블간에 상품코드를 기준으로 JOIN을 할 수 있도록 테이블 변경을 시작한다.
*/

-- tbl_iolist에 상품코드를 저장할 칼럼을 추가
ALTER TABLE tbl_iolist -- 테이블 iolist 속성변경
ADD io_pcode CHAR(6); -- io_pcode라는 칼럼 추가 형태는 고정문자열 CHAR(6) 형태

DESC tbl_iolist; -- 속성확인

-- 생성된 io_pcode 칼럼에 io_pname 칼럼의 상품이름에 해당하는 코드 데이터를 tbl_product에서 가져와서 저장을 해야한다.

-- 테이블의 데이터를 변경하기 위한 DML
-- tbl_iolist 전체를 반복하면서 io_pcode 칼럼에 값을 갱신하라
-- 이때 tbl_iolist의 상품으로 tbl_product 데이터를 조회하여 일치하는 데이터가 있으면 구중에 상품코드 칼럼의 값을 가져와서
-- io_pcode칼럼에 저장하라
UPDATE tbl_iolist IO
SET io_pcode = (
    SELECT p_code FROM tbl_product P
    WHERE IO.io_pname =  P.p_name
);


UPDATE tbl_iolist IO
    SET io_price = 'A';

/*
iolist 전체 데이터를 보여라
iolist 데이터의 상품이름을 product 테이블에서 조회하여
일치하는 상품이 있으면 리스트를 보일때 같이 보여달라는 Sub Query

*/

SELECT IO.io_pname,
(
    SELECT P.p_name FROM tbl_product P
    WHERE IO.io_pname = P.p_name

) AS 상품이름,
(
    SELECT P.p_code FROM tbl_product P
    WHERE IO.io_pname = P.p_name

) AS 상품코드
FROM tbl_iolist IO;


-- tbl ioList의 상품코드 칼럼에 저장된 값과 tbl_product의 상품코드를 JOIN하여 데이터 조회
SELECT IO.io_pcode, IO.io_pname, P.p_code, P.p_name, P.p_iprice, P.p_oprice
FROM
tbl_iolist IO
    LEFT JOIN tbl_product P
        ON IO.io_pcode = P.p_code;
        
/*
매입매출 데이터에서 거래처 정보를 추출하고 거래처 정보 데이터를 생성한 후,
거래처 코드를 만들고 tbl_dept Table을 작성한 다음 데이터 import

iolist에 io_dcode 칼럼을 추가하고 데이터를 Update 수행
*/

--1. iolist로 부터 거래처명, 대표자명 칼럼을 기준으로 중복되지 않는 데이터를 조회
--      중복되지 않은 데이터를 조회
--      거래처명, 대표자명 순으로 정렬
-- projection : 기준이 되는 칼럼을 SELECT 표현
-- 필요한 칼러만 나타나며 전체데이터가 출력
-- 중복되지 않게(같은 데이터는 한번만 출력)
SELECT io_dname,io_dceo
    FROM tbl_iolist
        GROUP BY io_dname,io_dceo
        ORDER BY io_dname,io_dceo;
        
CREATE TABLE tbl_dept
(
d_code	CHAR(5)		PRIMARY KEY,
d_name	nVARCHAR2(50)	NOT NULL,	
d_coeo	nVARCHAR2(20)	NOT NULL,	
d_tel	VARCHAR2(20)		,
d_addr	nVARCHAR2(125)		,
d_product	nVARCHAR2(20)		
);

--import 된 거래처정보와 매입매출정보를 JOIN하여 NULL값이 있는지 확인
SELECT d_name, io_dname, d_coeo, d_code
FROM tbl_dept D
    LEFT JOIN tbl_iolist I
        ON d.d_name = i.io_dname AND io_dceo = d_coeo        
        GROUP BY d_name, io_dname, d_coeo, d_code
        ORDER BY d_name, io_dname, d_coeo, d_code;




--tbl_iolist에 io_dcode 칼럼추가, CHAR(5)
ALTER TABLE tbl_iolist
ADD io_dcode CHAR(5);


-- 거래처정보 table에서 거래처 코드를 조회하여 tbl_iolist의 io_dcode 칼럼에 update
UPDATE tbl_iolist
SET io_dcode = (
SELECT d_code
FROM tbl_dept
WHERE io_dname = d_name AND io_dceo = d_coeo
);
