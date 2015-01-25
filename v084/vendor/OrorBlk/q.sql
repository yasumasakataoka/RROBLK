select trngantt_id,trngantt_strdate,trngantt_loca_id,trngantt_itm_id,trngantt_prdpurshp,trngantt_processseq,
			alloctbl_id,alloctbl_srctblname,alloctbl_srctblid,alloctbl_destblname,alloctbl_destblid,alloctbl_qty,alloctbl_id,trn.* 
		    from r_trngantts trngantt ,r_purschs trn ,r_alloctbls
		    where  alloctbl_srctblname = 'trngantts' and trngantt_id = alloctbl_srctblid
			and alloctbl_qty > 0 and alloctbl_destblname = 'purschs' and alloctbl_destblid = trn.id		    
			order by trngantt.itm_code,trngantt.trngantt_loca_id,trn.loca_id_to,trngantt.trngantt_processseq,trn.opeitm_id,
			trngantt.trngantt_strdate
			;
