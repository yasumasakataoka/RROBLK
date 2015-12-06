﻿class DbCud  < ActionController::Base
 ## @queue = :default
 ## def self.perform(sio_id,sio_view_name)
 ##　importと 画面でエラー検出すること。
			### とりあえず
## ダイナミックに　モデルを変更　	ctblname = tbl.chop.capitalize.constantize  使用中止　2015/10/01
    def perform(sio_session_counter,sio_user_id,one_by_one)
      begin	
	    @sio_user_code = sio_user_id
        ###plsql.execute "SAVEPOINT before_perform"
       ActiveRecord::Base.connection.begin_db_transaction()
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
					ActiveRecord::Base.connection.commit_db_transaction() if one_by_one == "one_by_one"
				end
			else
				logger.debug " Queue data nothing sio_session_counter = #{sio_session_counter},sio_user_id = #{sio_user_id}"
		    end
		end
		ActiveRecord::Base.connection.commit_db_transaction()
	   rescue
	        if @sio_result_f !=   "9" ##想定外error
                logger.debug"class #{self} #{Time.now}:  $@: #{$@} " 
                logger.debug"class #{self} :  $!: #{$!} "
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
end
class DbSchs  < DbCud    ###
    def perform_mkschs recs
		begin
			@sio_user_code = 0
			ActiveRecord::Base.connection.begin_db_transaction()
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
						@sio_classname = "mksch_perform_edit_"				
						proc_edit_from_trngantts(rec)
					when /_delete_/
						@sio_classname = "mksch_perform_delete_"				
						proc_edit_from_trngantts(rec)
					when /_add_/
					@sio_classname = "perform_mksch_perform_add_"				
					proc_add_trngantts(rec)
				end
				proc_tbl_edit_arel "mkschs", tbl, " id = #{rec["id"]}"   ###insertはtblinks updateはここ　何とかならないか
			end
			dbcud = DbCud.new
			dbcud.perform(@new_sio_session_counter ,@sio_user_code,"") 
			ActiveRecord::Base.connection.commit_db_transaction()
		rescue
		        ###plsql.rollback
				ActiveRecord::Base.connection.rollback_db_transaction()
                logger.debug"class #{self}   #{Time.now}$@: #{$@} " 
                logger.debug"class #{self}   $!: #{$!} " 		
		        rec[:result_f] = "9"  ## error
		        rec[:message_code] = $!.to_s[0..255]
		        rec[:remark] = $@.to_s[0..3999]
		        rec[:updated_at] = Time.now
		        rec[:where] = {:id =>rec[:id]}
		        plsql.mkschs.update tbl
		        ActiveRecord::Base.connection.commit_db_transaction()
		end
    end
    handle_asynchronously :perform_mkschs
	def sql_pre_chk_free_alloc(str_gantt)
		%Q&
			select 		alloc.id alloctbl_id,alloc.srctblname alloctbl_srctblname,alloc.srctblid alloctbl_srctblid,
						alloc.destblname alloctbl_destblname,alloc.destblid alloctbl_destblid,
						alloc.qty free_qty,#{str_gantt["opeitm_loca_id"]} trngantt_loca_id,
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
				proc_tbl_edit_arel("alloctbls",{:qty=>free_tbl["free_qty"]}," id = #{free_tbl["alloctbl_id"]} ")		
				proc_decide_alloc_inout("alloc_edit_",free_tbl["alloctbl_id"])
				destbl[:id] = proc_get_nextval(alloctbls_seq) 
				destbl[:created_at] = Time.now		
				##destbl[:id] = proc_get_nextval(alloctbls_seq) 
				destbl[:srctblid] = free_tbl["alloctbl_srctblid"]
				destbl[:destblname] = "trngantts"
				destbl[:destblid] = str_gantt["trngantt_id"]
				destbl[:allocfee] = "other"
				destbl[:persons_id_upd] = System_person_id
				destbl[:expiredate] = "2099/12/31".to_date
				proc_tbl_add_arel("alloctbls",destbl)	###alloc間の関係 inoutsには関係ない
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
				proc_tbl_edit_arel("alloctbls",{:qty=>chng_qty}," id = #{chil_trn[:alloc_id]}")		
				proc_decide_alloc_inout("alloc_edit_",chil_trn[:alloc_id])
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
					proc_tbl_add_arel("alloctbls",alloc)  ##今の引当てを新しいtrnganttに引き継ぐ			
					proc_decide_alloc_inout("alloc_add_",alloc[:id])			
					alloc[:srctblid] = tg_gantt["gantt_id"]
					alloc[:id] = proc_get_nextval "alloctbls_seq" 
					alloc[:destblname] = chil_trn["alloc_destblname"]
					alloc[:destblid] = chil_trn["alloc_destblid"]
					proc_tbl_add_arel("alloctbls",alloc)   ##新しいｔｒｎｇａｎｔｔに引当てをセットする。
					proc_decide_alloc_inout("alloc_add_",alloc[:id])
					qty = 0
				else
					logger.debug "logic error  line #{__LINE__} "
					logger.debug "str_gantt \n#{str_gantt}"
					logger.debug "chil_trn \n #{chil_trn}"
					logger.debug "strsql \n#{strsql}"
					raise
				end
			end
		end
	end
	def sql_alloc_search rec,sch_ord_inst_act
		org_strwhere = ""
		trn_strwhere = ""
		pare_strwhere = ""
		### orgtblnameの存在チェックを画面でする。 trnganttsのorgtblnameにあること。
		org_show_data = get_show_data "r_#{rec["orgtblname"]}"   if rec["orgtblname"]
		pare_show_data = get_show_data "r_#{rec["paretblname"]}"   if rec["paretblname"]
		trn_show_data = get_show_data "r_#{rec["prdpurshp"]+sch_ord_inst_act}" 
		org_search_key = {}
		pare_search_key = {}
		trn_search_key = {}
		fullord_pare = "0"
		rec.each do |key,val|
   		    next if val.nil?
   		    next if key !~ /_org$/ and key !~ /_trn$/ and key !~ /_pare$/
			next if rec["orgtblname"].nil? and key =~ /org$/
			next if rec["paretblname"].nil? and key =~ /pare$/
			### next if rec["prdpurshp"].nil? and key =~ /trn$/   #rec["prdpurshp"]は必須			
			##tblname,idfield,delm = key.sub(/_org$|_trn$|_pare$/,"").split("_",3)
			nkey = key.sub(/_org$|_trn$|_pare$/,"")
			viewname = case key
			                when /_org$/ 
								"r_#{rec["orgtblname"]}"
							when /_pare$/
								"r_#{rec["paretblname"]}"
							else
								"r_#{rec["prdpurshp"]+sch_ord_inst_act}"
						end
			nkey.sub!("strdate","depdate") if viewname =~ /^r_shp/			
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
    		org_strwhere = %Q& and trngantt_orgtblname = '#{rec["orgtblname"]}'    
							and  trngantt_orgtblid in (select id from   r_#{rec["orgtblname"]} where 
							#{proc_search_key_strwhere(org_search_key,org_strwhere,org_show_data )}
							) &
		end
		if pare_search_key.size >=1
			cmp_keys = ActiveRecord::Base.connection.select_all(%Q& select t.orgtblname,t.orgtblid,t.key ,t.opeitms_id
							from trngantts t ,alloctbls a,r_#{rec["paretblname"]} pare
							where a.srctblname = 'trngantts' and t.id = a.srctblid and   a.qty > 0
							and  a.destblname = '#{rec["paretblname"]}' and a.destblid =  pare.id and 
							#{proc_search_key_strwhere(pare_search_key,pare_strwhere,pare_show_data )}
							&)
			pare_strwhere = " and ("  ###
			cmp_keys.each do |key|   ###
				if fullord_pare == "1"  ###下位の階層すべての部品すべて対象
					pare_strwhere　 <<  %Q& ( trngantt_orgtblname = '#{key["orgtblname"]}' and trngantt_orgtblid = #{key["orgtblid"]}
												and trngantt_key like '#{key["key"]}%'   )   or &
				else ###同一itms_idの直下の子部品のみ
					nditms_id = proc_get_cons_chil(key["opeitms_id"])
					next if nditms_id.empty?   ###同一itms_idで複数のopeitms_idがある時で子部品なし
					str_itms_id = ""
					nditms_id.each do |rec|
						str_itms_id << rec["itm_id_nditm"].to_s + "," 
					end
					pare_strwhere << " ( trngantt_orgtblname = '#{key["orgtblname"]}' and trngantt_orgtblid = #{key["orgtblid"]} 
											and trngantt_key like '#{key["key"]}%'  and trn.opeitm_itm_id in(#{str_itms_id.chop}))   or "
				end
			end
			pare_strwhere = pare_strwhere[0..-5] + ")"
		end
		if trn_search_key.size >=1 
    		trn_strwhere = 	%Q&  and alloctbl_destblid in (select id from r_#{rec["prdpurshp"]+sch_ord_inst_act}  where
								#{proc_search_key_strwhere(trn_search_key,trn_strwhere,trn_show_data)}
								 ) &
		end
		proc_free_to_alloc(pare_strwhere,trn_strwhere,rec) if sch_ord_inst_act == "schs"
		%Q&
			select trngantt_id,trngantt_strdate,trngantt_orgtblname,trngantt_orgtblid,trngantt_key,
			trngantt.opeitm_id trngantt_opeitm_id,trngantt.opeitm_loca_id trngantt_loca_id,trngantt.opeitm_itm_id trngantt_itm_id,
			trngantt.opeitm_prdpurshp opeitm_prdpurshp,trngantt.opeitm_processseq,trngantt_prjno_id,
			alloctbl_id,alloctbl_srctblname,alloctbl_srctblid,alloctbl_destblname,alloctbl_destblid,alloctbl_qty,alloctbl_id,
			trn.#{rec["prdpurshp"]+sch_ord_inst_act.chop}_loca_id_to prdpurshpxxx_loca_id_to,trn.*
		    from r_trngantts trngantt ,r_#{rec["prdpurshp"]+sch_ord_inst_act} trn ,r_alloctbls
		    where  alloctbl_srctblname = 'trngantts' and trngantt_id = alloctbl_srctblid
			and alloctbl_qty > 0 
			and alloctbl_destblname = '#{rec["prdpurshp"]+sch_ord_inst_act}' 
			and alloctbl_destblid = trn.id
		    #{org_strwhere}
		    #{pare_strwhere}
		    #{trn_strwhere}
			#{if sch_ord_inst_act == "acts"
				"order by trn.id"
		 	  else
			  	"order by trngantt.itm_code,trngantt.opeitm_loca_id,
				trn.#{rec["prdpurshp"]+sch_ord_inst_act.chop}_loca_id_to,trngantt.opeitm_processseq,
				trngantt_opeitm_id,trngantt.trngantt_strdate"
			  end}
		&
	end
	###schからord  ordからinst・・・・に変わった時   proc_tblink から呼ばれる
	def proc_free_to_alloc(pare_strwhere,trn_strwhere,rec)  ###
		strsql =
		%Q&
			select trngantt_id,trngantt_strdate,trngantt_orgtblname,trngantt_orgtblid,trngantt_qty,trngantt_duedate,
			trngantt.opeitm_id trngantt_opeitm_id,trngantt.opeitm_loca_id trngantt_loca_id,trngantt.opeitm_itm_id trngantt_itm_id,
			trngantt.opeitm_prdpurshp opeitm_prdpurshp,trngantt.opeitm_processseq,trngantt_prjno_id,
			trngantt.opeitm_shuffle_loca opeitm_shuffle_loca,prj.code prj_code,
			alloctbl_id,alloctbl_srctblname,alloctbl_srctblid,alloctbl_destblname,alloctbl_destblid,alloctbl_qty,
			'9' sortkey,trngantt.opeitm_shuffle_flg opeitm_shuffle_flg,alloctbl_created_at
		    from r_trngantts trngantt ,r_#{rec["prdpurshp"]}ords trn ,r_alloctbls,prjnos prj
		    where  alloctbl_srctblname = 'trngantts' and trngantt_id = alloctbl_srctblid
			and alloctbl_qty > 0 and alloctbl_destblname = '#{rec["prdpurshp"]}ords' and alloctbl_destblid = trn.id
			and trngantt_key = '001' and trngantt_orgtblname = alloctbl_destblname and trngantt_orgtblid = alloctbl_destblid
		    #{pare_strwhere}
		    #{trn_strwhere}
			union
			select trngantt_id,trngantt_strdate,trngantt_orgtblname,trngantt_orgtblid,trngantt_qty,trngantt_duedate,
			trngantt.opeitm_id trngantt_opeitm_id,trngantt.opeitm_loca_id trngantt_loca_id,trngantt.opeitm_itm_id trngantt_itm_id,
			trngantt.opeitm_prdpurshp opeitm_prdpurshp,trngantt.opeitm_processseq,trngantt_prjno_id,
			trngantt.opeitm_shuffle_loca opeitm_shuffle_loca,prj.code prj_code,
			alloctbl_id,alloctbl_srctblname,alloctbl_srctblid,alloctbl_destblname,alloctbl_destblid,alloctbl_qty,
			'7' sortkey,trngantt.opeitm_shuffle_flg opeitm_shuffle_flg,alloctbl_created_at
		    from r_trngantts trngantt ,r_#{rec["prdpurshp"]}insts trn ,r_alloctbls,prjnos prj
		    where  alloctbl_srctblname = 'trngantts' and trngantt_id = alloctbl_srctblid
			and alloctbl_qty > 0 and alloctbl_destblname = '#{rec["prdpurshp"]}insts' and alloctbl_destblid = trn.id
			and trngantt_key = '001' and trngantt_orgtblname = alloctbl_destblname and trngantt_orgtblid = alloctbl_destblid
		    #{pare_strwhere}
		    #{trn_strwhere}
			union
			select trngantt_id,trngantt_strdate,trngantt_orgtblname,trngantt_orgtblid,trngantt_qty,trngantt_duedate,
			trngantt.opeitm_id trngantt_opeitm_id,trngantt.opeitm_loca_id trngantt_loca_id,trngantt.opeitm_itm_id trngantt_itm_id,
			trngantt.opeitm_prdpurshp opeitm_prdpurshp,trngantt.opeitm_processseq,trngantt_prjno_id,
			trngantt.opeitm_shuffle_loca opeitm_shuffle_loca,prj.code prj_code,
			alloctbl_id,alloctbl_srctblname,alloctbl_srctblid,alloctbl_destblname,alloctbl_destblid,alloctbl_qty,
			'5' sortkey,trngantt.opeitm_shuffle_flg opeitm_shuffle_flg,alloctbl_created_at
		    from r_trngantts trngantt ,r_#{rec["prdpurshp"]}acts trn ,r_alloctbls,prjnos prj
		    where  alloctbl_srctblname = 'trngantts' and trngantt_id = alloctbl_srctblid
			and alloctbl_qty > 0 and alloctbl_destblname = '#{rec["prdpurshp"]}acts' and alloctbl_destblid = trn.id
			and trngantt_key = '001' and trngantt_orgtblname = alloctbl_destblname and trngantt_orgtblid = alloctbl_destblid
		    #{pare_strwhere}
		    #{trn_strwhere}
			union
			select trngantt_id,trngantt_strdate,trngantt_orgtblname,trngantt_orgtblid,trngantt_qty,trngantt_duedate,
			trngantt.opeitm_id trngantt_opeitm_id,trngantt.opeitm_loca_id trngantt_loca_id,trngantt.opeitm_itm_id trngantt_itm_id,
			trngantt.opeitm_prdpurshp opeitm_prdpurshp,trngantt.opeitm_processseq,trngantt_prjno_id,
			trngantt.opeitm_shuffle_loca opeitm_shuffle_loca,prj.code prj_code,
			alloctbl_id,alloctbl_srctblname,alloctbl_srctblid,alloctbl_destblname,alloctbl_destblid,alloctbl_qty,
			'3' sortkey,trngantt.opeitm_shuffle_flg opeitm_shuffle_flg,alloctbl_created_at
		    from r_trngantts trngantt ,r_lotstkhists trn ,r_alloctbls,prjnos prj
		    where  alloctbl_srctblname = 'trngantts' and trngantt_id = alloctbl_srctblid
			and alloctbl_qty > 0 and alloctbl_destblname = 'lotstkhists' and alloctbl_destblid = trn.id
			and trngantt_key = '001' and trngantt_orgtblname = alloctbl_destblname and trngantt_orgtblid = alloctbl_destblid
		    #{pare_strwhere}
		    #{trn_strwhere}
			order by trngantt_opeitm_id,sortkey,alloctbl_created_at
		&
		frees = ActiveRecord::Base.connection.select_all(strsql)
		frees.each do |free|
			trn = {}
			trn[:tblname] = free["alloctbl_destblname"]
			trn[:id] = free["alloctbl_destblid"]
			trn[:qty] = free["alloctbl_qty"]
			chng_allocs = ActiveRecord::Base.connection.select_all(vsql_demand_ord(free))
			chng_allocs.each do |c_alloc|
				trn[:qty] = proc_update_base_alloc trn,c_alloc,free["alloctbl_id"]
				break if trn[:qty]  <= 0
			end
			if 	trn[:qty] < free["alloctbl_qty"]
				rec["tblname"] = free["trngantt_orgtblname"]
				rec["tblid"] = free["trngantt_orgtblid"]
				rec["qty"] = free["trngant_qty"]
				rec["duedate"] = free["trngantt_duedate"]
				proc_tbl_edit_arel "trngantt", {:qty=>rec["qty"]}, " id = #{rec["tblid"]}"
				proc_edit_from_trngantts rec
			end
		end
		
	end
	def vsql_demand_ord free
		%Q&
			select trngantt_id,trngantt_strdate,
			trngantt.opeitm_id trngantt_opeitm_id,trngantt.opeitm_loca_id trngantt_loca_id,trngantt.opeitm_itm_id trngantt_itm_id,
			trngantt.opeitm_prdpurshp opeitm_prdpurshp,trngantt.opeitm_processseq,trngantt_prjno_id,
			alloctbl_id,alloctbl_srctblname,alloctbl_srctblid,alloctbl_destblname,alloctbl_destblid,alloctbl_qty,alloctbl_id,trn.* 
		    from r_trngantts trngantt ,r_#{rec["prdpurshp"]}schs trn ,r_alloctbls,prjnos prj
		    where  alloctbl_srctblname = 'trngantts' and trngantt_id = alloctbl_srctblid
			and alloctbl_qty > 0 and alloctbl_destblname = '#{rec["prdpurshp"]}schs' and alloctbl_destblid = trn.id
			and trngantt_prjno_id = prj.id
			and trngantt_key != '001' 
			and trngantt_opeitm_id = #{free["trngantt_opeitm_id"]}
			#{case free["opeitm_prjallocflg"]
					when nil
						" and  trngantt_prjno_id =  " + free["trngantt_prjno_id"]
					when 0
						" and ( trngantt_prjno_id =  " + free["trngantt_prjno_id"] + " or prj_code = 'dummy' )"
					when 1..99
						" and  substr(prj_code,1," + free["opeitm_prjallocflg"].to_s + ") =  " + free["prj_code"][0..(free["opeitm_prjallocflg"]-1)]
						end}
			#{if free["opeitm_shuffle_loca"] == "1"  then "" else   " and trngantt_loca_id = " + free["trngantt_loca_id"] end }
		    #{org_strwhere}
		    #{pare_strwhere}
		    #{trn_strwhere}
			order by trngantt_opeitm_id,
			#{case free["opeitm_shuffle_flg"]
			    when 0,1,5
				   "trngantt.trngantt_created_at"
			   else
					"trngantt.trngantt_duedate"
			  end}
		&
	end
	def vsql_chk_chil_status_abc rec,abc  ### autocreate_ord = a,b,A,B
		%Q&
			select srctblid,destblname,sum(alloctbls.qty) qty from trngantts ,alloctbls
			where orgtblname = '#{rec["trngantt_orgtblname"]}' and orgtblid = #{rec["trngantt_orgtblid"]}
			and key like '#{rec["trngantt_key"]}%' and length(key) = #{rec["trngantt_key"].size + 3}
			and srctblname = 'trngantts' and srctblid = trngantts.id and alloctbls.qty > 0
			#{case abc
					when "a","b"
						" and (destblname = 'lotstkhists'  or destblname like '%acts' )" 
					when "A","B"
						" and (destblname = 'lotstkhists'  or destblname like '%acts' or destblname like '%ords'  or destblname like '%insts') "
					else
						raise
				end}	
			
		&
	end
	def vsql_chk_self_status_abc rec,abc  ### autocreate_ord = c,C
		%Q&
			select srctblid,destblname,sum(alloctbls.qty) qty from alloctbls
			where srctblname = 'trngantts' and srctblid = rec["trngantt_id"] and alloctbls.qty > 0
			#{case abc
					when "c"
						" and (destblname = 'lotstkhists'  or destblname like '%acts') " 
					when "C"
						" and (destblname = 'lotstkhists'  or destblname like '%acts' or destblname like '%ords'  or destblname like '%insts') "  
					else
						raise
				end}	
		&
	end
