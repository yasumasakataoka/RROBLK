

  CREATE OR REPLACE FORCE VIEW "RAILS"."R_SCREENFIELDS" ("SCREENFIELD_POBJECT_ID_SFD", "POBJECT_CODE_SFD", "POBJECT_OBJECTTYPE_SFD", "POBJECT_CONTENS_SFD",
  "POBJECT_REMARK_SFD", "POBJECT_RUBYCODE_SFD", "POBJECT_ID_SFD", "SCREENFIELD_EXPIREDATE", "SCREENFIELD_UPDATED_AT", "SCREENFIELD_EDOPTCOLS", "SCREENFIELD_EDOPTROW", 
  "SCREENFIELD_WIDTH", "SCREENFIELD_INDISP", "SCREENFIELD_ROWPOS", "SCREENFIELD_SEQNO", "SCREENFIELD_HIDEFLG", "SCREENFIELD_MAXVALUE", "SCREENFIELD_EDITABLE", 
  "SCREENFIELD_PARAGRAPH", "SCREENFIELD_SELECTION", "SCREENFIELD_CRTFIELD", "SCREENFIELD_EDOPTVALUE", "SCREENFIELD_SUBINDISP", "SCREENFIELD_TYPE", "SCREENFIELD_SUMKEY",
  "SCREENFIELD_REMARK", "SCREENFIELD_CREATED_AT", "SCREENFIELD_UPDATE_IP", "SCREENFIELD_EDOPTMAXLENGTH", "SCREENFIELD_DATASCALE", "SCREENFIELD_DATAPRECISION", 
  "SCREENFIELD_MINVALUE", "SCREENFIELD_TBLKEY", "SCREENFIELD_EDOPTSIZE", "SCREENFIELD_COLPOS", "SCREENFIELD_RUBYCODE", "ID", "SCREENFIELD_ID", "SCREENFIELD_FORMATTER",
  "SCREENFIELD_PERSON_ID_UPD",
  "UPDPERSON_ID_UPD", "UPDPERSON_CODE_UPD", "UPDPERSON_NAME_UPD",  "SCREENFIELD_SCREEN_ID", "SCREEN_STRWHERE", 
  "SCREEN_ROWS_PER_PAGE", "SCREEN_ROWLIST", "SCREEN_HEIGHT", "SCREEN_POBJECT_ID_VIEW", "POBJECT_CODE_VIEW", "POBJECT_OBJECTTYPE_VIEW", "POBJECT_CONTENS_VIEW", 
  "POBJECT_REMARK_VIEW", "POBJECT_RUBYCODE_VIEW", "POBJECT_ID_VIEW", "SCREEN_FORM_PS", "SCREEN_STRGROUPORDER", "SCREEN_STRSELECT", "SCREEN_REMARK", 
  "SCREEN_CDRFLAYOUT", "SCREEN_YMLCODE", "SCREEN_ID", "SCREEN_GRPCODENAME", "SCREEN_POBJECT_ID_SCR", "POBJECT_CODE_SCR", "POBJECT_OBJECTTYPE_SCR",
  "POBJECT_CONTENS_SCR", "POBJECT_REMARK_SCR", "POBJECT_RUBYCODE_SCR", "POBJECT_ID_SCR", "SCREEN_SCREENLEVEL_ID", "SCREENLEVEL_ID", "SCREENLEVEL_REMARK",
  "SCREENLEVEL_CODE", "SCREENFIELD_CHKBYRUBY") AS 
  select screenfield.pobjects_id_sfd screenfield_pobject_id_sfd , pobject_sfd.pobject_code pobject_code_sfd, pobject_sfd.pobject_objecttype pobject_objecttype_sfd, 
 pobject_sfd.pobject_contens pobject_contens_sfd, pobject_sfd.pobject_remark pobject_remark_sfd, pobject_sfd.pobject_rubycode pobject_rubycode_sfd, 
 pobject_sfd.pobject_id pobject_id_sfd,screenfield.expiredate screenfield_expiredate ,screenfield.updated_at screenfield_updated_at ,
 screenfield.edoptcols screenfield_edoptcols ,screenfield.edoptrow screenfield_edoptrow ,screenfield.width screenfield_width ,screenfield.indisp screenfield_indisp ,
 screenfield.rowpos screenfield_rowpos ,screenfield.seqno screenfield_seqno ,screenfield.hideflg screenfield_hideflg ,screenfield.maxvalue screenfield_maxvalue ,
 screenfield.editable screenfield_editable ,screenfield.paragraph screenfield_paragraph ,screenfield.selection screenfield_selection ,
 screenfield.crtfield screenfield_crtfield ,screenfield.edoptvalue screenfield_edoptvalue ,screenfield.subindisp screenfield_subindisp ,
 screenfield.type screenfield_type ,screenfield.sumkey screenfield_sumkey ,screenfield.remark screenfield_remark ,screenfield.created_at screenfield_created_at ,
 screenfield.update_ip screenfield_update_ip ,screenfield.edoptmaxlength screenfield_edoptmaxlength ,screenfield.datascale screenfield_datascale ,
 screenfield.dataprecision screenfield_dataprecision ,screenfield.minvalue screenfield_minvalue ,screenfield.tblkey screenfield_tblkey ,
 screenfield.edoptsize screenfield_edoptsize ,screenfield.colpos screenfield_colpos ,screenfield.rubycode screenfield_rubycode ,
 screenfield.id id,screenfield.id screenfield_id ,screenfield.formatter screenfield_formatter ,
 screenfield.persons_id_upd screenfield_person_id_upd ,
 person_upd.updperson_id updperson_id_upd, person_upd.updperson_code updperson_code_upd, person_upd.updperson_name updperson_name_upd,
 screenfield.screens_id screenfield_screen_id , screen.screen_strwhere screen_strwhere, screen.screen_rows_per_page screen_rows_per_page, screen.screen_rowlist screen_rowlist, screen.screen_height screen_height, screen.screen_pobject_id_view screen_pobject_id_view, screen.pobject_code_view pobject_code_view, screen.pobject_objecttype_view pobject_objecttype_view, screen.pobject_contens_view pobject_contens_view, screen.pobject_remark_view pobject_remark_view, screen.pobject_rubycode_view pobject_rubycode_view, screen.pobject_id_view pobject_id_view, screen.screen_form_ps screen_form_ps, screen.screen_strgrouporder screen_strgrouporder, screen.screen_strselect screen_strselect, screen.screen_remark screen_remark, screen.screen_cdrflayout screen_cdrflayout, screen.screen_ymlcode screen_ymlcode, screen.screen_id screen_id, screen.screen_grpcodename screen_grpcodename, screen.screen_pobject_id_scr screen_pobject_id_scr, screen.pobject_code_scr pobject_code_scr, screen.pobject_objecttype_scr pobject_objecttype_scr, screen.pobject_contens_scr pobject_contens_scr, screen.pobject_remark_scr pobject_remark_scr, screen.pobject_rubycode_scr pobject_rubycode_scr, screen.pobject_id_scr pobject_id_scr, screen.screen_screenlevel_id screen_screenlevel_id, screen.screenlevel_id screenlevel_id, screen.screenlevel_remark screenlevel_remark, screen.screenlevel_code screenlevel_code,screenfield.chkbyruby screenfield_chkbyruby 
 from screenfields screenfield ,r_pobjects  pobject_sfd,upd_persons  person_upd,r_screens  screen
 where  pobject_sfd.id = screenfield.pobjects_id_sfd and  person_upd.id = screenfield.persons_id_upd and  screen.id = screenfield.screens_id;
 
 
 
  CREATE OR REPLACE FORCE VIEW "RAILS"."R_POBJGRPS" ("POBJGRP_USERGROUP_ID", "USERGROUP_ID", "USERGROUP_CODE", "USERGROUP_NAME", "USERGROUP_REMARK", 
  "USERGROUP_EXPIREDATE", "POBJGRP_NAME", "POBJGRP_PERSON_ID_UPD", 
  "PERSON_ID_UPD", "PERSON_CODE_UPD", "PERSON_NAME_UPD", "PERSON_EXPIREDATE_UPD", "POBJGRP_UPDATED_AT", "POBJGRP_CREATED_AT", "POBJGRP_UPDATE_IP", "POBJGRP_EXPIREDATE", "POBJGRP_REMARK", "ID", "POBJGRP_ID", "POBJGRP_POBJECT_ID", "POBJECT_CODE", "POBJECT_OBJECTTYPE", "POBJECT_EXPIREDATE", "POBJECT_CONTENS", "POBJECT_REMARK", "POBJECT_RUBYCODE", "POBJECT_ID") AS 
  select pobjgrp.usergroups_id pobjgrp_usergroup_id , usergroup.usergroup_id usergroup_id, usergroup.usergroup_code usergroup_code, usergroup.usergroup_name usergroup_name, usergroup.usergroup_remark usergroup_remark, usergroup.usergroup_expiredate usergroup_expiredate,pobjgrp.name pobjgrp_name ,pobjgrp.persons_id_upd pobjgrp_person_id_upd , person_upd.person_id person_id_upd, person_upd.person_code person_code_upd, person_upd.person_name person_name_upd, person_upd.person_expiredate person_expiredate_upd,pobjgrp.updated_at pobjgrp_updated_at ,pobjgrp.created_at pobjgrp_created_at ,pobjgrp.update_ip pobjgrp_update_ip ,pobjgrp.expiredate pobjgrp_expiredate ,pobjgrp.remark pobjgrp_remark ,pobjgrp.id id,pobjgrp.id pobjgrp_id ,pobjgrp.pobjects_id pobjgrp_pobject_id , pobject.pobject_code pobject_code, pobject.pobject_objecttype pobject_objecttype, pobject.pobject_expiredate pobject_expiredate, pobject.pobject_contens pobject_contens, pobject.pobject_remark pobject_remark, pobject.pobject_rubycode pobject_rubycode, pobject.pobject_id pobject_id
 from pobjgrps pobjgrp ,r_usergroups  usergroup,upd_persons  person_upd,r_pobjects  pobject
 where  usergroup.id = pobjgrp.usergroups_id and  person_upd.id = pobjgrp.persons_id_upd and  pobject.id = pobjgrp.pobjects_id ;




  CREATE OR REPLACE FORCE VIEW "RAILS"."R_SCREENS" ("SCREEN_EXPIREDATE", "SCREEN_UPDATED_AT", "SCREEN_STRWHERE", "SCREEN_ROWS_PER_PAGE", "SCREEN_ROWLIST", 
  "SCREEN_HEIGHT", "SCREEN_POBJECT_ID_VIEW", "POBJECT_CODE_VIEW", "POBJECT_OBJECTTYPE_VIEW", "POBJECT_EXPIREDATE_VIEW", "POBJECT_CONTENS_VIEW", "POBJECT_REMARK_VIEW", 
  "POBJECT_RUBYCODE_VIEW", "POBJECT_ID_VIEW", "SCREEN_FORM_PS", "SCREEN_STRGROUPORDER", "SCREEN_STRSELECT", "SCREEN_REMARK", "SCREEN_CREATED_AT", 
  "SCREEN_UPDATE_IP", "SCREEN_CDRFLAYOUT", "SCREEN_YMLCODE", "ID", "SCREEN_ID", "SCREEN_GRPCODENAME", "SCREEN_PERSON_ID_UPD", 
  "UPDPERSON_ID_UPD", "UPDPERSON_CODE_UPD", "UPDPERSON_NAME_UPD",
  "SCREEN_POBJECT_ID_SCR", "POBJECT_CODE_SCR", "POBJECT_OBJECTTYPE_SCR", "POBJECT_EXPIREDATE_SCR", "POBJECT_CONTENS_SCR", "POBJECT_REMARK_SCR", "POBJECT_RUBYCODE_SCR", "POBJECT_ID_SCR", "SCREEN_SCREENLEVEL_ID", "SCREENLEVEL_ID", "SCREENLEVEL_REMARK", "SCREENLEVEL_EXPIREDATE", "SCREENLEVEL_CODE") AS 
 select screen.expiredate screen_expiredate ,screen.updated_at screen_updated_at ,screen.strwhere screen_strwhere ,screen.rows_per_page screen_rows_per_page ,
 screen.rowlist screen_rowlist ,screen.height screen_height ,screen.pobjects_id_view screen_pobject_id_view , pobject_view.pobject_code pobject_code_view,
 pobject_view.pobject_objecttype pobject_objecttype_view, pobject_view.pobject_expiredate pobject_expiredate_view, pobject_view.pobject_contens pobject_contens_view, 
 pobject_view.pobject_remark pobject_remark_view, pobject_view.pobject_rubycode pobject_rubycode_view, pobject_view.pobject_id pobject_id_view,screen.form_ps screen_form_ps ,
 screen.strgrouporder screen_strgrouporder ,screen.strselect screen_strselect ,screen.remark screen_remark ,screen.created_at screen_created_at ,
 screen.update_ip screen_update_ip ,screen.cdrflayout screen_cdrflayout ,screen.ymlcode screen_ymlcode ,screen.id id,screen.id screen_id ,
 screen.grpcodename screen_grpcodename ,
 screen.persons_id_upd screen_person_id_upd , person_upd.updperson_id updperson_id_upd, person_upd.updperson_code updperson_code_upd, 
 person_upd.updperson_name updperson_name_upd,screen.pobjects_id_scr screen_pobject_id_scr , pobject_scr.pobject_code pobject_code_scr, pobject_scr.pobject_objecttype pobject_objecttype_scr, pobject_scr.pobject_expiredate pobject_expiredate_scr, pobject_scr.pobject_contens pobject_contens_scr, pobject_scr.pobject_remark pobject_remark_scr, pobject_scr.pobject_rubycode pobject_rubycode_scr, pobject_scr.pobject_id pobject_id_scr,screen.screenlevels_id screen_screenlevel_id , screenlevel.screenlevel_id screenlevel_id, screenlevel.screenlevel_remark screenlevel_remark, screenlevel.screenlevel_expiredate screenlevel_expiredate, screenlevel.screenlevel_code screenlevel_code
 from screens screen ,r_pobjects  pobject_view,upd_persons  person_upd,r_pobjects  pobject_scr,r_screenlevels  screenlevel
 where  pobject_view.id = screen.pobjects_id_view and  person_upd.id = screen.persons_id_upd and  pobject_scr.id = screen.pobjects_id_scr and  
 screenlevel.id = screen.screenlevels_id ;
 
 
 
  CREATE OR REPLACE FORCE VIEW "RAILS"."R_POBJECTS" ("POBJECT_CODE", "POBJECT_OBJECTTYPE", "POBJECT_EXPIREDATE", "POBJECT_UPDATED_AT", "POBJECT_CONTENS", 
  "POBJECT_REMARK", "POBJECT_CREATED_AT", "POBJECT_UPDATE_IP", "POBJECT_RUBYCODE", "ID", "POBJECT_ID",
  "POBJECT_PERSON_ID_UPD", 
  "UPDPERSON_ID_UPD", "UPDPERSON_CODE_UPD", "UPDPERSON_NAME_UPD") AS 
  select pobject.code pobject_code ,pobject.objecttype pobject_objecttype ,pobject.expiredate pobject_expiredate ,
  pobject.updated_at pobject_updated_at ,pobject.contens pobject_contens ,pobject.remark pobject_remark ,
  pobject.created_at pobject_created_at ,pobject.update_ip pobject_update_ip ,pobject.rubycode pobject_rubycode ,pobject.id id,pobject.id pobject_id ,
  pobject.persons_id_upd pobject_person_id_upd , 
  person_upd.updperson_id updperson_id_upd, person_upd.updperson_code updperson_code_upd, person_upd.updperson_name updperson_name_upd
 from pobjects pobject ,upd_persons  person_upd
 where  person_upd.id = pobject.persons_id_upd;



