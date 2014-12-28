class DbCud  < ActionController::Base
 ## @queue = :default
 ## def self.perform(sio_id,sio_view_name)
 ##　importと 画面でエラー検出すること。
			### とりあえず
## ダイナミックに　モデルを変更　	ctblname = tbl.chop.capitalize.constantize
    def perform(sio_session_counter,user_id,one_by_one)
      begin	
		@req_userproc = false
	    @sio_user_code = user_id
        ###plsql.execute "SAVEPOINT before_perform"
        plsql.connection.autocommit = false
        ##crt_def_all  unless respond_to?("dummy_def")
	    @new_sio_session_counter  = user_seq_nextval(@sio_user_code)
        @pare_class = "batch"
        tg_tbls = plsql.select(:all,"select * from userproc#{user_id.to_s}s where session_counter = #{sio_session_counter}")
		tg_tbls.each do |tg_tbl|   ###複数のテーブルを同一セッションで処理
		    ### sio_session_counter --> session group id   sio_session_id-->group 内　id
            command_cs = plsql.select(:all,sql_perform(tg_tbl[:tblname],sio_session_counter,user_id))
            r_cnt0 = tg_tbl[:cnt_out]||=0
		    tblname = command_cs[0][:sio_viewname].split("_",3)[1] 
            command_cs.each do |i|  ##テーブル、画面の追加処理  #複数のレコードを処理
				r_cnt0 += 1
				@sio_classname = i[:sio_classname]
                proc_update_table i,r_cnt0 ### 本体
                reset_show_data_screen if tblname =~ /screen|pobjgrps/   ###キャッシュを削除
                ##
				strsql = " update userproc#{user_id.to_s}s set cnt_out = #{r_cnt0},status = 'normal end' ,updated_at = current_date
				           where session_counter = #{sio_session_counter} and tblname = '#{tg_tbl[:tblname]}' "
		        plsql.execute strsql
				if one_by_one == "one_by_one"			
                    plsql.commit
					if @req_userproc 
                       dbcud = DbCud.new
                       dbcud.perform(@new_sio_session_counter ,@sio_user_code,"")
				    end 
				end
		    end
		end						
        plsql.commit
		if one_by_one != "one_by_one"	and 	@req_userproc 
	       dbcud = DbCud.new
           dbcud.perform(@new_sio_session_counter ,@sio_user_code,"")
		end
        plsql.connection.autocommit = true
	   rescue
	        if @sio_result_f !=   "9" ##想定外error
                fprnt"class #{self} : LINE #{__LINE__} $@: #{$@} " 
                fprnt"class #{self} : LINE #{__LINE__} $!: #{$!} "
			end		
      end		
    end   ##perform
      handle_asynchronously :perform
	def sql_perform  tblname,sio_session_counter,user_id
		%Q%
		select * from #{tblname} a where sio_session_counter = #{sio_session_counter} and sio_command_response = 'C' and sio_user_code = #{user_id}
		        and not exists(select 1 from #{tblname} b where  a.sio_session_counter = b.sio_session_counter  
		        and sio_command_response = 'R' and a.sio_user_code =  b.sio_user_code and a.sio_session_id = b.sio_session_id)
		%
	end
    def reset_show_data_screen
	   ##debugger
      ##cache_key =  "show" 
      ##Rails.cache.delete_matched(cache_key) ###delay_jobからcallされるので、grp_codeはbatch
	  Rails.cache.clear(nil) ###delay_jobからcallされるので、grp_codeはbatch
    end
    def proc_update_table rec,r_cnt0  ##rec = command_c command_rとの混乱を避けるためrecにした。
	    tblname = rec[:sio_viewname].split("_")[1]
        begin 	       
            command_r = rec.dup ###sio_xxxxx の　レスポンス用
            tmp_key = {}
            proc_set_src_tbl  rec ### @src_tblの項目作成
            command_r[:sio_recordcount] = r_cnt0
            if  command_r[:sio_message_contents].nil? 
			    case command_r[:sio_classname]
			        when /_add_/ then
	                    plsql.__send__(tblname).insert @src_tbl  
	                when /_edit_/ then
                         @src_tbl[:where] = {:id => rec[:id]}             ##変更分のみ更新
                         plsql.__send__(tblname).update  @src_tbl
                    when  /_delete_/ then 
                         plsql.__send__(tblname).delete(:id => rec[:id])
	            end   ## case iud
            end  ##@src_tbl[:sio_message_contents].nil
          rescue
                plsql.rollback
                @sio_result_f = command_r[:sio_result_f] =   "9"  ##9:error 
                command_r[:sio_message_contents] =  "class #{self} : LINE #{__LINE__} $!: #{$!} "    ###evar not defined
                command_r[:sio_errline] =  "class #{self} : LINE #{__LINE__} $@: #{$@} "[0..3999]
                @src_tbl.each do |i,j| 
                    if i.to_s =~ /s_id/  
                        newi = (tblname.chop + "_" + i.to_s.sub("s_id","_id")).to_sym
                        command_r[newi] = j if j 
                    end
                    command_r[i] = j if i == :id
                end
                command_r[(command_r[:sio_viewname].split("_")[1].chop + "_id").to_sym] =  command_r[:id]
                fprnt"class #{self} : LINE #{__LINE__} $@: #{$@} " 
                fprnt"class #{self} : LINE #{__LINE__} $!: #{$!} " 
                fprnt"LINE #{__LINE__} command_r: #{command_r} " 
          else
            @sio_result_f = command_r[:sio_result_f] =  "1"   ## 1 normal end
            command_r[:sio_message_contents] = nil
            command_r[(command_r[:sio_viewname].split("_")[1].chop + "_id").to_sym] =  command_r[:id] = @src_tbl[:id]
            ##crt_def_tb if  tblname == "blktbs"
            case tblname
                 when 	/rubycodings|tblink/
						##undef dummy_def if respond_to?("dummy_def")
						crt_def_all
				 when   "mkschs","mkords","mkinsts","reallocs"
				        vproc_tbl_mk  tblname do 
						     case tblname
							      when  "mkschs"
								     DbSchs.new
							      when  "mkords"
								     DbOrds.new
							      when  "reallocs"
								     DbReAlloc.new
							      when  "mkinsts"
								     DbInsts.new
							 end
						end
				 ####when   /schs$|ords$|insts$|acts$/
            end				 					   
          ensure
            sub_insert_sio_r   command_r    ## 結果のsio書き込み
            ###raise   ### plsql.connection.autocommit = false   ##test 1/19 ok
        end ##begin
        raise if @sio_result_f ==   "9" 
    end
	def vproc_tbl_mk tblname
	    if tblname == "mkinsts"  then order_by_add = " autocreate_inst,tblname,tblid, "  else order_by_add = "" end
	    recs = plsql.select(:all,"select * from #{tblname} where result_f = '0' order by #{order_by_add} id")   ##0 未処理
        dbmk = yield
		recs.each do |rec|
		    if rec[:runtime] == -1
			   rec[:result_f] = "5"  ## Queueing
			   rec[:where] = {:id =>rec[:id]}
			   plsql.__send__(tblname).update rec
			   ##fprnt "line:#{__LINE__} rec:#{rec}"
            end			 
		end
		dbmk.__send__("perform_#{tblname}", recs)
		plsql.commit
	end
