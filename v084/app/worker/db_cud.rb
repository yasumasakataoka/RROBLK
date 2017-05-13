class DbCud  < ActionController::Base
 ## @queue = :default
 ## def self.perform(sio_id,sio_view_name)
 ##　importと 画面でエラー検出すること。
			### とりあえず
## ダイナミックに　モデルを変更　	ctblname = tbl.chop.capitalize.constantize  使用中止　2015/10/01
    def perform(sio_session_counter,sio_user_id,one_by_one)
	###	crt_def_all  unless respond_to?("dummy_def")
      begin	
	    @sio_user_code = sio_user_id
       ActiveRecord::Base.connection.begin_db_transaction()
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
					###i[:sio_viewname] = i["sio_viewname"]
					##i["person_id_upd"] = i[:person_id_upd] = @sio_user_code
					proc_update_table "rec",i.with_indifferent_access,r_cnt0 ### 本体
					##reset_show_data_screen if tblname =~ /screen|pobjgrps/   ###キャッシュを削除
					##
					strsql = " update userproc#{@sio_user_ode.to_s}s set cnt_out = #{r_cnt0},status = 'normal end' ,updated_at = current_date
				           where session_counter = #{sio_session_counter} and tblname = '#{tg_tbl[:tblname]}' "
					ActiveRecord::Base.connection.execute(strsql)
					ActiveRecord::Base.connection.commit_db_transaction() if one_by_one == "one_by_one"
				end
			else
				logger.debug " Queue data nothing sio_session_counter = #{sio_session_counter},sio_user_id = #{sio_user_id}"
		    end
		end
		ActiveRecord::Base.connection.commit_db_transaction()
	   rescue
	        if @sio_result_f !=   "9" ##想定外error
                logger.debug" error class #{self} #{Time.now}:  $@: #{$@} " 
                logger.debug"  error class #{self} :  $!: #{$!} "
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
    ##def reset_show_data_screen
      ##cache_key =  "show" 
      ##Rails.cache.delete_matched(cache_key) ###delay_jobからcallされるので、grp_codeはbatch
	##  Rails.cache.clear(nil) ###delay_jobからcallされるので、grp_codeはbatch
    ##end
	##def perform_crt_def_all
	##	crt_def_all
	##end
    ##  handle_asynchronously :perform_crt_def_all
	def auto_create_ords_insts
		###itm_code毎にmkordsを作成
		strsql = " select trngantt_prdpurshp,itm_code from r_trngantts,alloctbs
					inner join trngantt_id = srctblid
					where trngantt_autocreate_ord in('a','b','c','A','B') 
					and  srctblname = 'trngantts' and destblname like '%schs' and alloctbls.qty > 0 "
		###
		#strsql = " select trngantt_prdpurshp,itm_code from r_trngantts
		#			inner join alloctbls on trngantt_id = srctblid
		#			where trngantt_autocreate_inst in('a','A') 
		#			and  srctblname = 'trngantts' and destblname like '%ords' and alloctbls.qty > 0 "
		##debugger
		##raise
		insts = ActiveRecord::Base.connection.select_all(strsql)
	end
    def perform_mkbttables recs
		##crt_def_all  unless respond_to?("dummy_def")
	begin
		@pare_class = "batch"
		@sio_user_code = 0
		cnt = 0
		tbl= {}
		tbl[:result_f] = "1"  ## normal end
		tbl[:updated_at] = Time.now	
		tbl[:remark] = nil
	    tbl[:message_code] = nil
		strsql = "select * from tblinks where codel like 'proc_tblink_mkbttable_#{recs[0]["tblname"]}_%' and expiredate > current_date order by seqno"
		tblinks = ActiveRecord::Base.connection.select_all(strsql)
		@sio_classname = "mktrngantt_perform_edit_"
		err_cnt = 0
		recs.each do |rec|
		begin
			ActiveRecord::Base.connection.begin_db_transaction()
			case rec["sio_classname"]
				when /_edit_/
					@sio_classname = "mkbttable_perform_edit_"	
				when /_delete_/
					@sio_classname = "mkbttable_perform_delete_"
				when /_add_/
					@sio_classname = "mkbttable_perform_add_"
			end
			strsql = "select * from r_#{rec["tblname"]}  where id = #{rec["tblid"]}  "
			tgrec = ActiveRecord::Base.connection.select_one(strsql)
			proc_command_instance_variable tgrec
			tblinks.each do |tblink|
				unless respond_to?(tblink["codel"])
					proc_crt_def_rubycode(tblink)
				end
				__send__(tblink["codel"],rec["tblname"])
			end
			tbl[:cmpldate] = Time.now
			proc_tbl_edit_arel "mkbttables", tbl, " id = #{rec["id"]}"   ###insertはtblinks updateはここ　何とかならないか
			ActiveRecord::Base.connection.commit_db_transaction()
		rescue
			ActiveRecord::Base.connection.rollback_db_transaction()
			err_cnt += 1
			logger.debug"error class #{self}   #{Time.now}$@: #{$@} " 
			logger.debug"error class LINE #{__LINE__}   $!: #{$!} " 	
			tbl[:result_f] = "9"	
			tbl[:remark] = "error class #{self}   #{Time.now}$@: #{$@} "[0..3999]
			tbl[:message_code] = "error class LINE #{__LINE__}   $!: #{$!} "[0..200] 
			proc_tbl_edit_arel "mkbttables", tbl, " id = #{rec["id"]}"   ###insertはtblinks updateはここ　何とかならないか
			ActiveRecord::Base.connection.commit_db_transaction()
			break if err_cnt >= 10
		end 
		end
	rescue
		ActiveRecord::Base.connection.rollback_db_transaction()
		logger.debug"error class #{self}   #{Time.now}$@: #{$@} " 
		logger.debug"error class LINE #{__LINE__}   $!: #{$!} " 	
		tbl[:result_f] = "9"	
		tbl[:remark] = "error class #{self}   #{Time.now}$@: #{$@} "[0..3999]
		tbl[:message_code] = "error class LINE #{__LINE__}   $!: #{$!} "[0..200] 
		proc_tbl_edit_arel "mkbttables", tbl, " id = #{rec["id"]}"   ###insertはtblinks updateはここ　何とかならないか
		ActiveRecord::Base.connection.commit_db_transaction()
	end
    end
    handle_asynchronously :perform_mkbttables

	def sql_alloc_search rec,sch_ord_inst_act   ## 検索条件のためrecは必須　rec["xxxx"]と@xxxの併用
		org_strwhere = ""
		trn_strwhere = ""
		pare_strwhere = ""
		### orgtblnameの存在チェックを画面でする。 trnganttsのorgtblnameにあること。
		org_show_data = get_show_data "r_#{@tblname_org}"   if @tblname_org
		pare_show_data = get_show_data "r_#{@tblname_pare}"   if @tblname_pare
		trn_show_data = get_show_data "r_#{@prdpurshp+sch_ord_inst_act}" 
		org_search_key = {}
		pare_search_key = {}
		trn_search_key = {}
		fullord_pare = "0"
		rec.each do |key,val|
   		    next if val.nil?
   		    next if key !~ /_org$/ and key !~ /_trn$/ and key !~ /_pare$/
			next if @tblname_org.nil? and key =~ /org$/
			next if @tblname_pare.nil? and key =~ /pare$/
			### next if rec["prdpurshp"].nil? and key =~ /trn$/   #rec["prdpurshp"]は必須			
			##tblname,idfield,delm = key.sub(/_org$|_trn$|_pare$/,"").split("_",3)
			nkey = key.sub(/_org$|_trn$|_pare$/,"")
			viewname = case key
			                when /_org$/ 
								"r_#{@tblname_org}"
							when /_pare$/
								"r_#{@tblname_pare}"
							else
								"r_#{@prdpurshp+sch_ord_inst_act}"
						end
			nkey.sub!("starttime","depdate") if viewname =~ /^r_shp/			
			field = ActiveRecord::Base.connection.select_value(%Q&select pobject_code_sfd from r_screenfields where pobject_code_view = '#{viewname}' 
																and pobject_code_sfd = '#{nkey}'&)
			if field.nil?
				nkey = viewname.split("_")[1].chop + "_" + nkey 			
				field = ActiveRecord::Base.connection.select_value(%Q&select pobject_code_sfd from r_screenfields where pobject_code_view = '#{viewname}' 
																and pobject_code_sfd = '#{nkey}'&)
			end
			next if field.nil?
			case key
			    when /_org$/ 
					org_search_key[nkey] = val
				when /_trn$/
					trn_search_key[nkey] = val
				when /_pare$/
					if key == "fullord_pare"  ###全階層子部品手配
						fullord_pare = "1" if val == "1"
					else
						pare_search_key[nkey] = val
					end
			end
		end
		if org_search_key.size >=1 
    		org_strwhere = %Q& and trngantt_orgtblname = '#{@tblname_org}'    
							and  trngantt_orgtblid in (select id from   r_#{@tblname_org} where 
							#{proc_search_key_strwhere(org_search_key,org_strwhere,org_show_data )}
							) &
		end
		if pare_search_key.size >=1  ###在庫引きあたり分は対象外
			cmp_keys = ActiveRecord::Base.connection.select_all(%Q& select t.orgtblname,t.orgtblid,t.key ,
							t.itms_id,t.locas_id,t.processseq
							from trngantts t ,alloctbls a,r_#{@tblname_pare} pare
							where a.srctblname = 'trngantts' and t.id = a.srctblid and   a.qty > 0
							and  a.destblname = '#{@tblname_pare}' and a.destblid =  pare.id and 
							#{proc_search_key_strwhere(pare_search_key,pare_strwhere,pare_show_data )}
							&)
			pare_strwhere = " and ("  ###
			cmp_keys.each do |key|   ###
				if fullord_pare == "1"  ###下位の階層すべての部品すべて対象
					pare_strwhere　 <<  %Q& ( trngantt_orgtblname = '#{key["orgtblname"]}' and trngantt_orgtblid = #{key["orgtblid"]}
												and trngantt_key like '#{key["key"]}%'   )   or &
				else ###同一itms_idの直下の子部品のみ
					nditms_id = proc_get_cons_chil(key)
					next if nditms_id.empty?   ###同一itms_idで複数のopeitms_idがある時で子部品なし
					str_itms_id = ""
					nditms_id.each do |ndrec|
						str_itms_id << ndrec["itm_id_nditm"].to_s + "," 
					end
					pare_strwhere << " ( trngantt_orgtblname = '#{key["orgtblname"]}' and trngantt_orgtblid = #{key["orgtblid"]} 
											and trngantt_key like '#{key["key"]}%'  and length(trngantt_key) = #{key["key"].size + 3 } and trn.opeitm_itm_id in(#{str_itms_id.chop}))   or "
				end
			end
			pare_strwhere = pare_strwhere[0..-5] + ")"
		end
		if trn_search_key.size >=1 ###発注残用のbal_purschsを作成すべきか？
    		trn_strwhere = 	%Q&  and alloctbl_destblid in (select id from r_#{@prdpurshp+sch_ord_inst_act}  where
								#{proc_search_key_strwhere(trn_search_key,trn_strwhere,trn_show_data)}
								 ) &
		end
		proc_free_to_alloc(org_strwhere,pare_strwhere,trn_strwhere,nil) if sch_ord_inst_act == "schs" and @prdpurshp =~ /pur|prd/
		hchng_sch_ord_inst_act = {"schs"=>"ord","ords"=>"insts","insts"=>"act"}
		%Q&
			select trngantt_id,trngantt_starttime,trngantt_orgtblname,trngantt_orgtblid,trngantt_key,
			trngantt.itm_id trngantt_itm_id,trngantt.loca_id trngantt_loca_id,
			trngantt.trngantt_prdpurshp trngantt_prdpurshp,trngantt.trngantt_processseq,trngantt_prjno_id,
			trngantt.trngantt_autocreate_#{hchng_sch_ord_inst_act[sch_ord_inst_act]} autocreate_#{hchng_sch_ord_inst_act[sch_ord_inst_act]},
			alloctbl_id,alloctbl_srctblname,alloctbl_srctblid,alloctbl_destblname,alloctbl_destblid,alloctbl_qty,alloctbl_id,
			trn.#{@prdpurshp+sch_ord_inst_act.chop}_loca_id_to prdpurshpxxx_loca_id_to,trn.*
		    from r_trngantts trngantt ,r_#{@prdpurshp+sch_ord_inst_act} trn ,r_alloctbls 
		    where  alloctbl_srctblname = 'trngantts' and trngantt_id = alloctbl_srctblid
			and alloctbl_qty > 0 and alloctbl_allocfree in('alloc','free')
			and alloctbl_destblname = '#{@prdpurshp+sch_ord_inst_act}' 
			and alloctbl_destblid = trn.id
		    #{org_strwhere}
		    #{pare_strwhere}
		    #{trn_strwhere}
			#{if sch_ord_inst_act == "acts" 
				"order by trn.id"
		 	  else
			  	"order by trngantt.itm_code,trngantt.loca_id,
				trn.#{@prdpurshp+sch_ord_inst_act.chop}_loca_id_to,trngantt_processseq,
				trngantt_itm_id,trngantt.trngantt_starttime"
			  end}
		&
	end
	###schからord に変わった時 呼ばれる
	def proc_free_to_alloc(org_strwhere,pare_strwhere,trn_strwhere,trg_where)  ###org_strwhere プロジェクト単位　pare 親　trn　自身
		strsql =
		%Q&	select trngantt_id,trngantt_starttime,trngantt_orgtblname,trngantt_orgtblid,trngantt_qty,trngantt_qty_stk,trngantt_duedate,
			trngantt.loca_id trngantt_loca_id,trngantt.itm_id trngantt_itm_id,
			trngantt_prdpurshp,trngantt_processseq,trngantt_prjno_id,trngantt.prjno_code,
			alloctbl_id id,alloctbl_srctblname srctblname,alloctbl_srctblid srctblid,
			alloctbl_destblname destblname,alloctbl_destblid destblid,
			alloctbl_qty qty,alloctbl_qty_stk qty_stk,alloctbl_packqty packqty,
			case trngantt_shuffle_flg
				when '0'  then     ------シャッフルしない    
					case 
						when  alloctbl_destblname like 'pic%' then 'A'
						when alloctbl_destblname like '%ords' then '3' 
						when alloctbl_destblname like '%insts' then '5'
						when alloctbl_destblname like '%acts' then '7' 
						when  alloctbl_destblname = 'lotstkhists' then '9'
					end
				else
					case
						when  alloctbl_destblname LIKE 'pic%' then '9'
						when alloctbl_destblname like '%ords' then '7' 
						when alloctbl_destblname like '%insts' then '5'
						when alloctbl_destblname like '%acts' then '3' 
						when  alloctbl_destblname = 'lotstkhists' then 
								case 
									when alloctbl_packqty = alloctbl_qty_stk then '1'
									else '2'
								end	
					end
			end				sortkey,
			trngantt_shuffle_flg ,alloctbl_created_at
		    from r_trngantts trngantt ,r_alloctbls
		    where  alloctbl_srctblname = 'trngantts' and trngantt_id = alloctbl_srctblid
			and (alloctbl_qty > 0 or alloctbl_qty_stk > 0) and alloctbl_allocfree = 'free'
			and trngantt_key = '000' and trngantt_orgtblname = alloctbl_destblname and trngantt_orgtblid = alloctbl_destblid
			and alloctbl_destblname not like '%schs'
		    #{trn_strwhere}
			order by sortkey,trngantt_itm_id,alloctbl_srctblid,alloctbl_created_at
		&
		frees = ActiveRecord::Base.connection.select_all(strsql)
		trn = {}
		trn[:qty] = 0
		frees.each do |free|
			qty_stk = free["qty_stk"]
			qty = free["qty"]
			trn[:duedate] = free["trngantt_duedate"]
			##until qty_stk <= 0 and qty <= 0 ##if trn[:qty] <= 0
				###freeからallocに代わる候補を探す。
				chng_allocs = ActiveRecord::Base.connection.select_all(vsql_demand_ord(free,org_strwhere,pare_strwhere,if trg_where then trg_where else trn_strwhere end))
				chng_allocs.each do |c_alloc|
					trn[:tblname] = free["destblname"]
					trn[:id] = free["destblid"]
					trn[:qty_stk] = 0
					trn[:qty] = c_alloc["qty"]
					if free["qty"] == 0
						###trn[:qty_stk] = free["qty_stk"]
						free_qty_stk = proc_chng_sch_to_stk trn,c_alloc,free.with_indifferent_access
						###proc_edit_from_trngantts rec["tblname"].chop
						proc_edit_chil_req_qty_from_trngantts c_alloc,(trn[:qty] - free_qty_stk)
						free["qty_stk"] = free_qty_stk
						break if free_qty_stk  <= 0
					else
						free_qty = proc_update_base_alloc trn,c_alloc.with_indifferent_access,free.with_indifferent_access
						free["qty_stk"] = free_qty
						break if free_qty  <= 0
					end
				end
			##end
		end		
	end
	def vsql_demand_ord free,org_strwhere,pare_strwhere,trn_strwhere
		%Q&
			select 
			---- trngantt_id,trngantt_starttime,
			--- trngantt_loca_id , trngantt_itm_id,
			trngantt_orgtblname,trngantt_orgtblid,trngantt_key,
			---- trngantt_prdpurshp,trngantt_processseq,trngantt_prjno_id,
			alloctbl_id id,alloctbl_srctblname srctblname,alloctbl_srctblid srctblid,alloctbl_destblname destblname,alloctbl_destblid destblid,
			alloctbl_qty qty,alloctbl_qty_stk qty_stk,alloctbl_allocfree allocfree
		    from r_trngantts trngantt ,r_alloctbls 
				#{case free["destblname"]
					when /ords$|inst$/
						""
					when /lotstkhis/
						",trngantts pare"
					end}
		    where  alloctbl_srctblname = 'trngantts' and trngantt_id = alloctbl_srctblid and alloctbl_allocfree = 'alloc'
			and (alloctbl_qty > 0 and alloctbl_destblname like '%schs')
			and trngantt_key != '000' and trngantt_itm_id = #{free["trngantt_itm_id"]}
			and trngantt.prjno_code in('#{ proc_prj_allocprjcodes(free["prjno_code"])}')
			#{	case free["destblname"]
					when  /ords$|inst$/
							"and trngantt_processseq = " + sprintf("%3d",free["trngantt_processseq"]) +
							if free["opeitm_shuffle_loca"] != "1"  
								"and trngantt_loca_id = " + free["trngantt_loca_id"].to_s
							else
								""
							end
					when /lotstkhis/
						" and trngantt_orgtblname = pare.orgtblname and  trngantt_orgtblid = pare.orgtblid " +
						"and pare.processseq = " + sprintf("%3d",free["trngantt_processseq"]) +
						" and ( (substr(trngantt_key,1,length(trngantt_key)-3) =  pare.key) or " + 
								" ((trngantt_key - 1) = pare.key) and length(pare.key)=3  and length(trngantt_key)=3 )" +
						if free["opeitm_shuffle_loca"] != "1"  
							" and pare.locas_id = " + free["trngantt_loca_id"].to_s
						else
							""
						end
					end}
		    #{org_strwhere}
		    #{pare_strwhere}
		    #{trn_strwhere}
			order by trngantt_itm_id,
			#{case free["opeitm_shuffle_flg"]
			    when 0,1,5
				   "trngantt.trngantt_created_at"
			   else
					"trngantt.trngantt_duedate"
			  end}
		&
	end
	def vsql_chk_samle_level_status rec,abc  ### autocreate_ord = a,b,A,B
		%Q&
			select itm_code from r_trngantts ,alloctbls alloc
			where trngantt_orgtblname = '#{rec["trngantt_orgtblname"]}' and trngantt_orgtblid = #{rec["trngantt_orgtblid"]}
			and trngantt_key like '#{rec["trngantt_key"][0..-4]}%' and length(trngantt_key) = #{rec["trngantt_key"].size}
			and srctblname = 'trngantts' and srctblid = trngantts.id 
			#{case abc                                     
					when "a"
						" and  alloc.qty > 0 and trngantt_itm_id = #{rec["trngantt_itm_id"]} " 
					when "b"
						" and alloc.qty > 0  "
					when "c"
						" and alloc.qty > 0  and destblname like '%schs' "
					else
						raise
				end}	
			
		&
	end
	def vsql_chk_chil_status rec  ### autocreate_ord = a,b,A,B
		%Q&
			select itm_code from r_trngantts chil,alloctbls alloc
			where trngantt_orgtblname = '#{rec["trngantt_orgtblname"]}' and trngantt_orgtblid = #{rec["trngantt_orgtblid"]}
			and trngantt_key like '#{rec["trngantt_key"]}%' and length(trngantt_key) = #{rec["trngantt_key"].size+3}
			and srctblname = 'trngantts' and srctblid = chil.id 
			and ((trngantt_autocreate_ord = 'B' and alloc.qty > 0) or
					(trngantt_autocreate_ord = 'C' and alloc.qty > 0 and destblname like '%schs')) 
		&
	end
    def perform_mkords recs
		##crt_def_all  unless respond_to?("dummy_def")
	  begin
	    @sio_user_code = 0
		ActiveRecord::Base.connection.begin_db_transaction()
	    @new_sio_session_counter  = user_seq_nextval
        @pare_class = "batch"
		@sio_classname = "mkord_perform_add_"	
		tbl = {}
		rec_id = 0
		recs.each do |rec|
			rec_id = rec["id"]
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
			tbl[:remark] = nil
		    tbl[:message_code] = nil
		    ##tbl[:where] = {:id =>rec["id"]}
		    proc_tbl_edit_arel("mkords",tbl," id = #{rec["id"]} ")
		end
        ##dbcud = DbCud.new
        ##dbcud.perform(@new_sio_session_counter ,@sio_user_code,"") 
		ActiveRecord::Base.connection.commit_db_transaction()
		rescue
		        ActiveRecord::Base.connection.rollback_db_transaction()
                logger.debug"error class #{self} : #{Time.now} $@: #{$@} " 
                logger.debug"error class #{self} :  $!: #{$!} " 		
		        tbl[:result_f] = "9"  ## error
		        tbl[:message_code] = $!.to_s[0..200]
		        tbl[:remark] = $@.to_s[0..3999]
		        tbl[:updated_at] = Time.now
		        ##tbl[:where] = {:id =>rec["id"]}
		        proc_tbl_edit_arel("mkords",tbl," id = #{rec_id} ")
		        ActiveRecord::Base.connection.commit_db_transaction()
	  end
    end
    handle_asynchronously :perform_mkords
	###def proc_get_opeitms_999_999(trn)
	###	opeitm = ActiveRecord::Base.connection.select_one("select * from opeitms where itms_id = #{trn["trngantt_itm_id"]} and priority = 999 and processseq = 999")
	###	trn["opeitm_maxqty"] = opeitm["maxqty"]
	###	trn["opeitm_opt_fixoterm"] = opeitm ["opt_fixoterm"]
	###	trn["opeitm_packqty"] = opeitm["packqty"]
	###	return trn
	###end
	def vproc_mkord rec     ###画面項目prdpurshpは必須
	    aopeitms_id = [] 
		proc_command_instance_variable rec  ### @xxxの作成
		## @ord_show_data = get_show_data "r_#{rec["prdpurshp"]}ords"
		bal_schs = ActiveRecord::Base.connection.select_all(sql_alloc_search(rec,"schs"))
		@incnt = bal_schs.size
		@skipcnt = @outcnt = 0
		@inqty = @outqty = @skipqty = 0
		@inamt = @outamt = @skipamt = 0
		@schpricesym = (rec["prdpurshp"] + "sch_price")
		save_sch = {}
		allocs =[]		
		@free_qty = 0
		bal_schs.each do |sch|
		    @inqty += sch["alloctbl_qty"]
			@inamt += (sch["alloctbl_qty"] * (sch[@schpricesym]||=0))
			sch["alloctbl_qty_stk"] = 0   ###在庫分は対象外
			###if sch["opeitm_id"].nil?
			###	sch = proc_get_opeitms_999_999(sch)
			###end
			if rec["manual"] == "a"
				case  sch["autocreate_ord"] ### shp:出庫オーダ作成
					when /A|B|C|D/  ##親の作業指示・発注と同時に出庫指示
						if rec["tblname_pare"] and (rec["sno_pare"] or rec["cno_pare"])
						else
							@skipcnt += 1
							@skipqty += sch["alloctbl_qty"]
							@skipamt += (sch["alloctbl_qty"] * (sch[@schpricesym]||=0))	
							proc_mkord_err sch,"仕様変更？？？？"
							next
						end
					when /1|2/ 
					else
						@skipcnt += 1
						@skipqty += sch["alloctbl_qty"]
						@skipamt += (sch["alloctbl_qty"] * (sch[@schpricesym]||=0))	
						proc_mkord_err sch,proc_blkgetpobj("自動処理対象外","msg")
						next
				end
				### no check
			else	
				case  sch["autocreate_ord"] ### shp:出庫オーダ作成  
					when "0"  ##手動の時は作成しない。  proc_view_field_opeitm_autocreate_ordに移動
						@skipcnt += 1
						@skipqty += sch["alloctbl_qty"]
						@skipamt += (sch["alloctbl_qty"] * (sch[@schpricesym]||=0))	
						proc_mkord_err sch,proc_blkgetpobj("手動のためskip","msg")
						next
					when "a"
						itms = ActiveRecord::Base.connection.select_values(vsql_chk_samle_level_status(sch,"A"))
						if itms.size > 0
							proc_mkord_err sch,(proc_blkgetpobj("子部品在庫不足","msg")+itms.join(","))[0.3999]   ###コーディングはまだ
							next
						end	
					when /A|B|C|D/  ##親の作業指示・発注と同時に出庫指示のため対象外
						if rec["tblname_pare"] and (rec["sno_pare"] or rec["cno_pare"])
						else
							@skipcnt += 1
							@skipqty += sch["alloctbl_qty"]
							@skipamt += (sch["alloctbl_qty"] * (sch[@schpricesym]||=0))	
							proc_mkord_err sch,proc_blkgetpobj("親の作業指示・発注と同時に出庫指示のため対象外","msg") 
							next
						end
					else
				end
				### no check
			end
			itms = ActiveRecord::Base.connection.select_values(vsql_chk_chil_status(sch))
			if itms.size > 0
				proc_mkord_err sch,"子部品在庫不足　#{itms.join(",")} "[0.3999]   ###
				next
			end	
		    if aopeitms_id != [sch["trngantt_itm_id"],sch["trngantt_loca_id"],sch["trngantt_processseq"]] or save_sch["opt_fix_flg"] == "P"
			    vproc_mkord_create_ord(save_sch,allocs) if aopeitms_id != []
			    save_sch = sch.dup
				##proc_opeitm_instance (save_sch) ###set 
				aopeitms_id = [save_sch["trngantt_itm_id"],save_sch["trngantt_loca_id"],save_sch["trngantt_processseq"]]
				@free_qty = 0
				allocs =[]
				allocs << {"srctblname"=>sch["alloctbl_srctblname"],"srctblid"=>sch["alloctbl_srctblid"],"allocfree"=>"alloc",
							"destblname"=>sch["alloctbl_destblname"],"destblid"=>sch["alloctbl_destblid"],
							"qty"=>sch["alloctbl_qty"],"qty_stk"=>sch["alloctbl_qty_stk"],"id"=>sch["alloctbl_id"]}.with_indifferent_access
			else
				save_sch["opeitm_maxqty"] = 9999999999 if (save_sch["opeitm_maxqty"]||=0) <= 0
				save_sch["opeitm_opt_fixoterm"] = 999 if (save_sch["opeitm_opt_fixoterm"]||=0) <= 0
                if  save_sch["opeitm_maxqty"] < (save_sch["alloctbl_qty"] + sch["alloctbl_qty"]) or 
				    sch["trngantt_starttime"].to_date > (save_sch["trngantt_starttime"].to_date + save_sch["opeitm_opt_fixoterm"]) or
				    sch["trngantt_loca_id"] != save_sch["trngantt_loca_id"] or sch["prdpurshpxxx_loca_id_to"] != save_sch["prdpurshpxxx_loca_id_to"]  or
					sch["trngantt_prjno_id"] != save_sch["trngantt_prjno_id"] 
				    if  sch["trngantt_loca_id"] == save_sch["trngantt_loca_id"] and sch["prdpurshpxxx_loca_id_to"] == save_sch["prdpurshpxxx_loca_id_to"]
					    if save_sch["alloctbl_qty"] >= @free_qty ###@free_qty 余分に発注した数量
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
						vproc_mkord_create_ord(save_sch,allocs)  
						save_sch = sch.dup
						allocs =[]
					end
                else
                    save_sch["alloctbl_qty"] += sch["alloctbl_qty"]  	 				   			   
                end			
				allocs << {"srctblname"=>sch["alloctbl_srctblname"],"srctblid"=>sch["alloctbl_srctblid"],"allocfree"=>"alloc",
							"destblname"=>sch["alloctbl_destblname"],"destblid"=>sch["alloctbl_destblid"],
							"qty"=>sch["alloctbl_qty"],"qty_stk"=>sch["alloctbl_qty_stk"],"id"=>sch["alloctbl_id"]}.with_indifferent_access
		    end
		end
		if allocs.size >0
			vproc_mkord_create_ord(save_sch,allocs)  if save_sch["alloctbl_qty"] > 0
		end
	end
    def vproc_mkord_create_ord save_sch,allocs ###日付(opeitm_opt_fixoterm)による数量まとめは済んでいる。
		 ## 包装単位での発注出庫　ロット単位での製造
	    org_qty = 	if save_sch["opeitm_packqty"] == 0 or save_sch["opeitm_packqty"] == 1 or save_sch["opeitm_packqty"].nil?
						save_sch["alloctbl_qty"].to_f
					else
						opeitm_qty_pur = if (save_sch["opeitm_qty_pur"]||=1) == 0 then 1 else save_sch["opeitm_qty_pur"]||=1 end
						(save_sch["alloctbl_qty"].to_f/save_sch["opeitm_packqty"].to_f).ceil *  save_sch["opeitm_packqty"] * save_sch["opeitm_qty_pur"]
					end
		@free_qty = org_qty - save_sch["alloctbl_qty"]
		##schtblnamechop = save_sch["trngantt_prdpurshp"] + "sch"
		##ordtblnamechop = save_sch["trngantt_prdpurshp"] + "ord"
		save_sch["opeitm_maxqty"] = 99999999999 if save_sch["opeitm_maxqty"] <= 0
		i = 0
        until org_qty <= 0
		    ## maxqtyはpackqtyの整数倍であること。
	        qty = if save_sch["opeitm_maxqty"] < org_qty then save_sch["opeitm_maxqty"] else org_qty end
	        amt = qty * (save_sch[(save_sch["trngantt_prdpurshp"] + "sch"+"_price")]||=0)  ###単価概算
	        qty_case = if save_sch["opeitm_packqty"] == 0 or save_sch["opeitm_packqty"].nil?
																qty
														else
																(qty.to_f /  save_sch["opeitm_packqty"]).ceil
														end
			qty = qty_case * save_sch["opeitm_packqty"] if  save_sch["opeitm_packqty"] >= 1 
			proc_command_instance_variable save_sch   ###@xxxsch_yyyy 作成
			eval("@#{save_sch["trngantt_prdpurshp"] + "sch"}_qty = qty")
			eval("@#{save_sch["trngantt_prdpurshp"] + "sch"}_qty_case = qty_case")
			eval("@#{save_sch["trngantt_prdpurshp"] + "sch"}_amt = amt")
			eval("@#{save_sch["trngantt_prdpurshp"] + "sch"}_amt_case = amt")
			eval("@#{save_sch["trngantt_prdpurshp"] + "sch"}_duedate = @#{save_sch["trngantt_prdpurshp"] + "sch"}_duedate.to_date +  (@opeitm_opt_fixoterm||=1) * ( i - 1) ")
			@outcnt += 1
			@outqty += qty
			@outamt += amt 
			org_qty -= save_sch["opeitm_maxqty"]	
			##unless respond_to?("proc_tblink_mkord_trngantts_#{save_sch["trngantt_prdpurshp"] + "ord"}s_self10")
			##	proc_crt_def_tblink("proc_tblink_mkord_trngantts_#{save_sch["trngantt_prdpurshp"] + "ord"}s_self10")
			##end
			__send__("proc_tblink_mkord_trngantts_#{save_sch["trngantt_prdpurshp"] + "ord"}s_self10",allocs)   ###単価はここで求める。
			i += 1
	    end
		allocs.each do |alloc|
			proc_mkord_err({"alloctbl_destblname"=>alloc[:destblname],"alloctbl_destblid"=>alloc[:destblid]},proc_blkgetpobj("オーダへの変換済","msg"))
		end
	end

