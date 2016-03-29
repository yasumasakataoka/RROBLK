# -*- coding: utf-8 -*-  
class   GanttController  <  ScreenController
###同一priorityのもののみ抽出
    before_filter :authenticate_user!  
    respond_to :html ,:xml ,:json##  将来　タイトルに変更
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
        render :json =>@ganttdata
    end
    def  proc_mst_gantt  mst_code,id
        ngantts = []  ### viewの内容なので　itm_id loca_id
        time_now =  Time.now 
		case mst_code
		    when "itms"
		     ###itm = ActiveRecord::Base.connection.select_one("select * from itms where id = '#{id}'  ")
             rec = ActiveRecord::Base.connection.select_one("select * from r_opeitms where opeitm_itm_id = #{id} and opeitm_Expiredate > current_date
																order by opeitm_priority desc, opeitm_processseq desc,opeitm_Expiredate ")
		end
        if rec then 
            ngantts << {:seq=>"001",:mlevel=>1,:itm_id=>rec["opeitm_itm_id"],:loca_id=>rec["opeitm_loca_id"],:opeitms_id=>rec["id"],
								:itm_code=>rec["itm_code"],:itm_name=>rec["itm_name"],
								:loca_code=>rec["loca_code"],:loca_name=>rec["loca_name"],
								:parenum=>1,:chilnum=>1,:duration=>rec["opeitm_duration"],
								:processseq=>rec["opeitm_processseq"],:priority=>rec["opeitm_priority"],:endtime=>time_now,:id=>"opeitms_"+rec["id"].to_s}
            cnt = 0
            @bgantts = {}
            @bgantts["000"] = {:mlevel=>0,:itm_code=>"",:itm_name=>"全行程",:loca_code=>"",:loca_name=>"",:duration=>"",:assigs=>"",:endtime=>time_now,:starttime=>nil,:depends=>"",:id=>"000"}
            until ngantts.size == 0
               cnt += 1
               ngantts = proc_get_tree_itms_locas ngantts
               break if cnt >= 1000
            end
          else
            return ""
        end
        @bgantts["000"][:starttime] = Time.now
        prv_resch  ####再計算
        @bgantts["000"][:endtime] = @bgantts["001"][:endtime] 
        @bgantts["000"][:duration] = " #{(@bgantts["000"][:endtime]  - @bgantts["000"][:starttime] ).divmod(24*60*60)[0]}"
        strgantt = '{"tasks":['
        @bgantts.sort.each  do|key,value|
            strgantt << %Q&{"id":"#{value[:id]}","itm_code":"#{value[:itm_code]}","itm_name":"#{value[:itm_name]}",
			"loca_code":"#{value[:loca_code]}","loca_name":"#{value[:loca_name]}",
			"loca_id":"#{value[:loca_id]}","itm_id":"#{value[:itm_id]}",
            "parenum":"#{value[:parenum]}","chilnum":"#{value[:chilnum]}","start":#{value[:starttime].to_i.*1000},"duration":"#{value[:duration]}",
            "end":#{value[:endtime].to_i.*1000},"assigs":[],"depends":"#{value[:depends]}",
			"processseq":"#{value[:processseq]}","priority":"#{value[:priority]}","prdpurshp":"#{value[:prdpurshp]}",
			"level":#{if value[:mlevel] == 0 then 0 else 1 end},"mlevel":#{value[:mlevel]},"subtblid":"#{value[:subtblid]}","paretblcode":""},&
        end
        ## opeitmのsubtblidのopeitmは子のinsert用
        @ganttdata = strgantt.chop + %Q|],"selectedRow":0,"deletedTaskIds":[],"canWrite":true,"canWriteOnParent":true }|
    end  
	def sql_proc_trn_gantt trn_code,id
	    ### a.trngantt 引当て先　　b.trngantt オリジナル
        %Q& select a.trngantt_key,a.ITM_CODE,a.ITM_NAME,a.LOCA_CODE,a.loca_name,a.opeitm_prdpurshp prdpurshp,
                            alloctbl_destblname,alloctbl_destblid,max(trngantt_dependon) trngantt_dependon,
							itm_id,loca_id,
							min(a.TRNGANTT_STRDATE) org_strdate,max(a.TRNGANTT_MLEVEL) mlevel,
							max(a.TRNGANTT_dueDATE) org_duedate,max(a.trngantt_qty) qty,
							sum(case  when b.alloctbl_destblname like '%schs' then  b.alloctbl_qty else 0 end) qty_alloc_sch,
							sum(case  when b.alloctbl_destblname like '%ords' then  b.alloctbl_qty else 0 end) qty_alloc_ord,
							sum(case  when b.alloctbl_destblname like '%insts' then  b.alloctbl_qty else 0 end) qty_alloc_inst,
							sum(case  when b.alloctbl_destblname like '%act%' then  b.alloctbl_qty 
							          when b.alloctbl_destblname like '%lotstk%' then  b.alloctbl_qty   else 0 end) qty_alloc_stk,
							a.trngantt_orgtblname,a.trngantt_orgtblid
                      from r_trngantts a 
					  left join r_alloctbls b on a.trngantt_id = b.alloctbl_srctblid and b.alloctbl_srctblname = 'trngantts' and b.alloctbl_qty > 0
					  where   a.trngantt_orgtblname = '#{trn_code}' and a.trngantt_orgtblid = #{id}  
					  group by a.trngantt_key,a.ITM_CODE,a.ITM_NAME,a.LOCA_CODE,a.loca_name,a.trngantt_orgtblname,a.trngantt_orgtblid,
								alloctbl_destblname,alloctbl_destblid,a.opeitm_prdpurshp,itm_id,loca,id
					  order by a.trngantt_key&
	end
    def  proc_trn_gantt  trn_code,id
		trn_gantts = ActiveRecord::Base.connection.select_all(sql_proc_trn_gantt( trn_code,id))
		tmpgantt = {}
		trn_gantts.each_with_index do |value,idx|
            break if idx >= 1000	
			alloc = {}
		    case value["alloctbl_destblname"]
			    when nil
			        trn_sno = ActiveRecord::Base.connection.select_one(%Q& select * from #{value["trngantt_orgtblname"]} where id = #{value["trngantt_orgtblid"]} &)
					value["itm_name"] = trn_sno["sno"]
					value["itm_code"] = "" 
				    if value["trngantt_orgtblname"] =~ /cust/
					   custtrn = ActiveRecord::Base.connection.select_one(%Q& select * from  r_#{value["trngantt_orgtblname"]} where id = #{value["trngantt_orgtblid"]}&)
					   value["loca_code"] = custtrn["loca_code_cust"]
					   value["loca_name"] = custtrn["loca_name_cust"]
					   alloc["strdate"] = alloc["depdate"] = value["org_strdate"]  ###c
					   alloc["duedate"] = custtrn["custord_duedate"]  ###c
					end
			    else
					alloc =  ActiveRecord::Base.connection.select_one(%Q& select * from #{value["alloctbl_destblname"]} where id = #{value["alloctbl_destblid"]}&)	
		    end
            tmpgantt[value["trngantt_key"].to_sym] = {:id=>(idx).to_s,:itm_code=>value["itm_code"],:itm_name=>value["itm_name"],
			                                            :loca_code=>"#{value["loca_code"]}",:loca_name=>value["loca_name"],
			                                            :loca_id=>"#{value["loca_id"]}",:itm_id=>value["itm_id"],
														:prdpurshp=>"#{value["prdpurshp"]}",:sno=>alloc["sno"],
                                                        :qty=>"#{value["qty"]||=0}",
														:qty_sch=>"#{value["qty_alloc_sch"]||=0}",:qty_ord=>"#{value["qty_alloc_ord"]||=0}",
														:qty_inst=>"#{value["qty_alloc_inst"]||=0}",:qty_stk=>"#{value["qty_alloc_stk"]||=0}",
														:start=> if value["alloctbl_destblname"] =~ /^shp/ then(alloc["depdate"].to_i * 1000) else (alloc["strdate"].to_i * 1000) end,
														:org_start=>(value["org_strdate"].to_i * 1000),
														:duration=>value["duration"],
                                                        :end=>if value["alloctbl_destblname"] =~ /^lotstk/ then (alloc["strdate"].to_i * 1000) else (alloc["duedate"].to_i * 1000 )end,:org_end=>(value["org_duedate"].to_i * 1000),"assigs"=>[],
														:level=>if value["trngantt_key"] == '000' then 0 else 1 end,
														:mlevel=>value["mlevel"],:subtblid=>"",:paretblcode=>"",:depends=>value["trngantt_dependon"]}
							
            #if value["trngantt_key"].size > 3
			 #   tmpgantt[value["trngantt_key"][0..-4].to_sym][:depends] <<   "#{tmpgantt[value["trngantt_key"].to_sym][:id]},"  
			 # else
			 #   tmpgantt[:"001"][:depends] <<   "#{tmpgantt[value["trngantt_key"].to_sym][:id]}," if value["trngantt_key"] > "001"
			#end
		end		
        strgantt = '{"tasks":['
        tmpgantt.sort.each  do|key,gantt|
            strgantt << %Q&{"id":"#{gantt[:id]}","itm_code":"#{gantt[:itm_code]}","itm_name":"#{gantt[:itm_name]}",
			"loca_code":"#{gantt[:loca_code]}","loca_name":"#{gantt[:loca_name]}",
			"loca_id":"#{gantt[:loca_id]}","itm_id":"#{gantt[:itm_id]}",
            "start":#{gantt[:start]},"org_start":#{gantt[:start]},"end":#{gantt[:end]||=gantt[:org_end]},"org_end":#{gantt[:org_end]},			
			"prdpurshp":"#{gantt[:prdpurshp]}","sno":"#{gantt[:sno]}",
			"qty":#{gantt[:qty]},"qty_sch":#{gantt[:qty_sch]},"qty_ord":#{gantt[:qty_ord]},"qty_inst":#{gantt[:qty_inst]},"qty_stk":#{gantt[:qty_stk]},
			"assigs":[],"level":#{gantt[:level]},"mlevel":#{gantt[:mlevel]},"subtblid":"#{gantt[:subtblid]}","paretblcode":"","depends":"#{(gantt[:depends]||="").chop}"},&
        end
        @ganttdata = strgantt.chop + %Q&],"selectedRow":0,"deletedTaskIds":[],"canWrite":true,"canWriteOnParent":true }&
    end
	###
	###upload
	###
	def update_opeitm_from_gantt(copy_opeitm,value ,command_r)
		if copy_opeitm
			copy_opeitm.each do |k,v|
				command_r["#{k}".to_sym] = v if k =~ /^opeitm_/
			end
		end
		command_r[:opeitm_itm_id] = value[:itm_id]
		command_r[:opeitm_loca_id] = value[:loca_id]
		command_r[:sio_viewname]  = command_r[:sio_code] = @screen_code = "r_opeitms"
		command_r[:opeitm_priority] = value[:priority]
		command_r[:opeitm_processseq] = value[:processseq] 
		command_r[:opeitm_prdpurshp] = value[:prdpurshp]
		command_r[:opeitm_parenum] = value[:parenum]
		command_r[:opeitm_chilnum] = value[:chilnum]
		command_r[:opeitm_duration] = value[:duration]
		command_r[:opeitm_person_id_upd] = command_r[:sio_user_code] 
        command_r[:opeitm_expiredate] = Time.parse("2099/12/31")
		yield
		proc_simple_sio_insert command_r  ###重複チェックは　params[:tasks][@tree[key]][:processseq] > value[:processseq]　が確定済なので不要
	end
	def update_nditm_from_gantt(key,value ,command_r)
		strsql = "select id from opeitms where itms_id = #{params[:tasks][@tree[key]][:itm_id]} and locas_id = #{params[:tasks][@tree[key]][:loca_id]} and 
					processseq = #{params[:tasks][@tree[key]][:processseq]} and priority = #{params[:tasks][@tree[key]][:priority]}"
		pare_opeitm_id = ActiveRecord::Base.connection.select_value(strsql)
		if pare_opeitm_id
			###削除されてないか、再度確認
			##pare_opeitm_id = ActiveRecord::Base.connection.select_value("select id from opeitms where id = #{pare_opeitm_id} ")
			##if pare_opeitm_id
			yield
			update_nditm_rec(pare_opeitm_id,value ,command_r)
			##else
			##	@ganttdata[key]  = {:itm_name=>"opeitm not exists line #{__LINE__} ,opeitm_id = #{pare_opeitm_id} "}
			##end
		else
			@ganttdata[key][:itm_name] = @err = "opeitm is null line #{__LINE__} ,opeitm_id = #{pare_opeitm_id} "
		end
	end
	def chk_alreadt_exists_nditm(command_r)
		strsql = "select 1 from nditms where  opeitms_id = #{command_r[:nditm_opeitm_id]} and  itm_id_nditm = #{command_r[:nditm_itm_id_nditm]} and
					processseq_nditm = #{command_r[:nditm_processseq_nditm]} and   locas_id_nditm  = #{command_r[:nditm_loca_id_nditm]} " 
		if ActiveRecord::Base.connection.select_one (strsql)
			@ganttdata[key][:itm_name] = @err = " ??? !!! already exists !!!"
		end
	end
	def update_nditm_rec(pare_opeitm_id,value ,command_r)
		command_r[:sio_viewname]  = command_r[:sio_code] = @screen_code = "r_nditms"
		if value[:itm_id]
			command_r[:nditm_itm_id_nditm] = value[:itm_id]              
			command_r[:nditm_opeitm_id] = pare_opeitm_id  
			if value[:loca_id]
				command_r[:nditm_loca_id_nditm] = value[:loca_id]  
				command_r[:nditm_processseq_nditm] = value[:processseq]
				command_r[:nditm_expiredate] = Time.parse("2099/12/31")
				command_r[:nditm_parenum] = value[:parenum]
				command_r[:nditm_chilnum] = value[:chilnum]
				command_r[:nditm_duration] = value[:duration]
				command_r[:nditm_person_id_upd] = command_r[:sio_user_code] 
				command_r[:nditm_expiredate] = Time.parse("2099/12/31")
				chk_alreadt_exists_nditm(command_r) if command_r[:sio_classname] =~ /_add_/
				proc_simple_sio_insert command_r  if @err == "no"					
			else
				@ganttdata[key][:loca_code] =  @err = "???"
			end
		else
			@ganttdata[key][:itm_code] = @err = "???" 
		end
	end
    def exits_opeitm_from_gantt(key,value ,command_r) ###画面の内容をcommand_r from gantt screen
		###itm_codeでユニークにならない時内容が保証されない。  processseq,priorityは必須
		strsql = "select * from r_opeitms where itm_code = '#{value["copy_itemcode"]}' and opeitm_processseq = 999 and opeitm_priority = 999 "
		copy_opeitm = ActiveRecord::Base.connection.select_one(strsql)
		if value[:opeitms_id]
			opeitm = ActiveRecord::Base.connection.select_one("select * from opeitms where id = #{value[:opeitms_id]} ")
			if opeitm
				if opeitm["itms_id"] == value[:itm_id] and opeitm["processseq"] == value[:processseq] and opeitm["priority"] == value[:priority] 
					update_opeitm_from_gantt(copy_opeitm,value ,command_r) do
						ommand_r_[:sio_classname] = "_edit_opeitms_rec"
						command_r[:opeitm_id] = command_r[:id] = opeitm["id"]
					end
				else
					strsql = "select * from r_opeitms where itm_code = '#{value["copy_itemcode"]}' and loca_code = '#{value["loca_code"]}' and opeitm_processseq = #{value[:processseq]} " 
					if ActiveRecord::Base.connection.select_one(strsql)
						@ganttdata[key][:priority] = "???"  ###priority違いで同じものがいる。
					else
						update_opeitm_from_gantt(copy_opeitm,value ,command_r) do
							command_r[:sio_classname] = "_edit_opeitms_rec"
							command_r[:opeitm_id] = command_r[:id] = opeitm["id"]
						end
					end
				end
			else
				@ganttdata[key][:itm_name] = @err = "logic error LINE : #{__LINE__}"  
			end
		else
			if copy_opeitm
				update_opeitm_from_gantt(copy_opeitm,value ,command_r)do
					command_r[:sio_classname] = "_add_opeitm_rec"
					command_r[:opeitm_id] = command_r[:id] = proc_get_nextval "opeitms_seq"
				end
				params[:tasks][key][:opeitms_id] = command_r[:opeitm_id]
			else
				@ganttdata[key][:copy_itemcode] = @err = "???"
			end
		end
	end
    def exits_nditm_from_gantt(key,value ,command_r) ###画面の内容をcommand_r from gantt screen
		if value[:nditms_id]
			r_nditm = ActiveRecord::Base.connection.select_one("select * from r_nditms where id = #{value[:nditms_id]} ")
			if r_nditm
				update_nditm_from_gantt(key,value ,command_r) do
					command_r[:sio_classname] = "_edit_nditm_rec"
					command_r[:nditm_id] = command_r[:id] = value[:nditms_id]
				end
			else ###
				@ganttdata[key][:itm_name] = @err = "logic error  line #{__LINE__} "
			end
		else
			update_nditm_from_gantt(key,value ,command_r) do
				command_r[:sio_classname] = "_add_nditm_rec"
				command_r[:nditm_id] = command_r[:id] = proc_get_nextval "nditms_seq"
			end
		end
	end
	
	def chk_opeitm_nditm_from_gantt(key,value ,command_r)
		if @tree[key]
			if  params[:tasks][@tree[key]][:itm_code] == value[:itm_code]
				if params[:tasks][@tree[key]][:processseq] > value[:processseq]
					if (params[:tasks][@tree[key]][:priority] > value[:priority] and params[:tasks][@tree[key]][:priority] == 999) or params[:tasks][@tree[key]][:priority] == value[:priority]
						exits_opeitm_from_gantt(key,value ,command_r)
					else ###作業の一貫性
						@ganttdata[key][:priority] = @err = "???"
					end
				else  ###seq error
					@ganttdata[key][:processseq] = @err = "???"
				end
			else   ###nditms追加
				if  value[:processseq] == "999"  ###品目違いの時はprocessseq == 999
					if (params[:tasks][@tree[key]][:priority] > value[:priority] and params[:tasks][@tree[key]][:priority] == 999) or params[:tasks][@tree[key]][:priority] == value[:priority]
						if value[:itm_id] != "" and value[:loca_id] != ""
							strsql = "select id from opeitms where itms_id = #{value[:itm_id]} and locas_id = #{value[:loca_id]} and processseq = #{value[:processseq]} and priority = #{value[:priority]} "
							ope = ActiveRecord::Base.connection.select_one(strsql)
							if ope.nil?
								strsql = "select * from r_opeitms where itm_code = '#{value["copy_itemcode"]}' and opeitm_processseq = 999 and opeitm_priority = 999 "
								copy_opeitm = ActiveRecord::Base.connection.select_one(strsql)
								if copy_opeitm
									update_opeitm_from_gantt(copy_opeitm,value ,command_r)do
										command_r[:sio_classname] = "_add_opeitm_rec"
										command_r[:opeitm_id] = command_r[:id] = proc_get_nextval "opeitms_seq"
									end
									params[:tasks][key][:opeitms_id] = command_r[:opeitm_id]
									command_r = {}
									command_r[:sio_user_code] = @sio_user_code
									command_r[:sio_session_counter] =   @sio_session_counter
									exits_nditm_from_gantt(key,value ,command_r)	
								else
									@ganttdata[key][:copy_itemcode] = @err = "???"
								end
							else
								exits_nditm_from_gantt(key,value ,command_r)
							end
						else
							@ganttdata[key][:itm_code] = @ganttdata[key][:loca_code] = @err = "???"
						end
					else ###作業の一貫性
						@ganttdata[key][:priority] = @err = "???"
					end
				else  ###seq error
					@ganttdata[key][:processseq] = @err = "???"
				end
			end
		else
			### topの時
		end
	end
	def uploadgantt   ### trnは別		
		ActiveRecord::Base.connection.begin_db_transaction()
        @sio_user_code =  ActiveRecord::Base.connection.select_value("select id from persons where email = '#{current_user[:email]}'")   ###########   LOGIN USER
		@sio_session_counter = user_seq_nextval
		@ganttdata = params[:tasks]
		@err = "no"
		@tree = {}   ###親のid
		err = false
        params[:tasks].each do |key,value|
			value[:depends].split(",").each do |i|  ###子の親は必ず1つ　副産物も子として扱う
				@tree[i] = key 
			end
			command_r = {}
			command_r[:sio_user_code] = @sio_user_code
			command_r[:sio_session_counter] =   @sio_session_counter
			case value[:id] 
                when  "000" then
                ##top record
                   next
                when /gantttmp/  then ### レコード追加
					if value[:itm_id] and  value[:processseq] =~ /[000-999]/ and value[:priority] =~ /[000-999]/   
						chk_opeitm_nditm_from_gantt(key,value ,command_r)
					else
						if value[:itm_id].nil? then @ganttdata[key][:itm_code] = @err= "???" end
						if value[:processseq] !~ /[000-999]/  then @ganttdata[key][:processseq] = @err = "???"  end
						if value[:priority] !~ /[000-999]/ then @ganttdata[key][:priority] = @err = "???" end
					end
                when /opeitms/   ###追加更新もある?\
					params[:tasks][key][:opeitms_id] = value[:id].split("_")[1].to_i   
					chk_opeitm_nditm_from_gantt(key,value ,command_r)
				when /nditms/
					params[:tasks][key][:nditms_id] = value[:id].split("_")[1].to_i   
					chk_opeitm_nditm_from_gantt(key,value ,command_r)  ### 子品目から前工程に変更されることもある。
				else
				    logger.debug "#{Time.now} #{__LINE__} new option????? not support   value #{value}"
            end
        end
		###画面のラインを削除された時	
		if @err == "no"
			ActiveRecord::Base.connection.commit_db_transaction()
			render :json=>'{"result":"ok"}'
		else
			## logger.debug  "#{Time.now} #{__LINE__} :#{@ganttdata} "
			ActiveRecord::Base.connection.rollback_db_transaction()
			strgantt = '{"tasks":['
			@ganttdata.each  do|key,value|
				strgantt << %Q&{"id":"#{value[:id]}","itm_code":"#{value[:itm_code]}","itm_name":"#{value[:itm_name]}",
				"loca_code":"#{value[:loca_code]}","loca_name":"#{value[:loca_name]}",
				"loca_id":"#{value[:loca_id]}","itm_id":"#{value[:itm_id]}",
				"parenum":"#{value[:parenum]}","chilnum":"#{value[:chilnum]}","start":#{value[:start]},"duration":"#{value[:duration]}",
				"end":#{value[:end]},"assigs":[],"depends":"#{value[:depends]}",
				"processseq":"#{value[:processseq]}","priority":"#{value[:priority]}","prdpurshp":"#{value[:prdpurshp]}",
				"level":#{if value[:mlevel] == 0 then 0 else 1 end},"mlevel":#{value[:mlevel]},"subtblid":"#{value[:subtblid]}","paretblcode":""},&
			end
        ## opeitmのsubtblidのopeitmは子のinsert用
			@ganttdata = strgantt.chop + %Q|],"selectedRow":11,"deletedTaskIds":[],"canWrite":true,"canWriteOnParent":true }|
			####@ganttdata= %Q%["aaa":"bbb"}%
			render :json=>@ganttdata
		end
	end   
	def prv_resch   ##本日を起点に再計算
        dp_id = 0
        @bgantts.sort.each  do|key,value|    ###set dependon
           if key.to_s.size > 3 then
             @bgantts[key.to_s[0..-4]][:depends] << dp_id.to_s + "," 
           end
           dp_id += 1
        end

        today = Time.now
        @bgantts.sort.reverse.each  do|key,value|  ###計算
		  if key.to_s.size > 3
            if  value[:depends] == ""
		    	if @bgantts[key][:starttime]  <  today
                   @bgantts[key][:starttime]  =  today		   
                   @bgantts[key][:endtime]  =   @bgantts[key][:starttime] + value[:duration]*24*60*60    ###稼働日考慮今なし
                end					  
			end
            if  (@bgantts[key.to_s[0..-4]][:starttime] ) < @bgantts[key][:endtime]
                 @bgantts[key.to_s[0..-4]][:starttime]  =   @bgantts[key][:endtime]   ###稼働日考慮今なし
                 @bgantts[key.to_s[0..-4]][:endtime] =  @bgantts[key.to_s[0..-4]][:starttime]  + @bgantts[key.to_s[0..-4]][:duration] *24*60*60
				 ##p key
				 ##p @bgantts[key]
			end
          end
        end
		
        @bgantts.sort.each  do|key,value|  ###topから再計算
		  if key.to_s.size > 3
             if  (@bgantts[key.to_s[0..-4]][:starttime]  ) > @bgantts[key][:endtime]  			   
                      @bgantts[key][:endtime]  =   @bgantts[key.to_s[0..-4]][:starttime]    ###稼働日考慮今なし
                      @bgantts[key][:starttime] =  @bgantts[key][:endtime]  - value[:duration] *24*60*60
             end					  
          end
        end
      return 
   end
end ## ganttController

