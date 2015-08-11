class DbCud  < ActionController::Base
 ## @queue = :default
 ## def self.perform(sio_id,sio_view_name)
 ##　importと 画面でエラー検出すること。
			### とりあえず
## ダイナミックに　モデルを変更　	ctblname = tbl.chop.capitalize.constantize
    def perform(sio_session_counter,sio_user_id,one_by_one)
      begin	
	    @sio_user_code = sio_user_id
        ###plsql.execute "SAVEPOINT before_perform"
        plsql.connection.autocommit = false
        crt_def_all  unless respond_to?("dummy_def")
	    @new_sio_session_counter  = user_seq_nextval
        @pare_class = "batch"
        tg_tbls = ActiveRecord::Base.connection.select_all("select * from userproc#{@sio_user_code.to_s}s where session_counter = #{sio_session_counter}")
		tg_tbls.each do |tg_tbl|   ###複数のテーブルを同一セッションで処理
		    ### sio_session_counter --> session group id   sio_session_id-->group 内　id
            command_cs = ActiveRecord::Base.connection.select_all(sql_perform(tg_tbl["tblname"],sio_session_counter))
            r_cnt0 = tg_tbl["cnt_out"]||=0
			if command_cs[0]
				tblname = command_cs[0]["sio_viewname"].split("_",2)[1] 
				command_cs.each do |i|  ##テーブル、画面の追加処理  #複数のレコードを処理
					r_cnt0 += 1
					@sio_classname = i["sio_classname"]
					proc_update_table "rec",i,r_cnt0 ### 本体
					reset_show_data_screen if tblname =~ /screen|pobjgrps/   ###キャッシュを削除
					##
					strsql = " update userproc#{@sio_user_code.to_s}s set cnt_out = #{r_cnt0},status = 'normal end' ,updated_at = current_date
				           where session_counter = #{sio_session_counter} and tblname = '#{tg_tbl[:tblname]}' "
					ActiveRecord::Base.connection.execute(strsql)
					plsql.commit if one_by_one == "one_by_one"
				end
			else
				fprnt " Queue data nothing sio_session_counter = #{sio_session_counter},sio_user_id = #{sio_user_id}"
		    end
		end								
        plsql.commit
        plsql.connection.autocommit = true
	   rescue
	        if @sio_result_f !=   "9" ##想定外error
                fprnt"class #{self} :  $@: #{$@} " 
                fprnt"class #{self} :  $!: #{$!} "
			end		
      end		
    end   ##perform
      handle_asynchronously :perform
	def sql_perform  tblname,sio_session_counter
		%Q%
		select * from #{tblname} a where sio_session_counter = #{sio_session_counter} and sio_command_response = 'C' and sio_user_code = #{@sio_user_code}
		        and not exists(select 1 from #{tblname} b where  a.sio_session_counter = b.sio_session_counter  
		        and sio_command_response = 'R' and a.sio_user_code =  b.sio_user_code and a.sio_session_id = b.sio_session_id)
		%
	end
    def reset_show_data_screen
      ##cache_key =  "show" 
      ##Rails.cache.delete_matched(cache_key) ###delay_jobからcallされるので、grp_codeはbatch
	  Rails.cache.clear(nil) ###delay_jobからcallされるので、grp_codeはbatch
    end
	def proc_create_new_or_replace_alloc alloc   ###alloc 新しい引当て
		case @sio_classname
			when /_add_/
				alloc[:id] = proc_get_nextval "alloctbls_seq" 
				alloc[:created_at] = Time.now
				alloc[:updated_at] = Time.now
				alloc[:persons_id_upd] = System_person_id
				alloc[:expiredate] = "2099/12/31".to_date				
				Alloctbl.create alloc
			when /_edit_|_delete_/
				strsql = %Q& select * from alloctbls where srctblname = 'trngantts' and destblname = '#{alloc[:destblname]}' 
							and destblid = #{alloc[:destblid]} order by id desc &
				c_allocs = ActiveRecord::Base.connection.select_all(strsql)
				if c_allocs.size == 0 ##logic error
				   fprnt "strsql = #{strsql}"
				end
				qty = 0
				alloc[:qty] = 0 if @sio_classname =~ /_delete_/
				c_allocs.each do |c_alloc|
					if alloc[:qty] < qty + c_alloc["qty"]
						c_alloc["qty"] = if alloc[:qty] - qty > 0 then alloc[:qty] - qty  else 0 end
						Alloctbl.update(c_alloc["id"],:qty=>c_alloc["qty"])
						proc_return_alloc c_alloc
					end
					qty += c_alloc["qty"]
				end 
				if alloc[:qty] > qty  ###数量増された時
					strsql = %Q& select alloctbls.id id from trngantts,alloctbls where trngantts.orgtblname = '#{alloc[:destblname]}' 
									and trngantts.orgtblid = #{alloc[:destblid]} and trngantts.key = '001'
									and alloctbls.srctblname = 'trngantts' and trngantts.id = alloctbls.srctblid 
									and alloctbls.destblname = '#{alloc[:destblname]}' and alloctbls.destblid = #{alloc[:destblid]}  &
					free_alloc = ActiveRecord::Base.connection.select_one(strsql)
					Alloctbl.update(free_alloc["id"],:qty=>alloc[:qty] - qty)
				end
		end
		return alloc[:id]
	end
	 
	def proc_return_alloc c_alloc   ### 数量が減って前の状態のテーブルの引当て数を戻す。
		pre_destblname = case c_alloc["destblname"]
							when /ords/
								c_alloc["destblname"].sub("ords","schs")
							when /insts/
								c_alloc["destblname"].sub("insts","ords")
							when /acts/
								c_alloc["destblname"].sub("acts","insts")
							when /lotstkhists/
								c_alloc["destblname"].sub("acts","insts")
						end
		strsql = %Q&  select * from alloctbls where srctblname = '#{c_alloc["destblname"]}' and srctblid = #{c_alloc["destblid"]} and qty > 0
												and destblname = 'alloctbls'　
												and destblid in (select id from alloctbls where srctblname = 'trngantts' and srctblid = #{c_alloc["srctblid"]}
																							and destblname ='#{pre_destblname}')&
		rtn_alloc = ActiveRecord::Base.connection.select_one(strsql)
		if rtn_alloc["qty"].nil?
		   fprnt " logic error"
           fprnt " strsql = #{strsql}"		   
		end
		Alloctbl.update(rtn_alloc["destblid"],:qty=>rtn_alloc["qty"] - c_alloc["qty"])
		Alloctbl.update(rtn_alloc["id"],:qty=>c_alloc["qty"])
	end
