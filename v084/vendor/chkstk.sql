
create or replace view blk_chk_short_stk_qty  as
select a.locas_id,a.itms_id,a.strdate,a.SNO_PRJ,a.PROCESSSEQ,
       a.itms_id_pare,
       (a.qty + a.qty_inst + a.qty_ord + a.qty_sch - nvl(safestkqty,0)) short_qty
 from stkhists a,
(select max(strdate) strdate,locas_id,itms_id,processseq,sno_prj,itms_id_pare from stkhists
where strdate >= (select datevalue from blkstddates where key = 'blksdate')
 group by locas_id,itms_id,processseq,sno_prj,itms_id_pare) b,
 opeitms c
 where a.strdate = b.strdate
 and a.ITMS_ID = b.itms_id
 and a.ITMS_ID_pare = b.ITMS_ID_pare
 and a.LOCAS_ID = b.locas_id
 and a.processseq = b.processseq
 and a.sno_prj = b.sno_prj
 and a.ITMS_ID = c.ITMS_ID
 and a.locas_id = c.LOCAS_ID
 and a.PROCESSSEQ = c.PROCESSSEQ
 and (a.qty + a.qty_inst + a.qty_ord + a.qty_sch - nvl(safestkqty,0)) < 0
 union
 select a.locas_id,a.itms_id,a.strdate,a.SNO_PRJ,a.PROCESSSEQ,
       a.ITMS_ID_PARE,
       (a.qty + a.qty_inst + a.qty_ord + a.qty_sch - nvl(nditm_safestkqty,0)) short_qty
 from stkhists a,
(select max(strdate) strdate,locas_id,itms_id,processseq,sno_prj,itms_id_pare from stkhists
where strdate >= (select datevalue from blkstddates where key = 'blksdate')
 group by locas_id,itms_id,processseq,sno_prj,itms_id_pare) b,
 r_nditms c
 where a.strdate = b.strdate
 and a.ITMS_ID = b.itms_id
 and a.ITMS_ID_pare = b.itms_id_pare
 and a.LOCAS_ID = b.locas_id
 and a.processseq = b.processseq
 and a.sno_prj = b.sno_prj
 and a.ITMS_ID = c.nditm_ITM_ID_nditm
 and a.locas_id = c.opeitm_LOCA_ID
 and a.ITMS_ID_PARE = c.OPEITM_ITM_ID
 and a.PROCESSSEQ = c.OPEITM_PROCESSSEQ
 and (a.qty + a.qty_inst + a.qty_ord + a.qty_sch - nvl(nditm_safestkqty,0)) < 0
; 


create or replace view blk_short_stk_qty_all  as
select a.locas_id,a.itms_id,a.strdate,a.SNO_PRJ,a.PROCESSSEQ,
       a.ITMS_ID_PARE,
       (a.qty + a.qty_inst + a.qty_ord + a.qty_sch - nvl(safestkqty,0)) s_qty
 from stkhists a,
 opeitms c
 where  a.ITMS_ID = c.ITMS_ID
 and a.locas_id = c.LOCAS_ID
 and a.PROCESSSEQ = c.PROCESSSEQ
 and (a.qty + a.qty_inst + a.qty_ord + a.qty_sch - nvl(safestkqty,0)) < 0
 union
 select a.locas_id,a.itms_id,a.strdate,a.SNO_PRJ,a.PROCESSSEQ,
         a.ITMS_ID_PARE,
       (a.qty + a.qty_inst + a.qty_ord + a.qty_sch - nvl(nditm_safestkqty,0)) s_qty
 from stkhists a,
 r_nditms c
 where a.ITMS_ID = c.nditm_ITM_ID_nditm
 and a.locas_id = c.opeitm_LOCA_ID
 and a.ITMS_ID_PARE = c.OPEITM_ITM_ID
 and a.PROCESSSEQ = c.OPEITM_PROCESSSEQ
 and (a.qty + a.qty_inst + a.qty_ord + a.qty_sch - nvl(nditm_safestkqty,0)) < 0
; 

select a.locas_id,a.itms_id,a.strdate,a.SNO_PRJ,a.PROCESSSEQ,
	   a.amt,a.amt_INST,a.amt_ORD,a.amt_SCH
 from stkhists a,
(select max(strdate) strdate,locas_id,itms_id,processseq,sno_prj from stkhists
 where strdate > sysdate
 group by locas_id,itms_id,processseq,sno_prj) b,
 opeitms c
 where a.strdate = b.strdate
 and a.ITMS_ID = b.itms_id
 and a.LOCAS_ID = b.locas_id
 and a.processseq = b.processseq
 and a.sno_prj = b.sno_prj
 and a.ITMS_ID = c.ITMS_ID(+)
 and a.locas_id = c.LOCAS_ID(+)
 and a.PROCESSSEQ = c.PROCESSSEQ(+)
 and (a.amt + a.amt_inst + a.amt_ord + a.amt_sch ) < 0
;
