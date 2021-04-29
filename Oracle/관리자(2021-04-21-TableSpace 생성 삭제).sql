-- 관리자 권한 접속

-- Table space 생성하기

CREATE TABLESPACE iolistDB
DATAFILE 'c:/oraclexe/data/iolist.dbf'
SIZE 1M AUTOEXTEND ON NEXT 1K;

-- TABLESPACE 삭제하기
-- 반드시 옵션을 같이 작성하기
-- DROP TABLESPACE iolistDB
-- 옵션 ICLUDING CONTENTS AND DATAFILES CASCADE CONSTRAINTS; 

CREATE USER iouser IDENTIFIED BY iouser
DEFAULT TABLESPACE iolistDB;

-- 사용자 삭제
-- DROP USER iouser CASCADE;

GRANT DBA TO iouser;