end
class DbOrds  < DbSchs
    def perform_mkords recs
	  begin
	    @sio_user_code = 0
       ActiveRecord::Base.connection.begin_db_transaction()
	    @new_sio_session_counter  = user_seq_nextval
        @pare_class = "batch"
		@sio_classname = "mkord_perform_add_"	
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
		ActiveRecord::Base.connection.commit_db_transaction()
		rescue
		        plsql.rollback
                logger.debug"class #{self} : #{Time.now} $@: #{$@} " 
                logger.debug"class #{self} :  $!: #{$!} " 		
		        tbl[:result_f] = "9"  ## error
		        tbl[:message_code] = $!.to_s[0..255]
		        tbl[:remark] = $@.to_s[0..3999]
		        tbl[:updated_at] = Time.now
		        tbl[:where] = {:id =>rec["id"]}
		        plsql.mkords.update tbl
		        ActiveRecord::Base.connection.commit_db_transaction()
	  end
    end
    handle_asynchronously :perform_mkords
	def vproc_mkord rec     ###画面項目prdpurshpは必須
	    opeitms_id = 0
		@ord_show_data = get_show_data "r_#{rec["prdpurshp"]}ords"
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
			case  sch["#{rec["prdpurshp"]}sch_autocreate_ord"] ### shp:出庫オーダ作成
				when "0"  ##手動の時は作成しない。
					@skipcnt += 1
					@skipqty += sch["alloctbl_qty"]
					@skipamt += (sch["alloctbl_qty"] * (sch[@schpricesym]||=0))	
					proc_mkord_err sch,"手動のためskip"
					next
				when "a"
					rec = ActiveRecord::Base.connection.sedlect_one(vsql_chk_chil_status_abc(sch,"a"))
					if rec["qty"] < sch["alloctbl_qty"]
						proc_mkord_err sch,"在庫不足"   ###コーディングはまだ
						next
					end	
				when "b"
					err_f = false
					rec = ActiveRecord::Base.connection.sedlect_one(vsql_chk_chil_status_abc(sch,"b"))
					if rec["qty"] < sch["alloctbl_qty"]
						proc_mkord_err sch,"在庫不足"
						err_f = true
					end	
					###   装置のチェック
					next if err_f == true
				when "c"
					rec = ActiveRecord::Base.connection.sedlect_one(vsql_chk_self_status_abc(sch,"c"))
					if rec["qty"] < sch["alloctbl_qty"]
						proc_mkord_err sch,"在庫不足"
						next
					end	
				when "A"
					rec = ActiveRecord::Base.connection.sedlect_one(vsql_chk_chil_status_abc(sch,"A"))
					if rec["qty"] < sch["alloctbl_qty"]
						proc_mkord_err sch,"在庫不足しオーダも不足"
						next
					end	
				when "B"
					err_f = false
					rec = ActiveRecord::Base.connection.sedlect_one(vsql_chk_chil_status_abc(sch,"B"))
					if rec["qty"] < sch["alloctbl_qty"]
						proc_mkord_err sch,"在庫不足しオーダも不足"
						err_f = true
					end	
					###   装置のチェック
					next if err_f == true
				when "C"
					rec = ActiveRecord::Base.connection.sedlect_one(vsql_chk_self_status_abc(sch,"c"))
					if rec["qty"] < sch["alloctbl_qty"]
						proc_mkord_err sch,"在庫不足しオーダも不足"
						next
					end	
				else
				### no check
			end
		    if opeitms_id != sch["trngantt_opeitm_id"]
			    vproc_mkord_create_ord(save_sch,allocs) if opeitms_id != 0 
			    save_sch = sch.dup
				##proc_opeitm_instance (save_sch) ###set 
				opeitms_id = save_sch["trngantt_opeitm_id"]
				@free_qty = 0
				allocs =[]
				allocs << sch
			else
				save_sch["opeitm_maxqty"] = 9999999999 if (save_sch["opeitm_maxqty"]||=0) <= 0
                if  save_sch["opeitm_maxqty"] <= (save_sch["alloctbl_qty"] + sch["alloctbl_qty"]) or 
				    sch["trngantt_strdate"].to_date >= (save_sch["trngantt_strdate"].to_date + (save_sch["opeitm_opt_fixoterm"]||=999)) or
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
				allocs << sch
		    end
		end
		if allocs.size >0
			vproc_mkord_create_ord(save_sch,allocs)  if save_sch["alloctbl_qty"] > 0
		end
	end
    def vproc_mkord_create_ord save_sch,allocs ###日付(opeitm_opt_fixoterm)による数量まとめは済んでいる。
		 ## 包装単位での発注出庫　ロット単位での製造
		@ord = {}
	    org_qty = 	if save_sch["opeitm_packqty"] == 0 or save_sch["opeitm_packqty"].nil?
						save_sch["alloctbl_qty"].to_f
					else
						(save_sch["alloctbl_qty"].to_f/save_sch["opeitm_packqty"].to_f).ceil *  save_sch["opeitm_packqty"]
					end
		@free_qty = org_qty - save_sch["alloctbl_qty"]
		schtblnamechop = save_sch["opeitm_prdpurshp"] + "sch"
		ordtblnamechop = save_sch["opeitm_prdpurshp"] + "ord"
		proc_command_instance_variable save_sch   ###@xxxsch_yyyy 作成
		@ord[(ordtblnamechop+"_strdate").to_sym]  = save_sch[(schtblnamechop+"_strdate")]
		@ord[(ordtblnamechop+"_depdate").to_sym]  = save_sch[(schtblnamechop+"_depdate")]    ### shpschs
		@ord[(ordtblnamechop+"_duedate").to_sym]  = save_sch[(schtblnamechop+"_duedate")]
		save_sch["opeitm_maxqty"] = 99999999999 if save_sch["opeitm_maxqty"] <= 0
        until org_qty <= 0
		    ## maxqtyはpackqtyの整数倍であること。
	        qty = @ord[(ordtblnamechop+"_qty").to_sym] = if save_sch["opeitm_maxqty"] < org_qty then save_sch["opeitm_maxqty"] else org_qty end
	        amt = @ord[(ordtblnamechop+"_amt").to_sym] = qty * (save_sch[(ordtblnamechop+"_price")]||=0)  ###単価概算
	        @ord[(ordtblnamechop+"_qty_case").to_sym] = if save_sch["opeitm_packqty"] == 0 or save_sch["opeitm_packqty"].nil?
																qty
														else
																qty /  save_sch["opeitm_packqty"]
														end
			@outcnt += 1
			@outqty += qty
			@outamt += amt 
			org_qty -= save_sch["opeitm_maxqty"]	
			__send__("proc_tblink_mkord_trngantts_#{ordtblnamechop}s_self10",allocs)   ###単価はここで求める。
			###@ord[(ordtblnamechop+"_strdate").to_sym]  -= if (save_sch[:opeitm_opt_fixoterm]||=999) >=999 then 1 else save_sch[:opeitm_opt_fixoterm] end 
			###@ord[(ordtblnamechop+"_duedate").to_sym]  -= if (save_sch[:opeitm_opt_fixoterm]||=999) >=999 then 1 else save_sch[:opeitm_opt_fixoterm] end
	    end		
	end
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
		@sio_classname = "mkinst_perform_add_"
       ActiveRecord::Base.connection.begin_db_transaction()
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
		ActiveRecord::Base.connection.commit_db_transaction()
		rescue
		        plsql.rollback
                logger.debug"class #{self} : #{Time.now} $@: #{$@} " 
                logger.debug"class #{self} :  $!: #{$!} " 		
		        rec[:result_f] = "9"  ## error
		        rec[:message_code] = $!.to_s[0..255]
		        rec[:remark] = $@.to_s[0..3999]
		        rec[:updated_at] = Time.now
		        rec[:where] = {:id =>rec[:id]}
		        plsql.mkinsts.update rec
		        ActiveRecord::Base.connection.commit_db_transaction()
	  end
    end
    handle_asynchronously :perform_mkinsts
	def vproc_mkinst rec		
		@inst_show_data = get_show_data "r_#{rec["prdpurshp"]}insts"
		bal_ords = ActiveRecord::Base.connection.select_all(sql_alloc_search(rec,"ords"))   ### 
		@incnt = bal_ords.size
		@skipcnt = @outcnt = 0
		@inqty = @outqty = @skipqty = 0
		@inamt = @outamt = @skipamt = 0
		@ordpricesym = (rec["prdpurshp"] + "ord_price")
		save_ord = {}
		allocs =[]		
		opeitms_id = 0
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
		    if opeitms_id != ord["trngantt_opeitm_id"]
			    vproc_mkinst_create_inst(save_ord,allocs,rec["qty"]) if opeitms_id != 0 					   
			    save_ord = ord.dup
				##proc_opeitm_instance (ord) ###set 
				opeitms_id = ord["trngantt_opeitm_id"]
				allocs =[]
			else
				save_ord["alloctbl_qty"] += ord["alloctbl_qty"]
			end		
			allocs << ord
		end
		if allocs.size >0
			vproc_mkinst_create_inst(save_ord,allocs,rec["qty"])  if save_ord["alloctbl_qty"] > 0
		end
	end
    def vproc_mkinst_create_inst save_ord,allocs,qty ###
		@inst = {}  ### proc_fld_mkinst_trngantts_xxxinsts_self10   proc_fld_xxxx  は引数なしで自動生成のため@にした。
		ordtblnamechop = save_ord["opeitm_prdpurshp"] + "ord"
		insttblnamechop = save_ord["opeitm_prdpurshp"] + "inst"
		proc_command_instance_variable save_ord  ###@xxxord_yyyy 作成
		@inst[:strdate]  = save_ord[(ordtblnamechop+"_strdate")]
		@inst[:duedate]  = save_ord[(ordtblnamechop+"_duedate")]
		org_qty = if qty <= save_ord[(ordtblnamechop+"_qty")] then qty else save_ord[(ordtblnamechop+"_qty")] end 
	    @inst[:qty] = org_qty 
	    amt = @inst[:amt] = org_qty * (save_ord[(ordtblnamechop+"_price").to_sym]||=0)
	    @inst[:qty_case] = org_qty /  save_ord["opeitm_packqty"]
		@outcnt += 1
		@outqty += qty
		@outamt += amt 
		__send__("proc_tblink_mkinst_trngantts_#{insttblnamechop}s_self10",allocs)	#### 
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
       ActiveRecord::Base.connection.begin_db_transaction()
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
		ActiveRecord::Base.connection.commit_db_transaction()
		rescue
		        plsql.rollback
                logger.debug"class #{self} : #{Time.now} $@: #{$@} " 
                logger.debug"class #{self} :  $!: #{$!} " 		
		        rec[:result_f] = "9"  ## error
		        rec[:message_code] = $!.to_s[0..255]
		        rec[:remark] = $@.to_s[0..3999]
		        rec[:updated_at] = Time.now
		        rec[:where] = {:id =>rec[:id]}
		        plsql.mkords.update rec
		        ActiveRecord::Base.connection.commit_db_transaction()
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
		##logger.debug "line #{__LINE__}  \n sql_realloc_search(rec) #{sql_realloc_search(rec)}"
		save_inst = {}
		allocs =[]		
		trn_id = 0
		rec["qty"] ||= 0
		inst_allocs.each do |inst|
		    @inqty += inst["alloctbl_qty"]
			@inamt += (inst["alloctbl_qty"] * (inst[@ordpricesym]||=0))
		    if trn_id != inst[trnidsym]   ### xxxxxinsts_id毎に受け入れをする。
			    vproc_mkact_create_act(save_inst,allocs,rec) if trn_id != 0 					   
			    save_inst = inst.dup
				##proc_opeitm_instance (inst) ###set @opeitm
				trn_id = inst[trnidsym]
				allocs =[]
			else
				save_inst["alloctbl_qty"] += inst["alloctbl_qty"]
			end		
			allocs << inst
		end
		if allocs.size >0
			vproc_mkact_create_act(save_inst,allocs,rec)  if save_inst[:alloctbl_qty] > 0
		end
	end
    def vproc_mkact_create_act save_inst,allocs,rec ###   開始日は受入日
		@act = {}
		acttblnamechop = save_inst["opeitm_prdpurshp"] + "act"
		insttblnamechop = save_inst["opeitm_prdpurshp"] + "inst"
		proc_command_instance_variable save_inst  ###@xxxinst_yyyy 作成
		@act[(acttblnamechop+"_strdate").to_sym]  = rec["rcptdate"]
		@act[(acttblnamechop+"_duedate").to_sym]  = save_inst[(insttblnamechop+"_duedate")]
		qty = if rec["sno_ord"] then rec["qty"] else save_inst[(insttblnamechop+"_qty")] end 
	    @inst[(insttblnamechop+"_qty").to_sym] = qty 
		### 指示数以上の受入、出庫実績を許すかどうかはopeitm でし画面でもチェックするしここでもチェックする。  コーディングがまだ
	    amt = save_inst[(rec["prdpurshp"] + "inst_price")]
	    @act[(acttblnamechop+"_qty_case").to_sym] = qty /  save_inst["opeitm_packqty"]
		@outcnt += 1
		@outqty += qty
		@outamt += amt ###受入時単価決定の時はここの金額と異なる。
		__send__("proc_tblink_mkact_trngantts_#{acttblnamechop}s_self10",allocs)
	end
