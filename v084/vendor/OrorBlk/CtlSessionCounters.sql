
DROP TABLE CtlSessionCounters
;
CREATE TABLE CtlSessionCounters(
        id numeric(38)  CONSTRAINT  CtlSessionCounters_id_pk PRIMARY KEY
          ,Term_id char(30)
          ,session_id varchar(256)
          ,nextcount numeric(38))
;
drop sequence CtlSessionCounters_seq
;  
create sequence CtlSessionCounters_seq
;  
CREATE OR REPLACE TRIGGER  TRISEQ_CtlSessionCounters
before insert on  CtlSessionCounters
for each row  
begin 
  IF :NEW.ID IS NULL THEN
     select CtlSessionCounters_seq.nextval into :NEW.ID from dual ;
  end if;
end;

