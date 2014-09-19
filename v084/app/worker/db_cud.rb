class DbCud  < ActionController::Base
 ## @queue = :default
 ## def self.perform(sio_id,sio_view_name)
 ##　importと 画面でエラー検出すること。
 ##  shp,arvの更新条件がまだできてない。
    Blksdate = Date.today -1  ##在庫基準日　sch,ord,instのこれ以前の納期は許さない。
	plsql.blkstddates.update({:datevalue =>Blksdate,:where=>{:key=>"blksdate"}})
    def perform(sio_session_counter,user_id)
      begin
	    @sio_user_code = user_id
        ###plsql.execute "SAVEPOINT before_perform"
        plsql.connection.autocommit = false
        crt_def_all  unless respond_to?("dummy_def")
	    @new_sio_session_counter  = user_seq_nextval(@sio_user_code)
        @pare_class = "batch"
        target_sio_tbls = plsql.__send__("userproc#{user_id.to_s}s").all("where session_counter = #{sio_session_counter}")
		target_sio_tbls.each do |tg_tbl|
		    strsql = "where sio_session_counter = #{sio_session_counter} and sio_command_response = 'C' and sio_user_code = #{user_id} "
            command_cs = plsql.__send__(tg_tbl[:tblname]).all(strsql)
            ##debugger
            r_cnt0 = 1
			tblname = command_cs[0][:sio_viewname].split(/_/,3)[1] 
            command_cs.each do |i|  ##テーブル、画面の追加処理
                update_table i,tblname,r_cnt0 ### 本体
                r_cnt0 += 1
                reset_show_data_screen if tblname =~ /screen|pobjgrps/   ###キャッシュを削除
            end
         end	
      rescue 
		      ##plsql.rollback
              plsql.__send__("userproc#{user_id.to_s}s").update :status=> "error " ,:updated_at=>Time.now,:where=>{ :session_counter =>sio_session_counter}
			  if  @sio_result_f !=   "1" 
                  fprnt"class #{self} : LINE #{__LINE__} $@: #{$@} " 
                  fprnt"class #{self} : LINE #{__LINE__} $!: #{$!} " 
			  end  
         else
              ##debugger
			  plsql.__send__("userproc#{user_id.to_s}s").update :status=> "normal end" ,:updated_at=>Time.now,:where=>{ :session_counter =>sio_session_counter}
			  if @userproc_insert   ###tblinkがある時
				 plsql.commit   
		         ndbcud = DbCud.new
                 ndbcud.perform(@new_sio_session_counter,user_id)
				 ###debugger
			  end
      ensure
	          plsql.commit   ##
              plsql.connection.autocommit = true         
      end  #begin  
    end   ##perform
      handle_asynchronously :perform  	  
    def reset_show_data_screen
	
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
    
    def update_table rec,tblname,r_cnt0
      begin 	       
		   sub_command_instance_variable rec   if  tblname != "rubycodings" and tblname !~ /tblink/
           command_r = {}
           command_r = rec.dup
           command_r[:sio_recordcount] = r_cnt0
           tmp_key = {}
           @src_tbl = {}   ###テーブル更新用
           rec.each do |j,k|
             j_to_stbl,j_to_sfld = j.to_s.split("_",2)		    
              if   j_to_stbl == tblname.chop   ##本体の更新
	              @src_tbl[j_to_sfld.sub("_id","s_id").to_sym] = k  if k  ###org tbl field name
				  if respond_to?("psub_tbl_fld_set_#{j_to_sfld.sub('_id','s_id')}")
				     @src_tbl[j_to_sfld.sub("_id","s_id").to_sym] = __send__("psub_tbl_fld_set_#{j_to_sfld.sub('_id','s_id')}")
				  end 	 
                  @src_tbl[j_to_sfld.to_sym] = nil  if k  == "\#{nil}"  ##
              end   ## if j_to_s.
           end ## rec.each
           @src_tbl[:persons_id_upd] = rec[:sio_user_code]
           if  @src_tbl[:sio_message_contents].nil?
		       sub_tblinks_before rec
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
                 sub_tblinks_after rec			   
           end  ##@src_tbl[:sio_message_contents].nil
           rescue  
                ##debugger
                plsql.rollback
                @sio_result_f = command_r[:sio_result_f] =   "1" 
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
            @sio_result_f = command_r[:sio_result_f] =  "0"
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
            crt_def_rubycode  if  tblname == "rubycodings"  
          ensure
		    ##debugger
            sub_insert_sio_r   command_r    ## 結果のsio書き込み
            ###raise   ### plsql.connection.autocommit = false   ##test 1/19 ok
          end ##begin
          raise if @sio_result_f ==   "1" 
    end
    def undefined
      nil   
    end
    def crt_def_all
      eval("def dummy_def \n end")
      crt_defs = plsql.rubycodings.all("where expiredate > sysdate")
      crt_defs.each do |i|
          @src_tbl = i
		  crt_def_rubycode
      end
	end
    def crt_def_rubycode
     if @src_tbl[:expiredate]||Date.today > Date.today + 1
	     if @src_tbl[:code]
		    strdef = "def #{@src_tbl[:code]}  #{@src_tbl[:hikisu]} \n" 
			strdef << @src_tbl[:rubycode]
			strdef <<"\n end"
			eval(strdef)
		 end
	  end
    end

    def sub_command_instance_variable command_c
     ##debugger
	 str = ""
     command_c.each do |key,val|
	    case 
		     when key.to_s =~ /rubycode/ then
	              str << "@#{key.to_s} = #{val}\n"
		     when val.class == String then
	              str << "@#{key.to_s} = %Q%#{val}%\n"
		     when val.class == Date then
	              str << "@#{key.to_s} = %Q%#{val}%.to_date\n"	  
		     when val.class == Time then
	              str << "@#{key.to_s} = %Q%#{val}%.to_time\n"
		     when val.class == NilClass 
	              str << "@#{key.to_s} = nil\n"
		     else 
			      ##debugger
	              str << "@#{key.to_s} = #{val}\n"
	    end
	 end
	 ##debugger
	 eval(str)
    end
    def sub_tblinks_before command_c
     ##debugger
     do_all = plsql.r_tblinks.all("where pobject_code_scr_src = '#{command_c[:sio_viewname]}' and tblink_expiredate > sysdate order by tblink_seqno ")
	 do_all.each do |doba|
	     sub_do_tblinks doba if doba[:tblink_beforeafter] == "before"
		 if doba[:tblink_beforeafter] == "before_self"
		     strwhere = " where pobject_objecttype = 'screen' and pobject_code = '#{doba[:pobject_code_scr_src]}' and rubycoding_expiredate > sysdate" 
		     do_tbls = plsql.r_rubycodings.all(strwhere)
			 do_tbls.each do |do_tbl|
			    __send__(do_tbl[:rubycoding_code], command_c ) 
			 end
		 end
	 end
    end 
    def sub_tblinks_after command_c
     ##debugger
	 do_all = plsql.r_tblinks.all("where pobject_code_scr_src = '#{command_c[:sio_viewname]}' and tblink_expiredate > sysdate order by tblink_seqno ")
	 do_all.each do |doba|
	     sub_do_tblinks doba   if doba[:tblink_beforeafter] == "after"
		 if doba[:tblink_beforeafter] == "after_self"
		     strwhere = " where pobject_objecttype = 'screen' and pobject_code = '#{doba[:pobject_code_scr_src]}' and rubycoding_expiredate > sysdate" 
		     do_tbls = plsql.r_rubycodings.all(strwhere)
			 do_tbls.each do |do_tbl|
			    __send__(do_tbl[:rubycoding_code], command_c ) 
			 end
		 end
	 end
    end 
    def sub_do_tblinks doba
        strwhere = "where pobject_code_scr_src = '#{doba[:pobject_code_scr_src]}' and pobject_code_tbl_dest = '#{doba[:pobject_code_tbl_dest]}' "
	    strwhere << " and tblink_beforeafter = '#{doba[:tblink_beforeafter]}'  and tblink_seqno = '#{doba[:tblink_seqno]}' "
	    upd_tblinkkys = plsql.r_tblinkkys.all(strwhere)
	    strwhere = "where "
	    upd_tblinkkys.each do |updk|
            strwhere << " #{updk[:pobject_code_fld]} = '#{eval(updk[:tblinkky_command_c])}'   and"		 
	    end
		if strwhere.size < 7
           	fprnt " err  line:#{__LINE__} doba #{doba} "	
			fprnt " err  line:#{__LINE__} key record nothing "
			raise
		end
	    tbln = doba[:pobject_code_tbl_dest]
	    ##debugger
	    @target_rec = plsql.__send__(tbln).first(strwhere[0..-5])
	    eval(doba[:tblink_rubycode_before]) if doba[:tblink_rubycode_before] 
	    case @target_rec
	    when nil
		    case @sio_classname
			     when /_add_/
					 @target_rec = {}
				     tblnseq = tbln + "_seq"				     
					 @target_rec[:id]  = plsql.__send__(tblnseq).nextval
					 @id = @target_rec[:id]  
					 @target_rec[:created_at] = Time.now
				 when /_edit_/
                     eval(doba[:tblink_when_edit_notfound]) if doba[:tblink_when_edit_notfound]
				 when /_delete_/
                     eval(doba[:tblink_when_delete_notfound]) if doba[:tblink_when_delete_notfound] 				 
			end
        else 
		    case @sio_classname
			     when /_add_/
				     fprnt "err line#{__LINE__} same key exists tbln:#{tbln}  -->strwhere:#{strwhere} "
					 raise
				 when /_edit_/
				 when /_delete_/
			end			
	    end
	    eval(doba[:tblink_rubycode_after]) if doba[:tblink_rubycode_after] 
	    command_c = {} 
        command_c[:sio_session_counter] =   @new_sio_session_counter ##
        command_c[:sio_classname] = @sio_classname
        command_c[:id] = @id 
	    command_c[:sio_code] = "r_#{tbln}" 
	    command_c[:sio_viewname] = "r_#{tbln}"
        command_c = sub_set_target_rec( command_c ,doba)
	    @show_data = get_show_data(command_c[:sio_code])  ##char_to_number_dataとともに見直し]]
	     p "__LINE__ #{__LINE__} command_c #{command_c} " ##debugger
	    command_c[:sio_user_code] =   @sio_user_code ##
	    sub_insert_sio_c    command_c 
	    sub_userproc_chk_insert command_c
    end
 
    def sub_set_target_rec command_c ,doba
        tblchop = command_c[:sio_viewname].split("_")[1].chop + "_"
        @target_rec.each do |key,val|
	       command_c[(tblchop+key.to_s.sub("s_id","_id")).to_sym] = val if val 
	    end
	    strwhere = "where pobject_code_scr_src = '#{doba[:pobject_code_scr_src]}' and pobject_code_tbl_dest = '#{doba[:pobject_code_tbl_dest]}' " 
	    strwhere << " and tblink_beforeafter = '#{doba[:tblink_beforeafter]}'  and tblink_seqno = '#{doba[:tblink_seqno]}'  "
		strwhere << " order by pobject_code_view_src,pobject_code_tbl_dest,blktbsfieldcode_seqno "
	    target_flds = plsql.r_tblinkflds.all(strwhere)
	    target_flds.each do |tfld| 	
			 fprnt  " tblinkflds line:#{__LINE__}   tfld[:tblinkfld_command_c] #{tfld[:tblinkfld_command_c]} "
	        command_c[(tblchop+tfld[:pobject_code_fld].sub("s_id","_id")).to_sym] = eval(tfld[:tblinkfld_command_c]) if  tfld[:tblinkfld_command_c]
	    end
	    return command_c
    end
 
    def sub_userproc_chk_insert command_c    
        strwhere = " where tblname = 'sio_#{command_c[:sio_viewname]}' and "
		strwhere << " session_counter = #{command_c[:sio_session_counter]} "
        chkuserproc = plsql.__send__("userproc#{command_c[:sio_user_code].to_s}s").first(strwhere)
		sub_userproc_insert command_c if chkuserproc.nil?
		@userproc_insert = true
    end
    def sub_create_prd_pur_shp_sch_by_stk rec,inout 
      strwhere = "where " 
      strwhere << " itms_id = #{rec[:itms_id]}  and "  if rec[:itms_id]
      strwhere << " locas_id = #{rec[:locas_id]}  and " if rec[:locas_id]
      strwhere << " sno_prj = '#{rec[:sno_prj]}'  and " if rec[:sno_prj]
      strwhere << " processseq = #{rec[:processseq]}    and itms_id_pare = #{rec[:itms_id_pare]}       " if rec[:processseq]
      short_stks = plsql.blk_chk_short_stk_qty.all(strwhere[0..-5])
      short_stks.each do |short_stk|
	    prev_ope = plsql.opeitms.first("where itms_id = #{short_stk[:itms_id_pare]} and processseq < #{short_stk[:processseq]} ") 
	    if prev_ope	or short_stk[:itms_id] != short_stk[:itms_id_pare]
	     short_qty = short_stk[:short_qty] * -1
	     strwhere = "where  itms_id = #{short_stk[:itms_id]}  and  locas_id = #{short_stk[:locas_id]}  and " 
         strwhere << " sno_prj = '#{short_stk[:sno_prj]}'  and  processseq = #{short_stk[:processseq]}  and  itms_id_pare = #{short_stk[:itms_id_pare]}    " 
		 strwhere << " order by itms_id,locas_id,itms_id_pare,processseq,sno_prj,strdate "
         create_prd_pur_shps = plsql.blk_short_stk_qty_all.all(strwhere)
	     command_c = {}
	     command_c[:sio_user_code] =   @sio_user_code ##
		 p_opeitm = {}		 
		 p_opeitm[:itms_id_pare] = short_stk[:itms_id_pare]
		 p_opeitm[:itms_id] = short_stk[:itms_id]
		 p_opeitm[:processseq] = short_stk[:processseq]
	     @prev_opeitm = sub_get_prev_opeitm(p_opeitm) 
	     target_tbl = @prev_opeitm[:prdpurshp] + "schs"
         command_c[:sio_classname] = "auto_#{target_tbl}_add_by_stkhists"
         @screen_code = "r_#{target_tbl}"
	     command_c[:sio_code] = @screen_code
         command_c[:sio_viewname] = @screen_code
         command_c[:sio_session_counter] =   @new_sio_session_counter
	     @show_data = get_show_data(command_c[:sio_code])  ##char_to_number_dataとともに見直し
	     create_prd_pur_shps.each do |src_tbl|
	        command_c[:id] = command_c["#{target_tbl.chop}_id".to_sym] = plsql.__send__("#{target_tbl}_seq").nextval
		    @src_tbl = src_tbl.dup
			@src_tbl[:id] = command_c[:id]
		    @src_tbl[:priority] = inout[:priority]
			if  short_qty >= src_tbl[:s_qty]*-1
                @src_tbl[:s_qty] = 	src_tbl[:s_qty]*-1
                short_qty += src_tbl[:s_qty]
              else
			    @src_tbl[:s_qty] = short_qty
				short_qty = 0
            end			  
		    @src_tbl[:prdpurshp] = target_tbl[0..2]
	        strwhere = "where pobject_code_view_src = 'r_stkhists' and pobject_code_tbl_dest = '#{target_tbl}' and tblink_seqno = 10 "   ###after_self
			strwhere << " order by pobject_code_view_src,pobject_code_tbl_dest,blktbsfieldcode_seqno "
	        target_flds = plsql.r_tblinkflds.all(strwhere)
	        target_flds.each do |tfld|
			   ## 
			   fprnt " tfld[:tblinkfld_command_c] :#{tfld[:tblinkfld_command_c]} "
	           command_c[("#{target_tbl.chop}_"+tfld[:pobject_code_fld].sub("s_id","_id")).to_sym] = eval(tfld[:tblinkfld_command_c]) if  tfld[:tblinkfld_command_c] 
	        end
	        sub_insert_sio_c    command_c 
	        sub_userproc_chk_insert command_c
			break if short_qty <= 0
	     end
		end 
	  end	 
    end
 
 end ## class
