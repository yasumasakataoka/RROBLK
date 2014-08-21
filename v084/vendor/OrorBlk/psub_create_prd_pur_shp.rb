   command_c = {}
   command_c[:sio_classname] = "plsql_autostk_add_"
   command_c[:id] = plsql.__send__("#{ngantt[:prd_pur_shp]}schs_seq").nextval 
    command_c[:sio_code] = command_c[:sio_viewname] = "r_#{ngantt [:prd_pur_shp]}schs"
    command_c[("#{ngantt[:prd_pur_shp]}sch_id").to_sym] =  command_c[:id]
    isudatesym = "#{ngantt[:prd_pur_shp]}sch_isudate".to_sym
   command_c[isudatesym] = Time.now
  if  ngantt[:prd_pur_shp] =~ /prd|pur/
      strdatesym = "#{ngantt[:prd_pur_shp]}sch_strdate".to_sym  
      command_c[strdatesym] = ngantt[:endtime] - ngantt[:duration]*24*60*60  ####day固定
      duedatesym = "#{ngantt[:prd_pur_shp]}sch_duedate".to_sym
       command_c[duedatesym] = ngantt[:endtime]
       toduedatesym = "#{ngantt[:prd_pur_shp]}sch_toduedate".to_sym
      command_c[duedatesym] = ngantt[:endtime]
     else
	  duedatesym = :shpsch_depdate
      command_c[duedatesym] = ngantt[:endtime] - ngantt[:duration]*24*60*60  ####day固定
   end
   itm_idsym = "#{ngantt[:prd_pur_shp]}sch_itm_id".to_sym
   command_c[itm_idsym] = ngantt[:itm_id]
   processseqsym = "#{ngantt[:prd_pur_shp]}sch_processseq".to_sym
   command_c[processseqsym] = ngantt[:processseq]
   loca_id_tosym = "#{ngantt[:prd_pur_shp]}sch_loca_id_to".to_sym
   command_c[loca_id_tosym] = ngantt[:loca_id_to]
   loca_idsym =case ngantt[:prd_pur_shp]
	                 when "pur"
					       "#{ngantt[:prd_pur_shp]}sch_dealer_id".to_sym
	                 when "prd"
					     "#{ngantt[:prd_pur_shp]}sch_sect_id".to_sym
			 when "shp"
					      "#{ngantt[:prd_pur_shp]}sch_loca_id".to_sym
    			 end
   command_c[loca_idsym] =
                case ngantt[:prd_pur_shp]
	                 when "pur"
					       sub_get_dealers_id_fm_locas_id ngantt[:loca_id]
	                 when "prd"
                                               sub_get_sects_id_fm_locas_id  ngantt[:loca_id]
			 when "shp"
					      ngantt[:loca_id]
    			 end
   chrgperson_idsym = "#{ngantt[:prd_pur_shp]}sch_chrgperson_id".to_sym
   command_c[chrgperson_idsym] = sub_get_chrgperson_fm_loca ngantt[:loca_id],ngantt[:prd_pur_shp]
   qtysym = "#{ngantt[:prd_pur_shp]}sch_qty".to_sym
    command_c[qtysym] = rec[:qty_sch]*ngantt[:nditm_chilnum]/ngantt[:nditm_parenum]*-1  ##小数点桁数
    pricesym = "#{ngantt[:prd_pur_shp]}sch_price".to_sym
    command_c[pricesym] = sub_get_price ngantt[:loca_id],ngantt[:itm_id],command_c[isudatesym] ,command_c[:duedatesym] 
    amtsym = "#{ngantt[:prd_pur_shp]}sch_amt".to_sym
    command_c[amtsym]  = sub_get_amt(command_c[qtysym] ,command_c[pricesym] ,ngantt[:loca_id],ngantt[:prd_pur_shp])
    taxsym = "#{ngantt[:prd_pur_shp]}sch_tax".to_sym
   ## nil
    qty_ordsym = "#{ngantt[:prd_pur_shp]}sch_qty_ord".to_sym
   command_c[qty_ordsym] = 0 
    amt_ordsym = "#{ngantt[:prd_pur_shp]}sch_amt_ord".to_sym
   command_c[amt_ordsym] = 0
   snosym = "#{ngantt[:prd_pur_shp]}sch_sno".to_sym
   command_c[snosym] = command_c[:id].to_s 
    sno_prjsym = "#{ngantt[:prd_pur_shp]}sch_sno_prj".to_sym
    command_c[sno_prjsym] = rec[:sno_prj]
    expiredatesym = "#{ngantt[:prd_pur_shp]}sch_expiredate".to_sym
    command_c[expiredatesym] = "2099/12/31".to_date 	
    tblnamesym = "#{ngantt[:prd_pur_shp]}sch_tblname".to_sym
    command_c[tblnamesym] = tblname
    tblidsym = "#{ngantt[:prd_pur_shp]}sch_tblid".to_sym
    command_c[tblidsym] = rec[:id]
    orgtblnamesym = "#{ngantt[:prd_pur_shp]}sch_orgtblname".to_sym
     command_c[orgtblnamesym] = rec[:orgtblname]
     orgtblidsym = "#{ngantt[:prd_pur_shp]}sch_orgtblid".to_sym	
     command_c[orgtblidsym] = rec[:orgtblid]	
    command_c[:sio_session_counter] =   @new_sio_session_counter
    command_c[:sio_user_code] =   @sio_user_code ##
	strsql = "select sum(qty - qty_ord) balqty from #{ngantt [:prd_pur_shp]}schs "
	strsql << " where itms_id =  #{command_c[itm_idsym]} and procressseq = #{command_c[processseqsym]} "
	strsql << " and #{duedatesym.to_s.split("_",2)[1]} > to_date('#{Blksdate}','yyyy-mm-dd') "
	strsql << " and qty > qty_ord "
	strsql << " group by itms_id,procressseq "
	chk_balqty = plsql.select(:first,strsql)
	command_c[qtysym] -= if chk_balqty then chk_balqty[:balqty] else 0 end
	if command_c[qtysym]  > 0
       @show_data = get_show_data command_c[:sio_viewname]
       sub_insert_sio_c    command_c 
       sub_userproc_chk_insert command_c
	end   