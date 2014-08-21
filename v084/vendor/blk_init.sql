
DROP TABLE Persons
;
CREATE TABLE Persons
  ( id numeric(38)
  ,Code varchar(10)
  ,Name VARCHAR(50)
  ,UserGroups_id numeric(38)
  ,Sects_id numeric(38)
  ,scrlvs_id numeric(38)
  ,Email VARCHAR(50)
  ,Remark VARCHAR(100)
  ,Expiredate date
  ,Persons_id_Upd numeric(38)
  ,Update_IP varchar(40)
  ,created_at timestamp(6)
  ,Updated_at timestamp(6)
  , CONSTRAINT Persons_id_pk PRIMARY KEY (id)
  , CONSTRAINT Persons_16_uk  UNIQUE (Code)
)
;
drop sequence Persons_seq
;  
create sequence Persons_seq
;
insert into  Persons(id,code,name, UserGroups_id,Sects_id,email,Expiredate,Persons_id_Upd,screenlevels_id)
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
  ,Updated_at timestamp(6)
  ,Expiredate timestamp(6)
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
  ,created_at timestamp(6)
  ,Updated_at timestamp(6)
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
  ,Locas_id_sect number(38)
  ,Remark varchar(200)
  ,Expiredate date
  ,Persons_id_Upd number(38)
  ,Update_IP varchar(40)
  ,created_at timestamp(6)
  ,Updated_at timestamp(6)
  , CONSTRAINT Sects_id_pk PRIMARY KEY (id)
)
;
drop sequence Sects_seq
;  
create sequence Sects_seq
; 

insert into  sects(id,Locas_id_sect, persons_id_upd,Expiredate)
values(0,0,0,'2099/12/31')
;
CREATE TABLE ScrLVS
 ( id NUMBER(38)
 ,CODE varchar(30)
 ,Expiredate date
 ,Remark VARCHAR(200)
 ,Persons_id_Upd NUMBER(38)
 ,Update_IP varchar(40)
 ,created_at timestamp(6)
 ,Updated_at timestamp(6)
 , CONSTRAINT ScreenLEVELS_id_pk PRIMARY KEY (id)
)
;
create sequence ScrLVS_seq
; 
insert into  scrlvs(id,code, persons_id_upd,Expiredate)
values(0,'0',0,'2099/12/31')
;

  CREATE OR REPLACE FORCE VIEW "RAILS"."R_PERSONS" ("PERSON_CODE", "PERSON_EXPIREDATE", "PERSON_UPDATED_AT", "PERSON_NAME", "PERSON_REMARK", 
  "PERSON_CREATED_AT", "PERSON_UPDATE_IP", "PERSON_USERGROUP_ID", "USERGROUP_NAME", "USERGROUP_CODE", "USERGROUP_REMARK", "USERGROUP_ID", "PERSON_EMAIL", 
  "ID", "PERSON_ID", "PERSON_PERSON_ID_UPD", "UPDPERSON_ID_UPD", "UPDPERSON_CODE_UPD", "UPDPERSON_NAME_UPD", "PERSON_SECT_ID", "SECT_ID", 
  "LOCA_ID_SECT", "LOCA_CODE_SECT", "LOCA_NAME_SECT", "LOCA_ABBR_SECT", "LOCA_ZIP_SECT", "LOCA_COUNTRY_SECT", "LOCA_PRFCT_SECT", "LOCA_ADDR1_SECT", "LOCA_ADDR2_SECT", 
  "LOCA_TEL_SECT", "LOCA_FAX_SECT", "LOCA_MAIL_SECT", "LOCA_REMARK_SECT", 
  "SECT_REMARK", "PERSON_SCRLV_ID", "SCRLV_LEVEL1", "SCRLV_ID", "SCRLV_REMARK", "SCRLV_CODE") AS 
 select person.code person_code ,person.expiredate person_expiredate ,person.updated_at person_updated_at ,person.name person_name ,person.remark person_remark ,
  person.created_at person_created_at ,person.update_ip person_update_ip ,person.usergroups_id person_usergroup_id , usergroup.usergroup_name usergroup_name,
  usergroup.usergroup_code usergroup_code, usergroup.usergroup_remark usergroup_remark, usergroup.usergroup_id usergroup_id,person.email person_email ,
  person.id id,person.id person_id ,person.persons_id_upd person_person_id_upd , person_upd.updperson_id updperson_id_upd, person_upd.updperson_code updperson_code_upd,
  person_upd.updperson_name updperson_name_upd,person.sects_id person_sect_id , sect.sect_id sect_id, 
  sect.loca_id_sect loca_id_sect, sect.loca_code_sect loca_code_sect, sect.loca_name_sect loca_name_sect, sect.loca_abbr_sect loca_abbr_sect,
  sect.loca_zip_sect loca_zip_sect, sect.loca_country_sect loca_country_sect, sect.loca_prfct_sect loca_prfct_sect, sect.loca_addr1_sect loca_addr1_sect,
  sect.loca_addr2_sect loca_addr2_sect, sect.loca_tel_sect loca_tel_sect, sect.loca_fax_sect loca_fax_sect, sect.loca_mail_sect loca_mail_sect,
  sect.loca_remark_sect loca_remark_sect, sect.sect_remark sect_remark,person.scrlvs_id person_scrlv_id , scrlv.scrlv_level1 scrlv_level1, scrlv.scrlv_id scrlv_id, scrlv.scrlv_remark scrlv_remark, scrlv.scrlv_code scrlv_code
 from persons person ,r_usergroups  usergroup,upd_persons  person_upd,r_sects  sect,r_scrlvs  scrlv
 where  usergroup.id = person.usergroups_id and  person_upd.id = person.persons_id_upd and  sect.id = person.sects_id and  scrlv.id = person.scrlvs_id;

