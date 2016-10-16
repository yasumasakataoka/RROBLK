shprecs = proc_get_shp_contents(trn)  ##lot別在庫を求める。
shprecs.each do |lot|
      case lot[3]   ### tblname
             when /schs$|ords$|insts$/
                   ###　autocreated_ordでのerror判定
              when "lotstkhists"
              when /acts$/
                raise  if @opeitm_stktaking_f == "1"  ##logic error
      end
    stk = {}
    rec =  proc_decision_id_by_key("lotstkhists","  itms_id = #{@opeitm_itm_id} and locas_id = #{@opeitm_loca_id} and lotno = '#{lot[0]||="dummy"}' and processseq = #{@opeitm_processseq}  and prjnos_id = #{@shpact_prjno_id}  and packno = '#{lot[4]}'  ")
    stk[:lotstkhist_lotno] = lot[0]
    stk[:lotstkhist_qty] = lot[1] *-1 + (rec["qty"]||=0)
    stk[:lotstkhist_packno] = lot[4]
    stk[:lotstkhist_itm_id] = lot[5]
    stk[:lotstkhist_loca_id] = @opeitm_loca_id
    stk[:lotstkhist_starttime] = @shpact_depdate
    stk[:lotstkhist_processseq] = @opeitm_processseq
    stk[:id] = rec["id"]
    proc_fld_r_shpacts_lotstkhists_self30 do 
		stk
    end
    strsql = "select *  from r_alloctbls where alloctbl_srctblname = 'trngantts' and alloctbl_destblname = 'shpacts' and alloctbl_destblid = #{@shpact_id} "
    allocs = ActiveRecord::Base.connection.select_all(strsql)
    trn= {}
    proc_save_trn_of_opeitm(trn) do
			trn[:tblname] = "lotstkhists"
    end
    proc_update_gantt_alloc_fm_trn trn,allocs,nil
    ####
    rec =  proc_decision_id_by_key("lotstkhists","  itms_id = #{@opeitm_itm_id} and locas_id = #{@shpact_loca_id_to} and lotno = '#{lot[0]||="dummy"}' and processseq = #{@shpact_processseq_pare}  and prjnos_id = #{@shpact_prjno_id} and packno = '#{lot[4]}' ")
    stk[:lotstkhist_qty] = lot[1] + (rec["qty"]||=0)
    stk[:lotstkhist_loca_id]  = @shpact_loca_id_to
    stk[:lotstkhist_starttime] = @shpact_duedate
    stk[:lotstkhist_processseq] = lot[6]
    stk[:lotstkhist_processseq] = @shpact_processseq_pare
    stk[:id] = rec["id"]
    proc_fld_r_shpacts_lotstkhists_self30 do  ##in
		stk
    end
    strsql = "select *  from r_alloctbls where alloctbl_srctblname = 'trngantts' and alloctbl_destblname = 'shpacts' and alloctbl_destblid = #{@shpact_id} "
    allocs = ActiveRecord::Base.connection.select_all(strsql)
    trn= {}
    proc_save_trn_of_opeitm(trn) do
			trn[:tblname] = "lotstkhists"
    end
    proc_update_gantt_alloc_fm_trn trn,allocs,nil
end