end
class DbSchs  < DbCud    ###
    def perform_mkschs recs
		begin
			@sio_user_code = 0
			ActiveRecord::Base.connection.begin_db_transaction()
			##plsql.connection.autocommit = false
			@new_sio_session_counter  = user_seq_nextval
			@pare_class = "batch"
			cnt = 0
			tbl= {}
			tbl[:result_f] = "1"  ## normal end
			tbl[:cmpldate] = Time.now
			tbl[:updated_at] = Time.now
			recs.each do |rec|
				case rec["sio_classname"]
					when /_edit_/
						@sio_classname = "perform_mksch_edit_"				
						proc_edit_from_trngantts(rec)
					when /_delete_/
						@sio_classname = "perform_mksch_delete_"				
						proc_edit_from_trngantts(rec)
					when /_add_/
					@sio_classname = "perform_mksch_add_"				
					proc_add_trngantts(rec)
				end
				tbl[:where] = {:id =>rec["id"]}
				plsql.mkschs.update tbl   ###insertはtblinks updateはここ　何とかならないか
			end
			dbcud = DbCud.new
			dbcud.perform(@new_sio_session_counter ,@sio_user_code,"") 
			###plsql.commit
			###plsql.connection.autocommit = true
			ActiveRecord::Base.connection.commit_db_transaction()
		rescue
		        ###plsql.rollback
				ActiveRecord::Base.connection.rollback_db_transaction()
                fprnt"class #{self}   $@: #{$@} " 
                fprnt"class #{self}   $!: #{$!} " 		
		        rec[:result_f] = "9"  ## error
		        rec[:message_code] = $!.to_s[0..255]
		        rec[:message_contents] = $@.to_s[0..3999]
		        rec[:updated_at] = Time.now
		        rec[:where] = {:id =>rec[:id]}
		        plsql.mkschs.update tbl
		        ###plsql.commit
		end
    end
    handle_asynchronously :perform_mkschs
	def proc_update_trangantts_schs(id,trngantt,opeitms_id)
		opeitm = ActiveRecord::Base.connection.select_one(%Q& select * from opeitms where id = #{opeitms_id} &)
		trngantt[:strdate] =  trngantt[:duedate] - (opeitm["duration"]||=0)  ###稼働日考慮に  ###starttimeと合わすこと。
		Trngantt.update(id,trngantt)
		ctblanme = (opeitm["prdpurshp"]+"schs").singularize.capitalize.constantize
		strsql = %Q& qty = #{trngantt[:qty]} ,duedate = to_date('#{trngantt[:duedate].strftime("%Y/%m/%d/ %H:%M")}','yyyy/mm/dd hh24:mi') ,&
		strsql << if opeitm["prdpurshp"] =~ /^shp/ 
					%Q& depdate = to_date('#{trngantt[:strdate].strftime("%Y/%m/%d/ %H:%M")}','yyyy/mm/dd hh24:mi') &  
				else
					%Q& strdate = to_date('#{trngantt[:strdate].strftime("%Y/%m/%d/ %H:%M")}','yyyy/mm/dd hh24:mi') & 
				end
		ctblanme.update_all(strsql, "tblid = #{id}")
	end
	def sql_pre_chk_free_alloc(str_gantt)
		%Q&
			select 		alloc.id alloctbl_id,alloc.srctblname alloctbl_srctblname,alloc.srctblid alloctbl_srctblid,
						alloc.destblname alloctbl_destblname,alloc.destblid alloctbl_destblid,
						alloc.qty free_qty,#{@opeitm[:loca_id]} trngantt_loca_id,
						gantt.orgtblname,gantt.orgtblid,gantt.key
						from trngantts gantt,alloctbls alloc
						where alloc.srctblname = 'trngantts' and  gantt.id = alloc.srctblid and gantt.key = '001'   
						and gantt.orgtblname = alloc.destblname and gantt.orgtblid = alloc.destblid
						and alloc.qty > 0 and gantt.orgtblname not like 'cust%'
						and alloc.allocfree = 'free'
						and gantt.opeitms_id = #{str_gantt["trngantt_opeitm_id"]}
						and gantt.prjnos_id = #{str_gantt["trngantt_prjno_id"]}
		&
	end
	def vproc_pre_chk_free_alloc str_gantt   ###shuffleは在庫になった時行う。 ここは新規のprdpurshpの処理		 
		free_tbls = ActiveRecord::Base.connection.select_all(sql_pre_chk_free_alloc(str_gantt))
		org_qty = str_gantt["trngantt_qty"]
		free_tbls.each do |free_tbl|		
			break if str_gantt["trngantt_qty"] <= 0
			strsql = "select * from r_#{free_tbl["alloctbl_destblname"]} where id = #{free_tbl["alloctbl_destblid"]}"  ####xxx
			tmp = ActiveRecord::Base.connection.select_one(strsql)
			destbl = {}
			if  free_tbl["trngantt_loca_id"] == tmp["opeitm_loca_id"]			
				destbl[:srctblname] = "trngantts"
				destbl[:srctblid] = str_gantt["trngantt_id"]
				destbl[:destblname] = free_tbl["alloctbl_destblname"]
				destbl[:destblid] = free_tbl["alloctbl_destblid"]
				if free_tbl["free_qty"] > str_gantt["trngantt_qty"] 
					destbl["qty"] = str_gantt["trngantt_qty"]
					free_tbl["free_qty"] -= str_gantt["trngantt_qty"]
					str_gantt["trngantt_qty"] = 0
				else
					str_gantt["trngntt_qty"] -= free_tbl["free_qty"]
					destbl["qty"] = free_tbl["free_qty"]
					free_tbl["free_qty"] = 0
				end	
				destbl[:updated_at] = Time.now
				Alloctbl.update(free_tbl["alloctbl_id"],:qty=>free_tbl["free_qty"])				
				destbl[:id] = proc_get_nextval(alloctbls_seq) 
				destbl[:created_at] = Time.now
				###Alloctbl.create destbl			
				##destbl[:id] = proc_get_nextval(alloctbls_seq) 
				destbl[:srctblid] = free_tbl["alloctbl_srctblid"]
				destbl[:destblname] = "trngantts"
				destbl[:destblid] = str_gantt["trngantt_id"]
				destbl[:allocfee] = "other"
				destbl[:persons_id_upd] = System_person_id
				destbl[:expiredate] = "2099/12/31".to_date
				Alloctbl.create destbl			
			else ###出庫予定
			end
			if org_qty  > str_gantt["trngantt_qty"]
				@chng_qty_arrys = []
				@chng_qty_arrys << {:id=>free_tbl["alloctbl_srctblid"],:qty=>str_gantt["trngantt_qty"],
									:orgtblname =>str_gantt["orgtblname"],:orgtblid => str_gantt["trngantt_orgtblid"],
									:key=>str_gantt["trngantt_key"]} 
				until  @chng_qty_arrys.size == 0
					chng_qty_arry = @chng_qty_arrys.shift
					vproc_chg_chil_item_free_to_alloc chng_qty_arry
				end
			end
		end
		return str_gantt["trngantt_qty"]  ###
	end
	def vproc_chg_chil_item_free_to_alloc chng_qty_arry
		strsql = %Q& select chil_alloc.id alloc_id,free_chil.id chil_id,chil.opeitms_id opeitms_id,
					free_chil.parenum parenum,free_chil.chilnum chilnum,
					free_chil.orgtblname chil_orgtblname,free_chil.orgtblid chil_orgtblid,
					free_chil.key chil_key,
					chil_alloc.qty alloc_qty,chil_alloc.destblname alloc_destblname,chil_alloc.destblid alloc_destblid
					from trngantts free_pare,trngantts free_chil,alloctbls chil_alloc
					where free_pare.id = #{chng_qty_arry[:id]}
					and free_pare.orgtblname = free_chil.orgtblname and free_pare.orgtblid = free_chil.orgtblid
					and free_pare.key = substr(free_chil.key,1,length(free_pare.key))
					and length(free_pare.key) = (length(free_chil.key) -3)
					and chil_alloc.srctblname = 'trngantts' and  chil_alloc.srctblid = free_chil.id
					order by free_chil.id,chil_alloc.id
				&
		chil_trns = ActiveRecord::Base.connection.select_all(strsql)
		save_chil_id = -1
		arry_allocs = []
		chil_trns.each do |chil_trn|
			if save_chil_id != chil_trn["chil_id"]
				chng_qty = chng_qty_arry[:qty] * chil_trn["parenum"] / chil_trn["chilnum"]
				@chng_qty_arrys << {:id=>chil_trn["chil_id"],:qty=>chng_qty,
									:orgtblname =>chil_trn["chil_orgtblname"],:orgtblid => chil_trn["chil_orgtblid"],
									:key=>chil_trn["chil_key"]} 
			end			
			if chng_qty > chil_trn["alloc_qty"]
				chng_qty  -= chil_trn["alloc_qty"]
			else
				vproc_alloc_gantt(chng_qty_arry,chil_trn,chng_qty)   ### alloctbl srctbl-->free_trn;destbl-->alloc_trn 
				Alloctbl.update(chil_trn[:alloc_id],:qty=>chng_qty)
				chng_qty = 0
			end
			save_chil_id = chil_trn["chil_id"]
		end
	end
	def vproc_alloc_gantt chng_qty_arry,chil_trn,new_qty
		strsql = %Q& select gantt.id gantt_id,gantt.qty qty,alloc.qty alloc_qty
					from trngantts gantt left outer join  alloctbls alloc
					on alloc.srctblname = 'trngantts' and gantt.id = alloc.srctblid
					where gantt.orgtblname = '#{chng_qty_arry["orgtblname"]}'  
					and   gantt.orgtblid = '#{chng_qty_arry["orgtblid"]}'
					and   gantt.key = '#{chng_qty_arry["key"]}' 
					and   gantt.opeitms_id = #{chil_trn["opeitms_id"]}
				&
		tg_gantts = ActiveRecord::Base.connection.select_all(strsql)
		alloc = []
		alloc[:srctblname] = "trngantts"
		alloc[:destblname] = "trngantts"
		qty = 0
		tg_gantts.each do |tg_gantt|
			if  (tg_gantt["alloc_qty"]||= 0) > 0
				qty = if qty == 0 then tg_gantt["qty"] - tg_gantt["alloc_qty"] else  qty - tg_gantt["alloc_qty"]	end
			else
				if  tg_gantt["qty"] >=  qty and qty > 0
					alloc[:qty] = qty
					alloc[:srctblid] = chil_trn["id"]	
					alloc[:destblid] = tg_gantt["gantt_id"]
					alloc[:allocfree] = "alloc" 
					alloc[:id] = proc_get_nextval "alloctbls_seq" 
					alloc[:created_at] = Time.now
					alloc[:updated_at] = Time.now
					alloc[:persons_id_upd] = System_person_id
					alloc[:expiredate] = "2099/12/31".to_date
					Alloctbl.create alloc  ##今の引当てを新しいtrnganttに引き継ぐ
					alloc[:srctblid] = tg_gantt["gantt_id"]
					alloc[:id] = proc_get_nextval "alloctbls_seq" 
					alloc[:destblname] = chil_trn["alloc_destblname"]
					alloc[:destblid] = chil_trn["alloc_destblid"]
					Alloctbl.create alloc   ##新しいｔｒｎｇａｎｔｔに引当てをセットする。
					qty = 0
				else
					fprnt "logic error  line #{__LINE__} "
					fprnt "str_gantt \n#{str_gantt}"
					fprnt "chil_trn \n #{chil_trn}"
					fprnt "strsql \n#{strsql}"
					raise
				end
			end
		end
	end
	def sql_alloc_search rec,sch_ord_inst_act
		org_strwhere = ""
		trn_strwhere = ""
		### orgtblnameの存在チェックを画面でする。 trnganttsのorgtblnameにあること。
		gantt_show_data = get_show_data "r_trngantts"   if rec["orgtblname"]
		trn_show_data = get_show_data "r_#{rec["prdpurshp"]+sch_ord_inst_act}" 
		org_search_key = {}
		trn_search_key = {}
		org_id_key = ""
		trn_id_key = ""
		rec.each do |key,val|
   		    next if val.nil?
   		    next if key !~ /_org$/ and key !~ /_trn$/
			next if rec["orgtblname"].nil? and key =~ /org$/
			### next if rec["prdpurshp"].nil? and key =~ /trn$/   #rec["prdpurshp"]は必須			
			tblname,idfield,delm = key.sub(/_org$|_trn$/,"").split("_",3)
			if delm.nil? then delm = ""  else delm = "_"+delm end
			if  idfield == "id"	
				code_val = proc_get_viewrec_from_id(tblname,val)[tblname.chop+"_code"+delm]
				next if code_val == "dummy" or code_val.nil?
				nkey = key.sub("s_id","_id").sub(/_org$|_trn$/,"")
			else
				nkey = key.sub(/_org$|_trn$/,"")
			end
			viewname = (if rec["orgtblname"] then "r_#{rec["orgtblname"]}" 
						else
							if  rec["prdpurshp"] then "r_#{rec["prdpurshp"]+sch_ord_inst_act}"
							else
								fprnt "LINE #{__LINE__} viewname is nil  prdpurshpは必須 " 
							end
						end)
			field = ActiveRecord::Base.connection.select_one(%Q&select * from r_screenfields where pobject_code_view = '#{viewname}' 
																and pobject_code_sfd = '#{nkey}'&)
			if field.nil?  and key =~ /s_id/
				tmpkey = nkey.sub("_id","_code")
				field = ActiveRecord::Base.connection.select_one(%Q&select * from r_screenfields where pobject_code_view = '#{viewname}' 
																	and pobject_code_sfd = '#{tmpkey}'&)
				nkey = tmpkey if field
			end
			if field.nil? 
				nkey = viewname.split("_",2)[1].chop+ "_" + nkey
				field = ActiveRecord::Base.connection.select_one(%Q&select * from r_screenfields where pobject_code_view = '#{viewname}' 
																	and pobject_code_sfd = '#{nkey}'&)
				if  field.nil? and nkey =~ /_id/
					nkey = nkey.sub("_id","_code")
					field = ActiveRecord::Base.connection.select_one(%Q&select * from r_screenfields where pobject_code_view = '#{viewname}' 
																	and pobject_code_sfd = '#{nkey}'&)
				end
			end
			if field
				if nkey =~ /_id/
					if key  =~ /org$/
						org_id_key << " #{nkey} = #{val}    and"
					else
						trn_id_key << " #{nkey} = #{val}    and"
					end
				else
					if key  =~ /org$/
						org_search_key[nkey.to_sym] = val
					else
						if key =~ /_id/ and nkey =~ /_code/
							trn_search_key[nkey.to_sym] = code_val
						else
							trn_search_key[nkey.to_sym] = val
						end
					end
				end
			end
		end
		if org_search_key.size >=1 or org_id_key.size > 1
    		org_strwhere = %Q& and alloctbl_srctblid in (select id from r_trngantts 
							where trngantt_orgtblname = '#{rec["orgtblname"]}'    
							and  orgtblid in (select id from   #{rec["orgtblname"]} where 
							#{org_id_key[0..-4]}
							#{proc_search_key_strwhere(org_search_key,org_strwhere,gantt_show_data )}
							) &
		end
		if trn_search_key.size >=1 or trn_id_key.size > 1
    		trn_strwhere = 	%Q&  and alloctbl_destblid in (select id from r_#{rec["prdpurshp"]+sch_ord_inst_act} where
								#{trn_id_key[0..-4]}
								#{proc_search_key_strwhere(trn_search_key,trn_strwhere,trn_show_data)}
								 ) &
		end
		%Q&
			select trngantt_id,trngantt_strdate,trngantt.opeitm_loca_id trngantt_loca_id,trngantt.opeitm_itm_id trngantt_itm_id,
			trngantt.opeitm_prdpurshp opeitm_prdpurshp,trngantt.opeitm_processseq,
			alloctbl_id,alloctbl_srctblname,alloctbl_srctblid,alloctbl_destblname,alloctbl_destblid,alloctbl_qty,alloctbl_id,trn.* 
		    from r_trngantts trngantt ,r_#{rec["prdpurshp"]+sch_ord_inst_act} trn ,r_alloctbls
		    where  alloctbl_srctblname = 'trngantts' and trngantt_id = alloctbl_srctblid
			and alloctbl_qty > 0 and alloctbl_destblname = '#{rec["prdpurshp"]+sch_ord_inst_act}' and alloctbl_destblid = trn.id
		    #{org_strwhere}
		    #{trn_strwhere}
			#{if sch_ord_inst_act == "acts"
				"order by trn.id"
		 	  else
			  	"order by trngantt.itm_code,trngantt.opeitm_loca_id,
				trn.#{rec["prdpurshp"]+sch_ord_inst_act.chop}_loca_id_to,trngantt.opeitm_processseq,
				trn.#{rec["prdpurshp"]+sch_ord_inst_act.chop}_opeitm_id,trngantt.trngantt_strdate"
			  end}
		&
	end
	###schからord  ordからinst・・・・に変わった時   proc_tblink から呼ばれる
end
class DbOrds  < DbSchs
    def perform_mkords recs
	  begin
	    @sio_user_code = 0
        plsql.connection.autocommit = false
	    @new_sio_session_counter  = user_seq_nextval
        @pare_class = "batch"
		@sio_classname = "perform_mkord_add_"	
		##fprnt " line #{__LINE__}  \n sql_mkord_search(rec) = #{sql_mkord_search(rec)}"
		tbl = {}
		recs.each do |rec|
		    vproc_mkord rec	
		    tbl[:result_f] = "1"  ## normal end
		    tbl[:updated_at] = Time.now
		    tbl[:cmpldate] = Time.now
		    tbl[:incnt] = @incnt
		    tbl[:outcnt] = @outcnt
		    tbl[:skipcnt] = @skipcnt
		    tbl[:inqty] = @inqty
		    tbl[:outqty] = @outqty
		    tbl[:skipqty] = @skipqty
		    tbl[:inamt] = @inamt
		    tbl[:outamt] = @outamt
		    tbl[:skipamt] = @skipamt
		    tbl[:where] = {:id =>rec["id"]}
		    plsql.mkords.update tbl
		end
        dbcud = DbCud.new
        dbcud.perform(@new_sio_session_counter ,@sio_user_code,"") 
		plsql.commit
        plsql.connection.autocommit = true
		rescue
		        plsql.rollback
                fprnt"class #{self} : LINE #{__LINE__} $@: #{$@} " 
                fprnt"class #{self} : LINE #{__LINE__} $!: #{$!} " 		
		        tbl[:result_f] = "9"  ## error
		        tbl[:message_code] = $!.to_s[0..255]
		        tbl[:message_contents] = $@.to_s[0..3999]
		        tbl[:updated_at] = Time.now
		        tbl[:where] = {:id =>rec["id"]}
		        plsql.mkords.update tbl
		        plsql.commit
	  end
    end
    handle_asynchronously :perform_mkords
	def vproc_mkord rec     ###画面項目prdpurshpは必須
	    opeitm_id = 0
		@ord_show_data = get_show_data "r_#{rec["prdpurshp"]}ords"
		fprnt  "sql =  \n #{sql_alloc_search(rec,"schs")}"
		bal_schs = ActiveRecord::Base.connection.select_all(sql_alloc_search(rec,"schs"))
		@incnt = bal_schs.size
		@skipcnt = @outcnt = 0
		@inqty = @outqty = @skipqty = 0
		@inamt = @outamt = @skipamt = 0
		@schpricesym = (rec["prdpurshp"] + "sch_price")
		save_sch = {}
		ary_alloc =[]		
		@free_qty = 0
		bal_schs.each do |sch|
		    @inqty += sch["alloctbl_qty"]
			@inamt += (sch["alloctbl_qty"] * (sch[@schpricesym]||=0))
			if sch["opeitm_autocreate_ord"] == "0" ##手動の時は作成しない。
				@skipcnt += 1
				@skipqty += sch["alloctbl_qty"]
				@skipamt += (sch["alloctbl_qty"] * (sch[@schpricesym]||=0))	
				next
			end
		    if opeitm_id != sch["opeitm_id"]
			    vproc_mkord_create_ord(save_sch,ary_alloc) if opeitm_id != 0 
			    save_sch = sch.dup
				proc_opeitm_instance (save_sch) ###set @opeitm
				opeitm_id = @opeitm[:id]
				@free_qty = 0
				ary_alloc =[]
				ary_alloc << sch
			else
                if @opeitm[:maxqty] <= (save_sch["alloctbl_qty"] + sch["alloctbl_qty"]) or 
				    sch["trngantt_strdate"].to_date >= (save_sch["trngantt_strdate"].to_date + @opeitm[:opt_fixoterm]) or
				    sch["trngantt_loca_id"] != save_sch["trngantt_loca_id"] or sch["loca_id_to"] != save_sch["loca_id_to"]
				    if  sch["trngantt_loca_id"] == save_sch["trngantt_loca_id"] and sch["loca_id_to"] == save_sch["loca_id_to"]
					    if save_sch["alloctbl_qty"] >= @free_qty 
    						save_sch["alloctbl_qty"] -= @free_qty 
                            @free_qty = 0
                         else
    						save_sch["alloctbl_qty"] = 0
                            @free_qty -= save_sch["alloctbl_qty"]				
                        end	
                       else
                        @free_qty = 0   					   
					end
				    if save_sch["alloctbl_qty"] > 0 
						vproc_mkord_create_ord(save_sch,ary_alloc)  
						save_sch = sch.dup
						ary_alloc =[]
					end
                else
                    save_sch["alloctbl_qty"] += sch["alloctbl_qty"]  	 				   			   
                end			
				ary_alloc << sch
		    end
		end
		if ary_alloc.size >0
			vproc_mkord_create_ord(save_sch,ary_alloc)  if save_sch["alloctbl_qty"] > 0
		end
	end
    def vproc_mkord_create_ord save_sch,ary_alloc ###日付(@opeitm[:opt_fixoterm])による数量まとめは済んでいる。
		 ## 包装単位での発注
		@ord = {}
	    org_qty = (save_sch["alloctbl_qty"].to_f/@opeitm[:packqty].to_f).ceil *  @opeitm[:packqty]
		@free_qty = org_qty - save_sch["alloctbl_qty"]
		schtblnamechop = @opeitm[:prdpurshp] + "sch"
		ordtblnamechop = @opeitm[:prdpurshp] + "ord"
		proc_command_c_to_instance save_sch   ###@xxxsch_yyyy 作成
		@ord[(ordtblnamechop+"_strdate").to_sym]  = save_sch[(schtblnamechop+"_strdate")]
		@ord[(ordtblnamechop+"_duedate").to_sym]  = save_sch[(schtblnamechop+"_duedate")]
        until org_qty <= 0
		    ## maxqtyはpackqtyの整数倍であること。
	        qty = @ord[(ordtblnamechop+"_qty").to_sym] = if @opeitm[:maxqty] < org_qty then @opeitm[:maxqty] else org_qty end
	        amt = @ord[(ordtblnamechop+"_amt").to_sym] = qty * (save_sch[(ordtblnamechop+"_price")]||=0)
	        @ord[(ordtblnamechop+"_qty_case").to_sym] = qty /  @opeitm[:packqty]
			@outcnt += 1
			@outqty += qty
			@outamt += amt 
			##vproc_create_free_trngantts save_sch if @free_qty > 0   ### free qty
			org_qty -= @opeitm[:maxqty]	
			__send__("proc_tblink_mkord_trngantts_#{ordtblnamechop}s_self10",ary_alloc)
			@ord[(ordtblnamechop+"_strdate").to_sym]  -= if @opeitm[:opt_fixoterm] >=365 then 1 else @opeitm[:opt_fixoterm] end 
			@ord[(ordtblnamechop+"_duedate").to_sym]  -= if @opeitm[:opt_fixoterm] >=365 then 1 else @opeitm[:opt_fixoterm] end
	    end		
	end
	##def vproc_create_free_trngantts save_sch,mk_ord
end

### instsの機能
#autocreate_inst　ORDS -->INSTS への分割まとめTYPE
#0:手動又は外部からのデータ取り込みでinsts作成
#　　まとめと分解あり。
#1:無条件でordからinstsを作成　回答待ち
#2:子部品がそろったら指示
#3:子部品と設備がそろったら指示
class DbInsts  < DbOrds
    def perform_mkinsts recs
	  begin
	    @sio_user_code = 0
		@sio_classname = "perform_mkinst_add_"
        plsql.connection.autocommit = false
	    @new_sio_session_counter  = user_seq_nextval
        @pare_class = "batch"
		@savekey = ""								
		@gno_lineno = 0
		recs.each do |rec|  ###recsはautocreate_instでsortされていること
		    vproc_mkinst rec
		    rec[:result_f] = "1"  ## normal end
		    rec[:updated_at] = Time.now
		    rec[:cmpldate] = Time.now
		    rec[:incnt] = @incnt
		    rec[:outcnt] = @outcnt
		    rec[:skipcnt] = @skipcnt
		    rec[:inqty] = @inqty
		    rec[:outqty] = @outqty
		    rec[:skipqty] = @skipqty
		    rec[:inamt] = @inamt
		    rec[:outamt] = @outamt
		    rec[:skipamt] = @skipamt
		    ##rec[:where] = {:id =>rec[:id]}
		    ##plsql.mkinsts.update rec
			Mkinst.update(rec["id"],rec)
		end
        dbcud = DbCud.new
        dbcud.perform(@new_sio_session_counter ,@sio_user_code,"") 
		plsql.commit
        plsql.connection.autocommit = true
		rescue
		        plsql.rollback
                fprnt"class #{self} : LINE #{__LINE__} $@: #{$@} " 
                fprnt"class #{self} : LINE #{__LINE__} $!: #{$!} " 		
		        rec[:result_f] = "9"  ## error
		        rec[:message_code] = $!.to_s[0..255]
		        rec[:message_contents] = $@.to_s[0..3999]
		        rec[:updated_at] = Time.now
		        rec[:where] = {:id =>rec[:id]}
		        plsql.mkinsts.update rec
		        plsql.commit
	  end
    end
    handle_asynchronously :perform_mkinsts
	def vproc_mkinst rec		
		@inst_show_data = get_show_data "r_#{rec["prdpurshp"]}insts"
		fprnt  "sql =  \n #{sql_alloc_search(rec,"ords")}"
		bal_ords = ActiveRecord::Base.connection.select_all(sql_alloc_search(rec,"ords"))   ### 
		@incnt = bal_ords.size
		@skipcnt = @outcnt = 0
		@inqty = @outqty = @skipqty = 0
		@inamt = @outamt = @skipamt = 0
		@ordpricesym = (rec["prdpurshp"] + "ord_price")
		##fprnt "line #{__LINE__}  \n sql_realloc_search(rec) #{sql_realloc_search(rec)}"
		save_ord = {}
		ary_alloc =[]		
		opeitm_id = 0
		rec["qty"] ||= 0
		rec["qty"] = 9999999999 if rec["qty"] == 0
		@ordpricesym = (rec["prdpurshp"] + "ord_price")
		bal_ords.each do |ord|
		    @inqty += ord["alloctbl_qty"]
			@inamt += (ord["alloctbl_qty"] * (ord[@ordpricesym]||=0))
			if ord["opeitm_autocreate_inst"] == "0" or ord[(rec["prdpurshp"]+"ord_confirm")] == "0"  ##仮の時は作成しない。
			    ### instでは同一opeitms_idでの数量まとめまない。　ordでまとめるかrplysでまとめる。　親による異なる品目の子の品目のまとめ指示はある。
				@skipcnt += 1
				@skipqty += ord["alloctbl_qty"]
				@skipamt += (ord["alloctbl_qty"] * (ord[@ordpricesym]||=0))	
				next
			end
		    if opeitm_id != ord["opeitm_id"]
			    vproc_mkinst_create_inst(save_ord,ary_alloc,rec["qty"]) if opeitm_id != 0 					   
			    save_ord = ord.dup
				proc_opeitm_instance (ord) ###set @opeitm
				opeitm_id = @opeitm[:id]
				ary_alloc =[]
			else
				save_ord["alloctbl_qty"] += ord["alloctbl_qty"]
			end		
			ary_alloc << ord
		end
		if ary_alloc.size >0
			vproc_mkinst_create_inst(save_ord,ary_alloc,rec["qty"])  if save_ord["alloctbl_qty"] > 0
		end
	end
    def vproc_mkinst_create_inst save_ord,ary_alloc,qty ###
		@inst = {}  ### proc_fld_mkinst_trngantts_xxxinsts_self10   proc_fld_xxxx  は引数なしで自動生成のため@にした。
		ordtblnamechop = @opeitm[:prdpurshp] + "ord"
		insttblnamechop = @opeitm[:prdpurshp] + "inst"
		proc_command_c_to_instance save_ord  ###@xxxord_yyyy 作成
		@inst[:strdate]  = save_ord[(ordtblnamechop+"_strdate")]
		@inst[:duedate]  = save_ord[(ordtblnamechop+"_duedate")]
		org_qty = if qty <= save_ord[(ordtblnamechop+"_qty")] then qty else save_ord[(ordtblnamechop+"_qty")] end 
	    @inst[:qty] = org_qty 
	    amt = @inst[:amt] = org_qty * (save_ord[(ordtblnamechop+"_price").to_sym]||=0)
	    @inst[:qty_case] = org_qty /  @opeitm[:packqty]
		@outcnt += 1
		@outqty += qty
		@outamt += amt 
		##vproc_create_free_trngantts save_sch if @free_qty > 0   ### free qty
		__send__("proc_tblink_mkinst_trngantts_#{insttblnamechop}s_self10",ary_alloc)	#### 
	end
end		
class DbActs  < DbInsts
	###snoとgnoとで実行が異なる。
	### sno instsと一対一で実行 qtyは必須
	### gno カートン毎まとめて入力　qty入力は無効
	### snoの時もgnoの時も 受入日,qtyは必須
    def perform_mkacts recs
	  begin
	    @sio_user_code = 0
        plsql.connection.autocommit = false
	    @new_sio_session_counter  = user_seq_nextval
        @pare_class = "batch"
		@savekey = ""								
		@gno_lineno = 0
		recs.each do |rec|  ###
		    vproc_mkact rec
		    rec[:result_f] = "1"  ## normal end
		    rec[:updated_at] = Time.now
		    rec[:cmpldate] = Time.now
		    rec[:incnt] = @incnt
		    rec[:outcnt] = @outcnt
		    rec[:skipcnt] = @skipcnt
		    rec[:inqty] = @inqty
		    rec[:outqty] = @outqty
		    rec[:skipqty] = @skipqty
		    rec[:inamt] = @inamt
		    rec[:outamt] = @outamt
		    rec[:skipamt] = @skipamt
		    rec[:where] = {:id =>rec[:id]}
		    plsql.mkinsts.update rec
		end
        dbcud = DbCud.new
        dbcud.perform(@new_sio_session_counter ,@sio_user_code,"") 
		plsql.commit
        plsql.connection.autocommit = true
		rescue
		        plsql.rollback
                fprnt"class #{self} : LINE #{__LINE__} $@: #{$@} " 
                fprnt"class #{self} : LINE #{__LINE__} $!: #{$!} " 		
		        rec[:result_f] = "9"  ## error
		        rec[:message_code] = $!.to_s[0..255]
		        rec[:message_contents] = $@.to_s[0..3999]
		        rec[:updated_at] = Time.now
		        rec[:where] = {:id =>rec[:id]}
		        plsql.mkords.update rec
		        plsql.commit
	  end
    end
    handle_asynchronously :perform_mkacts
	def vproc_mkact rec
		inst_allocs = ActiveRecord::Base.connection.select_all(sql_alloc_search(rec,"inst"))
		trnidsym = rec["prdpurshp"] + "inst_id"
		@incnt = 0
		@skipcnt = @outcnt = 0
		@inqty = @outqty = @skipqty = 0
		@inamt = @outamt = @skipamt = 0
		##fprnt "line #{__LINE__}  \n sql_realloc_search(rec) #{sql_realloc_search(rec)}"
		save_inst = {}
		ary_alloc =[]		
		trn_id = 0
		rec["qty"] ||= 0
		inst_allocs.each do |inst|
		    @inqty += inst["alloctbl_qty"]
			@inamt += (inst["alloctbl_qty"] * (inst[@ordpricesym]||=0))
		    if trn_id != inst[trnidsym]   ### xxxxxinsts_id毎に受け入れをする。
			    vproc_mkact_create_act(save_inst,ary_alloc,rec) if trn_id != 0 					   
			    save_inst = inst.dup
				proc_opeitm_instance (inst) ###set @opeitm
				trn_id = inst[trnidsym]
				ary_alloc =[]
			else
				save_inst["alloctbl_qty"] += inst["alloctbl_qty"]
			end		
			ary_alloc << inst
		end
		if ary_alloc.size >0
			vproc_mkact_create_act(save_inst,ary_alloc,rec)  if save_inst[:alloctbl_qty] > 0
		end
	end
    def vproc_mkact_create_act save_inst,ary_alloc,rec ###   開始日は受入日
		@act = {}
		acttblnamechop = @opeitm[:prdpurshp] + "act"
		insttblnamechop = @opeitm[:prdpurshp] + "inst"
		proc_command_c_to_instance save_inst  ###@xxxinst_yyyy 作成
		@act[(acttblnamechop+"_strdate").to_sym]  = rec["rcptdate"]
		@act[(acttblnamechop+"_duedate").to_sym]  = save_inst[(insttblnamechop+"_duedate")]
		qty = if rec["sno_ord"] then rec["qty"] else save_inst[(insttblnamechop+"_qty")] end 
	    @inst[(insttblnamechop+"_qty").to_sym] = qty 
		### 指示数以上の受入、出庫実績を許すかどうかはopeitm でし画面でもチェックするしここでもチェックする。  コーディングがまだ
	    amt = save_inst[(rec["prdpurshp"] + "inst_price")]
	    @act[(acttblnamechop+"_qty_case").to_sym] = qty /  @opeitm[:packqty]
		@outcnt += 1
		@outqty += qty
		@outamt += amt ###受入時単価決定の時はここの金額と異なる。
		##vproc_create_free_trngantts save_sch if @free_qty > 0   ### free qty
		__send__("proc_tblink_mkact_trngantts_#{acttblnamechop}s_self10",ary_alloc)
	end
end	
class DbReplies  < DbOrds
    def perform_setreplies tbl,id,user_id,prdpurshp ### user_id integer
		##  tableは業者毎作業場所ごとにレイアウトが異なることを想定。そのレイアウトに 外部からのデータにcno(instsのcno:外部からのkey)とsno_ord(内部key)は必須
	 begin
		rptblname = tbl.singularize.capitalize.constantize
		@sio_classname = "_add_perform_setreplies" ### perform_set
		#####repliesの時は常に追加
		sno_ord = ""
		ord = {}
		cno = ""
		bal_qty = 0
		sum_rply_qty = 0
	    @sio_user_code = 0
		@new_sio_session_counter  = user_seq_nextval
		@pare_class = "batch"
		str_id = if id then " and id = #{id} " else "" end
	    replys = ActiveRecord::Base.connection.select_all("select * from #{tbl} where result_f = '0' and persons_id_upd = #{user_id} #{str_id} FOR UPDATE ")
		replys.each do |reply|		
			ActiveRecord::Base.connection.begin_db_transaction()
			@incnt = @skipcnt = @outcnt = 0
			@inqty = @outqty = @skipqty = 0
			ctblname = reply["tblname"].singularize.capitalize.constantize
			strsql = "select * from #{reply["tblname"]} where result_f = '0' and persons_id_upd = #{user_id}  order by sno_ord FOR UPDATE "
			inputs = ActiveRecord::Base.connection.select_all(strsql)
			inputs.each do |input|			
				err ={}			
				@incnt += 1 
				@inqty += input["qty"]	
				if sno_ord != input["sno_ord"] 
					if sno_ord != "" 
						if sum_rply_qty != bal_qty and ord["opeitm_chkord"] == "0"   ###opeitm_chkord 分割回答時で数量不一致は不可--->rubycodesに登録
							err[:message_contents] = "unmatch Σreply_qty != ord_balacle_qty ; Σreply_qty = #{sum_rply_qty.to_s} ,ord_balance_qty = #{bal_qty} "
							err[:message_code] = "error_xxxx "
							err[:result_f] = "9"
							ctblname.where(:sno_ord=>input["sno_ord"],:result_f => '0').update_all(err)
							@skipcnt += 1 
							@skipqty += sum_rply_qty
						end
					end			
					strsql = "select #{prdpurshp}ord_sno,#{prdpurshp}ord_qty ord_qty,opeitm_chkord
							from r_#{prdpurshp}ords  where #{prdpurshp}ord_sno = '#{input["sno_ord"]}' "
					ord = ActiveRecord::Base.connection.select_one(strsql)	
					if ord.nil?
						err[:remark] = " not find sno =  #{input["sno_ord"]} "
						###err[:message_code] = "error_perform_setreplys_2 "
						err[:result_f] = "9"
						ctblname.where(:sno_ord=>input["sno_ord"],:result_f => '0').update_all(err)
						next
					end
					bal_qty =  	ord["ord_qty"]
					strsql = "select sno_ord,sum(qty) act_qty from #{prdpurshp}acts  where sno_ord = '#{input["sno_ord"]}' group by sno_ord "
					act = ActiveRecord::Base.connection.select_one(strsql)
					strsql = "select sno_ord,sum(qty) ret_qty from #{prdpurshp}rets  where sno_ord = '#{input["sno_ord"]}' group by sno_ord "
					ret = ActiveRecord::Base.connection.select_one(strsql)
					bal_qty -= if act then act["qty"] else 0 end
					bal_qty += if ret then ret["qty"] else 0 end
					sno_ord = input["sno_ord"]				
					cno = input["cno"]
					sum_rply_qty = 0
				end
				sum_rply_qty += input["qty"]
			end		
			if sum_rply_qty != bal_qty and ord["opeitm_chkord"] == "0"
				err ={}
				err[:message_contents] = "unmatch Σreply_qty != ord_balacle_qty ; Σreply_qty = #{sum_rply_qty.to_s} ,ord_balance_qty = #{bal_qty} "
				err[:message_code] = "error_xxxx "
				err[:result_f] = "9"
				err[:updated_at] = Time.now
				ctblname.where(:sno_ord=>sno_ord,:result_f => '0').update_all(err)
				@skipcnt += 1 
				@skipqty += sum_rply_qty
				next
			end
			strsql = "select * from #{reply["tblname"]} where result_f = '0' and persons_id_upd = #{user_id}  order by sno_ord FOR UPDATE "
			inputs = ActiveRecord::Base.connection.select_all(strsql)
			sno_ord = ""
			inputs.each do |input|
				if sno_ord != input["sno_ord"]  ###既にinstsで登録済ならいったんXXXXINSTSをすべて削除
					strsql = %Q& select * from r_#{prdpurshp}ords  where #{prdpurshp}ord_sno = '#{input["sno_ord"]}' &
					ord = ActiveRecord::Base.connection.select_one(strsql)
					strsql = %Q& select * from r_#{prdpurshp}insts where  id in ( 
								select srctblid from alloctbls where srctblname = '#{prdpurshp}insts' and   destblname = 'alloctbls' and destblid in ( 
								select  id from alloctbls where srctblname = 'trngantts' and  destblname = '#{prdpurshp}ords' and  destblid = #{ord["id"]} ))&
					insts = ActiveRecord::Base.connection.select_all(strsql)
					insts.each do |inst|
						command_c = inst.dup
						##command_c = proc_set_command_c(command_c,"r_#{prdpurshp}insts") do
						@sio_classname = "reply_delete_"
						##end	
						proc_command_c_to_instance inst
						proc_opeitm_instance (inst)
						strsql = %Q& select * from alloctbls where  srctblname = 'trngantts' and destblname = '#{prdpurshp}insts' and destblid = #{inst["id"]} and qty > 0 &
						alloctbls = ActiveRecord::Base.connection.select_all(strsql)
						__send__("proc_tblink_r_rplies_#{prdpurshp}insts_self10",alloctbls)   ######alloctbls:xxxinstsの引当て情報
					end
				end
				sno_ord = input["sno_ord"]				
				@sio_classname = "reply_add_"
				strsql = %Q& select * from r_#{prdpurshp}ords where  #{prdpurshp}ord_sno = '#{input["sno_ord"]}' &	
				ord = ActiveRecord::Base.connection.select_one(strsql)  ###view
				strsql = %Q& select * from r_alloctbls where  alloctbl_srctblname = 'trngantts' 
				             and alloctbl_destblname = '#{prdpurshp}ords' and alloctbl_destblid = #{ord["id"]} and alloctbl_qty > 0 &
				alloctbls = ActiveRecord::Base.connection.select_all(strsql) 
				proc_command_c_to_instance ord
				proc_opeitm_instance(ord)
				@reply_qty = input["qty"]   ###回答から引き継げる項目は、数量、納期、cno,gnoコメントのみ
				@reply_qty_case = input["qty_case"]   
				@reply_duedate = input["duedate"] ###shpもduedateを出庫の回答日とする。
				@reply_strdate = input["strdate"]
				@reply_content = input["contents"]
				@reply_cno = input["cno"]
				@reply_gno = input["gno"]		
				__send__("proc_tblink_r_rplies_#{prdpurshp}insts_self10",alloctbls) ###alloctbls:xxxordsの引当て情報		
				data ={}
				data[:result_f] = "1"
				data[:updated_at] = Time.now
				ctblname.where(:id =>input["id"]).update_all(data)
				@outcnt += 1
				@outqty += input["qty"]
			end		
			data ={}
			data[:incnt] = @incnt
			data[:inqty] = @inqty
			data[:outcnt] = @outcnt
			data[:outqty] = @outqty
			data[:skipcnt] = @skipcnt
			data[:skipqty] = @skipqty
			data[:result_f] = "1"
			data[:updated_at] = Time.now
			rptblname.where(:id =>reply["id"]).update_all(data)
			ActiveRecord::Base.connection.commit_db_transaction()
		end
	   rescue
                fprnt"class #{self} : LINE #{__LINE__} $@: #{$@} " 
                fprnt"class #{self} : LINE #{__LINE__} $!: #{$!} "
				ActiveRecord::Base.connection.rollback_db_transaction()
      end		
	end
    handle_asynchronously :perform_setreplies
end		
class DbResults  < DbOrds
    def perform_setresults tbl,id,user_id,prdpurshp ### user_id integer
	begin
		ActiveRecord::Base.connection.begin_db_transaction()
		rptblname = tbl.singularize.capitalize.constantize
		@sio_classname = "_add_perform_setresults" ### perform_set
		#####resultの時は常に追加
		cno = ""
		bal_qty = 0
		sum_rply_qty = 0
	    @sio_user_code = 0
		@new_sio_session_counter  = user_seq_nextval
		@pare_class = "batch"
		str_id = if id then " and id = #{id} " else "" end
	    results = ActiveRecord::Base.connection.select_all("select * from #{tbl} where result_f = '0' and persons_id_upd = #{user_id} #{str_id} FOR UPDATE ")
		results.each do |result|		
			@incnt = @skipcnt = @outcnt = 0
			@inqty = @outqty = @skipqty = 0
			ctblname = result["tblname"].singularize.capitalize.constantize
		    str_gno = if  (result["gno_input"]||="dummy") == "dummy" then "" else " and gno = '#{result["gno_input"]}' " end
			strsql = "select * from #{result["tblname"]} where result_f = '0' and persons_id_upd = #{user_id} #{str_gno}  order by sno_ord FOR UPDATE "
			inputs = ActiveRecord::Base.connection.select_all(strsql)
			inputs.each do |input|				
				@incnt += 1 
				@inqty += input["qty"]
				if input["cno_inst"] == "dummy"
					if input["sno_inst"] == "dummy"
						strsql = %Q& select *
								from r_#{prdpurshp}insts where id in(
                                     select srctblid  from alloctbls where srctblname = 'purinsts' and destblname = 'alloctbls' and destblid in(
											select id from alloctbls where srctblname = 'trngantts' and destblname = 'purords' and allocfree = 'alloc'
												and  destblid in (select id from #{prdpurshp}ords where sno = '#{input["sno_ord"]}'
												))) &
					else
						strsql = %Q& select *
								from r_#{prdpurshp}insts where #{prdpurshp}inst_sno  = '#{input["sno_inst"]}'
												 &
					end
				else
					strsql = %Q& select *
							from r_#{prdpurshp}insts  where #{prdpurshp}inst_cno = '#{input["cno_inst"]}' and & +
									case prdpurshp
											when "pur"
												prdpurshp+"inst_dealer_id = #{input["dealers_id"]}"  
											else
												prdpurshp+"inst_loca_id = #{input["locas_id"]}"
											end 
				end
				insts = ActiveRecord::Base.connection.select_all(strsql)	
				if insts.empty?
					err ={}
					err[:remark] = " not find sno_ord =  #{input["sno_ord"]}  cno_inst =  #{input["cno_inst"]} "
					###err[:message_code] = "error_perform_setreplys_2 "
					err[:result_f] = "9"
					ctblname.where(:id=>input["id"]).update_all(err)
					@skipcnt += 1 
					@skipqty += input["qty"]
					next
				end
				strsql = "select qty from #{prdpurshp}ords  where sno = '#{insts[0]["#{prdpurshp}inst_sno_ord"]}' "
				bal_qty = ActiveRecord::Base.connection.select_value(strsql)				
				strsql = "select sum(qty) act_qty from #{prdpurshp}acts  where sno_ord = '#{insts[0]["#{prdpurshp}inst_sno_ord"]}' group by sno_ord "
				act_qty = ActiveRecord::Base.connection.select_value(strsql)
				strsql = "select sum(qty) ret_qty from #{prdpurshp}rets  where sno_ord = '#{insts[0]["#{prdpurshp}inst_sno_ord"]}' group by sno_ord "
				ret_qty = ActiveRecord::Base.connection.select_value(strsql)
				bal_qty -= if act_qty then act_qty else 0 end
				bal_qty += if ret_qty then ret_qty else 0 end
				if bal_qty < input["qty"] and insts[0]["opeitm_chkinst"] == "1"  ###発注数以上の受入は不可
					err[:message_contents] = " over  act_qty: #{input["qty"]} > ord_qty: #{bal_qty} "
					err[:message_code] = "error_xxxx "
					err[:result_f] = "9"
					err[:updated_at] = Time.now
					ctblname.where(:id=>input["id"]).update_all(err)
					@skipcnt += 1 
					@skipqty += sum_rply_qty
					next
				end
				insts.each do |inst|			
					@sio_classname = "result_add_"
					strsql = %Q& select * from r_alloctbls where  alloctbl_srctblname = 'trngantts' 
				             and alloctbl_destblname = '#{prdpurshp}insts' and alloctbl_destblid = #{inst["id"]} 
							 and alloctbl_qty > 0 and alloctbl_allocfree = 'alloc' &
					alloctbls = ActiveRecord::Base.connection.select_all(strsql) 
					proc_command_c_to_instance inst
					proc_opeitm_instance(inst)
					@result_qty = input["qty"]   ###
					@result_qty_case = input["qty_case"]   
					case prdpurshp
						when "prd"
							@result_cmpldate = input["cmpldate"]
						when "pur"
							@result_rcptdate = input["rcptdate"]
						when "shp"
							@result_depdate = input["depdate"]						
					end
					@result_cno = input["cno"]
					@result_gno = input["gno"]
					@result_gno_lineno = input["gno_lineno"]
					@result_isudate = input["isudate"]
					@result_strdate = input["strdate"]
					@result_content = input["contents"]		
					__send__("proc_tblink_r_results_#{prdpurshp}acts_self10",alloctbls) ###alloctbls:xxxinstsの引当て情報		
					data ={}
					data[:result_f] = "1"
					data[:updated_at] = Time.now
					ctblname.where(:id =>input["id"]).update_all(data)
					@outcnt += 1
					@outqty += input["qty"]
				end
			end		
			data ={}
			data[:incnt] = @incnt
			data[:inqty] = @inqty
			data[:outcnt] = @outcnt
			data[:outqty] = @outqty
			data[:skipcnt] = @skipcnt
			data[:skipqty] = @skipqty
			data[:result_f] = "1"
			data[:updated_at] = Time.now
			rptblname.where(:id =>result["id"]).update_all(data)
		end
	   rescue
				ActiveRecord::Base.connection.rollback_db_transaction()
                fprnt"class #{self} : $@: #{$@} " 
                fprnt"class #{self} : $!: #{$!} "
    end
	ActiveRecord::Base.connection.commit_db_transaction()
	end
    handle_asynchronously :perform_setresults
end		