end	
class DbReplies  < DbOrds
    def perform_setreplies tbl,id,user_id,prdpurshp ### user_id integer
		##  tableは業者毎作業場所ごとにレイアウトが異なることを想定。そのレイアウトに 外部からのデータにcno(instsのcno:外部からのkey)とsno_ord(内部key)は必須
	 begin
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
		replys.each do |reply|		
			ActiveRecord::Base.connection.begin_db_transaction()
			@incnt = @skipcnt = @outcnt = 0
			@inqty = @outqty = @skipqty = 0
			strsql = "select * from #{reply["tblname"]} where result_f = '0' and persons_id_upd = #{user_id}  order by sno_ord FOR UPDATE "
			inputs = ActiveRecord::Base.connection.select_all(strsql)
			inputs.each do |input|			
				err ={}			
				@incnt += 1 
				@inqty += input["qty"]
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
					strsql = "select #{prdpurshp}ord_sno,#{prdpurshp}ord_qty ord_qty,opeitm_chkord
							from r_#{prdpurshp}ords  where #{prdpurshp}ord_sno = '#{input["sno_ord"]}' "
					ord = ActiveRecord::Base.connection.select_one(strsql)	
					if ord.nil?
						err[:remark] = " not found sno =  #{input["sno_ord"]} "
						###err[:message_code] = "error_perform_setreplys_2 "
						err[:result_f] = "9"
						proc_tbl_edit_arel  reply["tblname"],err," sno_ord = #{input["sno_ord"]} and result_f  =  '0' "
						next
					end
					case ord["confirm"] 
						when "0"
							err[:remark] = " unconfirm #{TIme.now} :: " 
							@skipcnt += proc_tbl_edit_arel(reply["tblname"],err," id = #{input["id"]} ") 
							@skipqty += input["qty"]
							next
						when "5"
							err[:remark] = " waiting for sending order  #{TIme.now} :: " 
							@skipcnt += proc_tbl_edit_arel(reply["tblname"],err," id = #{input["id"]} ") 
							@skipqty += input["qty"]
							next
						when "T"
							err[:remark] = " test date  #{TIme.now} :: " 
							err[:result_f] = "8"
							@skipcnt += proc_tbl_edit_arel(reply["tblname"],err," id = #{input["id"]} ") 
							@skipqty += input["qty"]
							next
				end
					bal_qty =  	ord["ord_qty"]
					strsql = "select sno_ord,sum(qty) act_qty from #{prdpurshp}acts  where sno_ord = '#{input["sno_ord"]}' group by sno_ord "
					act = ActiveRecord::Base.connection.select_one(strsql)
					strsql = "select sno_ord,sum(qty) act_qty from #{prdpurshp}acts  where sno_ord = '#{input["sno_ord"]}' group by sno_ord "
					inst = ActiveRecord::Base.connection.select_one(strsql)
					##strsql = "select sno_ord,sum(qty) ret_qty from #{prdpurshp}rets  where sno_ord = '#{input["sno_ord"]}' group by sno_ord "
					##ret = ActiveRecord::Base.connection.select_one(strsql)
					bal_qty -= if act then act["qty"] else 0 end
					bal_qty -= if inst then inst["qty"] else 0 end
					##bal_qty += if ret then ret["qty"] else 0 end　  #####dummyの時があるので外した。
					sno_ord = input["sno_ord"]				
					cno = input["cno"]
					sum_rply_qty = 0
				end
				sum_rply_qty += input["qty"]
			end		
			if sum_rply_qty != bal_qty and ord["opeitm_chkord"] == "0"
				err ={}
				err[:remark] = "unmatch Σreply_qty != ord_balacle_qty ; Σreply_qty = #{sum_rply_qty.to_s} ,ord_balance_qty = #{bal_qty} "
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
						strsql = %Q& select * from r_alloctbls where  alloctbl_srctblname = 'trngantts' and alloctbl_destblname = '#{prdpurshp}insts' and alloctbl_destblid = #{inst["id"]} and alloctbl_qty > 0 &
						alloctbls = ActiveRecord::Base.connection.select_all(strsql)
						__send__("proc_tblink_r_rplies_#{prdpurshp}insts_self10",alloctbls)   ######alloctbls:xxxinstsの引当て情報
					end
				end
				sno_ord = input["sno_ord"]				
				@sio_classname = "replies_add_"
				strsql = %Q& select * from r_#{prdpurshp}ords where  #{prdpurshp}ord_sno = '#{input["sno_ord"]}' &	
				ord = ActiveRecord::Base.connection.select_one(strsql)  ###view
				strsql = %Q& select * from r_alloctbls where  alloctbl_srctblname = 'trngantts' 
				             and alloctbl_destblname = '#{prdpurshp}ords' and alloctbl_destblid = #{ord["id"]} and alloctbl_qty > 0 &
				alloctbls = ActiveRecord::Base.connection.select_all(strsql) 
				proc_command_instance_variable ord
				##proc_opeitm_instance(ord)
				@reply_qty = input["qty"]   ###回答から引き継げる項目は、数量、納期、cno,gnoコメントのみ
				@reply_qty_case = input["qty_case"]   
				@reply_duedate = input["duedate"] ###
				@reply_strdate = if  prdpurshp == "shp" then  input["depdate"] else  input["strdate"] end
				@reply_content = input["contents"]
				@reply_cno = input["cno"]
				@reply_gno = input["gno"]		
				__send__("proc_tblink_r_rplies_#{prdpurshp}insts_self10",alloctbls) ###alloctbls:xxxordsの引当て情報		
				data ={}
				data[:result_f] = "1"
				data[:updated_at] = Time.now
				##ctblname.where(:id =>input["id"]).update_all(data)
				proc_tbl_edit_arel(reply["tblname"],data," id = #{input["id"]} ")
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
			### rptblname.where(:id =>reply["id"]).update_all(data)
			proc_tbl_edit_arel(tbl,data," id = #{reply["id"]}")
			ActiveRecord::Base.connection.commit_db_transaction()
		end
	   rescue
                logger.debug"class #{self} : #{Time.now} $@: #{$@} " 
                logger.debug"class #{self} :  $!: #{$!} "
				ActiveRecord::Base.connection.rollback_db_transaction()
      end		
	end
    handle_asynchronously :perform_setreplies
