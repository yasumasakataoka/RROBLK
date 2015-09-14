CREATE 
OR REPLACE FORCE VIEW "RAILS"."R_PERSONS" ( 
  "ID"
  , "PERSON_ID"
  , "PERSON_REMARK"
  , "PERSON_EXPIREDATE"
  , "PERSON_UPDATE_IP"
  , "PERSON_CREATED_AT"
  , "PERSON_UPDATED_AT"
  , "PERSON_PERSON_ID_UPD"
  , "UPDPERSON_ID_UPD"
  , "UPDPERSON_CODE_UPD"
  , "UPDPERSON_NAME_UPD"
  , "PERSON_CODE"
  , "PERSON_NAME"
  , "PERSON_SECT_ID"
  , "SECT_ID"
  , "SECT_REMARK"
  , "SECT_LOCA_ID"
  , "LOCA_CODE_SECT"
  , "LOCA_ABBR_SECT"
  , "LOCA_PRFCT_SECT"
  , "LOCA_TEL_SECT"
  , "LOCA_COUNTRY_SECT"
  , "LOCA_NAME_SECT"
  , "LOCA_REMARK_SECT"
  , "LOCA_MAIL_SECT"
  , "LOCA_ADDR1_SECT"
  , "LOCA_ZIP_SECT"
  , "LOCA_FAX_SECT"
  , "LOCA_ADDR2_SECT"
  , "LOCA_ID_SECT"
  , "PERSON_EMAIL"
  , "PERSON_SCRLV_ID"
  , "SCRLV_LEVEL1"
  , "SCRLV_ID"
  , "SCRLV_REMARK"
  , "SCRLV_CODE"
  , "PERSON_USRGRP_ID"
  , "USRGRP_ID"
  , "USRGRP_REMARK"
  , "USRGRP_CODE"
  , "USRGRP_NAME"
  , "USRGRP_CONTENTS"
) AS 
select
  person.id id
  , person.id person_id
  , person.remark person_remark
  , person.expiredate person_expiredate
  , person.update_ip person_update_ip
  , person.created_at person_created_at
  , person.updated_at person_updated_at
  , person.persons_id_upd person_person_id_upd
  , person_upd.updperson_id updperson_id_upd
  , person_upd.updperson_code updperson_code_upd
  , person_upd.updperson_name updperson_name_upd
  , person.code person_code
  , person.name person_name
  , person.sects_id person_sect_id
  , sect.sect_id sect_id
  , sect.sect_remark sect_remark
  , sect.sect_loca_id sect_loca_id
  , sect.loca_code_sect loca_code_sect
  , sect.loca_abbr_sect loca_abbr_sect
  , sect.loca_prfct_sect loca_prfct_sect
  , sect.loca_tel_sect loca_tel_sect
  , sect.loca_country_sect loca_country_sect
  , sect.loca_name_sect loca_name_sect
  , sect.loca_remark_sect loca_remark_sect
  , sect.loca_mail_sect loca_mail_sect
  , sect.loca_addr1_sect loca_addr1_sect
  , sect.loca_zip_sect loca_zip_sect
  , sect.loca_fax_sect loca_fax_sect
  , sect.loca_addr2_sect loca_addr2_sect
  , sect.SECT_loca_id loca_id_sect
  , person.email person_email
  , person.scrlvs_id person_scrlv_id
  , scrlv.scrlv_level1 scrlv_level1
  , scrlv.scrlv_id scrlv_id
  , scrlv.scrlv_remark scrlv_remark
  , scrlv.scrlv_code scrlv_code
  , person.usrgrps_id person_usrgrp_id
  , usrgrp.usrgrp_id usrgrp_id
  , usrgrp.usrgrp_remark usrgrp_remark
  , usrgrp.usrgrp_code usrgrp_code
  , usrgrp.usrgrp_name usrgrp_name
  , usrgrp.usrgrp_contents usrgrp_contents 
from
  persons person
  , upd_persons person_upd
  , r_sects sect
  , r_scrlvs scrlv
  , r_usrgrps usrgrp
where person.persons_id_upd = person_upd.ID
and person.sects_id = sect.ID
and person.SCRLVS_ID = scrlv.ID
and person.USRGRPS_ID = usrgrp.ID
  ; 



