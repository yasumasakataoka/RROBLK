    ##inoutsの在庫数はshp で確定していること。
     rec = plsql.stkhists.first(" where strdate < to_date('#{Blksdate}','yyyy-mm-dd') and itms_id = #{@inout_itm_id} and processseq = #{@inout_processseq} and sno_prj = '#{@inout_sno_prj}' ")
     rec = psub_init_stkhists if rec.nil?
     plsql.stkhists.delete("where strdate >=  to_date('#{Blksdate}','yyyy-mm-dd') and itms_id = #{@inout_itm_id} and processseq = #{@inout_processseq} and sno_prj = '#{@inout_sno_prj}'")
     strsql = " select strdate ,itms_id , processseq,sno_prj ,substr(tblname,4,3) tblname43,locas_id,"
      strsql << " sum( qty ) qty,sum(amt) amt from inouts "
      strsql << " where strdate >= to_date('#{Blksdate}','yyyy-mm-dd') and itms_id = #{@inout_itm_id} and processseq = #{@inout_processseq} and sno_prj = '#{@inout_sno_prj}' "
      strsql << " group by strdate ,itms_id , processseq,sno_prj,substr(tblname,4,3),locas_id "
      inoutall = plsql.select(:all,strsql)
      inoutall.each do |inout| 
      rec[:strdate] = inout[:strdate]
      psub_stkhists_insert rec ,inout  if rec[:strdate] < inout[:strdate] and rec[:strdate].to_date >=  Blksdate
       ###priceの扱い未定
         case  inout[:tblname43]
	          when /sch/
	              rec[:qty_sch] += inout[:qty] 
		          rec[:amt_sch] += inout[:amt]
	         when /ord/
			   rec[:qty_ord] += inout[:qty] 
		           rec[:amt_ord] += inout[:amt]  
	        when /inst/
			    rec[:qty_inst] += inout[:qty] 
	                    rec[:amt_inst] += inout[:amt]
	         when /act/
                            rec[:qty] += inout[:qty] 
		            rec[:amt] += inout[:amt]
	    end
        end      
      psub_stkhists_insert rec ,inoutall[-1]  
       prdpurshp = plsql.opeitms.first("where itms_id = #{rec[:itms_id]} and processseq = #{rec[:processseq]}  order by priority desc ")
      if prdpurshp 
         allqty = rec[:qty_sch] + rec[:qty_ord] + rec[:qty_inst] + rec[:qty] - (prdpurshp[:safestkqty]||0)
       else
         allqty = rec[:qty_sch] + rec[:qty_ord] + rec[:qty_inst] + rec[:qty]
    end
      case 
        when allqty > 0
            psub_plsstk_sch rec,allqty,prdpurshp
      	when  allqty < 0
	   psub_minsstk_sch rec,allqty,prdpurshp
	  else
      end
	  
	  
      strwhere = " where itms_id = #{command_c[:opeitm_itm_id]} and processseq = #{command_c[:opeitm_processseq]} "
	  strwhere << " and (priority = #{command_c[:opeitm_priority]} or priority = 999) "
	  strwhere << " order by priority "
	  opeitm = plsql.opeitms.first(strwhere)
	  n0 = {}
	  n0 = {:seq => "001",:mlevel=>0}
	  ngantts = sub_get_prev_process(n0,opeitm,command_c[:prdsch_strdate])
	  ngantts.concat( sub_get_chil_itms(n0,opeitm,command_c[:sprdsch_strdate])) 
	  strwhere = "where pobject_code_view_src = 'r_prdschs' and pobject_code_tbl_dest = 'inouts' and tblink_seqno = 10 "
	  target_flds = plsql.r_tblinkflds.all(strwhere)
	  command_c[:sio_user_code] =   @sio_user_code ##
	  plsql.inouts.delete("where tblname = 'prdschs' and tblid= #{command_c[:id]} ")
	  command_c[:sio_classname] = "plsql_auto_prdsch_add_"
      command_c[:sio_viewname] = command_c[:sio_code] = @screen_code = "r_inouts"
      command_c[:sio_session_counter] =   @new_sio_session_counter
	  @show_data = get_show_data(command_c[:sio_code])  ##char_to_number_dataとともに見直し
	  ngantts.each do |ngantt|
          if  ngantt.size > 0
	          target_flds.each do |tfld|
	                 command_c[("inout_"+tfld[:pobject_code_fld].sub("s_id","_id")).to_sym] = eval(tfld[:tblinkfld_command_c]) if  tfld[:tblinkfld_command_c] 
	          end
	         command_c[:id] = command_c[:inout_id] = plsql.inouts_seq.nextval
             new_command_c = sub_select_column_for_sio_insert command_c,:sio_r_inouts			
	         sub_insert_sio_c    new_command_c 
	         sub_userproc_chk_insert new_command_c
          end  
	  end	  