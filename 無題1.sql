update screenfields
set edoptsize = 10
where edoptsize = 0
;
update screenfields
set edoptsize = 30
where edoptsize is null
;
  CREATE OR REPLACE FORCE VIEW "RAILS"."R_FIELDCODES" ("ID", "FIELDCODE_ID", "FIELDCODE_POBJECT_ID_FLD", "POBJECT_CODE_FLD", "POBJECT_OBJECTTYPE_FLD", "POBJECT_CONTENS_FLD", "POBJECT_REMARK_FLD", "POBJECT_ID_FLD", "POBJECT_RUBYCODE_FLD", "FIELDCODE_FTYPE", "FIELDCODE_FIELDLENGTH", "FIELDCODE_DATAPRESION", "FIELDCODE_DATASCALE", "FIELDCODE_REMARK", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "FIELDCODE_UPDATE_IP", "FIELDCODE_CREATED_AT", "FIELDCODE_EXPIREDATE", "FIELDCODE_UPDATED_AT", "FIELDCODE_FSEQ") AS 
  select fieldcode.id ,fieldcode.id fieldcode_id ,fieldcode.pobjects_id_fld fieldcode_pobject_id_fld , pobject_fld.pobject_code pobject_code_fld, pobject_fld.pobject_objecttype pobject_objecttype_fld, pobject_fld.pobject_contens pobject_contens_fld, pobject_fld.pobject_remark pobject_remark_fld, pobject_fld.pobject_id pobject_id_fld, pobject_fld.pobject_rubycode pobject_rubycode_fld,fieldcode.ftype fieldcode_ftype ,fieldcode.fieldlength fieldcode_fieldlength ,fieldcode.datapresion fieldcode_datapresion ,fieldcode.datascale fieldcode_datascale ,fieldcode.remark fieldcode_remark ,person_upd.code person_code_upd ,person_upd.name person_name_upd,fieldcode.update_ip fieldcode_update_ip ,fieldcode.created_at fieldcode_created_at ,fieldcode.expiredate fieldcode_expiredate ,fieldcode.updated_at fieldcode_updated_at ,fieldcode.fseq fieldcode_fseq  
 from fieldcodes fieldcode ,r_pobjects  pobject_fld, persons   person_upd
 where  pobject_fld.pobject_id = fieldcode.pobjects_id_fld and  person_upd.id = fieldcode.persons_id_upd ;
 
 
 create or replace view r_blktbsfieldcodes as select blktbsfieldcode.connectseq blktbsfieldcode_connectseq ,
 blktbsfieldcode.expiredate blktbsfieldcode_expiredate ,blktbsfieldcode.updated_at blktbsfieldcode_updated_at ,blktbsfieldcode.remark blktbsfieldcode_remark ,
 blktbsfieldcode.created_at blktbsfieldcode_created_at ,blktbsfieldcode.update_ip blktbsfieldcode_update_ip ,blktbsfieldcode.fieldcodes_id blktbsfieldcode_fieldcode_id , 
 fieldcode.fieldcode_id fieldcode_id, fieldcode.fieldcode_pobject_id_fld fieldcode_pobject_id_fld, fieldcode.pobject_code_fld pobject_code_fld, 
 fieldcode.pobject_objecttype_fld pobject_objecttype_fld, fieldcode.pobject_contens_fld pobject_contens_fld, fieldcode.pobject_remark_fld pobject_remark_fld, 
 fieldcode.pobject_id_fld pobject_id_fld, fieldcode.pobject_rubycode_fld pobject_rubycode_fld, fieldcode.fieldcode_ftype fieldcode_ftype,
 fieldcode.fieldcode_fieldlength fieldcode_fieldlength, fieldcode.fieldcode_datapresion fieldcode_datapresion, fieldcode.fieldcode_datascale fieldcode_datascale,
 fieldcode.fieldcode_remark fieldcode_remark, fieldcode.fieldcode_expiredate fieldcode_expiredate, fieldcode.fieldcode_fseq fieldcode_fseq, 
 blktbsfieldcode.blktbs_id blktbsfieldcode_blktb_id , blktb.blktb_expiredate blktb_expiredate,
 blktb.blktb_remark blktb_remark, blktb.blktb_id blktb_id, blktb.blktb_pobject_id_tbl blktb_pobject_id_tbl, blktb.pobject_code_tbl pobject_code_tbl, 
 blktb.pobject_objecttype_tbl pobject_objecttype_tbl, blktb.pobject_contens_tbl pobject_contens_tbl, blktb.pobject_remark_tbl pobject_remark_tbl,
 blktb.pobject_id_tbl pobject_id_tbl, blktb.pobject_rubycode_tbl pobject_rubycode_tbl,blktbsfieldcode.id id,blktbsfieldcode.id blktbsfieldcode_id ,
 blktbsfieldcode.persons_id_upd blktbsfieldcode_person_id_upd , person_upd.person_id person_id_upd, person_upd.person_code person_code_upd,
 person_upd.person_name person_name_upd, person_upd.person_expiredate person_expiredate_upd
 from blktbsfieldcodes blktbsfieldcode ,r_fieldcodes fieldcode,r_blktbs blktb,upd_persons person_upd where fieldcode.fieldcode_id = blktbsfieldcode.fieldcodes_id 
 and blktb.blktb_id = blktbsfieldcode.blktbs_id and person_upd.person_id = blktbsfieldcode.persons_id_upd
 ;
   CREATE OR REPLACE FORCE VIEW "RAILS"."R_FIELDCODES" ("FIELDCODE_EXPIREDATE", "FIELDCODE_UPDATED_AT", "FIELDCODE_FTYPE", "FIELDCODE_REMARK", "FIELDCODE_CREATED_AT", 
   "FIELDCODE_UPDATE_IP", "FIELDCODE_DATASCALE", "FIELDCODE_DATAPRESION", "FIELDCODE_FIELDLENGTH", "ID", "FIELDCODE_ID", "FIELDCODE_FSEQ", "FIELDCODE_PERSON_ID_UPD", 
   "PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EXPIREDATE_UPD", "FIELDCODE_POBJECT_ID_FLD", "POBJECT_CODE_FLD", "POBJECT_OBJECTTYPE_FLD",
   "POBJECT_EXPIREDATE_FLD", "POBJECT_CONTENS_FLD", "POBJECT_REMARK_FLD", "POBJECT_RUBYCODE_FLD", "POBJECT_ID_FLD") AS 
  select fieldcode.expiredate fieldcode_expiredate ,fieldcode.updated_at fieldcode_updated_at ,fieldcode.ftype fieldcode_ftype ,fieldcode.remark fieldcode_remark ,
  fieldcode.created_at fieldcode_created_at ,fieldcode.update_ip fieldcode_update_ip ,fieldcode.datascale fieldcode_datascale ,fieldcode.datapresion fieldcode_datapresion ,
  fieldcode.fieldlength fieldcode_fieldlength ,fieldcode.id id,fieldcode.id fieldcode_id ,fieldcode.fseq fieldcode_fseq ,fieldcode.persons_id_upd fieldcode_person_id_upd ,
  person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, person_upd.person_name person_name_upd, person_upd.person_expiredate person_expiredate_upd,
  fieldcode.pobjects_id_fld fieldcode_pobject_id_fld , pobject_fld.pobject_code pobject_code_fld, pobject_fld.pobject_objecttype pobject_objecttype_fld, 
  pobject_fld.pobject_expiredate pobject_expiredate_fld, pobject_fld.pobject_contens pobject_contens_fld, pobject_fld.pobject_remark pobject_remark_fld, 
  pobject_fld.pobject_rubycode pobject_rubycode_fld, pobject_fld.pobject_id pobject_id_fld
 from fieldcodes fieldcode ,upd_persons  person_upd,r_pobjects  pobject_fld
 where  person_upd.person_id = fieldcode.persons_id_upd and  pobject_fld.pobject_id = fieldcode.pobjects_id_fld ;
 
 
 CREATE OR REPLACE FORCE VIEW "RAILS"."FLD_POBJECTS" 
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
select * from pobjects where rubycode is not null
and rubycode like '%command_r%'
;
update screenfields set RUBYCODE = '' where rubycode is not null
and id= 1100
;

  CREATE OR REPLACE FORCE VIEW "RAILS"."R_BLKTBS" ("BLKTB_EXPIREDATE", "BLKTB_UPDATED_AT", "BLKTB_REMARK", "BLKTB_CREATED_AT", "BLKTB_UPDATE_IP", "ID", 
  "BLKTB_ID", "BLKTB_POBJECT_ID_TBL", "POBJECT_CODE_TBL", "POBJECT_OBJECTTYPE_TBL", "POBJECT_CONTENS_TBL", "POBJECT_REMARK_TBL", "POBJECT_ID_TBL", 
  "POBJECT_RUBYCODE_TBL", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_ID_UPD") AS 
  select blktb.expiredate blktb_expiredate ,blktb.updated_at blktb_updated_at ,blktb.remark blktb_remark ,blktb.created_at blktb_created_at ,
  blktb.update_ip blktb_update_ip ,blktb.id id,blktb.id blktb_id ,blktb.pobjects_id_tbl blktb_pobject_id_tbl , pobject_tbl.pobject_code pobject_code_tbl,
  pobject_tbl.pobject_objecttype pobject_objecttype_tbl, pobject_tbl.pobject_contens pobject_contens_tbl, pobject_tbl.pobject_remark pobject_remark_tbl,
  pobject_tbl.pobject_id pobject_id_tbl, pobject_tbl.pobject_rubycode pobject_rubycode_tbl,
  person_upd.code person_code_upd ,person_upd.name person_name_upd,person_upd.id person_id_upd
 from blktbs blktb ,r_pobjects  pobject_tbl, persons   person_upd
 where  pobject_tbl.pobject_id = blktb.pobjects_id_tbl and  person_upd.id = blktb.persons_id_upd ;
 
 select * from r_blktbs where POBJECT_ID_TBL = '1811' 
 ;
 truncate table sio_r_blktbsfieldcodes
 ;
 truncate table  USERPROC0S
 ;
   CREATE OR REPLACE FORCE VIEW "RAILS"."R_BLKTBS" ("BLKTB_EXPIREDATE", "BLKTB_UPDATED_AT", "BLKTB_REMARK", "BLKTB_CREATED_AT", "BLKTB_UPDATE_IP", "ID", "BLKTB_ID", "BLKTB_POBJECT_ID_TBL", "POBJECT_CODE_TBL", "POBJECT_OBJECTTYPE_TBL", "POBJECT_CONTENS_TBL", "POBJECT_REMARK_TBL", "POBJECT_ID_TBL", "POBJECT_RUBYCODE_TBL", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_ID_UPD") AS 
  select blktb.expiredate blktb_expiredate ,blktb.updated_at blktb_updated_at ,blktb.remark blktb_remark ,blktb.created_at blktb_created_at ,
  blktb.update_ip blktb_update_ip ,blktb.id id,blktb.id blktb_id ,blktb.pobjects_id_tbl blktb_pobject_id_tbl , pobject_tbl.pobject_code pobject_code_tbl,
  pobject_tbl.pobject_objecttype pobject_objecttype_tbl, pobject_tbl.pobject_contens pobject_contens_tbl, pobject_tbl.pobject_remark pobject_remark_tbl,
  pobject_tbl.pobject_id pobject_id_tbl, pobject_tbl.pobject_rubycode pobject_rubycode_tbl,
  person_upd.person_code person_code_upd ,person_upd.person_name person_name_upd,person_upd.person_id person_id_upd
 from blktbs blktb ,r_pobjects  pobject_tbl, upd_persons   person_upd
 where  pobject_tbl.pobject_id = blktb.pobjects_id_tbl and  person_upd.id = blktb.persons_id_upd;
 
  select blktb.expiredate blktb_expiredate ,blktb.updated_at blktb_updated_at ,blktb.remark blktb_remark ,blktb.created_at blktb_created_at ,
  blktb.update_ip blktb_update_ip ,blktb.id id,blktb.id blktb_id ,blktb.pobjects_id_tbl blktb_pobject_id_tbl , pobject_tbl.pobject_code pobject_code_tbl,
  pobject_tbl.pobject_objecttype pobject_objecttype_tbl, pobject_tbl.pobject_contens pobject_contens_tbl, pobject_tbl.pobject_remark pobject_remark_tbl,
  pobject_tbl.pobject_id pobject_id_tbl, pobject_tbl.pobject_rubycode pobject_rubycode_tbl,
  person_upd.person_code_upd person_code_upd ,person_upd.person_name_upd person_name_upd,person_upd.person_id_upd person_id_upd
 from blktbs blktb ,r_pobjects  pobject_tbl, upd_persons   person_upd
 where  pobject_tbl.id = blktb.pobjects_id_tbl and  person_upd.id = blktb.persons_id_upd;
 
 
   CREATE OR REPLACE FORCE VIEW "RAILS"."R_POBJECTS" ("POBJECT_CODE", "POBJECT_OBJECTTYPE", "POBJECT_EXPIREDATE", "POBJECT_UPDATED_AT", "POBJECT_CONTENS", "POBJECT_REMARK", "POBJECT_CREATED_AT", "POBJECT_UPDATE_IP", "POBJECT_RUBYCODE", "ID", "POBJECT_ID", "POBJECT_PERSON_ID_UPD", "PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EXPIREDATE_UPD") AS 
  select pobject.code pobject_code ,pobject.objecttype pobject_objecttype ,pobject.expiredate pobject_expiredate ,pobject.updated_at pobject_updated_at ,pobject.contens pobject_contens ,pobject.remark pobject_remark ,
  pobject.created_at pobject_created_at ,pobject.update_ip pobject_update_ip ,pobject.rubycode pobject_rubycode ,pobject.id id,pobject.id pobject_id ,pobject.persons_id_upd pobject_person_id_upd , 
  person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, person_upd.person_name person_name_upd, person_upd.person_expiredate person_expiredate_upd
 from pobjects pobject ,upd_persons  person_upd
 where  person_upd.id = pobject.persons_id_upd ;


select pobject.code pobject_code ,pobject.objecttype pobject_objecttype ,pobject.expiredate pobject_expiredate ,pobject.updated_at pobject_updated_at ,pobject.contens pobject_contens ,pobject.remark pobject_remark ,
  pobject.created_at pobject_created_at ,pobject.update_ip pobject_update_ip ,pobject.rubycode pobject_rubycode ,pobject.id id,pobject.id pobject_id ,pobject.persons_id_upd pobject_person_id_upd , 
  person_upd.person_id person_id_upd, person_upd.person_code_upd person_code_upd, person_upd.person_name_upd person_name_upd, person_upd.person_expiredate_upd person_expiredate_upd
 from pobjects pobject ,upd_persons  person_upd
 where  person_upd.id = pobject.persons_id_upd ;
 
  CREATE OR REPLACE FORCE VIEW "RAILS"."R_SCREENFIELDS" ("SCREENFIELD_POBJECT_ID_SFD", "POBJECT_CODE_SFD", "POBJECT_OBJECTTYPE_SFD", "POBJECT_EXPIREDATE_SFD", "POBJECT_CONTENS_SFD", "POBJECT_REMARK_SFD", "POBJECT_RUBYCODE_SFD", "POBJECT_ID_SFD", "SCREENFIELD_EXPIREDATE", "SCREENFIELD_UPDATED_AT", "SCREENFIELD_EDOPTCOLS", "SCREENFIELD_EDOPTROW", "SCREENFIELD_WIDTH", "SCREENFIELD_INDISP", "SCREENFIELD_ROWPOS", "SCREENFIELD_SEQNO", "SCREENFIELD_HIDEFLG", "SCREENFIELD_MAXVALUE", "SCREENFIELD_EDITABLE", "SCREENFIELD_PARAGRAPH", "SCREENFIELD_SELECTION", "SCREENFIELD_CRTFIELD", "SCREENFIELD_EDOPTVALUE", "SCREENFIELD_SUBINDISP", "SCREENFIELD_TYPE", "SCREENFIELD_SUMKEY", "SCREENFIELD_REMARK", "SCREENFIELD_CREATED_AT", "SCREENFIELD_UPDATE_IP", "SCREENFIELD_EDOPTMAXLENGTH", "SCREENFIELD_DATASCALE", "SCREENFIELD_DATAPRECISION", "SCREENFIELD_MINVALUE", "SCREENFIELD_TBLKEY", "SCREENFIELD_EDOPTSIZE", "SCREENFIELD_COLPOS", "SCREENFIELD_RUBYCODE", "ID", "SCREENFIELD_ID", "SCREENFIELD_FORMATTER", "SCREENFIELD_PERSON_ID_UPD", "PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EXPIREDATE_UPD", "SCREENFIELD_SCREEN_ID", "SCREEN_EXPIREDATE", "SCREEN_STRWHERE", "SCREEN_ROWS_PER_PAGE", "SCREEN_ROWLIST", "SCREEN_HEIGHT", "SCREEN_POBJECT_ID_VIEW", "POBJECT_CODE_VIEW", "POBJECT_OBJECTTYPE_VIEW", "POBJECT_EXPIREDATE_VIEW", "POBJECT_CONTENS_VIEW", "POBJECT_REMARK_VIEW", "POBJECT_ID_VIEW", "POBJECT_RUBYCODE_VIEW", "SCREEN_FORM_PS", "SCREEN_STRGROUPORDER", "SCREEN_STRSELECT", "SCREEN_REMARK", "SCREEN_CDRFLAYOUT", "SCREEN_YMLCODE", "SCREEN_ID", "SCREEN_GRPCODENAME", "SCREEN_POBJECT_ID_SCR", "POBJECT_CODE_SCR", "POBJECT_OBJECTTYPE_SCR", "POBJECT_EXPIREDATE_SCR", "POBJECT_CONTENS_SCR", "POBJECT_REMARK_SCR", "POBJECT_ID_SCR", "POBJECT_RUBYCODE_SCR", "SCREEN_SCREENLEVEL_ID", "SCREENLEVEL_ID", "SCREENLEVEL_REMARK", "SCREENLEVEL_EXPIREDATE", "SCREENLEVEL_CODE") AS 
  select screenfield.pobjects_id_sfd screenfield_pobject_id_sfd , pobject_sfd.pobject_code pobject_code_sfd, pobject_sfd.pobject_objecttype pobject_objecttype_sfd,
  pobject_sfd.pobject_expiredate pobject_expiredate_sfd, pobject_sfd.pobject_contens pobject_contens_sfd, pobject_sfd.pobject_remark pobject_remark_sfd, 
  pobject_sfd.pobject_rubycode pobject_rubycode_sfd, pobject_sfd.pobject_id pobject_id_sfd,screenfield.expiredate screenfield_expiredate ,screenfield.updated_at screenfield_updated_at ,
  screenfield.edoptcols screenfield_edoptcols ,screenfield.edoptrow screenfield_edoptrow ,screenfield.width screenfield_width ,screenfield.indisp screenfield_indisp ,
  screenfield.rowpos screenfield_rowpos ,screenfield.seqno screenfield_seqno ,screenfield.hideflg screenfield_hideflg ,screenfield.maxvalue screenfield_maxvalue ,
  screenfield.editable screenfield_editable ,screenfield.paragraph screenfield_paragraph ,screenfield.selection screenfield_selection ,screenfield.crtfield screenfield_crtfield ,
  screenfield.edoptvalue screenfield_edoptvalue ,screenfield.subindisp screenfield_subindisp ,screenfield.type screenfield_type ,screenfield.sumkey screenfield_sumkey ,
  screenfield.remark screenfield_remark ,screenfield.created_at screenfield_created_at ,screenfield.update_ip screenfield_update_ip ,screenfield.edoptmaxlength screenfield_edoptmaxlength ,
  screenfield.datascale screenfield_datascale ,screenfield.dataprecision screenfield_dataprecision ,screenfield.minvalue screenfield_minvalue ,screenfield.tblkey screenfield_tblkey ,
  screenfield.edoptsize screenfield_edoptsize ,screenfield.colpos screenfield_colpos ,screenfield.rubycode screenfield_rubycode ,screenfield.id id,screenfield.id screenfield_id ,
  screenfield.formatter screenfield_formatter ,
  screenfield.persons_id_upd screenfield_person_id_upd , person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, person_upd.person_name   person_name_upd, 
  person_upd.person_expiredate person_expiredate_upd,
  screenfield.screens_id screenfield_screen_id , screen.screen_expiredate screen_expiredate, screen.screen_strwhere screen_strwhere, screen.screen_rows_per_page screen_rows_per_page, screen.screen_rowlist screen_rowlist, screen.screen_height screen_height, screen.screen_pobject_id_view screen_pobject_id_view, screen.pobject_code_view pobject_code_view, screen.pobject_objecttype_view pobject_objecttype_view, screen.pobject_expiredate_view pobject_expiredate_view, screen.pobject_contens_view pobject_contens_view, screen.pobject_remark_view pobject_remark_view, screen.pobject_id_view pobject_id_view, screen.pobject_rubycode_view pobject_rubycode_view, screen.screen_form_ps screen_form_ps, screen.screen_strgrouporder screen_strgrouporder, screen.screen_strselect screen_strselect, screen.screen_remark screen_remark, screen.screen_cdrflayout screen_cdrflayout, screen.screen_ymlcode screen_ymlcode, screen.screen_id screen_id, screen.screen_grpcodename screen_grpcodename, screen.screen_pobject_id_scr screen_pobject_id_scr, screen.pobject_code_scr pobject_code_scr, screen.pobject_objecttype_scr pobject_objecttype_scr, screen.pobject_expiredate_scr pobject_expiredate_scr, screen.pobject_contens_scr pobject_contens_scr, screen.pobject_remark_scr pobject_remark_scr, screen.pobject_id_scr pobject_id_scr, screen.pobject_rubycode_scr pobject_rubycode_scr, screen.screen_screenlevel_id screen_screenlevel_id, screen.screenlevel_id screenlevel_id, screen.screenlevel_remark screenlevel_remark, screen.screenlevel_expiredate screenlevel_expiredate, screen.screenlevel_code screenlevel_code
 from screenfields screenfield ,r_pobjects  pobject_sfd,upd_persons  person_upd,r_screens  screen
 where  pobject_sfd.id = screenfield.pobjects_id_sfd and  person_upd.id = screenfield.persons_id_upd and  screen.id = screenfield.screens_id ;
 
 
 select screenfield.pobjects_id_sfd screenfield_pobject_id_sfd , pobject_sfd.pobject_code pobject_code_sfd, pobject_sfd.pobject_objecttype pobject_objecttype_sfd,
  pobject_sfd.pobject_expiredate pobject_expiredate_sfd, pobject_sfd.pobject_contens pobject_contens_sfd, pobject_sfd.pobject_remark pobject_remark_sfd, 
  pobject_sfd.pobject_rubycode pobject_rubycode_sfd, pobject_sfd.pobject_id pobject_id_sfd,screenfield.expiredate screenfield_expiredate ,screenfield.updated_at screenfield_updated_at ,
  screenfield.edoptcols screenfield_edoptcols ,screenfield.edoptrow screenfield_edoptrow ,screenfield.width screenfield_width ,screenfield.indisp screenfield_indisp ,
  screenfield.rowpos screenfield_rowpos ,screenfield.seqno screenfield_seqno ,screenfield.hideflg screenfield_hideflg ,screenfield.maxvalue screenfield_maxvalue ,
  screenfield.editable screenfield_editable ,screenfield.paragraph screenfield_paragraph ,screenfield.selection screenfield_selection ,screenfield.crtfield screenfield_crtfield ,
  screenfield.edoptvalue screenfield_edoptvalue ,screenfield.subindisp screenfield_subindisp ,screenfield.type screenfield_type ,screenfield.sumkey screenfield_sumkey ,
  screenfield.remark screenfield_remark ,screenfield.created_at screenfield_created_at ,screenfield.update_ip screenfield_update_ip ,screenfield.edoptmaxlength screenfield_edoptmaxlength ,
  screenfield.datascale screenfield_datascale ,screenfield.dataprecision screenfield_dataprecision ,screenfield.minvalue screenfield_minvalue ,screenfield.tblkey screenfield_tblkey ,
  screenfield.edoptsize screenfield_edoptsize ,screenfield.colpos screenfield_colpos ,screenfield.rubycode screenfield_rubycode ,screenfield.id id,screenfield.id screenfield_id ,
  screenfield.formatter screenfield_formatter ,
  screenfield.persons_id_upd screenfield_person_id_upd , person_upd.person_id_upd person_id_upd, person_upd.person_code_upd person_code_upd, person_upd.person_name_upd   person_name_upd, 
  person_upd.person_expiredate_upd person_expiredate_upd,
  screenfield.screens_id screenfield_screen_id , screen.screen_expiredate screen_expiredate, screen.screen_strwhere screen_strwhere, screen.screen_rows_per_page screen_rows_per_page, screen.screen_rowlist screen_rowlist, screen.screen_height screen_height, screen.screen_pobject_id_view screen_pobject_id_view, screen.pobject_code_view pobject_code_view, screen.pobject_objecttype_view pobject_objecttype_view, screen.pobject_expiredate_view pobject_expiredate_view, screen.pobject_contens_view pobject_contens_view, screen.pobject_remark_view pobject_remark_view, screen.pobject_id_view pobject_id_view, screen.pobject_rubycode_view pobject_rubycode_view, screen.screen_form_ps screen_form_ps, screen.screen_strgrouporder screen_strgrouporder, screen.screen_strselect screen_strselect, screen.screen_remark screen_remark, screen.screen_cdrflayout screen_cdrflayout, screen.screen_ymlcode screen_ymlcode, screen.screen_id screen_id, screen.screen_grpcodename screen_grpcodename, screen.screen_pobject_id_scr screen_pobject_id_scr, screen.pobject_code_scr pobject_code_scr, screen.pobject_objecttype_scr pobject_objecttype_scr, screen.pobject_expiredate_scr pobject_expiredate_scr, screen.pobject_contens_scr pobject_contens_scr, screen.pobject_remark_scr pobject_remark_scr, screen.pobject_id_scr pobject_id_scr, screen.pobject_rubycode_scr pobject_rubycode_scr, screen.screen_screenlevel_id screen_screenlevel_id, screen.screenlevel_id screenlevel_id, screen.screenlevel_remark screenlevel_remark, screen.screenlevel_expiredate screenlevel_expiredate, screen.screenlevel_code screenlevel_code
 from screenfields screenfield ,r_pobjects  pobject_sfd,upd_persons  person_upd,r_screens  screen
 where  pobject_sfd.id = screenfield.pobjects_id_sfd and  person_upd.id = screenfield.persons_id_upd and  screen.id = screenfield.screens_id ;
 
 
   CREATE OR REPLACE FORCE VIEW "RAILS"."R_SCREENS" ("SCREEN_EXPIREDATE", "SCREEN_UPDATED_AT", "SCREEN_STRWHERE", "SCREEN_ROWS_PER_PAGE", "SCREEN_ROWLIST", "SCREEN_HEIGHT", "SCREEN_POBJECT_ID_VIEW", "POBJECT_CODE_VIEW", "POBJECT_OBJECTTYPE_VIEW", "POBJECT_EXPIREDATE_VIEW", "POBJECT_CONTENS_VIEW", "POBJECT_REMARK_VIEW", "POBJECT_ID_VIEW", "POBJECT_RUBYCODE_VIEW", "SCREEN_FORM_PS", "SCREEN_STRGROUPORDER", "SCREEN_STRSELECT", "SCREEN_REMARK", "SCREEN_CREATED_AT", "SCREEN_UPDATE_IP", "SCREEN_CDRFLAYOUT", "SCREEN_YMLCODE", "ID", "SCREEN_ID", "SCREEN_GRPCODENAME", "SCREEN_PERSON_ID_UPD", "PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EXPIREDATE_UPD", "SCREEN_POBJECT_ID_SCR", "POBJECT_CODE_SCR", "POBJECT_OBJECTTYPE_SCR", "POBJECT_EXPIREDATE_SCR", "POBJECT_CONTENS_SCR", "POBJECT_REMARK_SCR", "POBJECT_ID_SCR", "POBJECT_RUBYCODE_SCR", "SCREEN_SCREENLEVEL_ID", "SCREENLEVEL_ID", "SCREENLEVEL_REMARK", "SCREENLEVEL_EXPIREDATE", "SCREENLEVEL_CODE") AS 
  select screen.expiredate screen_expiredate ,screen.updated_at screen_updated_at ,screen.strwhere screen_strwhere ,screen.rows_per_page screen_rows_per_page ,screen.rowlist screen_rowlist ,
  screen.height screen_height ,screen.pobjects_id_view screen_pobject_id_view , pobject_view.pobject_code pobject_code_view, pobject_view.pobject_objecttype pobject_objecttype_view, 
  pobject_view.pobject_expiredate pobject_expiredate_view, pobject_view.pobject_contens pobject_contens_view, pobject_view.pobject_remark pobject_remark_view, pobject_view.pobject_id pobject_id_view, 
  pobject_view.pobject_rubycode pobject_rubycode_view,screen.form_ps screen_form_ps ,screen.strgrouporder screen_strgrouporder ,screen.strselect screen_strselect ,screen.remark screen_remark ,
  screen.created_at screen_created_at ,screen.update_ip screen_update_ip ,screen.cdrflayout screen_cdrflayout ,screen.ymlcode screen_ymlcode ,screen.id id,screen.id screen_id ,screen.grpcodename screen_grpcodename ,
  screen.persons_id_upd screen_person_id_upd , person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, person_upd.person_name person_name_upd, person_upd.person_expiredate person_expiredate_upd,
  screen.pobjects_id_scr screen_pobject_id_scr , pobject_scr.pobject_code pobject_code_scr, pobject_scr.pobject_objecttype pobject_objecttype_scr, pobject_scr.pobject_expiredate pobject_expiredate_scr, pobject_scr.pobject_contens pobject_contens_scr, pobject_scr.pobject_remark pobject_remark_scr, pobject_scr.pobject_id pobject_id_scr, pobject_scr.pobject_rubycode pobject_rubycode_scr,screen.screenlevels_id screen_screenlevel_id , screenlevel.screenlevel_id screenlevel_id, screenlevel.screenlevel_remark screenlevel_remark, screenlevel.screenlevel_expiredate screenlevel_expiredate, screenlevel.screenlevel_code screenlevel_code
 from screens screen ,r_pobjects  pobject_view,upd_persons  person_upd,r_pobjects  pobject_scr,r_screenlevels  screenlevel
 where  pobject_view.pobject_id = screen.pobjects_id_view and  person_upd.id = screen.persons_id_upd and  pobject_scr.pobject_id = screen.pobjects_id_scr and  screenlevel.screenlevel_id = screen.screenlevels_id ;
 
 
  CREATE OR REPLACE FORCE VIEW "RAILS"."R_CHILSCREENS" ("CHILSCREEN_SCREENFIELD_ID", "SCREENFIELD_POBJECT_ID_SFD", "POBJECT_CODE_SFD", "POBJECT_OBJECTTYPE_SFD", "POBJECT_CONTENS_SFD", "POBJECT_REMARK_SFD", "POBJECT_ID_SFD", "POBJECT_RUBYCODE_SFD", "SCREENFIELD_EXPIREDATE", "SCREENFIELD_EDOPTCOLS", "SCREENFIELD_EDOPTROW", "SCREENFIELD_WIDTH", "SCREENFIELD_INDISP", "SCREENFIELD_ROWPOS", "SCREENFIELD_SEQNO", "SCREENFIELD_HIDEFLG", "SCREENFIELD_MAXVALUE", "SCREENFIELD_EDITABLE", "SCREENFIELD_CRTFIELD", "SCREENFIELD_EDOPTVALUE", "SCREENFIELD_TYPE", "SCREENFIELD_SUMKEY", "SCREENFIELD_REMARK", "SCREENFIELD_DATASCALE", "SCREENFIELD_DATAPRECISION", "SCREENFIELD_MINVALUE", "SCREENFIELD_TBLKEY", "SCREENFIELD_EDOPTSIZE", "SCREENFIELD_SELECTION", "SCREENFIELD_SUBINDISP", "SCREENFIELD_EDOPTMAXLENGTH", "SCREENFIELD_COLPOS", "SCREENFIELD_ID", "SCREENFIELD_FORMATTER", "SCREENFIELD_PARAGRAPH", "SCREENFIELD_SCREEN_ID", "SCREEN_STRWHERE", "SCREEN_ROWS_PER_PAGE", "SCREEN_ROWLIST", "SCREEN_HEIGHT", "SCREEN_POBJECT_ID_VIEW", "POBJECT_REMARK_VIEW", "POBJECT_CODE_VIEW", "POBJECT_CONTENS_VIEW", "POBJECT_RUBYCODE_VIEW", "POBJECT_OBJECTTYPE_VIEW", "SCREEN_FORM_PS", "SCREEN_STRGROUPORDER", "SCREEN_STRSELECT", "SCREEN_REMARK", "SCREEN_YMLCODE", "SCREEN_CDRFLAYOUT", "SCREEN_ID", "SCREEN_GRPCODENAME", "SCREEN_POBJECT_ID_SCR", "POBJECT_REMARK_SCR", "POBJECT_CODE_SCR", "POBJECT_CONTENS_SCR", "POBJECT_RUBYCODE_SCR", "POBJECT_OBJECTTYPE_SCR", "SCREEN_SCREENLEVEL_ID", "SCREENLEVEL_REMARK", "SCREENLEVEL_CODE", "SCREENFIELD_RUBYCODE", "CHILSCREEN_SCREENFIELD_ID_CH", "SCREENFIELD_POBJECT_ID_SFD_CH", "POBJECT_CODE_SFD_CH", "POBJECT_OBJECTTYPE_SFD_CH", "POBJECT_CONTENS_SFD_CH", "POBJECT_REMARK_SFD_CH", "POBJECT_ID_SFD_CH", "POBJECT_RUBYCODE_SFD_CH", "SCREENFIELD_EXPIREDATE_CH", "SCREENFIELD_EDOPTCOLS_CH", "SCREENFIELD_EDOPTROW_CH", "SCREENFIELD_WIDTH_CH", "SCREENFIELD_INDISP_CH", "SCREENFIELD_ROWPOS_CH", "SCREENFIELD_SEQNO_CH", "SCREENFIELD_HIDEFLG_CH", "SCREENFIELD_MAXVALUE_CH", "SCREENFIELD_EDITABLE_CH", "SCREENFIELD_CRTFIELD_CH", "SCREENFIELD_EDOPTVALUE_CH", "SCREENFIELD_TYPE_CH", "SCREENFIELD_SUMKEY_CH", "SCREENFIELD_REMARK_CH", "SCREENFIELD_DATASCALE_CH", "SCREENFIELD_DATAPRECISION_CH", "SCREENFIELD_MINVALUE_CH", "SCREENFIELD_TBLKEY_CH", "SCREENFIELD_EDOPTSIZE_CH", "SCREENFIELD_SELECTION_CH", "SCREENFIELD_SUBINDISP_CH", "SCREENFIELD_EDOPTMAXLENGTH_CH", "SCREENFIELD_COLPOS_CH", "SCREENFIELD_ID_CH", "SCREENFIELD_FORMATTER_CH", "SCREENFIELD_PARAGRAPH_CH", "SCREENFIELD_SCREEN_ID_CH", "SCREEN_STRWHERE_CH", "SCREEN_ROWS_PER_PAGE_CH", "SCREEN_ROWLIST_CH", "SCREEN_HEIGHT_CH", "SCREEN_POBJECT_ID_VIEW_CH", "POBJECT_REMARK_VIEW_CH", "POBJECT_CODE_VIEW_CH", "POBJECT_CONTENS_VIEW_CH", "POBJECT_RUBYCODE_VIEW_CH", "POBJECT_OBJECTTYPE_VIEW_CH", "SCREEN_FORM_PS_CH", "SCREEN_STRGROUPORDER_CH", "SCREEN_STRSELECT_CH", "SCREEN_REMARK_CH", "SCREEN_YMLCODE_CH", "SCREEN_CDRFLAYOUT_CH", "SCREEN_ID_CH", "SCREEN_GRPCODENAME_CH", "SCREEN_POBJECT_ID_SCR_CH", "POBJECT_REMARK_SCR_CH", "POBJECT_CODE_SCR_CH", "POBJECT_CONTENS_SCR_CH", "POBJECT_RUBYCODE_SCR_CH", "POBJECT_OBJECTTYPE_SCR_CH", "SCREEN_SCREENLEVEL_ID_CH", "SCREENLEVEL_REMARK_CH", "SCREENLEVEL_CODE_CH", "SCREENFIELD_RUBYCODE_CH", "CHILSCREEN_EXPIREDATE", "CHILSCREEN_UPDATED_AT", "CHILSCREEN_REMARK", "CHILSCREEN_CREATED_AT", "CHILSCREEN_UPDATE_IP", "ID", "CHILSCREEN_ID", "CHILSCREEN_PERSON_ID_UPD", "PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EXPIREDATE_UPD") AS 
  select chilscreen.screenfields_id chilscreen_screenfield_id , screenfield.screenfield_pobject_id_sfd screenfield_pobject_id_sfd, screenfield.pobject_code_sfd pobject_code_sfd, 
  screenfield.pobject_objecttype_sfd pobject_objecttype_sfd, screenfield.pobject_contens_sfd pobject_contens_sfd, screenfield.pobject_remark_sfd pobject_remark_sfd, 
  screenfield.pobject_id_sfd pobject_id_sfd, screenfield.pobject_rubycode_sfd pobject_rubycode_sfd, screenfield.screenfield_expiredate screenfield_expiredate, screenfield.screenfield_edoptcols screenfield_edoptcols,
  screenfield.screenfield_edoptrow screenfield_edoptrow, screenfield.screenfield_width screenfield_width, screenfield.screenfield_indisp screenfield_indisp, screenfield.screenfield_rowpos screenfield_rowpos, 
  screenfield.screenfield_seqno screenfield_seqno, screenfield.screenfield_hideflg screenfield_hideflg, screenfield.screenfield_maxvalue screenfield_maxvalue, screenfield.screenfield_editable screenfield_editable, 
  screenfield.screenfield_crtfield screenfield_crtfield, screenfield.screenfield_edoptvalue screenfield_edoptvalue, screenfield.screenfield_type screenfield_type, screenfield.screenfield_sumkey screenfield_sumkey,
  screenfield.screenfield_remark screenfield_remark, screenfield.screenfield_datascale screenfield_datascale, screenfield.screenfield_dataprecision screenfield_dataprecision, 
  screenfield.screenfield_minvalue screenfield_minvalue, screenfield.screenfield_tblkey screenfield_tblkey, screenfield.screenfield_edoptsize screenfield_edoptsize, 
  screenfield.screenfield_selection screenfield_selection, screenfield.screenfield_subindisp screenfield_subindisp, screenfield.screenfield_edoptmaxlength screenfield_edoptmaxlength, 
  screenfield.screenfield_colpos screenfield_colpos, screenfield.screenfield_id screenfield_id, screenfield.screenfield_formatter screenfield_formatter, screenfield.screenfield_paragraph screenfield_paragraph, 
  screenfield.screenfield_screen_id screenfield_screen_id, screenfield.screen_strwhere screen_strwhere, screenfield.screen_rows_per_page screen_rows_per_page, screenfield.screen_rowlist screen_rowlist, 
  screenfield.screen_height screen_height, screenfield.screen_pobject_id_view screen_pobject_id_view, screenfield.pobject_remark_view pobject_remark_view, screenfield.pobject_code_view pobject_code_view, 
  screenfield.pobject_contens_view pobject_contens_view, screenfield.pobject_rubycode_view pobject_rubycode_view, screenfield.pobject_objecttype_view pobject_objecttype_view, screenfield.screen_form_ps screen_form_ps, 
  screenfield.screen_strgrouporder screen_strgrouporder, screenfield.screen_strselect screen_strselect, screenfield.screen_remark screen_remark, screenfield.screen_ymlcode screen_ymlcode,
  screenfield.screen_cdrflayout screen_cdrflayout, screenfield.screen_id screen_id, screenfield.screen_grpcodename screen_grpcodename, screenfield.screen_pobject_id_scr screen_pobject_id_scr, 
  screenfield.pobject_remark_scr pobject_remark_scr, screenfield.pobject_code_scr pobject_code_scr, screenfield.pobject_contens_scr pobject_contens_scr, screenfield.pobject_rubycode_scr pobject_rubycode_scr, 
  screenfield.pobject_objecttype_scr pobject_objecttype_scr, screenfield.screen_screenlevel_id screen_screenlevel_id, screenfield.screenlevel_remark screenlevel_remark, screenfield.screenlevel_code screenlevel_code,
  screenfield.screenfield_rubycode screenfield_rubycode,chilscreen.screenfields_id_ch chilscreen_screenfield_id_ch , screenfield_ch.screenfield_pobject_id_sfd screenfield_pobject_id_sfd_ch, 
  screenfield_ch.pobject_code_sfd pobject_code_sfd_ch, screenfield_ch.pobject_objecttype_sfd pobject_objecttype_sfd_ch, screenfield_ch.pobject_contens_sfd pobject_contens_sfd_ch,
  screenfield_ch.pobject_remark_sfd pobject_remark_sfd_ch, screenfield_ch.pobject_id_sfd pobject_id_sfd_ch, screenfield_ch.pobject_rubycode_sfd pobject_rubycode_sfd_ch, 
  screenfield_ch.screenfield_expiredate screenfield_expiredate_ch, screenfield_ch.screenfield_edoptcols screenfield_edoptcols_ch, screenfield_ch.screenfield_edoptrow screenfield_edoptrow_ch,
  screenfield_ch.screenfield_width screenfield_width_ch, screenfield_ch.screenfield_indisp screenfield_indisp_ch, screenfield_ch.screenfield_rowpos screenfield_rowpos_ch, 
  screenfield_ch.screenfield_seqno screenfield_seqno_ch, screenfield_ch.screenfield_hideflg screenfield_hideflg_ch, screenfield_ch.screenfield_maxvalue screenfield_maxvalue_ch, 
  screenfield_ch.screenfield_editable screenfield_editable_ch, screenfield_ch.screenfield_crtfield screenfield_crtfield_ch, screenfield_ch.screenfield_edoptvalue screenfield_edoptvalue_ch, screenfield_ch.screenfield_type screenfield_type_ch,
  screenfield_ch.screenfield_sumkey screenfield_sumkey_ch, screenfield_ch.screenfield_remark screenfield_remark_ch, screenfield_ch.screenfield_datascale screenfield_datascale_ch, 
  screenfield_ch.screenfield_dataprecision screenfield_dataprecision_ch, screenfield_ch.screenfield_minvalue screenfield_minvalue_ch, screenfield_ch.screenfield_tblkey screenfield_tblkey_ch, 
  screenfield_ch.screenfield_edoptsize screenfield_edoptsize_ch, screenfield_ch.screenfield_selection screenfield_selection_ch, screenfield_ch.screenfield_subindisp screenfield_subindisp_ch,
  screenfield_ch.screenfield_edoptmaxlength screenfield_edoptmaxlength_ch, screenfield_ch.screenfield_colpos screenfield_colpos_ch, screenfield_ch.screenfield_id screenfield_id_ch,
  screenfield_ch.screenfield_formatter screenfield_formatter_ch, screenfield_ch.screenfield_paragraph screenfield_paragraph_ch, screenfield_ch.screenfield_screen_id screenfield_screen_id_ch, 
  screenfield_ch.screen_strwhere screen_strwhere_ch, screenfield_ch.screen_rows_per_page screen_rows_per_page_ch, screenfield_ch.screen_rowlist screen_rowlist_ch, 
  screenfield_ch.screen_height screen_height_ch, screenfield_ch.screen_pobject_id_view screen_pobject_id_view_ch, screenfield_ch.pobject_remark_view pobject_remark_view_ch, 
  screenfield_ch.pobject_code_view pobject_code_view_ch, screenfield_ch.pobject_contens_view pobject_contens_view_ch, screenfield_ch.pobject_rubycode_view pobject_rubycode_view_ch, 
  screenfield_ch.pobject_objecttype_view pobject_objecttype_view_ch, screenfield_ch.screen_form_ps screen_form_ps_ch, screenfield_ch.screen_strgrouporder screen_strgrouporder_ch,
  screenfield_ch.screen_strselect screen_strselect_ch, screenfield_ch.screen_remark screen_remark_ch, screenfield_ch.screen_ymlcode screen_ymlcode_ch, screenfield_ch.screen_cdrflayout screen_cdrflayout_ch,
  screenfield_ch.screen_id screen_id_ch, screenfield_ch.screen_grpcodename screen_grpcodename_ch, screenfield_ch.screen_pobject_id_scr screen_pobject_id_scr_ch, screenfield_ch.pobject_remark_scr pobject_remark_scr_ch, 
  screenfield_ch.pobject_code_scr pobject_code_scr_ch, screenfield_ch.pobject_contens_scr pobject_contens_scr_ch, screenfield_ch.pobject_rubycode_scr pobject_rubycode_scr_ch, 
  screenfield_ch.pobject_objecttype_scr pobject_objecttype_scr_ch, screenfield_ch.screen_screenlevel_id screen_screenlevel_id_ch, screenfield_ch.screenlevel_remark screenlevel_remark_ch, 
  screenfield_ch.screenlevel_code screenlevel_code_ch, screenfield_ch.screenfield_rubycode screenfield_rubycode_ch,chilscreen.expiredate chilscreen_expiredate ,chilscreen.updated_at chilscreen_updated_at ,
  chilscreen.remark chilscreen_remark ,chilscreen.created_at chilscreen_created_at ,chilscreen.update_ip chilscreen_update_ip ,chilscreen.id id,chilscreen.id chilscreen_id ,chilscreen.persons_id_upd chilscreen_person_id_upd ,
  person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, person_upd.person_name person_name_upd, person_upd.person_expiredate person_expiredate_upd
 from chilscreens chilscreen ,r_screenfields  screenfield,r_screenfields  screenfield_ch,upd_persons  person_upd
 where  screenfield.id = chilscreen.screenfields_id and  screenfield_ch.screenfield_id = chilscreen.screenfields_id_ch and  person_upd.id = chilscreen.persons_id_upd ;



  CREATE OR REPLACE FORCE VIEW "RAILS"."R_FIELDCODES" ("FIELDCODE_EXPIREDATE", "FIELDCODE_UPDATED_AT", "FIELDCODE_FTYPE", "FIELDCODE_REMARK", "FIELDCODE_CREATED_AT", "FIELDCODE_UPDATE_IP", "FIELDCODE_DATASCALE", "FIELDCODE_DATAPRESION", "FIELDCODE_FIELDLENGTH", "ID", "FIELDCODE_ID", "FIELDCODE_FSEQ", "FIELDCODE_PERSON_ID_UPD", "PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EXPIREDATE_UPD", "FIELDCODE_POBJECT_ID_FLD", "POBJECT_CODE_FLD", "POBJECT_OBJECTTYPE_FLD", "POBJECT_EXPIREDATE_FLD", "POBJECT_CONTENS_FLD", "POBJECT_REMARK_FLD", "POBJECT_RUBYCODE_FLD", "POBJECT_ID_FLD") AS 
  select fieldcode.expiredate fieldcode_expiredate ,fieldcode.updated_at fieldcode_updated_at ,fieldcode.ftype fieldcode_ftype ,fieldcode.remark fieldcode_remark ,
  fieldcode.created_at fieldcode_created_at ,fieldcode.update_ip fieldcode_update_ip ,fieldcode.datascale fieldcode_datascale ,fieldcode.datapresion fieldcode_datapresion ,
  fieldcode.fieldlength fieldcode_fieldlength ,fieldcode.id id,fieldcode.id fieldcode_id ,fieldcode.fseq fieldcode_fseq ,fieldcode.persons_id_upd fieldcode_person_id_upd ,
  person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, person_upd.person_name person_name_upd, person_upd.person_expiredate person_expiredate_upd,
  fieldcode.pobjects_id_fld fieldcode_pobject_id_fld , pobject_fld.pobject_code pobject_code_fld, pobject_fld.pobject_objecttype pobject_objecttype_fld, 
  pobject_fld.pobject_expiredate pobject_expiredate_fld, pobject_fld.pobject_contens pobject_contens_fld, pobject_fld.pobject_remark pobject_remark_fld, 
  pobject_fld.pobject_rubycode pobject_rubycode_fld, pobject_fld.pobject_id pobject_id_fld
 from fieldcodes fieldcode ,upd_persons  person_upd,r_pobjects  pobject_fld
 where  person_upd.id = fieldcode.persons_id_upd and  pobject_fld.pobject_id = fieldcode.pobjects_id_fld;
 
 
 create or replace view r_units as select unit.code unit_code ,unit.expiredate unit_expiredate ,unit.updated_at unit_updated_at ,unit.name unit_name ,unit.remark unit_remark ,
 unit.created_at unit_created_at ,unit.update_ip unit_update_ip ,unit.id id,unit.id unit_id ,unit.persons_id_upd unit_person_id_upd , person_upd.person_id_upd person_id_upd_upd, 
 person_upd.person_code_upd person_code_upd_upd, person_upd.person_name_upd person_name_upd_upd,
 person_upd.person_expiredate_upd person_expiredate_upd_upd from units unit ,upd_persons person_upd where person_upd.id = unit.persons_id_upd 
 ;
 
   CREATE OR REPLACE FORCE VIEW "RAILS"."R_BLKTBSFIELDCODES" ("BLKTBSFIELDCODE_CONNECTSEQ", "BLKTBSFIELDCODE_EXPIREDATE", "BLKTBSFIELDCODE_UPDATED_AT", "BLKTBSFIELDCODE_REMARK", "BLKTBSFIELDCODE_CREATED_AT", "BLKTBSFIELDCODE_UPDATE_IP", "BLKTBSFIELDCODE_FIELDCODE_ID", "FIELDCODE_EXPIREDATE", "FIELDCODE_FTYPE", "FIELDCODE_REMARK", "FIELDCODE_DATASCALE", "FIELDCODE_DATAPRESION", "FIELDCODE_FIELDLENGTH", "FIELDCODE_ID", "FIELDCODE_FSEQ", "FIELDCODE_POBJECT_ID_FLD", "POBJECT_CODE_FLD", "POBJECT_OBJECTTYPE_FLD", "POBJECT_EXPIREDATE_FLD", "POBJECT_CONTENS_FLD", "POBJECT_REMARK_FLD", "POBJECT_RUBYCODE_FLD", "POBJECT_ID_FLD", "BLKTBSFIELDCODE_BLKTB_ID", "BLKTB_EXPIREDATE", "BLKTB_REMARK", "BLKTB_ID", "BLKTB_POBJECT_ID_TBL", "POBJECT_CODE_TBL", "POBJECT_OBJECTTYPE_TBL", "POBJECT_CONTENS_TBL", "POBJECT_REMARK_TBL", "POBJECT_ID_TBL", "POBJECT_RUBYCODE_TBL", "ID", "BLKTBSFIELDCODE_ID", "BLKTBSFIELDCODE_PERSON_ID_UPD", "PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EXPIREDATE_UPD", "BLKTBSFIELDCODE_CONTENTS") AS 
  select blktbsfieldcode.connectseq blktbsfieldcode_connectseq ,blktbsfieldcode.expiredate blktbsfieldcode_expiredate ,blktbsfieldcode.updated_at blktbsfieldcode_updated_at ,
  blktbsfieldcode.remark blktbsfieldcode_remark ,blktbsfieldcode.created_at blktbsfieldcode_created_at ,blktbsfieldcode.update_ip blktbsfieldcode_update_ip ,blktbsfieldcode.fieldcodes_id blktbsfieldcode_fieldcode_id ,
  fieldcode.fieldcode_expiredate fieldcode_expiredate, fieldcode.fieldcode_ftype fieldcode_ftype, fieldcode.fieldcode_remark fieldcode_remark, fieldcode.fieldcode_datascale fieldcode_datascale, 
  fieldcode.fieldcode_datapresion fieldcode_datapresion, fieldcode.fieldcode_fieldlength fieldcode_fieldlength, fieldcode.fieldcode_id fieldcode_id, fieldcode.fieldcode_fseq fieldcode_fseq, 
  fieldcode.fieldcode_pobject_id_fld fieldcode_pobject_id_fld, fieldcode.pobject_code_fld pobject_code_fld, fieldcode.pobject_objecttype_fld pobject_objecttype_fld, fieldcode.pobject_expiredate_fld pobject_expiredate_fld,
  fieldcode.pobject_contens_fld pobject_contens_fld, fieldcode.pobject_remark_fld pobject_remark_fld, fieldcode.pobject_rubycode_fld pobject_rubycode_fld,
  fieldcode.pobject_id_fld pobject_id_fld,blktbsfieldcode.blktbs_id blktbsfieldcode_blktb_id , blktb.blktb_expiredate blktb_expiredate, blktb.blktb_remark blktb_remark, blktb.blktb_id blktb_id,
  blktb.blktb_pobject_id_tbl blktb_pobject_id_tbl, blktb.pobject_code_tbl pobject_code_tbl, blktb.pobject_objecttype_tbl pobject_objecttype_tbl, blktb.pobject_contens_tbl pobject_contens_tbl,
  blktb.pobject_remark_tbl pobject_remark_tbl, blktb.pobject_id_tbl pobject_id_tbl, blktb.pobject_rubycode_tbl pobject_rubycode_tbl,blktbsfieldcode.id id,blktbsfieldcode.id blktbsfieldcode_id ,
  blktbsfieldcode.persons_id_upd blktbsfieldcode_person_id_upd ,
  person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, person_upd.person_name person_name_upd, person_upd.person_expiredate person_expiredate_upd,blktbsfieldcode.contents blktbsfieldcode_contents 
 from blktbsfieldcodes blktbsfieldcode ,r_fieldcodes  fieldcode,r_blktbs  blktb,upd_persons  person_upd
 where  fieldcode.id = blktbsfieldcode.fieldcodes_id and  blktb.id = blktbsfieldcode.blktbs_id and  person_upd.id = blktbsfieldcode.persons_id_upd ;
 
 
  CREATE OR REPLACE FORCE VIEW "RAILS"."R_DEALERS" ("DEALER_PERSONNAMEOFOUTSIDE", "DEALER_CURRENCY_ID", "CURRENCY_ID", "CURRENCY_CODE", "CURRENCY_NAME", "CURRENCY_PRICEDECIMAL", "CURRENCY_AMTDECIMAL", "CURRENCY_REMARK", "CURRENCY_EXPIREDATE", "DEALER_MAXAMT", "DEALER_MINAMT", "DEALER_CHRGPERSON_ID", "CHRGPERSON_EXPIREDATE", "CHRGPERSON_UPDATED_AT", "CHRGPERSON_REMARK", "CHRGPERSON_CREATED_AT", "CHRGPERSON_UPDATE_IP", "CHRGPERSON_ID", "CHRGPERSON_PERSON_ID_UPD", "PERSON_ID_UPD_UPD", "PERSON_CODE_UPD_UPD", "PERSON_NAME_UPD_UPD", "PERSON_EXPIREDATE_UPD_UPD", "CHRGPERSON_PERSON_ID_CHRG", "PERSON_ID_CHRG", "PERSON_CODE_CHRG", "PERSON_NAME_CHRG", "PERSON_EMAIL_CHRG", "LOCA_CODE_SECT_CHRG", "LOCA_NAME_SECT_CHRG", "USERGROUP_CODE_CHRG", "PERSON_EXPIREDATE_CHRG", "DEALER_LOCA_ID_DEALER", "LOCA_ID_DEALER", "LOCA_CODE_DEALER", "LOCA_NAME_DEALER", "LOCA_ABBR_DEALER", "LOCA_ZIP_DEALER", "LOCA_COUNTRY_DEALER", "LOCA_PRFCT_DEALER", "LOCA_ADDR1_DEALER", "LOCA_ADDR2_DEALER", "LOCA_TEL_DEALER", "LOCA_FAX_DEALER", "LOCA_MAIL_DEALER", "LOCA_REMARK_DEALER", "LOCA_EXPIREDATE_DEALER") AS 
  select dealer.personnameofoutside dealer_personnameofoutside ,dealer.currencys_id dealer_currency_id , currency.currency_id currency_id, currency.currency_code currency_code, currency.currency_name currency_name,
  currency.currency_pricedecimal currency_pricedecimal, currency.currency_amtdecimal currency_amtdecimal, currency.currency_remark currency_remark, currency.currency_expiredate currency_expiredate,dealer.maxamt dealer_maxamt ,
  dealer.minamt dealer_minamt ,dealer.chrgpersons_id dealer_chrgperson_id , chrgperson.chrgperson_expiredate chrgperson_expiredate, chrgperson.chrgperson_updated_at chrgperson_updated_at, chrgperson.chrgperson_remark chrgperson_remark, 
  chrgperson.chrgperson_created_at chrgperson_created_at, chrgperson.chrgperson_update_ip chrgperson_update_ip, chrgperson.chrgperson_id chrgperson_id, chrgperson.chrgperson_person_id_upd chrgperson_person_id_upd, 
  chrgperson.person_id_upd_upd person_id_upd_upd, chrgperson.person_code_upd_upd person_code_upd_upd, chrgperson.person_name_upd_upd person_name_upd_upd, chrgperson.person_expiredate_upd_upd person_expiredate_upd_upd, 
  chrgperson.chrgperson_person_id_chrg chrgperson_person_id_chrg, chrgperson.person_id_chrg person_id_chrg, chrgperson.person_code_chrg person_code_chrg, chrgperson.person_name_chrg person_name_chrg, 
  chrgperson.person_email_chrg person_email_chrg, chrgperson.loca_code_sect_chrg loca_code_sect_chrg, chrgperson.loca_name_sect_chrg loca_name_sect_chrg, chrgperson.usergroup_code_chrg usergroup_code_chrg,
  chrgperson.person_expiredate_chrg person_expiredate_chrg,dealer.locas_id_dealer dealer_loca_id_dealer , loca_dealer.loca_id loca_id_dealer, loca_dealer.loca_code loca_code_dealer, loca_dealer.loca_name loca_name_dealer, 
  loca_dealer.loca_abbr loca_abbr_dealer, loca_dealer.loca_zip loca_zip_dealer, loca_dealer.loca_country loca_country_dealer, loca_dealer.loca_prfct loca_prfct_dealer, loca_dealer.loca_addr1 loca_addr1_dealer, 
  loca_dealer.loca_addr2 loca_addr2_dealer, loca_dealer.loca_tel loca_tel_dealer, loca_dealer.loca_fax loca_fax_dealer, loca_dealer.loca_mail loca_mail_dealer, loca_dealer.loca_remark loca_remark_dealer,
  loca_dealer.loca_expiredate loca_expiredate_dealer
 from dealers dealer ,r_currencys  currency,r_chrgpersons  chrgperson,r_locas  loca_dealer
 where  currency.id = dealer.currencys_id and  chrgperson.id = dealer.chrgpersons_id and  loca_dealer.id = dealer.locas_id_dealer ;
 
   CREATE OR REPLACE FORCE VIEW "RAILS"."R_CHRGPERSONS" ("CHRGPERSON_EXPIREDATE", "CHRGPERSON_UPDATED_AT", "CHRGPERSON_REMARK", "CHRGPERSON_CREATED_AT", "CHRGPERSON_UPDATE_IP", "ID", "CHRGPERSON_ID", "CHRGPERSON_PERSON_ID_UPD", "CHRGPERSON_PERSON_ID_CHRG", "PERSON_ID_CHRG", "PERSON_CODE_CHRG", "PERSON_NAME_CHRG", "PERSON_EMAIL_CHRG", "LOCA_CODE_SECT_CHRG", "LOCA_NAME_SECT_CHRG", "USERGROUP_CODE_CHRG", "PERSON_EXPIREDATE_CHRG") AS 
  select chrgperson.expiredate chrgperson_expiredate ,chrgperson.updated_at chrgperson_updated_at ,chrgperson.remark chrgperson_remark ,chrgperson.created_at chrgperson_created_at ,
  chrgperson.update_ip chrgperson_update_ip ,chrgperson.id id,chrgperson.id chrgperson_id ,chrgperson.persons_id_upd chrgperson_person_id_upd ,chrgperson.persons_id_chrg chrgperson_person_id_chrg , 
  person_chrg.person_id person_id_chrg, person_chrg.person_code person_code_chrg, person_chrg.person_name person_name_chrg, person_chrg.person_email person_email_chrg, 
  person_chrg.loca_code_sect loca_code_sect_chrg, person_chrg.loca_name_sect loca_name_sect_chrg, person_chrg.usergroup_code usergroup_code_chrg, person_chrg.person_expiredate person_expiredate_chrg
 from chrgpersons chrgperson ,upd_persons  person_upd,r_persons  person_chrg
 where  person_upd.id = chrgperson.persons_id_upd and  person_chrg.id = chrgperson.persons_id_chrg ;

  CREATE OR REPLACE FORCE VIEW "RAILS"."R_BLKUKYS" ("BLKUKY_EXPIREDATE", "BLKUKY_UPDATED_AT", "BLKUKY_SEQNO", "BLKUKY_REMARK", "BLKUKY_CREATED_AT", "BLKUKY_UPDATE_IP", "ID", "BLKUKY_ID", "BLKUKY_GRP", "BLKUKY_BLKTBSFIELDCODE_ID", 
  "BLKTBSFIELDCODE_CONNECTSEQ", "BLKTBSFIELDCODE_EXPIREDATE", "BLKTBSFIELDCODE_REMARK", "BLKTBSFIELDCODE_FIELDCODE_ID", "FIELDCODE_EXPIREDATE", "FIELDCODE_FTYPE", "FIELDCODE_REMARK", "FIELDCODE_DATASCALE", "FIELDCODE_DATAPRESION",
  "FIELDCODE_FIELDLENGTH", "FIELDCODE_ID", "FIELDCODE_FSEQ", "FIELDCODE_POBJECT_ID_FLD", "POBJECT_CODE_FLD", "POBJECT_OBJECTTYPE_FLD", "POBJECT_EXPIREDATE_FLD", "POBJECT_CONTENS_FLD", "POBJECT_REMARK_FLD", "POBJECT_RUBYCODE_FLD", 
  "POBJECT_ID_FLD", "BLKTBSFIELDCODE_BLKTB_ID", "BLKTB_EXPIREDATE", "BLKTB_REMARK", "BLKTB_ID", "BLKTB_POBJECT_ID_TBL", "POBJECT_CODE_TBL", "POBJECT_OBJECTTYPE_TBL", "POBJECT_CONTENS_TBL", "POBJECT_REMARK_TBL", "POBJECT_ID_TBL",
  "POBJECT_RUBYCODE_TBL", "BLKTBSFIELDCODE_ID", "BLKTBSFIELDCODE_CONTENTS", "BLKUKY_PERSON_ID_UPD", "PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EXPIREDATE_UPD") AS 
  select blkuky.expiredate blkuky_expiredate ,blkuky.updated_at blkuky_updated_at ,blkuky.seqno blkuky_seqno ,blkuky.remark blkuky_remark ,blkuky.created_at blkuky_created_at ,blkuky.update_ip blkuky_update_ip 
  ,blkuky.id id,blkuky.id blkuky_id ,blkuky.grp blkuky_grp ,blkuky.blktbsfieldcodes_id blkuky_blktbsfieldcode_id , blktbsfieldcode.blktbsfieldcode_connectseq blktbsfieldcode_connectseq, 
  blktbsfieldcode.blktbsfieldcode_expiredate blktbsfieldcode_expiredate, blktbsfieldcode.blktbsfieldcode_remark blktbsfieldcode_remark, blktbsfieldcode.blktbsfieldcode_fieldcode_id blktbsfieldcode_fieldcode_id, 
  blktbsfieldcode.fieldcode_expiredate fieldcode_expiredate, blktbsfieldcode.fieldcode_ftype fieldcode_ftype, blktbsfieldcode.fieldcode_remark fieldcode_remark, blktbsfieldcode.fieldcode_datascale fieldcode_datascale,
  blktbsfieldcode.fieldcode_datapresion fieldcode_datapresion, blktbsfieldcode.fieldcode_fieldlength fieldcode_fieldlength, blktbsfieldcode.fieldcode_id fieldcode_id, blktbsfieldcode.fieldcode_fseq fieldcode_fseq, 
  blktbsfieldcode.fieldcode_pobject_id_fld fieldcode_pobject_id_fld, blktbsfieldcode.pobject_code_fld pobject_code_fld, blktbsfieldcode.pobject_objecttype_fld pobject_objecttype_fld,
  blktbsfieldcode.pobject_expiredate_fld pobject_expiredate_fld, blktbsfieldcode.pobject_contens_fld pobject_contens_fld, blktbsfieldcode.pobject_remark_fld pobject_remark_fld, 
  blktbsfieldcode.pobject_rubycode_fld pobject_rubycode_fld, blktbsfieldcode.pobject_id_fld pobject_id_fld, blktbsfieldcode.blktbsfieldcode_blktb_id blktbsfieldcode_blktb_id, 
  blktbsfieldcode.blktb_expiredate blktb_expiredate, blktbsfieldcode.blktb_remark blktb_remark, blktbsfieldcode.blktb_id blktb_id, blktbsfieldcode.blktb_pobject_id_tbl blktb_pobject_id_tbl, 
  blktbsfieldcode.pobject_code_tbl pobject_code_tbl, blktbsfieldcode.pobject_objecttype_tbl pobject_objecttype_tbl, blktbsfieldcode.pobject_contens_tbl pobject_contens_tbl, 
  blktbsfieldcode.pobject_remark_tbl pobject_remark_tbl, blktbsfieldcode.pobject_id_tbl pobject_id_tbl, blktbsfieldcode.pobject_rubycode_tbl pobject_rubycode_tbl, blktbsfieldcode.blktbsfieldcode_id blktbsfieldcode_id,
  blktbsfieldcode.blktbsfieldcode_contents blktbsfieldcode_contents,blkuky.persons_id_upd blkuky_person_id_upd ,
  person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, person_upd.person_name person_name_upd, person_upd.person_expiredate person_expiredate_upd
 from blkukys blkuky ,r_blktbsfieldcodes  blktbsfieldcode,upd_persons  person_upd
 where  blktbsfieldcode.id = blkuky.blktbsfieldcodes_id and  person_upd.id = blkuky.persons_id_upd ;
 
update nditms set  minqty = null;

truncate table custords;
 select person.id,person.id person_id ,person.code person_code,person.name person_name,
  person.email person_email, sect.loca_id_sects loca_id_sect,sect.loca_code_sects loca_code_sect,
  sect.loca_name_sects loca_name_sect,usergroup.code usergroup_code,person.EXPIREDATE person_EXPIREDATE
 from persons person ,usergroups usergroup,screenlevels screenlevel, r_sects sect
 where person.UserGroups_id= usergroup.id and person.screenlevels_id = screenlevel.id
 and person.sects_id = sect.id
 ;
 select * from r_screenfields where  pobject_code_sfd = 'opeitm_loca_id'
 ;
 TRUNCATE table custords
 ;
 TRUNCATE table shpschs
 ;
  TRUNCATE table arvschs
 ;
 
  TRUNCATE table stkhists
 ;
 drop table sio_r_persons
 ;
 drop table manrsrs
 ;
 drop table nameunits
 ;
  CREATE OR REPLACE FORCE VIEW "RAILS"."R_FIELDCODES" ("FIELDCODE_EXPIREDATE", "FIELDCODE_UPDATED_AT", "FIELDCODE_FTYPE", "FIELDCODE_REMARK", 
  "FIELDCODE_CREATED_AT", "FIELDCODE_UPDATE_IP", "FIELDCODE_DATASCALE", "FIELDCODE_DATAPRECISION", "FIELDCODE_FIELDLENGTH", "ID", "FIELDCODE_ID", 
  "FIELDCODE_FSEQ", "FIELDCODE_PERSON_ID_UPD", "PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EXPIREDATE_UPD", "FIELDCODE_POBJECT_ID_FLD", 
  "POBJECT_CODE_FLD", "POBJECT_OBJECTTYPE_FLD", "POBJECT_EXPIREDATE_FLD", "POBJECT_CONTENS_FLD", "POBJECT_REMARK_FLD", "POBJECT_RUBYCODE_FLD", 
  "POBJECT_ID_FLD") AS 
  select fieldcode.expiredate fieldcode_expiredate ,fieldcode.updated_at fieldcode_updated_at ,fieldcode.ftype fieldcode_ftype ,
  fieldcode.remark fieldcode_remark ,fieldcode.created_at fieldcode_created_at ,fieldcode.update_ip fieldcode_update_ip ,
  fieldcode.datascale fieldcode_datascale ,fieldcode.dataprecision fieldcode_dataprecision ,fieldcode.fieldlength fieldcode_fieldlength ,
  fieldcode.id id,fieldcode.id fieldcode_id ,fieldcode.fseq fieldcode_fseq ,fieldcode.persons_id_upd fieldcode_person_id_upd , 
  person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, person_upd.person_name person_name_upd,
  person_upd.person_expiredate person_expiredate_upd,fieldcode.pobjects_id_fld fieldcode_pobject_id_fld ,
  pobject_fld.pobject_code pobject_code_fld, pobject_fld.pobject_objecttype pobject_objecttype_fld, pobject_fld.pobject_expiredate pobject_expiredate_fld,
  pobject_fld.pobject_contens pobject_contens_fld, pobject_fld.pobject_remark pobject_remark_fld, pobject_fld.pobject_rubycode pobject_rubycode_fld,
  pobject_fld.pobject_id pobject_id_fld
 from fieldcodes fieldcode ,upd_persons  person_upd,r_pobjects  pobject_fld
 where  person_upd.id = fieldcode.persons_id_upd and  pobject_fld.id = fieldcode.pobjects_id_fld ; 
 
   select fieldcode.expiredate fieldcode_expiredate ,fieldcode.updated_at fieldcode_updated_at ,fieldcode.ftype fieldcode_ftype ,
  fieldcode.remark fieldcode_remark ,fieldcode.created_at fieldcode_created_at ,fieldcode.update_ip fieldcode_update_ip ,
  fieldcode.datascale fieldcode_datascale ,fieldcode.dataprecision fieldcode_dataprecision ,fieldcode.fieldlength fieldcode_fieldlength ,
  fieldcode.id id,fieldcode.id fieldcode_id ,fieldcode.fseq fieldcode_fseq ,fieldcode.persons_id_upd fieldcode_person_id_upd , 
  person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, person_upd.person_name person_name_upd,
  person_upd.person_expiredate person_expiredate_upd,fieldcode.pobjects_id_fld fieldcode_pobject_id_fld ,
  pobject_fld.pobject_code pobject_code_fld, pobject_fld.pobject_objecttype pobject_objecttype_fld, pobject_fld.pobject_expiredate pobject_expiredate_fld,
  pobject_fld.pobject_contens pobject_contens_fld, pobject_fld.pobject_remark pobject_remark_fld, pobject_fld.pobject_rubycode pobject_rubycode_fld,
  pobject_fld.pobject_id pobject_id_fld
 from fieldcodes fieldcode ,upd_persons  person_upd,r_pobjects  pobject_fld
 where  person_upd.id = fieldcode.persons_id_upd and  pobject_fld.id = fieldcode.pobjects_id_fld ; 
 
  create table makings (created_at timestamp(6),duration number(38), expiredate date,id number(38), 
  opeitms_id number(38), persons_id_upd number(38), priority number(38), remark varchar2(100) ,tblid number(38), tblname varchar2(30) ,
  units_id_mk number(38), update_ip varchar2(40) ,updated_at timestamp(6))
  ;
  drop table makings
  ;
  create or replace view r_currencys as select currency.code currency_code ,currency.code currency_code ,
  currency.expiredate currency_expiredate ,currency.expiredate currency_expiredate ,currency.updated_at currency_updated_at ,
  currency.updated_at currency_updated_at ,currency.pricedecimal currency_pricedecimal ,currency.pricedecimal currency_pricedecimal ,
  currency.amtdecimal currency_amtdecimal ,currency.amtdecimal currency_amtdecimal ,currency.name currency_name ,currency.name currency_name ,
  currency.remark currency_remark ,currency.remark currency_remark ,currency.created_at currency_created_at ,currency.created_at currency_created_at 
  ,currency.update_ip currency_update_ip ,currency.update_ip currency_update_ip ,currency.id id,currency.id currency_id ,currency.id currency_id ,
  currency.persons_id_upd currency_person_id_upd , person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, 
  person_upd.person_name person_name_upd, person_upd.person_expiredate person_expiredate_upd from currencys currency ,
  upd_persons person_upd where person_upd.id = currency.persons_id_upd 
  ;
   select chrgperson.id id,chrgperson.id chrgperson_id ,chrgperson.remark chrgperson_remark ,chrgperson.expiredate chrgperson_expiredate ,
  chrgperson.update_ip chrgperson_update_ip ,chrgperson.created_at chrgperson_created_at ,chrgperson.updated_at chrgperson_updated_at ,
  chrgperson.persons_id_upd chrgperson_person_id_upd , person_upd.person_id person_id_upd, person_upd.person_code person_code_upd,
  person_upd.person_name person_name_upd, person_upd.person_expiredate person_expiredate_upd,chrgperson.persons_id_chrg chrgperson_person_id_chrg , 
  person_chrg.person_code person_code_chrg, person_chrg.person_expiredate person_expiredate_chrg, person_chrg.person_name person_name_chrg,
  person_chrg.person_remark person_remark_chrg, person_chrg.person_usergroup_id person_usergroup_id_chrg, 
  person_chrg.usergroup_name usergroup_name_chrg, person_chrg.usergroup_code usergroup_code_chrg, person_chrg.usergroup_expiredate usergroup_expiredate_chrg,
  person_chrg.usergroup_remark usergroup_remark_chrg, person_chrg.usergroup_id usergroup_id_chrg, person_chrg.person_email person_email_chrg,
  person_chrg.person_id person_id_chrg, person_chrg.person_sect_id person_sect_id_chrg, person_chrg.sect_id sect_id_chrg,
  person_chrg.loca_id_sects loca_id_sects_chrg, person_chrg.loca_code_sects loca_code_sects_chrg, person_chrg.loca_name_sects loca_name_sects_chrg,
  person_chrg.loca_abbr_sects loca_abbr_sects_chrg, person_chrg.loca_zip_sects loca_zip_sects_chrg, person_chrg.loca_country_sects loca_country_sects_chrg,
  person_chrg.loca_prfct_sects loca_prfct_sects_chrg, person_chrg.loca_addr1_sects loca_addr1_sects_chrg, person_chrg.loca_addr2_sects loca_addr2_sects_chrg, 
  person_chrg.loca_tel_sects loca_tel_sects_chrg, person_chrg.loca_fax_sects loca_fax_sects_chrg, person_chrg.loca_mail_sects loca_mail_sects_chrg,
  person_chrg.loca_remark_sects loca_remark_sects_chrg, person_chrg.sect_remark sect_remark_chrg, person_chrg.sect_expiredate sect_expiredate_chrg
 from chrgpersons chrgperson ,upd_persons  person_upd,r_persons person_chrg
 where  person_upd.id = chrgperson.persons_id_upd  ;

Create or ALter View sql create or replace view r_makings as select making.priority making_priority ,making.opeitms_id making_opeitm_id , 
opeitm.opeitm_minqty opeitm_minqty, opeitm.opeitm_priority opeitm_priority, opeitm.opeitm_processseq opeitm_processseq, opeitm.opeitm_duration opeitm_duration,
opeitm.opeitm_unit_id_lttime opeitm_unit_id_lttime, opeitm.unit_name_lttime unit_name_lttime, opeitm.unit_code_lttime unit_code_lttime, opeitm.unit_remark_lttime unit_remark_lttime, 
opeitm.unit_id_lttime unit_id_lttime, opeitm.opeitm_packqty opeitm_packqty, opeitm.opeitm_itm_id opeitm_itm_id, opeitm.itm_unit_id itm_unit_id, opeitm.unit_name unit_name, 
opeitm.unit_code unit_code, opeitm.unit_remark unit_remark, opeitm.unit_id unit_id, opeitm.itm_id itm_id, opeitm.itm_remark itm_remark, opeitm.itm_code itm_code, 
opeitm.itm_name itm_name, opeitm.itm_itmtype itm_itmtype, opeitm.itm_consumtype itm_consumtype, opeitm.itm_std itm_std, opeitm.itm_model itm_model, opeitm.itm_material itm_material,
opeitm.itm_design itm_design, opeitm.itm_weight itm_weight, opeitm.itm_length itm_length, opeitm.itm_wide itm_wide, opeitm.itm_deth itm_deth, opeitm.itm_packqty itm_packqty,
opeitm.itm_minqty itm_minqty, opeitm.opeitm_remark opeitm_remark, opeitm.opeitm_propucr opeitm_propucr, opeitm.opeitm_id opeitm_id, opeitm.opeitm_loca_id opeitm_loca_id,
opeitm.loca_id loca_id, opeitm.loca_code loca_code, opeitm.loca_name loca_name, opeitm.loca_abbr loca_abbr, opeitm.loca_zip loca_zip, opeitm.loca_country loca_country, 
opeitm.loca_prfct loca_prfct, opeitm.loca_addr1 loca_addr1, opeitm.loca_addr2 loca_addr2, opeitm.loca_tel loca_tel, opeitm.loca_fax loca_fax, opeitm.loca_mail loca_mail,

opeitm.loca_remark loca_remark,making.expiredate making_expiredate ,making.updated_at making_updated_at ,making.duration making_duration ,making.remark making_remark
,making.created_at making_created_at ,making.update_ip making_update_ip ,making.tblid making_tblid ,making.tblname making_tblname ,making.id id,making.id making_id ,
making.persons_id_upd making_person_id_upd , person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, person_upd.person_name person_name_upd,
person_upd.person_expiredate person_expiredate_upd,making.units_id_mk making_unit_id_mk , unit_mk.unit_name unit_name_mk, unit_mk.unit_code unit_code_mk, unit_mk.unit_remark unit_remark_mk, 
unit_mk.unit_id unit_id_mk,fcoperator.fcoperator_code vfmaking_vfcode , union making.priority making_priority ,making.opeitms_id making_opeitm_id , opeitm.opeitm_minqty opeitm_minqty,
opeitm.opeitm_priority opeitm_priority, opeitm.opeitm_processseq opeitm_processseq, opeitm.opeitm_duration opeitm_duration, opeitm.opeitm_unit_id_lttime opeitm_unit_id_lttime, 
opeitm.unit_name_lttime unit_name_lttime, opeitm.unit_code_lttime unit_code_lttime, opeitm.unit_remark_lttime unit_remark_lttime, opeitm.unit_id_lttime unit_id_lttime, 
opeitm.opeitm_packqty opeitm_packqty, opeitm.opeitm_itm_id opeitm_itm_id, opeitm.itm_unit_id itm_unit_id, opeitm.unit_name unit_name, opeitm.unit_code unit_code, 
opeitm.unit_remark unit_remark, opeitm.unit_id unit_id, opeitm.itm_id itm_id, opeitm.itm_remark itm_remark, opeitm.itm_code itm_code, opeitm.itm_name itm_name, 
opeitm.itm_itmtype itm_itmtype, opeitm.itm_consumtype itm_consumtype, opeitm.itm_std itm_std, opeitm.itm_model itm_model, opeitm.itm_material itm_material,
opeitm.itm_design itm_design, opeitm.itm_weight itm_weight, opeitm.itm_length itm_length, opeitm.itm_wide itm_wide, opeitm.itm_deth itm_deth, opeitm.itm_packqty itm_packqty, 
opeitm.itm_minqty itm_minqty, opeitm.opeitm_remark opeitm_remark, opeitm.opeitm_propucr opeitm_propucr, opeitm.opeitm_id opeitm_id, opeitm.opeitm_loca_id opeitm_loca_id, opeitm.loca_id loca_id, 
opeitm.loca_code loca_code, opeitm.loca_name loca_name, opeitm.loca_abbr loca_abbr, opeitm.loca_zip loca_zip, opeitm.loca_country loca_country, opeitm.loca_prfct loca_prfct, 
opeitm.loca_addr1 loca_addr1, opeitm.loca_addr2 loca_addr2, opeitm.loca_tel loca_tel, opeitm.loca_fax loca_fax, opeitm.loca_mail loca_mail,
opeitm.loca_remark loca_remark,making.expiredate making_expiredate ,making.updated_at making_updated_at ,making.duration making_duration ,making.remark making_remark ,
making.created_at making_created_at ,making.update_ip making_update_ip ,making.tblid making_tblid ,making.tblname making_tblname ,making.id id,making.id making_id ,
making.persons_id_upd making_person_id_upd , person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, person_upd.person_name person_name_upd, 
person_upd.person_expiredate person_expiredate_upd,making.units_id_mk making_unit_id_mk , unit_mk.unit_name unit_name_mk, unit_mk.unit_code unit_code_mk, 
unit_mk.unit_remark unit_remark_mk, unit_mk.unit_id unit_id_mk,facilitie.facilitie_code vfmaking_vfcode from makings making ,fcoperators fcoperator ,r_opeitms opeitm,
upd_persons person_upd,r_units unit_mk, from makings making ,facilities facilitie ,r_opeitms opeitm,upd_persons person_upd,r_units unit_mk
where making.tblid = fcoperator.id and opeitm.id = making.opeitms_id and person_upd.id = making.persons_id_upd and unit_mk.id = making.units_id_mk and 
where making.tblid = facilitie.id and opeitm.id = making.opeitms_id and person_upd.id = making.persons_id_upd and unit_mk.id = making.units_id_mk 
;
drop table making
;

  CREATE OR REPLACE FORCE VIEW "RAILS"."R_BLKTBSFIELDCODES" ("BLKTBSFIELDCODE_CONNECTSEQ", "BLKTBSFIELDCODE_EXPIREDATE", "BLKTBSFIELDCODE_UPDATED_AT", "BLKTBSFIELDCODE_REMARK", "BLKTBSFIELDCODE_CREATED_AT", "BLKTBSFIELDCODE_UPDATE_IP", "BLKTBSFIELDCODE_FIELDCODE_ID", "FIELDCODE_EXPIREDATE", "FIELDCODE_FTYPE", "FIELDCODE_REMARK", "FIELDCODE_DATASCALE", "FIELDCODE_DATAPRECISION", "FIELDCODE_FIELDLENGTH", "FIELDCODE_ID", "FIELDCODE_FSEQ", "FIELDCODE_POBJECT_ID_FLD", "POBJECT_CODE_FLD", "POBJECT_OBJECTTYPE_FLD", "POBJECT_EXPIREDATE_FLD", "POBJECT_CONTENS_FLD", "POBJECT_REMARK_FLD", "POBJECT_RUBYCODE_FLD", "POBJECT_ID_FLD", "BLKTBSFIELDCODE_BLKTB_ID", "BLKTB_ID", "BLKTB_POBJECT_ID_TBL", "POBJECT_CODE_TBL", "POBJECT_OBJECTTYPE_TBL", "POBJECT_EXPIREDATE_TBL", "POBJECT_CONTENS_TBL", "POBJECT_REMARK_TBL", "POBJECT_RUBYCODE_TBL", "POBJECT_ID_TBL", "BLKTB_REMARK", "BLKTB_EXPIREDATE", "BLKTB_SELTBLS", "ID", "BLKTBSFIELDCODE_ID", "BLKTBSFIELDCODE_PERSON_ID_UPD", "PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EXPIREDATE_UPD", "BLKTBSFIELDCODE_CONTENTS", "BLKTBSFIELDCODE_VIEWFLMK") AS 
  select blktbsfieldcode.connectseq blktbsfieldcode_connectseq ,blktbsfieldcode.expiredate blktbsfieldcode_expiredate ,blktbsfieldcode.updated_at blktbsfieldcode_updated_at ,blktbsfieldcode.remark blktbsfieldcode_remark ,blktbsfieldcode.created_at blktbsfieldcode_created_at ,blktbsfieldcode.update_ip blktbsfieldcode_update_ip ,blktbsfieldcode.fieldcodes_id blktbsfieldcode_fieldcode_id , fieldcode.fieldcode_expiredate fieldcode_expiredate, fieldcode.fieldcode_ftype fieldcode_ftype, fieldcode.fieldcode_remark fieldcode_remark, fieldcode.fieldcode_datascale fieldcode_datascale, fieldcode.fieldcode_dataprecision fieldcode_dataprecision, fieldcode.fieldcode_fieldlength fieldcode_fieldlength, fieldcode.fieldcode_id fieldcode_id, fieldcode.fieldcode_fseq fieldcode_fseq, fieldcode.fieldcode_pobject_id_fld fieldcode_pobject_id_fld, fieldcode.pobject_code_fld pobject_code_fld, fieldcode.pobject_objecttype_fld pobject_objecttype_fld, fieldcode.pobject_expiredate_fld pobject_expiredate_fld, fieldcode.pobject_contens_fld pobject_contens_fld, fieldcode.pobject_remark_fld pobject_remark_fld, fieldcode.pobject_rubycode_fld pobject_rubycode_fld, fieldcode.pobject_id_fld pobject_id_fld,blktbsfieldcode.blktbs_id blktbsfieldcode_blktb_id , blktb.blktb_id blktb_id, blktb.blktb_pobject_id_tbl blktb_pobject_id_tbl, blktb.pobject_code_tbl pobject_code_tbl, blktb.pobject_objecttype_tbl pobject_objecttype_tbl, blktb.pobject_expiredate_tbl pobject_expiredate_tbl, blktb.pobject_contens_tbl pobject_contens_tbl, blktb.pobject_remark_tbl pobject_remark_tbl, blktb.pobject_rubycode_tbl pobject_rubycode_tbl, blktb.pobject_id_tbl pobject_id_tbl, blktb.blktb_remark blktb_remark, blktb.blktb_expiredate blktb_expiredate, blktb.blktb_seltbls blktb_seltbls,blktbsfieldcode.id id,blktbsfieldcode.id blktbsfieldcode_id ,blktbsfieldcode.persons_id_upd blktbsfieldcode_person_id_upd , person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, person_upd.person_name person_name_upd, person_upd.person_expiredate person_expiredate_upd,blktbsfieldcode.contents blktbsfieldcode_contents ,blktbsfieldcode.viewflmk blktbsfieldcode_viewflmk 
 from blktbsfieldcodes blktbsfieldcode ,r_fieldcodes  fieldcode,r_blktbs  blktb,upd_persons  person_upd
 where  fieldcode.id = blktbsfieldcode.fieldcodes_id and  blktb.id = blktbsfieldcode.blktbs_id and  person_upd.id = blktbsfieldcode.persons_id_upd ;

CREATE OR REPLACE FORCE VIEW "RAILS"."R_BLKTBSFIELDCODES" ("BLKTBSFIELDCODE_CONNECTSEQ", "BLKTBSFIELDCODE_EXPIREDATE", "BLKTBSFIELDCODE_UPDATED_AT", "BLKTBSFIELDCODE_REMARK", 
"BLKTBSFIELDCODE_CREATED_AT", "BLKTBSFIELDCODE_UPDATE_IP", "BLKTBSFIELDCODE_FIELDCODE_ID", "FIELDCODE_EXPIREDATE", "FIELDCODE_FTYPE", "FIELDCODE_REMARK", 
"FIELDCODE_DATASCALE", "FIELDCODE_DATAPRECISION", "FIELDCODE_FIELDLENGTH", "FIELDCODE_ID", "FIELDCODE_FSEQ", "FIELDCODE_POBJECT_ID_FLD", "POBJECT_CODE_FLD", 
"POBJECT_OBJECTTYPE_FLD",  "POBJECT_CONTENS_FLD", "POBJECT_REMARK_FLD", "POBJECT_RUBYCODE_FLD", "POBJECT_ID_FLD", "BLKTBSFIELDCODE_BLKTB_ID", "BLKTB_ID", "BLKTB_POBJECT_ID_TBL", "POBJECT_CODE_TBL", "POBJECT_OBJECTTYPE_TBL", "POBJECT_EXPIREDATE_TBL", "POBJECT_CONTENS_TBL", "POBJECT_REMARK_TBL", "POBJECT_RUBYCODE_TBL", "POBJECT_ID_TBL", "BLKTB_REMARK", "BLKTB_EXPIREDATE", "BLKTB_SELTBLS", "ID", "BLKTBSFIELDCODE_ID", "BLKTBSFIELDCODE_PERSON_ID_UPD", "PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EXPIREDATE_UPD", "BLKTBSFIELDCODE_CONTENTS", "BLKTBSFIELDCODE_VIEWFLMK") AS 
 
 select blktbsfieldcode.connectseq blktbsfieldcode_connectseq ,blktbsfieldcode.expiredate blktbsfieldcode_expiredate ,blktbsfieldcode.updated_at blktbsfieldcode_updated_at ,
 blktbsfieldcode.remark blktbsfieldcode_remark ,blktbsfieldcode.created_at blktbsfieldcode_created_at ,blktbsfieldcode.update_ip blktbsfieldcode_update_ip ,
 blktbsfieldcode.fieldcodes_id blktbsfieldcode_fieldcode_id , fieldcode.fieldcode_expiredate fieldcode_expiredate, fieldcode.fieldcode_ftype fieldcode_ftype, 
 fieldcode.fieldcode_remark fieldcode_remark, fieldcode.fieldcode_datascale fieldcode_datascale, fieldcode.fieldcode_dataprecision fieldcode_dataprecision, 
 fieldcode.fieldcode_fieldlength fieldcode_fieldlength, fieldcode.fieldcode_id fieldcode_id, fieldcode.fieldcode_fseq fieldcode_fseq, fieldcode.fieldcode_pobject_id_fld fieldcode_pobject_id_fld,
 fieldcode.pobject_code_fld pobject_code_fld, fieldcode.pobject_objecttype_fld pobject_objecttype_fld, fieldcode.pobject_contens_fld pobject_contens_fld, fieldcode.pobject_remark_fld pobject_remark_fld, fieldcode.pobject_rubycode_fld pobject_rubycode_fld, fieldcode.pobject_id_fld pobject_id_fld,blktbsfieldcode.blktbs_id blktbsfieldcode_blktb_id , blktb.blktb_id blktb_id, blktb.blktb_pobject_id_tbl blktb_pobject_id_tbl, blktb.pobject_code_tbl pobject_code_tbl, blktb.pobject_objecttype_tbl pobject_objecttype_tbl, blktb.pobject_expiredate_tbl pobject_expiredate_tbl, blktb.pobject_contens_tbl pobject_contens_tbl, blktb.pobject_remark_tbl pobject_remark_tbl, blktb.pobject_rubycode_tbl pobject_rubycode_tbl, blktb.pobject_id_tbl pobject_id_tbl, blktb.blktb_remark blktb_remark, blktb.blktb_expiredate blktb_expiredate, blktb.blktb_seltbls blktb_seltbls,blktbsfieldcode.id id,blktbsfieldcode.id blktbsfieldcode_id ,blktbsfieldcode.persons_id_upd blktbsfieldcode_person_id_upd , person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, person_upd.person_name person_name_upd, person_upd.person_expiredate person_expiredate_upd,blktbsfieldcode.contents blktbsfieldcode_contents ,blktbsfieldcode.viewflmk blktbsfieldcode_viewflmk 
 from blktbsfieldcodes blktbsfieldcode ,r_fieldcodes  fieldcode,r_blktbs  blktb,upd_persons  person_upd
 where  fieldcode.id = blktbsfieldcode.fieldcodes_id and  blktb.id = blktbsfieldcode.blktbs_id and  person_upd.id = blktbsfieldcode.persons_id_upd ;
 
 
 select chilscreen.grp chilscreen_grp ,chilscreen.screenfields_id chilscreen_screenfield_id , screenfield.screenfield_pobject_id_sfd screenfield_pobject_id_sfd, screenfield.pobject_code_sfd pobject_code_sfd, screenfield.pobject_objecttype_sfd pobject_objecttype_sfd, screenfield.pobject_contens_sfd pobject_contens_sfd, screenfield.pobject_remark_sfd pobject_remark_sfd, screenfield.pobject_rubycode_sfd pobject_rubycode_sfd, screenfield.pobject_id_sfd pobject_id_sfd, screenfield.screenfield_edoptcols screenfield_edoptcols, screenfield.screenfield_edoptrow screenfield_edoptrow, screenfield.screenfield_width screenfield_width, screenfield.screenfield_indisp screenfield_indisp, screenfield.screenfield_rowpos screenfield_rowpos, screenfield.screenfield_seqno screenfield_seqno, screenfield.screenfield_hideflg screenfield_hideflg, screenfield.screenfield_maxvalue screenfield_maxvalue, screenfield.screenfield_editable screenfield_editable, screenfield.screenfield_paragraph screenfield_paragraph, screenfield.screenfield_selection screenfield_selection, screenfield.screenfield_crtfield screenfield_crtfield, screenfield.screenfield_edoptvalue screenfield_edoptvalue, screenfield.screenfield_subindisp screenfield_subindisp, screenfield.screenfield_type screenfield_type, screenfield.screenfield_sumkey screenfield_sumkey, screenfield.screenfield_remark screenfield_remark, screenfield.screenfield_edoptmaxlength screenfield_edoptmaxlength, screenfield.screenfield_datascale screenfield_datascale, screenfield.screenfield_dataprecision screenfield_dataprecision, screenfield.screenfield_minvalue screenfield_minvalue, screenfield.screenfield_tblkey screenfield_tblkey, screenfield.screenfield_edoptsize screenfield_edoptsize, screenfield.screenfield_colpos screenfield_colpos, screenfield.screenfield_rubycode screenfield_rubycode, screenfield.screenfield_id screenfield_id, screenfield.screenfield_formatter screenfield_formatter, screenfield.screenfield_screen_id screenfield_screen_id, screenfield.screen_strwhere screen_strwhere, screenfield.screen_rows_per_page screen_rows_per_page, screenfield.screen_rowlist screen_rowlist, screenfield.screen_height screen_height, screenfield.screen_pobject_id_view screen_pobject_id_view, screenfield.pobject_code_view pobject_code_view, screenfield.pobject_objecttype_view pobject_objecttype_view, screenfield.pobject_contens_view pobject_contens_view, screenfield.pobject_remark_view pobject_remark_view, screenfield.pobject_rubycode_view pobject_rubycode_view, screenfield.pobject_id_view pobject_id_view, screenfield.screen_form_ps screen_form_ps, screenfield.screen_strgrouporder screen_strgrouporder, screenfield.screen_strselect screen_strselect, screenfield.screen_remark screen_remark, screenfield.screen_cdrflayout screen_cdrflayout, screenfield.screen_ymlcode screen_ymlcode, screenfield.screen_id screen_id, screenfield.screen_grpcodename screen_grpcodename, screenfield.screen_pobject_id_scr screen_pobject_id_scr, screenfield.pobject_code_scr pobject_code_scr, screenfield.pobject_objecttype_scr pobject_objecttype_scr, screenfield.pobject_contens_scr pobject_contens_scr, screenfield.pobject_remark_scr pobject_remark_scr, screenfield.pobject_rubycode_scr pobject_rubycode_scr, screenfield.pobject_id_scr pobject_id_scr, screenfield.screen_screenlevel_id screen_screenlevel_id, screenfield.screenlevel_id screenlevel_id, screenfield.screenlevel_remark screenlevel_remark, screenfield.screenlevel_code screenlevel_code, screenfield.screenfield_chkbyruby screenfield_chkbyruby,chilscreen.screenfields_id_ch chilscreen_screenfield_id_ch , screenfield_ch.screenfield_pobject_id_sfd screenfield_pobject_id_sfd_ch, screenfield_ch.pobject_code_sfd pobject_code_sfd_ch, screenfield_ch.pobject_objecttype_sfd pobject_objecttype_sfd_ch, screenfield_ch.pobject_contens_sfd pobject_contens_sfd_ch, screenfield_ch.pobject_remark_sfd pobject_remark_sfd_ch, screenfield_ch.pobject_rubycode_sfd pobject_rubycode_sfd_ch, screenfield_ch.pobject_id_sfd pobject_id_sfd_ch, screenfield_ch.screenfield_edoptcols screenfield_edoptcols_ch, screenfield_ch.screenfield_edoptrow screenfield_edoptrow_ch, screenfield_ch.screenfield_width screenfield_width_ch, screenfield_ch.screenfield_indisp screenfield_indisp_ch, screenfield_ch.screenfield_rowpos screenfield_rowpos_ch, screenfield_ch.screenfield_seqno screenfield_seqno_ch, screenfield_ch.screenfield_hideflg screenfield_hideflg_ch, screenfield_ch.screenfield_maxvalue screenfield_maxvalue_ch, screenfield_ch.screenfield_editable screenfield_editable_ch, screenfield_ch.screenfield_paragraph screenfield_paragraph_ch, screenfield_ch.screenfield_selection screenfield_selection_ch, screenfield_ch.screenfield_crtfield screenfield_crtfield_ch, screenfield_ch.screenfield_edoptvalue screenfield_edoptvalue_ch, screenfield_ch.screenfield_subindisp screenfield_subindisp_ch, screenfield_ch.screenfield_type screenfield_type_ch, screenfield_ch.screenfield_sumkey screenfield_sumkey_ch, screenfield_ch.screenfield_remark screenfield_remark_ch, screenfield_ch.screenfield_edoptmaxlength screenfield_edoptmaxlength_ch, screenfield_ch.screenfield_datascale screenfield_datascale_ch, screenfield_ch.screenfield_dataprecision screenfield_dataprecision_ch, screenfield_ch.screenfield_minvalue screenfield_minvalue_ch, screenfield_ch.screenfield_tblkey screenfield_tblkey_ch, screenfield_ch.screenfield_edoptsize screenfield_edoptsize_ch, screenfield_ch.screenfield_colpos screenfield_colpos_ch, screenfield_ch.screenfield_rubycode screenfield_rubycode_ch, screenfield_ch.screenfield_id screenfield_id_ch, screenfield_ch.screenfield_formatter screenfield_formatter_ch, screenfield_ch.screenfield_screen_id screenfield_screen_id_ch, screenfield_ch.screen_strwhere screen_strwhere_ch, screenfield_ch.screen_rows_per_page screen_rows_per_page_ch, screenfield_ch.screen_rowlist screen_rowlist_ch, screenfield_ch.screen_height screen_height_ch, screenfield_ch.screen_pobject_id_view screen_pobject_id_view_ch, screenfield_ch.pobject_code_view pobject_code_view_ch, screenfield_ch.pobject_objecttype_view pobject_objecttype_view_ch, screenfield_ch.pobject_contens_view pobject_contens_view_ch, screenfield_ch.pobject_remark_view pobject_remark_view_ch, screenfield_ch.pobject_rubycode_view pobject_rubycode_view_ch, screenfield_ch.pobject_id_view pobject_id_view_ch, screenfield_ch.screen_form_ps screen_form_ps_ch, screenfield_ch.screen_strgrouporder screen_strgrouporder_ch, screenfield_ch.screen_strselect screen_strselect_ch, screenfield_ch.screen_remark screen_remark_ch, screenfield_ch.screen_cdrflayout screen_cdrflayout_ch, screenfield_ch.screen_ymlcode screen_ymlcode_ch, screenfield_ch.screen_id screen_id_ch, screenfield_ch.screen_grpcodename screen_grpcodename_ch, screenfield_ch.screen_pobject_id_scr screen_pobject_id_scr_ch, screenfield_ch.pobject_code_scr pobject_code_scr_ch, screenfield_ch.pobject_objecttype_scr pobject_objecttype_scr_ch, screenfield_ch.pobject_contens_scr pobject_contens_scr_ch, screenfield_ch.pobject_remark_scr pobject_remark_scr_ch, screenfield_ch.pobject_rubycode_scr pobject_rubycode_scr_ch, screenfield_ch.pobject_id_scr pobject_id_scr_ch, screenfield_ch.screen_screenlevel_id screen_screenlevel_id_ch, screenfield_ch.screenlevel_id screenlevel_id_ch, screenfield_ch.screenlevel_remark screenlevel_remark_ch, screenfield_ch.screenlevel_code screenlevel_code_ch, screenfield_ch.screenfield_chkbyruby screenfield_chkbyruby_ch,chilscreen.id id,chilscreen.id chilscreen_id ,chilscreen.remark chilscreen_remark ,chilscreen.expiredate chilscreen_expiredate ,chilscreen.update_ip chilscreen_update_ip ,chilscreen.created_at chilscreen_created_at ,chilscreen.updated_at chilscreen_updated_at ,chilscreen.persons_id_upd chilscreen_person_id_upd , 
  person_upd.updperson_id updperson_id_upd, person_upd.updperson_code updperson_code_upd, person_upd.updperson_name updperson_name_upd
 from chilscreens chilscreen ,r_screenfields  screenfield,r_screenfields  screenfield_ch,upd_persons  person_upd
 where  screenfield.id = chilscreen.screenfields_id and  screenfield_ch.id = chilscreen.screenfields_id_ch and  person_upd.id = chilscreen.persons_id_upd;


 
 CREATE OR REPLACE FORCE VIEW "RAILS"."R_FIELDCODES" ("FIELDCODE_EXPIREDATE", "FIELDCODE_UPDATED_AT", "FIELDCODE_FTYPE", "FIELDCODE_REMARK", "FIELDCODE_CREATED_AT", 
 "FIELDCODE_UPDATE_IP", "FIELDCODE_DATASCALE", "FIELDCODE_DATAPRECISION", "FIELDCODE_RUBYCODE", "FIELDCODE_FIELDLENGTH", "ID", "FIELDCODE_ID", "FIELDCODE_FSEQ", 
 "FIELDCODE_PERSON_ID_UPD", "PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EXPIREDATE_UPD", "FIELDCODE_POBJECT_ID_FLD",
 "POBJECT_CODE_FLD", "POBJECT_OBJECTTYPE_FLD", "POBJECT_CONTENS_FLD", "POBJECT_REMARK_FLD", "POBJECT_RUBYCODE_FLD", "POBJECT_ID_FLD") AS 
  select fieldcode.expiredate fieldcode_expiredate ,fieldcode.updated_at fieldcode_updated_at ,fieldcode.ftype fieldcode_ftype ,fieldcode.remark fieldcode_remark ,fieldcode.created_at fieldcode_created_at ,fieldcode.update_ip fieldcode_update_ip ,fieldcode.datascale fieldcode_datascale ,fieldcode.dataprecision fieldcode_dataprecision ,fieldcode.rubycode fieldcode_rubycode ,fieldcode.fieldlength fieldcode_fieldlength ,fieldcode.id id,fieldcode.id fieldcode_id ,fieldcode.fseq fieldcode_fseq ,fieldcode.persons_id_upd fieldcode_person_id_upd , person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, person_upd.person_name person_name_upd, person_upd.person_expiredate person_expiredate_upd,fieldcode.pobjects_id_fld fieldcode_pobject_id_fld , pobject_fld.pobject_code pobject_code_fld, pobject_fld.pobject_objecttype pobject_objecttype_fld, pobject_fld.pobject_contens pobject_contens_fld, pobject_fld.pobject_remark pobject_remark_fld, pobject_fld.pobject_rubycode pobject_rubycode_fld, pobject_fld.pobject_id pobject_id_fld
 from fieldcodes fieldcode ,upd_persons  person_upd,r_pobjects  pobject_fld
 where  person_upd.id = fieldcode.persons_id_upd and  pobject_fld.id = fieldcode.pobjects_id_fld;
 
 
 update opeitms set maxqty = null
 where maxqty is not null;

 
 
 
 
 