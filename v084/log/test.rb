def proc_fld_r_prdschs_inouts_self10

		command_c = {} 
		command_c[:sio_session_counter] =   @new_sio_session_counter 
		command_c[:sio_recordcount] = 1
		command_c[:sio_user_code] =   @sio_user_code
		command_c[:sio_code] = command_c[:sio_viewname] =  "r_inouts"
		command_c[:sio_classname] = @sio_classname
		
		if @sio_classname =~ /_delete_/ 
			command_c[:inout_id] = command_c[:id] = proc_get_nextval("inouts_seq")   
			command_c = vproc_delete_rec_contens(command_c)
		else 
			command_c[:inout_id] = command_c[:id] = proc_get_nextval("inouts_seq")   

			command_c[:inout_loca_id] = ( if yield(command_c[:prdsch_inoutf]) == "out" then @opeitm_loca_id else @prdsch_loca_id_to end) 

			command_c[:inout_itm_id] = (@opeitm_itm_id) 

			command_c[:inout_processseq] = (@prdsch_processseq) 

			command_c[:inout_strdate] = (@prdsch_duedate) 

			command_c[:inout_inoutflg] = (yield(command_c[:prdsch_inoutf])) 

			command_c[:inout_itm_id_pare] = (@pursch_itm_id_pare) 

			command_c[:inout_qty_alloc] = (yield(command_c[:prdsch_qty_alloc]||=@prdsch_qty)  

			command_c[:inout_qty] = (@prdsch_qty) 

			command_c[:inout_price] = (@prdsch_price) 

			command_c[:inout_amt] = @prdsch_amt*commnad_c[:prdsch_qty_alloc]/@prdsch_qty 

			command_c[:inout_tax] = @prdsch_tax*commnad_c[:prdsch_qty_alloc]/@prdsch_qty 

			command_c[:inout_sno] = (@prdsch_sno) 

			command_c[:inout_prjno_id] = (@prdsch_prjno_id) 

			command_c[:inout_expiredate] = "2099/12/31".to_date 

			command_c[:inout_person_id_upd] = (@pursch_person_id_upd) 

			command_c[:inout_tblname] = "prdschs" 

			command_c[:inout_tblid] = @prdsch_id 

			command_c[:inout_trngantt_id_inout] = yield(command_c[:prdsch_trngantt_id_inout]) 

			yield(command_c) if block_given?
		end  ###if @sio_classname =~ /_delete_/
		proc_simple_sio_insert command_c
	end