CREATE OR REPLACE FORCE VIEW "RAILS"."R_POBJGRPS" ("POBJGRP_USERGROUP_ID", "USERGROUP_ID", "USERGROUP_CODE", "USERGROUP_NAME",
"USERGROUP_REMARK", "USERGROUP_EXPIREDATE", "POBJGRP_NAME", "POBJGRP_PERSON_ID_UPD",
"UPDPERSON_ID_UPD", "UPDPERSON_CODE_UPD", "UPDPERSON_NAME_UPD", 
"POBJGRP_UPDATED_AT", "POBJGRP_CREATED_AT", "POBJGRP_UPDATE_IP", "POBJGRP_EXPIREDATE", "POBJGRP_REMARK", "ID", "POBJGRP_ID", 
"POBJGRP_POBJECT_ID", "POBJECT_CODE", "POBJECT_OBJECTTYPE", "POBJECT_EXPIREDATE", "POBJECT_CONTENS", "POBJECT_REMARK", "POBJECT_RUBYCODE", "POBJECT_ID") AS 
select pobjgrp.usergroups_id pobjgrp_usergroup_id , usergroup.usergroup_id usergroup_id, usergroup.usergroup_code usergroup_code,
  usergroup.usergroup_name usergroup_name, usergroup.usergroup_remark usergroup_remark, usergroup.usergroup_expiredate usergroup_expiredate,pobjgrp.name pobjgrp_name ,
  pobjgrp.persons_id_upd pobjgrp_person_id_upd , 
  person_upd.updperson_id updperson_id_upd, person_upd.updperson_code updperson_code_upd, person_upd.updperson_name updperson_name_upd,
  pobjgrp.updated_at pobjgrp_updated_at ,pobjgrp.created_at pobjgrp_created_at ,pobjgrp.update_ip pobjgrp_update_ip ,pobjgrp.expiredate pobjgrp_expiredate ,pobjgrp.remark pobjgrp_remark ,pobjgrp.id id,pobjgrp.id pobjgrp_id ,pobjgrp.pobjects_id pobjgrp_pobject_id , pobject.pobject_code pobject_code, pobject.pobject_objecttype pobject_objecttype, pobject.pobject_expiredate pobject_expiredate, pobject.pobject_contens pobject_contens, pobject.pobject_remark pobject_remark, pobject.pobject_rubycode pobject_rubycode, pobject.pobject_id pobject_id
 from pobjgrps pobjgrp ,r_usergroups  usergroup,upd_persons  person_upd,r_pobjects  pobject
 where  usergroup.id = pobjgrp.usergroups_id and  person_upd.id = pobjgrp.persons_id_upd and  pobject.id = pobjgrp.pobjects_id ;
 
 
 CREATE OR REPLACE FORCE VIEW "RAILS"."R_USERGROUPS" ("USERGROUP_NAME", "USERGROUP_CODE", "USERGROUP_PERSON_ID_UPD", 
 "UPDPERSON_ID_UPD", "UPDPERSON_CODE_UPD", "UPDPERSON_NAME_UPD", 
 "USERGROUP_UPDATED_AT", "USERGROUP_CREATED_AT", "USERGROUP_UPDATE_IP", "USERGROUP_EXPIREDATE", "USERGROUP_REMARK", "ID", "USERGROUP_ID") AS 
  select usergroup.name usergroup_name ,usergroup.code usergroup_code ,usergroup.persons_id_upd usergroup_person_id_upd ,
  person_upd.updperson_id updperson_id_upd, person_upd.updperson_code updperson_code_upd, person_upd.updperson_name updperson_name_upd, 
  usergroup.updated_at usergroup_updated_at ,usergroup.created_at usergroup_created_at ,usergroup.update_ip usergroup_update_ip ,usergroup.expiredate usergroup_expiredate ,usergroup.remark usergroup_remark ,usergroup.id id,usergroup.id usergroup_id 
 from usergroups usergroup ,upd_persons  person_upd
 where  person_upd.id = usergroup.persons_id_upd ;



  CREATE OR REPLACE FORCE VIEW "RAILS"."R_BLKTBS" ("ID", "BLKTB_ID", "BLKTB_POBJECT_ID_TBL", "POBJECT_CODE_TBL", "POBJECT_OBJECTTYPE_TBL", 
  "POBJECT_EXPIREDATE_TBL", "POBJECT_CONTENS_TBL", "POBJECT_REMARK_TBL", "POBJECT_RUBYCODE_TBL", "POBJECT_ID_TBL", "BLKTB_REMARK", "BLKTB_EXPIREDATE", "BLKTB_UPDATE_IP", 
  "BLKTB_CREATED_AT", "BLKTB_UPDATED_AT", "BLKTB_PERSON_ID_UPD", 
  "UPDPERSON_ID_UPD", "UPDPERSON_CODE_UPD", "UPDPERSON_NAME_UPD",  "BLKTB_SELTBLS") AS 
  select blktb.id id,blktb.id blktb_id ,blktb.pobjects_id_tbl blktb_pobject_id_tbl , pobject_tbl.pobject_code pobject_code_tbl,
  pobject_tbl.pobject_objecttype pobject_objecttype_tbl, pobject_tbl.pobject_expiredate pobject_expiredate_tbl, pobject_tbl.pobject_contens pobject_contens_tbl,
  pobject_tbl.pobject_remark pobject_remark_tbl, pobject_tbl.pobject_rubycode pobject_rubycode_tbl, pobject_tbl.pobject_id pobject_id_tbl,
  blktb.remark blktb_remark ,blktb.expiredate blktb_expiredate ,blktb.update_ip blktb_update_ip ,blktb.created_at blktb_created_at ,
  blktb.updated_at blktb_updated_at ,blktb.persons_id_upd blktb_person_id_upd , 
  person_upd.UPDperson_id UPDperson_id_upd, person_upd.updperson_code updperson_code_upd, person_upd.updperson_name updperson_name_upd,
  blktb.seltbls blktb_seltbls 
 from blktbs blktb ,r_pobjects  pobject_tbl,upd_persons  person_upd
 where  pobject_tbl.id = blktb.pobjects_id_tbl and  person_upd.id = blktb.persons_id_upd ;
 
 
 
  CREATE OR REPLACE FORCE VIEW "RAILS"."R_tblfields" ("BLKTBSFIELDCODE_CONNECTSEQ", "BLKTBSFIELDCODE_EXPIREDATE", "BLKTBSFIELDCODE_UPDATED_AT", 
  "BLKTBSFIELDCODE_REMARK", "BLKTBSFIELDCODE_CREATED_AT", "BLKTBSFIELDCODE_UPDATE_IP", "BLKTBSFIELDCODE_RUBYCODE", "BLKTBSFIELDCODE_FIELDCODE_ID", 
  "FIELDCODE_FTYPE", "FIELDCODE_REMARK", "FIELDCODE_DATASCALE", "FIELDCODE_DATAPRECISION", "FIELDCODE_RUBYCODE", "FIELDCODE_FIELDLENGTH", "FIELDCODE_ID",
  "FIELDCODE_FSEQ", "FIELDCODE_POBJECT_ID_FLD", "POBJECT_CODE_FLD", "POBJECT_OBJECTTYPE_FLD", "POBJECT_CONTENS_FLD", "POBJECT_REMARK_FLD", "POBJECT_RUBYCODE_FLD", 
  "POBJECT_ID_FLD", "BLKTBSFIELDCODE_BLKTB_ID", "BLKTB_ID", "BLKTB_POBJECT_ID_TBL", "POBJECT_CODE_TBL", "POBJECT_OBJECTTYPE_TBL", "POBJECT_CONTENS_TBL",
  "POBJECT_REMARK_TBL", "POBJECT_RUBYCODE_TBL", "POBJECT_ID_TBL", "BLKTB_REMARK", "BLKTB_SELTBLS", "ID", "BLKTBSFIELDCODE_ID", "BLKTBSFIELDCODE_PERSON_ID_UPD",
  "UPDPERSON_ID_UPD", "UPDPERSON_CODE_UPD", "UPDPERSON_NAME_UPD",  
  "BLKTBSFIELDCODE_CONTENTS", "BLKTBSFIELDCODE_VIEWFLMK") AS 
  select blktbsfieldcode.connectseq blktbsfieldcode_connectseq ,blktbsfieldcode.expiredate blktbsfieldcode_expiredate ,
  blktbsfieldcode.updated_at blktbsfieldcode_updated_at ,blktbsfieldcode.remark blktbsfieldcode_remark ,blktbsfieldcode.created_at blktbsfieldcode_created_at ,
  blktbsfieldcode.update_ip blktbsfieldcode_update_ip ,blktbsfieldcode.rubycode blktbsfieldcode_rubycode ,blktbsfieldcode.fieldcodes_id blktbsfieldcode_fieldcode_id ,
  fieldcode.fieldcode_ftype fieldcode_ftype, fieldcode.fieldcode_remark fieldcode_remark, fieldcode.fieldcode_datascale fieldcode_datascale, 
  fieldcode.fieldcode_dataprecision fieldcode_dataprecision, fieldcode.fieldcode_rubycode fieldcode_rubycode, fieldcode.fieldcode_fieldlength fieldcode_fieldlength,
  fieldcode.fieldcode_id fieldcode_id, fieldcode.fieldcode_fseq fieldcode_fseq, fieldcode.fieldcode_pobject_id_fld fieldcode_pobject_id_fld, 
  fieldcode.pobject_code_fld pobject_code_fld, fieldcode.pobject_objecttype_fld pobject_objecttype_fld, fieldcode.pobject_contens_fld pobject_contens_fld,
  fieldcode.pobject_remark_fld pobject_remark_fld, fieldcode.pobject_rubycode_fld pobject_rubycode_fld, fieldcode.pobject_id_fld pobject_id_fld,
  blktbsfieldcode.blktbs_id blktbsfieldcode_blktb_id , blktb.blktb_id blktb_id, blktb.blktb_pobject_id_tbl blktb_pobject_id_tbl,
  blktb.pobject_code_tbl pobject_code_tbl, blktb.pobject_objecttype_tbl pobject_objecttype_tbl, blktb.pobject_contens_tbl pobject_contens_tbl, 
  blktb.pobject_remark_tbl pobject_remark_tbl, blktb.pobject_rubycode_tbl pobject_rubycode_tbl, blktb.pobject_id_tbl pobject_id_tbl, blktb.blktb_remark blktb_remark,
  blktb.blktb_seltbls blktb_seltbls,blktbsfieldcode.id id,blktbsfieldcode.id blktbsfieldcode_id ,blktbsfieldcode.persons_id_upd blktbsfieldcode_person_id_upd , 
  person_upd.updperson_id updperson_id_upd, person_upd.updperson_code updperson_code_upd, person_upd.updperson_name updperson_name_upd, 
  blktbsfieldcode.contents blktbsfieldcode_contents ,blktbsfieldcode.viewflmk blktbsfieldcode_viewflmk 
 from tblfields blktbsfieldcode ,r_fieldcodes  fieldcode,r_blktbs  blktb,upd_persons  person_upd
 where  fieldcode.id = blktbsfieldcode.fieldcodes_id and  blktb.id = blktbsfieldcode.blktbs_id and  person_upd.id = blktbsfieldcode.persons_id_upd;
 
 
 CREATE OR REPLACE FORCE VIEW "RAILS"."R_FIELDCODES" ("FIELDCODE_EXPIREDATE", "FIELDCODE_UPDATED_AT", "FIELDCODE_FTYPE", "FIELDCODE_REMARK", 
 "FIELDCODE_CREATED_AT", "FIELDCODE_UPDATE_IP", "FIELDCODE_DATASCALE", "FIELDCODE_DATAPRECISION", "FIELDCODE_RUBYCODE", "FIELDCODE_FIELDLENGTH", "ID",
 "FIELDCODE_ID", "FIELDCODE_FSEQ", "FIELDCODE_PERSON_ID_UPD", 
 "UPDPERSON_ID_UPD", "UPDPERSON_CODE_UPD", "UPDPERSON_NAME_UPD",  
 "FIELDCODE_POBJECT_ID_FLD", "POBJECT_CODE_FLD", "POBJECT_OBJECTTYPE_FLD", "POBJECT_CONTENS_FLD", "POBJECT_REMARK_FLD", "POBJECT_RUBYCODE_FLD", 
 "POBJECT_ID_FLD", "FIELDCODE_CHKBYRUBY") AS 
  select fieldcode.expiredate fieldcode_expiredate ,fieldcode.updated_at fieldcode_updated_at ,fieldcode.ftype fieldcode_ftype ,
  fieldcode.remark fieldcode_remark ,fieldcode.created_at fieldcode_created_at ,fieldcode.update_ip fieldcode_update_ip ,
  fieldcode.datascale fieldcode_datascale ,fieldcode.dataprecision fieldcode_dataprecision ,fieldcode.rubycode fieldcode_rubycode ,
  fieldcode.fieldlength fieldcode_fieldlength ,fieldcode.id id,fieldcode.id fieldcode_id ,fieldcode.fseq fieldcode_fseq ,fieldcode.persons_id_upd fieldcode_person_id_upd ,
  person_upd.updperson_id updperson_id_upd, person_upd.updperson_code updperson_code_upd, person_upd.updperson_name updperson_name_upd, 
  fieldcode.pobjects_id_fld fieldcode_pobject_id_fld , pobject_fld.pobject_code pobject_code_fld, pobject_fld.pobject_objecttype pobject_objecttype_fld, pobject_fld.pobject_contens pobject_contens_fld, pobject_fld.pobject_remark pobject_remark_fld, pobject_fld.pobject_rubycode pobject_rubycode_fld, pobject_fld.pobject_id pobject_id_fld,fieldcode.chkbyruby fieldcode_chkbyruby 
 from fieldcodes fieldcode ,upd_persons  person_upd,r_pobjects  pobject_fld
 where  person_upd.id = fieldcode.persons_id_upd and  pobject_fld.id = fieldcode.pobjects_id_fld;


  CREATE OR REPLACE FORCE VIEW "RAILS"."R_CHILSCREENS" ("CHILSCREEN_GRP", "CHILSCREEN_SCREENFIELD_ID", "SCREENFIELD_POBJECT_ID_SFD", "POBJECT_CODE_SFD", 
  "POBJECT_OBJECTTYPE_SFD", "POBJECT_CONTENS_SFD", "POBJECT_REMARK_SFD", "POBJECT_RUBYCODE_SFD", "POBJECT_ID_SFD", "SCREENFIELD_EDOPTCOLS", 
  "SCREENFIELD_EDOPTROW", "SCREENFIELD_WIDTH", "SCREENFIELD_INDISP", "SCREENFIELD_ROWPOS", "SCREENFIELD_SEQNO", "SCREENFIELD_HIDEFLG", "SCREENFIELD_MAXVALUE", 
  "SCREENFIELD_EDITABLE", "SCREENFIELD_PARAGRAPH", "SCREENFIELD_SELECTION", "SCREENFIELD_CRTFIELD", "SCREENFIELD_EDOPTVALUE", "SCREENFIELD_SUBINDISP", 
  "SCREENFIELD_TYPE", "SCREENFIELD_SUMKEY", "SCREENFIELD_REMARK", "SCREENFIELD_EDOPTMAXLENGTH", "SCREENFIELD_DATASCALE", "SCREENFIELD_DATAPRECISION",
  "SCREENFIELD_MINVALUE", "SCREENFIELD_TBLKEY", "SCREENFIELD_EDOPTSIZE", "SCREENFIELD_COLPOS", "SCREENFIELD_RUBYCODE", "SCREENFIELD_ID", "SCREENFIELD_FORMATTER",
  "SCREENFIELD_SCREEN_ID", "SCREEN_STRWHERE", "SCREEN_ROWS_PER_PAGE", "SCREEN_ROWLIST", "SCREEN_HEIGHT", "SCREEN_POBJECT_ID_VIEW", "POBJECT_CODE_VIEW", 
  "POBJECT_OBJECTTYPE_VIEW", "POBJECT_CONTENS_VIEW", "POBJECT_REMARK_VIEW", "POBJECT_RUBYCODE_VIEW", "POBJECT_ID_VIEW", "SCREEN_FORM_PS", 
  "SCREEN_STRGROUPORDER", "SCREEN_STRSELECT", "SCREEN_REMARK", "SCREEN_CDRFLAYOUT", "SCREEN_YMLCODE", "SCREEN_ID", "SCREEN_GRPCODENAME",
  "SCREEN_POBJECT_ID_SCR", "POBJECT_CODE_SCR", "POBJECT_OBJECTTYPE_SCR", "POBJECT_CONTENS_SCR", "POBJECT_REMARK_SCR", "POBJECT_RUBYCODE_SCR",
  "POBJECT_ID_SCR", "SCREEN_SCREENLEVEL_ID", "SCREENLEVEL_ID", "SCREENLEVEL_REMARK", "SCREENLEVEL_CODE", "SCREENFIELD_CHKBYRUBY", "CHILSCREEN_SCREENFIELD_ID_CH", 
  "SCREENFIELD_POBJECT_ID_SFD_CH", "POBJECT_CODE_SFD_CH", "POBJECT_OBJECTTYPE_SFD_CH", "POBJECT_CONTENS_SFD_CH", "POBJECT_REMARK_SFD_CH", "POBJECT_RUBYCODE_SFD_CH",
  "POBJECT_ID_SFD_CH", "SCREENFIELD_EDOPTCOLS_CH", "SCREENFIELD_EDOPTROW_CH", "SCREENFIELD_WIDTH_CH", "SCREENFIELD_INDISP_CH", "SCREENFIELD_ROWPOS_CH", 
  "SCREENFIELD_SEQNO_CH", "SCREENFIELD_HIDEFLG_CH", "SCREENFIELD_MAXVALUE_CH", "SCREENFIELD_EDITABLE_CH", "SCREENFIELD_PARAGRAPH_CH", "SCREENFIELD_SELECTION_CH",
  "SCREENFIELD_CRTFIELD_CH", "SCREENFIELD_EDOPTVALUE_CH", "SCREENFIELD_SUBINDISP_CH", "SCREENFIELD_TYPE_CH", "SCREENFIELD_SUMKEY_CH", "SCREENFIELD_REMARK_CH", 
  "SCREENFIELD_EDOPTMAXLENGTH_CH", "SCREENFIELD_DATASCALE_CH", "SCREENFIELD_DATAPRECISION_CH", "SCREENFIELD_MINVALUE_CH", "SCREENFIELD_TBLKEY_CH",
  "SCREENFIELD_EDOPTSIZE_CH", "SCREENFIELD_COLPOS_CH", "SCREENFIELD_RUBYCODE_CH", "SCREENFIELD_ID_CH", "SCREENFIELD_FORMATTER_CH", "SCREENFIELD_SCREEN_ID_CH", 
  "SCREEN_STRWHERE_CH", "SCREEN_ROWS_PER_PAGE_CH", "SCREEN_ROWLIST_CH", "SCREEN_HEIGHT_CH", "SCREEN_POBJECT_ID_VIEW_CH", "POBJECT_CODE_VIEW_CH", 
  "POBJECT_OBJECTTYPE_VIEW_CH", "POBJECT_CONTENS_VIEW_CH", "POBJECT_REMARK_VIEW_CH", "POBJECT_RUBYCODE_VIEW_CH", "POBJECT_ID_VIEW_CH", 
  "SCREEN_FORM_PS_CH", "SCREEN_STRGROUPORDER_CH", "SCREEN_STRSELECT_CH", "SCREEN_REMARK_CH", "SCREEN_CDRFLAYOUT_CH", "SCREEN_YMLCODE_CH",
  "SCREEN_ID_CH", "SCREEN_GRPCODENAME_CH", "SCREEN_POBJECT_ID_SCR_CH", "POBJECT_CODE_SCR_CH", "POBJECT_OBJECTTYPE_SCR_CH", "POBJECT_CONTENS_SCR_CH", 
  "POBJECT_REMARK_SCR_CH", "POBJECT_RUBYCODE_SCR_CH", "POBJECT_ID_SCR_CH", "SCREEN_SCREENLEVEL_ID_CH", "SCREENLEVEL_ID_CH", "SCREENLEVEL_REMARK_CH", 
  "SCREENLEVEL_CODE_CH", "SCREENFIELD_CHKBYRUBY_CH", "ID", "CHILSCREEN_ID", "CHILSCREEN_REMARK", "CHILSCREEN_EXPIREDATE", "CHILSCREEN_UPDATE_IP",
  "CHILSCREEN_CREATED_AT", "CHILSCREEN_UPDATED_AT", "CHILSCREEN_PERSON_ID_UPD", "UPDPERSON_ID_UPD", "UPDPERSON_CODE_UPD", "UPDPERSON_NAME_UPD") AS 
  select chilscreen.grp chilscreen_grp ,chilscreen.screenfields_id chilscreen_screenfield_id , screenfield.screenfield_pobject_id_sfd screenfield_pobject_id_sfd, screenfield.pobject_code_sfd pobject_code_sfd, screenfield.pobject_objecttype_sfd pobject_objecttype_sfd, screenfield.pobject_contens_sfd pobject_contens_sfd, screenfield.pobject_remark_sfd pobject_remark_sfd, screenfield.pobject_rubycode_sfd pobject_rubycode_sfd, screenfield.pobject_id_sfd pobject_id_sfd, screenfield.screenfield_edoptcols screenfield_edoptcols, screenfield.screenfield_edoptrow screenfield_edoptrow, screenfield.screenfield_width screenfield_width, screenfield.screenfield_indisp screenfield_indisp, screenfield.screenfield_rowpos screenfield_rowpos, screenfield.screenfield_seqno screenfield_seqno, screenfield.screenfield_hideflg screenfield_hideflg, screenfield.screenfield_maxvalue screenfield_maxvalue, screenfield.screenfield_editable screenfield_editable, screenfield.screenfield_paragraph screenfield_paragraph, screenfield.screenfield_selection screenfield_selection, screenfield.screenfield_crtfield screenfield_crtfield, screenfield.screenfield_edoptvalue screenfield_edoptvalue, screenfield.screenfield_subindisp screenfield_subindisp, screenfield.screenfield_type screenfield_type, screenfield.screenfield_sumkey screenfield_sumkey, screenfield.screenfield_remark screenfield_remark, screenfield.screenfield_edoptmaxlength screenfield_edoptmaxlength, screenfield.screenfield_datascale screenfield_datascale, screenfield.screenfield_dataprecision screenfield_dataprecision, screenfield.screenfield_minvalue screenfield_minvalue, screenfield.screenfield_tblkey screenfield_tblkey, screenfield.screenfield_edoptsize screenfield_edoptsize, screenfield.screenfield_colpos screenfield_colpos, screenfield.screenfield_rubycode screenfield_rubycode, screenfield.screenfield_id screenfield_id, screenfield.screenfield_formatter screenfield_formatter, screenfield.screenfield_screen_id screenfield_screen_id, screenfield.screen_strwhere screen_strwhere, screenfield.screen_rows_per_page screen_rows_per_page, screenfield.screen_rowlist screen_rowlist, screenfield.screen_height screen_height, screenfield.screen_pobject_id_view screen_pobject_id_view, screenfield.pobject_code_view pobject_code_view, screenfield.pobject_objecttype_view pobject_objecttype_view, screenfield.pobject_contens_view pobject_contens_view, screenfield.pobject_remark_view pobject_remark_view, screenfield.pobject_rubycode_view pobject_rubycode_view, screenfield.pobject_id_view pobject_id_view, screenfield.screen_form_ps screen_form_ps, screenfield.screen_strgrouporder screen_strgrouporder, screenfield.screen_strselect screen_strselect, screenfield.screen_remark screen_remark, screenfield.screen_cdrflayout screen_cdrflayout, screenfield.screen_ymlcode screen_ymlcode, screenfield.screen_id screen_id, screenfield.screen_grpcodename screen_grpcodename, screenfield.screen_pobject_id_scr screen_pobject_id_scr, screenfield.pobject_code_scr pobject_code_scr, screenfield.pobject_objecttype_scr pobject_objecttype_scr, screenfield.pobject_contens_scr pobject_contens_scr, screenfield.pobject_remark_scr pobject_remark_scr, screenfield.pobject_rubycode_scr pobject_rubycode_scr, screenfield.pobject_id_scr pobject_id_scr, screenfield.screen_screenlevel_id screen_screenlevel_id, screenfield.screenlevel_id screenlevel_id, screenfield.screenlevel_remark screenlevel_remark, screenfield.screenlevel_code screenlevel_code, screenfield.screenfield_chkbyruby screenfield_chkbyruby,chilscreen.screenfields_id_ch chilscreen_screenfield_id_ch , screenfield_ch.screenfield_pobject_id_sfd screenfield_pobject_id_sfd_ch, screenfield_ch.pobject_code_sfd pobject_code_sfd_ch, screenfield_ch.pobject_objecttype_sfd pobject_objecttype_sfd_ch, screenfield_ch.pobject_contens_sfd pobject_contens_sfd_ch, screenfield_ch.pobject_remark_sfd pobject_remark_sfd_ch, screenfield_ch.pobject_rubycode_sfd pobject_rubycode_sfd_ch, screenfield_ch.pobject_id_sfd pobject_id_sfd_ch, screenfield_ch.screenfield_edoptcols screenfield_edoptcols_ch, screenfield_ch.screenfield_edoptrow screenfield_edoptrow_ch, screenfield_ch.screenfield_width screenfield_width_ch, screenfield_ch.screenfield_indisp screenfield_indisp_ch, screenfield_ch.screenfield_rowpos screenfield_rowpos_ch, screenfield_ch.screenfield_seqno screenfield_seqno_ch, screenfield_ch.screenfield_hideflg screenfield_hideflg_ch, screenfield_ch.screenfield_maxvalue screenfield_maxvalue_ch, screenfield_ch.screenfield_editable screenfield_editable_ch, screenfield_ch.screenfield_paragraph screenfield_paragraph_ch, screenfield_ch.screenfield_selection screenfield_selection_ch, screenfield_ch.screenfield_crtfield screenfield_crtfield_ch, screenfield_ch.screenfield_edoptvalue screenfield_edoptvalue_ch, screenfield_ch.screenfield_subindisp screenfield_subindisp_ch, screenfield_ch.screenfield_type screenfield_type_ch, screenfield_ch.screenfield_sumkey screenfield_sumkey_ch, screenfield_ch.screenfield_remark screenfield_remark_ch, screenfield_ch.screenfield_edoptmaxlength screenfield_edoptmaxlength_ch, screenfield_ch.screenfield_datascale screenfield_datascale_ch, screenfield_ch.screenfield_dataprecision screenfield_dataprecision_ch, screenfield_ch.screenfield_minvalue screenfield_minvalue_ch, screenfield_ch.screenfield_tblkey screenfield_tblkey_ch, screenfield_ch.screenfield_edoptsize screenfield_edoptsize_ch, screenfield_ch.screenfield_colpos screenfield_colpos_ch, screenfield_ch.screenfield_rubycode screenfield_rubycode_ch, screenfield_ch.screenfield_id screenfield_id_ch, screenfield_ch.screenfield_formatter screenfield_formatter_ch, screenfield_ch.screenfield_screen_id screenfield_screen_id_ch, screenfield_ch.screen_strwhere screen_strwhere_ch, screenfield_ch.screen_rows_per_page screen_rows_per_page_ch, screenfield_ch.screen_rowlist screen_rowlist_ch, screenfield_ch.screen_height screen_height_ch, screenfield_ch.screen_pobject_id_view screen_pobject_id_view_ch, screenfield_ch.pobject_code_view pobject_code_view_ch, screenfield_ch.pobject_objecttype_view pobject_objecttype_view_ch, screenfield_ch.pobject_contens_view pobject_contens_view_ch, screenfield_ch.pobject_remark_view pobject_remark_view_ch, screenfield_ch.pobject_rubycode_view pobject_rubycode_view_ch, screenfield_ch.pobject_id_view pobject_id_view_ch, screenfield_ch.screen_form_ps screen_form_ps_ch, screenfield_ch.screen_strgrouporder screen_strgrouporder_ch, screenfield_ch.screen_strselect screen_strselect_ch, screenfield_ch.screen_remark screen_remark_ch, screenfield_ch.screen_cdrflayout screen_cdrflayout_ch, screenfield_ch.screen_ymlcode screen_ymlcode_ch, screenfield_ch.screen_id screen_id_ch, screenfield_ch.screen_grpcodename screen_grpcodename_ch, screenfield_ch.screen_pobject_id_scr screen_pobject_id_scr_ch, screenfield_ch.pobject_code_scr pobject_code_scr_ch, screenfield_ch.pobject_objecttype_scr pobject_objecttype_scr_ch, screenfield_ch.pobject_contens_scr pobject_contens_scr_ch, screenfield_ch.pobject_remark_scr pobject_remark_scr_ch, screenfield_ch.pobject_rubycode_scr pobject_rubycode_scr_ch, screenfield_ch.pobject_id_scr pobject_id_scr_ch, screenfield_ch.screen_screenlevel_id screen_screenlevel_id_ch, screenfield_ch.screenlevel_id screenlevel_id_ch, screenfield_ch.screenlevel_remark screenlevel_remark_ch, screenfield_ch.screenlevel_code screenlevel_code_ch, screenfield_ch.screenfield_chkbyruby screenfield_chkbyruby_ch,chilscreen.id id,chilscreen.id chilscreen_id ,chilscreen.remark chilscreen_remark ,chilscreen.expiredate chilscreen_expiredate ,chilscreen.update_ip chilscreen_update_ip ,chilscreen.created_at chilscreen_created_at ,chilscreen.updated_at chilscreen_updated_at ,chilscreen.persons_id_upd chilscreen_person_id_upd , 
  person_upd.updperson_id updperson_id_upd, person_upd.updperson_code updperson_code_upd, person_upd.updperson_name updperson_name_upd
 from chilscreens chilscreen ,r_screenfields  screenfield,r_screenfields  screenfield_ch,upd_persons  person_upd
 where  screenfield.id = chilscreen.screenfields_id and  screenfield_ch.id = chilscreen.screenfields_id_ch and  person_upd.id = chilscreen.persons_id_upd;



