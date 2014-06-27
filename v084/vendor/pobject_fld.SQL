CREATE OR REPLACE FORCE VIEW "RAILS"."fld_POBJECTS" 
("POBJECT_CODE",  "POBJECT_EXPIREDATE", "POBJECT_UPDATED_AT", 
"POBJECT_CONTENS", "POBJECT_REMARK", "POBJECT_CREATED_AT", "POBJECT_UPDATE_IP", "ID", "POBJECT_ID", 
"PERSON_CODE_UPD", "PERSON_NAME_UPD", "POBJECT_RUBYCODE") AS 
  select
  pobject.code pobject_code
  , pobject.expiredate pobject_expiredate
  , pobject.updated_at pobject_updated_at
  , pobject.contens pobject_contens
  , pobject.remark pobject_remark
  , pobject.created_at pobject_created_at
  , pobject.update_ip pobject_update_ip
  , pobject.id id
  , pobject.id pobject_id
  , person_upd.code person_code_upd
  , person_upd.name person_name_upd
  , pobject.rubycode pobject_rubycode 
from
  pobjects pobject
  , persons person_upd 
where
  person_upd.id = pobject.persons_id_upd
  and pobject.objecttype = 'tbl_field'
  ;
