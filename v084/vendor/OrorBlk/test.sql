
delete from custords where id <   (select max(id) from custords)
;
delete from mkords where id < 
       (select max(id) from mkords)
;
truncate table sio_r_mkords;

truncate table sio_r_custords
;
truncate table shpschs;
truncate table shpords;
truncate table shpinsts;

truncate table shpacts;


truncate table prdschs;
truncate table prdords;
truncate table prdinsts;
truncate table prdacts;


truncate table purschs;
truncate table purords;
truncate table purinsts;
truncate table inouts;
truncate table lotstkhists;

truncate table sio_r_purschs;
truncate table sio_r_purords;
truncate table sio_r_purinsts;

truncate table sio_r_shpschs;
truncate table sio_r_shpords;
truncate table sio_r_shpinsts;
truncate table sio_r_shpacts;


truncate table sio_r_prdschs;
truncate table sio_r_prdords;
truncate table sio_r_prdinsts;
truncate table sio_r_prdacts;

truncate table sio_r_inouts;
truncate table sio_r_lotstkhists;
truncate table mkschs;
truncate table sio_r_mkschs;
truncate table mkinsts;
truncate table sio_r_mkinsts;
truncate table puracts;
truncate table sio_r_puracts;
truncate table stkhists;
truncate table sio_r_stkhists;
delete from SIO_R_tblfields where tblfield_created_at < current_date - 90
;
delete from SIO_R_screenFIELDS where screenfield_created_at < current_date - 90
;
delete from SIO_R_TBLINKFLDS where TBLINKFLD_created_at < current_date - 90
;
delete from SIO_R_BLKTBS where BLKTB_created_at < current_date - 90
;

truncate table sio_r_purrplies;

truncate table purrplies;

truncate table inouts;
truncate table sio_r_inouts;
delete trngantts;


truncate table replyinputs;

truncate table sio_r_replyinputs;

truncate table rplies;

truncate table sio_r_rplies;

truncate table purinsts;

truncate table sio_r_purinsts;

truncate table results;

truncate table sio_r_results
;
truncate table prdrsltinputs;

truncate table sio_r_prdrsltinputs
;
truncate table purrsltinputs
;
truncate table purreplyinputs
;
truncate table sio_r_purrsltinputs
;
truncate table sio_r_purreplyinputs
;
truncate table shpreplyinputs
;
truncate table sio_r_shpreplyinputs
;
delete from alloctbls;
truncate table shprsltinputs;
truncate table sio_r_shprsltinputs;
truncate table prdreplyinputs;
truncate table sio_r_prdreplyinputs;