﻿class DbCud  < ActionController::Base
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
		    strsql = "select * from #{tg_tbl[:tblname]} a where sio_session_counter = #{sio_session_counter} and sio_command_response = 'C' and sio_user_code = #{user_id} "
		    strsql << " and not exists(select 1 from #{tg_tbl[:tblname]} b where  a.sio_session_counter = b.sio_session_counter " 
		    strsql << " and sio_command_response = 'R' and a.sio_user_code =  b.sio_user_code and a.sio_session_id = b.sio_session_id)"
            command_cs = plsql.select(:all,strsql)
            ##debugger if tg_tbl[:tblname] =~ /inout/
            r_cnt0 = tg_tbl[:cnt_out]||=0
		    tblname = command_cs[0][:sio_viewname].split("_",3)[1] 
            command_cs.each do |i|  ##テーブル、画面の追加処理
				r_cnt0 += 1
                update_table i,tblname,r_cnt0 ### 本体
                reset_show_data_screen if tblname =~ /screen|pobjgrps/   ###キャッシュを削除
                ##
				strsql = " update userproc#{user_id.to_s}s set cnt_out = #{r_cnt0},status = 'normal end' ,updated_at = sysdate
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
	        if @sio_result_f !=   "9" 
                fprnt"class #{self} : LINE #{__LINE__} $@: #{$@} " 
                fprnt"class #{self} : LINE #{__LINE__} $!: #{$!} "
			end		
      end		
    end   ##perform
      handle_asynchronously :perform  	  
    def reset_show_data_screen
	   debugger
      ##cache_key =  "show" 
      ##Rails.cache.delete_matched(cache_key) ###delay_jobからcallされるので、grp_codeはbatch
	  Rails.cache.clear(nil) ###delay_jobからcallされるので、grp_codeはbatch
    end
    def reset_show_data_screenlist   ###casheは消えけどうまくいかない　2013/11/2
      debugger
      cache_keys =["listindex","show","id"] 
      cache_keys.each do |key|
         Rails.cache.delete_matched(key) ###delay_jobからcallされるので、grp_codeはbat
      end
    end
    def  set_sch_status schsrec
      case
         when  schsrec[:qty] >0
             case
                 when schsrec[:qty] <= schsrec[:qty_act] 
                  "9:complete"
                  when schsrec[:qty] <= schsrec[:qty_inst] 
                  "7:insts"
                  when schsrec[:qty] <= schsrec[:qty_ord] 
                  "5:ords"
                  else
                  "0:schs"
             end
        when  schsrec[:amt] >0
             case
                 when schsrec[:amt] <= schsrec[:amt_act] 
                  "9:complete"
                  when schsrec[:amt] <= schsrec[:amt_inst] 
                  "7:insts"
                  when schsrec[:amt] <= schsrec[:amt_ord] 
                  "5:ords"
                  else
                  "0:schs"
             end
      end
    end
    
    def update_table rec,tblname,r_cnt0  ##rec = command_c command_rとの混乱を避けるためrecにした。
        begin 	       
            command_r = {}   ###sio_xxxxx の　レスポンス用
            command_r = rec.dup
            tmp_key = {}
            sub_set_src_tbl  rec ### @src_tblの項目作成
			if   rec[:sio_viewname] !~ /ruby|tblink/
			     sub_tblinks_before (rec)
			end
            command_r[:sio_recordcount] = r_cnt0
            @src_tbl[:persons_id_upd] = rec[:sio_user_code]
            if  command_r[:sio_message_contents].nil? 
                @src_tbl[:updated_at] = Time.now
			    case command_r[:sio_classname]
			        when /_add_/ then
                        ##debugger
                        @src_tbl[:created_at] = Time.now  
	                    plsql.__send__(tblname).insert @src_tbl  
	                when /_edit_/ then
                         @src_tbl[:where] = {:id => rec[:id]}             ##変更分のみ更新
	                     ##debugger
                         @src_tbl[:updated_at] = Time.now
                         plsql.__send__(tblname).update  @src_tbl
                    when  /_delete_/ then 
                         plsql.__send__(tblname).delete(:id => rec[:id])
	            end   ## case iud
            end  ##@src_tbl[:sio_message_contents].nil
			sub_tblinks_after rec if   rec[:sio_viewname] !~ /ruby|tblink/
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
            @src_tbl.each do |i,j| 
	            if i.to_s =~ /s_id/  
		              newi = (tblname.chop + "_" + i.to_s.sub("s_id","_id")).to_sym
		              command_r[newi] = j if j 
                end
               command_r[i] = j if i == :id
            end
            command_r[(command_r[:sio_viewname].split("_")[1].chop + "_id").to_sym] =  command_r[:id]
            ##crt_def_tb if  tblname == "blktbs"
            case tblname
                 when 	"rubycodings" 
                       crt_def_rubycode
				 when   "mkopes"
				        psub_tbl_mkopes
            end				 					   
          ensure
		    ##debugger
            sub_insert_sio_r   command_r    ## 結果のsio書き込み
            ###raise   ### plsql.connection.autocommit = false   ##test 1/19 ok
        end ##begin
        raise if @sio_result_f ==   "9" 
    end
 
	def psub_tbl_mkopes
	    recs = plsql.select(:all,"select * from mkopes where result_f = '0' order by id")   ##0 未処理
        dbmkope = DbGantt.new
		recs.each do |rec|
		    if runtime = -1
			   rec[:result_f] = "5"  ## Queueing
			   rec[:where] = {:id =>rec[:id]}
			   plsql.mkopes.update rec
			   plsql.commit
		       dbmkope.perform_gantt rec
			   fprnt "line:#{__LINE__} rec:#{rec}"
            end			 
		end
	end
