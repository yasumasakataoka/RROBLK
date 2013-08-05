Create person_typ AS OBJECT (
  idno           NUMBER,
  name           VARCHAR2(30),
  phone          VARCHAR2(20),
  MAP MEMBER FUNCTION get_idno RETURN NUMBER )
NOT FINAL;
/
CREATE or replace TYPE BODY person_typ AS
  MAP MEMBER FUNCTION get_idno RETURN NUMBER IS
  BEGIN
    RETURN idno;
  END;
END;
/
CREATE TABLE contacts (
  contact         person_typ,
  contact_date    DATE );
INSERT INTO contacts VALUES (
  person_typ (65, 'Vrinda Mills', '1-800-555-4412'), '2009/02/12' );
  
CREATE TYPE location_typ  AS OBJECT(
  building_no  NUMBER,
  city         VARCHAR2(40) );
/
CREATE TYPE office_typ AS OBJECT (
  office_id    VARCHAR(10),
  office_loc   location_typ,
  occupant     person_typ );
/
CREATE TABLE office_tab OF office_typ (
             office_id      PRIMARY KEY );
/             
CREATE TABLE department_mgrs (
  dept_no     NUMBER PRIMARY KEY, 
  dept_name   CHAR(20),
  dept_mgr    person_typ,
  dept_loc    location_typ,
  CONSTRAINT  dept_loc_cons1
      UNIQUE (dept_loc.building_no, dept_loc.city),
  CONSTRAINT  dept_loc_cons2
       CHECK (dept_loc.city IS NOT NULL) );
INSERT INTO department_mgrs VALUES 
          ( 102, 'Physical Sciences', 
           person_typ(65,'Vrinda  Mills', ' 1-800-555-4412'),
           location_typ(3001, 'Palo Alto'));
/

CREATE TYPE rational_typ AS OBJECT (
  num INTEGER,
  den INTEGER,
  MEMBER PROCEDURE normalize_proc);
/
create or replace function gcd(a number, b number)

return number is
begin
   if b = 0 then
      return a;
   else
      return gcd(b,mod(a,b));
   end if;
end;
/




CREATE or replace TYPE BODY rational_typ AS 
  MEMBER PROCEDURE normalize_proc IS
    g INTEGER;
  BEGIN
    g := gcd(SELF.num, SELF.den);
    g := gcd(num, den);           -- equivalent to previous line
    num := num / g;
    den := den / g;
  END normalize_proc;
END;
/

CREATE TYPE rectangle_typ AS OBJECT ( 
  len NUMBER,
  wid NUMBER,
  MAP MEMBER FUNCTION area RETURN NUMBER);
/
CREATE TYPE BODY rectangle_typ AS 
  MAP MEMBER FUNCTION area RETURN NUMBER IS
  BEGIN
     RETURN len * wid;
  END area;
END;
/

ALTER TYPE person_typ FINAL;   -----エラーになりました
/
-----　　別の名前で　練習
------  ここから別環境
CREATE TYPE Mperson_typ AS OBJECT (
   idno           NUMBER,
   name           VARCHAR2(30),
   phone          VARCHAR2(20)) 
NOT FINAL;
/
CREATE TYPE employee_typ UNDER Mperson_typ(
    emp_id NUMBER, 
    mgr VARCHAR2(30));
/

CREATE TYPE student_typ UNDER Mperson_typ(
    std_id NUMBER, 
    age VARCHAR2(30));
/
-----  CREATE TABLE Mpersons  (p Mperson_typ);  NG 照会できない
------　SELECT で　エラー
/
CREATE TABLE Mpersons OF Mperson_typ;
/
drop table Mpersons;
/
SELECT * FROM Mpersons;
/
INSERT INTO Mpersons 
  VALUES (employee_typ(51, 'Joe Lane', '1-800-555-1312',  55,'HISTORY'));
/

INSERT INTO Mpersons 
  VALUES (student_typ(52, 'Joe Lane j', '1-800-555-1313',  56,'10 sai'));
/
\
  ELECT value(p) FROM Mpersons　p;
/
SELECT p.idno,p.mgr FROM Mpersons p;
/
SELECT  ref(p.employee_typ)  FROM Mpersons p;