CREATE OR REPLACE FORCE VIEW "RAILS"."R_REPORTS" ("REPORT_EXPIREDATE", "REPORT_UPDATED_AT", "REPORT_REMARK", "REPORT_CREATED_AT", "REPORT_UPDATE_IP", "REPORT_FILENAME", 
"REPORT_USERGROUP_ID", "USERGROUP_NAME", "USERGROUP_CODE", "USERGROUP_EXPIREDATE", "USERGROUP_REMARK", "USERGROUP_ID", "ID", "REPORT_ID", "REPORT_POBJECT_ID_REP", 
"POBJECT_CODE_REP", "POBJECT_OBJECTTYPE_REP", "POBJECT_EXPIREDATE_REP", "POBJECT_CONTENS_REP", "POBJECT_REMARK_REP", "POBJECT_RUBYCODE_REP", "POBJECT_ID_REP", 
"REPORT_PERSON_ID_UPD", 
"UPDPERSON_ID_UPD", "UPDPERSON_CODE_UPD", "UPDPERSON_NAME_UPD", 
"REPORT_SCREEN_ID", "SCREEN_EXPIREDATE", "SCREEN_STRWHERE", 
"SCREEN_ROWS_PER_PAGE", "SCREEN_ROWLIST", "SCREEN_HEIGHT", "SCREEN_POBJECT_ID_VIEW", "POBJECT_CODE_VIEW", "POBJECT_OBJECTTYPE_VIEW", "POBJECT_EXPIREDATE_VIEW",
"POBJECT_CONTENS_VIEW", "POBJECT_REMARK_VIEW", "POBJECT_RUBYCODE_VIEW", "POBJECT_ID_VIEW", "SCREEN_FORM_PS", "SCREEN_STRGROUPORDER", "SCREEN_STRSELECT", 
"SCREEN_REMARK", "SCREEN_CDRFLAYOUT", "SCREEN_YMLCODE", "SCREEN_ID", "SCREEN_GRPCODENAME", "SCREEN_POBJECT_ID_SCR", "POBJECT_CODE_SCR", "POBJECT_OBJECTTYPE_SCR",
"POBJECT_EXPIREDATE_SCR", "POBJECT_CONTENS_SCR", "POBJECT_REMARK_SCR", "POBJECT_RUBYCODE_SCR", "POBJECT_ID_SCR", "SCREEN_SCREENLEVEL_ID", "SCREENLEVEL_ID",
"SCREENLEVEL_REMARK", "SCREENLEVEL_EXPIREDATE", "SCREENLEVEL_CODE") AS 
 select report.expiredate report_expiredate ,report.updated_at report_updated_at ,report.remark report_remark ,report.created_at report_created_at ,
  report.update_ip report_update_ip ,report.filename report_filename ,report.usergroups_id report_usergroup_id , usergroup.usergroup_name usergroup_name, 
  usergroup.usergroup_code usergroup_code, usergroup.usergroup_expiredate usergroup_expiredate, usergroup.usergroup_remark usergroup_remark,
  usergroup.usergroup_id usergroup_id,report.id id,report.id report_id ,report.pobjects_id_rep report_pobject_id_rep ,
  pobject_rep.pobject_code pobject_code_rep, pobject_rep.pobject_objecttype pobject_objecttype_rep, pobject_rep.pobject_expiredate pobject_expiredate_rep, 
  pobject_rep.pobject_contens pobject_contens_rep, pobject_rep.pobject_remark pobject_remark_rep, pobject_rep.pobject_rubycode pobject_rubycode_rep, 
  pobject_rep.pobject_id pobject_id_rep,report.persons_id_upd report_person_id_upd ,
  person_upd.updperson_id updperson_id_upd, person_upd.updperson_code updperson_code_upd, person_upd.updperson_name updperson_name_upd,
  report.screens_id report_screen_id , screen.screen_expiredate screen_expiredate, screen.screen_strwhere screen_strwhere, screen.screen_rows_per_page screen_rows_per_page, screen.screen_rowlist screen_rowlist, screen.screen_height screen_height, screen.screen_pobject_id_view screen_pobject_id_view, screen.pobject_code_view pobject_code_view, screen.pobject_objecttype_view pobject_objecttype_view, screen.pobject_expiredate_view pobject_expiredate_view, screen.pobject_contens_view pobject_contens_view, screen.pobject_remark_view pobject_remark_view, screen.pobject_rubycode_view pobject_rubycode_view, screen.pobject_id_view pobject_id_view, screen.screen_form_ps screen_form_ps, screen.screen_strgrouporder screen_strgrouporder, screen.screen_strselect screen_strselect, screen.screen_remark screen_remark, screen.screen_cdrflayout screen_cdrflayout, screen.screen_ymlcode screen_ymlcode, screen.screen_id screen_id, screen.screen_grpcodename screen_grpcodename, screen.screen_pobject_id_scr screen_pobject_id_scr, screen.pobject_code_scr pobject_code_scr, screen.pobject_objecttype_scr pobject_objecttype_scr, screen.pobject_expiredate_scr pobject_expiredate_scr, screen.pobject_contens_scr pobject_contens_scr, screen.pobject_remark_scr pobject_remark_scr, screen.pobject_rubycode_scr pobject_rubycode_scr, screen.pobject_id_scr pobject_id_scr, screen.screen_screenlevel_id screen_screenlevel_id, screen.screenlevel_id screenlevel_id, screen.screenlevel_remark screenlevel_remark, screen.screenlevel_expiredate screenlevel_expiredate, screen.screenlevel_code screenlevel_code
 from reports report ,r_usergroups  usergroup,r_pobjects  pobject_rep,upd_persons  person_upd,r_screens  screen
 where  usergroup.id = report.usergroups_id and  pobject_rep.id = report.pobjects_id_rep and  person_upd.id = report.persons_id_upd and  screen.id = report.screens_id ;
 
 
 
  CREATE OR REPLACE FORCE VIEW "RAILS"."R_USEBUTTONS" ("ID", "USEBUTTON_ID", "USEBUTTON_REMARK", "USEBUTTON_EXPIREDATE", "USEBUTTON_UPDATE_IP", 
  "USEBUTTON_CREATED_AT", "USEBUTTON_UPDATED_AT", "USEBUTTON_PERSON_ID_UPD",
  "UPDPERSON_ID_UPD", "UPDPERSON_CODE_UPD", "UPDPERSON_NAME_UPD",  
  "USEBUTTON_BUTTON_ID", "BUTTON_ID", "BUTTON_REMARK", "BUTTON_CODE", "BUTTON_SEQNO", "BUTTON_CAPTION", "BUTTON_TITLE", "BUTTON_BUTTONICON", "BUTTON_ONCLICKBUTTON", 
  "BUTTON_GETGRIDPARAM", "BUTTON_EDITGRIDROW", "BUTTON_AFTERSHOWFORM", "USEBUTTON_SCREEN_ID_UB", "SCREEN_STRWHERE_UB", "SCREEN_ROWS_PER_PAGE_UB", "SCREEN_ROWLIST_UB",
  "SCREEN_HEIGHT_UB", "SCREEN_POBJECT_ID_VIEW_UB", "POBJECT_CODE_VIEW_UB", "POBJECT_OBJECTTYPE_VIEW_UB", "POBJECT_CONTENS_VIEW_UB", "POBJECT_REMARK_VIEW_UB",
  "POBJECT_RUBYCODE_VIEW_UB", "POBJECT_ID_VIEW_UB", "SCREEN_FORM_PS_UB", "SCREEN_STRGROUPORDER_UB", "SCREEN_STRSELECT_UB", "SCREEN_REMARK_UB", "SCREEN_CDRFLAYOUT_UB",
  "SCREEN_YMLCODE_UB", "SCREEN_ID_UB", "SCREEN_GRPCODENAME_UB", "SCREEN_POBJECT_ID_SCR_UB", "POBJECT_CODE_SCR_UB", "POBJECT_OBJECTTYPE_SCR_UB", "POBJECT_CONTENS_SCR_UB", 
  "POBJECT_REMARK_SCR_UB", "POBJECT_RUBYCODE_SCR_UB", "POBJECT_ID_SCR_UB", "SCREEN_SCREENLEVEL_ID_UB", "SCREENLEVEL_ID_UB", "SCREENLEVEL_REMARK_UB", "SCREENLEVEL_CODE_UB") AS 
  select usebutton.id id,usebutton.id usebutton_id ,usebutton.remark usebutton_remark ,usebutton.expiredate usebutton_expiredate ,
  usebutton.update_ip usebutton_update_ip ,usebutton.created_at usebutton_created_at ,usebutton.updated_at usebutton_updated_at ,
  usebutton.persons_id_upd usebutton_person_id_upd , 
  person_upd.updperson_id updperson_id_upd, person_upd.updperson_code updperson_code_upd, person_upd.updperson_name updperson_name_upd, 
  usebutton.buttons_id usebutton_button_id , button.button_id button_id, button.button_remark button_remark, button.button_code button_code, button.button_seqno button_seqno, button.button_caption button_caption, button.button_title button_title, button.button_buttonicon button_buttonicon, button.button_onclickbutton button_onclickbutton, button.button_getgridparam button_getgridparam, button.button_editgridrow button_editgridrow, button.button_aftershowform button_aftershowform,usebutton.screens_id_ub usebutton_screen_id_ub , screen_ub.screen_strwhere screen_strwhere_ub, screen_ub.screen_rows_per_page screen_rows_per_page_ub, screen_ub.screen_rowlist screen_rowlist_ub, screen_ub.screen_height screen_height_ub, screen_ub.screen_pobject_id_view screen_pobject_id_view_ub, screen_ub.pobject_code_view pobject_code_view_ub, screen_ub.pobject_objecttype_view pobject_objecttype_view_ub, screen_ub.pobject_contens_view pobject_contens_view_ub, screen_ub.pobject_remark_view pobject_remark_view_ub, screen_ub.pobject_rubycode_view pobject_rubycode_view_ub, screen_ub.pobject_id_view pobject_id_view_ub, screen_ub.screen_form_ps screen_form_ps_ub, screen_ub.screen_strgrouporder screen_strgrouporder_ub, screen_ub.screen_strselect screen_strselect_ub, screen_ub.screen_remark screen_remark_ub, screen_ub.screen_cdrflayout screen_cdrflayout_ub, screen_ub.screen_ymlcode screen_ymlcode_ub, screen_ub.screen_id screen_id_ub, screen_ub.screen_grpcodename screen_grpcodename_ub, screen_ub.screen_pobject_id_scr screen_pobject_id_scr_ub, screen_ub.pobject_code_scr pobject_code_scr_ub, screen_ub.pobject_objecttype_scr pobject_objecttype_scr_ub, screen_ub.pobject_contens_scr pobject_contens_scr_ub, screen_ub.pobject_remark_scr pobject_remark_scr_ub, screen_ub.pobject_rubycode_scr pobject_rubycode_scr_ub, screen_ub.pobject_id_scr pobject_id_scr_ub, screen_ub.screen_screenlevel_id screen_screenlevel_id_ub, screen_ub.screenlevel_id screenlevel_id_ub, screen_ub.screenlevel_remark screenlevel_remark_ub, screen_ub.screenlevel_code screenlevel_code_ub
 from usebuttons usebutton ,upd_persons  person_upd,r_buttons  button,r_screens  screen_ub
 where  person_upd.id = usebutton.persons_id_upd and  button.id = usebutton.buttons_id and  screen_ub.id = usebutton.screens_id_ub;






  CREATE OR REPLACE FORCE VIEW "RAILS"."R_BUTTONS" ("ID", "BUTTON_ID", "BUTTON_REMARK", "BUTTON_EXPIREDATE", "BUTTON_UPDATE_IP", "BUTTON_CREATED_AT",
  "BUTTON_UPDATED_AT", "BUTTON_PERSON_ID_UPD", 
  "UPDPERSON_ID_UPD", "UPDPERSON_CODE_UPD", "UPDPERSON_NAME_UPD",
  "BUTTON_CODE", "BUTTON_SEQNO", 
  "BUTTON_CAPTION", "BUTTON_TITLE", "BUTTON_BUTTONICON", "BUTTON_ONCLICKBUTTON", "BUTTON_GETGRIDPARAM", "BUTTON_EDITGRIDROW", "BUTTON_AFTERSHOWFORM") AS 
  select button.id id,button.id button_id ,button.remark button_remark ,button.expiredate button_expiredate ,button.update_ip button_update_ip ,
  button.created_at button_created_at ,button.updated_at button_updated_at ,button.persons_id_upd button_person_id_upd ,
  person_upd.updperson_id updperson_id_upd, person_upd.updperson_code updperson_code_upd, person_upd.updperson_name updperson_name_upd,
  button.code button_code ,button.seqno button_seqno ,button.caption button_caption ,button.title button_title ,button.buttonicon button_buttonicon ,button.onclickbutton button_onclickbutton ,button.getgridparam button_getgridparam ,button.editgridrow button_editgridrow ,button.aftershowform button_aftershowform 
 from buttons button ,upd_persons  person_upd
 where  person_upd.id = button.persons_id_upd;



  CREATE OR REPLACE FORCE VIEW "RAILS"."CHRG_PERSONS" ("ID", "PERSON_ID", "PERSON_CODE", "PERSON_NAME", "PERSON_EMAIL", "LOCA_ID_SECT", "LOCA_CODE_SECT", 
  "LOCA_NAME_SECT", "PERSON_EXPIREDATE") AS 
  select person.id,person.id person_id ,person.code person_code,person.name person_name ,
  person.email person_email,sect.LOCA_ID_SECT LOCA_ID_SECT, sect.loca_code_sect loca_code_sect,
  sect.loca_name_sect loca_name_sect,person.EXPIREDATE person_EXPIREDATE
 from persons person ,usergroups usergroup, r_sects sect
 where person.UserGroups_id= usergroup.id  and person.sects_id = sect.id;
