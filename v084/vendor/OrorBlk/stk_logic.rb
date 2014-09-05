   strsql = " where strdate >= to_date('#{Blksdate}','yyyy-mm-dd') and "  ###予定在庫は昨日以前はすべてzero
   strsql << " itms_id = #{rec[:itms_id]}  and locas_id = #{rec[:locas_id]} and "
   strsql << " processseq  = #{rec[:processseq]} and  sno_prj = '#{rec[:sno_prj]}'   and "
   strsql << " (qty_sch + qty_ord + qty_inst + qty - #{safestkqty} ) < 0  order by strdate "  
   tqty = 0  ##加算
   prds_purs_shps = plsql.stkhists.all(strsql)   ###最終在庫がマイナスの品目日付順レコード
   prds_purs_shps.each do |prd_pur_shp|
      qty = prd_pur_shp[:qty_sch] + prd_pur_shp[:qty_ord] + prd_pur_shp[:qty_inst] + prd_pur_shp[:qty] - (safestkqty) 
      if allqty  <= qty and qty*-1 > tqty 
		allqty += qty*-1
		tqty += qty*-1
       else
	     if allqty  > qty and qty *-1 > tqty   
		   qty = allqty *-1
		   allqty = 0
		 end
       end	  
       n0 = {}
       n0 = {:seq => "001",:mlevel=>0}
      opeitm[:priority] = 999   ###opeitms priorityに999は必須
      opeitm[:processseq] = rec[:processseq]
      ngantts = sub_get_prev_process(n0,opeitm,prd_pur_shp[:strdate])
      ngantts.concat( sub_get_chil_itms(n0,opeitm,prd_pur_shp[:strdate]))
      ngantts.each do |ngantt|
           if  ngantt.size > 0
               @screen_code = "r_#{ngantt[:prd_pur_shp]}schs"
               @jqgrid_id  = 0	
               psub_create_prd_pur_shp ngantt,rec,"stkhists"
           end
        break if allqty<=0
      end
      opeitm[:processseq] = 999
      ngantts = sub_get_chil_itms(n0,opeitm,prd_pur_shp[:strdate])
      ngantts.each do |ngantt|
           if  ngantt.size > 0
               @screen_code = "r_#{ngantt[:prd_pur_shp]}schs"
               @jqgrid_id  = 0	
               psub_create_prd_pur_shp ngantt,rec,"stkhists"
           end
        break if allqty<=0
      end
   end