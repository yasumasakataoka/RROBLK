class DbCud  < ActionController::Base
 ## @queue = :default
 ## def self.perform(sio_id,sio_view_name)
 ##　importと 画面でエラー検出すること。
			### とりあえず
		##plsql.blkstddates.update({:datevalue =>blksdate,:where=>{:key=>"blksdate"}})  ###修正要
    def perform(sio_session_counter,user_id,one_by_one)
      begin	
		@req_userproc = false
	    @sio_user_code = user_id
        ###plsql.execute "SAVEPOINT before_perform"
        plsql.connection.autocommit = false
        crt_def_all  unless respond_to?("dummy_def")
	    @new_sio_session_counter  = user_seq_nextval(@sio_user_code)
        @pare_class = "batch"
        tg_tbls = plsql.select(:all,"select * from userproc#{user_id.to_s}s where session_counter = #{sio_session_counter}")
		tg_tbls.each do |tg_tbl|
		    ### sio_session_counter --> session group id   sio_session_id-->group 内　id 
		    strsql = "select * from #{tg_tbl[:tblname]} a where sio_session_counter = #{sio_session_counter} and sio_command_response = 'C' and sio_user_code = #{user_id} "
		    strsql << " and not exists(select 1 from #{tg_tbl[:tblname]} b where  a.sio_session_counter = b.sio_session_counter " 
		    strsql << " and sio_command_response = 'R' and a.sio_user_code =  b.sio_user_code and a.sio_session_id = b.sio_session_id)"
            command_cs = plsql.select(:all,strsql)
            ##debugger if tg_tbl[:tblname] =~ /inout/
            r_cnt0 = tg_tbl[:cnt_out]||=0
		    tblname = command_cs[0][:sio_viewname].split("_",3)[1] 
            command_cs.each do |i|  ##テーブル、画面の追加処理
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
    def reset_show_data_screen
	   ##debugger
      ##cache_key =  "show" 
      ##Rails.cache.delete_matched(cache_key) ###delay_jobからcallされるので、grp_codeはbatch
	  Rails.cache.clear(nil) ###delay_jobからcallされるので、grp_codeはbatch
    end
    def reset_show_data_screenlist   ###casheは消えけどうまくいかない　2013/11/2
      ##debugger
      cache_keys =["listindex","show","id"] 
      cache_keys.each do |key|
         Rails.cache.delete_matched(key) ###delay_jobからcallされるので、grp_codeはbat
      end
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
                        ##debugger  
	                    plsql.__send__(tblname).insert @src_tbl  
	                when /_edit_/ then
                         @src_tbl[:where] = {:id => rec[:id]}             ##変更分のみ更新
	                     ##debugger
                         plsql.__send__(tblname).update  @src_tbl
                    when  /_delete_/ then 
                         plsql.__send__(tblname).delete(:id => rec[:id])
	            end   ## case iud
            end  ##@src_tbl[:sio_message_contents].nil
          rescue  
                ###debugger
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
          else
			##debugger
            @sio_result_f = command_r[:sio_result_f] =  "1"   ## 1 normal end
            command_r[:sio_message_contents] = nil
            command_r[(command_r[:sio_viewname].split("_")[1].chop + "_id").to_sym] =  command_r[:id] = @src_tbl[:id]
            ##crt_def_tb if  tblname == "blktbs"
            case tblname
                 when 	"rubycodings" 
                       vproc_crt_def_rubycode
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
		    ##debugger
            sub_insert_sio_r   command_r    ## 結果のsio書き込み
            ###raise   ### plsql.connection.autocommit = false   ##test 1/19 ok
        end ##begin
        raise if @sio_result_f ==   "9" 
    end
	def vproc_tbl_mk tblname
	    if tblname == "mkinsts"  then order_by_add = " sumtype,tblname,tblid, "  else order_by_add = "" end
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
		    chk_trngantt = plsql.select(:first,"select * from trngantts where orgtblname = '#{rec[:tblbame]}' and tblid = #{rec[:tblid]}")
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
        @bgantts.sort.each  do|key,value|   ###依頼されたオーダ等を単純にopeitms,nditmsを使用してgantttableに展開
			idx = plsql.trngantts_seq.nextval
			opeitm = plsql.select(:first,"select * from opeitms  where id =  #{value[:opeitm_id]}")
			str_gantt ={:id=>idx,:key=>key,
			:orgtblname=>rec[:tblname],:orgtblid=>rec[:tblid],
			:mlevel=>value[:mlevel],
			:sno_prj=>rec[:sno_prj],:strdate=>value[:starttime],
			:duedate=>value[:endtime],
            :parenum=>value[:nditm_parenum],:chilnum=>value[:nditm_chilnum],
			:qty=>value[:qty],:prdpurshp=>value[:prdpurshp],
			:itms_id=>opeitm[:itms_id],:processseq=>opeitm[:processseq],:locas_id=>opeitm[:locas_id],:priority=>opeitm[:priority],
			:expiredate=>"2099/12/31".to_date,
			:created_at=>Time.now,:updated_at=>Time.now,:remark=>"auto_created_by perform_mkschs ",:persons_id_upd=>0}
		    plsql.trngantts.insert str_gantt		
		    vproc_create_schs_from_gantt str_gantt
        end
	end
	def vproc_create_schs_from_gantt( str_gantt)  ##	
		proc_command_c_to_instance(plsel.select(:first,"select * from r_trngantts where id = #{str_gantt[:id]}"))   ### @xxxxの作成
		strsql = "select * from opeitms where itms_id = #{str_gantt[:itms_id]} and processseq = #{str_gantt[:processseq]} and priority = #{str_gantt[:priority]}"
		@opeitm = plsql.select(:first,strsql)
		if str_gantt[:key].size > 4 
			strsql = "select * from trngantts where orgtblname = #{str_gantt[:orgtblname]} and orgtblid = #{str_gantt[:orgtblid]} and keys = '#{str_gantt[:key][0..-4]}'"
			pare_gantt = plsql.select(:first,strsql)	
			strsql = "select * from opeitms where itms_id = #{pare_gantt[:itms_id]} and processseq = #{pare_gantt[:processseq]} and priority = #{pare_gantt[:priority]}"
			@pare_opeitm = plsql.select(:first,strsql)
			__send__("proc_tblink_mksch_trngantts_#{str_gantt[:prdpurshp]}schs_self10")
		else
			@pare_opeitm = @opeitm
			__send__("proc_tblink_mksch_trngantts_#{str_gantt[:prdpurshp]}schs_self10") if str_gantt[:mlevel] == 1
		end
		
    end
	
	def psub_chk_alloc_opeitm( free_rec,gantt_rec, short_qty )
	    ## gantt_recにはあるがfree_recからの引当てにはないopeitms  途中で構成が変更された。
	end
	def psub_over_alloc_to_free over_alloc_itms
	end
 end ## class
 
 
