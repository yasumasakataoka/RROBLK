
  CREATE OR REPLACE FORCE VIEW RAILS.asstwh_LOCAS ("ID", "LOCA_ID", "LOCA_REMARK", "LOCA_EXPIREDATE", "LOCA_UPDATE_IP", "LOCA_CREATED_AT", "LOCA_UPDATED_AT", "LOCA_PERSON_ID_UPD", "PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "LOCA_CODE", "LOCA_NAME", "LOCA_ABBR", "LOCA_ZIP", "LOCA_COUNTRY", "LOCA_PRFCT", "LOCA_ADDR1", "LOCA_ADDR2", "LOCA_TEL", "LOCA_FAX", "LOCA_MAIL") AS 
  select loca.id id,loca.id loca_id ,loca.remark loca_remark ,loca.expiredate loca_expiredate ,loca.update_ip loca_update_ip ,loca.created_at loca_created_at ,loca.updated_at loca_updated_at ,loca.persons_id_upd loca_person_id_upd , person_upd.person_id_upd person_id_upd, person_upd.person_code_upd person_code_upd, person_upd.person_name_upd person_name_upd,loca.code loca_code ,loca.name loca_name ,loca.abbr loca_abbr ,loca.zip loca_zip ,loca.country loca_country ,loca.prfct loca_prfct ,loca.addr1 loca_addr1 ,loca.addr2 loca_addr2 ,loca.tel loca_tel ,loca.fax loca_fax ,loca.mail loca_mail 
 from locas loca ,upd_persons  person_upd
 where  person_upd.id = loca.persons_id_upd
 and exists(select 1 from asstwhs asstwh where loca.id = asstwh.locas_id_asstwh and expiredate > current_date );
 
 
  CREATE OR REPLACE FORCE VIEW RAILS.custrcvplc_LOCAS ("ID", "LOCA_ID", "LOCA_REMARK", "LOCA_EXPIREDATE", "LOCA_UPDATE_IP", "LOCA_CREATED_AT", "LOCA_UPDATED_AT", "LOCA_PERSON_ID_UPD", "PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "LOCA_CODE", "LOCA_NAME", "LOCA_ABBR", "LOCA_ZIP", "LOCA_COUNTRY", "LOCA_PRFCT", "LOCA_ADDR1", "LOCA_ADDR2", "LOCA_TEL", "LOCA_FAX", "LOCA_MAIL") AS 
  select loca.id id,loca.id loca_id ,loca.remark loca_remark ,loca.expiredate loca_expiredate ,loca.update_ip loca_update_ip ,loca.created_at loca_created_at ,loca.updated_at loca_updated_at ,loca.persons_id_upd loca_person_id_upd , person_upd.person_id_upd person_id_upd, person_upd.person_code_upd person_code_upd, person_upd.person_name_upd person_name_upd,loca.code loca_code ,loca.name loca_name ,loca.abbr loca_abbr ,loca.zip loca_zip ,loca.country loca_country ,loca.prfct loca_prfct ,loca.addr1 loca_addr1 ,loca.addr2 loca_addr2 ,loca.tel loca_tel ,loca.fax loca_fax ,loca.mail loca_mail 
 from locas loca ,upd_persons  person_upd
 where  person_upd.id = loca.persons_id_upd
 and exists(select 1 from custrcvplcs custrcvplc where loca.id = custrcvplc.locas_id_custrcvplc and expiredate > current_date );

 
 