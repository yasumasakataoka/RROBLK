CREATE OR REPLACE FORCE VIEW "RAILS"."A_POBJECTS" ("ID", "POBJECT_ID",  "POBJECT_CODE", "POBJECT_CONTENS", "POBJECT_REMARK", 
"POBJECT_RUBYCODE", "POBJECT_PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EMAIL_UPD", "PERSON_REMARK_UPD",
 "USERGROUP_CODE_UPD", "USERGROUP_NAME_UPD", "POBJECT_UPDATE_IP", "POBJECT_CREATED_AT", "POBJECT_EXPIREDATE", "POBJECT_UPDATED_AT") AS 
  select pobject.id ,pobject.id pobject_id ,pobject.objecttype pobject_objecttype ,pobject.code pobject_code ,
  pobject.fieldlength pobject_fieldlength ,pobject.datapresion pobject_datapresion ,pobject.datascale pobject_datascale ,
  pobject.contens pobject_contens ,pobject.remark pobject_remark ,pobject.rubycode pobject_rubycode ,
  pobject.persons_id_upd pobject_person_id_upd , person_upd.person_code person_code_upd,
 person_upd.person_name person_name_upd,
 person_upd.person_email person_email_upd,
 person_upd.person_remark person_remark_upd,
 person_upd.usergroup_code usergroup_code_upd,
 person_upd.usergroup_name usergroup_name_upd,
pobject.update_ip pobject_update_ip ,pobject.created_at pobject_created_at ,pobject.expiredate pobject_expiredate ,
pobject.updated_at pobject_updated_at ,pobject.ukeyflg pobject_ukeyflg ,pobject.chartype pobject_chartype
 from pobjects pobject ,r_persons  person_upd
 where  person_upd.person_id = pobject.persons_id_upd
 and POBJECT_OBJECTTYPE = 'T'
 ;
  CREATE OR REPLACE FORCE VIEW "RAILS"."B_POBJECTS" ("ID", "POBJECT_ID",  "POBJECT_CODE", 
 "POBJECT_FIELDLENGTH", "POBJECT_DATAPRESION", "POBJECT_DATASCALE", "POBJECT_CONTENS", "POBJECT_REMARK", "POBJECT_RUBYCODE",
  "POBJECT_PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EMAIL_UPD", "PERSON_REMARK_UPD", "USERGROUP_CODE_UPD", 
  "USERGROUP_NAME_UPD", "POBJECT_UPDATE_IP", "POBJECT_CREATED_AT", "POBJECT_EXPIREDATE", "POBJECT_UPDATED_AT", 
   "POBJECT_CHARTYPE") AS 
  select pobject.id ,pobject.id pobject_id ,pobject.objecttype pobject_objecttype ,pobject.code pobject_code ,
  pobject.fieldlength pobject_fieldlength ,pobject.datapresion pobject_datapresion ,pobject.datascale pobject_datascale 
  ,pobject.contens pobject_contens ,pobject.remark pobject_remark ,pobject.rubycode pobject_rubycode ,
  pobject.persons_id_upd pobject_person_id_upd , person_upd.person_code person_code_upd,
 person_upd.person_name person_name_upd,
 person_upd.person_email person_email_upd,
 person_upd.person_remark person_remark_upd,
 person_upd.usergroup_code usergroup_code_upd,
 person_upd.usergroup_name usergroup_name_upd,
pobject.update_ip pobject_update_ip ,pobject.created_at pobject_created_at ,pobject.expiredate pobject_expiredate ,
pobject.updated_at pobject_updated_at ,pobject.ukeyflg pobject_ukeyflg ,pobject.chartype pobject_chartype
 from pobjects pobject ,r_persons  person_upd
 where  person_upd.person_id = pobject.persons_id_upd
  and POBJECT_OBJECTTYPE = '0'
