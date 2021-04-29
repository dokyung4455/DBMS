-- 여기는 SCUSER 접속
-- 학생정보 table 생성
-- 학번 : 고정문자열 5, 기본키 설정
-- 이름 : 한글가변문자열 20, NULL값이 올 수 없다
-- 학과 : 한글가변문자열 10
-- 학년 : 가변문자열 5
-- 전화번호 : 가변문자열 5
-- 주소 : 한글가변문자열 125
DROP TABLE tbl_student; -- 이전꺼 삭제
CREATE TABLE tbl_student(
    st_num CHAR(5) PRIMARY KEY,
    st_name NVARCHAR2(20) NOT NULL,
    st_dept nVARCHAR2(20),
    st_grade VARCHAR(5),
    st_tel VARCHAR(20),
    st_addr nVARCHAR2(125)

);

-- 점수테이블
-- 학번 : 고정문자열 5 기본키
-- 과목 : 숫자형 NULL값 없이
DROP TABLE tbl_score; -- 이전꺼 삭제
CREATE TABLE tbl_score(
    sc_num CHAR(5) PRIMARY KEY,
    sc_kr NUMBER NOT NULL,
    sc_eng NUMBER NOT NULL,
    sc_math NUMBER NOT NULL
);

DROP VIEW VIEW_1반학생;
DROP VIEW VIEW_SCORE;
DROP VIEW VIEW_영어점수;

-- 임포트한 데이터 확인
SELECT * FROM tbl_student;

-- 임포트한 데이터의 개수(데이터 레코드 수) 확인
-- COUNT() : SQL의 통계함수, 개수를 계산
SELECT COUNT(*) FROM tbl_student;

SELECT * FROM tbl_score;
SELECT COUNT(*) FROM tbl_score;

-- 임포트된 성적데이터의 전체 과목 총점 계산
-- 통계함수 SUM() : 숫자칼럼의 합계를 계산
SELECT SUM(sc_kr) AS 국어총점,
    SUM(sc_eng) AS 영어총점,
    SUM(sc_math) AS 수학총점
FROM tbl_score;

-- 숫자칼럼의 연산을 하여 표시
SELECT sc_num AS 학번,
(sc_kr + sc_eng + sc_math ) AS 총점
FROM tbl_score;

-- 전체 과목의 평균점수
-- 통계함수 AVG()를 사용하여 과목평균 계산
SELECT AVG(sc_kr) 국어,
        AVG(sc_eng) 영어,
        AVG(sc_math) 수학
FROM tbl_score;

-- 전체학생 성적중에 국어 최고점, 국어 최저점
SELECT MAX(sc_kr), MIN(sc_kr)
FROM tbl_score;

-- 통계함수
-- COUNT(), SUM(), AVG(), MIN(),  MAX()
-- 개수,    합산,  평균,  최소값, 최대값
-- 통계함수를 사용할때 통계에 포함하지 않는 칼럼을
-- 보고자 할때는 GROUP BY를 사용하여 묶어줘야 한다
-- 학번으로 묶어서, 동일한 학번의 국어점수의 합계 할때
SELECT sc_num, SUM(sc_kr)
FROM tbl_score
GROUP BY sc_num;

SELECT * FROM tbl_score;

SELECT * FROM tbl_student
WHERE st_num = 'S0005';

-- 성적데이터를 보면서
-- 각 학생의 이름 등을 같이 보고싶다
-- 2개의 테이블을 JOIN을 하여 함께 보자
-- tbl_score 테이블을 나열하고
-- tbl_score의 sc_num 칼럼의 값과 같은 데이터를
-- tbl_student에서 찾아서 함께 나열하라
SELECT * 
FROM tbl_score, tbl_student
WHERE sc_num = st_num;

SELECT sc_num, st_name, st_dept, sc_kr, sc_eng, sc_math
FROM tbl_score, tbl_student
WHERE sc_num = st_num;

-- 2개 이상의 테이블을 JOIN할때
-- 각각 테이블의 칼럼(속성) 이름이 같은경우
-- 문제가 발생할 수 있다
SELECT tbl_score.sc_num,
        tbl_student.st_name,
        tbl_student.st_dept,
        tbl_score.sc_kr,
        tbl_score.sc_eng,
        tbl_score.sc_math
FROM tbl_score, tbl_student
WHERE sc_num = st_num;

-- 테이블 이름을 부착하기가 번거로우면
-- 테이블에 Alias를 추가한 후
-- 각 칼럼 이름에 Alias를 사용할 수 있다
-- 테이블 Alias에도 AS 키워드를 사용하지만
-- 오라클에서는 테이블 Alias에 AS 키워드를 사용하면
-- 문법 오류가 발생한다
SELECT SC.sc_num,
        ST.st_name,
        ST.st_dept,
        SC.sc_kr,
        SC.sc_eng,
        SC.sc_math
FROM tbl_score SC, tbl_student ST
WHERE sc_num = st_num;

-- 테스트를 위하여 학생데이터 일부를 삭제
DELETE FROM tbl_student
WHERE st_num >= 'S0080';

-- 학생데이터에서 일부를 삭제한 후
-- JOIN을 실행하였더니
-- 성적데이터가 79개밖에 조회되지 않는다
-- 성적데이터는 모두 100개가 있지만
-- 학생데이터는 79개만 남은 상태이기 때문에
-- JOIN한 결과가 학생데이터와 같은 수인 79개만
-- 조회(인출)되고 있다
-- EQ JOIN(참조 무결성이 보장되는 경우 사용하는 일반적인 JOIN)
SELECT SC.sc_num,
        ST.st_name,
        ST.st_dept,
        SC.sc_kr,
        SC.sc_eng,
        SC.sc_math
