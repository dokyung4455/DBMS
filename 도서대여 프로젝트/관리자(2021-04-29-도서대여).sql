-- 여기는 관리자 접속 SQL 입니다. --
-- 프로젝트에서 사용할 TableSpace, User 생성
CREATE TABLESPACE RentBookDB2
DATAFILE 'C:/oraclexe/data/retbook2.dbf'
SIZE 1m AUTOEXTEND ON NEXT 1k;

CREATE USER bookuser2 IDENTIFIED BY bookuser2
DEFAULT TABLESPACE RentBookDB2;

GRANT DBA TO bookuser;