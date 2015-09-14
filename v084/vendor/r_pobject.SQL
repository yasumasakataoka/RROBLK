CREATE 
OR REPLACE FORCE VIEW "RAILS"."R_POBJECTS" ( 
  "POBJECT_CODE"
  , "POBJECT_OBJECTTYPE"
  , "POBJECT_EXPIREDATE"
  , "POBJECT_UPDATED_AT"
  , "POBJECT_REMARK"
  , "POBJECT_CREATED_AT"
  , "POBJECT_UPDATE_IP"
  , "POBJECT_RUBYCODE"
  , "ID"
  , "POBJECT_ID"
  , "POBJECT_PERSON_ID_UPD"
  , "PERSON_ID_UPD"
  , "PERSON_CODE_UPD"
  , "PERSON_NAME_UPD"
  , "POBJECT_CONTENTS"
) AS 
select
  pobject.code pobject_code
  , pobject.objecttype pobject_objecttype
  , pobject.expiredate pobject_expiredate
  , pobject.updated_at pobject_updated_at
  , pobject.remark pobject_remark
  , pobject.created_at pobject_created_at
  , pobject.update_ip pobject_update_ip
  , pobject.rubycode pobject_rubycode
  , pobject.id id
  , pobject.id pobject_id
  , pobject.persons_id_upd pobject_person_id_upd
  , person_upd.person_id_upd person_id_upd
  , person_upd.person_code_upd person_code_upd
  , person_upd.person_name_upd person_name_upd
  , pobject.contents pobject_contents 
from
  pobjects pobject
  , upd_persons person_upd 
where
  person_upd.id = pobject.persons_id_upd
;