end
class DbSchs  < DbCud
    def perform_mkschs recs
	  begin
	    @sio_user_code = 0
        plsql.connection.autocommit = false
	    @new_sio_session_counter  = user_seq_nextval(@sio_user_code)
        @pare_class = "batch"
        cnt = 0
		recs.each do |rec|
		    chk_trngantt = plsql.select(:first,"select * from trngantts where orgtblname = '#{rec[:tblbame]}' and orgtblid = #{rec[:tblid]}")
            if chk_trngantt 
				chk_tbl = plsql.select(:first,"selecgt * from #{rec[:tblname]} where id = #{rec[:tblid]}")
				if ckk_tbl
					raise if rec[:sio_classname] !~ /_edit_/
					@sio_classname = "perform_mksch_edit_"				
					vproc_edit_trngantts(rec)
				else
					raise if rec[:sio_classname] !~ /_delete_/
					@sio_classname = "perform_mksch_delete_"				
					vproc_edit_trngantts(rec)
				end
			else
				raise if rec[:sio_classname] !~ /_add_/
				@sio_classname = "perform_mksch_add_"				
				vproc_add_trngantts(rec)
			end
		    rec[:result_f] = "1"  ## normal end
		    rec[:cmpldate] = Time.now
		    rec[:updated_at] = Time.now
		    rec[:where] = {:id =>rec[:id]}
		    plsql.mkschs.update rec   ###insertはtblinks updateはここ　何とかならないか
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
		        plsql.mkschs.update rec
		        plsql.commit
	  end
    end
    handle_asynchronously :perform_mkschs
	def vproc_add_trngantts	rec								
        @bgantts = {}
		cnt = 0
        @bgantts[:"000"] = {:mlevel=>0,
							:opeitm_id=>plsql.select(:first,"select * from opeitms where itms_id = #{rec[:itms_id]} and priority = 999 and processseq = 999")[:id],
							:opeitm_duration=>"",:assigs=>"",
							:endtime=>rec[:duedate],
							:qty=>rec[:qty],
							:depends=>""}
	    ngantts = []
        ngantts << {:seq=>"001",:mlevel=>1,:itm_id=>rec[:itms_id],:loca_id=>rec[:locas_id],
					:processseq=>rec[:processseq],:priority=>rec[:priority],
					:endtime=>rec[:duedate],:id=>"000"}
        until ngantts.size == 0
            cnt += 1
            ngantts = proc_get_tree_itms_locas ngantts
             break if cnt >= 10000
        end	
        @bgantts[:"000"][:starttime] = if @min_time < Time.now then Time.now else @min_time end
        prv_resch_trn  ####再計算
        @bgantts[:"000"][:endtime] = @bgantts[:"001"][:endtime] 
        @bgantts[:"000"][:opeitm_duration] = " #{(@bgantts[:"000"][:endtime]  - @bgantts[:"000"][:starttime] ).divmod(24*60*60)[0]}"
	    str_gantt = {}
        @bgantts.sort.each  do|key,value|   ###依頼されたオーダ等をopeitms,nditmsを使用してgantttableに展開
			idx = plsql.trngantts_seq.nextval
			opeitm = plsql.select(:first,"select * from opeitms  where id =  #{value[:opeitm_id]}")
			str_gantt ={:id=>idx,:key=>key.to_s,
			:orgtblname=>rec[:tblname],:orgtblid=>rec[:tblid],
			:mlevel=>value[:mlevel],
			:prjno=>rec[:prjno],:strdate=>value[:starttime],
			:duedate=>value[:endtime],
            :parenum=>value[:nditm_parenum],:chilnum=>value[:nditm_chilnum],
			:qty=>value[:qty],:prdpurshp=>value[:prdpurshp],
			:itms_id=>opeitm[:itms_id],:processseq=>opeitm[:processseq],:locas_id=>opeitm[:locas_id],
			:expiredate=>"2099/12/31".to_date,
			:created_at=>Time.now,:updated_at=>Time.now,:remark=>"auto_created_by perform_mkschs ",:persons_id_upd=>0}
		    plsql.trngantts.insert str_gantt
			vproc_create_sch_from_gantt(str_gantt)			
			vproc_pre_chk_free_alloc(str_gantt)
        end
	end
	def sql_pre_chk_free_alloc(str_gantt)
		%Q&
			select 		alloc.id alloctbl_id,alloc.srctblname alloctbl_srctblname,alloc.srctblid alloctbl_srctblid,
						alloc.destblname alloctbl_destblname,alloc.destblid alloctbl_destblid,
						alloc.qty alloctbl_qty,gantt.locas_id trngantt_loca_id,stk.locas_id lotstkhist_loca_id
						from trngantts gantt,alloctbls alloc, lotstkhists stk 
						where  gantt.id = alloc.srctblid and key = '001' and alloc.qty > 0 and gantt.orgtblname !~ /^cust/
						and alloc.srctblname = 'trngantts' and destblname = 'lotstkhists' and  alloc.destblid = stk.id 
						and stk.itms_id = #{str_gantt[:itms_id]} and stk.processseq = #{str_gantt[:processseq]} and prjno = '#{str_gantt[:prjno]}'
		&
	end
	def vproc_pre_chk_free_alloc str_gantt   ###shuffleは在庫になった時行う。 ここは新規のprdpurshpの処理		 
		free_stks = plsql.select(:all,sql_pre_chk_free_alloc(str_gantt))
		free_stks.each do |free_stk|		
			break if str_gantt[:qty] <= 0
			if shuffle_loca = "1" or trngantt_loca_id == lotstkhist_loca_id
				destbl = {}
				destbl[:alloctbl_srctblname] = "trngantts"
				destbl[:alloctbl_srctblid] = str_gantt[:id]
				destbl[:alloctbl_destblname] = free_stk[:alloctbl_destblname]
				destbl[:alloctbl_destblid] = free_stk[:alloctbl_destblid]
				destbl[:alloctbl_qty] = str_gantt[:qty]
				if trngantt_loca_id == lotstkhist_loca_id  
					str_gantt[:qty] = proc_chng_allocxxxxxx free_stk,destbl
				else ###出庫予定
				end
			end
		end
	end
	def proc_create_new_alloc alloc
		case @sio_classname
			when /_add_/
				alloc[:id] = plsql.alloctbls_seq.next
				alloc[:created_at] = Time.now
				alloc[:updated_at] = Time.now
				alloc[:persons_id_upd] = 0
				plsql.alloctbls.insert alloc
			when /_edit_|_delete_/
				strsql = %Q& select * from alloctbls where srctblname = '#{alloc[:srctblname]}' and srctblid = #{alloc[:srctblid]}
									and destblname = '#{alloc[:destblname]}' and destblid = #{alloc[:destblid]} &
				alloctbl = ActiveRecord::Base.connection.select_one(strsql)
				raise if alloctbl.nil?  ##logic error
				alloctbl[:updated_at] = Time.now
				if @sio_classname =~ /_edit_/ 
					if alloc[:qty]  >=  alloctbl[:qty]
						alloc[:qty]  -=  alloctbl[:qty]
					else
						alloctbl[:qty] = 0 
					end
				else
					alloctbl[:qty] = 0
				end 
				alloctbl[:where] = {:id=>alloctbl[:id]}
				plsql.alloctbls.update alloctbl
				alloc[:id] = alloctbl[:id]
		end
		return alloc[:id]
	end
	def vproc_create_sch_from_gantt(str_gantt)  ##	
		proc_command_c_to_instance(plsql.select(:first,"select * from r_trngantts where id = #{str_gantt[:id]}"))   ### @xxxxの作成
		strsql = "select * from opeitms where itms_id = #{str_gantt[:itms_id]} and processseq = #{str_gantt[:processseq]} and priority = #{str_gantt[:priority]}"
		@opeitm = plsql.select(:first,strsql)
		if str_gantt[:key].size > 4 
			strsql = "select * from trngantts where orgtblname = '#{str_gantt[:orgtblname]}' and orgtblid = #{str_gantt[:orgtblid]} and key = '#{str_gantt[:key][0..-4]}'"
			pare_gantt = plsql.select(:first,strsql)	
			strsql = "select * from opeitms where itms_id = #{pare_gantt[:itms_id]} and processseq = #{pare_gantt[:processseq]} and locas_id = #{pare_gantt[:locas_id]}"
			strsql << " order by priority desc "
			@pare_opeitm = plsql.select(:first,strsql)
		else
			@pare_opeitm = @opeitm 
		end
		gantt = {} ##ganttsは alloctblsで使用
		gantt[:trngantt_id] = @trngantt_id
		gantt[:trngantt_qty] = @trngantt_qty
		__send__("proc_tblink_mksch_trngantts_#{str_gantt[:prdpurshp]}schs_self10",gantt)
    end
	def sql_alloc_search rec,sch_ord_inst_act
		org_strwhere = ""
		trn_strwhere = ""
		### orgtblnameの存在チェックを画面でする。 trnganttsのorgtblnameにあること。
		gantt_show_data = get_show_data "r_trngantts"   if rec[:orgtblname]
		@trn_show_data = get_show_data "r_#{rec[:prdpurshp]+sch_ord_inst_act}" 
		trn_show_data = get_show_data "r_trngantts"
		org_search_key = {}
		trn_search_key = {}
		rec.each do |key,val|
   		    next if val.nil?
   		    next if val == "dummy"
   		    skey = key.to_s
   		    next if skey =~ /_id_/
    		case skey
        		when /_org$/
	        		newkey = skey.gsub("_org","").to_sym
					org_search_key[newkey] = val
	    		when /_trn$/
	        		newkey = skey.gsub("_trn","").to_sym
					trn_search_key[newkey] = val
    		end    
		end
		if org_search_key.size >=1
    		org_strwhere = " and alloctbl_srctblid in (select id from r_trngantts "
			org_strwhere << " where trngantt_orgtblname = '#{rec[:orgtblname]}'     "
    		org_strwhere = proc_search_key_strwhere(org_search_key,org_strwhere,gantt_show_data )
    		org_strwhere << ") "
		end
		if trn_search_key.size >=1
    		trn_strwhere = "  and alloctbl_destblid in (select id from r_#{rec[:prdpurshp]+sch_ord_inst_act}s  where  "
    		trn_strwhere = proc_search_key_strwhere(trn_search_key,trn_strwhere,@trn_show_data)
    		trn_strwhere << ") "
		end
		%Q&
			select trngantt_id,trngantt_strdate,trngantt_loca_id,trngantt_itm_id,trngantt_prdpurshp,trngantt_processseq,
			alloctbl_id,alloctbl_srctblname,alloctbl_srctblid,alloctbl_destblname,alloctbl_destblid,alloctbl_qty,alloctbl_id,trn.* 
		    from r_trngantts trngantt ,r_#{rec[:prdpurshp]+sch_ord_inst_act}s trn ,r_alloctbls
		    where  alloctbl_srctblname = 'trngantts' and trngantt_id = alloctbl_srctblid
			and alloctbl_qty > 0 and alloctbl_destblname = '#{rec[:prdpurshp]+sch_ord_inst_act}s' and alloctbl_destblid = trn.id
		    #{org_strwhere}
		    #{trn_strwhere}
			order by trngantt.itm_code,trngantt.trngantt_loca_id,trn.loca_id_to,trngantt.trngantt_processseq,trn.opeitm_id,trngantt.trngantt_strdate
		&
	end
	def proc_create_self_gantt sch_ord_inst_act
		case @sio_classname
			when /_add_/
				str_gantt ={:id=>plsql.trngantts_seq.nextval,:key=>"000",
					:orgtblname=>"#{@opeitm[:prdpurshp]+sch_ord_inst_act}s",:orgtblid=>@src_tbl[:id],
					:mlevel=>0,
					:prjno=>@src_tbl[:prjno],:strdate=>@src_tbl[:strdate]||=@src_tbl[:depdate],:duedate=>@src_tbl[:duedate],
					:parenum=>1,:chilnum=>1,
					:qty=>@src_tbl[:qty],:prdpurshp=>@opeitm[:prdpurshp],
					:itms_id=>@opeitm[:itms_id],:processseq=>@opeitm[:processseq],:locas_id=>@opeitm[:locas_id],
					:expiredate=>"2099/12/31".to_date,
					:created_at=>Time.now,:updated_at=>Time.now,:remark=>"auto_created gantts from tran ",:persons_id_upd=>0} 
				plsql.trngantts.insert str_gantt	### sch,ord,inst,act自身のtrngantts
				str_gantt ={:id=>plsql.trngantts_seq.nextval,:key=>"001",
					:mlevel=>1} 
				plsql.trngantts.insert str_gantt
			when /_edit_|_delete_/
				str_sql = "select * from trngantts where "
				str_sql << %Q& orgtblname = '#{@opeitm[:prdpurshp]+sch_ord_inst_act}s' and orgtblid = #{@src_tbl[:id]} and and key = '000' &
				trn = ActiveRecord::Base.connection.select_all(strsql)
				trn[:qty] = if @sio_classname =~ /_edit_/ then @src_tbl[:qty] else 0 end
				trn[:where] = {:id=>trn[:id]}
				str_sql = "select * from trngantts where "
				str_sql << %Q& orgtblname = '#{@opeitm[:prdpurshp]+sch_ord_inst_act}s' and orgtblid = #{@src_tbl[:id]} and and key = '001' &
				trn[:qty] = if @sio_classname =~ /_edit_/ then @src_tbl[:qty] else 0 end
				trn[:where] = {:id=>trn[:id]}
				str_sql = "select * from trngantts where "
				plsqal.trngantts.update trn
		end
		return str_gantt[:id]
	end
	###schからord  ordからinst・・・・に変わった時
	def proc_update_gantt_alloc_fm_trn gantt,allocs  ###gantt:今回作成した　ord等のtrngantts  allocs:ord等の作成元　ordなら　sch instならord等
		self_gantt_id = proc_create_self_gantt yield   ###schやord自身のtrngantts作成
		str_alloctbl = {}		
		new_alloc = {}	
		new_alloc[:srctblname] = "trngantts"
		new_alloc[:destblname] = "#{@opeitm[:prdpurshp] + yield}"
		new_alloc[:srctblid] = self_gantt_id	
		new_alloc[:destblid] = @src_tbl[:id]
		if allocs
			new_alloc[:qty] = gantt[:qty] 
			new_alloc_id = proc_create_new_alloc(new_alloc)    ###基本形作成 最初未引当てとして作成
			allocs.each do |alloc|
				vproc_update_upper_alloc gantt,allocs,new_alloc_id,self_gantt_id
			end
		else
			new_alloc[:qty] = 0 
			new_alloc_id = proc_create_new_alloc(new_alloc)    ###基本形作成 
			new_alloc[:qty] = gantt[:qty]
			new_alloc[:srctblid] = gantt[:id]	
			new_alloc_id = proc_create_new_alloc(new_alloc)    ###
		end
    end
	def vproc_update_upper_alloc gantt,allocs,new_alloc_id,self_gantt_id
		alloctbl = {}
		base_alloc = alloc.dup
		alloctbl[:qty] = if  alloc[:alloctbl_qty] <= gantt[:qty] then 0 else alloc[:alloctbl_qty] - gantt[:qty] end 
		alloctbl[:where] = {:id=>alloc[:alloctbl_id]}
		plsql.alloctbls.update alloctbl   ## 上位ステータスに変更になったため、元を減
		base_alloc[:destblname] = "#{@opeitm[:prdpurshp] + yield}"
		base_alloc[:destblid] = @src_tbl[:id]
		base_alloctbl[:qty] = if  alloc[:alloctbl_qty] == 0 then base_alloctbl[:qty] else gantt[:qty] end
		proc_create_new_alloc base_alloc　　  ## 引当てを　schからord  又はordからinstへ　　・・・
		org_new_alloc = {}
		org_new_alloc[:where] = {:id=>new_alloc_id}
		org_new_alloc[:qty] = alloc[:qty] - base_alloc[:qty] 
		plsql.alloctbls.update org_new_alloctbl   ###未引当て分を減	
		gantt[:qty] -= org_new_alloc[:qty]
	end
