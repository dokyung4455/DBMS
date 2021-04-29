CREATE TABLE tbl_books(
bk_isbn	CHAR(13)		PRIMARY KEY	,
bk_title	nVARCHAR2(125)	NOT NULL		,
bk_ccode	CHAR(5)	NOT NULL		,
bk_acode	CHAR(5)	NOT NULL		,
bk_date	CHAR(10)			,
bk_price	NUMBER			,
bk_pages	NUMBER			
);

INSERT INTO tbl_books (bk_isbn, bk_title, bk_ccode, bk_acode, bk_date, bk_price, bk_pages)
VALUES ('9845487844124','아름다운 인생','32456','23412','2010-04-84',75800,154);

SELECT
    *
FROM tbl_books;

DROP TABLE tbl_books;

CREATE TABLE tbl_company(
cp_code CHAR(5) PRIMARY KEY	,
cp_title nVARCHAR2(125) NOT NULL,
cp_ceo nVARCHAR2(20) ,
cp_tel VARCHAR2(20) ,
cp_addr nVARCHAR2(125),
cp_genre nVARCHAR2(30)
);

INSERT INTO tbl_company (cp_code,cp_title,cp_ceo,cp_tel,cp_addr,cp_genre)VALUES('15412','세상만사재앙또재앙','림춘','010-7655-4455','서울특별시 성북구 동선동 473-7','호러');

CREATE TABLE tbl_author(
au_code	CHAR(5)		PRIMARY KEY	,
au_name	nVARCHAR2(50)	NOT NULL		,
au_tel	VARCHAR2(20)			,
au_addr	nVARCHAR2(125)			,
au_genre	nVARCHAR2(30)			
);

INSERT INTO tbl_author(au_code,au_name,au_tel,au_addr,au_genre) VALUES('78454','림춘','010-8447-8754','경기도 고양시 일산서구 가좌동 123번지','로맨스');

SELECT * FROM tbl_books;
SELECT * FROM tbl_company;
SELECT * FROM tbl_author;

DROP TABLE tbl_books;
DROP TABLE tbl_company;
DROP TABLE tbl_author;

SELECT 
bk_isbn AS ISBN, 
bk_title AS 도서명,
C.cp_title AS 출판사명,
C.cp_ceo AS 출판사대표,
A.au_name AS 저자명,
A.au_tel AS 저자연락처,
bk_date AS 출판일,
bk_price AS 가격
FROM tbl_books B 
LEFT JOIN tbl_company C ON b.bk_ccode = c.cp_code
LEFT JOIN tbl_author A ON b.bk_acode = a.au_code;

SELECT 
bk_isbn 도서코드,
bk_title 도서명,
cp_title 출판사명,
cp_ceo 출판사대표,
au_name 작가명,
bk_date 출판일,
bk_price 가격,
bk_pages 페이지
FROM tbl_books LEFT JOIN tbl_company ON bk_ccode = cp_code LEFT JOIN tbl_author ON bk_acode = au_code;

/*
고정 문자열 type칼럼 주의사항
CHAR() TYPE의 문자열 칼럼은 실제 지정되는 데이터 type에 따라 주의를 해야한다
만약 데이터가 숫자값으로만 되어 있는 경우
00001, 00002 와 같이 입력 할 경우 0을 삭제해 버리는 경우가 있다.
(엑셀에서 import하는) 실제 데이터가 날짜 타입일 경우 SQL의 날짜형 데이터로 변환한 후 다시 문자열로 변환하여 저장
칼럼을 PK로 설정하지 않는 경우는 가급정 CHAR로 설정하지 말고 VARCHAR2로 설정하는 것이 좋다.
고정문자열 칼럼으로 조회를 할때 아래와 같은 조건을 부여하면 데이터가 조회 되지 않는 현상이 발생할 수 있다.
WHERE 코드 = '00001'
*/

SELECT
    *
FROM view_도서정보 WHERE ISBN = '9791188850426';

-- 도서명 앞에 엘리트가 들어간 모든 데이터
SELECT * FROM
WHERE 도서명 LIKE '엘리트%';

-- 출판사명에 넥 문자열이 포함된 모든 데이터
SELECT * FROM
WHERE 출판사명 LIKE '%넥%';

-- 출판일이 2018인 모든 데이터
SELECT * FROM view_도서정보
WHERE 출판일 >= '2018-01-01' AND 출판일 <= '2018-12-31';

SELECT * FROM view_도서정보
WHERE 출판일 BETWEEN '2018-01-01' AND '2018-12-31';


-- SUBSTR() 함수를 사용한 문자열 자르기
-- SUBSTR(문자열데이터,시작위치,개수)
SELECT * FROM view_도서정보
WHERE SUBSTR(출판일,0,4) = '2018';

CREATE VIEW view_도서정보
AS
(
    SELECT bk_isbn AS ISBN, bk_title AS 도서명,
    C.cp_title AS 출판사명, C.cp_ceo As 출판사대표,
    A.au_name AS 저자명, A.au_tel AS 저자연락처,
    bk_date AS 출판일, bk_price AS 가격
    FROM tbl_books B
        LEFT JOIN tbl_company C
            ON B.bk_ccode = C.cp_code
        LEFT JOIN tbl_author A
            ON B.bk_acode = A.au_code
);            


