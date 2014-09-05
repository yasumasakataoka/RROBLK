class DbCud  < ActionController::Base
 ## @queue = :default
 ## def self.perform(sio_id,sio_view_name)
 ##　importと 画面でエラー検出すること。
 ##  shp,arvの更新条件がまだできてない。
    Blksdate = Date.today -1  ##在庫基準日　sch,ord,instのこれ以前の納期は許さない。
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
			      p  $@
                  p  " err     #{$!}"
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
	              ###2013/3/25 追加覚書　 xxxx_id_yyyy   yyyy:自身のテーブルの追加  プラス _idをs_idに
	              @src_tbl[j_to_sfld.sub("_id","s_id").to_sym] = k  if k  ###org tbl field name
                  @src_tbl[j_to_sfld.to_sym] = nil  if k  == "\#{nil}"  ##画面項目クリアー
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
                p  $@
                p  " err     #{$!}"
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
				     eval(doba[:tblink_when_add_dup]) if doba[:tblink_when_add_dup]
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
	 ##debugger
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
	 strwhere << " and tblink_beforeafter = '#{doba[:tblink_beforeafter]}'  and tblink_seqno = '#{doba[:tblink_seqno]}'  order by tblinkfld_seqno "
	 target_flds = plsql.r_tblinkflds.all(strwhere)
	 ##debugger
	 target_flds.each do |tfld|
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
 def psub_create_prd_pur_shp ngantt,rec,tblname
    #stkhists view
    command_c = {}  ## r_stkhists
	command_c = plsql.r_stkhists.first("where id = #{rec[:id]} ")
	sub_command_instance_variable command_c
	strwhere = "where pobject_code_scr_src = 'r_stkhists' and pobject_code_tbl_dest = '#{ngantt[:prd_pur_shp]}schs' " 
	strwhere << " and tblink_beforeafter = 'after_self'  and tblink_seqno = 10  order by tblinkfld_seqno"
	target_flds = plsql.r_tblinkflds.all(strwhere)
    if  ngantt[:prd_pur_shp] =~ /prd|pur/
        duedatesym = "#{ngantt[:prd_pur_shp]}sch_duedate".to_sym
     else
	    duedatesym = :shpsch_depdate
    end
	command_new = {}  ## xxxschs
	@screen_code = "r_#{ngantt[:prd_pur_shp]}schs" 
	command_new[:sio_code] = command_new[:sio_viewname] = @screen_code
    command_new[:sio_classname] = "stkhist_auto_add_#{@screen_code}"
    command_new[:sio_session_counter] =   @new_sio_session_counter
    command_new[:sio_user_code] =   @sio_user_code ##
	target_flds.each do |tfld|
	    command_new[("#{ngantt[:prd_pur_shp]}sch_"+tfld[:pobject_code_fld].sub("s_id","_id")).to_sym] = eval(tfld[:tblinkfld_command_c]) if  tfld[:tblinkfld_command_c] 
	end
	strsql = "select sum(#{ngantt [:prd_pur_shp]}sch_qty - #{ngantt [:prd_pur_shp]}sch_qty_ord) balqty from r_#{ngantt [:prd_pur_shp]}schs "
	strsql << " where opeitm_itm_id =  #{command_c[:stkhist_itm_id]} and opeitm_processseq = #{command_c[:stkhist_processseq]} "
	strsql << " and #{ngantt [:prd_pur_shp]}sch_#{duedatesym.to_s.split("_",2)[1]} >= to_date('#{Blksdate}','yyyy-mm-dd') "
	strsql << " and #{ngantt [:prd_pur_shp]}sch_qty > #{ngantt [:prd_pur_shp]}sch_qty_ord "
	strsql << " group by opeitm_itm_id,opeitm_processseq "
	chk_balqty = plsql.select(:first,strsql)
	qtysym = "#{ngantt[:prd_pur_shp]}sch_qty".to_sym
	##command_new[qtysym] = rec[:qty_sch]*ngantt[:nditm_chilnum]/ngantt[:nditm_parenum]*-1  ##小数点桁数
	command_new[qtysym] -= if chk_balqty then chk_balqty[:balqty] else 0 end
	debugger
	if command_new[qtysym]  > 0
       @show_data = get_show_data @screen_code
       command_new[:id] = plsql.__send__("#{ngantt[:prd_pur_shp]}schs_seq").nextval
       command_new[("#{ngantt[:prd_pur_shp]}sch_id").to_sym] =  command_new[:id]
       sub_insert_sio_c    command_new
       sub_userproc_chk_insert command_new
	end   
 end
 def  sub_get_opeitm_id_fm_itm_id p_opeitm
      strwhere = " where itms_id = #{p_opeitm[:itm_id]} and expiredate > sysdate and  "
      strwhere << " processseq =  #{if p_opeitm[:processseq] then p_opeitm[:processseq]  else 999 end} and "
      strwhere << " priority  =  #{if p_opeitm[:priority] then p_opeitm[:priority]  else 999 end} "	  
	  opeitm_id = plsql.opeitms.first(strwhere)
	  if opeitm_id.nil?
	     p " logic err sub_get_opeitm_id_fm_itm_id  --- p_opeitm:#{p_opeitm} "
		 raise
      end
      return opeitm_id[:id]	  
 end
 def  sub_get_opeitm_next_processseq p_opeitm
      strwhere = " where itms_id = #{p_opeitm[:itm_id]} and expiredate > sysdate and  "
      strwhere << " processseq >  #{p_opeitm[:processseq]} and "
      strwhere << " priority  =  #{if p_opeitm[:priority] then p_opeitm[:priority] else 999 end} "	  
	  opeitm_id = plsql.opeitms.first(strwhere)
	  if opeitm_id.nil?
	     p " sub_get_opeitm_prv_processseq  --- p_opeitm:#{p_opeitm} "
		 raise
      end
      return opeitm_id[:processseq]	  
 end
end ## class