end
class DbOrds  < DbSchs
    def perform_mkords recs
	  begin
	    @sio_user_code = 0
        plsql.connection.autocommit = false
	    @new_sio_session_counter  = user_seq_nextval(@sio_user_code)
        @pare_class = "batch"
		##fprnt " line #{__LINE__}  \n sql_mkord_search(rec) = #{sql_mkord_search(rec)}"
		recs.each do |rec|
		    vproc_mkord rec	
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
		    plsql.mkords.update rec
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
    handle_asynchronously :perform_mkords
	def vproc_mkord rec     ###画面項目prdpurshpは必須
	    opeitm_id = 0
		@ord_show_data = get_show_data "r_#{rec[:prdpurshp]}ords"
		bal_schs = plsql.select(:all,sql_alloc_search(rec,"sch"))   ### ordの元となるschのデータを探す。
		@incnt = bal_schs.size
		@skipcnt = @outcnt = 0
		@inqty = @outqty = @skipqty = 0
		@inamt = @outamt = @skipamt = 0
		@schpricesym = (rec[:prdpurshp] + "sch_price").to_sym
		##fprnt "line #{__LINE__}  \n sql_realloc_search(rec) #{sql_realloc_search(rec)}"
		save_sch = {}
		ary_alloc =[]		
		@free_qty = 0
		bal_schs.each do |sch|
		    @inqty += sch[:alloctbl_qty]
			@inamt += (sch[:alloctbl_qty] * (sch[@schpricesym]||=0))
			if sch[:opeitm_autocreate_ord] == "0" ##手動の時は作成しない。
				@skipcnt += 1
				@skipqty += sch[:alloctbl_qty]
				@skipamt += (sch[:alloctbl_qty] * (sch[@schpricesym]||=0))	
				next
			end
		    if opeitm_id != sch[:opeitm_id]
			    vproc_mkord_create_ord(save_sch,ary_alloc) if opeitm_id != 0 					   
			    save_sch = sch.dup
				proc_opeitm_instance (save_sch) ###set @opeitm
				opeitm_id = @opeitm[:id]
				@free_qty = 0
				ary_alloc =[]
			else
                if @opeitm[:maxqty] <= (save_sch[:alloctbl_qty] + sch[:alloctbl_qty]) or 
				    sch[:trngantt_strdate].to_date <= (save_sch[:trngantt_strdate].to_date + @opeitm[:opt_fixoterm]) or
				    sch[:trngantt_loca_id] != save_sch[:trngantt_loca_id] or sch[:loca_id_to] != save_sch[:loca_id_to]
				    if  sch[:trngantt_loca_id] == save_sch[:trngantt_loca_id] and sch[:loca_id_to] == save_sch[:loca_id_to]
					    if save_sch[:alloctbl_qty] >= @free_qty 
    						save_sch[:alloctbl_qty] -= @free_qty 
                            @free_qty = 0
                         else
    						save_sch[:alloctbl_qty] = 0
                            @free_qty -= save_sch[:alloctbl_qty]				
                        end	
                       else
                        @free_qty = 0   					   
					end
				    if save_sch[:alloctbl_qty] > 0 
						vproc_mkord_create_ord(save_sch,ary_alloc)  
						ary_alloc =[]
						save_sch = sch.dup
					end
                else
                    save_sch[:alloctbl_qty] += sch[:alloctbl_qty]  	 				   			   
                end			
				ary_alloc << sch
		    end
		end
		vproc_mkord_create_ord(save_sch,ary_alloc)  if save_sch[:alloctbl_qty] > 0
	end
    def vproc_mkord_create_ord save_sch,ary_alloc ###日付(@opeitm[:opt_fixoterm])による数量まとめは済んでいる。
		 ## 包装単位での発注
		mk_ord = {}
	    org_qty = (save_sch[:alloctbl_qty].to_f/@opeitm[:packqty].to_f).ceil *  @opeitm[:packqty]
		@free_qty = org_qty - save_sch[:alloctbl_qty]
        until org_qty <= 0
		    ## maxqtyはpackqtyの整数倍であること。
	        qty = mk_ord[(ordtblname.chop+"_qty").to_sym] = if @opeitm[:maxqty] < org_qty then @opeitm[:maxqty] else org_qty end
	        amt = mk_ord[(ordtblname.chop+"_amt").to_sym] = qty * (save_sch[@schpricesym]||=0)
	        mk_ord[(ordtblname.chop+"_qty_case").to_sym] = qty /  @opeitm[:packqty]
			@outcnt += 1
			@outqty += qty
			@outamt += amt 
			##vproc_create_free_trngantts save_sch if @free_qty > 0   ### free qty
			org_qty -= @opeitm[:maxqty]			
			__send__("proc_tblink_mkord_trngantts_#{str_gantt[:prdpurshp]}ords_self10",gantts,save_sch)
			mk_ord[(ordtblname.chop+"_strdate").to_sym]  -= @opeitm[:opt_fixoterm]
			mk_ord[(ordtblname.chop+"_dudate").to_sym]  -= @opeitm[:opt_fixoterm]
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
        plsql.connection.autocommit = false
	    @new_sio_session_counter  = user_seq_nextval(@sio_user_code)
        @pare_class = "batch"
		@savekey = ""								
		@cno_lineno = 0
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
    handle_asynchronously :perform_mkinsts
