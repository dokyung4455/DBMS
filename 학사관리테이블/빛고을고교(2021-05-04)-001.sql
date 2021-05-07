--kscuser
CREATE TABLE tbl_student(
st_num	CHAR(5)		PRIMARY KEY,
st_dpcode	CHAR(4)	NOT NULL	,
st_grade	NUMBER	NOT NULL	,
st_name	nVARCHAR2(10)	NOT NULL,	
st_tel	VARCHAR2(13)		,
st_addr	nVARCHAR2(125)		
);

CREATE TABLE tbl_dept(
dp_code	CHAR(4)		PRIMARY KEY,
dp_name	nVARCHAR2(50)	NOT NULL,	
dp_pro	nVARCHAR2(10)	NOT NULL,	
dp_tel	VARCHAR2(5)		
);

CREATE TABLE tbl_sbject(
sb_code	CHAR(5)		PRIMARY KEY,
sb_name	nVARCHAR2(50)	NOT NULL,	
sb_prof	nVARCHAR2(20)
);

CREATE TABLE tbl_score(
sc_seq	NUMBER PRIMARY KEY,
sc_stnum	CHAR(5) NOT NULL,
sc_sbcode	CHAR(5) NOT NULL,
sc_score	NUMBER
);
DROP TABLE tbl_dept;
DROP TABLE tbl_score;
DROP TABLE tbl_student;
DROP TABLE tbl_sbject;

ALTER TABLE tbl_student
ADD CONSTRAINT fk_dpcode
FOREIGN KEY(st_dpcode)
REFERENCES tbl_dept(dp_code);

ALTER TABLE tbl_score
ADD CONSTRAINT fk_stnum
FOREIGN KEY(sc_stnum)
REFERENCES tbl_student(st_num);

ALTER TABLE tbl_score
ADD CONSTRAINT fk_sbcode
FOREIGN KEY (sc_sbcode)
REFERENCES tbl_sbject(sb_code);


SELECT ST.st_num AS 학번,
ST.st_name AS 이름,
ST.st_dpcode AS 학과코드,
DP.dp_name AS 학과명,
ST.st_tel AS 연락처,
ST.st_addr AS 주소
FROM tbl_student ST
LEFT JOIN tbl_dept DP
ON ST.st_dpcode = DP.dp_code;


DROP VIEW view_성적정보;
CREATE VIEW view_성적정보 AS(
SELECT 
SC.sc_seq 일련번호,
SC.sc_stnum 학번,
ST.st_name 학생이름,
ST.st_tel 전화번호,
SC.sc_sbcode 과목코드,
SB.sb_name 과목명,
sc.sc_score 점수,
SB.sb_prof 담임교수
   FROM tbl_score SC
    LEFT JOIN tbl_student ST
        ON SC.sc_stnum = ST.st_num
    LEFT JOIN tbl_sbject SB
        ON SC.sc_sbcode = SB.sb_code
);


SELECT 학번, 학생이름, SUM(점수) AS 총점,
ROUND(AVG(점수),1) AS 평균
FROM view_성적정보
GROUP BY 학번,학생이름
ORDER BY 학번;

-- DECODE() IF 와 유사한 조건검색 함수
-- DECODE(칼럼명,'값',return)
-- 칼럼명에 '값'이 담겨있으면 return명령을 수행하라
-- 과목명 칼럼에 국어 문자열이 담겨있으면 해당 레코드의 점수 칼럼 값을 표시하고
SELECT 학번,
    DECODE(과목명,'국어',점수) AS 국어점수,
    DECODE(과목명,'영어',점수) AS 영어점수,
    DECODE(과목명,'수학',점수) AS 수학점수
FROM view_성적정보
ORDER BY 학번;


-- 위의 SQL을 학번으로 GROUPING 하고 각 점수를 합산(SUM())하면 DBMS의 SQL에서는 (null) + 숫자 = 0 + 숫자와 같다
-- SUM(null,null,null,50,null) = SUM(0,0,0,50,0) 과 같다
CREATE VIEW view_성적보고서 AS
(
SELECT 학번,
    SUM(DECODE(과목명,'국어',점수)) AS 국어점수,
    SUM(DECODE(과목명,'영어',점수)) AS 영어점수,
    SUM(DECODE(과목명,'수학',점수)) AS 수학점수,
    SUM(DECODE(과목명,'데이터베이스',점수)) AS DB점수,
    SUM(DECODE(과목명,'미술',점수)) AS 미술점수,
    SUM(DECODE(과목명,'음악',점수)) AS 음악점수,
    SUM(DECODE(과목명,'소프트웨어공학',점수)) AS SW점수,
    SUM(점수) AS 총점,
    ROUND(AVG(점수),1) AS 평균
FROM view_성적정보
GROUP BY 학번
);

SELECT
    *
FROM view_성적보고서
ORDER BY 학번;

SELECT SC.학번,
ST.st_name AS 학생이름,
ST.st_tel AS 전화번호,
SC.국어점수, SC.영어점수, SC.수학점수
FROM view_성적보고서 SC
    LEFT JOIN tbl_student ST
        ON SC.학번 = ST.st_num;