### instsの機能
    def perform_mkinsts insts
    end
    ##handle_asynchronously :perform_mkinstsv
    def perform_mkacts insts
    end
    handle_asynchronously :perform_mkacts
    def perform_setreplies tbl,id,user_id,prdpurshp ### user_id integer  tbl:回答納期を実行するテーブル
		##crt_def_all  unless respond_to?("dummy_def")
		##  tableは業者毎作業場所ごとにレイアウトが異なることを想定。そのレイアウトに 外部からのデータにcno(instsのcno:外部からのkey)とsno_ord(内部key)は必須
		##rptblname = tbl.singularize.capitalize.constantize
		@sio_classname = "replies_add_perform" ### perform_set
		#####replies aed a:add e:edit d:delete nil:自動判定flgを用意する。
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
		data ={}
		replys.each do |reply|
		begin		### replys 実行要求
			ActiveRecord::Base.connection.begin_db_transaction()
			@incnt = @skipcnt = @outcnt = 0
			@inqty = @outqty = @skipqty = 0
			strsql = "select * from #{reply["tblname"]} where result_f = '0' and persons_id_upd = #{user_id}  order by sno_ord FOR UPDATE "
			inputs = ActiveRecord::Base.connection.select_all(strsql)
			inputs.each do |input|			###回納期が゛セットされているテーブル
				err ={}			
				@incnt += 1 
				@inqty += if prdpurshp =~ /dlv|pic/ then input["qty_stk"] else  input["qty"] end
				if sno_ord != input["sno_ord"] 
					if sno_ord != "" 
						if sum_rply_qty != bal_qty and ord["opeitm_chkord"] == "0"   ###opeitm_chkord 分割回答時で数量不一致は不可--->rubycodesに登録
							err[:remark] = "unmatch Σreply_qty != ord_balacle_qty ; Σreply_qty = #{sum_rply_qty.to_s} ,ord_balance_qty = #{bal_qty}  #{Time.now} ::" + err[:remark][0..3000]
							err[:message_code] = "error_xxxx "
							err[:result_f] = "9"
							@skipcnt += proc_tbl_edit_arel(reply["tblname"],err," sno_ord = #{input["sno_ord"]} and result_f  =  '0' ") 
							@skipqty += sum_rply_qty
						end
					end			
					if prdpurshp =~ /dlv|pic/ 
						strsql = "select #{prdpurshp}ord_sno,#{prdpurshp}ord_qty_stk ord_qty,'0' opeitm_chkord,'1' #{prdpurshp}ord_confirm
							from r_#{prdpurshp}ords  where #{prdpurshp}ord_sno = '#{input["sno_ord"]}' "
					else
						strsql = "select #{prdpurshp}ord_sno,#{prdpurshp}ord_qty ord_qty,opeitm_chkord,#{prdpurshp}ord_confirm
							from r_#{prdpurshp}ords  where #{prdpurshp}ord_sno = '#{input["sno_ord"]}' "
					end
					ord = ActiveRecord::Base.connection.select_one(strsql)	
					if ord.nil?
						err[:remark] = " not found sno =  #{input["sno_ord"]} "
						###err[:message_code] = "error_perform_setreplys_2 "
						err[:result_f] = "9"
						proc_tbl_edit_arel  reply["tblname"],err," sno_ord = #{input["sno_ord"]} and result_f  =  '0' "
						next
					end
					bal_qty =  	ord["ord_qty"]
					##strsql = "select sno_ord,sum(qty) act_qty from #{prdpurshp}acts  where sno_ord = '#{input["sno_ord"]}' group by sno_ord "
					##act = ActiveRecord::Base.connection.select_one(strsql)
					strsql = "select sno_ord,sum(qty) act_qty from #{prdpurshp}insts  where sno_ord = '#{input["sno_ord"]}' group by sno_ord "
					inst = ActiveRecord::Base.connection.select_one(strsql)
					##strsql = "select sno_ord,sum(qty) ret_qty from #{prdpurshp}rets  where sno_ord = '#{input["sno_ord"]}' group by sno_ord "
					##ret = ActiveRecord::Base.connection.select_one(strsql)
					##bal_qty -= if act then act["qty"] else 0 end
					bal_qty -= if inst then inst["qty"] else 0 end
					##bal_qty += if ret then ret["qty"] else 0 end　  #####dummyの時があるので外した。
					sno_ord = input["sno_ord"]				
					cno = input["cno"]
					sum_rply_qty = 0
				end
				sum_rply_qty += if prdpurshp =~ /dlv|pic/ then input["qty_stk"] else  input["qty"] end
			end		
			if sum_rply_qty != bal_qty and ord["opeitm_chkord"] == "0"   ### rubycodeに移行する。
				err ={}
				err[:remark] = "unmatch Σreply_qty != ord_balacle_qty ; Σreply_qty = #{sum_rply_qty.to_s} ,ord_balance_qty = #{bal_qty} "
				err[:message_code] = "error_xxxx "
				err[:result_f] = "9"
				err[:updated_at] = Time.now
				##ctblname.where(:sno_ord=>sno_ord,:result_f => '0').update_all(err)
				proc_tbl_edit_arel(reply["tblname"],err," sno_ord = '#{sno_ord}'  and result_f = '0' ")
				@skipcnt += 1 
				@skipqty += sum_rply_qty
				ActiveRecord::Base.connection.commit_db_transaction()
				ActiveRecord::Base.connection.begin_db_transaction()
				next
			end
			strsql = "select * from #{reply["tblname"]} where result_f = '0' and persons_id_upd = #{user_id}  order by sno_ord FOR UPDATE "
			inputs = ActiveRecord::Base.connection.select_all(strsql)
			sno_ord = ""
			inputs.each do |input|
			begin
				case ord["#{prdpurshp}ord_confirm"] 
					when "0"  ##原則画面でチェック
							err[:remark] = " unconfirm #{Time.now} :: " 
							@skipcnt += proc_tbl_edit_arel(reply["tblname"],err," id = #{input["id"]} ") 
							@skipqty += if prdpurshp =~ /dlv|pic/ then input["qty_stk"] else  input["qty"] end
							next
					when "5"
							err[:remark] = " waiting for sending order  #{Time.now} :: " 
							@skipcnt += proc_tbl_edit_arel(reply["tblname"],err," id = #{input["id"]} ") 
							@skipqty += if prdpurshp =~ /dlv|pic/ then input["qty_stk"] else  input["qty"] end
							next
					when "T"
							err[:remark] = " test date  #{Time.now} :: " 
							err[:result_f] = "8"
							@skipcnt += proc_tbl_edit_arel(reply["tblname"],err," id = #{input["id"]} ") 
							@skipqty += if prdpurshp =~ /dlv|pic/ then input["qty_stk"] else  input["qty"] end
							next
				end
				if sno_ord != input["sno_ord"]  ###既にinstsで登録済ならいったんXXXXINSTSを削除
					strsql = %Q& select * from r_#{prdpurshp}ords  where #{prdpurshp}ord_sno = '#{input["sno_ord"]}' &
					ord = ActiveRecord::Base.connection.select_one(strsql)
					strsql = %Q& select * from r_#{prdpurshp}insts where  id in ( 
								select srctblid from alloctbls where srctblname = '#{prdpurshp}insts' and   destblname = 'alloctbls' and destblid in ( 
								select  id from alloctbls where srctblname = 'trngantts' and  destblname = '#{prdpurshp}ords' and  destblid = #{ord["id"]} ))
								#{if input["cno"] =~ /^dummy/ or input["cno"].nil? then "" else " and "+ prdpurshp + "inst_cno = '" + input["cno"] + "'" end} &
					insts = ActiveRecord::Base.connection.select_all(strsql)
					insts.each do |inst|
						@sio_classname = "replies_delete_"
						##end	
						proc_command_instance_variable inst
						strsql = %Q& select * from alloctbls where  srctblname = 'trngantts' and destblname = '#{prdpurshp}insts' and destblid = #{inst["id"]} and qty > 0 &
						alloctbls = ActiveRecord::Base.connection.select_all(strsql)
						unless respond_to?("proc_tblink_r_rplies_#{prdpurshp}insts_self10")
							proc_crt_def_tblink("proc_tblink_r_rplies_#{prdpurshp}insts_self10")
						end
						__send__("proc_tblink_r_rplies_#{prdpurshp}insts_self10",alloctbls)   ######alloctbls:xxxinstsの引当て情報
					end
				end
				sno_ord = input["sno_ord"]				
				@sio_classname = "replies_add_"
				strsql = %Q& select * from r_#{prdpurshp}ords where  #{prdpurshp}ord_sno = '#{input["sno_ord"]}' &	
				ord = ActiveRecord::Base.connection.select_one(strsql)  ###view
				if prdpurshp =~ /dlv|pic/
					strsql = %Q& select * from alloctbls where  srctblname = 'trngantts' 
				             and destblname = '#{prdpurshp}ords' and destblid = #{ord["id"]} and qty_stk > 0 &
				else
					strsql = %Q& select * from alloctbls where  srctblname = 'trngantts' 
				             and destblname = '#{prdpurshp}ords' and destblid = #{ord["id"]} and qty > 0 &
				end
				alloctbls = ActiveRecord::Base.connection.select_all(strsql) 
				proc_command_instance_variable ord
				##proc_opeitm_instance(ord)
				@reply_qty = if prdpurshp =~ /dlv|pic/ then input["qty_stk"] else  input["qty"] end  ###回答から引き継げる項目は、数量、納期、cno,gnoコメントのみ
				@reply_qty_case = input["qty_case"]   
				@reply_duedate = input["duedate"] ###
				@reply_starttime = if  prdpurshp == "shp" then  input["depdate"] else  input["starttime"] end
				@reply_content = input["contents"]
				@reply_cno = input["cno"]
				@reply_gno = input["gno"]		
				@reply_lotno = input["lotno"]
				@reply_packno = input["packno"]		
				@reply_transport_id = input["transports_id"]
				unless respond_to?("proc_tblink_r_rplies_#{prdpurshp}insts_self10")
					proc_crt_def_tblink("proc_tblink_r_rplies_#{prdpurshp}insts_self10")
				end
				__send__("proc_tblink_r_rplies_#{prdpurshp}insts_self10",alloctbls) ###alloctbls:xxxordsの引当て情報	
				data[:result_f] = "1"
				data[:updated_at] = Time.now
				##ctblname.where(:id =>input["id"]).update_all(data)
				proc_tbl_edit_arel(reply["tblname"],data," id = #{input["id"]} ")
				@outcnt += 1
				@outqty += if prdpurshp =~ /dlv|pic/ then input["qty_stk"] else  input["qty"] end
				ActiveRecord::Base.connection.commit_db_transaction()
				ActiveRecord::Base.connection.begin_db_transaction()
			rescue
				ActiveRecord::Base.connection.rollback_db_transaction()
				logger.debug"error class #{self} #{Time.now}: $@: #{$@} " 
				logger.debug"error class #{self} : $!: #{$!} "
				@skipcnt += 1
				@skipqty = if prdpurshp =~ /dlv|pic/ then input["qty_stk"] else  input["qty"] end
				data[:result_f] = "9"
				data[:updated_at] = Time.now
				data[:remark] = "class #{self} #{Time.now}: $@: #{$@} "[0..3999]
				data[:message_code] = (@errmsg||=" $!:#{$!}"[0..200])
				proc_tbl_edit_arel(reply["tblname"],data," id = #{input["id"]} ")
				ActiveRecord::Base.connection.commit_db_transaction()		
				ActiveRecord::Base.connection.begin_db_transaction()	
				@errmsg = nil
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
			data[:remark] = nil
		    data[:message_code] = nil
			### rptblname.where(:id =>reply["id"]).update_all(data)
			proc_tbl_edit_arel(tbl,data," id = #{reply["id"]}")
			ActiveRecord::Base.connection.commit_db_transaction()
			ActiveRecord::Base.connection.begin_db_transaction()
		rescue
				ActiveRecord::Base.connection.rollback_db_transaction()
				logger.debug"error class #{self} #{Time.now}: $@: #{$@} " 
				logger.debug"error class #{self} : $!: #{$!} "
				@skipcnt = 999
				@skipqty = 9999999
				data[:result_f] = "9"
				data[:updated_at] = Time.now
				data[:remark] = "class #{self} #{Time.now}: $@: #{$@} "[0..3999]
				data[:message_code] = "class #{self} : $!: #{$!} "[0..200]
				proc_tbl_edit_arel(tbl,data," id = #{reply["id"]}")
				ActiveRecord::Base.connection.commit_db_transaction()
		end
		end		
	end
    handle_asynchronously :perform_setreplies
    def perform_setresults id ### user_id integer
	begin
		@pare_class = "batch"
		##crt_def_all  unless respond_to?("dummy_def")
		###rptblname = tbl.singularize.capitalize.constantize
		@sio_classname = "_results_add_perform" ### perform_set
		#####resultの時は常に追加
		cno = ""
		bal_qty = 0
		sum_rply_qty = 0
	    @sio_user_code = 0
		@new_sio_session_counter  = user_seq_nextval
		###同一ユーザで　未処理が対象
		ActiveRecord::Base.connection.begin_db_transaction()	
	    result = ActiveRecord::Base.connection.select_one("select * from results where result_f  = '0' and id = #{id} FOR UPDATE ")
		return if result.nil?  ###   別task実行済?
		prdpurshp = result["prdpurshp"]
		@incnt = @skipcnt = @outcnt = 0
		@inqty = @outqty = @skipqty = 0
		###ctblname = result["tblname"].singularize.capitalize.constantize  ### persons_id_upd  --->resultgnoに変更予定
		strsql = "select * from #{result["tblname"]} where result_f in('0') and persons_id_upd = #{result["persons_id_upd"]} order by sno_inst FOR UPDATE "
		inputs = ActiveRecord::Base.connection.select_all(strsql)
		inputs.each do |input|	
		begin			
			@errmsg = ""
			@incnt += 1 
			@inqty += if prdpurshp =~ /^prd|^pur|^shp/ then  input["qty"] else input["qty_stk"] end
			case 
				when  (input["cno_inst"]||="dummy")  !~ /^dummy/
						strsql = %Q& select *
							from r_#{prdpurshp}insts  where #{prdpurshp}inst_cno = '#{input["cno_inst"]}' and & +
									case prdpurshp
											when "pur"
												prdpurshp+"inst_dealer_id = #{input["dealers_id"]}"  
											else
												prdpurshp+"inst_loca_id = #{input["locas_id"]}"
											end  +  " for update " 
				when  (input["sno_inst"]||="dummy") !~ /^dummy/
						strsql = %Q& select *
								from r_#{prdpurshp}insts where #{prdpurshp}inst_sno  = '#{input["sno_inst"]}'  for update 
												 &
				when  (input["sno_ord"]||="dummy") !~ /^dummy/
						strsql = %Q& select *
								from r_#{prdpurshp}insts where id in(
                                     select srctblid  from alloctbls where srctblname = '#{prdpurshp}insts' and destblname = 'alloctbls' and destblid in(
											select id from alloctbls where srctblname = 'trngantts' and destblname = '#{prdpurshp}ords' and allocfree = 'alloc'
												and  destblid in (select id from #{prdpurshp}ords where sno = '#{input["sno_ord"]}'
												)))  for update &
				when  (input["gno_inst"]||="dummy") !~ /^dummy/
						strsql = %Q& select *
								from r_#{prdpurshp}insts where id in(
										select srctblid  from alloctbls where srctblname = '#{prdpurshp}insts' and destblname = 'alloctbls' and destblid in(
												select id from alloctbls where srctblname = 'trngantts' and destblname = '#{prdpurshp}ords' and allocfree = 'alloc'
												and  destblid in (select id from #{prdpurshp}insts where gno_inst = '#{input["gno_inst"]}'
												)))  for update &
						
				else
						strsql = %Q& select *
								from r_#{prdpurshp}insts where id in(
										select srctblid  from alloctbls where srctblname = '#{prdpurshp}insts' and destblname = 'alloctbls' and destblid in(
												select id from alloctbls where srctblname = 'trngantts' and destblname = '#{prdpurshp}ords' and allocfree = 'alloc'
												)) for update &
			end
			insts = ActiveRecord::Base.connection.select_all(strsql)	
			if insts.empty?
				err ={}
				err[:message_code] = "error_xxx1 "
				err[:remark] = %Q&  not found  #{if input["sno_ord"] then  "sno_ord = " + input["sno_ord"]   end } #{if input["cno_inst"] then "cno_inst =  " + input["cno_inst"] end }   #{if input["sno_inst"] then  "sno_inst = " + input["sno_inst"]   end } & 
				err[:result_f] = "9"
				proc_tbl_edit_arel(result["tblname"],err,"id = #{input["id"]} ")
				@skipcnt += 1 
				@skipqty += if prdpurshp =~ /^prd|^pur|^shp/ then  input["qty"] else input["qty_stk"] end
				ActiveRecord::Base.connection.commit_db_transaction()
				ActiveRecord::Base.connection.begin_db_transaction()
				next
			end
			case prdpurshp
			when   /^pr|^pur|^shp/
				strsql = "select qty from #{prdpurshp}ords  where sno = '#{insts[0]["#{prdpurshp}inst_sno_ord"]}' "
				bal_qty = ActiveRecord::Base.connection.select_value(strsql)				
				strsql = "select sum(qty) act_qty from #{prdpurshp}acts  where sno_inst = '#{insts[0]["#{prdpurshp}inst_sno"]}' group by sno_inst "
				act_qty = ActiveRecord::Base.connection.select_value(strsql)
			when   /^dlv|^pic/
				strsql = "select qty_stk from #{prdpurshp}ords  where sno = '#{insts[0]["#{prdpurshp}inst_sno_ord"]}' "
				bal_qty = ActiveRecord::Base.connection.select_value(strsql)				
				strsql = "select sum(qty_stk) act_qty from #{prdpurshp}acts  where sno = '#{insts[0]["#{prdpurshp}inst_sno"]}' group by sno_inst "
				act_qty = ActiveRecord::Base.connection.select_value(strsql)
			else 
				err = {}
				err[:remark] = " logic error "
				err[:message_code] = "error  prdpurshp: #{prdpurshp}"
				err[:result_f] = "9"
				err[:updated_at] = Time.now
				proc_tbl_edit_arel(input["tblname"],err,"id = #{input["id"]} ")
				@skipcnt += 1 
				@skipqty += sum_rply_qty
				ActiveRecord::Base.connection.commit_db_transaction()
				ActiveRecord::Base.connection.begin_db_transaction()
				next			    
			end
			bal_qty -= (act_qty||= 0)
			##bal_qty += if ret_qty then ret_qty else 0 end  ##返品はordsに紐付かないときもある。
			if bal_qty < (if prdpurshp =~ /^prd|^pur|^shp/ then  input["qty"] else input["qty_stk"] end) and insts[0]["opeitm_chkinst"] == "1"  ###発注数以上の受入は不可
				err = {}
				err[:remark] = " over  act_qty: #{if prdpurshp =~ /^prd|^pur|^shp/ then  input["qty"] else input["qty_stk"] end} > ord_qty: #{bal_qty} "
				err[:message_code] = "error_xxx2 "
				err[:result_f] = "9"
				err[:updated_at] = Time.now
				proc_tbl_edit_arel(input["tblname"],err,"id = #{input["id"]} ")
				@skipcnt += 1 
				@skipqty += sum_rply_qty
				ActiveRecord::Base.connection.commit_db_transaction()
				ActiveRecord::Base.connection.begin_db_transaction()
				next
			end
			data = {}
			insts.each do |inst|			
				@sio_classname = "results_add_"
					strsql = %Q& select * from alloctbls where  srctblname = 'trngantts' 
				             and destblname = '#{prdpurshp}insts' and destblid = #{inst["id"]} 
							 and (qty > 0 or qty_stk >0) 
							  /* and allocfree = 'alloc' */
							  for update &
				alloctbls = ActiveRecord::Base.connection.select_all(strsql) 
				if alloctbls.size > 0
					proc_command_instance_variable inst
					##proc_opeitm_instance(inst)
					@result_qty = input["qty"] if prdpurshp =~ /^prd|^pur|^shp/   ###
					@result_qty_stk =  input["qty_stk"] if prdpurshp =~ /^pic|^dlv/    ###
					@result_qty_case = input["qty_case"]   
					case prdpurshp
						when /prd|pic|dlv/
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
					@result_starttime = input["starttime"]
					@result_content = input["contents"]	
					@result_shelfno_id = input["shelfnos_id_input"]
					@result_transport_id = input["transports_id"]
					@result_person_id = result["persons_id_upd"]
					__send__("proc_tblink_#{prdpurshp}inst_results_#{prdpurshp}acts_self10",alloctbls) ###alloctbls:xxxinstsの引当て情報	
					data[:remark] = nil
					data[:message_code] = nil
					data[:result_f] = "1"
					@outcnt += 1
					@outqty += if prdpurshp =~ /^prd|^pur|^shp/ then  input["qty"] else input["qty_stk"] end
				else
					data[:remark] = "data not found  strsql = #{strsql} "
					@skipcnt += 1 
					data[:result_f] = "8"
				end
				data[:updated_at] = Time.now
				proc_tbl_edit_arel(result["tblname"],data,"id = #{input["id"]} ")
			end
			ActiveRecord::Base.connection.commit_db_transaction()
			ActiveRecord::Base.connection.begin_db_transaction()
		rescue
			ActiveRecord::Base.connection.rollback_db_transaction()
			logger.debug"error class #{self} #{Time.now}: $@: #{$@} " 
			logger.debug"error class #{self} : $!: #{$!} "
			@skipcnt += 1
			@skipqty += if prdpurshp =~ /^prd|^pur|^shp/ then  input["qty"] else input["qty_stk"] end
			data[:result_f] = "9"
			data[:updated_at] = Time.now
			data[:remark] = if @errmsg == "" then "class #{self} #{Time.now}: $@: #{$@} "[0..3999] else @errmsg end
			data[:message_code] = "class #{self} : $!: #{$!} "[0..200]
			proc_tbl_edit_arel(result["tblname"],data,"id = #{input["id"]} ")
			ActiveRecord::Base.connection.commit_db_transaction()
			ActiveRecord::Base.connection.begin_db_transaction()
			@errmsg = ""
		end
		end
		data ={}
		data[:incnt] = @incnt
		data[:inqty] = @inqty
		data[:outcnt] = @outcnt
		data[:outqty] = @outqty
		data[:skipcnt] = @skipcnt
		data[:skipqty] = @skipqty
		data[:result_f] = if @incnt == @outcnt and @inqty == @outqty then "1" else "8" end
		data[:updated_at] = Time.now
		proc_tbl_edit_arel("results",data," id = #{result["id"]} ")
		ActiveRecord::Base.connection.commit_db_transaction()
	rescue
		logger.debug"error class #{self} #{Time.now}: $@: #{$@} " 
		logger.debug"error class #{self} : $!: #{$!} "
	end
	end
    handle_asynchronously :perform_setresults
end