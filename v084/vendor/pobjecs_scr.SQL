
  CREATE OR REPLACE FORCE VIEW "RAILS"."SCR_POBJECTS" 
("POBJECT_CODE",  "POBJECT_EXPIREDATE", "POBJECT_UPDATED_AT", 
"POBJECT_CONTENS", "POBJECT_REMARK", "POBJECT_CREATED_AT", "POBJECT_UPDATE_IP", "ID", "POBJECT_ID", 
"PERSON_CODE_UPD", "PERSON_NAME_UPD", "POBJECT_RUBYCODE","POBJECT_PERSON_ID_UPD") AS 
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
  , person_upd.code updperson_code_upd
  , person_upd.name updperson_name_upd
  , pobject.rubycode updpobject_rubycode 
  ,pobject.persons_id_upd pobject_person_id_upd
from
  pobjects pobject
  , persons person_upd 
where
  person_upd.id = pobject.persons_id_upd
  and pobject.objecttype = 'screen'
  ;
