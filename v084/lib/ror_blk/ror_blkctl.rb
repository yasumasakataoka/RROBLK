# RorBlk
# 2099/12/31を修正する時は　2100/01/01の修正も
 module Ror_blkctl    
	Blksdate = Date.today - 1  ##在庫基準日　sch,ord,instのこれ以前の納期は許さない。
	Confirmdate = Date.today + 7  ##在庫基準日　sch,ord,instのこれ以降の納期は許さない。
	Db_adapter = ActiveRecord::Base.configurations[Rails.env]['adapter']
	System_person_id = ActiveRecord::Base.connection.select_value("select id from persons where code = '0'")
    def sub_blkget_grpcode     ## fieldsの名前
        return @pare_class if  @pare_class == "batch"
        usrgrp_code =  ActiveRecord::Base.connection.select_value("select usrgrp_code from r_persons where person_email = '#{current_user[:email]}'")
        ###p " current_user[:email] #{current_user[:email]}"
        if usrgrp_code.nil?
           p "add person to his or her email "  
		   raise   ### 別画面に移動する　後で対応
            else
            usrgrp_code
        end 
    end
	def proc_blkgetpobj code,ptype
		sub_blkgetpobj code,ptype
	end
    def sub_blkgetpobj code,ptype    ###
        fstrsqly = ""
        grp_code =  sub_blkget_grpcode 
		if grp_code == "batch"
            oragname = code
		end
        if code =~ /_id/ or   code == "id" 
            oragname = code
        else
            orgname = ""      
            basesql = "select pobjgrp_name from R_POBJGRPS where POBJGRP_EXPIREDATE > current_date AND USRGRP_CODE = '#{grp_code}' and   "
            fstrsql = basesql +  " POBJECT_CODE = '#{code}' and POBJECT_OBJECTTYPE = '#{ptype}' "
            ###  フル項目で指定しているとき
            orgname = ActiveRecord::Base.connection.select_value(fstrsql) 
			orgname ||= code
            if orgname == code and ptype == "view_field" then  ###view項目の時はテーブル項目まで
                orgname = ""
                code.split('_').each_with_index do |value,index|
		            fstrsqly =  basesql +  "   POBJECT_CODE = '#{if index == 0 then value + "s" else value end}'  and POBJECT_OBJECTTYPE = '#{if index == 0 then  'tbl' else 'tbl_field' end}' "
		            if ActiveRecord::Base.connection.select_value(fstrsql)   ## tbl name get
			            orgname <<  ActiveRecord::Base.connection.select_value(fstrsql)  + "_"
		            else
                        orgname << value + "_"
                    end   
                end   ## do code. 
                orgname.chop!
            end ## if orgname
        end  ## if ocde
        return orgname 
    end  ## def getpobj
    def sub_blkget_code_fm_name name,ptype    ###
         grp_code =  sub_blkget_grpcode 
         if name =~ /_id/ or   name == "id" then
            orgcode = name
           else
            orgcode = ""      
            basesql = "select POBJECT_CODE  from R_POBJGRPS where POBJGRP_EXPIREDATE > current_date AND USERGROUP_CODE = '#{grp_code}' and   "
            basesql  <<  " pobjgrp_name = '#{name}' and POBJECT_OBJECTTYPE = '#{ptype}' "
            pobject_code = ActiveRecord::Base.connection.select_value(basesql)
            orgcode =  if pobject_code then pobject_code else name end			
         end  ## if ocde
      return orgcode ||= name
    end  ## def getpobj
    def user_seq_nextval
      ses_cnt_usercode = "userproc_ses_cnt" + @sio_user_code.to_s ###user_code 15char 以下
      unless proc_sequences_exist(ses_cnt_usercode) 
             ActiveRecord::Base.connection.execute("CREATE SEQUENCE #{ses_cnt_usercode}")
             ActiveRecord::Base.connection.execute("CREATE SEQUENCE userproc#{@sio_user_code.to_s}s_seq")
             userprocs = "CREATE TABLE userproc#{@sio_user_code.to_s}s
                   ( id numeric(38)
				     ,session_counter numeric(38)
                     ,tblname VARCHAR(30)
                     ,status VARCHAR(20)
                     ,cnt numeric(38)
                     ,cnt_out numeric(38)
                     ,Persons_id_Upd numeric(38)
                     ,Update_IP varchar(40)
                     ,created_at timestamp(6)
                     ,Expiredate date
                     ,Updated_at timestamp(6)
                     ,CONSTRAINT userproc#{@sio_user_code.to_s}s_id_pk PRIMARY KEY (id)
					 ,CONSTRAINT userproc#{@sio_user_code.to_s}s_uk1 UNIQUE(session_counter,tblname)
                      )"					  
              ActiveRecord::Base.connection.execute(userprocs)
      end
      return proc_get_nextval(ses_cnt_usercode) 
    end
    def user_parescreen_nextval
        parescreen_cnt_usercode = "parescreen_a" + @sio_user_code.to_s
        unless proc_sequences_exist(parescreen_cnt_usercode)  
            ActiveRecord::Base.connection.execute("CREATE SEQUENCE #{parescreen_cnt_usercode}")
            parescreens = "CREATE TABLE parescreen#{@sio_user_code.to_s}s
                   ( id numeric(38)
                    ,rcdkey VARCHAR(200)
                     ,strsql VARCHAR(4000)
                     ,ctltbl VARCHAR(4000)
                     ,Persons_id_Upd numeric(38)
                     ,Update_IP varchar(40)
                     ,created_at timestamp(6)
                     ,Expiredate date
                     ,Updated_at timestamp(6)
                     , CONSTRAINT parescreen#{@sio_user_code.to_s}s_id_pk PRIMARY KEY (id)
                      )"
              ActiveRecord::Base.connection.execute(parescreens)
        end
        return proc_get_nextval(parescreen_cnt_usercode) 
    end
    def proc_update_table flg,command_r,r_cnt0  ##rec = command_c command_rとの混乱を避けるためrecにした。   
        begin
            tmp_key = {}
			tblname = command_r[:sio_viewname].split("_")[1]
            if  command_r[:sio_message_contents].nil? 
				proc_set_src_tbl  command_r ### @src_tblの項目作成
				if command_r[:sio_classname] =~ /_add_|_edit_|_delete_/ and tblname !~ /tblink/  ## rec = command_c = sio_xxxxx
					proc_command_before_instance_variable(command_r) 
					proc_tblinks(command_r) do 
						"before"
					end
				end
				command_r[:sio_recordcount] = r_cnt0
				if tblname =~ /^mk/ and @screen_code !~ /#{tblname}/  ###mkxxxxは追加のみ
					proc_tbl_add_arel(tblname,@src_tbl)
				else
					case command_r[:sio_classname]
						when /_add_/
							proc_tbl_add_arel(tblname,@src_tbl)
						when /_edit_/ 
							##@src_tbl[:where] = {:id => @src_tbl[:id]}             ##変更分のみ更新
							proc_tbl_edit_arel(tblname,@src_tbl," id = #{@src_tbl[:id]}")
						when  /_delete_/ 
							if tblname =~ /schs$|ords$|insts$|acts$/  ##alloctblにかかわるtrnは削除なし
								@src_tbl[:qty] = 0 if @src_tbl[:qty] 
								@src_tbl[:amt] = 0 if @src_tbl[:amt]
								@src_tbl[:tax] = 0 if @src_tbl[:tax]      ##変更分のみ更新
								proc_tbl_edit_arel(tblname,@src_tbl," id = #{@src_tbl[:id]}")
							else			
								proc_tbl_delete_arel(tblname," id = #{@src_tbl[:id]}")
							end
							### blkukyの時は　constrainも削除
						else
							logger.debug "command_r = '#{command_r}'"
							raise
					end   ## case iud
				end
				if command_r[:sio_classname] =~ /_add_|_edit_|_delete_/ and tblname !~ /tblink/  ## rec = command_c = sio_xxxxx
					proc_command_after_instance_variable(command_r)
					proc_tblinks(command_r) do 
						"after"
					end 
				end
            end  ##@src_tbl[:sio_message_contents].nil
          rescue
                ActiveRecord::Base.connection.rollback_db_transaction()
                @sio_result_f = command_r[:sio_result_f] =   "9"  ##9:error 
                command_r[:sio_message_contents] =  "class #{self} : LINE #{__LINE__} $!: #{$!} "    ###evar not defined
                command_r[:sio_errline] =  "class #{self} : LINE #{__LINE__} $@: #{$@} "[0..3999]
                logger.debug"error class #{self} : #{Time.now}: #{$@} " 
                logger.debug"error class #{self} : $!: #{$!} " 
                logger.debug"  command_r: #{command_r} " 
          else
            @sio_result_f = command_r[:sio_result_f] =  "1"   ## 1 normal end
            command_r[:sio_message_contents] = nil
            command_r[(tblname.chop + "_id")] =  command_r[:id] = @src_tbl[:id]
			proc_delayjob_or_optiontbl(tblname,command_r[:id]) ###  if vproc_optiontabl(tblname)
			crt_def_all if tblname =~ /rubycodings|tblink/
            ##crt_def_tb if  tblname == "blktbs"   
          ensure
            sub_insert_sio_r   command_r    ## 結果のsio書き込み
        end ##begin
        raise if @sio_result_f ==   "9" 
    end
	##def vproc_optiontabl tblname
	##	if tblname =~ /rplies$|mksch|mkords|results$/ then true else false end  ###mkinsts,mkactsは使用してない　12/9
	##end
	def proc_delayjob_or_optiontbl tblname,id	
		###ActionController::Base::DbCud.new
        case tblname
			when   /mkschs|mkords|mkbttables/   ###mkinsts,mkactsは使用してない　12/9
		        vproc_tbl_mk  tblname,id 
				 ####when   /schs$|ords$|insts$|acts$/				 
			when   /rplies$/ 
				dbrply = DbCud.new
			    dbrply.perform_setreplies tblname,id,@sio_user_code,@src_tbl[:prdpurshp] ###reply のuser_id はinteger		 
			when   /results$/ 
				dbresult = DbCud.new
			    dbresult.perform_setresults id  ###reply のuser_id はinteger 
			##when /rubycodings|tblink/
			##	dbruby = DbCud.new
			##   dbruby.perform_crt_def_all
        end				 					
	end
	def vproc_tbl_mk tblname,id
		str_id = if id then " and id = #{id} " else "" end
	    ##if tblname == "mkinsts"  then order_by_add = " autocreate_inst, "  else order_by_add = "" end
	    recs = ActiveRecord::Base.connection.select_all("select * from #{tblname} where result_f = '0' #{str_id}  order by id")   ##0 未処理
        dbmk = DbCud.new 
		tbl = {}
		tbl[:result_f] = "5"
		recs.each do |rec|
			proc_tbl_edit_arel tblname,tbl," id = ( #{rec["id"]} )"
		end
		case tblname
			when "mkschs"  ##not spport
				dbmk.perform_mkschs recs
			when "mkbttables"
				dbmk.perform_mkbttables recs
			when "mkords"
				dbmk.perform_mkords recs
		end
	end	
	def proc_insert_sio_c command_c   ###要求  無限ループにならないこと
        ###command_c = char_to_number_data(command_c) ###画面イメージからデータtypeへ   入口に変更すること
        command_c[:sio_id] =  proc_get_nextval("SIO_#{command_c[:sio_viewname]}_SEQ")
        command_c[:sio_term_id] =  request.remote_ip  if respond_to?("request.remote_ip")  ## batch処理ではrequestはnil　　？？ 
        command_c[:sio_command_response] = "C"
        command_c[:sio_add_time] = Time.now
		command_c = vproc_command_c_dflt_set_fm_rubycoding(command_c) if command_c[:sio_classname] =~ /_add_|_edit_|_delete_/
		begin
			proc_tbl_add_arel("sio_#{command_c[:sio_viewname]}",command_c)
		rescue
			ActiveRecord::Base.connection.rollback_db_transaction()
			logger.debug " proc_insert_sio_c err   ・・・・・　command_c = #{command_c}"
            logger.debug"error class #{self}  $@: #{$@} " 
            logger.debug"error class #{self} #{Time.now} $!: #{$!} " 	
			raise
		end
		return command_c
    end   ## sub_insert_sio_c	

	def vproc_command_c_dflt_set_fm_rubycoding command_c  ###　引き数はcommand_cで固定
		command_r = command_c.dup
		tblnamechop = command_c[:sio_viewname].split("_",2)[1].chop
		command_c.each do |key,val|
			if (val == "" or val.nil? or val == "dummy" ) and  key.to_s =~ /^#{tblnamechop}_/
				if respond_to?("proc_view_field_#{key.to_s}_dflt_for_tbl_set")
					command_r[key] = __send__("proc_view_field_#{key.to_s}_dflt_for_tbl_set",command_r)
				else
					fld_tbl = key.to_s.split("_",2)[1]
					if respond_to?("proc_field_#{fld_tbl}_dflt_for_tbl_set")
						command_r[key] = __send__("proc_field_#{fld_tbl}_dflt_for_tbl_set",command_r)
					end
				end
			end
		end
		return command_r
	end
	def proc_userproc_insert command_c
    ##def sub_userproc_insert command_c
        userproc = {}		
        userproc[:id] = proc_get_nextval("userproc#{@sio_user_code.to_s}s_seq")
		userproc[:session_counter] = command_c[:sio_session_counter]
        userproc[:tblname] = "sio_"+ command_c[:sio_viewname]
        userproc[:cnt] = command_c[:sio_recordcount]
        userproc[:cnt_out] = 0
        userproc[:status] = "request"
        userproc[:created_at] = Time.now
        userproc[:updated_at] = Time.now
        userproc[:persons_id_upd] = System_person_id
        userproc[:expiredate] = DateTime.parse("2099/12/31")
        proc_tbl_add_arel("userproc#{@sio_user_code.to_s}s",userproc)
    ##end
	##	sub_userproc_chk_set command_c
	end
    def proc_userproc_chk_set command_c		
		strwhere = "select * from userproc#{@sio_user_code.to_s}s where tblname = 'sio_#{command_c[:sio_viewname]}' and "
		strwhere << " session_counter = #{command_c[:sio_session_counter]} "
        chkuserproc = ActiveRecord::Base.connection.select_one(strwhere)
		if chkuserproc
		    chkuserproc["cnt"] += 1
            ### chkuserproc["where"] = {:id=>chkuserproc["id"]}			
            proc_tbl_edit_arel("userproc#{@sio_user_code.to_s}s",chkuserproc," id = #{chkuserproc["id"]}" )		  
		else
		    proc_userproc_insert command_c 
		end
    end
    def sub_parescreen_insert hash_rcd
        parescreen = {}
        parescreen[:id] = @ss_id.to_i
        parescreen[:rcdkey] = nil ###   rcdkey
        parescreen[:strsql] = hash_rcd[:strsql]
        parescreen[:ctltbl] = hash_rcd[:ctltbl]
        parescreen[:created_at] = Time.now
        parescreen[:updated_at] = Time.now
        parescreen[:persons_id_upd] = System_person_id
        parescreen[:expiredate] = Date.today + 1
        proc_tbl_add_arel("parescreen#{@sio_user_code.to_s}s",parescreen)
    end
    def sub_insert_sio_r command_r   ####レスポンス
        command_r[:sio_id] =  proc_get_nextval("SIO_#{command_r[:sio_viewname]}_SEQ")
        command_r[:sio_command_response] = "R"
        command_r[:sio_add_time] = Time.now
		proc_tbl_add_arel  "SIO_#{command_r[:sio_viewname]}",command_r
    end   ## sub_insert_sio_r 
    def proc_insert_sio_r command_r   ####レスポンス
        sub_insert_sio_r command_r
    end   ## sub_insert_sio_r
    def char_to_number_data command_c   ###excel からのデータ取り込み　根本解決を   
		##rubyXl マッキントッシュ excel windows excel not perfect
		@date1904 = nil
		viewtype = proc_blk_columns("sio_#{command_c[:sio_viewname]}")
		##@show_data[:allfields].each do |i|
		command_c.each do |key,j|
			if viewtype[key] 
				###case @show_data[:alltypes][i]
				case viewtype[key][:data_type].downcase
					when /date|^timestamp/ then
			        begin
						command_c[key] = Time.parse(command_c[key].gsub(/\W/,"")) if command_c[key].class == String
						command_c[key] = num_to_date(command_c[key])  if command_c[key].class == Fixnum  or command_c[key].class == Float 
			        rescue
                       command_c[key] = Time.now
			        end
					when /number/ then
						command_c[key] = command_c[key].gsub(/,|\(|\)|\\/,"").to_f if command_c[key].class == String
					when /char/
						command_c[key] = command_c[key].to_i.to_s if command_c[key].class == Fixnum
				end  #case show_data
			else
				command_c.delete(key)
			end  ## if command_c
		end  ## sho_data.each
		command_c["id"] = command_c[(command_c[:sio_viewname].split("_")[1].chop + "_id")]
		return command_c
    end ## defar_to....

    def num_to_date(num)
      return nil if num.nil?
      if @date1904
        compare_date = DateTime.parse('December 31, 1903')
      else
        compare_date = DateTime.parse('December 31, 1899')
      end
      # subtract one day to compare date for erroneous 1900 leap year compatibility
      compare_date - 1 + num
    end

    def proc_blk_paging  command_c,screen_code
        ### strsqlにコーディングしてないときは、viewをしよう
        ### strdql はupdate insertには使用できない。
        ### command_c[:sio_strsql] = (select  ・・・・) a
        if  command_c[:sio_strsql]     ## 親からの情報があるときは対象外
            tmp_sql =  if command_c[:sio_strsql].class.to_s == "Hash" then command_c[:sio_strsql]["strsql"] else command_c[:sio_strsql] end 
          else
            tmp_str = ActiveRecord::Base.connection.select_one("select * from r_screens where pobject_code_scr = '#{screen_code}' and screen_Expiredate > current_date order by screen_expiredate ")
            if  tmp_str and  command_c[:sio_search]  == "false" and command_c[:sio_sidx] == "" then
                if tmp_str["screen_strselect"]  then tmp_sql = "(#{tmp_str["screen_strselect"]}" else tmp_sql =  command_c[:sio_viewname]  + " a " end 
                tmp_sql << (tmp_str["screen_strselect"]||="")
                tmp_sql << (" Where "+  tmp_str["screen_strwhere"] ) if tmp_str["screen_strwhere"] and  command_c[:sio_search]  == "false"
                tmp_sql << tmp_str["screen_strgrouporder"]||=""
                tmp_sql << " ) a "  if tmp_str["screen_strselect"].size > 0
              else 
                tmp_sql =  command_c[:sio_viewname]  + " a " 
            end
        end
        strsql = "SELECT id FROM " + tmp_sql
        if command_c[:sio_search]  == "true"
			tmp_sql << proc_strwhere(command_c)
			(tmp_sql << (" and "+  tmp_str["screen_strwhere"] ) if tmp_str["screen_strwhere"]) if tmp_str 
		end
        sort_sql = ""
        unless command_c[:sio_sidx].nil? or command_c[:sio_sidx] == "" then 
	        sort_sql = " ROW_NUMBER() over (order by " +  command_c[:sio_sidx] + " " +  command_c[:sio_sord]  + " ) " 
	      else
	        sort_sql = "rownum "
        end
        cnt_strsql = "SELECT count(*) FROM " + tmp_sql 
        command_c[:sio_totalcount] =  ActiveRecord::Base.connection.select_value(cnt_strsql)  
	    all_sub_command_r = []
        case  command_c[:sio_totalcount]
            when nil,0   ## 該当データなし　　回答
	            command_c[:sio_recordcount] = 0
                command_c[:sio_result_f] = "8"  ## no record
                command_c[:sio_message_contents] = proc_blkgetpobj("not find record","err_msg")
                sub_insert_sio_r(command_c)
	            all_sub_command_r[0] =  command_c
            else 
                strsql = "select #{sub_getfield} from (SELECT #{sort_sql} cnt,a.* FROM #{tmp_sql} ) "
                r_cnt = 0
                strsql  <<    " WHERE  cnt <= #{command_c[:sio_end_record]}  and  cnt >= #{command_c[:sio_start_record]} "
                pagedata = ActiveRecord::Base.connection.select_all(strsql)
                pagedata.each do |j|
                    r_cnt += 1
                    ##   command_c.merge j なぜかうまく動かない。
                    j.each do |j_key,j_val|
                        command_c[j_key]   = j_val ## unless j_key.to_s == "id" ## sioのidとｖｉｅｗのｉｄが同一になってしまう
                        ## command_r[:id_tbl] = j_val if j_key.to_s == "id"
                    end  
	                command_c[:sio_recordcount] = r_cnt
                    command_c[:sio_result_f] = "1"
                    command_c[:sio_message_contents] = nil
	                ##tmp = {}
                    sub_insert_sio_r(command_c)     ###回答
	                ###tmp.merge! command_c
	                all_sub_command_r <<  command_c.dup ## tmp   ### all_sub_command_r << command_c にすると以前の全ての配列が最新に変わってしまう
	            end  ##pagedata
        end   ## case
        ###p  "e: " + Time.now.to_s 
        return all_sub_command_r
    end   ##sub_blk_paging

    def  proc_strwhere command_c
	  #日付　/ - 固定にしないようにできないか?
        if command_c[:sio_strsql] then
          strwhere =  if command_c[:sio_strsql].downcase.split(")")[-1] =~ /where/ then   " and " else  " where "  end
          else
           strwhere = " WHERE "
        end
        ##xparams gridの生 
	    ###if (params[:commit]||="") == "Export" then search_key = params[:export].dup else search_key = params.dup end
		###search_key = params.dup
		strwhere = proc_search_key_strwhere params,strwhere,@show_data
	end	
	def proc_search_key_strwhere search_key,strwhere,show_data   ###search key:"xxxx"   not sym   ## search_key 画面と db_cud(データ選択)で使用
        search_key.each  do |i,j|  ##xparams gridの生
            next if j == ""
			tmpwhere = nil
	        case show_data[:alltypes][i.to_sym]
				when nil
					next
	            when /number/
                    tmpwhere = " #{i} = #{j}     AND " 
		            tmpwhere = " #{i}  #{j[0]}  #{j[1..-1]}      AND "   if j =~ /^</   or  j =~ /^>/ 
		            tmpwhere = " #{i} #{j[0..1]} #{j[2..-1]}      AND "    if j =~ /^<=/  or j =~ /^>=/ or j =~ /^!=/ 
	            when /^date|^timestamp/
		            case  j.size  
			            when 4
			                tmpwhere = " to_char( #{i},'yyyy') = '#{j}'       AND "  
			            when 5
			                tmpwhere = " to_char( #{i},'yyyy') #{j[0]} '#{j[1..-1]}'      AND "  if  ( j =~ /^</   or  j =~ /^>/ )
                        when 6 
			                tmpwhere = " to_char( #{i},'yyyy')  #{j[0..1]} '#{j[2..-1]}'      AND "  if   (j =~ /^<=/  or j =~ /^>=/ )
			            when 7
			                tmpwhere = " to_char( #{i},'yyyy/mm') = '#{j}'       AND "  if Date.valid_date?(j.split("/")[0].to_i,j.split("/")[1].to_i,01)
			            when 8
			                tmpwhere = " to_char( #{i},'yyyy/mm') #{j[0]} '#{j[1..-1]}'      AND "  if Date.valid_date?(j[1..-1].split("/")[0].to_i,j.split("/")[1].to_i,01)  and ( j =~ /^</   or  j =~ /^>/ )
                        when 9 
			                tmpwhere = " to_char( #{i},'yyyy/mm')  #{j[0..1]} '#{j[2..-1]}'      AND "  if Date.valid_date?(j[1..-1].split("/")[0].to_i,j.split("/")[1].to_i,01)   and (j =~ /^<=/  or j =~ /^>=/ )
			            when 10
			                tmpwhere = " to_char( #{i},'yyyy/mm/dd') = '#{j}'       AND "  if Date.valid_date?(j.split("/")[0].to_i,j.split("/")[1].to_i,j.split("/")[2].to_i)
			            when 11
			                tmpwhere = " to_char( #{i},'yyyy/mm/dd') #{j[0]} '#{j[1..-1]}'      AND "  if Date.valid_date?(j[1..-1].split("/")[0].to_i,j.split("/")[1].to_i,j.split("/")[2].to_i)  and ( j =~ /^</   or  j =~ /^>/ )
                        when 12 
			                tmpwhere = " to_char( #{i},'yyyy/mm/dd')  #{j[0..1]} '#{j[2..-1]}'      AND "  if Date.valid_date?(j[2..-1].split("/")[0].to_i,j.split("/")[1].to_i,j.split("/")[2].to_i)   and (j =~ /^<=/  or j =~ /^>=/ )
			            when 16
			                if Date.valid_date?(j.split("/")[0].to_i,j.split("/")[1].to_i,j.split("/")[2][0..1].to_i)
								hh = j.split(" ")[1][0..1]
								mi = j.split(" ")[1][3..4]
								delm = j.split(" ")[1][2.2]
								if  Array(0..24).index(hh.to_i) and Array(0..60).index(mi.to_i) and delm ==":"  
									tmpwhere = " to_char( #{i},'yyyy/mm/dd hh24:mi') = '#{j}'       AND "
								end
							end
			            when 17
							if Date.valid_date?(j[1..-1].split("/")[0].to_i,j.split("/")[1].to_i,j.split("/")[2][0..1].to_i)  and ( j =~ /^</   or  j =~ /^>/ or  j =~ /^=/ )
								hh = j.split(" ")[1][0..1]
								mi = j.split(" ")[1][3..4]
								delm = j.split(" ")[1][2.2]
								if  Array(0..24).index(hh.to_i) and Array(0..60).index(mi.to_i) and delm ==":"  								
									tmpwhere = " to_char( #{i},'yyyy/mm/dd hh24:mi') #{j[0]} '#{j[1..-1]}'      AND "
								end
							end
                        when 18 
			                if Date.valid_date?(j[2..-1].split("/")[0].to_i,j.split("/")[1].to_i,j.split("/")[2][0..1].to_i)   and (j =~ /^<=/  or j =~ /^>=/ )
								hh = j.split(" ")[1][0..1]
								mi = j.split(" ")[1][3..4]
								delm = j.split(" ")[1][2.2]
								if  Array(0..24).index(hh.to_i) and Array(0..60).index(mi.to_i) and delm ==":"  								
										tmpwhere = " to_char( #{i},'yyyy/mm/dd hh24:mi')  #{j[0..1]} '#{j[2..-1]}'      AND "
								end
							end
                    end ## j.size  
	            when /char|text/
                    tmpwhere = " #{i} = '#{j}'         AND "
		            tmpwhere = " #{i}  #{j[0]}  '#{j[1..-1]}'         AND "  if j =~ /^</   or  j =~ /^>/ 
		            tmpwhere = " #{i} #{j[0..1]} '#{j[2..-1]}'       AND "    if j =~ /^<=/  or j =~ /^>=/
		            tmpwhere = " #{i} like '#{j}'     AND " if (j =~ /^%/ or j =~ /%$/ ) 
	                #when  "textarea"
                    #       tmpwhere = " #{i.to_s} like '#{j}'     AND " if (j =~ /^%/ or j =~ /%$/ ) 
	            when "select"
                   tmpwhere = " #{i} = '#{j}'         AND "
            end   ##show_data[:alltypes][i]
                tmpwhere = " #{i} #{j}    AND " if  j =~/is\s*null/ or j =~/is\s*not\s*null/ 
	        strwhere << tmpwhere  if  tmpwhere 
        end ### command_c.each  do |i,j|###
        return strwhere[0..-7]
    end   ## proc_strwhere
    def  proc_pdfwhere pdfscript,command_c
	    reports_id = pdfscript[:id]
	    viewname = command_c[:sio_viewname]
        tmpwhere = proc_strwhere command_c
        case  params[:initprnt] 
            when  "1"  then
	            tmpwhere <<  if tmpwhere.size > 1 then " and " else " where " end
	            tmpwhere << "   not exists (select 1 from HisOfRprts x
                                   where lower(tblname) = '#{viewname}' and #{viewname.split('_')[1].chop}_id = recordid
				                and reports_id = #{reports_id}) "
		end		
        case  params[:afterprnt] 
            when  "1"  then  
	            tmpwhere <<  if tmpwhere.size > 1 then " and " else " where " end
	            tmpwhere << " exists (select 1 from  (select max(updated_at) updated_at ,recordid
     							       from HisOfRprts x where reports_id = #{reports_id}
     								   group by reports_id,recordid )
								   where id = recordid and  #{viewname.split("_")[1].chop}_updated_at > updated_at )"
		end										
        if params[:whoupdate] == '1' then
	        tmpwhere <<  if tmpwhere.size > 1 then " and " else " where " end
	        tmpwhere << " person_code_upd = '"
			tmpwhere <<  ActiveRecord::Base.connection.select_value("select code from persons where email = '#{current_user[:email]}'")
			tmpwhere << "'"
        end										
        if pdfscript[:pobject_code_rep] =~ /order_list/ then
	        tmpwhere <<  if tmpwhere.size > 1 then " and " else " where " end
	        tmpwhere << "  #{pdfscript[:pobject_code_view].split('_')[1].chop}_confirm  in('1','5')  "   ##order_listの時は確定又は確認済しか印刷しない
        end
        ##if params[:
        return tmpwhere
    end

    def subpaging  command_c,screen_code
        tbldata = []
        command_c[:sio_viewname]  = @show_data[:screen_code_view] 
        proc_insert_sio_c command_c    ###ページング要求
        rcd = proc_blk_paging command_c,screen_code
		allf = @show_data[:allfields]
		allt = @show_data[:alltypes]
        rcd.each do |j|
            tmp_data = {}
            allf.each do |k|
				if j[k]
					case allt[k]
						when /date/
							tmp_data[k] = j[k].strftime("%Y/%m/%d")
						when /time/
							tmp_data[k] = j[k].strftime("%Y/%m/%d %H:%M")
						else
							tmp_data[k] = j[k] ## if k_to_s != "id"        ## 2dcのidを修正したほうがいいのかな
					end
				end
            end 
	        tbldata << tmp_data
        end ## for
        return [tbldata,rcd[0][:sio_totalcount]]    ###[データの中身,レコード件数]
    end  ##subpagi
    def  sub_getfield 
       @show_data[:allfields].join(",").to_s
    end   ##  sub_getfield

    def sub_set_chil_tbl_info next_screen_data
      strwhere = "select ctlb_id from CTL#{next_screen_data[:sio_org_tblname]} where ptblid = #{next_screen_data[:sio_org_tblid]} and "
      strwhere << "ctblname = '#{next_screen_data[:sio_viewname].split("_")[1]}'  "
      ctbl_id = ActiveRecord::Base.connection.select_value(strwhere)
      if ctbl_id
	  return ctbl_id
       else
	  ##logger.debug " LINE #{__LINE__}  ptblname CTL#{next_screen_data[:sio_org_tblname]} ; strwhere = #{strwhere} "
	  raise "error"
      end
    end
	
	def proc_get_starttime duedate,duration,period,type
		case type
			when nil
				case period
					when "day"
					debugger if duedate.nil?
						duedate - duration * 24 * 60* 60
				end
		end
	end
	def proc_get_duration fm_id,to_id,transportation   ### transportation 輸送手段　船飛行機トラック・・・
		1
	end
    def proc_get_cons_chil(key)  ###工程の始まり=前工程の終わり
		strsql = "select nd.* from r_nditms nd ,opeitms opeitm where nditm_opeitm_id = opeitm.id   and nditm_Expiredate > current_date  order by itm_code
																and opeitm.itms_id = #{key["itms_id"]} and opeitm.locas_id = #{key["locas_id"]}  and opeitm.processseq = #{key["processseq"]}  "  
		rnditms = ActiveRecord::Base.connection.select_all(strsql)
		return rnditms
    end
	def proc_get_trngantt_cons_chil_inout_fm_alloc_id alloc_id
		alloc = ActiveRecord::Base.connection.select_one("select * from alloctbls where id = #{alloc_id}")
		if alloc["srctblname"] == "trngantts" 
			strsql = "select alloc.qty alloc_qty,alloc.id alloc_id,alloc.destblname alloc_destblname,alloc.destblid alloc_destblid,
						gantt.trngantt_qty trngantt_qty,gantt.trngantt_id trngantt_id,
						gantt.trngantt_itm_id trngantt_itm_id,gantt.trngantt_processseq trngantt_processseq,gantt.trngantt_consumtype consumtype, 
						pare.trngantt_starttime pare_starttime,pare.trngantt_loca_id pare_loca_id,pare.trngantt_itm_id pare_itm_id,
						pare.trngantt_processseq pare_processseq
						from r_trngantts gantt,alloctbls alloc ,r_trngantts pare
						where pare.trngantt_id = #{alloc["srctblid"]}
						and pare.trngantt_orgtblname = gantt.trngantt_orgtblname and pare.trngantt_orgtblid = gantt.trngantt_orgtblid
						and pare.trngantt_key = case length(gantt.trngantt_key) 
						                             when 3 then
														to_char(gantt.trngantt_key - 1,'000')
													 else
													     substr(gantt.trngantt_key,1,length(gantt.trngantt_key) -3 )
													 end
						and alloc.srctblname = 'trngantts' and alloc.srctblid = gantt.trngantt_id and alloc.qty > 0"
			children = ActiveRecord::Base.connection.select_all(strsql)
			children.each do |chil|
				#inoutflg = case chil["consumtype"]
				#			when "ACT","ORD","con"  ###消費
				#				 "con"
				#			when "BYP" ###副産物
				#				 "mkd"
				#			when "DEV" ###装置
				#				 "emp"
				#			when "MAT" ###金型
				#				"out"
				#			else
				#				logger.debug %Q& forgotten   chil["consumtype"]= '#{chil["consumtype"]}'  &
				#				raise
				#			end
				proc_command_instance_variable(ActiveRecord::Base.connection.select_one(" select * from r_#{chil["alloc_destblname"]} where id = #{chil["alloc_destblid"]}"))
				case chil["consumtype"]
					when "con","mkd"
						inout = {}
						##inout = ActiveRecord::Base.connection.select_one("select * from inouts where alloctbls_id_inout = #{chil["alloc_id"]} and inoutflg = '#{chil["consumtype"]}' ")
						inout[:id] = proc_decision_id_by_key("inouts"," alloctbls_id_inout = #{chil["alloc_id"]} and inoutflg = '#{chil["consumtype"]}' ")["id"]
						if @inout_classname =~ /_edit_/ 
							inout[:inout_qty_alloc] = if chil["consumtype"] == "mkd" then chil["alloc_qty"] else chil["alloc_qty"] * -1 end
						else
							#bal_qty = chil["trngantt_qty"] - chil["alloc_qty"]
							#strsql = "select * from inouts where trngantts_id_inout = #{chil["trngantt_id"]} and locas_id = #{chil["pare_loca_id"]} and inoutflg = '#{inoutflg}' "
							#prevs = ActiveRecord::Base.connection.select_all(strsql)
							#prevs.each do |prev|
							#	if prev["qty_alloc"] >  bal_qty 
							#		prev["qty_alloc"] = bal_qty
							#		bal_qty -= prev["qty_alloc"]
							#		proc_tbl_edit_arel("inouts",{:qty_alloc =>prev["qty_alloc"]}," id = #{prev["id"]} ")
							#	else
							#		bal_qty -= prev["qty_alloc"]
							#	end
							#end
							###proc_tbl_delete_arel("inouts",%Q& trngantts_id_inout = #{chil["trngantt_id"]} and locas_id = #{chil["pare_loca_id"]}   and inoutflg = '#{inoutflg}' 
							inout[:inout_qty_alloc] = if chil["consumtype"] == "mkd" then  chil["alloc_qty"] else chil["alloc_qty"] * -1 end
						end
						inout[:inout_alloctbl_id_inout] = chil["alloc_id"]
						inout[:inout_trngantt_id_inout] = chil["trngantt_id"]
						inout[:inout_itm_id_pare] = chil["pare_itm_id"]
						inout[:inout_loca_id] = eval("@#{alloc["destblname"].chop}_loca_id_to")  
						inout[:inout_starttime] = eval("@#{alloc["destblname"].chop}_duedate")  
						inout[:inout_inoutflg] = chil["consumtype"]
						if chil["trngantt_itm_id"] == chil["pare_itm_id"]
							inout[:inout_processseq] = chil["pare_processseq"]
						else
							inout[:inout_processseq] = chil["trngantt_processseq"]
						end
						__send__("proc_fld_alloctbls_#{chil["alloc_destblname"]}_inouts_self10") do
							inout
						end
					when "emp"  ###装置が空いた
					when "out"  ### 完了したとき返却
				end
			end
		else
			logger.debug "logic err alloc = '#{alloc} "
			raise
		end
	end
	
	def proc_get_trngantt_cons_chil_stk(tblname,tblid)
		strsql = %Q& select alloc.qty alloc_qty,alloc.destblname alloc_destblname,alloc.destblid alloc_destblid,gantt.trngantt_consumtype consumtype
						from r_trngantts gantt,alloctbls alloc ,r_trngantts pare,alloctbls pare_alloc
						where pare_alloc.srctblname = 'trngantts' and pare.trngantt_id = pare_alloc.srctblid
						and pare_alloc.destblname = '#{tblname}' and pare_alloc.destblid = #{tblid}
						and pare.trngantt_orgtblname = gantt.trngantt_orgtblname and pare.trngantt_orgtblid = gantt.trngantt_orgtblid
						and pare.trngantt_key = substr(gantt.trngantt_key,1,length(gantt.trngantt_key) -3 ) 
						and alloc.srctblname = 'trngantts' and alloc.srctblid = gantt.trngantt_id and alloc.qty > 0
						and  gantt.trngantt_consumtype  in('ACT','ORD','BYP','con') 
						and gantt.trngantt_consumauto != 'M' &
		children = ActiveRecord::Base.connection.select_all(strsql)
		children.each do |chil|
			rec = ActiveRecord::Base.connection.select_one(" select * from r_#{chil["alloc_destblname"]} where id = #{chil["alloc_destblid"]} ") 
			if chil["alloc_destblname"] == "lotstkhists"
				if chil["consumtype"] == "BYP"   ###副産物
					rec[chil["alloc_destblname"].chop + "_qty"] += chil["alloc_qty"] 
				else
					rec[chil["alloc_destblname"].chop + "_qty"] -= chil["alloc_qty"] 
				end
				proc_tbl_edit_arel("lotstkhists",{:qty=>rec[chil["alloc_destblname"].chop + "_qty"]},%Q& id = #{rec["id"]} &)
			else
				strsql = "select * from opeitms where itms_id = #{rec["itm_id"]} and locas_id = #{rec["loca_id"]} and processseq = #{rec["opeitm_processseq"]} "
				opeitm = ActiveRecord::Base.connection.select_one(strsql)
				lotstk = proc_get_rec_fm_tblname_yield("lotstkhists") do 
								%Q& itms_id = #{opeitm["itms_id"]} and processseq = #{opeitm["processseq"]} and locas_id = #{rec["loca_id_to"]||=rec["loca_id"]} 
									and lotno =  '#{rec[chil["alloc_destblname"].chop + "_lotno"]||="dummy"}'   
									#{if rec[chil["alloc_destblname"].chop + "_packno"] then "and packno = '#{rec[chil["alloc_destblname"].chop + "_packno"]}'" else "" end }  
									and prjnos_id = #{rec["prjno_id"]} &
						 end
				if lotstk
					lotstk["qty"] += if chil["consumtype"] == "BYP"  then  chil["alloc_qty"] else chil["alloc_qty"] *-1 	end
					proc_tbl_add_arel("lotstkhists",lotstk," id = #{lotstk["id"]} " )
				else	
					lotstk = {}   ###xxxschsからxxxinstsのどれなのかわからない。
					lotstk["id"] = proc_get_nextval "lotstkhists_seq"
					lotstk["itms_id"] = opeitm["itms_id"]
					lotstk["processseq"] = opeitm["processseq"]
					lotstk["locas_id"] = (rec["loca_id_to"]||= rec["loca_id"])
					lotstk["lotno"] =  (rec[(chil["alloc_destblname"].chop + "_lotno")]||= "dummy")
					lotstk["packno"] = rec[chil["alloc_destblname"].chop + "_packno"]
					lotstk["starttime"] = Time.now
					lotstk["expiredate"] = "2099/12/31".to_date
					lotstk["prjnos_id"] = rec["prjno_id"]
					lotstk["qty"] = if chil["consumtype"] == "BYP"  then  chil["alloc_qty"] else chil["alloc_qty"] *-1 	end
					lotstk["persons_id_upd"] = 0
					proc_tbl_add_arel("lotstkhists",lotstk)
				end
			end
		end
	end
	def proc_auto_add_pobject_code(pobject_code,objecttype)
        strsql = "select code from pobjects where code = '#{pobject_code}' and objecttype = '#{objecttype}'  and expiredate > current_date" 
        if   ActiveRecord::Base.connection.select_one(strsql).nil?
	        command_c = {}.with_indifferent_access
            command_c[:pobject_code] = pobject_code
            command_c[:pobject_expiredate] = "2099/12/31".to_date
            command_c[:pobject_objecttype] = objecttype
            command_c[:sio_viewname] = "r_pobjects"
            command_c[:sio_session_counter] =   user_seq_nextval   ##
            command_c[:sio_classname] = "_auto_add_by_screencodes"
            command_c[:id] = command_c[:pobject_id] = proc_get_nextval("pobjects_seq") 
            command_c[:sio_user_code] = ActiveRecord::Base.connection.select_one("select * from persons where email = '#{current_user[:email]}'")["id"]
            proc_simple_sio_insert command_c
			id = command_c[:id] 
		else
			id = nil
        end
	end
	def proc_get_pare_opeitms_by_nditms(itms_id,locas_id) ##未作成
		strsql = "select * from r_nditms where nditm_opeitm_id = #{opeitms_id} #{strwhere}  and nditm_Expiredate > current_date "
		rnditms = ActiveRecord::Base.connection.select_all(strsql)		
	end
	
	def proc_get_pare_opeitms_by_trngantts(itms_id,locas_id) ## 未作成

	end
	def proc_sch_chil_get orgtblname,orgtblid	## 
		strsql = "select alloctbl.id alloctbl_id from trngantts trn ,alloctbls alloctbl where trn.orgtblname = '#{orgtblname}' and trn.orgtblid = #{orgtblid}
						and alloctbl.srctblname = 'trngantts' and alloctbl.srctblid = trn.id 
						and (destblname like 'pur%' or destblname like 'prd%') order by trn.key "
		alloc_ids = ActiveRecord::Base.connection.select_values(strsql)
		alloc_ids.each do |alloc_id|
			proc_get_trngantt_cons_chil_inout_fm_alloc_id(alloc_id)
		end
	end

    def vproc_get_chil_itms(n0,endtime)  ###工程の始まり=前工程の終わり
		rnditms = ActiveRecord::Base.connection.select_all("select * from nditms where opeitms_id = #{n0[:opeitms_id]} and Expiredate > current_date  ")
		if rnditms.size > 0 then
			ngantts = []  ###viewの内容なので　itm_id  loca_id
			mlevel = n0[:mlevel] + 1
			rnditms.each.with_index(1)  do |i,cnt|
				chil_ope = vproc_get_ope_id_priority(i,n0)
				##if chil_ope and i["consumtype"]
				if chil_ope
					##i["processseq_nditm"] += 1 if chil_ope[:locas_id] != i["locas_id_nditm"]
					if i["locas_id_nditm"] != n0[:loca_id]
						i["consumtype"] = "con"  if  i["consumtype"] =~ /con|ORD|ACT/
						ngantts << {:seq=>n0[:seq] + sprintf("%03d", cnt),:mlevel=>mlevel,:itm_id=>i["itms_id_nditm"],
								:prdpurshp=>"shp",:processseq=>i["processseq_nditm"],
								:loca_id=> i["locas_id_nditm"]  ,
								:loca_id_to=>n0[:loca_id],:opeitms_id =>chil_ope["id"],
								:priority=>chil_ope["priority"],
								:endtime=>endtime,:duration=>(n0[:duration]||=1),
								:nditm_consumtype=>i["consumtype"],:nditm_consumauto=>i["consumauto"],
								:parenum=>i["parenum"],:chilnum=>i["chilnum"],:id=>"nditms_"+i["id"].to_s}  ###
					else
						next
					end
				else
					raise  ###自動で出庫指示を作る考え方もある。
				end
						
			   ##else
				##	if i["consumtype"].nil? 
				##		ngantts << {:seq=>n0[:seq] + sprintf("%03d", cnt),:mlevel=>mlevel,:itm_id=>i["itms_id_nditm"],
				##				:prdpurshp=>"shp",:processseq=>999,
				##				:loca_id=>proc_get_opeitms_id_fm_itm_loca( i["itms_id_nditm"],nil,999,999)["locas_id"] ,
				##				:loca_id_to=>n0[:loca_id],:opeitms_id =>chil_ope["id"],
				##				:priority=>chil_ope["priority"],
				##				:endtime=>endtime,:duration=>(n0[:duration]||=1),
				##				:nditm_consumtype=>i["consumtype"],:nditm_consumauto=>i["consumauto"],
				##				:parenum=>i["parenum"],:chilnum=>i["chilnum"],:id=>"nditms_"+i["id"].to_s}
				##	else
				##		logger.debug "logic error opeitms missing  line :#{__LINE_} i:#{i}  n0:#{n0}"
				##		raise
				##	end
			   ##end
			end 
		else
			ngantts  = [{}]	   
		end
		return ngantts
    end

    def vproc_get_pare_itms(n0,endtime)  ###
		strsql = "select * from nditms where itms_id_nditm = #{n0[:itm_id]} and locas_id_nditm = #{n0[:loca_id]} and processseq_nditm = #{n0[:processseq]} and Expiredate > current_date  "
		nditms = ActiveRecord::Base.connection.select_all(strsql)
		if nditms.size > 0 then
			ngantts = []  ###viewの内容なので　itm_id  loca_id
			mlevel = n0[:mlevel] + 1
			nditms.each.with_index(1)  do |i,cnt|
				ope = ActiveRecord::Base.connection.select_one("select * from opeitms where id = #{i["opeitms_id"]} ")
				if ope
				    np= {:duration => i["duration"],:parenum => i["chilnum"],:chilnum => i["parenum"],:prdpurshp => ope["prdpurshp"],:nditm_consumtype => i["nditm_consumtype"],
							:nditm_consumauto => i["nditm_consumauto"],:opeitms_id => i["opeitms_id"],
							:itm_id => ope["itms_id"],:loca_id => ope["locas_id"],:processseq=>ope["processseq"],:priority=>ope["priority"],
							:seq=>n0[:seq] + sprintf("%03d", cnt),:mlevel=>mlevel,:itm_id=>ope["itms_id"],:level=>1,
							:starttime=>endtime,:duration=>(i["duration"]||=1),:endtime=> proc_get_starttime(n0[:endtime] ,(i["duration"]||=1)*-1,"day",nil),
							:id=>"nditms_"+i["id"].to_s}  ###
					ngantts << np
			   else
					logger.debug "logic error opeitms missing  line :#{__LINE_} select * from opeitms where id = #{i["opeitms_id"]} "
					raise
			   end
			end 
		else
			ngantts  = [{}]	   
		end
		return ngantts
    end
	def vproc_get_ope_id_priority(i,n0)
		strsql = "select id,priority,locas_id from opeitms where itms_id = #{i["itms_id_nditm"]} and locas_id = #{i["locas_id_nditm"]} and processseq = #{i["processseq_nditm"]} and priority = #{n0[:priority]} " 
		ActiveRecord::Base.connection.select_one(strsql)
	end
    def vproc_get_prev_process(n0,starttime)  ###工程の始まり=前程の終わり
      rec = ActiveRecord::Base.connection.select_one("select * from opeitms where itms_id = #{n0[:itm_id]} and Expiredate > current_date 
																			and Priority = #{n0[:priority]} and processseq < #{n0[:processseq]}  order by   processseq desc")
      if rec
	       ngantts = []
				ngantts << {:seq=>(n0[:seq] + "000"),:mlevel=>n0[:mlevel]+1,:itm_id=>rec["itms_id"],:loca_id=>rec["locas_id"],:opeitms_id=>rec["id"],
							:loca_id_to=>n0[:loca_id],
							:endtime=>starttime,:prdpurshp=>rec["prdpurshp"],:duration=>(rec["duration"]||=1),
							:parenum=>rec["parenum"],:chilnum=>rec["chilnum"],
							:autocreate_ord=>rec["autocreate_ord"],:autocreate_inst=>rec["autocreate_inst"],
							:autoord_p=>rec["autoord_p"],:autoinst_p=>rec["autoinst_p"],
							:nditm_consumtype=>rec["consumtype"],,:nditm_consumauto=>n0[:consumauto],
							:safestkqty=>rec["safestkqty"],:id=>"opeitms_"+rec["id"].to_s,:priority=>rec["priority"],:processseq=>rec["processseq"],
							:starttime => proc_get_starttime(starttime ,(rec["duration"]||=1),"day",nil)}  ###基準日　期間　タイプ　休日考慮
		else
          ngantts = [{}]		
      end
      return ngantts
    end
    def vproc_get_after_process(n0,endtime)  ###工程の始まり=前程の終わり
      rec = ActiveRecord::Base.connection.select_one("select * from opeitms where itms_id = #{n0[:itm_id]} and Expiredate > current_date 
																			and Priority = #{n0[:priority]} and processseq > #{n0[:processseq]}  order by   processseq ")
      if rec
	       ngantts = []
           ngantts << {:seq=>(n0[:seq] + "000"),:mlevel=>n0[:mlevel]+1,:itm_id=>rec["itms_id"],:loca_id=>rec["locas_id"],:opeitms_id=>rec["id"],
		   :loca_id_to=>n0[:loca_id],:prdpurshp=>rec["prdpurshp"],:endtime=>proc_get_starttime(endtime,(rec["duration"]||=1)*-1,"day",nil),
		   :duration=>(rec["duration"]||=1),:parenum=>rec["parenum"],:chilnum=>rec["chilnum"],
		   :autocreate_ord=>rec["autocreate_ord"],:autocreate_inst=>rec["autocreate_inst"],:autoord_p=>rec["autoord_p"],:autoinst_p=>rec["autoinst_p"],
		   :safestkqty=>rec["safestkqty"],:id=>"opeitms_"+rec["id"].to_s,:priority=>rec["priority"],:processseq=>rec["processseq"],
            :starttime => endtime } ##基準日　期間　タイプ　休日考慮
		else
          ngantts = [{}]		
      end
      return ngantts
    end	
    ##def sub_get_itm_locas_procssseq_frm_opeitm opeitms_id  ###
    ##   rec = ActiveRecord::Base.connection.select_one("select * from opeitms\ where id  = #{opeitms_id} and Expiredate > current_date ")
    ##    if rec
	##        rec
	##	 else
    ##        p "logic err 	sub_get_itm_locas_procssseq_frm_opeitm opeitms_id:#{opeitms_id} "
    ##       raise		  
    ##    end
    ##end
	
    #def proc_get_next_opeitm_processseq_and_loca_id p_opeitm  ###
	#    if p_opeitm[:itms_id].nil? or p_opeitm[:priority].nil? or p_opeitm[:processseq].nil? or p_opeitm[:prdpursch].nil? 
	#        tmp = ActiveRecord::Base.connection.select_one("select * from opeitms where id = #{p_opeitm[:opeitms_id]} ")
	#	    p_opeitm[:itms_id] = tmp["itms_id"]
	#	    p_opeitm[:locas_id] = tmp["locas_id"]
	#	    p_opeitm[:priority] = tmp["priority"]
	#	    p_opeitm[:processseq] = tmp["processseq"]
	#	    p_opeitm[:prdpursch] = tmp["prdpursch"]
	 #   end
	#    case p_opeitm[:processseq] 
	#		when 0..998
	#			strwhere = "select * from opeitms where itms_id = #{p_opeitm[:itms_id]} and Expiredate > current_date and Priority = #{p_opeitm[:priority]} and processseq > #{p_opeitm[:processseq]}  order by   processseq "
	#			rec = ActiveRecord::Base.connection.select_one(strwhere)
	#	    when 999
	#			p_opeitm[:prdpursch] = "shp"   ###移動
	#			rec = p_opeitm.dup
	#		else
	#			p_opeitm[:prdpursch] = "con"   ###消費
	#			rec = p_opeitm.dup
    #   end		
    #    if rec
	#        {:processseq=>rec["processseq"],:locas_id=>rec["locas_id"],:itms_id=>rec["itms_id"],:prev_prdpurshp=>p_opeitm[:prdpursch],:nxt_opeitms_id=>rec["id"]}
	#	 else
    #        p "logic err 	sub_get_next_opeitm_processseq_and_loca_id   p_opeitm:#{p_opeitm} "	  
    #        raise		  
    #    end
    #end	
    ##def sub_get_opeitms_id_fm_itm_processseq_priority p_opeitm  ###
    ##    rec = ActiveRecord::Base.connection.select_one("select * from opeitms where itms_id = #{p_opeitm[:itms_id]} and Expiredate > current_date 
	##																and Priority = #{p_opeitm[:priority]||=999} and processseq = #{p_opeitm[:processseq]||=999}  ")
    ##    if rec
	##        rec
	##	  else
    ##        p "logic err 	sub_get_opeitms_id_fm_itm_processseq_priority   p_opeitm:#{p_opeitm} "	  
    ##        raise		  
    ##    end
    ##end

    def sub_cal_date(locas_id,ops_loca_id,dueday) 
        dueday
    end
    
    def  sub_get_bilcode(locas_id_custs)
         locas_id_custs
    end
        
    def  sub_get_pay_incomming_day(locas_id,dueday)
         dueday
    end
    def sub_get_to_locaid(custord_loca_id,itms_id)
        custord_loca_id
    end  	
    def sub_get_sects_id_fm_locas_id  locas_id
	    sect_id = ActiveRecord::Base.connection.select_value("select id from sects where locas_id_sect = #{locas_id||=0} ")
		if sect_id.nil?
	       sect_id = ActiveRecord::Base.connection.select_value("select id from r_sects where loca_code_sect =  'dummy'")
		   sect_id ||= 0
	    end 
	    return sect_id
	end
	  	
    def sub_get_locas_id_fm_sects_id  sects_id
	    locas_id = ActiveRecord::Base.connection.select_value("select locas_id_sect from sects where id = #{sects_id} ")
		if locas_id.nil?
	       p "err logic err?"
		   raise 
	    end 
	    return locas_id
	end
    def proc_get_dealers_id_fm_locas_id  locas_id
	    locas_id ||= 0
	    dealers_id = ActiveRecord::Base.connection.select_value("select id from dealers where locas_id_dealer = #{locas_id} ")
		if dealers_id.nil?
	       logger.debug "err logic err?  locas_id:#{locas_id}"
		   raise
	    end 
	    return dealers_id
	end
    def sub_get_locas_id_fm_dealers_id  dealers_id
	    locas_id = ActiveRecord::Base.connection.select_value("select locas_id_dealer from dealers where id = #{dealers_id} ")
		if locas_id.nil?
	       p "err logic err?  dealers_id:#{dealers_id}"
		   raise
	    end 
	    return locas_id
	end   
		
    def proc_get_opeitms_id_fm_itm_loca itms_id,locas_id,processseq = nil,priority = nil  ###
		strsql = %Q& select * from opeitms where itms_id = #{itms_id} #{if locas_id then " and locas_id = " + locas_id.to_s else "" end} 
		           and processseq = #{processseq ||= 999} 
				   #{if priority then " and priority = " + priority.to_s else "" end} 
				   and expiredate > current_date &
		rec = ActiveRecord::Base.connection.select_one(strsql)
        if rec
	        rec
		  else
            logger.debug "error class logic err proc_get_opeitms_id_fm_itm_loca itms_id = #{itms_id} ,locas_id = #{locas_id}, processseq = #{processseq ||= 999} , 
					priority = = #{priority ||= 999} ,expiredate > #{Date.today}"	  
            raise		  
        end
    end
    def proc_get_chrgperson_fm_loca locas_id,prdpurshp
        case prdpurshp
			when "pur"
	           strsql = "select * from dealers where locas_id_dealer = #{locas_id} and expiredate > current_date"
			else	
			   strsql = "select * from asstwhs where locas_id_asstwh = #{locas_id} and expiredate > current_date"   
	    end	
        chrgperson = ActiveRecord::Base.connection.select_one(strsql)
	    if chrgperson
			chrgperson_id = chrgperson["chrgpersons_id_dflt"]
		else
			chrgperson = ActiveRecord::Base.connection.select_one("select * from r_chrgs where person_code =  'dummy'")
			if chrgperson
				chrgperson_id = chrgperson["id"]
			else 
				logger.debug " proc_get_chrgperson_fm_loca  chrgpersons dummy code missing "
				raise
			end
	    end 
	    return chrgperson_id
    end
    def proc_get_tree_pare_itms_locas ngantts,gantt_reverse ### bgantt 表示内容　ngantt treeスタック  itms_idは必須
        n0 = ngantts.shift
	    if n0.size > 0  ###子部品がいなかったとき{}になる。
			case gantt_reverse
				when /gantt/
					starttime,endtime = proc_get_item_loca_contents(n0,gantt_reverse)
					tmp = vproc_get_chil_itms(n0,starttime)
					ngantts.concat(tmp) if tmp[0].size > 0 
					tmp = vproc_get_prev_process(n0,starttime)
				when /reverse/
					starttime,endtime = proc_get_item_loca_contents(n0,gantt_reverse)
					tmp = vproc_get_pare_itms(n0,endtime)
					ngantts.concat(tmp) if tmp[0].size > 0 
					tmp = vproc_get_after_process(n0,endtime)
			end
			ngantts.concat(tmp) if tmp[0].size > 0
	    end	
        return ngantts
    end  ##    
    #def proc_get_tree_under_opeitm opeitms_id
	#	ngantts = []
	#	n0 = {}
	#	r0 =  ActiveRecord::Base.connection.select_one("select * from  opeitms where id = #{opeitms_id} ")
	#	n0[:itm_id] = r0["itms_id"]
	#	n0[:processseq] = r0["processseq"]
	#	n0[:priority] = r0["priority"]
	#	n0[:seq] = "000"
	#	n0[:endtime]  = Time.now
	#	n0[:mlevel] = 0
	#	ngantts << n0			
	#	if r0 then
    #        strtime = (n0,r0)
    #        tmp = vproc_get_chil_itms(n0,r0,strtime)
    #        ngantts.concat(tmp) if tmp[0].size > 0 
    #        tmp = proc_get_prev_process(n0,r0,strtime)
    #        ngantts.concat(tmp) if tmp[0].size > 0 
    #     end
    #    return ngantts
    #end

    def proc_get_item_loca_contents(n0,gantt_reverse)   ##n0[:itm_id] r0[:itms_id]
        ##logger.debug "n0:#{n0}"
	    ##logger.debug "r0:#{r0}"
        itm = ActiveRecord::Base.connection.select_one("select * from  itms where id = #{n0[:itm_id]} ")
	    if n0[:loca_id]
            loca = ActiveRecord::Base.connection.select_one("select * from locas where id = #{n0[:loca_id]} ")
	       else
	        rec = ActiveRecord::Base.connection.select_one("select * from opeitms where itms_id = #{n0[:itm_id]} and Expiredate > current_date and Priority = #{n0[:priority]}   order by   processseq desc")
	        loca = ActiveRecord::Base.connection.select_one("select * from locas  where id = #{rec["locas_id"]} ")
        end
	    qty = if n0[:seq].size > 4 then (@bgantts[n0[:seq][0..-4]][:qty] ||= 1) else  (@bgantts["000"][:qty] ||= 1) end
	    new_qty = qty.to_f / (n0[:parenum]||=1) * (n0[:chilnum]||=1)
		###:autocreate_ord,:autocreate_instは画面にはセットしない。
        bgantt = {:mlevel=>n0[:mlevel],:itm_code=>itm["code"],:itm_name=>itm["name"],:loca_code=>loca["code"],:loca_name=>loca["name"],
								:duration=>(n0[:duration]||=1),:assigs=>"",:depends=>"",
								 :parenum=>n0[:parenum]||=1,:chilnum=>n0[:chilnum]||=1,:prdpurshp=>n0[:prdpurshp],
								 :nditm_consumtype=>n0[:nditm_consumtype],:nditm_consumauto=>n0[:nditm_consumauto],
                                 :id=>n0[:id],:itm_id=>n0[:itm_id],:loca_id=>n0[:loca_id],
								 :processseq=>n0[:processseq],:priority=>n0[:priority],:qty=>new_qty,:qty_src=>new_qty}		
		bgantt[:opeitms_id] = n0[:opeitms_id] if gantt_reverse =~ /mst$/ 						 
		 case gantt_reverse
			when /gantt/
				cgantt = {:endtime=>n0[:endtime],:endtime_est=>n0[:endtime],
									:starttime=>proc_get_starttime(n0[:endtime],(n0[:duration]||=1),"day",nil),
									:starttime_est=>proc_get_starttime(n0[:endtime],(n0[:duration]||=1),"day",nil)}
			when /reverse/
				cgantt = {:starttime=>n0[:starttime],:starttime_est=>n0[:starttime],
									:endtime=>proc_get_starttime(n0[:starttime],(n0[:duration]||=1)*-1,"day",nil),
									:endtime_est=>proc_get_starttime(n0[:starttime],(n0[:duration]||=1)*-1,"day",nil)}
		 end
        bgantt.merge! cgantt
		@bgantts[n0[:seq]] = bgantt
	    @min_time = cgantt[:starttime] if (@min_time||="2099/12/31".to_time) > cgantt[:starttime]
		@max_time = cgantt[:endtime] if (@max_time||=Time.now)  < cgantt[:endtime]
        return cgantt[:starttime],cgantt[:endtime]
    end
    def prv_resch_trn   ##本日を起点に再計算
        dp_id = 0
        @bgantts.sort.each  do|key,value|    ###set depends
            if key.to_s.size > 3 then
                @bgantts[key[0..-4]][:depends] << dp_id.to_s + "," 
				@bgantts[key[0..-4]][:duration] = 0  if @bgantts[key[0..-4]][:itm_id] != @bgantts[key][:itm_id]
            end
            dp_id += 1
        end

        today = Time.now
        @bgantts.sort.reverse.each  do|key,value|  ###計算
		    if key.size > 3
                if  value[:depends] == ""
		    	    if @bgantts[key][:starttime_est]  <  today
                       @bgantts[key][:starttime_est]  =  today		   
                       @bgantts[key][:endtimeest]  =   proc_get_starttime(@bgantts[key][:starttime_est], (value[:duration]||=1)*-1,"day",nil)    ###稼働日考慮今なし
                    end					  
			    end
                if  (@bgantts[key[0..-4]][:starttime_est] ) < @bgantts[key][:endtime_est]
                    @bgantts[key[0..-4]][:starttime_est]  =   @bgantts[key][:endtime_est]   ###稼働日考慮今なし
                    @bgantts[key[0..-4]][:endtime_est] =  proc_get_starttime(@bgantts[key[0..-4]][:starttime_est],@bgantts[key[0..-4]][:duration]*-1,"day",nil)
				    ##p key
				    ##p @bgantts[key]
			    end
            end
        end		
        @bgantts.sort.each  do|key,value|  ###topから再計算
		    if key.size > 3
                if  (@bgantts[key[0..-4]][:starttime_est]  ) > @bgantts[key][:endtime_est]  			   
                      @bgantts[key][:endtime_est]  =   @bgantts[key[0..-4]][:starttime_est]    ###稼働日考慮今なし
                      @bgantts[key][:starttime_est] =  proc_get_starttime(@bgantts[key][:endtime_est],(value[:duration]||=1) ,"day",nil)
                end					  
            end
        end
        return 
    end    
    def proc_tblinks command_c
		if command_c[:sio_code] !~ /blktbs/ and command_c[:sio_code] !~ /tblink/ 
			strsql = " select * from r_tblinks where pobject_code_scr_src = '#{command_c[:sio_code]}' and tblink_expiredate > current_date "
			strsql << " and tblink_beforeafter = '#{yield}' order by tblink_seqno "
			do_all = ActiveRecord::Base.connection.select_all(strsql)
			if do_all.size > 0
				do_all.each do |dorec|
					if respond_to?(dorec["tblink_codel"])
						__send__(dorec["tblink_codel"],eval(dorec["tblink_hikisu"])) 
					else
						logger.debug "line #{__LINE__} method missing #{dorec["tblink_codel"]}"
						raise
					end
				end
			end
		end
	end 
	def proc_set_src_tbl rec  ##rec["xxxxx"]
        @src_tbl = {}   ###テーブル更新
		tblnamechop = rec[:sio_viewname].split("_",2)[1].chop
        rec.each do |j,k|
            j_to_stbl,j_to_sfld = j.to_s.split("_",2)		    
            if   j_to_stbl == tblnamechop   ##本体の更新
			    if  k 
	                @src_tbl[j_to_sfld.sub("_id","s_id").to_sym] = k 
                    @src_tbl[j_to_sfld.to_sym] = nil  if k  == "\#{nil}"  ##
				end	
            end   ## if j_to_s.
        end ## rec.each		
        @src_tbl[:persons_id_upd] =  @sio_user_code
        @src_tbl[:updated_at] = Time.now
        @src_tbl[:created_at] = Time.now  if rec[:sio_classname] =~ /_add_/
	end
    ##def proc_rec_instance_variable rec
	##	proc_command_instance_variable rec
	##end
    def proc_command_before_instance_variable rec
	    if @pare_class == "batch"  ###delayjobからだと必要データが来ない。
			tmp = {}
    	    tblnamechop = rec[:sio_viewname].split("_")[1].chop
            rec.each do |key,val| 
	            if  key.to_s =~ /_id/ and val
					screenchop,tbl,filler = key.to_s.split("_",3)
					if filler
						delm = "_" + key.to_s.split("_id",2)[1]
					else
						delm = ""
					end
					if tblnamechop == screenchop  and tbl != "id" ###  and proc_chk_tble_exist(tbl+ "s")
						trec = ActiveRecord::Base.connection.select_one("select * from #{"r_" + tbl + "s"} where id = #{val}")
						if trec.nil?  ###logic error
							logger.debug " logic error rec = #{rec} "
							logger.debug " key = '#{key}' val = #{val} "
							raise
						end
						trec.each do |reckey,recval|
							tmp[reckey+delm] = recval if recval and reckey != "id"
						end
					end
				end
	        end
			show_data = get_show_data(rec[:sio_code]||=rec["sio_code"])
			show_data[:allfields].each  do |fld|  ###必要項目のみセット
				rec[fld.to_s] = tmp[fld]  if tmp[fld]
			end
	    end
		proc_command_instance_variable rec
    end
    def proc_command_after_instance_variable rec
	    if @pare_class == "batch"  ###delayjobからだと必要データが来ない。
			tmp = {}
    	    tblnamechop = rec[:sio_viewname].split("_")[1].chop
            rec.each do |key,val|
	            if  key.to_s.split("_")[0] == tblnamechop and key.to_s.split("_")[2] == "id" and val
				    trec = ActiveRecord::Base.connection.select_one("select * from #{"r_" + key.to_s.split('_')[1]+'s'} where id = #{val}")
					if trec.nil?  ###logic error
						logger.debug "rec = '#{rec}' "
						logger.debug " key = '#{key}' val = '#{val}' "
					end
				    trec.each do |reckey,recval|
				        tmp[reckey] = recval if recval and reckey != "id"
				    end
				end
	        end
			show_data = get_show_data(rec[:sio_code])
			show_data[:allfields].each  do |fld|  ###必要項目のみセット
				rec[fld.to_s] = tmp[fld]  if tmp[fld]
			end
	    end
		proc_command_instance_variable rec
    end
	def proc_command_instance_variable rec ###@xxxxの作成
	    str = ""
        rec.each do |key,val|
	        case 
		        when key == "rubycoding_rubycode" 
	                @rubycoding_rubycode = val
		        when key == "button_onclickbutton"
	                @button_onclickbutton = val					
		        when val.class == String 
	                str << %Q%@#{key} = "#{val.gsub('"','\"')}"\n%
		        when val.class == Date 
	                str << "@#{key} = %Q%#{val}%.to_date\n"	  
		        when val.class == Time 
	                str << "@#{key} = %Q%#{val}%.to_time\n"
		        when val.class == NilClass 
	                str << "@#{key} = nil\n"
		        else 
	                str << "@#{key} = #{val}\n"
	        end
	    end
	    eval(str)
	end
    def undefined
      nil   
    end
    def get_screen_code 
        case
            when params[:jqgrid_id]  ##disp
               @jqgrid_id   =  params[:jqgrid_id]  ###@jqgrid_id  2dc_jqgridで使用
	           @screen_code = params[:jqgrid_id]  if params[:jqgrid_id].split('_div_')[1].nil?    ##子画面無
               @screen_code = params[:jqgrid_id].split('_div_')[1]  if params[:jqgrid_id].split('_div_')[1]    ##子画面
            ##when params[:action]  == "index"  then 
            ##   @jqgrid_id  = @screen_code = params[:id]   ## listからの初期画面の時 とcodeを求める時
            when params[:nst_tbl_val] 
               @jqgrid_id   =  params[:nst_tbl_val]
               @screen_code =  params[:nst_tbl_val].split("_div_")[1]  ###chil_scree_code
		    when params[:dump]  ### import by excel
               @screen_code = @jqgrid_id = params[:dump][:screen_code]
	    end
    end
    def crt_def_all
        eval("def dummy_def \n end")
		begin
			crt_defs = ActiveRecord::Base.connection.select_all("select * from rubycodings where expiredate > current_date")
			crt_defs.each do |src_tbl|
				vproc_crt_def_rubycode src_tbl
			end
			proc_create_tblinkfld_def
			crt_defs = ActiveRecord::Base.connection.select_all("select * from tblinks where expiredate > current_date")
			crt_defs.each do |src_tbl|
				vproc_crt_def_rubycode src_tbl
			end
		rescue			
            logger.debug" error class #{self} #{Time.now}:  $@: #{$@} " 
            logger.debug"  error class #{self} :  $!: #{$!} "
		end
	end
    def vproc_crt_def_rubycode src_tbl
		if src_tbl["codel"]
			strdef = "def #{src_tbl["codel"]}  #{src_tbl["hikisu"]} \n" 
		    strdef << src_tbl["rubycode"]
		    strdef <<"\n end"
			logger.debug strdef
		    eval(strdef)
		end
    end
	def str_init_command_c tbl_dest
	    %Q%
		command_c = {}.with_indifferent_access 
		command_c[:sio_session_counter] =   @new_sio_session_counter 
		command_c[:sio_recordcount] = 1
		command_c[:sio_user_code] =   @sio_user_code
		command_c[:sio_code] = command_c[:sio_viewname] =  "#{tbl_dest}"
		command_c.merge!(yield) if block_given?
		###  command_c[:sio_classname] = @sio_classname
		%
	end
	def proc_simple_sio_insert command_c
        ### @src_tbl作成はproc_update_tableで実施
		proc_update_table "command",proc_insert_sio_c(command_c),1
		#####proc_command_c_to_instance command_c  ###@xxxx_yyyy作成
	end
	def str_sio_set tblchop
		%Q%
		##end  ###if @sio_classname =~ /_delete_/
		##proc_command_instance_variable(command_c) 
		##proc_opeitm_instance(command_c)
		command_c[:sio_classname] = (@#{tblchop}_classname ||= @sio_classname)
		proc_simple_sio_insert command_c
		##proc_command_instance_variable(command_c) 
		##proc_opeitm_instance(command_c)   ##keyのありなしで、判断する時もあるので中止
	    end
		%
	end
    def proc_create_tblinkfld_def 	
		strsql = " select * from r_tblinkflds where tblinkfld_expiredate > current_date " 
		strsql << " order by pobject_code_scr_src,pobject_code_tbl_dest,tblink_beforeafter,tblink_seqno,tblinkfld_seqno "
	    recs = ActiveRecord::Base.connection.select_all(strsql)
		streval = nil
		tblchop = ""
		src_screen = ""
		beforeafter = ""
		seqno = ""
	    recs.each do |rec|
			if src_screen != rec["pobject_code_scr_src"] or 	tblchop != rec["pobject_code_tbl_dest"].chop or
					beforeafter != rec["tblink_beforeafter"] or seqno != rec["tblink_seqno"]
					if streval
						streval << str_sio_set(tblchop)
						logger.debug streval
						eval(streval)
					end
					src_screen = rec["pobject_code_scr_src"]
					tblchop = rec["pobject_code_tbl_dest"].chop
					beforeafter = rec["tblink_beforeafter"]
					seqno = rec["tblink_seqno"]
					streval = "def proc_fld_#{src_screen}_#{tblchop}s_#{beforeafter+seqno.to_s}\n"
					streval << str_init_command_c("r_#{rec["pobject_code_tbl_dest"]}")
			end
			if  rec["pobject_code_fld"] =~ /s_id/   ###tblchop==delm ###ヘッダーと同じものは除く crttblviewscreen
				fld = tblchop + "_" + rec["pobject_code_fld"].sub("s_id","_id")
			else
				fld = tblchop+"_"+rec["pobject_code_fld"]
			end
			if rec["tblinkfld_rubycode"] and rec["tblinkfld_rubycode"] != "undefined"
					streval << %Q&\n	command_c[:#{fld}] = #{rec["tblinkfld_rubycode"]} 	&
			else
				str = vproc_tblinkfld_dflt_set_fm_rubycoding(fld)
				if str
					streval << %Q&\n command_c[:#{fld}] = #{str} 	&
				end
			end
			if  rec["pobject_code_fld"] =~ /s_id/
				streval << %Q&\n 	command_c[:#{fld}] = "missing id #{fld}"  if command_c[:#{fld}].nil?  &  	###_id項目は必須
			end
	    end ##
		if recs.size > 0
		    streval << %Q&\n command_c[(command_c[:sio_viewname].split("_")[1].chop+"_id").to_sym] = command_c[:id] &
			streval << str_sio_set(tblchop)
			logger.debug streval
			eval(streval)
		end
    end
	### beforeへの戻しは　bkのみ
	####def vproc_delete_rec_contens(command_c)
	##	ret_rec = command_c.dup
	##	rec = ActiveRecord::Base.connection.select_one("select * from #{command_c[:sio_viewname]} where id = #{command_c[:id]}")
	##	rec.each do |key,val|
	##		ret_rec[key.to_sym] = val if val
	##	end
	##	return ret_rec
	##end
	def vproc_tblinkfld_dflt_set_fm_rubycoding fld
		dflt_rubycode = nil
		strsql = %Q& select * from r_rubycodings where pobject_objecttype = 'view_field' 	and  pobject_code = '#{fld}'
							and rubycoding_codel like '%dflt_for_tbl_set' &
		rubycode_view = ActiveRecord::Base.connection.select_one(strsql)
		if rubycode_view
			dflt_rubycode = rubycode_view["rubycoding_codel"] + " " +(rubycode_view["rubycoding_hikisu"]||="" )
		else
			fld_tbl = fld.split("_",2)[1] 
			strsql = %Q& select * from r_rubycodings where pobject_objecttype = 'tbl_field' 	and  pobject_code = '#{fld_tbl}'
					and rubycoding_codel like '%dflt_for_tbl_set' &
			rubycode_tbl = ActiveRecord::Base.connection.select_one(strsql)
			if rubycode_tbl
				dflt_rubycode = rubycode_tbl["rubycoding_codel"] + " " + (rubycode_tbl["rubycoding_hikisu"]||="")
			end
		end
		return dflt_rubycode
	end
    def proc_set_fields_from_allfields  ## value ###画面の内容をcommand_rへ ###typeの変換を
        command_c = params.dup
		command_c[:sio_user_code] = @sio_user_code  ###########   LOGIN USER
	    command_c[:sio_viewname]  = @show_data[:screen_code_view]
	    command_c[:sio_code]  = @screen_code
		command_c = char_to_number_data(command_c)
	        ## nilは params[j] にセットされない。
			### 下記の変換が未実施
			###  1 (params == String ,command_c=float or integer
        return command_c
    end
    def init_from_screen
		get_screen_code			
		@sio_user_code = ActiveRecord::Base.connection.select_value("select id from persons where email = '#{current_user[:email]}'")
	    @show_data = get_show_data @screen_code   #####popup画面もあるので@screen_codeをもパラメータにしている。
	    if @show_data.nil?
	       render :text=> "Create screen #{@screen_code} " and return
	    end
	    command_c = proc_set_fields_from_allfields
        return command_c
    end	
	def proc_get_inst_alloc destblname,inst_id,sno,qty
		if inst_id.nil?
			strsql = "select * from #{destblname} where sno = '#{sno}' "
			inst_id = ActiveRecord::Base.connection.select_one(strsql)["id"]
		end
		strsql = "select * from r_alloctbls where alloctbl_destblname = '#{destblname}' and alloctbl_destblid = #{inst_id} and alloctbl_qty > 0 "
		ary_alloc = []
		allocs = ActiveRecord::Base.connection.select_all(strsql)
		allocs.each do |alloc|
			if qty > 0
				if qty >= alloc["alloctbl_qty"]	
					ary_alloc << alloc
					qty -= alloc["alloctbl_qty"]
				else
					alloc[:alloctbl_qty] = qty
					ary_alloc << alloc
					qty = 0
				end
			else
				break
			end
		end
		return ary_alloc
	end
	def proc_decide_alloc_inout(cmd,id)
		
		alloc = ActiveRecord::Base.connection.select_one("select * from alloctbls where id = #{id}")
		if alloc.nil?
			logger.debug "error not found alloctbls 'select * from alloctbls where id = #{id} ' "
			raise
		end 
		command_c = ActiveRecord::Base.connection.select_one("select * from r_#{alloc["destblname"]} where id = #{alloc["destblid"]}")
		if command_c.nil?
			logger.debug "error:not found  #{alloc["destblid"]} by alloctbls_id 'select * from r_#{alloc["destblname"]} where id = #{alloc["destblid"]} ' "
			raise   ##logic error
		end
		##return rec.with_indifferent_access,alloc.with_indifferent_access
		#command_c,alloc = proc_get_view_from_alloc_id(id)
		###基本　sio_xxxxは　:sio_xxxとするが　　proc_command_instance_variableのhash keyが charのため　
		command_c["sio_viewname"] = command_c["sio_code"] = "r_#{alloc["destblname"]}"
		command_c["sio_classname"] = cmd
		proc_command_instance_variable(command_c)
		__send__(%Q&proc_tblink_alloctbls_#{alloc["destblname"]}_inouts_self10&,alloc)  if alloc["destblname"] !~ /cust/
	end
	def proc_inouts_in_addfield_create alloc
		add_fields = {}
		add_fields[:inout_qty_alloc] = alloc["qty"]
		add_fields[:inout_inoutflg] = "in"
		add_fields[:inout_trngantt_id_inout] = alloc["srctblid"]   ### trngantts_id
		add_fields[:inout_alloctbl_id_inout] = alloc["id"]  
		add_fields[:inout_loca_id] = eval("@#{alloc["destblname"].chop}_loca_id_to")  
		add_fields[:inout_starttime] = eval("@#{alloc["destblname"].chop}_duedate")  
		add_fields[:id] = add_fields[:inout_id] = proc_decision_id_by_key("inouts"," alloctbls_id_inout = #{alloc["id"]} and inoutflg = 'in' ")["id"]
		add_fields.merge!( proc_get_pare_from_trn_id(alloc["srctblid"]))
		__send__("proc_fld_alloctbls_#{alloc["destblname"]}_inouts_self10") do 
			add_fields
		end
	end
	#def proc_alloc_chng_act_to_lotstk trn
	#	strsql = %Q& select * from alloctbls where srctblname = 'trngantts'
	#					and destblname = '#{trn[:tblname]}' and destblid = #{trn[:id]} &
	#	alloctbls  = ActiveRecord::Base.connection.select_all(strsql)
	#	alloc = {}
	#	lot = {}
	#	alloctbls.each do |alloctbl|
	#		strsql = %Q& select alot.qty,alot.id alot_id,aprev.id aprev_id from alloctbls alot,alloctbls aprev 
	#					where alot.srctblname = 'trngantts' and alot.srctblid = #{alloctbl["srctblid"]}
	#					and alot.destblname = 'lotstkhists' and alot.destblid = #{@lotstkhist_id}
	#					and aprev.srctblname = alot.destblname and aprev.srctblid = alot.destblid
	#					and aprev.destblname = 'alloctbls' and aprev.destblid = #{alloctbl["id"]} &
	#		lot  = 	ActiveRecord::Base.connection.select_one(strsql)
	#		if lot.nil?
	#			lot = {}
	#			lot["qty"] = 0
	#		end
	#		if	lot["qty"] < trn[:qty] 
	#			alloctbl["qty"] -= trn[:qty]
	#		else  
	#			alloctbl["qty"] = lot["qty"] - trn[:qty]
	#		end
	#		proc_tbl_edit_arel("alloctbls", alloctbl," id = #{alloctbl["id"]} ")
	#		proc_decide_alloc_inout("alloc_edit_",alloctbl["id"])
	#		if lot["alot_id"]
	#			proc_tbl_edit_arel("alloctbls", {:qty=>trn[:qty],:updated_at => Time.now}," id = #{lot["alot_id"]} ")
	#			proc_decide_alloc_inout("alloc_edit_",lot["alot_id"])
	#			proc_tbl_edit_arel("alloctbls", {:qty=>trn[:qty],:updated_at => Time.now}," id = #{lot["aprev_id"]} ")
	#		else
	#			alloc[:srctblname] = alloctbl["srctblname"]
	#			alloc[:srctblid] = alloctbl["srctblid"]
	#			alloc[:destblname] = "lotstkhists"
	#			alloc[:destblid] = @lotstkhist_id
	#			alloc[:qty] = trn[:qty]
	#			alloc[:allocfree] = "alloc"
	#			alloc[:id] = proc_get_nextval "alloctbls_seq" 
	#			alloc[:created_at] = Time.now
	#			alloc[:updated_at] = Time.now
	#			alloc[:persons_id_upd] = System_person_id
	#			proc_tbl_add_arel("alloctbls", alloc)
	#			proc_decide_alloc_inout("alloc_add_",alloc[:id])
	#			alloc[:srctblname] = "lotstkhists"
	#			alloc[:srctblid] = @lotstkhist_id
	#			alloc[:destblname] = "alloctbls"  
	#			alloc[:destblid] = alloctbl["id"]
	#			alloc[:id] = proc_get_nextval "alloctbls_seq" 
	#			proc_tbl_add_arel("alloctbls", alloc)  ###引当て履歴　inouts関係なし
	#		end
	#	end
	#	case lot["alot_id"]
	#		when nil   ###新規の時
	#			gantt = proc_decision_id_by_key("trngantts"," key = '000' and orgtblname = 'lotstkhists' and orgtblid = #{@lotstkhist_id} ")
	#			pre_gantt ={"id"=>gantt["id"],
	#				"key"=>"000","orgtblname"=>"lotstkhists","orgtblid"=>@lotstkhist_id,
	#				"mlevel"=>0,"prjnos_id" => @lotstkhist_prjno_id,
	#				"starttime"=>Date.today,"duedate"=>Date.today,
	#				"parenum"=>1,"chilnum"=>1,
	#				"qty"=>trn[:qty] + (gantt["qty"]||=0),  ###stkは使用しなくなった。
	#				"qty_src"=>0,
	#				"opeitms_id"=>trn[:opeitms_id],
	#				"expiredate"=>"2099/12/31".to_date,
	#				"created_at"=>Time.now,"updated_at"=>Time.now,"remark"=>" create from act",
	#				"persons_id_upd"=>alloc[:persons_id_upd]} 
	#			##Trngantt.create pre_gantt	### sch,ord,inst,act自身のtrngantts
	#			if @trngantt_classname =~ /_add_/ then proc_tbl_add_arel("trngantts",pre_gantt) else proc_tbl_edit_arel("trngantts",pre_gantt," id = #{gantt["id"]} ") end
	#			gantt = proc_decision_id_by_key("trngantts"," key = '000' and orgtblname = 'lotstkhists' and orgtblid = #{@lotstkhist_id} ")
	#			pre_gantt["id"] = gantt["id"] 
	#			pre_gantt["key"] = "000" 
	#			pre_gantt["mlevel"] = 1 
	#			##Trngantt.create pre_gantt
	#			if @trngantt_classname =~ /_add_/ then proc_tbl_add_arel("trngantts",pre_gantt) else proc_tbl_edit_arel("trngantts",pre_gantt," id = #{gantt["id"]} ") end 
	#			strsql = %Q& select sum(alloctbl.qty) qty from alloctbls alloctbl,trngantts trn
	#						where alloctbl.srctblname = 'trngantts' and trn.id = alloctbl.srctblid and trn.key = '000'
	#						and trn.orgtblname = '#{trn[:tblname]}' and trn.orgtblid = #{trn[:id]} 
	#						and destblname = 'lotstkhists' and destblid =  #{@lotstkhist_id}
	#						group by alloctbl.srctblname,alloctbl.srctblid,alloctbl.destblname,alloctbl.destblid & 
	#			free_qty  = ActiveRecord::Base.connection.select_value(strsql)
	#			alloc[:srctblname] = "trngantts"
	#			alloc[:srctblid] = pre_gantt["id"]
	#			alloc[:destblname] = "lotstkhists"
	#			alloc[:destblid] = @lotstkhist_id
	#			alloc[:id] = proc_get_nextval "alloctbls_seq"
	#			alloc[:qty] = free_qty
	#			alloc[:allocfree] = "alloc"
	#			#Alloctbl.create alloc
	#			proc_tbl_add_arel("alloctbls",alloc)
	#			proc_decide_alloc_inout("alloc_add_",alloc[:id])
	#		else
	#			proc_tbl_edit_arel("alloctbls",{:qty=>trn[:qty]}," id = #{lot["alot_id"]} ")
	#			proc_decide_alloc_inout("alloc_edit",lot["alot_id"])
	#			proc_tbl_edit_arel("alloctbls",{:qty=>trn[:qty]}," id = #{lot["aprev_id"]} ")
	#	end
	#end
	def proc_get_nextval tbl_seq
		ActiveRecord::Base.uncached() do
			case Db_adapter 
				when /post/
					ActiveRecord::Base.connection.select_value("SELECT nextval('#{tbl_seq}')")  ##post
				when /oracle/
					ActiveRecord::Base.connection.select_value("select #{tbl_seq}.nextval from dual")  ##oracle
			end
		end
	end
	def proc_chk_tble_exist tblname
		case ActiveRecord::Base.configurations[Rails.env]['adapter'] 
			when /post/
				ActiveRecord::Base.connection.select_value("select relname as TABLE_NAME from pg_stat_user_tables where table_name = '#{tblname.doencase}'")  ##post
			when /oracle/
				ActiveRecord::Base.connection.select_value("select table_name from user_tables where table_name = '#{tblname.upcase}'")  ##oracle
		end
	end
	def proc_blk_columns tblname
		columns = {}
		case ActiveRecord::Base.configurations[Rails.env]['adapter'] 
			when /post/
				ActiveRecord::Base.connection.select_all("SELECT attname, typname FROM pg_class, pg_attribute, pg_type WHERE   relkind     ='r'
												AND relname     ='テーブル名' AND attrelid    = (select relid from pg_stat_all_tables where relname = 'テーブル名')
												AND attnum      > 0    AND pg_type.oid = atttypid;")  ##post
				####SELECT pg_class.relname, pg_attribute.attname, pg_attribute.atttypmod, pg_attribute.attnum, pg_attribute.attalign, 
				##		pg_attribute.attnotnull, pg_type.typname 
				##FROM pg_class, pg_attribute, pg_type 
				##WHERE pg_class.oid = pg_attribute.attrelid and pg_attribute.atttypid = pg_type.oid and pg_class.relname='テーブル名称' and pg_attribute.attnum > 0 
				##ORDER BY pg_attribute.attnum;
			when /oracle/
				recs = ActiveRecord::Base.connection.select_all("select * from user_tab_columns where  table_name = '#{tblname.upcase}'")  ##oracle
				recs.each do |rec|
					columns[rec["column_name"].downcase] = {:data_type=>rec["data_type"],:data_precision=>rec["data_precision"],:data_scale=>rec["data_scale"],:char_length=>rec["char_length"]}
				end
		end
		return columns
	end
	def proc_get_trg_rec_id_fm_tblname_tblid tblname,srctblname,srctblid  ##レコードが見つからなかったときの処理は親ですること。
		if @sio_classname =~ /_add_/
			id = proc_get_nextval "#{tblname}_seq"
		else
			if block_given?
				id = ActiveRecord::Base.connection.select_value("select id from #{tblname} where tblname = '#{srctblname}' and tblid = #{srctblid} #{yield}")
			else
				id = ActiveRecord::Base.connection.select_value("select id from #{tblname} where tblname = '#{srctblname}' and tblid = #{srctblid}")
			end
		end
		return id
	end
	def proc_get_rec_fm_tblname_sno tblname,sno　 ##レコードが見つからなかったときの処理は親ですること。
		rec = {}
		if @sio_classname =~ /_add_/
			rec["id"] = nil
		else  ###snoはテーブル毎に必ずユニーク
			rec = ActiveRecord::Base.connection.select_one("select * from #{tblname} where sno = #{sno}")
		end
		rec.with_indifferent_access if rec
	end
	
	def proc_get_rec_fm_tblname_yield tblname  ##proc_fld_xxxxの中の項目を求める。　 ##レコードが見つからなかったときの処理は親ですること。
		rec = ActiveRecord::Base.connection.select_one("select * from #{tblname} where expiredate > current_date and #{yield}")
		rec.with_indifferent_access if rec
	end
	def proc_get_rec_fm_viewname_yield viewname  ##proc_fld_xxxxの中の項目を求める。　 ##レコードが見つからなかったときの処理は親ですること。
		rec = ActiveRecord::Base.connection.select_one("select * from #{viewname} where #{viewname.split("_")[1].chop}_expiredate > current_date and #{yield}")
		rec.with_indifferent_access if rec
	end
	def proc_get_allrecs_fm_tblname_yield tblname  ##proc_fld_xxxxの中の項目を求める。　 ##レコードが見つからなかったときの処理は親ですること。
		rec = ActiveRecord::Base.connection.select_all("select * from #{tblname} where expiredate > current_date and  #{yield}")
		rec.with_indifferent_access
	end
	def proc_get_viewrec_from_id tblname,id  ##  ##レコードが見つからなかったときの処理は親ですること。
		rec = ActiveRecord::Base.connection.select_one("select * from r_#{tblname} where id = #{id}")
		return rec.with_indifferent_access if rec
	end
	def proc_get_pare_from_trn_id trn_id  ## inoutsのprocessseq　itms_id_pare
		inout = {}
		for ii in 1..5 do
			strsql = " select case when pare.itm_id = trn.itm_id then pare.trngantt_processseq else 999 end processseq,
					pare.itm_id itms_id_pare,trn.itm_id itms_id,pare.trngantt_key key,pare.trngantt_id trn_id
					from r_trngantts trn,r_trngantts pare
					where trn.trngantt_orgtblname = pare.trngantt_orgtblname and trn.trngantt_orgtblid = pare.trngantt_orgtblid
					and pare.trngantt_key =  case length(trn.trngantt_key)      when 3 then  to_char(trn.trngantt_key  - 1,'000')   else   substr(trn.trngantt_key,1,length(trn.trngantt_key) -3)   end
					and trn.id = #{trn_id} "
			rec = ActiveRecord::Base.connection.select_one(strsql)
			if rec
				inout["inout_processseq"] = rec["processseq"] if ii == 1
				inout["inout_itm_id_pare"] = rec["itms_id_pare"]
			else
				rec1 = ActiveRecord::Base.connection.select_one("select itms_id,processseq from trngantts where id = #{trn_id}")
				inout["inout_processseq"] = rec1["processseq"] 
				inout["inout_itm_id_pare"] = rec1["itms_id"]
				break					
			end
			break if rec["itms_id_pare"] != rec["itms_id"]
			ii += 1
			break rec["key"].size < 4
			trn_id = rec["trn_id"]
		end
		return inout
	end
	def proc_get_inout_id(add_fields)##
		case @sio_classname
			when /_add_/
				inouts_id = [] 
				inouts_id[0] = proc_get_nextval("inouts_seq")
			when /_edit_/
				strsql = %Q& select id from inouts where alloctbls_id_inout = #{add_fields[:inout_alloctbl_id_inout]} 
									and inoutflg ='#{add_fields[:inout_inoutflg]}' 
									#{if add_fields[:inout_itm_id] then " and itms_id = " + add_fields[:inout_itm_id].to_s else "" end } &  
				inouts_id = ActiveRecord::Base.connection.select_values(strsql)  ###実際には　1個のみ　		+ 4でチェック
			else
				logger.debug "error @sio_classname #{@sio_classname}  : add_fields #{add_fields} "
				raise
		end	
		if inouts_id.size != 1   ### 
			###ActiveRecord::Base.connection.commit_db_transaction()
			logger.debug "error when get   inout_id   strsql = #{strsql}  : must be inouts_id.size == 1 "
			raise
		end
		return inouts_id[0]
	end
	##def proc_alloc_ids_fm_trngantt(trngantt_id)
	##	strsql = %Q& select id from alloctbls where srctblname = 'trngantts' and srctblid = #{trngantt_id} 	and qty > 0 &  
	##	rec = ActiveRecord::Base.connection.select_values(strsql)			
	##end
	def proc_decision_id_by_key(tblname,where)
		strsql = %Q& select * from #{tblname} where #{where} &  
		rec = ActiveRecord::Base.connection.select_one(strsql)
		eval(%Q& if  rec.nil?
					rec = {}
					rec["id"] =  proc_get_nextval("#{tblname}_seq")
					@#{tblname.chop}_classname = "#{tblname}_add_#{where}"[0..49]
				else
					### tbllinksでユニークkey チェックをセットする。　複数レコードはエラー
					@#{tblname.chop}_classname  = "#{tblname}_edit_#{where}"[0..49]
				end &)
		eval(%Q& @#{tblname.chop}_id = rec["id"] &)		
		return rec
	end
	def proc_decision_all_ids_by_key(tblname,where)
		strsql = %Q& select * from #{tblname} where #{where} &  
		recs = ActiveRecord::Base.connection.select_all(strsql)
		eval(%Q& if  recs.size == 0
					rec[0] = {"id" =>  proc_get_nextval("#{tblname}_seq")}
					@#{tblname.chop}_classname = "#{tblname}_add_#{where}"[0..49]
				else
					@#{tblname.chop}_classname  = "#{tblname}_edit_#{where}"[0..49]
				end &)
		return recs
	end
	def proc_tbl_add_arel  tblname,hash ##
		fields = ""
		values = ""
		hash.each do |key,val|
			fields << key.to_s + ","
			values << case val.class.to_s
				when "String"
					%Q&'#{val.gsub("'","''")}',&
				when "Fixnum","Bignum","BigDecimal","Float"
					"#{val},"
				when "Date"
					%Q& to_date('#{val.strftime("%Y/%m/%d")}','yyyy/mm/dd'),&
				when "Time"
					case key.to_s
						when "created_at","updated_at"
							%Q& to_date('#{val.strftime("%Y/%m/%d %H:%M:%S")}','yyyy/mm/dd hh24:mi:ss'),&
						else
							%Q& to_date('#{val.strftime("%Y/%m/%d %H:%M")}','yyyy/mm/dd hh24:mi'),&
					end
				when "DateTime"
					case key.to_s
						when "expiredate"
							%Q& to_date('#{val.strftime("%Y/%m/%d")}','yyyy/mm/dd'),&
						else
							%Q& to_date('#{val.strftime("%Y/%m/%d %H:%M")}','yyyy/mm/dd hh24:mi'),&
					end
				when "NilClass"
					"null,"
				when "Hash"
					"'#{val.to_query}',"
				else
					logger.debug " line #{__LINE__} : error val.class #{val.class}  key #{key.to_s} "
			end
		end
		ActiveRecord::Base.connection.insert("insert into #{tblname}(#{fields.chop}) values(#{values.chop})")
	end	
	def proc_tbl_edit_arel  tblname,hash,strwhere ##
		strset = ""
		hash.each do |key,val|
			strset << key.to_s  + " = "
			strset << case val.class.to_s
				when "String"
					%Q&'#{val.gsub("'","''")}',&
				when "Fixnum","Bignum","BigDecimal","Float"
					"#{val},"
				when "Date"
					%Q& to_date('#{val.strftime("%Y/%m/%d")}','yyyy/mm/dd'),&
				when "Time"
					case key.to_s
						when "created_at","updated_at"
							%Q& to_date('#{val.strftime("%Y/%m/%d %H:%M:%S")}','yyyy/mm/dd hh24:mi:ss'),&
						else
							%Q& to_date('#{val.strftime("%Y/%m/%d %H:%M")}','yyyy/mm/dd hh24:mi'),&
					end
				when "NilClass"
					"null,"
				else
					logger.debug " line #{__LINE__} : error val.class #{val.class}  key #{key.to_s} "
					raise
		   end
		end
		ActiveRecord::Base.connection.update("update #{tblname}  set #{strset.chop} where #{strwhere} ")
	end
	def proc_tbl_delete_arel  tblname,strwhere ##
		ActiveRecord::Base.connection.delete("delete from  #{tblname}  where #{strwhere} ")
	end
	def proc_price_amt command_c
		tblnamechop = (command_c[:sio_viewname].split("_",2)[1].chop)
		qty = command_c[("#{tblnamechop}_qty").to_sym]
		case tblnamechop  
			when /^cust/
				pricetbl = "custs"
				loca_code = command_c[:loca_code_cust]
			when /^pur/
				pricetbl = "dealers"
				loca_code = command_c[:loca_code]   ###入力でdealerを保証する。
			when /^prd/
				pricetbl = "asstwhs"
				loca_code = command_c[:loca_code_asstwh]
			when /^shp/			
				loca_code = command_c[:loca_code_to]
				case command_c[:opeitm_oparation]
					when "shp:delivered_goods"
							pricetbl = "custs"
					when "shp:feepayment"	
							pricetbl = "feepayms"
					when "shp:shipment"
							pricetbl = "asstwhs"
					else
							pricetbl = "asstwhs"
				end
				loca_code = command_c[:loca_code_to]
			when /mkact/
				case command_c[:mkact_prdpurshp]
					when "pur"
						pricetbl = "dealers"
						if command_c[:mkact_sno_inst]
							strsql = "select * from r_purinsts where purinst_sno = '#{command_c[:mkact_sno_inst]}'"
							loca_code = ActiveRecord::Base.connection.select_one(strsql)["loca_code"]
						else
							if command_c[:mkact_sno_act]
								strsql = "select * from r_puracts where purinst_sno = '#{command_c[:mkact_sno_act]}'"
								loca_code = ActiveRecord::Base.connection.select_one(strsql)["loca_code"]
							else							
								return {}
							end
						end
					else
						return {}
				end	
			else
				return {}
		end
		strsql = "select *
				from r_pricemsts 	/*同一品目内ではcontract_price<pricemst_amtroundは有効日内で同一であること*/
				where pricemst_tblname =  '#{pricetbl}' and pricemst_expiredate >= current_date and
				itm_code = '#{command_c[:itm_code]}' AND loca_code = '#{loca_code}' " 
		rec_contract = ActiveRecord::Base.connection.select_one(strsql)   ###画面のfield
		command_c[("#{tblnamechop}_contract_price").to_sym]||=""
		if command_c[("#{tblnamechop}_contract_price").to_sym]  != "" ###変更の時
			contract = command_c[("#{tblnamechop}_contract_price").to_sym]
			price = (command_c[("#{tblnamechop}_price").to_sym]||=0).to_f
			amtround = rec_contract["pricemst_amtround"] if rec_contract
			amtdecimal = rec_contract["pricemst_amtdecimal"] if rec_contract
		else   ###新規登録の時の単価
			if rec_contract.nil?
				contract = ""
				case tblnamechop
					when /^cust/
						contract= "C"
					when /^pur/
						contract = "D"
					when /^prd/
						contract = "X"  ###単価未定
						expiredate = ""
						return {:price=>"0",:amt=>"0",:tax=>"0",:amtf=>"0",:contract_price => contract}   ##
					when /^shp/			
						case command_c[:opeitm_oparation]
							when "shp:delivered_goods"
								contract= "C"
							when "shp:feepayment"
								contract = "F"
							when "shp:shipment"
								contract = "X"  ###単価未定
								expiredate = ""
								return {:price=>"0",:amt=>"0",:tax=>"0",:amtf=>"0",:contract_price => contract}   ##
							else
								contract = "X"  ###単価未定
								expiredate = ""
								return {:price=>"0",:amt=>"0",:tax=>"0",:amtf=>"0",:contract_price => contract}   ##
					end
				end
			else
				contract = rec_contract["pricemst_contract_price"]
				amtround = rec_contract["pricemst_amtround"]
				amtdecimal = rec_contract["pricemst_amtdecimal"]
			end
		end
		##7:出荷日までに決定する単価
		##　8:受入日までに決定する単価　
		##9:単価決定=検収
		expiredate = nil
		case contract
			when "1" ###発注日ベース　　発注日　== String 以下同様
				if tblnamechop =~ /ord|sch/
					expiredate = vproc_price_expiredate_set(contract,command_c) 	
				else
					return {:pricef=>true,:amtf=>true}
				end
			when "2"	###納期ベース	
				if tblnamechop =~ /inst|ord|sch/
					expiredate = vproc_price_expiredate_set(contract,command_c)	
				else
					return {:pricef=>true,:amtf=>true}
				end
			when "3","4"				
				expiredate = vproc_price_expiredate_set(contract,command_c)
			when "C","D","F" ##C : custs テーブルに従う D:dealersテーブルに従う
				case  pricetbl
					when  "custs"
						strsql = "select  * from r_custs 	
								where loca_code_cust =  '#{loca_code}' and cust_expiredate > current_date " 
						pare_contract = ActiveRecord::Base.connection.select_one(strsql)   ###画面のfield
						if pare_contract
							expiredate = vproc_price_expiredate_set(pare_contract["cust_contract_price"],command_c)
							if expiredate.nil?
								logger.debug "line #{__LINE__} strsql #{strsql}"
								raise
							end
							pare_rule_price = pare_contract["cust_rule_price"]
							amtround = pare_contract["pricemst_amtround"]
							amtdecimal = pare_contract["pricemst_amtdecimal"]
						end
					when  "dealers"
						strsql = "select  * from r_dealers 	
									where loca_code_dealer =  '#{loca_code}' and dealer_expiredate > current_date " 
						pare_contract = ActiveRecord::Base.connection.select_one(strsql)   ###画面のfield
						expiredate = vproc_price_expiredate_set(pare_contract["dealer_contract_price"],command_c)
						if expiredate.nil?
							logger.debug "line #{__LINE__} strsql #{strsql}"
							raise
						end
						pare_rule_price = pare_contract["dealer_rule_price"]
						amtround = pare_contract["pricemst_amtround"]
						amtdecimal = pare_contract["pricemst_amtdecimal"]
					when  "feepayms"
						strsql = "select  * from r_feepayms 	
									where loca_code_dealer_fee =  '#{loca_code}' and feepaym_expiredate > current_date " 
						pare_contract = ActiveRecord::Base.connection.select_one(strsql)   ###画面のfield
						expiredate = vproc_price_expiredate_set(pare_contract["feepaym_contract_price"],command_c)
						if expiredate.nil?
							logger.debug "line #{__LINE__} strsql #{strsql}"
							raise
						end
						pare_rule_price = pare_contract["feepaym_rule_price"]
						amtround = pare_contract["pricemst_amtround"]
						amtdecimal = pare_contract["pricemst_amtdecimal"]
				end
			when "Z"
				expiredate = ""
		end 
		if expiredate.nil?
			logger.debug "line #{__LINE__} proc_price_amt :master error ???"
		end
		strsql = %Q& select * from r_pricemsts 	
					where pricemst_tblname =  '#{pricetbl}' and
						itm_code = '#{command_c[:itm_code]}' AND loca_code = '#{loca_code}' and
						pricemst_maxqty >= #{qty} and
						pricemst_expiredate >= to_date('#{expiredate}','yyyy/mm/dd') and
						pricemst_contract_price = '#{contract}'
						order by pricemst_expiredate ,pricemst_maxqty  &
		price_rec = ActiveRecord::Base.connection.select_one(strsql)   ###画面のfield
		if price_rec
			amtf = true
			contract = price_rec["pricemst_contract_price"]
			amtround = price_rec["pricemst_amtround"]
			amtdecimal = price_rec["pricemst_amtdecimal"]
			if price_rec["pricemst_rule_price"] == "0"
				pricef = true 
				price =  price_rec["pricemst_price"]
			else
				if contract == "Z"
					price = command_c[("#{tblnamechop}_price").to_sym].to_f
					contract = "Z" if price_rec["pricemst_price"] != price
				else
					price =  price_rec["pricemst_price"]
				end
			end
		else
			if pare_rule_price  == "0" 
				price = proc_blkgetpobj("単価マスタなし","err_msg")
				return {:price=>price.to_s,:amt=>"",:tax=>"",:pricef=>true,:amtf=>true,:contract_price => contract}
			end
            ###画面から単価入力された時
		end
		amt = qty.to_f * price
		case amtround
			when "-1"  ###切り捨て
				amt = amt.floor2(amtdecimal)
			when "0"
				amt = amt.round(amtdecimal)
			when "1"  ###切り上げ
				amt = amt.ceil2(amtdecimal)
			else
				raise  ###該当レコードのremarkに
		end
		tax = vproc_get_tax(amt,loca_code)    ###作成中
		return {:price=>price.to_s,:amt=>amt.to_s,:tax=>tax.to_s,:pricef=>true,:amtf=>true,:contract_price => contract}
	end	
	def vproc_get_tax(amt,loca_code)  ###作成中
		0
	end
	def vproc_price_expiredate_set(contract,command_c)
		tblnamechop = command_c[:sio_viewname].split("_",2)[1].chop
		case contract  ###
			when "1"   ###発注日ベース
				expiredate = command_c[(tblnamechop+"_isudate").to_sym].strftime("%Y/%m/%d")
			when "2" ###納期ベース
				expiredate = command_c[(tblnamechop+"_duedate").to_sym].strftime("%Y/%m/%d")
			when "3" ###:受入日ベース   
				if tblnamechop =~ /acts$/ 
					expiredate = command_c[(tblnamechop+"_rcptdate").to_sym].strftime("%Y/%m/%d")
				else 
					expiredate = command_c[(tblnamechop+"_duedate").to_sym].strftime("%Y/%m/%d")
				end
			when "4" ###:出荷日ベース　
				expiredate = command_c[(tblnamechop+"_depdate").to_sym].strftime("%Y/%m/%d")
			when "5" #####:検収ベース  
				expiredate = command_c[(tblnamechop+"acpdate").to_sym].strftime("%Y/%m/%d")
		end
	end
	def proc_update_gantt_alloc_fm_trn trn,allocs,trn_id = nil    ### allocs:ord等の作成元　ordなら　sch;  instならord
		return if trn[:sio_classname] =~ /_edit_|delete_/
		tmp_gantt ={:id=>proc_get_nextval("trngantts_seq"),:key=>"000",
			:orgtblname=>trn[:tblname] ,:orgtblid=>trn[:id],:mlevel=>0,
			:prjnos_id=>trn[:prjnos_id],
			:itms_id=>trn[:itms_id],:locas_id=>trn[:locas_id],
			:prdpurshp=>trn[:prdpurshp],:processseq=>trn[:processseq],:priority=>trn[:priority],:shuffle_flg=>trn[:shuffle_flg],
			:starttime=>(trn[:starttime]||=trn[:depdate]),:duedate=>trn[:duedate],
            :parenum=>1,:chilnum=>1,:consumtype=>trn[:consumtype],:autoord_p=>"",:autoinst_p=>"",
			:consumauto=>"",:qty=>trn[:qty],
			:qty_src=>trn[:qty],:depends=>"",:expiredate=>"2099/12/31".to_date,
			:created_at=>Time.now,:updated_at=>Time.now,:remark=>"proc_update_gantt_alloc_fm_trn",
			:persons_id_upd=>System_person_id}
		proc_tbl_add_arel("trngantts",tmp_gantt) 
		### schからord ordから　・・・・を作成時には子部品のtrnganttsは作成しない。　二重手配になる。。	
		new_alloc = {}	
		new_alloc[:srctblname] = "trngantts"
		new_alloc[:destblname] = "#{trn[:tblname] }"
		new_alloc[:srctblid] = tmp_gantt[:id]	
		new_alloc[:destblid] = trn[:id]
		new_alloc[:allocfree] = "free"
		new_alloc[:id] = proc_get_nextval "alloctbls_seq"
		new_alloc[:persons_id_upd] = System_person_id
		new_alloc[:expiredate] = "2099/12/31".to_date
		###  inouts 
		proc_tbl_add_arel("alloctbls",new_alloc)
		allocs.each do |alloc|
			trn[:qty]  = proc_update_base_alloc trn,alloc,new_alloc[:id] 
			break if trn[:qty] <= 0
		end
    end
	def proc_add_alloc_fm_schtrn trn,trngantt_id  ### allocs:ord等の作成元　ordなら　sch;  instならord
	##proc_tblink_mksch_trnganttsから呼ばれる
		return if trn[:sio_classname] =~ /_edit_|delete_/
		str_alloctbl = {}		
		new_alloc = {}	
		new_alloc[:srctblname] = "trngantts"
		new_alloc[:destblname] = "#{trn[:tblname] }"
		new_alloc[:srctblid] = trngantt_id	
		new_alloc[:destblid] = trn[:id]
		###trn = str_gantt ##xxxschsの時
		##if trngantt_id   ###tranganttを展開して作成
		new_alloc[:allocfree] = "alloc"
		##else   ### xxxschsを直接入力
		##	new_alloc[:srctblid] =	 proc_create_self_gantt(trn,nil)
		##	new_alloc[:allocfree] = "free"
		##end
		new_alloc[:qty] = trn[:qty] ### allocs.nilで　trn[:qty] != trngantt_qtyはあり得ない  
		new_alloc[:srctblid] = trngantt_id
		alloc_id = proc_create_or_replace_alloc_by_same_tbl(trn,new_alloc)
    end	
	def proc_update_base_alloc trn,alloc,free_alloc_id   ###trn:freeのtrn alloc:引当て要求元　freeを引き当てたいalloc
		based_alloc  = {}
		based_alloc[:remark] = "proc_update_base_alloc trn,alloc,free_alloc_id"
		debugger if alloc.nil?
		##based_alloc[:srctblname] = alloc["alloctbl_srctblname"]
		##based_alloc[:srctblid] = alloc["alloctbl_srctblid"]	
		##based_alloc[:destblname] = alloc["alloctbl_destblname"]
		##based_alloc[:destblid] = alloc["alloctbl_destblid"]
		##based_alloc[:allocfree] = alloc["alloctbl_allocfree"]
		##based_alloc[:id] = alloc["alloctbl_id"] 
		##based_alloc[:persons_id_upd] = System_person_id
		##based_alloc[:expiredate] = "2099/12/31".to_date
		based_alloc[:qty] = if  alloc["alloctbl_qty"] <= trn[:qty] then 0 else alloc["alloctbl_qty"] - trn[:qty] end 
	    ## 上位ステータスに変更
		proc_tbl_edit_arel("alloctbls", based_alloc," id =  #{alloc["alloctbl_id"]} ")
		proc_decide_alloc_inout("alloc_edit_",alloc["alloctbl_id"])
		based_alloc[:srctblname] = "#{trn[:tblname] }"
		based_alloc[:srctblid] = trn[:id]	
		based_alloc[:destblname] = "alloctbls"
		based_alloc[:destblid] = alloc["alloctbl_id"]
		based_alloc[:allocfree] = "other"
		based_alloc[:qty] = alloc["alloctbl_qty"] - based_alloc[:qty]
		based_alloc[:id] = proc_get_nextval "alloctbls_seq"
		based_alloc[:persons_id_upd] = System_person_id
		based_alloc[:expiredate] = "2099/12/31".to_date
		###引当て履歴を作成 変更  inoutsには関係ない。
		proc_tbl_add_arel("alloctbls",based_alloc) 
		based_alloc[:srctblname] = alloc["alloctbl_srctblname"]  ###=trngantts
		based_alloc[:srctblid] = alloc["alloctbl_srctblid"]
		based_alloc[:destblname] = "#{trn[:tblname] }"
		based_alloc[:destblid] = trn[:id]
		based_alloc[:allocfree] = "alloc"
		based_alloc[:qty] = if  alloc["alloctbl_qty"] <= trn[:qty] then alloc["alloctbl_qty"] else trn[:qty] end
		based_alloc[:id] = proc_get_nextval "alloctbls_seq"
		###新規引当て作成
		proc_tbl_add_arel("alloctbls",based_alloc) 
		proc_decide_alloc_inout("alloc_add_",based_alloc[:id])
		###   ## 引当てを　schからord  又はordからinstへ　
		proc_tbl_edit_arel("alloctbls", {:qty => (trn[:qty] - based_alloc[:qty])}," id = #{free_alloc_id} ")
		proc_decide_alloc_inout("alloc_edit_",free_alloc_id)
		return (trn[:qty] - based_alloc[:qty])
	end	
	def proc_reverse_alloc destblname,destblid,qty   ###trn:freeのtrn alloc:引当て要求元　freeを引き当てたいalloc  qty:戻す数
		strsql = "select * from alloctbls where srctblname = '#{destblname}' and srctblid = #{destblid} and destblname = 'alloctbls' and allocfree] = 'other' order by id desc "
		bases = ActiveRecord::Base.connection.select_all(strsql)
		bases.each do|base|
			reverse = ActiveRecord::Base.connection.select_one("select * from alloctbls where id = #{base["destblid"]}")
			if qty > base["qty"]
				proc_tbl_edit_arel("alloctbls",{:qty=>reverse["qty"]+ base["qty"]}," id =  #{reverse["id"]} ")
				proc_decide_alloc_inout("alloc_edit_",reverse["id"])
				proc_tbl_edit_arel("alloctbls",{:qty=>0}," id =  #{base["id"]} ")
				qty -= base["qty"]
			else
				proc_tbl_edit_arel("alloctbls",{:qty=>qty + base["qty"]}," id =  #{reverse["id"]} ")
				proc_decide_alloc_inout("alloc_edit_",reverse["id"])
				proc_tbl_edit_arel("alloctbls", {:qty=>base["qty"] - qty}," id =  #{base["id"]} ")
				qty = 0
			end
		end
	end
	#def proc_create_self_gantt trn,allocs
	#	sum_qty = 0
	#	if allocs
	#		allocs.each do |alloc|
	#			sum_qty += alloc["alloctbl_qty"]
	#		end
	#	end
	#	pre_gantt ={"tblname"=>trn[:tblname],
	#		"tblid"=>trn[:id],
	#		"prjnos_id" => trn[:prjnos_id],
	#		"starttime"=>if trn[:prdpurshp] == "shp" then  trn[:depdate]
	#			              else trn[:starttime] end,
	#		"qty" =>(trn[:qty] - (sum_qty)),
	#		"duedate"=>	trn[:duedate],"priority"=>trn[:priority],
	#		"itms_id"=>trn[:itms_id],"locas_id"=>trn[:locas_id],
	#		"opeitms_id"=>trn[:opeitms_id]}
	#	pre_gantt["qty_src"] = 	trn[:qty]
	#	proc_add_trngantts(trn[:tblname].chop) 				
	#	strsql = %Q& select id from trngantts where 
	#				orgtblname = '#{trn[:tblname]}' 
	#				and orgtblid = #{trn[:id]}
	#				and key = '001' &
	#	pre_gantt_id = ActiveRecord::Base.connection.select_value(strsql)
	#	return pre_gantt_id
	#end
	def proc_add_trngantts	tblchop								
        @bgantts = {}
		cnt = 0
		if @opeitm_id
			if @itm_id.nil?
				@itm_id = @opeitm_itm_id
			end
			if @loca_id.nil?
				@loca_id = @opeitm_loca_id
			end
		else
			if @itm_id
				@opeitm_id = proc_get_opeitms_id_fm_itm_loca(@itm_id,@loca_id,processseq = nil,priority = nil)["id"]
			else
				logger.debug " error class line #{__LINE__} ,@opeitm_id not found:#{rec} "
				raise
			end
			if @loca_id.nil?
				logger.debug " line #{__LINE__} ,@opeitm_id not found:#{rec} "
			end		
		end
		@bgantts["000"] = {:mlevel=>0,
			:opeitms_id=>@opeitm_id,:duration=>0,:assigs=>"",
			:itm_id=>@itm_id,:loca_id=>@loca_id,:processseq=>999,:priority=>eval("@#{tblchop}_priority||=999"),:prdpurshp=>"",
							:endtime=>eval("@#{tblchop}_duedate"),:starttime=>eval("@#{tblchop}_isudate"),
							:autocreate_ord=>"",:autocreate_inst=>"",:autoord_p=>"",:autoinst_p=>"",
							:autocreate_ord=>"",:autocreate_inst=>"",
							:qty=>eval("@#{tblchop}_qty"),:qty_src=>eval("@#{tblchop}_qty_src"),
							:depends=>""}
		@bgantts["000"][:duration] = (@bgantts["000"][:endtime].to_date - @bgantts["000"][:starttime].to_date).to_i
		@bgantts["000"][:duration] = 1 if @bgantts["000"][:duration] < 1
	    ngantts = []
		r0 =  ActiveRecord::Base.connection.select_one("select * from  opeitms where id = #{@bgantts["000"][:opeitms_id]} ")
		if @loca_id_to != r0["locas_id"]
			cnt += 2
			@bgantts["001"] = {:seq=>"001",:mlevel=>1,:itm_id=>@itm_id,:loca_id=>@loca_id_to,
						:processseq=>(r0["processseq"]+1),:priority=>r0["priority"],:prdpurshp=>"dlv",
						:autocreate_ord=>r0["autocreate_ord"],:autocreate_inst=>r0["autocreate_inst"],
						:autoord_p=>r0["autoord_p"],:autoinst_p=>r0["autoinst_p"],:autocreate_ord=>r0["autocreate_ord"],:autocreate_inst=>r0["autocreate_inst"],
						:endtime=>eval("@#{tblchop}_duedate"),:id=>"001",
						:qty=>eval("@#{tblchop}_qty"),:qty_src=>eval("@#{tblchop}_qty_src"),
						:duration=>proc_get_duration_by_loca(eval("@#{tblchop}_loca_id_fm"),eval("@#{tblchop}_loca_id_to"),nil),
						:subtblid=>"opeitms_"+r0["id"].to_s,:opeitms_id=>r0["id"]}
			@bgantts["001"][:starttime] = proc_get_starttime(@bgantts["001"][:endtime],(@bgantts["001"][:duration]) ,"day",nil)			
			ngantts << {:seq=>"002",:mlevel=>2,:itm_id=>r0["itms_id"],:loca_id=>r0["locas_id"],
					:processseq=>r0["processseq"],:priority=>r0["priority"],:prdpurshp=>r0["prdpurshp"],
					:autocreate_ord=>r0["autocreate_ord"],:autocreate_inst=>r0["autocreate_inst"],:shuffle_flg=>r0["shuffle_flg"],
					:autoord_p=>r0["autoord_p"],:autoinst_p=>r0["autoinst_p"],:autocreate_ord=>r0["autocreate_ord"],:autocreate_inst=>r0["autocreate_inst"],
					:endtime=>proc_get_starttime(@bgantts["001"][:starttime],1,"day",nil),:id=>"002",
					:qty=>eval("@#{tblchop}_qty"),:qty_src=>eval("@#{tblchop}_qty_src"),
					:duration=>(r0["duration"]||=1),:subtblid=>"opeitms_"+r0["id"].to_s,:opeitms_id=>r0["id"]}
		else
            cnt += 1
			ngantts << {:seq=>"001",:mlevel=>1,:itm_id=>@itm_id,:loca_id=>@loca_id,
					:processseq=>(r0["processseq"]),:priority=>(r0["priority"]),:prdpurshp=>r0["prdpurshp"],
					:autocreate_ord=>r0["autocreate_ord"],:autocreate_inst=>r0["autocreate_inst"],:shuffle_flg=>r0["shuffle_flg"],
					:autoord_p=>r0["autoord_p"],:autoinst_p=>r0["autoinst_p"],:autocreate_ord=>r0["autocreate_ord"],:autocreate_inst=>r0["autocreate_inst"],
					:endtime=>eval("@#{tblchop}_duedate"),:id=>"001",
					:qty=>eval("@#{tblchop}_qty"),:qty_src=>eval("@#{tblchop}_qty_src"),
					:duration=>proc_get_duration_by_loca(eval("@#{tblchop}_loca_id_fm"),eval("@#{tblchop}_loca_id_to"),nil),
					:subtblid=>"opeitms_"+r0["id"].to_s,:opeitms_id=>r0["id"]}
		end
        until ngantts.size == 0
            cnt += 1
            ngantts = proc_get_tree_pare_itms_locas ngantts,"gantttrn"
             break if cnt >= 10000
        end	
        @bgantts["000"][:starttime] = if @min_time < Time.now then Time.now else @min_time end
        prv_resch_trn  ####再計算
        @bgantts["000"][:endtime] = @bgantts["001"][:endtime] 
        @bgantts["000"][:duration] = " #{(@bgantts["000"][:endtime]  - @bgantts["000"][:starttime] ).divmod(24*60*60)[0]}"
	    tmp_gantt = {}
		sio_classname = "trngantts_add_"
        @bgantts.sort.each  do|key,value|   ###依頼されたオーダ等をopeitms,nditmsを使用してgantttableに展開
			tmp_gantt ={:id=>proc_get_nextval("trngantts_seq"),:key=>key,
			:orgtblname=>tblchop+"s",:orgtblid=>eval("@#{tblchop}_id"),
			:mlevel=>value[:mlevel],
			:prjnos_id=>eval("@#{tblchop}_prjno_id"),
			:itms_id=>value[:itm_id],:locas_id=>value[:loca_id],
			:prdpurshp=>value[:prdpurshp],:processseq=>value[:processseq],:priority=>value[:priority],
			:duration=>value[:duration],:shuffle_flg=>value[:shuffle_flg],
			:starttime=>value[:starttime],:duedate=>value[:endtime],
            :parenum=>value[:parenum],:chilnum=>value[:chilnum],
			:consumtype=>value[:nditm_consumtype],
			:autoord_p=>value[:autoord_p],:autoinst_p=>value[:autoinst_p],
			:consumauto=>value[:nditm_consumauto],
			####    :itm_id=>value[:itm_id],:loca_id=>value[:loca_id],
			:qty=>value[:qty],
			:qty_src=>value[:qty_src],
			:depends=>value[:depends],
			:expiredate=>"2099/12/31".to_date,
			:created_at=>Time.now,:updated_at=>Time.now,:remark=>"auto_created_by perform_mkbttables ",
			:persons_id_upd=>System_person_id}
		    #Trngantt.create tmp_gantt
			proc_tbl_add_arel("trngantts",tmp_gantt) 
			proc_create_prdpurshp_alloc(tmp_gantt[:id],sio_classname)
		end
		proc_sch_chil_get(tblchop+"s",eval("@#{tblchop}_id"))
	end	
	def proc_get_duration_by_loca(loca_id_fm,loca_id_to,priority)
		1
	end
	def proc_alloctbls_update(sio_classname,alloc)
		case sio_classname
			when /_add/
				alloc[:id] = proc_get_nextval "alloctbls_seq"
				alloc[:updated_at] = Time.now
				alloc[:expiredate] = "2099/12/31".to_date
				alloc[:remark] = "vproc_add_from_gantt(trn_id = #{alloc[:srctblid]})"
				proc_tbl_add_arel("alloctbls",alloc)
			when /_edit|_delete/
				alloc[:updated_at] = Time.now
				alloc[:remark] = "vproc_edit_from_gantt(trn_id = #{alloc[:srctblname]})"
				strsql = "select id from alloctbls where srctblname = 'trngantts' and srctblid = #{alloc[:srctblid]} and 
							destblname = '(#{alloc[:destblname]}' and destblid = #{alloc[:destblid]} "
				alloc_id = ActiveRecord::Base.connection.select_value(strsql)
				proc_tbl_edit_arel("alloctbls", alloc," id = #{alloc_id} ")
		end
	end
	def proc_create_prdpurshp_alloc(trn_id,sio_classname)  ##
		str_gantt_sch = ActiveRecord::Base.connection.select_one(" select * from r_trngantts where id = #{trn_id} ")
		qty = str_gantt_sch["trngantt_qty"]
		str_gantt_sch[:sio_viewname] = "r_trngantts"
		str_gantt_sch[:sio_classname] = sio_classname
		str_gantt_sch[:sio_code] = "r_trngantts"
		proc_command_instance_variable(str_gantt_sch) ### trnganttsはproc_update_tableを使用してない。
		if str_gantt_sch["trngantt_key"] ==  "000"
			alloc= {}
			alloc[:qty] = @trngantt_qty
			alloc[:srctblname] = "trngantts"	
			alloc[:destblname] = @trngantt_orgtblname
			alloc[:srctblid] = @trngantt_id	
			alloc[:destblid] = @trngantt_orgtblid
			alloc[:allocfree] = "alloc"
			alloc[:updated_at] = Time.now
			alloc[:persons_id_upd] = System_person_id
			proc_alloctbls_update(sio_classname,alloc)
		else
			### prdxxx,purxxx,shpxxxが直接画面、excelstr_gantt_schから入力された時 alloctblsとの紐つけを作成する。
			strsql = %Q& select * from r_trngantts where trngantt_orgtblname = '#{@trngantt_orgtblname}' 
							and trngantt_orgtblid = #{@trngantt_orgtblid}
							and trngantt_key = '#{if @trngantt_key.size == 3 then sprintf("%03d", @trngantt_key.to_i - 1) else @trngantt_key[0..-4]  end}'&
			@pare_gantt = ActiveRecord::Base.connection.select_one(strsql).with_indifferent_access
			##@pare_gantt = ActiveRecord::Base.connection.select_one(strsql) 
			##@pare_gantt = pare_gantt.with_indifferent_access   
			__send__("proc_tblink_mksch_trngantts_#{str_gantt_sch["trngantt_prdpurshp"]}schs_self10",str_gantt_sch)
			##end
		end
	end
	def proc_prj_allocprjcodes prj_code
		prjcodes = []
		prjcodes << prj_code
		loopcode =[]
		loopcode << prj_code
		ii = 0
		until loopcode.size < 1
			strsql = "select self.code_chil from prjnos self,prjnos chil where self.code_chil = chil.code and self.code = '#{loopcode.shift}'"
			rec_prjs = ActiveRecord::Base.connection.select_values(strsql)
			rec_prjs.each do |prj|
				if prjcodes.index(prj).nil?
					prjcodes << prj
					loopcode << prj
				end
				ii += 1
				break if ii >10   
			end
		end
		prjcodes.join("','")
	end
	def proc_edit_from_trngantts tblchop   #
		strsql = %Q& select gantt.*,
					alloc.id alloc_id,alloc.qty alloc_qty,alloc.destblname alloc_destblname,alloc.destblid alloc_destblid,
					case when alloc.destblname like '%schs' then 1
					     when alloc.destblname like '%ords' then 2
						 when alloc.destblname like '%insts' then 3
						 when alloc.destblname like '%acts' then 4
						 when alloc.destblname like 'lotstk%' then 5 end tblsortkey
					from r_trngantts gantt inner join  alloctbls alloc
					on alloc.srctblname = 'trngantts' and gantt.id = alloc.srctblid
					where destblname = '#{tblchop}s'  and   destblid = #{eval("@#{tblchop}_id")} 
					and alloc.qty > 0 alloc.allocfree in('free','alloc')
					order by    trngantt_orgtblname, trngantt_orgtblid,trngantt_key,tblsortkey,alloc.destblid
				&
		### trngantt : alloctbl  = 1:n		
		gantt_allocs = ActiveRecord::Base.connection.select_all(strsql)
		pre_gantt_id = gantt_allocs[0]["trngantt_id"]
		save_gantt_id = 0
		save_alloc = {}
		save_alloc[:destblname] = ""
		newgantt = {}
		gantt_allocs.each do |gantt_alloc|
			if save_gantt_id != gantt_alloc["trngantt_id"]
				save_gantt_id = gantt_alloc["trngantt_id"]
				strsql = %Q&select sum(qty) from alloctbls where srctblname ='trngantts' and srctblid = #{gantt_alloc["trngantt_id"]} 
							and destblname not like '%schs' group by srctblname,srctblid&
				oth_alloc_qty = ActiveRecord::Base.connection.select_value(strsql)     ###ords,insts等に引きあたってといる数
				oth_alloc_qty ||= 0	
				if gantt_alloc["trngantt_key"].size == 3 
					key = sprintf("%03d", str_gantt_sch["trngantt_key"].to_i - 1)
				else
					key = gantt_alloc["trngantt_key"][0..-4]
				end
				if  gantt_alloc["trngantt_key"] != "000" ###2階層以降　
					strsql = %Q& select * from 	trngantts where orgtblname = '#{gantt_alloc["trngantt_orgtblname"]}' 
									and orgtblid = #{gantt_alloc["trngantt_orgtblid"]} 
									and key = '#{key}'&
					pare_gantt = ActiveRecord::Base.connection.select_one(strsql)
					newgantt[:qty] = pare_gantt["qty"].to_f * gantt_alloc["trngantt_chilnum"] / gantt_alloc["trngantt_parenum"]
					newgantt[:duedate] = proc_get_starttime(pare_gantt["starttime"],-1,"day",nil)  ### 構成を作成するときと合わすこと
				else  ###topレコード 
					newgantt[:qty] = eval("@#{tblchop}_qty")
					newgantt[:duedate] = eval("@#{tblchop}_duedate")
				end	
				sch_tblname,sch_id = proc_update_trangantts(gantt_alloc["trngantt_id"],newgantt,gantt_alloc)
				alloc ={}
				alloc[:id] = gantt_alloc["alloc_id"]
				alloc[:qty] =  	newgantt[:qty]   - oth_alloc_qty
				if gantt_alloc["alloc_destblname"] =~ /schs$/ ### trngants:xxxschs = 1:1   trngantts:xxxords等=1:n n=0,1,2,3・・・・ 
					if alloc[:qty] > 0
						proc_tbl_edit_arel("alloctbls",{:qty=>alloc[:qty]}," id = #{alloc[:id]} ")
						proc_decide_alloc_inout("alloc_edit_",alloc[:id])
					else
						proc_tbl_edit_arel("alloctbls",{:qty=>0}," id = #{alloc[:id]} ")
						proc_decide_alloc_inout("alloc_edit_",alloc[:id])
					end
				else 
					if alloc[:qty] >= 0     ###schsが残っているケース　実際には生しない。
						strsql = " select id from alloctbls where srctblname = 'trngantts' and srctblid = #{gantt_alloc["trngantt_id"]} 
																				and destblname ='#{sch_tblname}' and destblid = #{sch_id}"
						id = ActiveRecord::Base.connection.select_value(strsql)
						proc_tbl_edit_arel("alloctbls", {:qty=>alloc[:qty]}," id = #{id} ")
						proc_decide_alloc_inout("alloc_edit_",id) 
					else
						alloc[:qty] = proc_alloc_to_free(alloc,gantt_alloc) 
					end
				end
			else
				alloc[:qty] = proc_alloc_to_free(alloc,gantt_alloc) if alloc[:qty] <0
			end   ### prdpurshpの数量が減って前の状態のテーブルの引当て数を戻す。
		end
		return pre_gantt_id
	end	
	
	def proc_edit_trngantts_by_prdpurshp_qty tblchop,tblid   #  例えばpurordsのqtyが変更された時callされる。  数量増は認めない。
		strsql = %Q& select sum(qty) maxqty from  alloctbls alloc
					where destblname = '#{tblchop}s'  and   destblid = #{tblid} 
					and alloc.qty > 0 alloc.allocfree in('free','alloc')
					group by destblname,destblid
				&		
		max_qty = ActiveRecord::Base.connection.select_value(strsql)
		if  eval("@#{tblchop}_qty") < max_qty
			@err_msg = " 既に状態が変化しています。　現在の変更可能数量  #{max_qty}  "
			return
		end
		proc_edit_gantt_alloc_by_trn tblchop,tblid
		strsql = %Q& select gantt.*,
					alloc.id alloc_id,alloc.qty alloc_qty,alloc.destblname alloc_destblname,alloc.destblid alloc_destblid
					from r_trngantts gantt inner join  alloctbls alloc
					on alloc.srctblname = 'trngantts' and gantt.id = alloc.srctblid
					where destblname = '#{tblchop}s'  and   destblid = #{tblid} 
					and alloc.qty > 0  and alloc.allocfree in('free','alloc')
					order by    gantt.id desc
				&
		### trngantt : alloctbl  = 1:n		
		gantt_allocs = ActiveRecord::Base.connection.select_all(strsql)
		qty = ActiveRecord::Base.connection.select_value("select qty from #{tblchop}s where id = #{tblid}") 
		gantt_allocs.each do |gantt_alloc|   ###後から引き当てた物から引き離し
			if qty >= gantt_alloc["alloc_qty"]
				qty -= gantt_alloc["alloc_qty"]
			else
				save_qty = gantt_alloc["alloc_qty"] 
				gantt_alloc["alloc_qty"] = qty
				proc_tbl_edit_arel("alloctbls",{:qty=>gantt_alloc["alloc_qty"]}," id = #{c} ")
				proc_decide_alloc_inout("alloc_edit_",alloc[:id])
				proc_reverse_alloc(tblchop+"s",tblid,save_qty - qty)
				qty = 0
			end   ### prdpurshpの数量が減って前の状態のテーブルの引当て数を戻す。
		end
	end	
	
	def proc_edit_gantt_alloc_by_trn tblchop,tblid   ###deleteも含む	prdpurshpxxxsが変更された時	
		view =  ActiveRecord::Base.connection.select_one("select * from r_#{tblchop}s where id = #{tblid} ")
		strsql = %Q& select *  from r_trngantts gantt 
					where trngantt_orgtblname = '#{tblchop}s'  and   trngantt_orgtblid = #{tblid}
					order by    trngantt_orgtblname, trngantt_orgtblid,trngantt_key
					&
		### trngantt : alloctbl  = 1:n		
		gantts = ActiveRecord::Base.connection.select_all(strsql)
		newgantt = {}
		gantts.each do |gantt|
			old_qty = gantt["trngantt_qty"]
			if  gantt["trngantt_key"] == "000" 	  ###topレコード
				newgantt[:qty] =  if gantt["trngantt_qty"] >= view[tblchop+"_qty"] 
										view[tblchop+"_qty"] ## trngantt_qty 下位に展開に必要な数
									else
										gantt["trngantt_qty"]
									end
				newgantt[:qty_src] = view[tblchop+"_qty"]
				newgantt[:duedate] = view[tblchop+"_duedate"] 	
				newgantt[:starttime] = proc_get_starttime(newgantt[:duedate],view["opeitm_duration"],"day",nil)
				proc_tbl_edit_arel("trngantts",newgantt,"id = #{gantt["trngantt_id"]}") ##
				###topの引当て変更はcall元ででやっている。
			else  ###2階層以降　
				key = 	if gantt["trngantt_key"].size == 3 
							 sprintf("%03d", gantt["trngantt_key"].to_i - 1)
						else 
							gantt["trngantt_key"][0..-4]	
						end
				strsql = %Q& select * from 	trngantts where orgtblname = '#{gantt["trngantt_orgtblname"]}' 
							and orgtblid = #{gantt["trngantt_orgtblid"]} 
							and key = '#{key}'&
				pare_gantt = ActiveRecord::Base.connection.select_one(strsql)
				newgantt[:qty] = if key == "000" 
									pare_gantt["qty_src"].to_f * gantt["trngantt_chilnum"] / gantt["trngantt_parenum"]
								else 
									pare_gantt["qty"].to_f * gantt["trngantt_chilnum"] / gantt["trngantt_parenum"]
								end
				newgantt[:duedate] = proc_get_starttime(pare_gantt["starttime"],-1,"day",nil)  ### 構成を作成するときと合わすこと	
				newgantt[:starttime] = proc_get_starttime(newgantt[:duedate],gantt["duration"],"day",nil)
				proc_tbl_edit_arel("trngantts",newgantt,"id = #{gantt["trngantt_id"]}") ##
				strsql = %Q& select * from 	alloctbls  where srctblname = "trngantts" and srctblid = #{gantt["trngantt_id"]} and allocfree in('free','alloc')
									 order by id desc&  ###最初に引き当ては物はなるべく残す
				allocs = ActiveRecord::Base.connection.select_all(strsql)
				qty = newgantt[:qty]
				allocs.each do|alloc|
					if qty >= alloc["qty"]
						qty -= alloc["qty"]
					else
						proc_tbl_edit_arel("alloctbls",{:qty=>qty},"id = #{alloc["id"]}")
						proc_decide_alloc_inout("alloc_edit_",alloc["destblid"])
						proc_reverse_alloc(gantt["trngantt_destblname"],gantt["trngantt_destblid"],alloc["qty"] - qty)
						qty = 0
					end
				end
			end
		end
	end	
	def proc_update_gantt_schs(gantt,newgantt)
		proc_tbl_edit_arel("trngantts",newgantt,"id = #{gantt["trngantt_id"]}")
		trn = {:qty=>newgantt[:qty],:duedate=>newgantt[:duedate]}
		if gantt["trngantt_prdpurshp"] == "shp" then trn[:depdate] = newgantt[:starttime] else  trn[:starttime] = newgantt[:starttime] end
		proc_tbl_edit_arel("#{gantt["trngantt_prdpurshp"]}schs",trn,"tblid = #{gantt["trngantt_id"]}")
		if newgantt[:qty] < gantt["trngantt_qty"]
			strsql = %Q& select *,case when alloc.destblname like '%schs' then 5
									when alloc.destblname like '%ords' then 4
									when alloc.destblname like '%insts' then 3
									when alloc.destblname like '%acts' then 4
									when alloc.destblname like 'lotstk%' then 1
								end tblsortkey
								from 	alloctbls alloc where srctblname = 'trngantts' and srctblid = #{gantt["trngantt_id"]} and qty > 0
								order by 	tblsortkey &		
			allocs = ActiveRecord::Base.connection.select_all(strsql)
			allocs.each do |allloc|
				if newgantt[:qty] >= alloc["qty"]
					newgantt[:qty]  -= alloc["qty"]
				else
					alloc["qty"] = newgantt[:qty]
					proc_tbl_edit_arel("alloctbls",{:qty=>newgantt[:qty]},"id = #{alloc["id"]}")
					proc_decide_alloc_inout("alloc_edit_",alloc["id"])
					if alloc["destblname"] !~ /shps$/  ### add free
						strsql = %Q& select alloc.id alloc_id,alloc.qty alloc_qty from trngantts gantt,alloctbls alloc 
							where orgtblname = '#{alloc["destblname"]}' and orgtblid = #{alloc["_destblid"]} and key = '001'
							and srctblname = 'trngantts' and trngantts.id = srctblid 
							and destblname = '#{alloc["destblname"]}' and destblid = #{alloc["destblid"]}  &		
						gantt_alloc = ActiveRecord::Base.connection.select_one(strsql)
						proc_tbl_edit_arel("alloctbls",{:qty=>gantt_alloc["alloc_qty"] += (alloc["qty"] - newgantt[:qty]) },"id = #{gantt_alloc["id"]}")
						proc_decide_alloc_inout("alloc_edit_",gantt_alloc["id"])
					end
					newgantt[:qty] = 0
				end
			end
		else
			strsql = %Q& select * from 	alloctbls 
							where srctblname = 'trngantts' and srctblid = #{gantt["trngantt_id"]} 
							and destblname = '#{gantt["trngantt_prdpurshp"]}schs' &
			rec = ActiveRecord::Base.connection.select_one(strsql)  ###trngantts:alloc[destblname = xxxschs] = 1:1
			proc_tbl_edit_arel("alloctbls",{:qty=>rec["qty"] += (newgantt[:qty] - gantt["trngantt_qty"])},"id = #{rec["id"]}")
			proc_decide_alloc_inout("alloc_edit_",rec["id"])
		end
	end
	def proc_update_trangantts(id,newgantt,gantt_alloc)  ### id = trngantt_id
		strsql = %Q& select * from opeitms where itms_id = #{gantt_alloc["trngantt_itm_id"]} and locas_id = #{gantt_alloc["trngantt_loca_id"]} and processseq = #{gantt_alloc["trngantt_processseq"]} &
		opeitm = ActiveRecord::Base.connection.select_one(strsql)
		newgantt[:starttime] =  proc_get_starttime(newgantt[:duedate], (opeitm["duration"]||=1),"day",nil)  ###稼働日考慮に  ###starttimeと合わすこと。
		newgantt[:amt] = newgantt[:qty] * (gantt_alloc["trngantt_price"]||=0)
		proc_tbl_edit_arel("trngantts",newgantt," id = #{id} ")
		schtblname = gantt_alloc["trngantt_prdpurshp"] + "schs"
		strsql = "select id from #{schtblname} where tblname = 'trngantts' and tblid = #{gantt_alloc["trngantt_id"]} "
		sch_id = ActiveRecord::Base.connection.select_value(strsql)
		rec = {}
		if schtblname =~ /^shp/ then rec[:depdate] = newgantt[:starttime] else rec[:starttime] = newgantt[:starttime] end 
		rec[:duedate] = newgantt[:duedate]
		rec[:qty] = newgantt[:qty]
		rec[:amt] = newgantt[:amt]
		proc_tbl_edit_arel(schtblname, rec, " id = #{sch_id} ")
		return schtblname,sch_id
	end
	def proc_alloc_to_free(alloc,gantt_alloc)
		alloc[:qty] += gantt_alloc["alloc_qty"]
		new_qty = if alloc[:qty] >  0  then alloc[:qty] else 0 end 
		proc_tbl_edit_arel("alloctbls", {:qty=>new_qty}," id = #{alloc[:id]} ")  ###まだ残っている引当て
		proc_decide_alloc_inout("alloc_edit_",alloc[:id])
		strsql = %Q& select alloctbls.id id,alloctbls.qty qty from trngantts,alloctbls where trngantts.orgtblname = '#{gantt_alloc["alloc_destblname"]}' 
					and trngantts.orgtblid = #{gantt_alloc["alloc_destblid"]} and trngantts.key = '001'
					and alloctbls.srctblname = 'trngantts' and trngantts.id = alloctbls.srctblid 
					and alloctbls.destblname = '#{gantt_alloc["alloc_destblname"]}' and alloctbls.destblid = #{gantt_alloc["alloc_destblid"]}  &
		free_alloc = ActiveRecord::Base.connection.select_one(strsql)  ###親が数量減されfreeができた
		proc_tbl_edit_arel("alloctbl" ,{:qty=> free_alloc["qty"] + gantt_alloc["alloc_qty"] - new_qty  }," id = #{free_alloc["id"]}")
　　　　　　　return alloc[:qty]
	end
	def proc_create_or_replace_alloc_by_same_tbl trn,alloc   ###xxxords,xxxinsts,lotstkhistsそのものが数量変更された時 alloc 新しい引当て  
		case trn[:sio_classname]
			when /_add_/
				alloc[:id] = proc_get_nextval "alloctbls_seq" 
				alloc[:created_at] = Time.now
				alloc[:updated_at] = Time.now
				alloc[:persons_id_upd] = System_person_id
				alloc[:expiredate] = "2099/12/31".to_date				
				proc_tbl_add_arel  "alloctbls", alloc
				proc_decide_alloc_inout("alloc_add_",alloc[:id])
			when /_edit_|_delete_/
				strsql = %Q& select * from alloctbls where srctblname = 'trngantts' and destblname = '#{alloc[:destblname]}' 
							and destblid = #{alloc[:destblid]} order by id desc &
				c_allocs = ActiveRecord::Base.connection.select_all(strsql)
				if c_allocs.size == 0 ##logic error
				   logger.debug "strsql = #{strsql}"
				end
				qty = 0
				alloc[:qty] = 0 if @sio_classname =~ /_delete_/
				c_allocs.each do |c_alloc|
					if alloc[:qty] < qty + c_alloc["qty"]
						c_alloc["qty"] = if (alloc[:qty] - qty) > 0 then alloc[:qty] - qty  else 0 end
						proc_tbl_edit_arel("alloctbl" ,{:qty=>c_alloc["qty"]}," id = #{c_alloc["id"]}")
						proc_return_alloc c_alloc
					end
					qty += c_alloc["qty"]
				end 
				if alloc[:qty] > qty  ###数量増された時
					strsql = %Q& select alloctbls.id id,alloctbls.qty qty from trngantts,alloctbls where trngantts.orgtblname = '#{alloc[:destblname]}' 
									and trngantts.orgtblid = #{alloc[:destblid]} and trngantts.key = '001'
									and alloctbls.srctblname = 'trngantts' and trngantts.id = alloctbls.srctblid 
									and alloctbls.destblname = '#{alloc[:destblname]}' and alloctbls.destblid = #{alloc[:destblid]}  &
					free_alloc = ActiveRecord::Base.connection.select_one(strsql)
					proc_tbl_edit_arel("alloctbl" ,{:qty=>alloc[:qty] - qty + free_alloc["qty"]}," id = #{free_alloc["id"]}")
				end
		end
		return alloc[:id]
	end	 
	def proc_return_alloc c_alloc   ### prdpurshpの数量が減って前の状態のテーブルの引当て数を戻す。
		pre_destblname = case c_alloc["destblname"]
							when /ords/
								c_alloc["destblname"].sub("ords","schs")
							when /insts/
								c_alloc["destblname"].sub("insts","ords")
							when /acts/
								c_alloc["destblname"].sub("acts","insts")
							when /lotstkhists/
								c_alloc["destblname"].sub("acts","insts")
							else
								return  ###返品は前の状態に戻らない。
						end
		strsql = %Q&  select * from alloctbls where srctblname = '#{c_alloc["destblname"]}' and srctblid = #{c_alloc["destblid"]} and qty > 0
												and destblname = 'alloctbls'　
												and destblid in (select id from alloctbls where srctblname = 'trngantts' and srctblid = #{c_alloc["srctblid"]}
																							and destblname ='#{pre_destblname}')&
		rtn_alloc = ActiveRecord::Base.connection.select_one(strsql)
		if rtn_alloc.nil?
		   logger.debug " logic error"
           logger.debug " strsql = #{strsql}"		   
		end
		proc_tbl_edit_arel("alloctbl" ,{:qty=>rtn_alloc["qty"] - c_alloc["qty"]}," id = #{rtn_alloc["destblid"]} " )
		proc_tbl_edit_arel("alloctbl" ,{:qty=>c_alloc["qty"]}," id = #{rtn_alloc["id"]}" )
	end
	def proc_save_trn_of_opeitm trn  ##複数の品目の時、内容が変わってしまうのでsaveした。
		yield
		trn[:prdpurshp] ||= @opeitm_prdpurshp
		trn[:opeitms_id] = @opeitm_id
		trn[:stktaking_f] =@opeitm_stktaking_f
		trn[:packqty] = @opeitm_packqty
		trn[:itms_id] = @opeitm_itm_id
		trn[:processseq] = @opeitm_processseq
		trn[:locas_id] = @opeitm_loca_id
		trn[:locas_id_to] = eval("@#{trn[:tblname].chop}_loca_id_to")
		trn[:priority] = @opeitm_priority
		trn[:shuffle_flg] = @opeitm_shuffle_flg
		trn[:sio_classname] = @sio_classname
		trn[:id] = eval("@#{trn[:tblname].chop}_id")
		trn[:qty] = eval("@#{trn[:tblname].chop}_qty")
		trn[:prjnos_id] = eval("@#{trn[:tblname].chop}_prjno_id")
		trn[:starttime] = eval("@#{trn[:tblname].chop}_starttime")
		trn[:depdate] = eval("@#{trn[:tblname].chop}_depdate")
		trn[:duedate] = case  trn[:tblname]
							when "puracts" 
								@puract_rcptdate
							when "prdacts" 
								@prdact_cmpldate
							when "lotstkhists"
								nil
							else
								eval("@#{trn[:tblname].chop}_duedate") 
						end 
		return trn
	end
	def proc_get_shp_contents(trn)
		lot_qty = []
		strsql = " select aprev.destblname destblname ,aprev.destblid destblid,aprev.qty alloc_qty,shp.trngantt_processseq pare_processseq
					from alloctbls aprev,r_trngantts prev,alloctbls ashp, r_trngantts shp
					where aprev.srctblname = 'trngantts' and  aprev.srctblid = prev.trngantt_id
					and ashp.srctblname = 'trngantts' and  ashp.srctblid = shp.trngantt_id
					and prev.trngantt_orgtblname = shp.trngantt_orgtblname and prev.trngantt_orgtblid = shp.trngantt_orgtblid
					and shp.trngantt_key = substr(prev.trngantt_key,1,(length(prev.trngantt_key)-3)) and prev.itm_id = shp.itm_id
					and ashp.destblname = '#{trn[:tblname]}' and ashp.destblid = #{trn[:id]} and aprev.qty >0 "
		prevs =  ActiveRecord::Base.connection.select_all(strsql)
		prevs.each do |prev|
			strsql = %Q& select '#{prev["destblname"]}' tblname,
						#{if  prev["destblname"] == "lotstkhists" 
                   			"lotstkhist_lotno lotno,lotstkhist_packno packno,lotstkhist_loca_id locas_id,lotstkhist_itm_id itms_id " 
						else 
							"'dummy' lotno,'dummy' packno , opeitm_itm_id itms_id   "
						end },
						#{prev["alloc_qty"]} qty
						from  r_#{prev["destblname"]} where id = #{prev["destblid"]} &
			lotstk = ActiveRecord::Base.connection.select_one(strsql)
			lot_qty << [lotstk["lotno"],lotstk["qty"],1,lotstk["tblname"],lotstk["packno"],lotstk["itms_id"],prev["pare_processseq"]]
		end
		return lot_qty
	end
	def proc_mkord_err rec,mag
	end
	def proc_custord_chng_dlv_to_dlv(fmpps,fm_id)   ###custordsの引当ての変更
		case fmpps
			when /custschs/
			when /custords/  ###custordsの時　dlvはdlvinsts
				strsql = "select * from dlvschs where tblname = '#{fmpps}' and tblid = #{fm_id} "
				dlvsch = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from custords where id = #{fm_id} "
				custord = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from alloctbls where srctblname = 'custords' and srctblid = #{fm_id}  and destblname = 'dlvschs' and destblid = #{dlvsch["id"]} "
				alloctbl = ActiveRecord::Base.connection.select_one(strsql)
				if alloctbl
					strsql = "select sum(qty) qty from alloctbls where srctblname = 'custords' and srctblid = #{fm_id}  and destblname in('dlvords','dlvinsts','dlvacts')
																			and allocfree = 'dlv' group by srctblname,srctblid "
					done_qty = ActiveRecord::Base.connection.select_value(strsql)
					done_qty ||= 0
					alloctbl["qty"] = custord["qty"] - done_qty
					if alloctbl["qty"]  >= 0
						proc_tbl_edit_arel("alloctbls",alloctbl," id = #{alloctbl["id"]}")
					else
						logger.debug " logic error   オーダー済以下にはできない。"
						logger.debug " 画面でチェック　していること。"
						raise
					end
						proc_decide_alloc_inout("alloc_edit_",alloctbl["id"])
				else
					alloctbl = {}
						alloctbl[:qty] = custord["qty"]
						alloctbl[:srctblname] = "custords"	
						alloctbl[:destblname] = "dlvschs"
						alloctbl[:srctblid] = custord["id"]	
						alloctbl[:destblid] = dlvsch["id"]
						alloctbl[:allocfree] = "dlv"
						alloctbl[:id] = proc_get_nextval "alloctbls_seq" 
						alloctbl[:created_at] = Time.now
						alloctbl[:updated_at] = Time.now
						alloctbl[:persons_id_upd] = System_person_id
						alloctbl[:expiredate] = "2099/12/31".to_date
						alloctbl[:remark] = "proc_payord_chng_pay_to_pay"
						proc_tbl_add_arel("alloctbls",alloctbl)
						proc_decide_alloc_inout("alloc_add_",alloctbl[:id])
				end
			when /custinsts/   ##　custinstsの時　　　参考custords:custinsts= 1:n  
				strsql = "select * from dlvords where tblname = '#{fmpps}' and tblid = #{fm_id} "
				dlvord = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from custinsts where id = #{fm_id} "
				custinst = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from custords where custs_id = #{custinst["custs_id"]} and cno = '#{custinst["custinst_cno_ord"]}' "
				custord = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from alloctbls where srctblname = 'custords' and srctblid = #{custord["id"]}  and destblname = 'dlvords' and destblid = #{dlvord["id"]} "
				alloctbl = ActiveRecord::Base.connection.select_one(strsql)
				if alloctbl
					strsql = "select sum(qty) qty from dlvinsts where sno_ord = '#{dlvord["sno"]}'  group by sno_ord "
					dlvinst_qty = ActiveRecord::Base.connection.select_value(strsql)
					dlvinst_qty ||= 0
					alloctbl["qty"] = custinst["qty"] - dlvinst_qty   ###
					if alloctbl["qty"]  >= 0
						proc_tbl_edit_arel("alloctbls",alloctbl," id = #{alloctbl["id"]}")
						proc_decide_alloc_inout("alloc_edit_",alloctbl["id"])
					else
						logger.debug " logic error   出荷済数以下にはできない。"
						logger.debug " 画面でチェック　していること。"
						raise
					end
				else
					alloctbl = {}
					alloctbl[:qty] = custinst["qty"]
					alloctbl[:srctblname] = "custords"   ###srctblname は常に　custords	
					alloctbl[:destblname] = "dlvords"
					alloctbl[:srctblid] = custord["id"]	
					alloctbl[:destblid] = dlvord["id"]
					alloctbl[:allocfree] = "dlv"
					alloctbl[:id] = proc_get_nextval "alloctbls_seq" 
					alloctbl[:created_at] = Time.now
					alloctbl[:updated_at] = Time.now
					alloctbl[:persons_id_upd] = System_person_id
					alloctbl[:expiredate] = "2099/12/31".to_date
					alloctbl[:remark] = "proc_payord_chng_pay_to_pay"
					proc_tbl_add_arel("alloctbls",alloctbl)
					proc_decide_alloc_inout("alloc_add_",alloctbl[:id])
				end
					###cusords_dlvschs  のqty変更
					strsql = "select * from alloctbls where srctblname = 'custords' and srctblid = #{custord["id"]} and destblname = 'dlvschs' and allocfree = 'dlv' "
					alloctbl = ActiveRecord::Base.connection.select_one(strsql)
					alloctbl["qty"] = custord["qty"] - custinst["qty"]
					alloctbl["qty"] = 0 if alloctbl["qty"] < 0 
					proc_tbl_edit_arel("alloctbls",alloctbl," id = #{alloctbl["id"]}")
					proc_decide_alloc_inout("alloc_add_",alloc[:id])
			when /custacts/ 
				strsql = "select * from dlvacts where tblname = '#{fmpps}' and tblid = #{fm_id} "
				dlvact = ActiveRecord::Base.connection.select_one(strsql)  ###dlvinstsは現場(出荷場)からの回答
				strsql = "select * from custacts where id = #{fm_id} "
				custact = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from custords where custs_id = #{custact["custs_id"]} and cno_ord  = '#{custact["cno_ord"]}' "
				custord = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from alloctbls where srctblname = 'custords' and srctblid = #{custord["id"]}  and destblname = 'dlvacts' and destblid = #{dlvact["id"]} "
				alloctbl = ActiveRecord::Base.connection.select_one(strsql)
				if alloctbl 
					alloctbl["qty"] = dlvact_qty
					proc_tbl_edit_arel("alloctbls",alloctbl," id = #{alloctbl["id"]}")
					proc_decide_alloc_inout("alloc_edit_",alloctbl["id"])
				else
					alloctbl = {}
					alloctbl [:qty] = custacts["qty"]
					alloctbl[:srctblname] = "custords"   ###srctblname は常に　custords	
					alloctbl[:destblname] = "dlvords"
					alloctbl[:srctblid] = custord["id"]	
					alloctbl[:destblid] = dlvact["id"]
					alloctbl[:allocfree] = "dlv"
					alloctbl[:id] = proc_get_nextval "alloctbls_seq" 
					alloctbl[:created_at] = Time.now
					alloctbl[:updated_at] = Time.now
					alloctbl[:persons_id_upd] = System_person_id
					alloctbl[:expiredate] = "2099/12/31".to_date
					alloctbl[:remark] = "proc_payord_chng_pay_to_pay"
					proc_tbl_add_arel("alloctbls",alloctbl)
					proc_decide_alloc_inout("alloc_add_",alloctbl[:id])
				end
				###alloctbl dlvinsts  のqty変更 	
				strsql = "select * from dlvinsts where sno = '#{dlvacts["sno_inst"]}'  "
				dlvinst = ActiveRecord::Base.connection.select_one(strsql) 
				strsql = "select * from alloctbls where srctblname = 'custords' and srctblid = #{custord["id"]} and destblname = 'dlvsinsts'  and destblid = #{dlvinst["id"]} and allocfree = 'dlv' "
				alloctbl = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select sum(qty) qty from dlvacts where sno_inst = '#{dlvinst["sno"]}' "
				alldlvact_qty = ActiveRecord::Base.connection.select_value(strsql)  ###dlvinstsは現場(出荷場)からの回答
					alloctbl["qty"] = dlvinst["qty"] - alldlvact_qty
					alloctbl["qty"] = 0 if alloctbl["qty"] < 0 
					proc_tbl_edit_arel("alloctbls",alloctbl," id = #{alloctbl["id"]}")
					proc_decide_alloc_inout("alloc_add_",alloc[:id])
		end
	end
	def proc_custord_chng_bill_to_bill(fmpps,fm_id)   ###custordsの引当ての変更
		case fmpps
			when /custords/  ###
				strsql = "select * from billschs where tblname = '#{fmpps}' and tblid = #{fm_id} "
				billsch = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from custords where id = #{fm_id} "
				custord = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from alloctbls where srctblname = 'custords' and srctblid = #{fm_id}  and destblname = 'billschs' and destblid = #{billsch["id"]} "
				alloctbl = ActiveRecord::Base.connection.select_one(strsql)
				if alloctbl
					strsql = "select sum(amt) amt from alloctbls where srctblname = 'custords' and srctblid = #{fm_id}  and destblname in('billords','billinsts','billacts')
																			and allocfree = 'bill' group by srctblname,srctblid "
					done_amt = ActiveRecord::Base.connection.select_value(strsql)
					done_amt ||= 0
					alloctbl["amt"] = custord["amt"] - done_amt
					if alloctbl["amt"]  >= 0
						proc_tbl_edit_arel("alloctbls",alloctbl," id = #{alloctbl["id"]}")
					else
						logger.debug " logic error   請求金額済以下にはできない。"
						logger.debug " 画面でチェック　していること。"
						raise
					end
						proc_decide_alloc_inout("alloc_edit_",alloctbl["id"])
				else
					alloctbl = {}
						alloctbl[:amt] = custord["amt"]
						alloctbl[:srctblname] = "custords"	
						alloctbl[:destblname] = "billschs"
						alloctbl[:srctblid] = custord["id"]	
						alloctbl[:destblid] = billsch["id"]
						alloctbl[:allocfree] = "bill"
						alloctbl[:id] = proc_get_nextval "alloctbls_seq" 
						alloctbl[:created_at] = Time.now
						alloctbl[:updated_at] = Time.now
						alloctbl[:persons_id_upd] = System_person_id
						alloctbl[:expiredate] = "2099/12/31".to_date
						alloctbl[:remark] = "proc_payord_chng_pay_to_pay"
						proc_tbl_add_arel("alloctbls",alloctbl)
						###
						##strsql = "select * from alloctbls where srctblname = 'trngantts' and  destblname = 'custords' and destblid = #{custord["id"]} "
						##alloctbl = ActiveRecord::Base.connection.select_one(strsql)
						proc_decide_alloc_inout("alloc_add_",alloctbl[:id])
				end	
			when /custacts/   ##　custactsの時　　　参考custords:custinsts= 1:n  
				strsql = "select * from dlvords where tblname = '#{fmpps}' and tblid = #{fm_id} "
				billord = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from custacts where id = #{fm_id} "
				custact = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from custords where custs_id = #{custact["custs_id"]} and cno = '#{custact["custact_cno_ord"]}' "
				custord = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from alloctbls where srctblname = 'custords' and srctblid = #{custord["id"]}  and destblname = 'billords' and destblid = #{billord["id"]} "
				alloctbl = ActiveRecord::Base.connection.select_one(strsql)
				if alloctbl
					strsql = "select sum(amt) amt from billinsts where sno_ord = '#{billord["sno"]}'  group by sno_ord "
					billinst_amt = ActiveRecord::Base.connection.select_value(strsql)
					billinst_amt ||= 0
					alloctbl["amt"] = custact["amt"] - billinst_amt   ###
					if alloctbl["amt"]  >= 0
						proc_tbl_edit_arel("alloctbls",alloctbl," id = #{alloctbl["id"]}")
						proc_decide_alloc_inout("alloc_edit_",alloctbl["id"])
					else
						logger.debug " logic error   出荷済数以下にはできない。"
						logger.debug " 画面でチェック　していること。"
						raise
					end
				else
					alloctbl = {}
					alloctbl[:qty] = custact["amt"]
					alloctbl[:srctblname] = "custords"   ###srctblname は常に　custords	
					alloctbl[:destblname] = "billords"
					alloctbl[:srctblid] = custord["id"]	
					alloctbl[:destblid] = billord["id"]
					alloctbl[:allocfree] = "dlv"
					alloctbl[:id] = proc_get_nextval "alloctbls_seq" 
					alloctbl[:created_at] = Time.now
					alloctbl[:updated_at] = Time.now
					alloctbl[:persons_id_upd] = System_person_id
					alloctbl[:expiredate] = "2099/12/31".to_date
					alloctbl[:remark] = "proc_payord_chng_pay_to_pay"
					proc_tbl_add_arel("alloctbls",alloctbl)
					proc_decide_alloc_inout("alloc_add_",alloctbl[:id])
				end
					###cusords_billschs  のamt変更
					strsql = "select * from alloctbls where srctblname = 'custords' and srctblid = #{custord["id"]} and destblname = 'billschs' and allocfree = 'bill' "
					alloctbl = ActiveRecord::Base.connection.select_one(strsql)
					alloctbl["amt"] = custord["amt"] - custact["amt"]
					alloctbl["amt"] = 0 if alloctbl["amt"] < 0 
					proc_tbl_edit_arel("alloctbls",alloctbl," id = #{alloctbl["id"]}")
					proc_decide_alloc_inout("alloc_add_",alloc[:id])
			when /billacts/   ###billinsts 請求書発行
				strsql = "select * from billacts where id = #{fm_id} "
				billact = ActiveRecord::Base.connection.select_one(strsql)  ###dlvinstsは現場(出荷場)からの回答
				strsql = "select * from billschs  where sno = #{billact["sno_sch"]} "
				billsch = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from custords  where id = #{billsch["tblid"]} "
				custord = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from alloctbls where srctblname = 'custords' and srctblid = #{custord["id"]}  and destblname = 'billacts' and destblid = #{billact["id"]} "
				alloctbl = ActiveRecord::Base.connection.select_one(strsql)  ###billactsどこのステータスまで変更可能
				if alloctbl 
					alloctbl["amt"] = billact["amt"]
					proc_tbl_edit_arel("alloctbls",alloctbl," id = #{alloctbl["id"]}")
					proc_decide_alloc_inout("alloc_edit_",alloctbl["id"])
				else
					alloctbl = {}
					alloctbl [:amt] = billacts["amt"]
					alloctbl[:srctblname] = "custords"   ###srctblname は常に　custords	
					alloctbl[:destblname] = "billacts"
					alloctbl[:srctblid] = custord["id"]	
					alloctbl[:destblid] = billact["id"]
					alloctbl[:allocfree] = "bill"
					alloctbl[:id] = proc_get_nextval "alloctbls_seq" 
					alloctbl[:created_at] = Time.now
					alloctbl[:updated_at] = Time.now
					alloctbl[:persons_id_upd] = System_person_id
					alloctbl[:expiredate] = "2099/12/31".to_date
					alloctbl[:remark] = "proc_payord_chng_pay_to_pay"
					proc_tbl_add_arel("alloctbls",alloctbl)
					proc_decide_alloc_inout("alloc_add_",alloctbl[:id])
				end
				###alloctbl billinsts  のamt変更 	
				strsql = "select * from billinsts where sno = '#{billact["sno_inst"]}'  "
				billinst = ActiveRecord::Base.connection.select_one(strsql) 
				strsql = "select * from alloctbls where srctblname = 'custords' and srctblid = #{custord["id"]} and destblname = 'billinsts'  and destblid = #{billinst["id"]} and allocfree = 'dlv' "
				alloctbl = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select sum(amt) amt from billacts where sno_inst = '#{billact["sno_inst"]}' "
				allbillact_amt = ActiveRecord::Base.connection.select_value(strsql)  ###
				alloctbl["amt"] = billinst["amt"] - allbillact_amt   ###先に入金された時は、未対応
				alloctbl["amt"] = 0 if alloctbl["amt"] < 0 
				proc_tbl_edit_arel("alloctbls",alloctbl," id = #{alloctbl["id"]}")
				proc_decide_alloc_inout("alloc_add_",alloc[:id])
		end
	end
	def proc_payord_chng_pay_to_pay(fmpps,fm_id)   ###custordsの引当ての変更
		case fmpps
			when /payords/  ###
				strsql = "select * from payschs where tblname = '#{fmpps}' and tblid = #{fm_id} "
				paysch = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from payords where id = #{fm_id} "
				purord = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from alloctbls where srctblname = 'payords' and srctblid = #{fm_id}  and destblname = 'payschs' and destblid = #{paysch["id"]} "
				alloctbl = ActiveRecord::Base.connection.select_one(strsql)
				if alloctbl
					strsql = "select sum(amt) amt from alloctbls where srctblname = 'payords' and srctblid = #{fm_id}  and destblname in('payords','payinsts','payacts')
																			and allocfree = 'bill' group by srctblname,srctblid "
					done_amt = ActiveRecord::Base.connection.select_value(strsql)
					done_amt ||= 0
					alloctbl["amt"] = purord["amt"] - done_amt
					if alloctbl["amt"]  >= 0
						proc_tbl_edit_arel("alloctbls",alloctbl," id = #{alloctbl["id"]}")
					else
						logger.debug " logic error   請求金額済以下にはできない。"
						logger.debug " 画面でチェック　していること。"
						raise
					end
					proc_decide_alloc_inout("alloc_edit_",alloctbl["id"])
				else
					alloctbl = {}
					alloctbl[:qty] = custord["amt"]
					alloctbl[:srctblname] = "purords"	
					alloctbl[:destblname] = "payschs"
					alloctbl[:srctblid] = custord["id"]	
					alloctbl[:destblid] = billsch["id"]
					alloctbl[:allocfree] = "pay"
					alloctbl[:id] = proc_get_nextval "alloctbls_seq" 
					alloctbl[:created_at] = Time.now
					alloctbl[:updated_at] = Time.now
					alloctbl[:persons_id_upd] = System_person_id
					alloctbl[:expiredate] = "2099/12/31".to_date
					alloctbl[:remark] = "proc_payord_chng_pay_to_pay"
					proc_tbl_add_arel("alloctbls",alloctbl)
					proc_decide_alloc_inout("alloc_add_",alloctbl[:id])
				end	
			when /puracts/   ##　puracts受入の時　　  
				strsql = "select * from payords where tblname = '#{fmpps}' and tblid = #{fm_id} "
				payord = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from puracts where id = #{fm_id} "
				puract = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from purords where sno = '#{puract["puract_sno_ord"]}' "
				purord = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from alloctbls where srctblname = 'purords' and srctblid = #{purord["id"]}  and destblname = 'payords' and destblid = #{payord["id"]} "
				alloctbl = ActiveRecord::Base.connection.select_one(strsql)
				if alloctbl
					strsql = "select sum(amt) amt from billinsts where sno_ord = '#{billord["sno"]}'  group by sno_ord "
					payinst_amt = ActiveRecord::Base.connection.select_value(strsql)
					payinst_amt ||= 0
					alloctbl["amt"] = payord["amt"] - payinst_amt   ###
					if alloctbl["amt"]  >= 0
						proc_tbl_edit_arel("alloctbls",alloctbl," id = #{alloctbl["id"]}")
						proc_decide_alloc_inout("alloc_edit_",alloctbl["id"])
					else
						logger.debug " logic err 支払通知額以下にはできない。"
						logger.debug " 画面でチェック　していること。"
						raise
					end
				else
					alloctbl = {}
					alloctbl[:amt] = payact["amt"]
					alloctbl[:srctblname] = "purords"   ###srctblname は常に　custords	
					alloctbl[:destblname] = "payords"
					alloctbl[:srctblid] = purord["id"]	
					alloctbl[:destblid] = payord["id"]
					alloctbl[:allocfree] = "pur"
					alloctbl[:id] = proc_get_nextval "alloctbls_seq" 
					alloctbl[:created_at] = Time.now
					alloctbl[:updated_at] = Time.now
					alloctbl[:persons_id_upd] = System_person_id
					alloctbl[:expiredate] = "2099/12/31".to_date
					alloctbl[:remark] = "proc_payord_chng_pay_to_pay"
					proc_tbl_add_arel("alloctbls",alloctbl)
					proc_decide_alloc_inout("alloc_add_",alloctbl[:id])
				end
					###purords_payschs  のamt変更
					strsql = "select * from alloctbls where srctblname = 'purords' and srctblid = #{purord["id"]} and destblname = 'payschs' and allocfree = 'pay' "
					alloctbl = ActiveRecord::Base.connection.select_one(strsql)
					alloctbl["amt"] = purord["amt"] - puract["amt"]
					alloctbl["amt"] = 0 if alloctbl["amt"] < 0 
					proc_tbl_edit_arel("alloctbls",alloctbl," id = #{alloctbl["id"]}")
					proc_decide_alloc_inout("alloc_add_",alloc[:id])
			when /payacts/   ###payinsts 支払通知書発行
				strsql = "select * from payacts where id = #{fm_id} "
				payact = ActiveRecord::Base.connection.select_one(strsql)  ##
				strsql = "select * from payschs  where sno = #{billact["sno_sch"]} "
				paysch = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from purords  where id = #{paysch["tblid"]} "
				custord = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select * from alloctbls where srctblname = 'purords' and srctblid = #{purord["id"]}  and destblname = 'payacts' and destblid = #{payact["id"]} "
				alloctbl = ActiveRecord::Base.connection.select_one(strsql)  ###billactsどこのステータスまで変更可能
				if alloctbl 
					alloctbl["amt"] = payact["amt"]
					proc_tbl_edit_arel("alloctbls",alloctbl," id = #{alloctbl["id"]}")
					proc_decide_alloc_inout("alloc_edit_",alloctbl["id"])
				else
					alloctbl = {}
					alloctbl [:amt] = payacts["amt"]
					alloctbl[:srctblname] = "purords"   ###srctblname は常に　custords	
					alloctbl[:destblname] = "payacts"
					alloctbl[:srctblid] = purord["id"]	
					alloctbl[:destblid] = payact["id"]
					alloctbl[:allocfree] = "pay"
					alloctbl[:id] = proc_get_nextval "alloctbls_seq" 
					alloctbl[:created_at] = Time.now
					alloctbl[:updated_at] = Time.now
					alloctbl[:persons_id_upd] = System_person_id
					alloctbl[:expiredate] = "2099/12/31".to_date
					alloctbl[:remark] = "proc_payord_chng_pay_to_pay"
					proc_tbl_add_arel("alloctbls",alloctbl)
					proc_decide_alloc_inout("alloc_add_",alloctbl[:id])
				end
				###alloctbl payinsts  のamt変更 	
				strsql = "select * from payinsts where sno = '#{payact["sno_inst"]}'  "
				payinst = ActiveRecord::Base.connection.select_one(strsql) 
				strsql = "select * from alloctbls where srctblname = 'purords' and srctblid = #{purord["id"]} and destblname = 'payinsts'  and destblid = #{payinst["id"]} and allocfree = 'pay' "
				alloctbl = ActiveRecord::Base.connection.select_one(strsql)
				strsql = "select sum(amt) amt from payacts where sno_inst = '#{billact["sno_inst"]}' "
				allpayact_amt = ActiveRecord::Base.connection.select_value(strsql)  ###
				alloctbl["amt"] = payinst["amt"] - allpayact_amt   ###先に入金された時は、未対応
				alloctbl["amt"] = 0 if alloctbl["amt"] < 0 
				proc_tbl_edit_arel("alloctbls",alloctbl," id = #{alloctbl["id"]}")
				proc_decide_alloc_inout("alloc_add_",alloc[:id])
		end
	end	
	def proc_blk_constrains tbl,colm,type,constraint_name
		strsql = ""
		ActiveRecord::Base.uncached() do
			case Db_adapter 
				when /post/
					##post
				when /oracle/
					strsql = "select  c.table_name, c.constraint_name, c.constraint_type, cc.position, cc.column_name from user_constraints c, user_cons_columns cc
								where c.table_name      = cc.table_name  and c.constraint_name = cc.constraint_name "
					strsql << if tbl then " and c.table_name = '#{tbl.upcase}' " else "" end 
					strsql << if colm 
								if colm =~ /%$|^%/ then " and  cc.column_name like  '#{colm.upcase}' " else " and  cc.column_name = '#{colm.upcase}'" end
								else
									""
								end
					strsql << if type then " and c.constraint_type = '#{type.upcase}' " else "" end 
					strsql << if constraint_name then " and c.constraint_name = '#{constraint_name.upcase}' " else "" end
					strsql << " order by c.constraint_name ,cc.position "
			end
		end	
		ActiveRecord::Base.connection.select_all(strsql)
	end
	def proc_blk_get_constrains tbl,type
		strsql = ""
		ActiveRecord::Base.uncached() do
			case Db_adapter 
				when /post/
					strsql = "SELECT  constraint_name FROM information_schema.table_constraints WHERE table_name = '#{tbl.downcase}' 
										and constraint_type = #{case type.upcase when /^U/ then 'UNIQUE' when /^F/ then 'FOREIGN KEY' else '' end } "
				when /oracle/
					strsql = "select constraint_name 	from all_constraints 	where  table_name = '#{tbl.upcase}'  and constraint_type = '#{type[0].upcase}'"
			end
		end	
		ActiveRecord::Base.connection.select_values(strsql)
	end
	def proc_sequences_exist seq_name
		case Db_adapter 
			when /oracle/
				sql = "SELECT 1	FROM user_sequences WHERE sequence_name = '#{seq_name.upcase}' "
			when /post/
				sql = "SELECT 1 FROM pg_class where relname = '#{seq_name.downcase}'"
		end
		ActiveRecord::Base.connection.select_one(sql)
	end
	class Float
		def floor2(exp = 0)
			multiplier = 10 ** exp
			((self * multiplier).floor).to_f/multiplier.to_f
		end
		def ceil2(exp = 0)
			multiplier = 10 ** exp
			((self * multiplier).ceil).to_f/multiplier.to_f
		end
	end
end   ##module Ror_blk