end		

class DbReplys  < DbOrds
    def perform_setreplys (view_name,user_id)
		##  tableは業者毎作業場所ごとにレイアウトが異なることを想定。そのレイアウトに 外部からのデータにsno(instsのsno:外部からのkey)とsno_ord(内部key)は必須
		tbl = view_name.splt("_",2)[1]
		ctblname = tbl.chop.capitalize.constantize
		sno_ord = ""
		ord = {}
		sno_inst = ""
		bal_qty = 0
		sum_rply_qty = 0 
	    replys = ActiveRecord::Base.connection.select_all("select * from #{tbl} where result_f = '0' and persons_id_upd = #{user_id} order by sno_ord,sno_inst FOR UPDATE ")
		replys.each do |reply|
			if sno_ord != reply[:sno_ord] and sno_inst != reply[:sno_inst]
				if sno_ord != "" 
					if sum_rply_qty    != bal_qty and ord[:opeitm_chkord] == "0"   ###分割の時で数量不一致は不可
						err ={}
						err[:message_contents] = "unmatch Σreply_qty != ord_balacle_qty ; Σreply_qty = #{sum_rply_qty.to_s} ,ord_balance_qty = #{bal_qty} "
						err[:message_code] = "error_xxxx "
						err[:result_f] = "9"
						ctblname.where(:sno_ord=>reply[:sno_ord],:result_f => '0').update_all(err)
					end
				end			
				strsql = "select #{tbl[0..2]}ord_sno,#{tbl[0..2]}ord_qty ord_qty,opeitm_chkord from r_#{tbl[0..2]}ords  where #{tbl[0..2]}ord_sno = '#{reply[:sno_ord]}' "
				ord = ActiveRecord::Base.connection.select_one(strsql)	
				if ord.nil?
					err[:message_contents] = " not find sno =  #{reply[:sno_ord]} "
					err[:message_code] = "error_perform_setreplys_2 "
					err[:result_f] = "9"
					ctblname.where(:sno_ord=>reply[:sno_ord],:result_f => '0').update_all(err)
					next
				end
				bal_qty =  	ord[:ord_qty]
				strsql = "select sno_ord,sum(qty) act_qty from #{tbl[0..2]}acts  where sno_ord = '#{reply[:sno_ord]}' group by sno_ord "
				act = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select sno_ord,sum(qty) ret_qty from #{tbl[0..2]}rets  where sno_ord = '#{reply[:sno_ord]}' group by sno_ord "
				ret = ActiveRecord::Base.connection.select_one(strsql)
				bal_qty -= if act then act[:qct_qty] else 0 end
				bal_qty += if ret then ret[:ret_qty] else 0 end
				sno_ord = reply[:sno_ord]				
				sno_inst = reply[:sno_inst]
				sum_rply_qty = 0
			end
			sum_rply_qty += reply[:qty]
		end		
		if sum_rply_qty != bal_qty and ord[:opeitm_chkord] == "0"
			err ={}
			err[:message_contents] = "unmatch Σreply_qty != ord_balacle_qty ; Σreply_qty = #{sum_rply_qty.to_s} ,ord_balance_qty = #{bal_qty} "
			err[:message_code] = "error_xxxx "
			err[:result_f] = "9"
			ctblname.where(:sno_ord=>sno_ord,:result_f => '0').update_all(err)
		end
	    strsql = "select * from r_#{tbl} where #{tbl.chop}_result_f = '0' and #{tbl}_person_id_upd = #{user_id} order by #{tbl.chop}_sno_ord "
	    replys = ActiveRecord::Base.connection.select_all(strsql)  ###view
		sno_ord = ""
		sno_ordsym = (tbl.chop + "_sno_ord").to_sym
		replys.each do |reply|
			if sno_ord != reply[sno_ordsym]
				strsql = "select * from r_#{tbl[0..2]}ords  where #{tbl[0..2]}ord_sno = '#{reply[sno_ordsym]}' "
				ord = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from r_#{tbl[0..2]}insts where  id in ( "
				strsql << " select srctblid from alloctbls where srctblname = '#{tbl[0..2]}inst' and   "
				strsql << " destblname = '#{tbl[0..2]}ord' and  destblid = #{ord[:id]}"
				insts = ActiveRecord::Base.connection.select_all(strsql)
				insts.each do |inst|
					command_c = inst.dup
					command_c = proc_set_command_c(command_c,"r_#{tbl[0..2]}insts") do
						command_c[:sio_classname] = "reply_delete_"
					end
					proc_insert_sio_c command_c
				end
				sno_ord = reply[sno_ordsym]
			end
			proc_command_c_to_instance reply
			proc_ord_inst_alloc_by_reply reply,tbl[0..2]
		end
	end
    handle_asynchronously :perform_setreplys
	def proc_ord_inst_alloc_by_reply reply,prdpurshp
		__send__("proc_reply_r_#{prdpurshp}ords_#{prdpurshp}insts_self10")
	end
end		