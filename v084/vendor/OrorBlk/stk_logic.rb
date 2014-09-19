   def sub_create_prd_pur_shp_sch_by_stk 
      strwhere = "where " 
      strwhere << " itms_id = #{rec[:itms_id]}  and "  if rec[:itms_id]
      strwhere << " locas_id = #{rec[:locas_id]}  and " if rec[:locas_id]
      strwhere << " sno_prj = #{rec[:sno_prj]}  and " if rec[:sno_prj]
      strwhere << " processseq = #{rec[:processseq]}    and itms_id_pare = #{rec[:itms_id_pare]}  " if rec[:processseq]
      short_stks = plsql.blk_chk_short_stk_qty.all(strwhere[0..-5])
      short_stks.each do |short_stk|
	  short_qty = sort_stk[:short_qty] * -1
	  strwhere = "where  a.itms_id = #{short_stk[:itms_id]}  and  a.locas_id = #{short_stk[:locas_id]}  and " 
      strwhere << " a.sno_prj = #{short_stk[:sno_prj]}  and  a.processseq = #{short_stk[:processseq]}  and  a.itms_id_pare = #{short_stk[:itms_id_pare]}    " 
      create_prd_pur_shps = plsql.blk_short_stk_qty_all.all(strsql)
	  command_c = {}
	  command_c[:sio_user_code] =   @sio_user_code ##
	  target_tbl = create_prd_pur_shps[0][:prdpursch] + "schs"
      command_c[:sio_classname] = "plsql_auto_#{target_tbl}_add_by_stkhists"
      @screen_code = "r_#{target_tbl}"
	  command_c[:sio_code] = @screen_code
      command_c[:sio_viewname] = @screen_code
      command_c[:sio_session_counter] =   @new_sio_session_counter
	  @show_data = get_show_data(command_c[:sio_code])  ##char_to_number_dataとともに見直し
	  create_prd_pur_shps.each do |src_tbl|
	     command_c[:id] = command_c["#{target_tbl.chop}_id".to_sym] = plsql.__send__("#{target_tbl}_seq").nextval
		 @src_tbl = src_tbl
		 @src_tbl[:priority] = inout[:priority]
		 @src_tbl[:prdpurshp] = create_prd_pur_shps[0][:prdpursch]
	     strwhere = "where pobject_code_view_src = 'r_stkhists' and pobject_code_tbl_dest = '#{target_tbl}' and tblink_seqno = 10 "   ###after_self
	     target_flds = plsql.r_tblinkflds.all(strwhere)
	     target_flds.each do |tfld|
	        command_c[("#{target_tbl.chop}_"+tfld[:pobject_code_fld].sub("s_id","_id")).to_sym] = eval(tfld[:tblinkfld_command_c]) if  tfld[:tblinkfld_command_c] 
	     end
	     sub_insert_sio_c    command_c 
	     sub_userproc_chk_insert command_c
	  end
   end