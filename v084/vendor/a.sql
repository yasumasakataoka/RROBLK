truncate  table mkords;
alter table mkords modify id number(38,0);
 alter table mkords modify persons_id_upd number(38,0);
 alter table mkords modify runtime number(2,0); 
 alter table mkords modify itms_id_org number(38,0); 
 alter table mkords modify locas_id_trn number(38,0); 
 alter table mkords modify itms_id_trn number(38,0);
  alter table mkords modify locas_id_org number(38,0); 
  alter table mkords modify chrgpersons_id_org number(38,0);
   alter table mkords add chrgpersons_id_trn number (38,0); 
   
   alter table mkords modify incnt number(38,0); 
   alter table mkords modify outcnt number(38,0);
    alter table mkords modify skipcnt number(38,0); 
	alter table mkords modify inqty number(38,4);
	 alter table mkords modify outqty number(38,4);
	  alter table mkords modify skipqty number(38,4); 
	  alter table mkords modify skipamt number(38,4); 
	  alter table mkords modify outamt number(38,4); 
	  alter table mkords modify inamt number(38,4);
 alter table mkords drop (chrgpersons_id_tbl);
 
drop table bk_trndetails_0923
;
alter table trngantts drop (tblid); 
alter table trngantts drop (tblname);


alter table trngantts  drop  CONSTRAINT trngantts_ukysg1 CASCADE; 


alter table trngantts  drop  CONSTRAINT trngantts_ukysg2 CASCADE; 

a
