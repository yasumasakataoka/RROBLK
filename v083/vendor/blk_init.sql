
DROP TABLE Persons
;
CREATE TABLE Persons
  ( id numeric(38)
  ,Code varchar(10)
  ,Name VARCHAR(50)
  ,UserGroups_id numeric(38)
  ,ScreenLevels_id numeric(38)
  ,Sects_id numeric(38)
  ,Email VARCHAR(50)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT Persons_id_pk PRIMARY KEY (id)
  , CONSTRAINT Persons_16_uk  UNIQUE (Code,Expiredate)
)
;
drop sequence Persons_seq
;  
create sequence Persons_seq
;
insert into  Persons(id,code,name, UserGroups_id,Sects_id,email,Expiredate,Persons_id_Upd,ScreenLevels_id)
values(0,'0','system',0,0,'yasumasa_kataoka@voice.ocn.ne.jp','2099/12/31',0,0)
; 
DROP TABLE UserGroups
;
CREATE TABLE UserGroups
  ( id numeric(38)
  ,Code VARCHAR2(30)
  ,Name varchar(20)
  ,Remark VARCHAR(100)
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  ,Expiredate date
  , CONSTRAINT UserGroups_id_pk PRIMARY KEY (id)
  , CONSTRAINT UserGroups_41_uk  UNIQUE (Code,Expiredate)
)
;

drop sequence UserGroups_seq
;  
create sequence UserGroups_seq
;  

insert into  usergroups(id,code,name, persons_id_upd,Expiredate)
values(0,'0','system',0,'2099/12/31')
;
DROP TABLE Locas
;
CREATE TABLE Locas
  ( id number(38)
  ,Code varchar(40)
  ,Name VARCHAR(100)
  ,ABBR varchar(50)
  ,zip varchar(10)
  ,country varchar(20)
  ,PRFCT varchar(20)
  ,addr1 VARCHAR(50)
  ,addr2 VARCHAR(50)
  ,Tel varchar(20)
  ,Fax varchar(20)
  ,mail varchar(20)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT Locas_id_pk PRIMARY KEY (id)
  , CONSTRAINT Locas_23_uk  UNIQUE (Code,Expiredate)
)
;
drop sequence Locas_seq
;  
create sequence Locas_seq
; 
insert into  locas(id,code,name, persons_id_upd,Expiredate)
values(0,'0','system',0,'2099/12/31')
;
DROP TABLE Sects
;
CREATE TABLE Sects
  ( id number(38)
  ,Locas_id_sects number(38)
  ,Remark number(38)
  ,Expiredate varchar(40)
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT Sects_id_pk PRIMARY KEY (id)
)
;
drop sequence Sects_seq
;  
create sequence Sects_seq
; 

insert into  sects(id,Locas_id_sects, persons_id_upd,Expiredate)
values(0,0,0,'2099/12/31')
;

create or replace view  r_persons as 
 select person.id,person.id person_id ,person.code person_code ,person.name person_name ,person.email person_email ,
 person.remark person_remark ,person.expiredate person_expiredate ,person.update_ip person_update_ip ,
 person.created_at person_created_at ,person.updated_at person_updated_at,person.persons_id_upd person_id_upd,
 usergroup.code usergroup_code,usergroup.name usergroup_name
 from persons person ,usergroups usergroup
 where person.UserGroups_id= usergroup.id
;
require "rubygems"
require "ruby-plsql"
plsql.connection = OCI8.new("rails","rails","xe")
require File.dirname(__FILE__) +  "/vendor/OrorBlk/screen_names_set.rb
doaddsrn = AddScreen.new
doaddsrn.addmain "R_PERSONS"



drop table "RAILS"."SIO_R_PERSONS" 
;
CREATE TABLE "RAILS"."SIO_R_PERSONS" 
   (	"SIO_ID" NUMBER(38,0), 
	"SIO_USER_CODE" NUMBER(38,0), 
	"SIO_TERM_ID" VARCHAR2(30), 
	"SIO_SESSION_ID" VARCHAR2(256), 
	"SIO_COMMAND_RESPONSE" CHAR(1), 
	"SIO_SESSION_COUNTER" NUMBER(38,0), 
	"SIO_CLASSNAME" VARCHAR2(30), 
	"SIO_VIEWNAME" VARCHAR2(30), 
	"SIO_CODE" VARCHAR2(30), 
	"SIO_STRSQL" VARCHAR2(4000), 
	"SIO_TOTALCOUNT" NUMBER(38,0), 
	"SIO_RECORDCOUNT" NUMBER(38,0), 
	"SIO_START_RECORD" NUMBER(38,0), 
	"SIO_END_RECORD" NUMBER(38,0), 
	"SIO_SORD" VARCHAR2(256), 
	"SIO_SEARCH" VARCHAR2(10), 
	"SIO_SIDX" VARCHAR2(256), 
	"ID" NUMBER, 
	"PERSON_ID" NUMBER, 
	"PERSON_CODE" VARCHAR2(10), 
	"PERSON_NAME" VARCHAR2(50), 
	"PERSON_EMAIL" VARCHAR2(50), 
	"PERSON_REMARK" VARCHAR2(100), 
	"PERSON_EXPIREDATE" DATE, 
	"PERSON_UPDATE_IP" VARCHAR2(40), 
	"PERSON_ID_UPD" NUMBER,
	"PERSON_CREATED_AT" DATE, 
	"PERSON_UPDATED_AT" DATE, 
        "SCREENLEVEL_CODE" VARCHAR(30),     -------- SCREENLEVELÇÃíËã`ÇÇÌÇ∑ÇÍÇ»Ç¢Ç±Ç∆ÅB
        "SCREENLEVEL_NAME" VARCHAR(30),
	"USERGROUP_CODE" VARCHAR2(30), 
	"USERGROUP_NAME" VARCHAR2(20), 
	"SIO_ORG_TBLNAME" VARCHAR2(30), 
	"SIO_ORG_TBLID" NUMBER(38,0), 
	"SIO_ADD_TIME" DATE, 
	"SIO_REPLAY_TIME" DATE, 
	"SIO_RESULT_F" CHAR(1), 
	"SIO_MESSAGE_CODE" CHAR(10), 
	"SIO_MESSAGE_CONTENTS" VARCHAR2(256), 
	"SIO_CHK_DONE" CHAR(1), 
	 CONSTRAINT "SIO_R_PERSONS_ID_PK" PRIMARY KEY ("SIO_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"
;