drop table "RAILS"."SIO_R_PERSONS" 
;
CREATE OR REPLACE FORCE VIEW "RAILS"."R_LOCAS" 
("ID", "LOCA_ID", "LOCA_CODE", "LOCA_NAME", "LOCA_ABBR", "LOCA_ZIP", "LOCA_COUNTRY", "LOCA_PRFCT", "LOCA_ADDR1", 
"LOCA_ADDR2", "LOCA_TEL", "LOCA_FAX", "LOCA_MAIL", "LOCA_REMARK", "LOCA_EXPIREDATE", "LOCA_PERSON_ID_UPD", 
"PERSON_ID_UPD","PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EMAIL_UPD",
"LOCA_UPDATE_IP", "LOCA_CREATED_AT", "LOCA_UPDATED_AT") AS 
  select loca.id ,loca.id loca_id ,loca.code loca_code ,loca.name loca_name ,loca.abbr loca_abbr ,loca.zip loca_zip ,
  loca.country loca_country ,loca.prfct loca_prfct ,loca.addr1 loca_addr1 ,loca.addr2 loca_addr2 ,loca.tel loca_tel ,
  loca.fax loca_fax ,loca.mail loca_mail ,loca.remark loca_remark ,loca.expiredate loca_expiredate ,loca.persons_id_upd loca_person_id_upd ,
   person_upd.id person_id_upd, 
   person_upd.code person_code_upd,
 person_upd.name person_name_upd,
 person_upd.email person_email_upd,
loca.update_ip loca_update_ip ,loca.created_at loca_created_at ,loca.updated_at loca_updated_at
 from locas loca ,persons  person_upd
 where  person_upd.id = loca.persons_id_upd
;


CREATE OR REPLACE FORCE VIEW "RAILS"."R_SECTS" ("ID", "SECT_ID", "LOCA_ID_SECT", "LOCA_CODE_SECT", "LOCA_NAME_SECT",
 "LOCA_ABBR_SECT", "LOCA_ZIP_SECT", "LOCA_COUNTRY_SECT", "LOCA_PRFCT_SECT", 
 "LOCA_ADDR1_SECT", "LOCA_ADDR2_SECT", "LOCA_TEL_SECT", 
 "LOCA_FAX_SECT", "LOCA_MAIL_SECT", "LOCA_REMARK_SECT",
 "SECT_REMARK",  "SECT_EXPIREDATE", "SECT_PERSON_ID_UPD", "PERSON_CODE_UPD", 
 "PERSON_NAME_UPD", "PERSON_EMAIL_UPD",  "SECT_UPDATE_IP", "SECT_CREATED_AT", "SECT_UPDATED_AT") AS 
select sect.id ,sect.id sect_id ,loca_sect.loca_id loca_id_sect , loca_sect.loca_code loca_code_sect, loca_sect.loca_name loca_name_sect,
 loca_sect.loca_abbr loca_abbr_sect, loca_sect.loca_zip loca_zip_sect, loca_sect.loca_country loca_country_sect, loca_sect.loca_prfct loca_prfct_sect,
 loca_sect.loca_addr1 loca_addr1_sect, loca_sect.loca_addr2 loca_addr2_sect, loca_sect.loca_tel loca_tel_sect,
 loca_sect.loca_fax loca_fax_sect, loca_sect.loca_mail loca_mail_sect, loca_sect.loca_remark loca_remark_sect,
sect.remark sect_remark ,sect.expiredate sect_expiredate ,sect.persons_id_upd sect_person_id_upd ,
 person_upd.code person_code_upd,
 person_upd.name person_name_upd,
 person_upd.email person_email_upd,
sect.update_ip sect_update_ip ,sect.created_at sect_created_at ,sect.updated_at sect_updated_at
 from sects sect ,r_locas  loca_sect,persons  person_upd
 where  loca_sect.loca_id = sect.locas_id_sect and  person_upd.id = sect.persons_id_upd