FROM tbl_score SC, tbl_student ST
WHERE sc_num = st_num;

-- 학생데이터에는 1 ~ 79번까지만 있고
-- 성적데이터에는 1 ~ 100까지 그대로 있다
-- 성적데이터의 80 ~ 100까지는
--   실제 존재하는 학생인지 아닌지 증명할 방법이 없다
-- 성적데이터는 무결성이 깨진상태가 된다
-- 학생테이블과 성적테이블간의 연관(관계) 참조가
--   무너진 상태가 된다
--      '== 참조 무결성이 오류가 발생했다' 라고 표현한다
-- 참조 무결성에 문제가 생긴경우
-- JOIN을 했을때 인출되는 데이터의 신뢰성을 보증 할 수 없다
SELECT * FROM tbl_score;
SELECT * FROM tbl_student;

-- 참조 무결성 여부와 관계없이
-- 모든 데이터를 JOIN하여 보고 싶을때

-- 참조무결성에 문제가 있어야 하는 경우
-- LEFT JOIN(LEFT OUT JOIN)
--   tbl_score 테이블의 데이터는 모두 보여주고
--   학생테이블에서 학번이 일치하는 학생이 있으면
--   같이 보여달라
-- 보통 table의 참조무결성 보증을 설정하는 경우가 있는데
-- 참조관계에 없는 다수의 테이블을 JOIN하여 보고 싶을때는
-- LEFT JOIN을 사용한다.
-- 모든 데이터의 참조 무결성이 잘 되고 있는지 확인 할 수 있다.
SELECT SC.sc_num,
        ST.st_name,
        ST.st_dept,
        SC.sc_kr,
        SC.sc_eng,
        SC.sc_math
FROM tbl_score SC
    LEFT JOIN tbl_student ST
    ON sc_num = st_num;

-- EQ JOIN을 실행할 때 조건을 부여하지 않으면
-- 테이블 x 테이블 만큼의 데이터가 출력된다
-- 이렇게 인출된 데이터를 "카티션곱" 이라고 한다.
SELECT COUNT(*)
FROM tbl_score, tbl_student;

-- 학생데이터에 없는 학생의 성적이 추가되어 있는지 여부를
-- 알아보고 싶을때
-- 참조 무결성에 오류가 있는지 알고 싶을때
SELECT COUNT(*)
FROM tbl_score
LEFT JOIN tbl_student
ON sc_num = st_num;

-- 학생데이터를 모두 나열하고
-- 학생데이터와 일치하는 성적데이터만 보여라
-- 학생데이터와 성적데이터간의 참조 무결성에 오류가 있기때문에
-- 실제 학생데이터에 존재하는 성적정보만 보고 싶을때
SELECT COUNT(*)
FROM tbl_student
LEFT JOIN tbl_score -- 왼쪽부터 나열.. 후 오른쪽 대입
ON st_num = sc_num;


-- ROUND() DBMS 시스템함수, 소수점이하 자릿수 제한
-- ROUND(값, 자릿수) : 자릿수 이하에서 반올림시전
-- ROUND(값, 0) : 소수점이하 반올림하고 정수형으로
-- TRUNC(값, 자릿수) : 자릿수 이하값은 무조건 절사

CREATE VIEW view_성적정보
AS
(
    SELECT SC.sc_num AS 학번,
            ST.st_name AS 이름,
            ST.st_dept AS 학과,
            ST.st_grade AS 학년,
            ST.st_tel AS 전화번호,
            SC.sc_kr AS 국어,
            SC.sc_eng AS 영어,
            SC.sc_math AS 수학,
            (SC.sc_kr + SC.sc_eng + SC.sc_math) AS 총점,
            ROUND((SC.sc_kr + SC.sc_eng + SC.sc_math)/3,2) AS 평균,
            ROUND((SC.sc_kr + SC.sc_eng + SC.sc_math)/3,0) AS 평균1
    FROM tbl_score SC
    LEFT JOIN tbl_student ST
    ON sc_num = st_num
); -- 여기 안에는 ORDER 할 수 없다

SELECT * FROM view_성적정보;

-- 학번순으로 정렬
SELECT * FROM view_성적정보
ORDER BY 학번;

-- 총점을 내림차순으로 정렬
SELECT * FROM view_성적정보
ORDER BY 총점 DESC;

-- DESC : 높은것부터 내림차순 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

-- 학과순으로 정렬하고
-- 같은 학과가 있으면 다시 총점순으로 정렬
SELECT * FROM view_성적정보
ORDER BY 학과, 총점 DESC;

-- 학과별로 묶고
-- 각 학과의 총점을 계산하고
-- 평균도 계산
-- 학과칼럼을 GROUP BY로 묶지 않으면 오류가 발생한다
SELECT 학과, SUM(총점) AS 학과총점, ROUND (AVG(평균),0) AS 학과평균
FROM view_성적정보
GROUP BY 학과  -- 학과별로 묶어서
ORDER BY 학과평균 DESC, 학과총점 DESC;
-- ORDER BY ROUND(AVG(평균),0) DESC, SUM(총점) DESC; 
        -- 총점을 계산하고 높은순부터 내림차로 보이기





