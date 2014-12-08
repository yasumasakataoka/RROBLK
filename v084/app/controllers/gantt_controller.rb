# -*- coding: utf-8 -*-  
class   GanttController  <  ScreenController
###同一priorityのもののみ抽出
    before_filter :authenticate_user!  
    respond_to :html ,:xml ##  将来　タイトルに変更
    def index
	    scr_code = params[:screen_code].split("_")[1]
        case params[:screen_code]
            when /^ganttmst_/   ##r_opeitm と
			    @master = true
			    proc_mst_gantt  scr_code,params[:id]
			when  /^gantttrn_/
			    @master = false			
			    proc_trn_gantt  scr_code,params[:id]
        end
        @xnum1 = "parent_number"
        @xnum1witdth = 30   
        ##debugger
        ##fprnt("@ganttdata :#{@ganttdata}")
        render :json =>@ganttdata

    end
    def  proc_mst_gantt  mst_code,id
        ngantts = []
        time_now =  Time.now 
		case mst_code
		    when "itms"
		     itm = plsql.select(:first,"select * from itms where id = '#{id}'  ")
             rec = plsql.select(:first,"select * from opeitms where itms_id = #{id} and Expiredate > current_date   order by priority desc, processseq desc,Expiredate ")
		end
        if rec then 
            ngantts << {:seq=>"001",:mlevel=>1,:itm_id=>rec[:itms_id],:loca_id=>rec[:locas_id],:processseq=>rec[:processseq],:priority=>rec[:priority],:endtime=>time_now,:id=>"opeitms_"+rec[:id].to_s}
            cnt = 0
            @bgantts = {}
            @bgantts[:"000"] = {:mlevel=>0,:itm_code=>"",:itm_name=>"全行程",:loca_code=>"",:loca_name=>"",:opeitm_duration=>"",:assigs=>"",:endtime=>time_now,:starttime=>nil,:depends=>"",:id=>0}
            until ngantts.size == 0
               cnt += 1
               ngantts = proc_get_tree_itms_locas ngantts
               break if cnt >= 1000
            end
          else
            return ""
        end
     
        @bgantts[:"000"][:starttime] = Time.now
        prv_resch  ####再計算
        @bgantts[:"000"][:endtime] = @bgantts[:"001"][:endtime] 
        @bgantts[:"000"][:opeitm_duration] = " #{(@bgantts[:"000"][:endtime]  - @bgantts[:"000"][:starttime] ).divmod(24*60*60)[0]}"
        strgantt = '{"tasks":['
        @bgantts.sort.each  do|key,value|
            strgantt << %Q&{"id":"#{value[:id]}","itm_code":"#{value[:itm_code]}","itm_name":"#{value[:itm_name]}","loca_code":"#{value[:loca_code]}","loca_name":"#{value[:loca_name]}",
            "nditm_parenum":"#{value[:nditm_parenum]}","nditm_chilnum":"#{value[:nditm_chilnum]}","start":#{value[:starttime].to_i.*1000},"opeitm_duration":"#{value[:opeitm_duration]}",
            "end":#{value[:endtime].to_i.*1000},"assigs":[],"depends":"#{value[:depends]}","level":#{if value[:mlevel] == 0 then 0 else 1 end},"mlevel":#{value[:mlevel]},"subtblid":"#{value[:subtblid]}","paretblcode":""},&
        end
        ## opeitmのsubtblidのopeitmは子のinsert用
        ##debugger
        ##fprnt("#{__LINE__} strgantt :#{strgantt}")
        @ganttdata = strgantt.chop + %Q|],"selectedRow":0,"deletedTaskIds":[],"canWrite":true,"canWriteOnParent":true }|
    end  
	def sql_proc_trn_gantt trn_code,id
	    ### a.trngantt 引当て先　　b.trngantt オリジナル
        %Q& select a.trngantt_subkey,a.ITM_CODE,a.ITM_NAME,a.LOCA_CODE,a.loca_name,
                            min(a.TRNGANTT_STRDATE) strdate,min(b.TRNGANTT_STRDATE) org_strdate,max(b.TRNGANTT_MLEVEL) mlevel,
                            max(a.TRNGANTT_dueDATE) duedate,max(b.TRNGANTT_dueDATE) org_duedate,max(b.trngantt_qty) qty,
							sum(case  when a.TRNGANTT_TBLNAME like '%schs' then  a.trngantt_qty_alloc else 0 end) qty_alloc_sch,
							sum(case  when a.TRNGANTT_TBLNAME like '%ords' then  a.trngantt_qty_alloc else 0 end) qty_alloc_ord,
							sum(case  when a.TRNGANTT_TBLNAME like '%insts' then  a.trngantt_qty_alloc else 0 end) qty_alloc_inst,
							sum(case  when a.TRNGANTT_TBLNAME like '%stk%' then  a.trngantt_qty_alloc else 0 end) qty_alloc_stk,
							a.trngantt_orgtblname,a.trngantt_orgtblid
                      from r_trngantts a,r_trngantts b 
					  where (a.trngantt_tblname is not null  or a.trngantt_key  = '00000' )
                      and a.trngantt_orgtblname = '#{trn_code}' and a.trngantt_orgtblid = #{id} 
                      and a.trngantt_orgtblname = b.trngantt_orgtblname and a.trngantt_orgtblid = b.trngantt_orgtblid 
					  and a.trngantt_subkey = b.trngantt_subkey 
                      and b.trngantt_tblname is null
					  group by a.trngantt_subkey,a.ITM_CODE,a.ITM_NAME,a.LOCA_CODE,a.loca_name,a.trngantt_orgtblname,a.trngantt_orgtblid
					  order by a.trngantt_subkey&
	end
    def  proc_trn_gantt  trn_code,id
		trn_gantts = plsql.select(:all,sql_proc_trn_gantt( trn_code,id))
		tmpgantt = {}
		##fprnt "line #{__LINE__} \n #{sql_proc_trn_gantt( trn_code,id)}"
		trn_gantts.each_with_index do |value,idx|
            break if idx >= 1000
		    case idx
			    when 0
			        trn_sno = plsql.select(:first,"select * from #{value[:trngantt_orgtblname]} where id = #{value[:trngantt_orgtblid]} ")
					value[:itm_name] = trn_sno[:sno]
					value[:itm_code] = "" 
				    if value[:trngantt_orgtblname] =~ /cust/
					   custtrn = plsql.select(:first,"select * from  r_#{value[:trngantt_orgtblname]} where id = #{value[:trngantt_orgtblid]}")
					   value[:loca_code] = custtrn[:loca_code_cust]
					   value[:loca_name] = custtrn[:loca_name_cust]
					end
			    else
                  ###  trn_sno = plsql.select(:first,"select * from #{value[:trngantt_tblname]} where id = #{value[:trngantt_tblid]} ")				
		    end
            tmpgantt[value[:trngantt_subkey].to_sym] = {:id=>"#{(idx += 1).to_s}",:itm_code=>"#{value[:itm_code]}",:itm_name=>"#{value[:itm_name]}",
			                                            :loca_code=>"#{value[:loca_code]}",:loca_name=>"#{value[:loca_name]}",
                                                        :qty=>"#{value[:qty]||=0}",
														:qty_sch=>"#{value[:qty_alloc_sch]||=0}",:qty_ord=>"#{value[:qty_alloc_ord]||=0}",
														:qty_inst=>"#{value[:qty_alloc_inst]||=0}",:qty_stk=>"#{value[:qty_alloc_stk]||=0}",
			                                            :start=>(value[:strdate].to_i * 1000),:org_start=>(value[:org_strdate].to_i * 1000),
														:opeitm_duration=>"#{value[:opeitm_duration]}",
                                                        :end=>(value[:duedate].to_i * 1000),:org_end=>(value[:org_duedate].to_i * 1000),"assigs"=>[],
														:level=>if value[:trngantt_subkey] == '000' then 0 else 1 end,
														:mlevel=>value[:mlevel],:subtblid=>"",:paretblcode=>"",:depends=>""}
            if value[:trngantt_subkey].size > 5 
			    tmpgantt[value[:trngantt_subkey][0..-4].to_sym][:depends] <<   "#{tmpgantt[value[:trngantt_subkey].to_sym][:id]},"  if tmpgantt[value[:trngantt_subkey][0..-4].to_sym]
			  else
			    tmpgantt[:"001"][:depends] <<   "#{tmpgantt[value[:trngantt_subkey].to_sym][:id]}," if value[:trngantt_subkey].to_s > "001"
			end
		end	
        strgantt = '{"tasks":['
        tmpgantt.sort.each  do|key,value|
            strgantt << %Q&{"id":"#{value[:id]}","itm_code":"#{value[:itm_code]}","itm_name":"#{value[:itm_name]}","loca_code":"#{value[:loca_code]}","loca_name":"#{value[:loca_name]}",
            "start":#{value[:start]},"org_start":#{value[:start]},"end":#{value[:end]||=value[:org_end]},"org_end":#{value[:org_end]},
			"qty":#{value[:qty]},"qty_sch":#{value[:qty_sch]},"qty_ord":#{value[:qty_ord]},"qty_inst":#{value[:qty_inst]},"qty_stk":#{value[:qty_stk]},
			"assigs":[],"level":#{value[:level]},"mlevel":#{value[:mlevel]},"subtblid":"#{value[:subtblid]}","paretblcode":"","depends":"#{value[:depends].chop}"},&
        end
        ##fprnt("#{__LINE__} strgantt :#{strgantt}")
        @ganttdata = strgantt.chop + %Q&],"selectedRow":0,"deletedTaskIds":[],"canWrite":true,"canWriteOnParent":true }&
    end

    def set_fields_from_gantt tblcode,value ,command_r ###画面の内容をcommand_r from gantt screen     
       pare_opeitm = plsql.r_opeitms.first("where id = #{value[:paretblcode].split("_")[1].to_i}")
	   if pare_opeitm
	        if value[:itm_cod ] == pare_opeitm[:itm_code]			    ###前工程作成
               @screen_code  = jqgrid_id = "r_opeitms"
                command_r[:sio_viewname]  = command_r[:sio_code] = @screen_code
                command_r.merge!(init_from_screen(value))
                command_r[:opeitm_unit_id_lttime] = paretbl[:units_id_lttime]
			    ##command_r[:opeitm_duration] = value[:opeitm_duration]  ## init_from_screenでセットされる
                ##command_r[:loca_code] = value[:loca_code]
                ##command_r[:itm_code] = value[:itm_code]
                command_r[:opeitm_prdpurshp] = value[:opeitm_prdpurshp]
                command_r[:opeitm_priority] = pare_opeitm[:opeitm_priority]
                command_r[:opeitm_processseq] = pare_opeitm[:opeitm_processseq] - 10
                command_r[:opeitm_expiredate] = Time.parse("2099/12/31")
			  else		    
                @screen_code  = jqgrid_id = "r_nditms"
                command_r[:sio_viewname]  = command_r[:sio_code] = @screen_code
                command_r.merge!(init_from_screen(value))
                ##command_r[:nditm_parenum] = value[:nditm_parenum]
                ##command_r[:nditm_chilnum] = value[:nditm_chilnum]
                ##command_r[:loca_code] = value[:loca_code]
                command_r[:itm_code_nditm] = value[:itm_code]
                ###command_r[:loca_code_nditm] = value[:loca_code]   ===>opeitmsの作成
                command_r[:nditm_opeitm_id] = value[:paretblcode].split("_")[1].to_i 
                command_r[:nditm_expiredate] = Time.parse("2099/12/31")
			end
       end
       return command_r
   end  
   def uploadgantt
        sio_user_code = plsql.persons.first(:email =>current_user[:email])[:id]  ||= 0   ###########   LOGIN USER
		sio_session_counter =   user_seq_nextval(sio_user_code) 
		command_r = {}
        command_r[:sio_user_code] = sio_user_code
		command_r[:sio_session_counter] =   sio_session_counter
        params[:tasks].each do |key,value|
            tblcode = value[:id].split("_")[0]
            case tblcode 
                when  "000" then
                ##top record
                   next
                when "gantttmp"  then ### レコード追加
                    tblcode = value[:id].split("_")[1]
                    command_r[:sio_classname] = "plsql_blk_gantt_add_"
					sub_insert(set_fields_from_gantt tblcode,value ,command_r)
                else
          			rid = value[:id].split("_")[1].to_i 
         			if  rid.nil
		    		    fprnt "logic err line #{__LINE__} value #{value}"
			    		raise
				   end
                    command_r[:sio_classname] = "plsql_blk_gantt_edit_"
                    @screen_code  = jqgrid_id = "r_" + tblcode
                    command_r[:sio_viewname]  = command_r[:sio_code] = @screen_code
			        command_r.merge!(init_from_screen(value))
                    command_r[:id] = command_r[(tblcode.chop+"_id").to_sym] = rid					
                    sub_insert_sio_c     command_r  ##
                    if  tblcode == "nditms"
                        @screen_code  = jqgrid_id = "r_opeitms" 
               	        command_r.merge!(init_from_screen(value))
                        command_r[:id] = command_r[:opeitm_id] = value[:subtblid].split("_")[1].to_i
                        command_r[:sio_classname] = "plsql_blk_gantt_edit_"    
                        command_r[:sio_viewname]  = command_r[:sio_code] = @screen_code
                        command_r[:sio_user_code] = sio_user_code  
			            sub_insert_sio_c     command_r  
					end
            end
        end
        sub_userproc_insert command_r
        plsql.commit
        dbcud = DbCud.new
        dbcud.perform(command_r[:sio_session_counter],command_r[:sio_user_code])
        @ganttreturn = "retrurn ok"
   end
   
   def prv_resch   ##本日を起点に再計算
        dp_id = 1
        @bgantts.sort.each  do|key,value|    ###set dependon
           if key.to_s.size > 3 then
             @bgantts[key.to_s[0..-4].to_sym][:depends] << dp_id.to_s + "," 
           end
           dp_id += 1
        end

        today = Time.now
        @bgantts.sort.reverse.each  do|key,value|  ###計算
		  if key.to_s.size > 3
            if  value[:depends] == ""
		    	if @bgantts[key][:starttime]  <  today
                   @bgantts[key][:starttime]  =  today		   
                   @bgantts[key][:endtime]  =   @bgantts[key][:starttime] + value[:opeitm_duration]*24*60*60    ###稼働日考慮今なし
                end					  
			end
            if  (@bgantts[key.to_s[0..-4].to_sym][:starttime] ) < @bgantts[key][:endtime]
                 @bgantts[key.to_s[0..-4].to_sym][:starttime]  =   @bgantts[key][:endtime]   ###稼働日考慮今なし
                 @bgantts[key.to_s[0..-4].to_sym][:endtime] =  @bgantts[key.to_s[0..-4].to_sym][:starttime]  + @bgantts[key.to_s[0..-4].to_sym][:opeitm_duration] *24*60*60
				 ##p key
				 ##p @bgantts[key]
			end
          end
        end
		
        @bgantts.sort.each  do|key,value|  ###topから再計算
		  if key.to_s.size > 3
             if  (@bgantts[key.to_s[0..-4].to_sym][:starttime]  ) > @bgantts[key][:endtime]  			   
                      @bgantts[key][:endtime]  =   @bgantts[key.to_s[0..-4].to_sym][:starttime]    ###稼働日考慮今なし
                      @bgantts[key][:starttime] =  @bgantts[key][:endtime]  - value[:opeitm_duration] *24*60*60
             end					  
          end
        end
      return 
   end
end ## ganttController

