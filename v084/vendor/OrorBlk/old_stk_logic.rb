##受注とか製造の計画オーダの時も　mkopesを発行する。

strsql = "select max(strdate),itm_id,processseq,locas_id,sno_prj from stkhists " 
strwhere = ""
strwhere << " where itms_id =  #{mkope[:itms_id]} " if mkope[:itms_id]
if mkope[:locas_id] 
   if strwhere == "" 
      strwhere << " where "
	 else
       strwhere << " and "
   end
   strwhere << " locas_id = #{mkope[:locas_id]} "
end 
if mkope[:sno_prj]  ###dummy で存在する。
   if strwhere == "" 
      strwhere << " where "
	 else
       strwhere << " and "
   end
   strwhere << " sno_prj = '#{mkope[:sno_prj]} ' "
end 
strsql << strwhere +  " group  by itm_id,  processseq,locas_id,sno_prj "
###品目　processseq毎の最終在庫数
stkchks = plsql.select(:all,strsql)
stkchks.each do |stkchk|
  strsql = " where strdate = #{stkchk[:strdate]} and "
  strsql << " itms_id = #{stkchk[:itms_id]} and locas_id = #{stkchk[:locas_id]} and "
  strsql << " processseq  = #{stkchk[:processseq]} and  sno_prj = '#{mkope[:sno_prj]} '"
  strsql << " (qty_sch + qty_ord + qty_inst + qty ) < 0  "  ###安全在庫数は別テーブルで管理opeitmsにはもてない。
  prds_purs_shps = plsql.stkhists.all(strsql)　　###最終在庫がマイナスの品目
  prds_purs_shps.each do |prd_pur_shp|
    baseqty = prd_pur_shp[:qty_sch] + prd_pur_shp[:qty_ord] + prd_pur_shp[:qty_inst] + prd_pur_shp[:qty] 
	ngantts = {}
	ngantts = {:seq => "001",:mlevel=>0}
	prd_pur_shp[:priority] = 999   ###opeitms priorityに999は必須
	ngantts = sub_get_prev_process(ngantts,prd_pur_shp,prd_pur_shp[:strdate
	ngantts = sub_get_chil_itms(ngantts,prd_pur_shp,prd_pur_shp[:strdate])
    strsql = " where itms_id = #{prd_pur_shp[:itms_id]} and locas_id = #{prd_pur_shp[:locas_id]} and "
    strsql << " processseq  = #{stkchk[:processseq]} and  sno_prj = '#{mkope[:sno_prj]} '"
    strsql << " (qty_sch + qty_ord + qty_inst + qty ) < 0 and "
    strsql << "	strdate >= (to_date(to_char(sysdate,'yyyy/mm/dd'),'yyyy/mm/dd') -1 ) order by strdate"
    doqty = plsql.stkhists.first(strsql)  ###マイナス在庫になっている日付
	if baseqty <= doqty[:qty_sch]
        addqty = doqty[:qty_sch] *-1
        baseqty += addqty
	  else
        addqty = baseqty *-1
        baseqty = 0
    end
	command_c[:sio_session_counter] =   user_seq_nextval(command_c[:sio_user_code]) 
	create_inouts
	ngants.each do |ngantt|
        @screen_code = "r_#{ngantt[:prd_pur_shp]}schs"
		@jqgrid_id  = 0	
        command_c[:sio_classname] = "plsql_autostk_add_"
		create_prd_pur_shp
        command_c[:id] = plsql.__send__(command_c[:sio_viewname].split("_")[1] + "_seq").nextval 
        command_c[(command_c[:sio_viewname].split("_")[1].chop + "_id").to_sym] =  command_c[:id]
        sub_insert_sio_c    command_c 
	end
	
    sub_userproc_insert command_c
    plsql.commit
    dbcud = DbCud.new
    dbcud.perform(command_c[:sio_session_counter],command_c[:sio_user_code])		
    end		   
  end
						
 end  	