﻿class DbCud  < ActionController::Base
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
        tg_tbls = plsql.select(:all,"select * from userproc#{@sio_user_code.to_s}s where session_counter = #{sio_session_counter}")
		tg_tbls.each do |tg_tbl|   ###複数のテーブルを同一セッションで処理
		    ### sio_session_counter --> session group id   sio_session_id-->group 内　id
            command_cs = plsql.select(:all,sql_perform(tg_tbl[:tblname],sio_session_counter))
            r_cnt0 = tg_tbl[:cnt_out]||=0
		    tblname = command_cs[0][:sio_viewname].split("_",2)[1] 
            command_cs.each do |i|  ##テーブル、画面の追加処理  #複数のレコードを処理
				r_cnt0 += 1
				@sio_classname = i[:sio_classname]
                proc_update_table i,r_cnt0 ### 本体
                reset_show_data_screen if tblname =~ /screen|pobjgrps/   ###キャッシュを削除
                ##
				strsql = " update userproc#{@sio_user_code.to_s}s set cnt_out = #{r_cnt0},status = 'normal end' ,updated_at = current_date
				           where session_counter = #{sio_session_counter} and tblname = '#{tg_tbl[:tblname]}' "
		        ActiveRecord::Base.connection.execute(strsql)
                plsql.commit if one_by_one == "one_by_one"
		    end
		end								
        plsql.commit
        plsql.connection.autocommit = true
	   rescue
	        if @sio_result_f !=   "9" ##想定外error
                fprnt"class #{self} : LINE #{__LINE__} $@: #{$@} " 
                fprnt"class #{self} : LINE #{__LINE__} $!: #{$!} "
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
	def proc_update_gantt_alloc_fm_trn trn,allocs,trngantt_id  ### allocs:ord等の作成元　ordなら　sch; trngantt_id xxxschsの作成時
		self_gantt = proc_create_self_gantt yield   ###schやord自身のtrngantts作成
		str_alloctbl = {}		
		new_alloc = {}	
		new_alloc[:srctblname] = "trngantts"
		new_alloc[:destblname] = "#{@opeitm[:prdpurshp] + yield}"
		new_alloc[:srctblid] = self_gantt["id"]	
		new_alloc[:destblid] = trn[:id]
		if allocs  ##trn = ords or insts ・・・・
			new_alloc[:qty] = trn[:qty] 
			new_alloc_id = proc_create_new_or_replace_alloc(new_alloc)    ###基本形作成 最初未引当てとして作成
			allocs.each do |alloc|
				trn[:qty]  = vproc_update_base_alloc trn,alloc,new_alloc_id do
								yield
							end
			end
		else   ###trn = str_gantt ##xxxschsの時
			if trngantt_id   ###tranganttを展開して作成
				new_alloc[:qty] = 0
				proc_create_new_or_replace_alloc(new_alloc)
				new_alloc[:qty] = trn[:qty] ### allocs.nilで　trn[:qty] != trngantt_qtyはあり得ない  
				new_alloc[:srctblid] = trngantt_id
				proc_create_new_or_replace_alloc(new_alloc)
			else   ### xxxschsを直接入力
				new_alloc[:qty] = trn[:qty]
				proc_create_new_or_replace_alloc(new_alloc)    ###基本形作成
			end
		end
		proc_update_inputs(new_alloc[:destblname],new_alloc[:destblid],allocs,trngantt_id)
    end	
	def proc_update_inputs(tblname,tblid,ary_alloc,trngantt_id)
		strsql = %Q& select * from r_#{tblname}  where  id = #{tblid} &
		org_rec = ActiveRecord::Base.connection.select_one(strsql)
		if  ary_alloc
			ary_alloc.each do |alloc|   ###xxxschsの新規の時 ary_alloc =　nil
				__send__(%Q&proc_tblink_r_alloctbls_#{tblname}_inouts_self10&,org_rec,alloc["alloctbl_qty"],trngantt_id)
				Inout.delete_all(%Q& tblname = '#{alloc["alloctbl_destblname"]}'	and	tblid = #{alloc["alloctbl_destblid"]} &)
				strsql = %Q& select * from alloctbls where destblname = '#{alloc["alloctbl_destblname"]}'
												and	destblid = #{alloc["alloctbl_destblid"]} and srctblname = 'trngantts' and qty > 0 &
				recs = ActiveRecord::Base.connection.select_all(strsql)
				if recs.size > 0
					strsql = %Q& select * from r_#{alloc["alloctbl_destblname"]} where  id=  #{alloc["alloctbl_destblid"]}  &
					srctbl = ActiveRecord::Base.connection.select_one(strsql)
					recs.each do |rec|
						__send__(%Q&proc_tblink_r_alloctbls_#{alloc["alloctbl_destblname"]}_inouts_self10&,srctbl,rec["qty"],rec["srctblid"]) 
					end
				end 
			end
		else
			__send__(%Q&proc_tblink_r_alloctbls_#{tblname}_inouts_self10&,org_rec,nil,trngantt_id)
		end
	end
	def vproc_update_base_alloc trn,alloc,new_alloc_id
		based_alloc  = {}
		alloc.each do |key,val|
			if key.to_s =~ /alloctbl/
				nk = key.split("_",2)[1].sub("_id","s_id").to_sym
				based_alloc[nk] = val
			end
		end
		based_alloc[:qty] = if  alloc["alloctbl_qty"] <= trn[:qty] then 0 else alloc["alloctbl_qty"] - trn[:qty] end 
		based_alloc[:where] = {:id=>alloc["alloctbl_id"]}
		plsql.alloctbls.update based_alloc   ## 上位ステータスに変更になったため、元を減	
		based_alloc[:srctblname] = "#{@opeitm[:prdpurshp] + yield}"
		based_alloc[:srctblid] = trn[:id]	
		based_alloc[:destblname] = "alloctbls"
		based_alloc[:destblid] = alloc["alloctbl_id"]
		alloc[:allocfree] = "other"
		based_alloc[:qty] = alloc["alloctbl_qty"] - based_alloc[:qty]
		proc_create_new_or_replace_alloc  based_alloc  ###引当て履歴を作成 変更
		based_alloc[:srctblname] = alloc["alloctbl_srctblname"]
		based_alloc[:srctblid] = alloc["alloctbl_srctblid"]
		based_alloc[:destblname] = "#{@opeitm[:prdpurshp] + yield}"
		based_alloc[:destblid] = trn[:id]
		alloc[:allocfree] = "alloc"
		based_alloc[:qty] = if  alloc["alloctbl_qty"] <= trn[:qty] then alloc["alloctbl_qty"] else trn[:qty] end
		proc_create_new_or_replace_alloc based_alloc    ## 引当てを　schからord  又はordからinstへ　
		org_new_alloc = {}
		org_new_alloc[:where] = {:id=>new_alloc_id}
		org_new_alloc[:qty] = trn[:qty] - based_alloc[:qty] 
		plsql.alloctbls.update org_new_alloc  ###未引当て分を減	
		return org_new_alloc[:qty]
	end
	def proc_create_new_or_replace_alloc alloc
		case @sio_classname
			when /_add_/
				alloc[:id] = proc_get_nextval "alloctbls_seq" 
				alloc[:created_at] = Time.now
				alloc[:updated_at] = Time.now
				alloc[:persons_id_upd] = ActiveRecord::Base.connection.select_value("select id from persons where code = '0'")
				Alloctbl.create alloc
			when /_edit_|_delete_/
				strsql = %Q& select * from alloctbls where srctblname = 'trngantts' and destblname = '#{alloc[:destblname]}' 
							and destblid = #{alloc[:destblid]} order by id desc &
				c_allocs = ActiveRecord::Base.connection.select_all(strsql)
				raise if c_allocs.size == 0 ##logic error
				qty = 0
				alloc[:qty] = 0 if @sio_classname =~ /_delete_/
				c_allocs.each do |c_alloc|
					if alloc[:qty] < qty + c_alloc["qty"]
						c_alloc["qty"] = alloc[:qty] - qty
						Alloctbl.update(c_alloc["id"],:qty=>c_alloc["qty"])
						vproc_return_alloc c_alloc
					end
					qty += c_alloc["qty"]
				end 
				if alloc[:qty] > qty  ###数量増された時
					strsql = %Q& select alloctbls.id id from trngantts,alloctbls where trngantts.orgtblname = '#{alloc[:destblname]}' and trngantts.orgtblid = #{alloc[:destblid]} and trngantts.key = '001'
									and alloctbls.srctblname = 'trngantts' and trngantts.id = alloctbls.srctblid and alloctbls.destblname = '#{alloc[:destblname]}' and alloctbls.destblid = #{alloc[:destblid]}  &
					free_alloc = ActiveRecord::Base.connection.select_one(strsql)
					Alloctbl.update(free_alloc["id"],:qty=>alloc[:qty] - qty)
				end
		end
		return alloc[:id]
	end
	 
	def vproc_return_alloc c_alloc
		strsql = %Q&  select id from alloctbls where srctblname = '#{c_alloc[:destblname]}' and srctblid = #{c_alloc[:destblid]} and qty > 0
												and destblname = 'alloctbls'　and destblid in (select id from alloctbls where srctblname = 'trngantts' and srctblid = #{c_alloc["srctblid"]} )&
		rtn_alloc = ActiveRecord::Base.connection.select_one(strsql)
		Alloctbl.update(rtn_alloc["destblid"],:qty=>rtn_alloc["qty"] - c_alloc["qty"])
		Alloctbl.update(rtn_alloc["id"],:qty=>c_alloc["qty"])
	end
	def proc_create_self_gantt sch_ord_inst_act
		tblnamechop = @opeitm[:prdpurshp]+sch_ord_inst_act.chop
		case @sio_classname
			when /_add_/
				pre_gantt ={"id"=>proc_get_nextval("trngantts_seq"),
					"key"=>"000",
					"orgtblname"=>"#{@opeitm[:prdpurshp]+sch_ord_inst_act}",
					"orgtblid"=>eval("@#{tblnamechop}_id"),
					"mlevel"=>0,
					"prjnos_id" => eval("@#{tblnamechop}_prjno_id"),
					"strdate"=>if @opeitm[:prdpurshp] == "shp" then  eval("@#{tblnamechop}_depdate")
					              else eval("@#{tblnamechop}_strdate") end,
					"duedate"=>eval("@#{tblnamechop}_duedate"),
					"parenum"=>1,"chilnum"=>1,
					"qty"=>eval("@#{tblnamechop}_qty"),
					###:itms_id=>@opeitm[:itms_id],:processseq=>@opeitm[:processseq],:locas_id=>@opeitm[:locas_id],
					"opeitms_id"=>@opeitm[:id],
					"expiredate"=>"2099/12/31".to_date,
					"created_at"=>Time.now,"updated_at"=>Time.now,"remark"=>"auto_created gantts from tran ",
					"persons_id_upd"=>ActiveRecord::Base.connection.select_value("select * from persons where code = '0'")}
				Trngantt.create pre_gantt	### sch,ord,inst,act自身のtrngantts
				pre_gantt["id"] = proc_get_nextval "trngantts_seq" 
				pre_gantt["key"] = "001" 
				pre_gantt["mlevel"] = 1 
				Trngantt.create pre_gantt
			when /_edit_|_delete_/
				str_sql = %Q& select * from trngantts where 
							orgtblname = '#{@opeitm[:prdpurshp]+sch_ord_inst_act}' 
							and orgtblid = eval("@#{tblnamechop.chop}_id")
							and and key = '000' &
				pre_gantt = ActiveRecord::Base.connection.select_one(strsql)
				qty = if @sio_classname =~ /_edit_/ then @src_tbl[:qty] else 0 end			
				Trngantt.update(pre_gantt["id"],{:qty=>qty})
				str_sql = %Q& select * from trngantts where 
							orgtblname = '#{@opeitm[:prdpurshp]+sch_ord_inst_act}' and orgtblid = #{@src_tbl[:id]} and and key = '001' &
				pre_gantt = ActiveRecord::Base.connection.select_one(strsql)		
				Trngantt.update(pre_gantt["id"],{:qty=>qty})
			else
				fprnt "LINE #{__LINE__} @sio_classname err #{@sio_classname} "
		end
		return pre_gantt
	end
end
class DbSchs  < DbCud    ###
    def perform_mkschs recs
	  begin
	    @sio_user_code = 0
	  ActiveRecord::Base.transaction do
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
					vproc_add_trngantts(rec)
			end
		    tbl[:where] = {:id =>rec["id"]}
		    plsql.mkschs.update tbl   ###insertはtblinks updateはここ　何とかならないか
		end
        dbcud = DbCud.new
        dbcud.perform(@new_sio_session_counter ,@sio_user_code,"") 
		###plsql.commit
        ###plsql.connection.autocommit = true
	  end
		rescue
		        ###plsql.rollback
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
	def vproc_add_trngantts	rec								
        @bgantts = {}
		cnt = 0
        @bgantts[:"000"] = {:mlevel=>0,
							:opeitm_id=>plsql.select(:first,"select * from opeitms where itms_id = #{rec["itms_id"]} and priority = 999 and processseq = 999")[:id],
							:opeitm_duration=>"",:assigs=>"",
							:endtime=>rec["duedate"],
							:qty=>rec["qty"],
							:depends=>""}
	    ngantts = []
        ngantts << {:seq=>"001",:mlevel=>1,
					:itm_id=>rec["itms_id"],
					:loca_id=>rec["locas_id"],
					:processseq=>rec["processseq"],:priority=>rec["priority"],
					:endtime=>rec["duedate"],:id=>"000"}
        until ngantts.size == 0
            cnt += 1
            ngantts = proc_get_tree_itms_locas ngantts
             break if cnt >= 10000
        end	
        @bgantts[:"000"][:starttime] = if @min_time < Time.now then Time.now else @min_time end
        prv_resch_trn  ####再計算
        @bgantts[:"000"][:endtime] = @bgantts[:"001"][:endtime] 
        @bgantts[:"000"][:opeitm_duration] = " #{(@bgantts[:"000"][:endtime]  - @bgantts[:"000"][:starttime] ).divmod(24*60*60)[0]}"
	    tmp_gantt = {}
		trn_ids = []
        @bgantts.sort.each  do|key,value|   ###依頼されたオーダ等をopeitms,nditmsを使用してgantttableに展開
			idx = plsql.trngantts_seq.nextval
			opeitm = plsql.select(:first,"select * from opeitms  where id =  #{value[:opeitm_id]}")
			tmp_gantt ={:id=>idx,:key=>key.to_s,
			:orgtblname=>rec["tblname"],:orgtblid=>rec["tblid"],
			:mlevel=>value[:mlevel],
			:prjnos_id=>rec["prjnos_id"],
			:opeitms_id=>value[:opeitm_id],
			:strdate=>value[:starttime],
			:duedate=>value[:endtime],
            :parenum=>value[:nditm_parenum],:chilnum=>value[:nditm_chilnum],
			:qty=>value[:qty],
			:expiredate=>"2099/12/31".to_date,
			:created_at=>Time.now,:updated_at=>Time.now,:remark=>"auto_created_by perform_mkschs ",
			:persons_id_upd=>ActiveRecord::Base.connection.select_value("select * from persons where code = '0'")}
		    Trngantt.create tmp_gantt
			trn_ids << idx
		end
		trn_ids.each do |trn_id|
			vproc_create_sch_from_gantt(trn_id)
		end
	end
	def proc_edit_from_trngantts rec   ###deleteも含む		
		strsql = %Q& select gantt.id gantt_id,gantt.parenum parenum,gantt.chilnum chilnum,gantt.key key,gantt.qty gantt_qty,
					gantt.opeitms_id opeitms_id,gantt.price price,gantt.orgtblname orgtblname,gantt.orgtblid orgtblid,
					alloc.id alloc_id,alloc.qty alloc_qty
					from trngantts gantt inner join  alloctbls alloc
					on alloc.srctblname = 'trngantts' and gantt.id = alloc.srctblid
					where gantt.orgtblname = '#{rec["tblname"]}'  and   gantt.orgtblid = #{rec["tblid"]} 
					order by    gantt.orgtblname, gantt.orgtblid,gantt.key
				&
		### trngantt : alloctbl  = 1:n		
		gantt_allocs = ActiveRecord::Base.connection.select_all(strsql)
		save_gantt_id = 0
		bal_qty =  0
		gantt_allocs.each do |gantt_alloc|
			if save_gantt_id != gantt_alloc["gantt_id"]			
				gantt = {}		
				if  bal_qty > 0 
					alloc = {}
					alloc[:id] = proc_get_nextval "alloctbls_seq" 
					alloc[:qty] = bal_qty
					alloc[:srctblname] = "trngantts" 
					alloc[:srctblid] = save_gantt_id	
					alloc[:destblname] = gantt_alloc["orgtblname"]	
					alloc[:destblid] = gantt_alloc["orgtblid"]
					alloc[:allocfree] = "free"
					alloc[:created_at] = Time.now
					alloc[:updated_at] = Time.now
					alloc[:persons_id_upd] = ActiveRecord::Base.connection.select_value("select id from persons where code = '0'")
					Alloctbl.create alloc
				end	
				if  gantt_alloc["key"].size > 4 ###2階層以降　
					strsql = %Q& select * from 	trngantts where orgtblname = '#{gantt_alloc["orgtblname"]}' 
												and orgtblid = #{gantt_alloc["orgtblid"]} and key = '#{gantt_alloc["key"][0..-4]}'&
					pare_gantt = ActiveRecord::Base.connection.select_one(strsql)
					gantt[:qty] = pare_gantt["qty"] * gantt_alloc["chilnum"] / gantt_alloc["parenum"]
					gantt[:duedate] = pare_gantt["strdate"] - 1 ### 構成を作成するときと合わすこと
				else  ###topレコード
					gantt[:qty] = rec["qty"]
					gantt[:duedate] = rec["duedate"]
				end
				gantt[:amt] = gantt[:qty] * (gantt_alloc["price"]||=0)
				proc_update_trangantts_schs(gantt_alloc["gantt_id"],gantt,gantt_alloc["opeitms_id"])
				save_gantt_id = gantt_alloc["gantt_id"]
				###freee alloc
				bal_qty = gantt[:qty]
			end
			if bal_qty >= gantt_alloc["alloc_qty"]
				bal_qty -= gantt_alloc["alloc_qty"]
			else
				proc_realloc(gantt_alloc["alloc_id"],bal_qty,gantt[:duedate],gantt[:strdate]) 
				bal_qty = 0
			end
        end		
		if  bal_qty > 0 
			alloc = {}
			alloc[:id] = proc_get_nextval "alloctbls_seq" 
			alloc[:qty] = bal_qty
			alloc[:srctblname] = "trngantts" 
			alloc[:srctblid] = save_gantt_id	
			alloc[:destblname] = gantt_alloc["orgtblname"]	
			alloc[:destblid] = gantt_alloc["orgtblid"]
			alloc[:allocfree] = "free"
			alloc[:created_at] = Time.now
			alloc[:updated_at] = Time.now
			alloc[:persons_id_upd] = ActiveRecord::Base.connection.select_value("select id from persons where code = '0'")
			Alloctbl.create alloc
		end	
	end
	def proc_update_trangantts_schs(id,trngantt,opeitms_id)
		opeitm = ActiveRecord::Base.connection.select_one(%Q& select * from opeitms where id = #{opeitms_id} &)
		trngantt[:strdate] =  trngantt[:duedate] - (opeitm["duration"]||=0)  ###稼働日考慮に  ###starttimeと合わすこと。
		Trngantt.update(id,trngantt)
		ctblanme = (opeitm["prdpurshp"]+"sch").singularize.capitalize.constantize
		strsql = " qty = #{trngantt[:qty]} ,duedate = #{trngantt[:duedate]} ,"
		strsql <<  if opeitm["prdpurshp"] =~ /^shp/ then "depdate = #{trngantt[:strdate]}" else " strdate = #{trngantt[:strdate]}" end
		ctblanme.update_all(strsql, "tblid = #{id}")
	end
	def proc_realloc alloc_id,bal_qty,duedate,strdate
		alloc = ActiveRecord::Base.connection.select_one("select * from alloctbls where id = #{alloc_id}")
		###prdpurshp = ActiveRecord::Base.connection.select_one(%Q& select * from #{alloc["destblname"]} where id = #{alloc["destblid"]} &)
		###ctblname = alloc["destblname"].chop.capitalize.constantize
		###tbl = {}
		###tbl[:qty] = prdpurshp["qty"] - (alloc["qty"] - bal_qty)
		###tbl[:duedate] = duedate
		##if alloc["destblname"] =~ /^shp/ then tbl[:depdate] = strdate else tbl[:strdate] = strdate end
		###ctblname.update(alloc["destblid"],tbl)
		Alloctbl.update(alloc_id,:qty=>bal_qty)
		case alloc["destblname"]
			when /ords$|insts$|acts$|lotstkhists/	
				strsql = %Q& select * from  alloctbls alloc
				where  alloc.destblname = 'alloctbls' 	
				and alloc.srctblname = '#{alloc["destblname"]}' and   alloc.srctblid = #{alloc["destblid"]} and alloc.allocfee = 'other'
				&
				others = ActiveRecord::Base.connection.select_all(strsql)
				others.each do |other|
					qty = if other["qty"] >= bal_qty then bal_qty else other["qty"] end
					Alloctbl.update(other["id"],:qty=> qty)	
					bal_qty = if other["qty"] >= bal_qty then 0 else bal_qty - other["qty"] end
					strsql = %Q& select * from  alloctbls alloc where  id = #{other["srctblid"]}
					&
					pre_alloc = ActiveRecord::Base.connection.select_one(strsql)
					Alloctbl.update(pre_alloc["id"],:qty=> pre_alloc["qty"] + other["qty"] - qty)
				end
		end
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
				alloc[:allocfee] = "other"
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
					alloc[:persons_id_upd] = ActiveRecord::Base.connection.select_value("select id from persons where code = '0'")
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
	def vproc_create_sch_from_gantt(trn_id)  ##
		str_gantt_sch = ActiveRecord::Base.connection.select_one(" select * from r_trngantts where id = #{trn_id} ")
		qty = str_gantt_sch["trngantt_qty"]
		if str_gantt_sch["trngantt_key"].size > 4 
			strsql = %Q& select * from r_trngantts where trngantt_orgtblname = '#{str_gantt_sch["trngantt_orgtblname"]}' 
												and trngantt_orgtblid = #{str_gantt_sch["trngantt_orgtblid"]}
												and trngantt_key = '#{str_gantt_sch["trngantt_key"][0..-4]}'&
			pare_gantt = ActiveRecord::Base.connection.select_one(strsql)
			@pare_opeitm = {}
			pare_gantt.each do |key,val|  ###xxxschs作成時使用
				tmptbl,newkey = key.split("_",2)
				@pare_opeitm[newkey.to_sym] = val if tmptbl == "opeitm"
			end
		##
			proc_command_c_to_instance(str_gantt_sch) 
			proc_opeitm_instance(str_gantt_sch)
			__send__("proc_tblink_mksch_trngantts_#{str_gantt_sch["opeitm_prdpurshp"]}schs_self10",str_gantt_sch)
		else
			@pare_opeitm = @opeitm
			### prdxxx,purxxx,shpxxxが直接画面、excelから入力された時 alloctblsとの紐つけを作成する。
			if str_gantt_sch["trngantt_orgtblname"] !~ /^cust/ and str_gantt_sch["trngantt_key"] == "001" 
				strsql = %Q& select * from alloctbls where srctblname = 'trngantts' 
										and destblname = '#{str_gantt_sch["trngantt_orgtblname"]}' and destblid = #{str_gantt_sch["trngantt_orgtblid"]} 
										and (allocfree = 'alloc' or allocfree = 'free')
										order by allocfree,(case substr(destblname,length(destblname) - 4, length(destblname))
															when 'acts' then '1'
															when 'nsts' then '2'
															when 'ords' then '3'
															when 'schs' then '4'
															else '9' end),srctblid
										&
				free_trns = ActiveRecord::Base.connection.select_all(strsql)
				if free_trns.empty?
					alloc= {}
					alloc[:qty] = str_gantt_sch["trngantt_qty"]
					alloc[:srctblname] = "trngantts"	
					alloc[:destblname] = str_gantt_sch["trngantt_orgtblname"]
					alloc[:srctblid] = str_gantt_sch["trngantt_id"]	
					alloc[:destblid] = str_gantt_sch["trngantt_orgtblid"]
					alloc[:allocfree] = "free"
					alloc[:id] = proc_get_nextval "alloctbls_seq" 
					alloc[:created_at] = Time.now
					alloc[:updated_at] = Time.now
					alloc[:persons_id_upd] = ActiveRecord::Base.connection.select_value("select id from persons where code = '0'")
					Alloctbl.create alloc   ###xxxschsのfree作成
				else
					free_trns.each do |free_trn|   #  すでに引きあたっている、数を引く
						if qty >= free_trn["qty"]
							qty -= free_trn["qty"]
						else
							Alloctbl.update(free_trn["id"],:qty=>qty)
							qty = 0
						end
					end
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
		qty = if rec["sno_org"] then rec["qty"] else save_inst[(insttblnamechop+"_qty")] end 
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
    def perform_setreplys tbl,id,user_id ### user_id integer
		##  tableは業者毎作業場所ごとにレイアウトが異なることを想定。そのレイアウトに 外部からのデータにsno(instsのsno:外部からのkey)とsno_org(内部key)は必須
	 begin
		rptblname = tbl.singularize.capitalize.constantize
		@sio_classname = "_add_perform_setreplys" ### perform_set
		
		replysの時は常に追加
		sno_org = ""
		ord = {}
		sno_trn = ""
		bal_qty = 0
		sum_rply_qty = 0 
	    @sio_user_code = 0
		@new_sio_session_counter  = user_seq_nextval
		@pare_class = "batch"
		str_id = if id then " and id = #{id} " else "" end
	    replys = ActiveRecord::Base.connection.select_all("select * from #{tbl} where result_f = '0' and persons_id_upd = #{user_id} #{str_id} FOR UPDATE ")
		replys.each do |reply|
			ctblname = reply["tblname"].singularize.capitalize.constantize
			strsql = "select * from #{reply["tblname"]} where result_f = '0' and persons_id_upd = #{user_id}  order by sno_org FOR UPDATE "
			inputs = ActiveRecord::Base.connection.select_all(strsql)
			inputs.each do |input|
				if sno_org != input["sno_org"] 
					if sno_org != "" 
						if sum_rply_qty != bal_qty and ord["opeitm_chkord"] == "0"   ###分割の時で数量不一致は不可
							err ={}
							err[:message_contents] = "unmatch Σreply_qty != ord_balacle_qty ; Σreply_qty = #{sum_rply_qty.to_s} ,ord_balance_qty = #{bal_qty} "
							err[:message_code] = "error_xxxx "
							err[:result_f] = "9"
							ctblname.where(:sno_org=>input["sno_org"],:result_f => '0').update_all(err)
						end
					end			
					strsql = "select #{tbl[0..2]}ord_sno,#{tbl[0..2]}ord_qty ord_qty,opeitm_chkord
							from r_#{tbl[0..2]}ords  where #{tbl[0..2]}ord_sno = '#{input["sno_org"]}' "
					ord = ActiveRecord::Base.connection.select_one(strsql)	
					if ord.nil?
						err[:message_contents] = " not find sno =  #{input["sno_org"]} "
						err[:message_code] = "error_perform_setreplys_2 "
						err[:result_f] = "9"
						ctblname.where(:sno_org=>input["sno_org"],:result_f => '0').update_all(err)
						next
					end
					bal_qty =  	ord["ord_qty"]
					strsql = "select sno_ord,sum(qty) act_qty from #{tbl[0..2]}acts  where sno_ord = '#{input["sno_org"]}' group by sno_ord "
					act = ActiveRecord::Base.connection.select_one(strsql)
					strsql = "select sno_ord,sum(qty) ret_qty from #{tbl[0..2]}rets  where sno_ord = '#{input["sno_org"]}' group by sno_ord "
					ret = ActiveRecord::Base.connection.select_one(strsql)
					bal_qty -= if act then act["qty"] else 0 end
					bal_qty += if ret then ret["qty"] else 0 end
					sno_org = input["sno_org"]				
					sno_trn = input["sno_trn"]
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
				ctblname.where(:sno_org=>sno_org,:result_f => '0').update_all(err)
				next
			end
			strsql = "select * from #{reply["tblname"]} where result_f = '0' and persons_id_upd = #{user_id}  order by sno_org FOR UPDATE "
			inputs = ActiveRecord::Base.connection.select_all(strsql)
			sno_org = ""
			inputs.each do |input|
				if sno_org != input["sno_org"]
					strsql = %Q& select * from r_#{tbl[0..2]}ords  where #{tbl[0..2]}ord_sno = '#{input["sno_org"]}' &
					ord = ActiveRecord::Base.connection.select_one(strsql)
					strsql = %Q& select * from r_#{tbl[0..2]}insts where  id in ( 
								select srctblid from alloctbls where srctblname = '#{tbl[0..2]}insts' and   destblname = 'alloctbls' and destblid in ( 
								select  id from alloctbls where srctblname = 'trngantts' and  destblname = '#{tbl[0..2]}ords' and  destblid = #{ord["id"]} ))&
					insts = ActiveRecord::Base.connection.select_all(strsql)
					insts.each do |inst|
						command_c = inst.dup
						##command_c = proc_set_command_c(command_c,"r_#{tbl[0..2]}insts") do
							@sio_classname = "reply_delete_"
						##end	
						proc_command_c_to_instance inst
						proc_opeitm_instance (inst)
						strsql = %Q& select * from alloctbls where  srctblname = 'trngantts' and destblname = '#{tbl[0..2]}insts' and destblid = #{inst["id"]} and qty > 0 &
						alloctbls = ActiveRecord::Base.connection.select_all(strsql)
						__send__("proc_tblink_r_#{tbl[0..2]}rplys_#{tbl[0..2]}insts_self10",alloctbls)
					end
				end
				sno_org = input["sno_org"]
				strsql = %Q& select * from r_#{tbl[0..2]}ords where  #{tbl[0..2]}ord_sno = '#{input["sno_org"]}' &	
				ord = ActiveRecord::Base.connection.select_one(strsql)  ###view
				strsql = %Q& select * from r_alloctbls where  alloctbl_srctblname = 'trngantts' 
				             and alloctbl_destblname = '#{tbl[0..2]}ords' and alloctbl_destblid = #{ord["id"]} and alloctbl_qty > 0 &
				alloctbls = ActiveRecord::Base.connection.select_all(strsql) 
				proc_command_c_to_instance ord
				proc_opeitm_instance(ord)
				@reply_qty = input["qty"]   ###回答から引き継げる項目は、数量、納期、コメントのみ
				@reply_qty_case = input["qty_case"]   
				@reply_duedate = input["duedate"] 
				@reply_strdate = input["strdate"]
				@replt_content = input["contents"]
				__send__("proc_tblink_r_#{tbl[0..2]}rplys_#{tbl[0..2]}insts_self10",alloctbls)				
				data ={}
				data[:result_f] = "1"
				data[:updated_at] = Time.now
				ctblname.where(:id =>input["id"]).update_all(data)
			end		
			data ={}
			data[:result_f] = "1"
			data[:updated_at] = Time.now
			rptblname.where(:id =>reply["id"]).update_all(data)
		end
	   rescue
                fprnt"class #{self} : LINE #{__LINE__} $@: #{$@} " 
                fprnt"class #{self} : LINE #{__LINE__} $!: #{$!} "
      end		
	end
    handle_asynchronously :perform_setreplys
end		