
DROP TABLE CUL_PERIOD ;

CREATE TABLE CUL_PERIOD (
  POS_COD CHAR(8) DEFAULT '',
 APP_STA_D DATE DEFAULT '',
 APP_END_D DATE DEFAULT '',
 P_Minute INTEGER,
 DUPLICATE_TIME DATE ) TABLESPACE DATA PCTFREE 20 PCTUSED 60 ;

-----  不要　多分
----- CREATE TABLE CUL_DATE (
----  POS_COD CHAR(8) DEFAULT '',
----- APP_STA_D DATE DEFAULT '',
---- APP_END_D DATE DEFAULT '',
---- DUPLICATE_TIME DATE ) TABLESPACE DATA PCTFREE 20 PCTUSED 60 ;



UPDATE  CUL_PERIOD SET P_Minute  =  (APP_END_D -  APP_STA_D) *1440 

-----insert into CUL_DATE 
-----select distinct pos_cod,to_date(to_char(APP_STA_D ,'yyyy/mm/dd'),'yyyy/mm/dd') app_sta_d, 
-----  to_date(to_char(APP_end_D ,'yyyy/mm/dd'),'yyyy/mm/dd') app_end_d,null
----- from CUL_PERIOD 

/

------ STA　と　END は同一日であること。