class DbReAllocs  < DbSchs
    def perform_reallocs recs
	  begin
	    @sio_user_code = 0
        plsql.connection.autocommit = false
	    @new_sio_session_counter  = user_seq_nextval(@sio_user_code)
        @pare_class = "batch"
		##fprnt " line #{__LINE__}  \n sql_mkord_search(rec) = #{sql_mkord_search(rec)}"
		recs.each do |rec|
		    vproc_alloc_search rec	
		    rec[:result_f] = "1"  ## normal end
		    rec[:updated_at] = Time.now
		    rec[:cmpldate] = Time.now
		    rec[:incnt] = @incnt
		    rec[:outcnt_alloc] = @outcnt_alloc
		    rec[:inqty] = @inqty
		    rec[:qty_alloc] = @qty_alloc
		    rec[:inamt] = @inamt
		    rec[:amt_alloc] = @amt_alloc
		    rec[:where] = {:id =>rec[:id]}
		    plsql.reallocs.update rec
		end 
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
		        plsql.reallocs.update rec
		        plsql.commit
	  end
    end
    handle_asynchronously :perform_reallocs
	def sql_alloc_search rec,alloc_ord
		org_strwhere = ""
		trn_strwhere = ""
		### orgtblnameの存在チェックを画面でする。 trnganttsのorgtblnameにあること。
		gantt_show_data = get_show_data "r_trngantts"   if rec[:orgtblname]
		@sch_show_data = get_show_data "r_#{rec[:prdpurshp]}schs" 
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
    		trn_strwhere = "  and alloctbl_destblid in (select id from r_#{rec[:prdpurshp]}schs  where  "
    		trn_strwhere = proc_search_key_strwhere(trn_search_key,trn_strwhere,@sch_show_data)
    		trn_strwhere << ") "
		end
		%Q& #{if alloc_ord == "alloc" 
				"select distinct trngantt_orgtblname,trngantt_orgtblid"
			  else
				"select trngantt_id,trngantt_strdate,trngantt_loca_id,trngantt_itm_id,alloctbl_qty,alloctbl_id,sch.* "
			 end}
		    from r_trngantts trngantt ,r_#{rec[:prdpurshp]}schs sch ,r_alloctbls
		    where  alloctbl_srctblname = 'trngantts' and trngantt_id = alloctbl_srctblid
			 and alloctbl_qty > 0 and alloctbl_destblname = '#{rec[:prdpurshp]}schs' and alloctbl_destblid = sch.id
		    #{org_strwhere}
		    #{trn_strwhere}
			#{if alloc_ord == "alloc"
				"order by trngantt.trngantt_strdate "
			else
				"order by trngantt.itm_code,trngantt.trngantt_loca_id,sch.loca_id_to,trngantt.trngantt_processseq,sch.opeitm_id,trngantt.trngantt_strdate"
			end}&
	end
	### 子部品の置き換えのコーディングがまだ
	def vproc_alloc_search rec
		gantts = plsql.select(:all,sql_alloc_search(rec,"alloc"))
		gantts.each do |gantt|
			strsql = "select trn.id ,trn.itms_id,trn.processseq,trn.priority,trn.key,trn.sno_prj,sum(alloc.qty) unalloc_qty "
			strsql << " from trngantts trn,alloctbls alloc where orgtblname = '#{gantt[:orgtblname]}' and orgtblid = #{gantt[:orgtblid]} "
			strsql << " and mlevel >0 and srctblname = 'trngantts' and trn.id = alloc.srctblid and destblname like '%schs' "
			strsql << " group by trn.id,trn.itms_id,trn.processseq,trn.priority,trn.key,trn.sno_prj  having sum(alloc.qty) > 0 order by  key"
			unallocs = plsql.select(:all,strsql)
			unallocs.each do |unalloc|
				strsql = "select trn.id new_alloc_id,alloc.qty alloc_qty "
				strsql << " from r_#{gantt[:prdpurshp]}ords trn,alloctbls alloc where srctblname = '#{gantt[:prdpurshp]}ords' "
				strsql << " and trn.id = srctblid and trn.opeitm_itm_id = #{unalloc[:itms_id]} and trn.opeitm_processseq = #{unalloc[:processseq]} "
				strsql << " and trn.opeitm_priority = #{unalloc[:priority]} and alloc.srctblname = alloc.desttblname and alloc.scrtblid = alloc.destblid "
				strsql << " and gantt.sno_prj = trn.sno_prj "
				allocs = plsql.select(:all,strsql)
				allocs.each do |alloc|
					if unalloc[:unalloc_qty] > alloc[:alloc_qty]
						proc_alloc gantt,unalloc,alloc,alloc[:alloc_qty]
						unalloc[:unalloc_qty] -= alloc[:alloc_qty]
					else
						proc_alloc gantt,unalloc,alloc,unalloc[:unalloc_qty]
						break
					end
				end
			end			
		end
	end
	def	proc_alloc unalloc,alloc,dest_qty
		###  新しいtrnganttとの関係
        str_alloc ={:id=>plsql.alloctbls_seq.nextval,
	        :srctblname=>"trngantts",:srctblid=>unalloc[:id],:destblname=>(gantt[:prdpurshp]+ "ords"),:destblid=>alloc[:new_alloc_id],
			:qty=>@src_tbl[:dest_qty],
			:expiredate=>"2099/12/31".to_date,
			:created_at=>Time.now,:updated_at=>Time.now,:remark=>"proc_realloc ",:persons_id_upd=>0} 
		plsql.alloctbls.insert str_alloc
		### 
        str_alloc ={:id=>plsql.alloctbls_seq.nextval,
	        :srctblname=>unalloc[:destblname],:srctblid=>unalloc[:destblid],:destblname=>(gantt[:prdpurshp]+"ords"),:destblid=>alloc[:new_alloc_id],
			:qty=>@src_tbl[:dest_qty],
			:expiredate=>"2099/12/31".to_date,
			:created_at=>Time.now,:updated_at=>Time.now,:remark=>"proc_realloc ",:persons_id_upd=>0} 
		plsql.alloctbls.insert str_alloc		
		org_allocs = plsql.select(:all," select * from alloctbls where srctblname = 'trngantts' and srctblid = #{unalloc[:id]} and destblname like '%schs' ")
		####元の引当て関係
		org_allocs.each do |org|
			org[:where] = {:id=>org[:id]}
			org[:updated_at] = Time.now
			if dest_qty  > org[:qty]
				org[:qty] = 0
				plsql.alloctbls.update org
				dest_qty -= org[:qty]
			else
				org[:qty] -=dest_qty
				plsql.alloctbls.update org
				break
			end
		end
	end