end
class DbGantt  < ActionController::Base
    def perform_gantt rec
	  begin
	    @sio_user_code = 0
        plsql.connection.autocommit = false
	    @new_sio_session_counter  = user_seq_nextval(@sio_user_code)
        @pare_class = "batch"
        cnt = 0
        @bgantts = {}
		if rec[:tblname] =~ /^cust/
		    cust = plsql.__send__("r_#{rec[:tblname]}").first(" where id = #{rec[:tblid]}")
			cust_code = cust[:cust_code]
		    cust_name = cust[:cust_name]
		end
        @bgantts[:"000"] = {:mlevel=>0,:itm_code=>"",
				:itm_name=>sub_blkgetpobj(rec[:tblname]||="全行程","tbl"),
				:loca_code=>cust_code||="",
				:loca_name=>cust_name||="",
				:opeitm_duration=>"",:assigs=>"",
				:endtime=>rec[:duedate],
				:qty=>rec[:qty],
				:starttime=>nil,:depends=>"",:id=>0}
		ngantts = []
        ngantts << {:seq=>"001",:mlevel=>1,:itm_id=>rec[:itms_id],:loca_id=>rec[:locas_id],
                :processseq=>rec[:processseq],:priority=>rec[:priority],
			    :endtime=>rec[:duedate],:id=>"000"}
        until ngantts.size == 0
            cnt += 1
            ngantts = psub_get_itms_locas ngantts
            break if cnt >= 10000
        end	
        @bgantts[:"000"][:starttime] = if @min_time < Time.now then Time.now else @min_time end
        prv_resch_trn  ####再計算
        @bgantts[:"000"][:endtime] = @bgantts[:"001"][:endtime] 
        @bgantts[:"000"][:opeitm_duration] = " #{(@bgantts[:"000"][:endtime]  - @bgantts[:"000"][:starttime] ).divmod(24*60*60)[0]}"
		str_trngantt = {}
        @bgantts.sort.each  do|key,value|
		    ##if key.to_s.size > 4
		    ##   itms_id_pare = @bgantts[key.to_s[0..-4].to_sym][:itm_id]
			##   processseq_pare = @bgantts[key.to_s[0..-4].to_sym][:processseq]
		    ## else 				    
		    ##   itms_id_pare = value[:itm_id]
			##   processseq_pare = 999
			##end
			idx = plsql.trndetails_seq.nextval
			subkey = key.to_s
			key = key.to_s.scan(/.{1,3}/).join("00") + "00"
            str_trngantt ={:id=>idx,:key=>key,:keynext=>"00",:subkey=>subkey,
				            :orgtblname=>rec[:tblname],:orgtblid=>rec[:tblid]||=idx,
			                :mlevel=>value[:mlevel],:opeitms_id=>value[:opeitm_id],
			                :sno_prj=>rec[:sno_prj],:strdate=>value[:starttime],:strdate_est=>value[:starttime_est],
							:duedate=>value[:endtime],:duedate_est=>value[:endtime],
                            :parenum=>value[:nditm_parenum],:chilnum=>value[:nditm_chilnum],
							:qty=>value[:qty],:qty_alloc=>0,:prdpurshp=>value[:prdpurshp],
							:created_at=>Time.now,:updated_at=>Time.now,:remark=>"auto_created_by def trngantts ",:persons_id_upd=>0}
			##fprnt " line #{__LINE__} trngantt #{str_trngantt} "
		    plsql.trngantts.insert str_trngantt
        end
		sub_chk_create_prd_pur_shp_from_gantt str_trngantt,rec[:qty]	
		rec[:result_f] = "1"  ## normal end
		rec[:updated_at] = Time.now
		rec[:where] = {:id =>rec[:id]}
		plsql.mkopes.update rec
		plsql.commit
        dbcud = DbCud.new
        dbcud.perform(@new_sio_session_counter ,@sio_user_code,"") 
        plsql.connection.autocommit = true
		rescue
                fprnt"class #{self} : LINE #{__LINE__} $@: #{$@} " 
                fprnt"class #{self} : LINE #{__LINE__} $!: #{$!} " 		
		        rec[:result_f] = "9"  ## error
		        rec[:updated_at] = Time.now
		        rec[:where] = {:id =>rec[:id]}
		        plsql.mkopes.update rec
		        plsql.commit
	  end
    end
    handle_asynchronously :perform_gantt
	
	def sub_chk_create_prd_pur_shp_from_gantt gantt_rec,short_qty
    ###def sub_chk_create_prd_pur_shp_from_gantt gantt_rec,short_qty 
	   ###引当てKEY　 custXXXの時はorgtblname = custXXXX prd,pur,shpの時はorgtblname=prd,pur,shpXXXX
	   ### orgtblname = tblnameの時は上位部品から引当て可能
	   ###  孫の構成が異なっていても引当てる。 psub_chk_alloc_opeitmでチェック
	   strsql = %Q% select * from trngantts a where orgtblname = '#{gantt_rec[:orgtblname]}' and orgtblid = #{gantt_rec[:orgtblid]} 
	                and exists(select 1 from (select opeitms_id ,subkey ,sno_prj,max(key) max_key
					                          from trngantts where  orgtblname = '#{gantt_rec[:orgtblname]}' and orgtblid = #{gantt_rec[:orgtblid]}
					                          group by opeitms_id,subkey,sno_prj having sum(qty_alloc) < max(qty )) b
                               where a.opeitms_id = b.opeitms_id and a.subkey = b.subkey and a.sno_prj = b.sno_prj  and a.key = b.max_key)
					and key != '00000' /* topの	レコードは除く */
                    order by key
                    for update%							   
	   crtschs = plsql.select(:all,strsql)
	   ##fprnt "line:#{__LINE__} : srsql = #{strsql} "
	   @show_data_prd = get_show_data("r_prdschs")
	   @show_data_pur = get_show_data("r_purschs")
	   @show_data_shp = get_show_data("r_shpschs")
  	   crtschs.each do |rec|
	      command_c = {}
          command_c[:sio_session_counter] =   @new_sio_session_counter
	      command_c[:sio_user_code] = @sio_user_code 
          command_c[:sio_classname] = "auto_#{rec[:prdpurshp]}schs_add_by_trngantt"
		  command_c[:sio_recordcount] = 1
	      short_qty = sub_chk_free_prdpurshp rec,delay=false
	      short_qty = sub_chk_free_stk(rec) if short_qty > 0  ###在庫引当て
		  short_qty　= sub_chk_free_prdpurshp(rec,delay=true) if short_qty > 0   ##納期遅れ分
		  psub_create_pur_prd_shp_fm_trngantt( command_c,rec,short_qty ) if short_qty>0 and rec[:key] != "00000"
	   end	   
	end
	def psub_create_pur_prd_shp_fm_trngantt( command_c,trn,short_qty )
        ###
	       target_tbl = trn[:prdpurshp] + "schs"
           @screen_code = "r_#{target_tbl}"
	       command_c[:sio_code] = @screen_code
           command_c[:sio_viewname] = @screen_code
		   @show_data =  case trn[:prdpurshp]
		                      when "prd"
							       @show_data_prd
				              when "pur"
							       @show_data_pur
				              when  "shp"
							       @show_data_shp
		                 end
            
	       strsql = %Q% select * from trngantts a where orgtblname = '#{trn[:orgtblname]}' and orgtblid = #{trn[:orgtblid]} 
	                    and sno_prj = '#{trn[:sno_prj]}'   and key = '#{trn[:key][0..-6]}' %   
		   ##fprnt" line #{__LINE__} strsql='#{strsql}'"				
	       pare_trn = plsql.select(:first,strsql)
		   pare_trn = {} if pare_trn.nil?
		   pare_trn[:opeitms_id] ||= trn[:opeitms_id]   ### tblinkfldで使用
           pare_opeitm = plsql.select(:first,"select * from opeitms where id = #{pare_trn[:opeitms_id]} ")	
           opeitm = plsql.select(:first,"select * from opeitms where id = #{trn[:opeitms_id]} ")	   
	        strwhere = "where pobject_code_scr_src = 'mk_trngantts' and pobject_code_tbl_dest = '#{target_tbl}' and tblink_seqno = 10 "   ###after_self
			strwhere << " order by pobject_code_scr_src,pobject_code_tbl_dest,blktbsfieldcode_seqno "
	        target_flds = plsql.r_tblinkflds.all(strwhere)
			command_c[:id] = command_c["#{target_tbl.chop}_id".to_sym] = plsql.__send__("#{target_tbl}_seq").nextval
	        target_flds.each do |tfld|
			   ##
			   if  tfld[:tblinkfld_command_c] 
			       ##fprnt " tfld[:tblinkfld_command_c] :#{tfld[:tblinkfld_command_c]}:#{eval(tfld[:tblinkfld_command_c])} "
	               command_c[("#{target_tbl.chop}_"+tfld[:pobject_code_fld].sub("s_id","_id")).to_sym] = eval(tfld[:tblinkfld_command_c])
               end				   
	        end
			##fprnt "line #{__LINE__} command_c = #{command_c}"
	        sub_insert_sio_c    command_c 
	        sub_userproc_chk_set    command_c
    end

    def sub_chk_free_prdpurshp gantt_rec,delay
	    ## 上位構成ですでに引きあたってるか確認
        strsql = %Q% select (max(qty ) - sum(qty_alloc)) short_qty,max(keynext) max_key
            		from trngantts  where orgtblname = '#{gantt_rec[:orgtblname]}' and orgtblid = #{gantt_rec[:orgtblid]} 
	                and subkey = '#{gantt_rec[:subkey]}' and sno_prj = '#{gantt_rec[:sno_prj]}' group by subkey having sum(qty_alloc) < max(qty )  %
        rechk_short_qty = plsql.select(:first,strsql)
		if rechk_short_qty
		   short_qty = rechk_short_qty[:short_qty]
	       strsql = %Q% select tblname,tblid, qty,qty_alloc from trngantts 
                   where  OPEITMS_ID = #{gantt_rec[:opeitms_id]}
                   and ORGTBLname = tblname and orgtblid = tblid   /* 未引当てを示す*/
                   and  sno_prj = '#{gantt_rec[:sno_prj]}' and  qty > qty_alloc  /*未引当てテーブルにまだ未引当てが残っている。 */
                   and to_char(duedate,'yyyy/mm/dd HH24') #{if delay then  " > " else " <= " end}  '#{gantt_rec[:duedate].strftime("%Y/%m/%d %H")}'
                   order by duedate desc
                   for update%
		   unallocs = plsql.select(:all,strsql)   ### 未引当て
		   add_key = rechk_short_qty[:max_key].next ###ファイルの分割は98まで
		   unallocs.each do |free_rec|
		     qty_alloc = psub_chng_free_to_alloc( free_rec, gantt_rec,short_qty ,add_key) ### 未引当てから引当てへ
			 short_qty -= qty_alloc
			 break short_qty <= 0
			 add_key.next!
			 if add_key >= "99" ###ファイルの分割は98まで
			   fprnt " add_key over line #{__LINE__} gantt_rec:#{gantt_rec}"
			   raise
			 end
		   end 
		  else
            short_qty = 0
        end			
		return short_qty
	end
	
    def sub_chk_free_stk gantt_rec
	    ## 上位構成ですでに引きあたってるか確認
        strsql = %Q% select (max(qty ) - sum(qty_alloc)) short_qty,max(key) max_key from trngantts  where orgtblname = '#{gantt_rec[:orgtblname]}' and orgtblid = #{gantt_rec[:orgtblid]} 
	                and subkey = '#{gantt_rec[:subkey]}' and sno_prj = '#{gantt_rec[:sno_prj]}' group by subkey having sum(qty_alloc) < max(qty )  %
        rechk_short_qty = plsql.select(:first,strsql)
		if rechk_short_qty
		    short_qty = rechk_short_qty[:short_qty]
	        opt = {:opeitms_id=>gantt_rec[:opeitms_id]}
	        nxt_opeitm = sub_get_next_opeitm_processseq_and_loca_id opt
		    ###ルート以外のところに在庫がある時　未処理
		    if nxt_opeitm[:opeitms_id]
  	            strsql = %Q% select * from trngantts    /* qty_alloc 引当てされている数 */
                   where  OPEITMS_ID = #{nxt_opeitm[:opeitms_id]}
                   and ORGTBLname = tblname and orgtblid = tblid
                   and  b.sno_prj = '#{gantt_rec[:sno_prj]}'
                   and tblname = 'lotstkhists' and qty > qty_alloc 
                   order by duedate desc
                   for update%
		        unallocs = plsql.select(:all,strsql)   ### 未引当て
		        add_key = rechk_short_qty[:max_key][-2..-1]  ###ファイルの分割は98まで
		        unallocs.each do |free_rec|
		           qty_alloc = psub_chng_freestk_to_allocstk( free_rec,gantt_rec, short_qty,add_key ) ### 未引当てから引当てへ
			       short_qty -= qty_alloc
			       break short_qty <= 0
			       add_key.next!
			       if add_key >= "99" ###ファイルの分割は98まで
			            fprnt " add_key over line #{__LINE__} gantt_rec:#{gantt_rec}"
			            raise
			        end
				end
		    end
          else
            short_qty = 0		  
		end 
		return short_qty
	end
	
	def psub_chng_freestk_to_allocstk( free_rec,gantt_rec, short_qty ,add_key)
	    qty_alloc = if (free_rec[:qty] - free_rec[:qty_alloc]) >= short_qty then short_qty else (free_rec[:qty] - free_rec[:qty_alloc]) end
        chng_trns = plsql.trngantts.all("where orgtblname = '#{free_rec[:orgtblname]}' 
		                                 and orgtblid = #{free_rec[:orgtblid]} order by key ")
        chng_trns.each do |chng_rec|
		    if chng_rec[:key].size == 5
		         plsql.trngantts.update(:qty_alloc =>chng_rec[:qty_alloc]+qty_alloc,:where=>{:id=>chng_rec[:id]})  ##引当て元のfreeの数を減
			end
		end	
        stk_trns = plsql.trngantts.all("where orgtblname = '#{gantt_rec[:orgtblname]}' and orgtblid = #{gantt_rec[:orgtblid]}
                                       and key like '#{gantt_rec[:key][0..-2]+"00"}%' order by key ")
		base_key = stk_trns[0][:key][0..-2] + add_key
        stk_trns.each_with_index do |stk_rec,idx|
		    stk_rec[:keynext] = add_key if idx = 0 ############  最初のレコード(親)のみ			
		    if base_key.size == stk_rec[:key].size
			   stk_rec[:key] = base_key
			  else
                stk_rec[:key] = base_key + stk_rec[:key][(base_key.size - 1 )..-1]
			end
			org_rec_key = gantt_rec[:key][0..-2] + "00" + chng_rec[:key][5..-1]
			org_rec = plsql.select(:first,"select * from trngantts where  orgtblname = '#{gantt_rec[:orgtblname]}' and orgtblid = #{gantt_rec[:orgtblid]}  
			                                     and key = '#{org_rec_key}' ")
			stk_rec[:qty] = org_rec[:qty]									 
			pare_rec = plsql.select(:first,"select * from trngantts where  orgtblname = '#{gantt_rec[:orgtblname]}' and orgtblid = #{gantt_rec[:orgtblid]}  
			                                     and key = '#{chng_rec[:key][0..-6]}' ") 
			pare_rec ||={}  ###||={} key = 00000 00100の時
			stk_rec[:qty_alloc] = pare_rec[:qty_alloc]*(chng_rec[:chilnum]||=1)/(chng_rec[:parenum]||=1)
			stk_rec[:id] = plsql.trngnatts_seq.nextval
			plsql.trngantts.insert stk_rec
        end		
	end
		
	def  psub_chng_free_to_alloc( free_rec,gantt_rec, short_qty,add_key )
	    qty_alloc = if (free_rec[:qty] - free_rec[:qty_alloc]) >= short_qty then short_qty else (free_rec[:qty] - free_rec[:qty_alloc]) end
        chng_trns = plsql.trngantts.all("where orgtblname = '#{free_rec[:orgtblname]}' 
		                                 and orgtblid = #{free_rec[:orgtblid]} order by key ")
        chng_trns.each do |chng_rec|
		    if chng_rec[:key].size == 5
		         plsql.trngantts.update(:qty_alloc =>chng_rec[:qty_alloc]+qty_alloc,:where=>{:id=>chng_rec[:id]})  ##引当て元のfreeの数を減
			end
			chng_rec[:orgtblname] = gantt_rec[:orgtblname]
			chng_rec[:orgtblid] = gantt_rec[:orgtblid]
			chng_rec[:duedate] = gantt_rec[:duedate]
			chng_rec[:key] = gantt_rec[:key][0..-2] + add_key + chng_rec[:key][5..-1]
			org_rec_key = gantt_rec[:key][0..-2] + "00" + chng_rec[:key][5..-1]
			org_rec = plsql.trngantts.first("where  orgtblname = '#{gantt_rec[:orgtblname]}' and orgtblid = #{gantt_rec[:orgtblid]}  
			                                     and key = '#{org_rec_key}' ")
			chng_rec[:qty] = org_rec[:qty]									 
			pare_rec = plsql.trngantts.first("where  orgtblname = '#{gantt_rec[:orgtblname]}' and orgtblid = #{gantt_rec[:orgtblid]}  
			                                     and key = '#{chng_rec[:key][0..-6]}' ")  ###||={} key = 00000 00100の時
			pare_rec ||={} 
			chng_rec[:qty_alloc] = pare_rec[:qty_alloc]*(chng_rec[:chilnum]||=1)/(chng_rec[:parenum]||=1)
			chng_rec[:id] = plsql.trngnatts_seq.nextval
			plsql.trngantts.insert chng_rec
        end	
		###構成が変わった時、余分な引当てが発生する対処　未処理
	end
	def psub_chk_over_alloc
		strsql = %Q/ select orgtblname,orgtblid,substr(key,1,length(key)-2) key2,opeitms_id,sum(qty_alloc) qty_alloc,max(qty) qty
                     from trngantts 
                     where  orgtblname = '#{gantt_rec[:orgtblname]}' and orgtblid = #{gantt_rec[:orgtblid]}  
			                and key like '#{gant_rec[:key][0..-2]}%' 					 
			         group by orgtblname,orgtblid,substr(key,1,length(key)-2),opeitms_id
			         having sum(qty_alloc)>max(qty) /
		over_alloc_itms = plsql.select(:all,strsql)
		psub_over_alloc_to_free over_alloc_itms
	end
		
	
	def psub_chk_alloc_opeitm( free_rec,gantt_rec, short_qty )
	    ## gantt_recにはあるがfree_recからの引当てにはないopeitms  途中で構成が変更された。
	end
	def psub_over_alloc_to_free over_alloc_itms
	    over_alloc_itms.each do |over_itm|
		    over_qty = over_itm[:qty_alloc] - over_itm[:qty]
		    alloc_tbls = plsql.trngantts.all("where orgtblname = tblname and orgtblid = tblid and opeitms_id = #{over_itm[:opeitms_id]} 
			                                   and qty_alloc < qty ")
			alloc_tbls.each do |alloc_tbl|
			   alloc_tbl[:qty_alloc] = if over_qty > (alloc_tbl[:qty_alloc] - alloc_tbl[:qty])
			                               minus_qty = (alloc_tbl[:qty_alloc] - alloc_tbl[:qty])
			                               over_qty -=  (alloc_tbl[:qty_alloc] - alloc_tbl[:qty])
                            			   alloc_tbl[:qty]
									   else
			                               minus_qty = over_qty
									       over_qty = 0
    									   alloc_tbl[:qty_alloc] += over_qty
									   end  
				plsql.trngantts.update(:qty_alloc=>alloc_tbl[:qty_alloc],:where=>{:id=>alloc_tbl[:id]})  ###未引当ての戻し
				over_trn = plsql.trngantts.first("where  orgtblname = '#{over_itm[:orgtblname]}' and orgtblid = #{over_itm[:orgtblid]}  
			                                      and key like '#{gant_rec[:key][0..-2]}%'
												  and tblname = '#{alloc_tbl[:tblname]}' and tblid = #{alloc_tbl[:tblid]}")
				plsql.trngantts.update(:qty_alloc=>over_trn[:alloc]-minus_qty,:where=>{:id=>over_trn[:id]})  ##過剰引当て数解除								  
				break if over_qty <= 0					   
			end			
		end
	end
 end ## class
