delete from custords where id < 
       (select max(id) from custords)
;
delete from mkords where id < 
       (select max(id) from mkords)
;
truncate table sio_r_mkords;
truncate table trngantts;
truncate table alloctbls;
truncate table sio_r_custords
;
truncate table shpschs;
truncate table shpords;
truncate table shpinsts;


truncate table prdschs;
truncate table prdords;
---  truncate table prdinsts;


truncate table purschs;
truncate table purords;
truncate table purinsts;
truncate table purxxxrplys;
truncate table inouts;
truncate table lotstkhists;

truncate table sio_r_purschs;
truncate table sio_r_purords;
truncate table sio_r_purinsts;


truncate table sio_r_shpschs;
truncate table sio_r_shpords;
truncate table sio_r_shpinsts;


truncate table sio_r_prdschs;
truncate table sio_r_prdords;
---truncate table sio_r_prdinsts;

truncate table sio_r_inouts;
truncate table sio_r_lotstkhists;
truncate table mkschs;
truncate table sio_r_mkschs;
truncate table mkinsts;
truncate table sio_r_mkinsts;
truncate table puracts;
truncate table sio_r_puracts;