end
class DbOrds  < DbReAllocs
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
		

	def vproc_mkord rec
	    opeitm_id = 0
		@ord_show_data = get_show_data "r_#{rec[:prdpurshp]}ords"
		bal_schs = plsql.select(:all,sql_alloc_search(rec,"ord"))
		@incnt = bal_schs.size
		@skipcnt = @outcnt = 0
		@inqty = @outqty = @skipqty = 0
		@inamt = @outamt = @skipamt = 0
		@schpricesym = (rec[:prdpurshp] + "sch_price").to_sym
		##fprnt "line #{__LINE__}  \n sql_realloc_search(rec) #{sql_realloc_search(rec)}"
		save_sch = {}
		ary_trns =[]		
		@free_qty = 0
		bal_schs.each do |sch|
		    @inqty += sch[:alloctbl_qty]
			@inamt += (sch[:alloctbl_qty] * (sch[@schpricesym]||=0))
		    if opeitm_id != sch[:opeitm_id]
			    vproc_chk_mkord_create_ord(save_sch,ary_trns) if opeitm_id != 0 					   
			    save_sch = sch.dup
				ary_trns << sch[:trngantt_id]
				vproc_mkord_opeitm (save_sch) ###set @opeitm
				opeitm_id = @opeitm[:id]
				@free_qty = 0
			  else
                if @opeitm[:maxqty] > save_sch[:alloctbl_qty] + sch[:alloctbl_qty] or 
				    sch[:trngantt_strdate].to_date > save_sch[:trngantt_strdate].to_date + @opeitm[:opt_fixoterm] or
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
				    vproc_chk_mkord_create_ord(save_sch,ary_trns)  if save_sch[:alloctbl_qty] > 0 
			        save_sch = sch.dup
				    ary_trns << sch[:trngantt_id]
				    vproc_mkord_opeitm (save_sch)   ###set @opeitm
				    opeitm_id = @opeitm[:id]
                   else
                    save_sch[:alloctbl_qty] += sch[:alloctbl_qty]  
				    ary_trns << sch[:trngantt_id]  	 				   			   
                end				
		    end
		end
		vproc_chk_mkord_create_ord(save_sch,ary_trns)  if save_sch[:alloctbl_qty] > 0
	end
	def vproc_chk_mkord_create_ord save_sch,ary_trns
		if @opeitm[:autocreate_ord] == "0" ##手動の時は作成しない。
		   @skipcnt += 1
		   @skipqty += save_sch[:alloctbl_qty]
		   @skipamt += (save_sch[:alloctbl_qty] * (save_sch[@schpricesym]||=0))
		else   
		    vproc_mkord_create_ord(save_sch,ary_trns)
        end
	end
    def vproc_mkord_opeitm save_sch
	    @opeitm = {}
		save_sch.each do |key,val|
		    @opeitm[key.to_s.split("_",2)[1].to_sym] = val if key.to_s =~ /^opeitm/
		end
		@opeitm[:minqty] ||= 0
		@opeitm[:maxqty] ||= 999999999
		@opeitm[:maxqty] = 9999999999 if @opeitm[:maxqty] == 0
		@opeitm[:opt_fixoterm] ||= 999999999
		@opeitm[:opt_fixoterm] = 9999999999 if  @opeitm[:opt_fixoterm] == 0 
		@opeitm[:packqty] ||= 1 
		@opeitm[:packqty]  = 1 if @opeitm[:packqty] == 0
		@opeitm[:autocreate_ord] ||= '0' ## 0:手動　1：自動　confirm=1  2:仮のxxxORDSを自動作成 confirm=0
	end
    def vproc_mkord_create_ord save_sch,ary_trns ###日付(@opeitm[:opt_fixoterm])による数量まとめは済んでいる。
         ##仮オーダま他は本オーダ　仮は有効xx(仮に7日にしている。
		 ## 包装単位での発注
		mk_ord = {}
		ordtblname = save_sch[:trngantt_tblname].sub("schs","ords")
		mk_ord[:sio_code] = mk_ord[:sio_viewname] = "r_" + ordtblname
        mk_ord[:sio_user_code] = 0
		@sch_show_data[:allfields].each do |fld|
		    if  save_sch[fld]
			    ord_fld = fld.to_s.sub("sch","ord").to_sym
				if @ord_show_data[:allfields].index(ord_fld)
		           mk_ord[ord_fld] = save_sch[fld]
                end
		    end
		end
        mk_ord[:sio_classname] = "plsql_auto_add_by_mk_ord"
        debugger if ordtblname == "custords"
        mk_ord[:id] = mk_ord[(ordtblname.chop + "_id").to_sym] = plsql.__send__("#{ordtblname}_seq").nextval 
		mk_ord[:sio_user_code] = 0		
		mk_ord[(ordtblname.chop+"_expiredate").to_sym] = Confirmdate if @opeitm[:autocreate_ord] != "1" ##仮オーダ
	    org_qty = (save_sch[:alloctbl_qty].to_f/@opeitm[:packqty].to_f).ceil *  @opeitm[:packqty]
		@free_qty = org_qty - save_sch[:alloctbl_qty]
        until org_qty <= 0
		    ## maxqtyはpackqtyの整数倍であること。
	        mk_ord[(ordtblname.chop+"_qty").to_sym] = if @opeitm[:maxqty] < org_qty then @opeitm[:maxqty] else org_qty end
	        mk_ord[(ordtblname.chop+"_amt").to_sym] = mk_ord[(ordtblname.chop+"_qty").to_sym] * (save_sch[@schpricesym]||=0)
	        mk_ord[(ordtblname.chop+"_qty_case").to_sym] = mk_ord[(ordtblname.chop+"_qty").to_sym] /  @opeitm[:packqty]
			@outcnt += 1
			@outqty += mk_ord[(ordtblname.chop+"_qty").to_sym]
			@outamt += mk_ord[(ordtblname.chop+"_amt").to_sym] 
	        mk_ord[(ordtblname.chop+"_remark").to_sym] =  " created by mkord "
		    mk_ord[(ordtblname.chop+"_confirm").to_sym] = @opeitm[:autocreate_ord]
            sub_insert_sio_c    mk_ord 
            proc_update_table  mk_ord,1
            vproc_chng_alloc ary_trns,mk_ord[(ordtblname.chop+"_qty").to_sym] do
			  "'schs','ords'"
			end			
			vproc_create_free_trngantts save_sch if @free_qty > 0   ### free qty
			org_qty -= @opeitm[:maxqty]   
	    end		
	end
	def vproc_chng_alloc ary_trns ,qty
		trn_ids = ary_trns.join(",") 
		trns = plsql.select(:all,"select * from trngantts where id in (#{trn_ids}) and qty_alloc > 0 ")
	    trns.each do |trn|		
			alloctbl = {}
            alloctbl[:id] = plsql.alloctbls_seq.nextval
            alloctbl[:srctblname] = trn[:tblname]
            alloctbl[:srctblid] = trn[:id]
            alloctbl[:qty] = trn[:qty_alloc]
			nxt_trn = trn.dup
			if qty >= trn[:qty_alloc]
			    qty -= trn[:qty_alloc]				      
			    trn[:qty_alloc] = 0
			  else 
			    trn[:qty_alloc] -= qty 			   
			    qty = 0
			end
			trn[:where] = {:id=>trn[:id]}
			plsql.trngantts.update trn
            nxt_trn[:id] = plsql.trngantts_seq.nextval
            alloctbl[:destblname] = nxt_trn[:tblname].sub!(yield)
            alloctbl[:destblid] = nxt_trn[:tblid] = @src_tbl[:id]	
			nxt_trn[:created_at] = alloctbl[:created_at] = Time.now
			nxt_trn[:updated_at] = alloctbl[:updated_at] = Time.now
            plsql.trngantts.insert nxt_trn			
            plsql.alloctbls.insert alloctbl			
		end
	end
	
	def vproc_create_free_trngantts save_sch
	    strsql = "select * from trngantts where orgtblname = '#{save_sch[:trngantt_tblname]}' and id = #{@src_tbl[:id]} and tblname = orgtblname"
     	trn = plsql.select(:first,strsql)
		if trn
		    trn[:qty_alloc] = @free_qty
			trn[:where] = {:id=>trn[:id]}
			plsql.trngantts.update trn
		  else	
            str_gantt ={:id=>plsql.trngantts_seq.nextval,:key=>"000",
	        :orgtblname=>save_sch[:trngantt_tblname],:orgtblid=>mk_ord[:id],
	        :mlevel=>0,
	        :sno_prj=>@src_tbl[:sno_prj],:strdate=>@src_tbl[:strdate]||=@src_tbl[:depdate],:strdate_est=>@src_tbl[:strdate]||=@src_tbl[:depdate],
	    	:duedate=>@src_tbl[:duedate],:duedate_est=>@src_tbl[:duedate],
            :parenum=>1,:chilnum=>1,
		    :qty=>@src_tbl[:qty],:qty_alloc=>@free_qty,:prdpurshp=>value[:prdpurshp],
			:itms_id=>save_sch[:itm_id],:processseq=>save_sch[:opeitm_processseq],:locas_id=>save_sch[:loca_id],
			:expiredate=>"2099/12/31".to_date,
			:created_at=>Time.now,:updated_at=>Time.now,:remark=>"auto_created free trngantts ",:persons_id_upd=>0} 
			plsql.trngantts.insert str_gantt
		end
    end		
