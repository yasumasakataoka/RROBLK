CREATE OR REPLACE FORCE VIEW "RAILS"."TBL_POBJECTS" 
("POBJECT_CODE",  "POBJECT_EXPIREDATE", "POBJECT_UPDATED_AT", 
 "POBJECT_REMARK", "POBJECT_CREATED_AT", "POBJECT_UPDATE_IP", "ID", "POBJECT_ID", "POBJECT_PERSON_ID_UPD",
"PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD") AS 
select
  pobject.code pobject_code
  , pobject.expiredate pobject_expiredate
  , pobject.updated_at pobject_updated_at
  , pobject.remark pobject_remark
  , pobject.created_at pobject_created_at
  , pobject.update_ip pobject_update_ip
  , pobject.id id
  , pobject.id pobject_id
  , pobject.persons_id_upd pobject_person_id_upd
  , person_upd.id updperson_id_upd
  , person_upd.code updperson_code_upd
  , person_upd.name updperson_name_upd
from
  pobjects pobject
  , persons person_upd 
where
  person_upd.id = pobject.persons_id_upd
  and pobject.objecttype = 'tbl'
  ;
  