end		
class DbResults  < DbOrds
    def perform_setresults tbl,id,user_id,prdpurshp ### user_id integer
	begin
		ActiveRecord::Base.connection.begin_db_transaction()
		###rptblname = tbl.singularize.capitalize.constantize
		@sio_classname = "_results_add_perform" ### perform_set
		#####resultの時は常に追加
		cno = ""
		bal_qty = 0
		sum_rply_qty = 0
	    @sio_user_code = 0
		@new_sio_session_counter  = user_seq_nextval
		@pare_class = "batch"
		str_id = if id then " and id = #{id} " else "" end
		###同一ユーザで　未処理　又はskip分が対象
	    results = ActiveRecord::Base.connection.select_all("select * from #{tbl} where result_f  = '0' and persons_id_upd = #{user_id} #{str_id} FOR UPDATE ")
		results.each do |result|		
			@incnt = @skipcnt = @outcnt = 0
			@inqty = @outqty = @skipqty = 0
			###ctblname = result["tblname"].singularize.capitalize.constantize
			strsql = "select * from #{result["tblname"]} where result_f in('0') and persons_id_upd = #{user_id} order by sno_ord FOR UPDATE "
			inputs = ActiveRecord::Base.connection.select_all(strsql)
			inputs.each do |input|				
				@incnt += 1 
				@inqty += input["qty"]
				case 
					when  (input["cno_inst"]||="dummy")  !~ /^dummy/
						strsql = %Q& select *
							from r_#{prdpurshp}insts  where #{prdpurshp}inst_cno = '#{input["cno_inst"]}' and & +
									case prdpurshp
											when "pur"
												prdpurshp+"inst_dealer_id = #{input["dealers_id"]}"  
											else
												prdpurshp+"inst_loca_id = #{input["locas_id"]}"
											end  
					when  (input["sno_inst"]||="dummy") !~ /^dummy/
						strsql = %Q& select *
								from r_#{prdpurshp}insts where #{prdpurshp}inst_sno  = '#{input["sno_inst"]}'
												 &
					when  (input["sno_ord"]||="dummy") !~ /^dummy/
						strsql = %Q& select *
								from r_#{prdpurshp}insts where id in(
                                     select srctblid  from alloctbls where srctblname = '#{prdpurshp}insts' and destblname = 'alloctbls' and destblid in(
											select id from alloctbls where srctblname = 'trngantts' and destblname = '#{prdpurshp}ords' and allocfree = 'alloc'
												and  destblid in (select id from #{prdpurshp}ords where sno = '#{input["sno_ord"]}'
												))) &
					when  (input["gno_inst"]||="dummy") !~ /^dummy/
						strsql = %Q& select *
								from r_#{prdpurshp}insts where id in(
										select srctblid  from alloctbls where srctblname = '#{prdpurshp}insts' and destblname = 'alloctbls' and destblid in(
												select id from alloctbls where srctblname = 'trngantts' and destblname = '#{prdpurshp}ords' and allocfree = 'alloc'
												and  destblid in (select id from #{prdpurshp}insts where gno_inst = '#{input["gno_inst"]}'
												))) &
						
					else
						strsql = %Q& select *
								from r_#{prdpurshp}insts where id in(
										select srctblid  from alloctbls where srctblname = '#{prdpurshp}insts' and destblname = 'alloctbls' and destblid in(
												select id from alloctbls where srctblname = 'trngantts' and destblname = '#{prdpurshp}ords' and allocfree = 'alloc'
												)) &
				end
				insts = ActiveRecord::Base.connection.select_all(strsql)	
				if insts.empty?
					err ={}
					err[:message_code] = "error_xxx1 "
					err[:remark] = %Q&  not found  #{if input["sno_ord"] then  "sno_ord = " + input["sno_ord"]   end } #{if input["cno_inst"] then "cno_inst =  " + input["cno_inst"] end }   #{if input["sno_inst"] then  "sno_inst = " + input["sno_inst"]   end } & 
					err[:result_f] = "9"
					##ctblname.where(:id=>input["id"]).update_all(err)
					proc_tbl_edit_arel(result["tblname"],err,"id = #{input["id"]} ")
					@skipcnt += 1 
					@skipqty += input["qty"]
					next
				end
				strsql = "select qty from #{prdpurshp}ords  where sno = '#{insts[0]["#{prdpurshp}inst_sno_ord"]}' "
				bal_qty = ActiveRecord::Base.connection.select_value(strsql)				
				strsql = "select sum(qty) act_qty from #{prdpurshp}acts  where sno_ord = '#{insts[0]["#{prdpurshp}inst_sno_ord"]}' group by sno_ord "
				act_qty = ActiveRecord::Base.connection.select_value(strsql)
				##strsql = "select sum(qty) ret_qty from #{prdpurshp}rets  where sno_ord = '#{insts[0]["#{prdpurshp}inst_sno_ord"]}' group by sno_ord "
				##ret_qty = ActiveRecord::Base.connection.select_value(strsql)
				bal_qty -= if act_qty then act_qty else 0 end
				##bal_qty += if ret_qty then ret_qty else 0 end  ##返品はordsに紐付かないときもある。
				if bal_qty < input["qty_bal"] and insts[0]["opeitm_chkinst"] == "1"  ###発注数以上の受入は不可
					err = {}
					err[:remark] = " over  act_qty: #{input["qty_bal"]} > ord_qty: #{bal_qty} "
					err[:message_code] = "error_xxx2 "
					err[:result_f] = "9"
					err[:updated_at] = Time.now
					proc_tbl_edit_arel(input["tblname"],err,"id = #{input["id"]} ")
					@skipcnt += 1 
					@skipqty += sum_rply_qty
					next
				end
				insts.each do |inst|			
					@sio_classname = "results_add_"
					strsql = %Q& select * from r_alloctbls where  alloctbl_srctblname = 'trngantts' 
				             and alloctbl_destblname = '#{prdpurshp}insts' and alloctbl_destblid = #{inst["id"]} 
							 and alloctbl_qty > 0 and alloctbl_allocfree = 'alloc' &
					alloctbls = ActiveRecord::Base.connection.select_all(strsql) 
					data ={}
					if alloctbls.size > 0
						proc_command_instance_variable inst
						##proc_opeitm_instance(inst)
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
						@outcnt += 1
						@outqty += input["qty"]
						__send__("proc_tblink_r_results_#{prdpurshp}acts_self10",alloctbls) ###alloctbls:xxxinstsの引当て情報	
						data[:remark] = ""
						data[:result_f] = "1"
					else
						data[:remark] = "data not found  strsql = #{strsql} "
						data[:result_f] = "8"
					end
					data[:result_f] = "1"
					data[:updated_at] = Time.now
					proc_tbl_edit_arel(result["tblname"],data,"id = #{input["id"]} ")
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
			###rptblname.where(:id =>result["id"]).update_all(data)
			proc_tbl_edit_arel(tbl,data," id = #{result["id"]} ")
		end
	   rescue
				ActiveRecord::Base.connection.rollback_db_transaction()
                logger.debug"class #{self} #{Time.now}: $@: #{$@} " 
                logger.debug"class #{self} : $!: #{$!} "
    end
	ActiveRecord::Base.connection.commit_db_transaction()
	end
    handle_asynchronously :perform_setresults
end		