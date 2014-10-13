truncate table sio_r_shpschs
;
truncate table shpschs
;

delete custords where id <(select max(id) from custords)
;truncate table sio_r_prdschs
;
truncate table prdschs
;
truncate table sio_r_purschs
;
truncate table purschs
;
truncate table sio_r_inouts
;
truncate table inouts
;
truncate table stkhists
;
;




