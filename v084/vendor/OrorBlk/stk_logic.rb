def
    ##inoutsの在庫数はshp で確定していること。
     rec = plsql.stkhists.first(" where strdate < to_date('#{Blksdate}','yyyy-mm-dd') and itms_id = #{key[:itms_id]} and processseq = #{key[:processseq]} and sno_prj = '#{key[:sno_prj]}' ")
     rec = psub_init_stkhists if rec.nil?
     plsql.stkhists.delete("where strdate >=  to_date('#{Blksdate}','yyyy-mm-dd') and itms_id = #{key[:itms_id]} and processseq = #{key[:processseq]} and sno_prj = '#{key[:sno_prj]}'")
     strsql = " select strdate ,itms_id , processseq,sno_prj ,substr(tblname,4,3) tblname43,locas_id,"
      strsql << " sum( qty ) qty,sum(amt) amt from inouts "
      strsql << " where strdate >= to_date('#{Blksdate}','yyyy-mm-dd') and itms_id = #{key[:itms_id]} and processseq = #{key[:processseq]} and sno_prj = '#{key[:sno_prj]}' "
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
	  if 
      allqty = rec[:qty_sch] + rec[:qty_ord] + rec[:qty_inst] + rec[:qty] - (prdpurshp[:safestkqty]||0)
      case 
        when allqty > 0
            psub_plsstk_sch rec,allqty,prdpurshp
      	when  allqty < 0
	   psub_minsstk_sch rec,allqty,prdpurshp
	else
     end
