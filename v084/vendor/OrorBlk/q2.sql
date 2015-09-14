select a.trngantt_key,a.ITM_CODE,a.ITM_NAME,a.LOCA_CODE,a.loca_name,a.opeitm_prdpurshp prdpurshp,
 alloctbl_destblname,alloctbl_destblid,
							min(a.TRNGANTT_STRDATE) org_strdate,max(a.TRNGANTT_MLEVEL) mlevel,
							max(a.TRNGANTT_dueDATE) org_duedate,max(a.trngantt_qty) qty,
							sum(case when b.alloctbl_destblname like '%schs' then b.alloctbl_qty else 0 end) qty_alloc_sch,
							sum(case when b.alloctbl_destblname like '%ords' then b.alloctbl_qty else 0 end) qty_alloc_ord,
							sum(case when b.alloctbl_destblname like '%insts' then b.alloctbl_qty else 0 end) qty_alloc_inst,
							sum(case when b.alloctbl_destblname like '%act%' then b.alloctbl_qty else 0 end) qty_alloc_stk,
							a.trngantt_orgtblname,a.trngantt_orgtblid
 from r_trngantts a 
					 inner join r_alloctbls b on a.trngantt_id = b.alloctbl_srctblid 
					 and b.alloctbl_srctblname = 'trngantts' and b.alloctbl_qty > 0
					 where a.trngantt_orgtblname = 'custords' and a.trngantt_orgtblid = 5601 
					 group by a.trngantt_key,a.ITM_CODE,a.ITM_NAME,a.LOCA_CODE,a.loca_name,a.trngantt_orgtblname,a.trngantt_orgtblid,
								alloctbl_destblname,alloctbl_destblid,a.opeitm_prdpurshp
					 order by a.trngantt_key
					 ;