end

class DbInsts  < DbOrds
    def perform_mkinsts recs
	  begin
	    @sio_user_code = 0
        plsql.connection.autocommit = false
	    @new_sio_session_counter  = user_seq_nextval(@sio_user_code)
        @pare_class = "batch"
		@savekey = ""								
		@cno_lineno = 0
		recs.each do |rec|  ###recsはsumtypeでsortされていること
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
	def vproc_mkinst_fm_ord rec
	    strsql = "select * from r_#{rec[:orgtblname]} where id = #{tblid} "
		proc_command_c_to_instance command_c
		command_c = plsql.select(:first,strsql)
		proc_command_c_to_instance command_c		
	    __send__("proc_tblink_#{rec[:tblname]}_to_#{rec[:tblname].sub('ords','insts')}_self10")
	end
	def vproc_inst rec
		 ## tblname,tblid(keyの決定はsno又はcno)必須　オンラインでチェックしていること
		command_c = plsql.select(:first,"select * from r_mkinsts where id = {rec[:id]}")
		case rec[:sumtype]
		    when "0"  ##ord:inst = 1:1
				vproc_chk_inst rec if @savekey != ""
				vproc_mkinst_fm_ord rec
				@savekey = ""
			when "1"   ###分割
				vproc_chk_inst rec if @savekey != ""
				vproc_mkinst_fm_ord rec
				@savekey = "1," + rec[:tblname] + "," + rec[:tblid].to_s
			when /^NO/  ###統合
				vproc_chk_inst rec if @savekey != "" and @savekey != rec[:sumtype]
				@cno = __send__("proc_view_field_#{@rec[:tblname].chop}_cno")
				vproc_mkinst_fm_ord rec
				@savekey = rec[:sumtype]
		end
	end
	def vproc_chk_inst rec
	    case @savekey
			when /^1/
				vproc_chk_ord_qty_inst_qty
			when /^NO/
				@cno_lineno = 0
		end
	end
	def vproc_chk_inst rec
	    case @savekey
			when /^1/
				vproc_chk_ord_qty_inst_qty
			when /^NO/
				@cno_lineno = 0
		end
	end
end		