;
 CREATE OR REPLACE FORCE VIEW "RAILS"."UPD_PERSONS"
 ("ID", "UPDPERSON_ID","UPDPERSON_CODE","UPDPERSON_NAME") AS 
  select  person.id, person.id updperson_id ,person.code updperson_code,person.name updperson_name
 from persons person
 ;
CREATE OR REPLACE FORCE VIEW "RAILS"."R_CHRGPERSONS" ("ID", "CHRGPERSON_ID", "CHRGPERSON_REMARK", "CHRGPERSON_EXPIREDATE", "CHRGPERSON_UPDATE_IP", "CHRGPERSON_CREATED_AT", 
"CHRGPERSON_UPDATED_AT", "CHRGPERSON_PERSON_ID_UPD", "PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EXPIREDATE_UPD", "CHRGPERSON_PERSON_ID_CHRG", "PERSON_CODE_CHRG",
"PERSON_EXPIREDATE_CHRG", "PERSON_NAME_CHRG", "PERSON_REMARK_CHRG", "PERSON_USERGROUP_ID_CHRG", "USERGROUP_NAME_CHRG", "USERGROUP_CODE_CHRG", "USERGROUP_EXPIREDATE_CHRG", 
"USERGROUP_REMARK_CHRG", "USERGROUP_ID_CHRG", "PERSON_EMAIL_CHRG", "PERSON_ID_CHRG",  
"PERSON_SECT_ID_CHRG", "SECT_ID_CHRG", "LOCA_ID_SECT_CHRG", "LOCA_CODE_SECT_CHRG", "LOCA_NAME_SECT_CHRG", "LOCA_ABBR_SECT_CHRG", "LOCA_ZIP_SECT_CHRG",
"LOCA_COUNTRY_SECT_CHRG", "LOCA_PRFCT_SECT_CHRG", "LOCA_ADDR1_SECT_CHRG", "LOCA_ADDR2_SECT_CHRG", "LOCA_TEL_SECT_CHRG", "LOCA_FAX_SECT_CHRG", "LOCA_MAIL_SECT_CHRG",
"LOCA_REMARK_SECT_CHRG", "SECT_REMARK_CHRG", "SECT_EXPIREDATE_CHRG") AS 
  select chrgperson.id id,chrgperson.id chrgperson_id ,chrgperson.remark chrgperson_remark ,chrgperson.expiredate chrgperson_expiredate ,chrgperson.update_ip chrgperson_update_ip ,
  chrgperson.created_at chrgperson_created_at ,chrgperson.updated_at chrgperson_updated_at ,chrgperson.persons_id_upd chrgperson_person_id_upd , person_upd.person_id person_id_upd, 
  person_upd.person_code person_code_upd, person_upd.person_name person_name_upd, person_upd.person_expiredate person_expiredate_upd,chrgperson.persons_id_chrg chrgperson_person_id_chrg ,
  person_chrg.person_code person_code_chrg, person_chrg.person_expiredate person_expiredate_chrg, person_chrg.person_name person_name_chrg, person_chrg.person_remark person_remark_chrg, 
  person_chrg.person_usergroup_id person_usergroup_id_chrg, person_chrg.usergroup_name usergroup_name_chrg, person_chrg.usergroup_code usergroup_code_chrg, 
  person_chrg.usergroup_expiredate usergroup_expiredate_chrg, person_chrg.usergroup_remark usergroup_remark_chrg, person_chrg.usergroup_id usergroup_id_chrg, 
  person_chrg.person_email person_email_chrg, person_chrg.person_id person_id_chrg, 
  person_chrg.person_sect_id person_sect_id_chrg, person_chrg.sect_id sect_id_chrg, person_chrg.loca_id_sects loca_id_sect_chrg,
  person_chrg.loca_code_sects loca_code_sect_chrg, person_chrg.loca_name_sects loca_name_sect_chrg, person_chrg.loca_abbr_sects loca_abbr_sect_chrg, 
  person_chrg.loca_zip_sects loca_zip_sect_chrg, person_chrg.loca_country_sects loca_country_sect_chrg, person_chrg.loca_prfct_sects loca_prfct_sect_chrg, 
  person_chrg.loca_addr1_sects loca_addr1_sect_chrg, person_chrg.loca_addr2_sects loca_addr2_sect_chrg, person_chrg.loca_tel_sects loca_tel_sect_chrg, 
  person_chrg.loca_fax_sects loca_fax_sect_chrg, person_chrg.loca_mail_sects loca_mail_sect_chrg, person_chrg.loca_remark_sects loca_remark_sect_chrg, 
  person_chrg.sect_remark sect_remark_chrg, person_chrg.sect_expiredate sect_expiredate_chrg
 from chrgpersons chrgperson ,upd_persons  person_upd,r_persons  person_chrg
 where  person_upd.id = chrgperson.persons_id_upd and  person_chrg.id = chrgperson.persons_id_chrg ;

