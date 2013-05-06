
DROP TABLE Persons
;
CREATE TABLE Persons
  ( id numeric(38)
  ,Code varchar(10)
  ,Name VARCHAR(50)
  ,UserGroups_id numeric(38)
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
insert into  Persons(id,code,name, UserGroups_id,Sects_id,email,Expiredate,Persons_id_Upd)
values(0,'0','system',0,0,'yasumasa_kataoka@voice.ocn.ne.jp','2099/12/31',0)
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
 person.created_at person_created_at ,person.updated_at person_updated_at,
 usergroup.code usergroup_code,usergroup.name usergroup_name
 from persons person ,usergroups usergroup
 where person.UserGroups_id= usergroup.id
;
