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


CREATE OR REPLACE FORCE VIEW "RAILS"."R_SECTS" ("ID", "SECT_ID", "SECT_LOCA_ID_SECTS", "LOCA_CODE_SECTS", "LOCA_NAME_SECTS",
 "LOCA_ABBR_SECTS", "LOCA_ZIP_SECTS", "LOCA_COUNTRY_SECTS", "LOCA_PRFCT_SECTS", "LOCA_ADDR1_SECTS", "LOCA_ADDR2_SECTS", "LOCA_TEL_SECTS", 
 "LOCA_FAX_SECTS", "LOCA_MAIL_SECTS", "LOCA_REMARK_SECTS", "SECT_REMARK", "SECT_EXPIREDATE", "SECT_PERSON_ID_UPD", "PERSON_CODE_UPD", 
 "PERSON_NAME_UPD", "PERSON_EMAIL_UPD",  "SECT_UPDATE_IP", "SECT_CREATED_AT", "SECT_UPDATED_AT") AS 
  select sect.id ,sect.id sect_id ,sect.locas_id_sects sect_loca_id_sects , loca_sects.loca_code loca_code_sects,
 loca_sects.loca_name loca_name_sects,
 loca_sects.loca_abbr loca_abbr_sects,
 loca_sects.loca_zip loca_zip_sects,
 loca_sects.loca_country loca_country_sects,
 loca_sects.loca_prfct loca_prfct_sects,
 loca_sects.loca_addr1 loca_addr1_sects,
 loca_sects.loca_addr2 loca_addr2_sects,
 loca_sects.loca_tel loca_tel_sects,
 loca_sects.loca_fax loca_fax_sects,
 loca_sects.loca_mail loca_mail_sects,
 loca_sects.loca_remark loca_remark_sects,
sect.remark sect_remark ,sect.expiredate sect_expiredate ,sect.persons_id_upd sect_person_id_upd ,
 person_upd.code person_code_upd,
 person_upd.name person_name_upd,
 person_upd.email person_email_upd,
sect.update_ip sect_update_ip ,sect.created_at sect_created_at ,sect.updated_at sect_updated_at
 from sects sect ,r_locas  loca_sects,persons  person_upd
 where  loca_sects.loca_id = sect.locas_id_sects and  person_upd.id = sect.persons_id_upd
;
 ;
 CREATE OR REPLACE FORCE VIEW "RAILS"."CHRG_PERSONS"
 ("ID", "PERSON_ID", "PERSON_CODE", "PERSON_NAME",
  "PERSON_EMAIL", LOCA_ID_SECT, loca_code_sect,loca_name_sect,person_EXPIREDATE) AS 
  select person.id,person.id person_id ,person.code person_code,person.name person_name ,
  person.email person_email_chrg ,sect.SECT_LOCA_ID_SECTS LOCA_ID_SECT, sect.loca_code_sects loca_code_sect,
  sect.loca_name_sects loca_name_sect,person.EXPIREDATE person_EXPIREDATE
 from persons person ,usergroups usergroup,screenlevels screenlevel, r_sects sect
 where person.UserGroups_id= usergroup.id and person.screenlevels_id = screenlevel.id
 and person.sects_id = sect.id
 ;
 CREATE OR REPLACE FORCE VIEW "RAILS"."UPD_PERSONS"
 ("ID", "PERSON_ID","PERSON_CODE","PERSON_NAME","PERSON_EXPIREDATE") AS 
  select  person.id, person.id person_id ,person.code person_code,person.name person_name,person.EXPIREDATE person_EXPIREDATE
 from persons person 
 ;
  CREATE OR REPLACE FORCE VIEW "RAILS"."R_PERSONS"
 ("ID", "PERSON_ID", "PERSON_CODE", "PERSON_NAME",
  "PERSON_EMAIL",  loca_code_sect,loca_name_sect,"USERGROUP_CODE",person_EXPIREDATE) AS 
  select person.id,person.id person_id ,person.code person_code,person.name person_name,
  person.email person_email, sect.loca_code_sects loca_code_sects,
  sect.loca_name_sects loca_name_sect,usergroup.code usergroup_code,person.EXPIREDATE person_EXPIREDATE
 from persons person ,usergroups usergroup,screenlevels screenlevel, r_sects sect
 where person.UserGroups_id= usergroup.id and person.screenlevels_id = screenlevel.id
 and person.sects_id = sect.id
 ;

