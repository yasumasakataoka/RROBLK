# -*- coding: utf-8 -*-
# RorBlk
# 2099/12/31を修正する時は　2100/01/01の修正も
module Ror_blkctl
	LocaTransport = {}  ###仕様方法を間違っている　修正要
	def initialize
	end
	def system_person_id
		if @system_person_id
			@system_person_id
		else
			@system_person_id = ActiveRecord::Base.connection.select_value("select id from persons where code = '0'")
			if @system_person_id
				@system_person_id
			else
				logger.debug"  error missuing person_id = 0 "
				raise
			end
		end
	end
    ##def sub_blkget_grpcode     ## fieldsの名前
    ##    return @pare_class if  @pare_class == "batch"
    ##    usrgrp_code =  ActiveRecord::Base.connection.select_value("select usrgrp_code from r_persons where person_email = '#{current_user[:email]}'")
        ###p " current_user[:email] #{current_user[:email]}"
    ##    if usrgrp_code.nil?
    ##       p "add person to his or her email "
	##	   raise   ### 別画面に移動する　後で対応
    ##        else
    ##        usrgrp_code
    ##    end
    ##end
	def grp_code
        return @pare_class if  @pare_class == "batch"
		if @usrgrp_code
			return @usrgrp_code
		else
			@usrgrp_code =  ActiveRecord::Base.connection.select_value("select usrgrp_code from r_persons where person_email = '#{current_user[:email]}'")
			if @usrgrp_code
				return @usrgrp_code
				p "add person to his or her email "
				raise   ### 別画面に移動する　後で対応
			end
		end
	end
	def proc_blkgetpobj code,ptype
		##sub_blkgetpobj code,ptype
	##end
    ##def sub_blkgetpobj code,ptype    ###
        fstrsqly = ""
        ##grp_code =  sub_blkget_grpcode
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
		end  ##
        return orgname
    end  ## def getpobj
    def sub_blkget_code_fm_name name,ptype    ###
         ##grp_code =  sub_blkget_grpcode
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
	def proc_tblname_field_delm(param_key)  ###import excelでも呼ばれる
		if param_key =~ /^mk/
			mktblname,tblnamechop,field,delm = param_key.split("_",4)
			if mktblname =~ /mkord|mktrngantts/
				return tblnamechop,field,delm
			else
				return nil,nil,nil
			end
		else
			tblnamechop,field,delm = param_key.split("_",3)
		end
	end
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
									@src_tbl[:qty_stk] = 0 if @src_tbl[:qty_stk]
									@src_tbl[:amt] = 0 if @src_tbl[:amt]
									@src_tbl[:tax] = 0 if @src_tbl[:tax]      ##変更分のみ更新
									proc_tbl_edit_arel(tblname,@src_tbl," id = #{@src_tbl[:id]}")
								else
									proc_tbl_delete_arel(tblname," id = #{@src_tbl[:id]}")
								end
							end ### blkukyの時は　constrainも削除
						end
				else
					logger.debug "command_r = '#{command_r}'"
					raise
				end   ## case iud
				if command_r[:sio_classname] =~ /_add_|_edit_|_delete_/ and tblname !~ /tblink/  ## rec = command_c = sio_xxxxx
					proc_command_after_instance_variable(command_r)
					proc_tblinks(command_r) do
						"after"
					end
				end
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
					##crt_def_all if tblname =~ /rubycodings|tblink/
            ##crt_def_tb if  tblname == "blktbs"
      ensure
            sub_insert_sio_r(command_r) if @pare_class != "batch"    ## 結果のsio書き込み
      end ##begin
      raise if @sio_result_f ==   "9"
  end
	##def vproc_optiontabl tblname
	##	if tblname =~ /rplies$|mksch|mkords|results$/ then true else false end  ###mkinsts,mkactsは使用してない　12/9
	##end
	def proc_delayjob_or_optiontbl tblname,id
		###ActionController::Base::DbCud.new
      case tblname
			#when   /mkschs/   ###mkinsts,mkactsは使用してない　12/9
			#			if @tbl_mkschs
			#			else
			#				 @tbl_mkschs = []
			#			end
			#			@tbl_mkschs << [tblname,id]
			#							 		####when   /schs$|ords$|insts$|acts$/
			when   /mkords/   ###mkinsts,mkactsは使用してない　12/9
						if @tbl_mkords
						else
						 	@tbl_mkords = []
						end
						@tbl_mkords << [tblname,id]
 			when   /mkbttables/   ###mkinsts,mkactsは使用してない　12/9
 						if @tbl_mktbls
 						else
 						 	@tbl_mktbls = []
 						end
 						@tbl_mktbls << [tblname,id]
 			when    /rplies$/  ###mkinsts,mkactsは使用してない　12/9
 						if @tbl_rpls
 						else
 						 	@tbl_rpls = []
 						end
 						@tbl_rpls << [tblname,id]
 			when    /results$/  ###mkinsts,mkactsは使用してない　12/9
 						if @tbl_results
 						else
 						 	@tbl_results = []
 						end
 						@tbl_results << [tblname,id]
      end
	end
	def vproc_tbl_mk_sub tbls
		begin
			 tbls.each do |tbl|
				##rec = ActiveRecord::Base.connection.select_one("select * from #{tbl[0]} where result_f = '0'  and id = #{tbl[1]}  order by id")   ##0 未処理
				rec = {}
				rec["result_f"] = "5"
				##proc_tbl_edit_arel tbl[0],rec," id = ( #{rec["id"]} )"
				proc_tbl_edit_arel tbl[0],rec," id = ( #{tbl[1]} )"
			end
			 	yield
				ActiveRecord::Base.connection.commit_db_transaction()
		rescue
			ActiveRecord::Base.connection.rollback_db_transaction()
			logger.debug"error class #{self}   #{Time.now}$@: #{$@} "
			logger.debug"error class LINE #{__LINE__}   $!: #{$!} "
			logger.debug"error class LINE #{__LINE__}   perform error: #{ tbls} "
		end
	end
	def vproc_tbl_mk
			##case tblname
			##when "mkschs"  ##not spport
			##if @tbl_mkschs
			##	vproc_tbl_mk_sub  @tbl_mkschs
			##end
			###when "mkbttables"
			if  @tbl_mktbls
				vproc_tbl_mk_sub  @tbl_mktbls do
					dbmks = DbCud.new
					dbmks.perform_mkbttables @tbl_mktbls
				end
			end
			## when "mkords"
			if @tbl_mkords
				vproc_tbl_mk_sub @tbl_mkords do
					dbmks = DbCud.new
					dbmks.perform_mkords @tbl_mkords
				end
			end
 			###when   /rplies$/
			if @tbl_rpls
				vproc_tbl_mk_sub  @tbl_rpls do
					dbmks = DbCud.new
				  dbmks.perform_setreplies  @tbl_rpls
				end
			end
 			##when   /results$/
			if @tbl_results
				vproc_tbl_mk_sub @tbl_results do
					dbmks = DbCud.new
				  dbmks.perform_setresults @tbl_results
				end
			end
	end
	def proc_insert_sio_c command_c   ###要求  無限ループにならないこと
        ###command_c = char_to_number_data(command_c) ###画面イメージからデータtypeへ   入口に変更すること
        command_c[:sio_term_id] =  request.remote_ip  if respond_to?("request.remote_ip")  ## batch処理ではrequestはnil　　？？
        command_c[:sio_command_response] = "C"
        command_c[:sio_add_time] = Time.now
		begin
			command_c = vproc_command_c_dflt_set_fm_rubycoding(command_c) if command_c[:sio_classname] =~ /_add_|_edit_|_delete_/
			if command_c[:sio_viewname] =~ /_inouts$/ and  command_c[:sio_classname] =~ /_add_|_edit_|_delete_/
			else
				command_c[:sio_id] =  proc_get_nextval("SIO_#{command_c[:sio_viewname]}_SEQ")
				proc_tbl_add_arel("sio_#{command_c[:sio_viewname]}",command_c)
			end
		rescue
			ActiveRecord::Base.connection.rollback_db_transaction()
			logger.debug " proc_insert_sio_c err  ...command_c = #{command_c}"
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
        userproc[:persons_id_upd] = system_person_id
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
        parescreen[:persons_id_upd] = system_person_id
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
				## tmp_sql << (tmp_str["screen_strselect"]||="")
				tmp_sql << (" Where "+  tmp_str["screen_strwhere"] ) if tmp_str["screen_strwhere"] and  command_c[:sio_search]  == "false"
				tmp_sql << (tmp_str["screen_strgrouporder"]||="")
				tmp_sql << " ) a "  if tmp_str["screen_strselect"]
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
	        tmpwhere << " person_code_upd = '#{@sio_user_code}'"
			##tmpwhere <<  ActiveRecord::Base.connection.select_value("select code from persons where email = '#{current_user[:email]}'")
			##tmpwhere << "'"
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
		### allf = @show_data[:allfields]
		###allt = @show_data[:alltypes]
        rcd.each do |j|
            tmp_data = {}
            @show_data[:allfields].each do |k|
				if j[k]
					case @show_data[:alltypes][k]
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
						duedate - duration * 24 * 60* 60
				end
		end
	end

	def proc_get_transport fm_id,to_id   ### transport
		if LocaTransport[fm_id.to_s + to_id.to_s]
			return LocaTransport[fm_id.to_s + to_id.to_s]
		else
			strsql = "select transport_id,transport_code,transport_name,localt_duration duration from r_localts
						where localt_loca_id_fm = #{fm_id} and localt_loca_id_to = #{to_id} order by localt_priority"
			LocaTransport[fm_id.to_s + to_id.to_s] = ActiveRecord::Base.connection.select_one(strsql)
			if LocaTransport[fm_id.to_s + to_id.to_s]
				return LocaTransport[fm_id.to_s + to_id.to_s]
			else
				strsql = "select transport_id,transport_code,transport_name,localt_duration duration from r_localts
						where localt_loca_id_fm = #{fm_id}  order by localt_priority"
				LocaTransport[fm_id.to_s + to_id.to_s] = ActiveRecord::Base.connection.select_one(strsql)
				if 	LocaTransport[fm_id.to_s + to_id.to_s]
					return LocaTransport[fm_id.to_s + to_id.to_s]
				else
					strsql = "select transport_id,transport_code,transport_name,1 duration from r_transports
							where transport_code = 'dummy' "
					LocaTransport[fm_id.to_s + to_id.to_s] = ActiveRecord::Base.connection.select_one(strsql)
					if LocaTransport[fm_id.to_s + to_id.to_s]
						return LocaTransport[fm_id.to_s + to_id.to_s]
					else
						logger.debug " line #{__LINE__} fm_id:#{fm_id}, to_id:#{to_id} "
						raise
					end
				end
			end
		end
	end
    def proc_get_cons_chil(key)  ###工程の始まり=前工程の終わり
		strsql = "select nditm_itm_id_nditm itms_id, nditm_loca_id_nditm locas_id,nditm_processseq_nditm processseq ,
		                nditm_consumtype consumtype,nditm_consumauto consumauto,nditm_minqty minqty,nditm_consumunitqty consumunitqty
					from r_nditms nd
		            where  nditm_Expiredate > current_date
					and opeitm_itm_id = #{key["itms_id"]} and opeitm_loca_id = #{key["locas_id"]}  and opeitm_processseq = #{key["processseq"]} order by itm_code "
		chils = ActiveRecord::Base.connection.select_all(strsql)
		strsql = "select chil.itms_id itms_id, chil.locas_id locas_id,chil.processseq processseq ,
		                chil.consumtype consumtype,chil.consumauto consumauto,chil.minqty minqty,chil.consumunitqty consumunitqty
					from opeitms pare,opeitms chil
		            where  chil.Expiredate > current_date and pare.expiredate > current_date
					and pare.itms_id = #{key["itms_id"]} and  pare.processseq = #{key["processseq"]}
					and pare.itms_id = chil.itms_id and pare.processseq > chil.processseq and (pare.priority = chil.priority or chil.priority = 999)
					order by chil.processseq desc"
		chil_opeitm = ActiveRecord::Base.connection.select_one(strsql)
		chils << chil_opeitm if chil_opeitm
		return chils
    end
	def proc_get_trngantt_cons_chil_inout_fm_alloc_id alloc_id   ### trngantt作成時　の消費の予定
		alloc = ActiveRecord::Base.connection.select_one("select * from alloctbls where id = #{alloc_id}")
		if alloc["srctblname"] == "trngantts"
			strsql = "select calloc.qty calloc_qty,calloc.qty_stk calloc_qty_stk,calloc.id calloc_id,calloc.destblname calloc_destblname,calloc.destblid calloc_destblid,
						palloc.id palloc_id,palloc.destblname palloc_destblname,palloc.destblid palloc_destblid,
						cgantt.trngantt_qty cgantt_qty,cgantt.trngantt_qty_stk cgantt_qty_stk,cgantt.trngantt_id cgantt_id,
						cgantt.trngantt_itm_id cgantt_itm_id,cgantt.trngantt_processseq cgantt_processseq,cgantt.trngantt_consumtype cgantt_consumtype,
						pgantt.trngantt_starttime pgantt_starttime,pgantt.trngantt_loca_id pgantt_loca_id,pgantt.trngantt_itm_id pgantt_itm_id
						from r_trngantts cgantt,alloctbls calloc,alloctbls palloc ,r_trngantts pgantt
						where pgantt.trngantt_id = #{alloc["srctblid"]}
						and pgantt.trngantt_orgtblname = cgantt.trngantt_orgtblname and pgantt.trngantt_orgtblid = cgantt.trngantt_orgtblid
						and pgantt.trngantt_key = case length(cgantt.trngantt_key)
						                             when 3 then
														to_char(cgantt.trngantt_key - 1,'000')
													 else
													     substr(cgantt.trngantt_key,1,length(cgantt.trngantt_key) -3 )
													 end
						and palloc.srctblname = 'trngantts' and palloc.srctblid = pgantt.trngantt_id and (palloc.qty > 0 or palloc.qty_stk >0 )
						and calloc.srctblname = 'trngantts' and calloc.srctblid = cgantt.trngantt_id and (calloc.qty > 0 or calloc.qty_stk > 0)
						and calloc.allocfree = 'alloc' and 	palloc.allocfree = 'alloc' 	"
			children = ActiveRecord::Base.connection.select_all(strsql)
			children.each do |chil|
				proc_command_instance_variable(ActiveRecord::Base.connection.select_one(" select * from r_#{chil["calloc_destblname"]} where id = #{chil["calloc_destblid"]}"))
				case chil["cgantt_consumtype"]
				when /con|ORD|ACT|BYP/
					inout = {}
					###inout[:inout_qty_alloc] = if chil["cgantt_consumtype"] == "BYP" then  chil["calloc_qty"] + chil["calloc_qty_stk"] else (chil["calloc_qty"] + chil["calloc_qty_stk"]) * -1 end
					##inout = ActiveRecord::Base.connection.select_one("select * from inouts where alloctbls_id_inout = #{chil["alloc_id"]} and inoutflg = '#{chil["consumtype"]}' ")
					###inout[:id] = proc_decision_id_by_key("inouts"," alloctbls_id_inout = #{alloc_id} and itms_id = #{chil["cgantt_itm_id"]} and inoutflg = 'con' ")["id"]
					##inout[:id] = proc_decision_id_by_key("inouts",%Q% alloctbls_id_inout = #{chil["calloc_id"]} and inoutflg = 'con' %)["id"]
					inout[:id] = proc_get_nextval("inouts_seq")
					@sio_classname = "_add_proc_get_trngantt_cons_chil_inout_fm_alloc_id"
					##if @inout_classname =~ /_edit_/
						## 変更の時はproc_update_base_allocで処理をしている。  lotno packno毎に作成
					##else
						###proc_tbl_delete_arel("inouts",%Q& trngantts_id_inout = #{chil["trngantt_id"]} and locas_id = #{chil["pare_loca_id"]}   and inoutflg = '#{inoutflg}'
						##end
						### lotno packno毎に作成
						inout[:inout_alloctbl_id_inout] = chil["calloc_id"]
						###logger.debug "trace  '#{chil["calloc_id"]} "
						inout[:inout_trngantt_id_inout] = chil["cgantt_id"]
						inout[:inout_itm_id_pare] = chil["pgantt_itm_id"]
						inout[:inout_inoutflg] = chil["cgantt_consumtype"]
						inout[:inout_qty] = chil["calloc_qty"] * -1
						inout[:inout_qty_stk] = chil["calloc_qty_stk"] * -1
						pare = ActiveRecord::Base.connection.select_one(" select * from r_#{alloc["destblname"]} where id = #{alloc["destblid"]}")
						inout[:inout_loca_id] = pare["opeitm_loca_id"]
						inout[:inout_starttime] = pare["#{alloc["destblname"].chop}_starttime"]   ###在庫とあっていること　原価の計算とも合うこと
						##inout[:inout_processseq] = if  chil["pgantt_itm_id"] == chil["cgantt_itm_id"] then pare["#{alloc["destblname"].chop}_processseq"] else chil["cgantt_processseq"] end
						__send__("proc_fld_con_#{alloc["destblname"]}_inouts_self10") do   ###alloctbls 自身のinout　　 con子部品の消費
							inout
						end
					##end
				when "DEV"  ###装置が空いた
				when "MET"  ### 完了したとき返却
				end
			end
		else
			logger.debug "logic err alloc = '#{alloc} "
			raise
		end
	end
	def proc_get_trngantt_cons_chil_stk(tblname,tblid)  ###子部品の消費　金型の返却　tblname 親のテーブル名  ###装置(facilities)、人員(makings)はテーブルが別
		strsql = %Q& select calloc.qty alloc_qty,calloc.qty_stk alloc_qty_stk,
						calloc.destblname alloc_destblname,calloc.destblid alloc_destblid,calloc.srctblid alloc_srctblid,
						cgantt.trngantt_consumtype consumtype,cgantt.trngantt_processseq gantt_processseq,cgantt.trngantt_consumauto gantt_consumauto,
						pgantt.trngantt_key pkey,cgantt.trngantt_key ckey,calloc.id alloc_id,cgantt.id gantt_id,cgantt.trngantt_priority gantt_priority,palloc.id palloc_id
						from r_trngantts cgantt,alloctbls calloc ,r_trngantts pgantt,alloctbls palloc
						where palloc.srctblname = 'trngantts' and pgantt.trngantt_id = palloc.srctblid
						and palloc.destblname = '#{tblname}' and palloc.destblid = #{tblid}
						and pgantt.trngantt_orgtblname = cgantt.trngantt_orgtblname and pgantt.trngantt_orgtblid = cgantt.trngantt_orgtblid
						and pgantt.trngantt_key =  case length(cgantt.trngantt_key)
						                             when 3 then
														to_char(cgantt.trngantt_key - 1,'000')
													 else
													     substr(cgantt.trngantt_key,1,length(cgantt.trngantt_key) -3 )
													 end
						and calloc.srctblname = 'trngantts' and calloc.srctblid = cgantt.trngantt_id
						and (calloc.qty + calloc.qty_stk) > 0 and calloc.allocfree = 'alloc' and 	palloc.allocfree = 'alloc'
						/*and  cgantt.trngantt_consumtype  in('ACT','ORD','BYP','con')   */
						and  (cgantt.trngantt_consumauto != 'M' or cgantt.TRNGANTT_CONSUMAUTO is null) &
		children = ActiveRecord::Base.connection.select_all(strsql)
		children.each do |child|
			 proc_get_trngantt_cons_chil_inout_fm_alloc_id child["palloc_id"]
		end
		children.each do |chil|
			case chil["consumtype"]
			when /ACT|ORD|BYP|con/
				if chil["alloc_destblname"] == "lotstkhists"
					rec = ActiveRecord::Base.connection.select_one(" select * from r_#{chil["alloc_destblname"]} where id = #{chil["alloc_destblid"]} ")
					if chil["consumtype"] == "BYP"   ###副産物
						rec["lotstkhist_qty_stk"] += chil["alloc_qty_stk"]
						based_alloc = {}
						based_alloc[:srctblid] = chil["alloc_srctblid"]
						based_alloc[:destblid] = chil["alloc_destblid"]
						proc_add_edit_lotstkhist_by_free(chil["alloc_qty_stk"]) do
							based_alloc
						end
					else
						rec["lotstkhist_qty_stk"] -= chil["alloc_qty_stk"]
					end
					packqty = rec["lotstkhist_qty_stk"]
					proc_tbl_edit_arel("lotstkhists",{:qty_stk=>rec["lotstkhist_qty_stk"]},%Q& id = #{rec["id"]} &)
					proc_tbl_edit_arel("alloctbls",{:qty_stk=>0,:packqty => packqty},%Q& id = #{chil["alloc_id"]} &)   ###変更削除に耐えれるよう修正
					###when /picords|picinsts/
					###完了の時子部品を残す残さない判定。
				else
					rec = ActiveRecord::Base.connection.select_one(" select * from r_#{chil["alloc_destblname"]} where id = #{chil["alloc_destblid"]} and opeitm_stktaking_f = '1' ")
					prec = ActiveRecord::Base.connection.select_one(" select * from r_#{tblname} where id = #{tblid}")
					next if rec.nil?
					lot =  proc_decision_id_by_key("lotstkhists","  itms_id = #{rec["itm_id"]} and locas_id = #{prec["loca_id"]}
																and lotno = '#{proc_flg_process_lotno_flg}' and shelfnos_id = 0  and prjnos_id  = #{rec["prjno_id"]}
																and processseq = #{chil["gantt_processseq"]}
																and packno =  'dummy'")
					add_fields  = {}
					add_fields[:id]  = lot["id"]
					add_fields[:lotstkhist_qty_stk] =   (chil["alloc_qty"]) * -1  + (lot["qty_stk"]||=0)
					if @lotstkhist_classname =~ /_add_/
						add_fields[:lotstkhist_itm_id]  = rec["itm_id"]
						add_fields[:lotstkhist_loca_id] =  prec["loca_id"]
						add_fields[:lotstkhist_prjno_id] =  rec["prjno_id"]
						add_fields[:lotstkhist_shelfno_id] =  0   ### 作業場での棚番はない。shelfno_id
						add_fields[:lotstkhist_processseq] = chil["gantt_processseq"]
						add_fields[:lotstkhist_lotno] = "dummy"
						add_fields[:lotstkhist_packno] = "dummy"
						__send__("proc_fld_r_alloctbls_lotstkhists_self50")   do
							add_fields
						end ##
					else
						proc_tbl_edit_arel("lotstkhists",{:qty_stk=>add_fields[:lotstkhist_qty_stk]},%Q& id = #{lot["id"]} &)
					end
					based_alloc = {}
					based_alloc[:srctblid] = chil["gantt_id"]
					based_alloc[:destblid] = lot["id"]
					based_alloc[:qty_stk] = add_fields[:lotstkhist_qty_stk]
					based_alloc[:packqty] = unless lot["lotno"].nil? and lot["lotno"] != "dummy" then add_fields[:lotstkhist_qty_stk] else 0 end
					proc_add_edit_lotstkhist_by_free(add_fields[:lotstkhist_qty_stk]) do
						based_alloc
					end
				end
			when /MET/  ###金型の時 processseq = 999
				if chil["alloc_destblname"] == "lotstkhists"
					if chil["gantt_consumauto"] == "A"
						strsql = "select shelfnos_id  from r_opeitms where itms_id = #{rec["itm_id"]} and locas_id = #{rec["loca_id"]} and processseq = #{chil["gantt_processseq"]} "
						shelfno_id = ActiveRecord::Base.connection.select_value(strsql)
						rec = ActiveRecord::Base.connection.select_one(" select * from r_lotstkhists where id = #{chil["alloc_destblid"]}  ")
						rec["lotstkhist_qty_stk"] -= chil["alloc_qty_stk"]
						proc_tbl_edit_arel("lotstkhists",{:qty_stk=>rec["lotstkhist_qty_stk"]},%Q& id = #{rec["id"]} &)
						proc_tbl_edit_arel("alloctbls",{:qty_stk=>0},%Q& id = #{chil["alloc_id"]} &)
						opeitm = proc_get_opeitms_rec rec["itm_id"],nil,999,chil["gantt_priority"]  ###金型の保管部署を求める。
						rec =  proc_decision_id_by_key("lotstkhists","  itms_id = #{rec["itm_id"]} and locas_id = #{opeitm["locas_id"]}
																and lotno = '#{rec["lotstkhist_lotno"]}' and shelfnos_id = #{shelfno_id}
																and processseq = 999  and priority = #{chil["gantt_priority"]}
																and packno =  'dummy'")
						add_fields[:id]  = {}
						add_fields[:id]  = rec["id"]
						add_fields[:lotstkhist_qty_stk] =   (rec["qty_stk"]||=0) + 1
						if @lotstkhist_classname =~ /_add_/
							add_fields[:lotstkhist_itm_id]  = rec["itm_id"]
							add_fields[:lotstkhist_loca_id] =  rec["loca_id"]
							add_fields[:lotstkhist_prjno_id] =  rec["prjno_id"]
							add_fields[:lotstkhist_shelfno_id] =  shelfno_id
							add_fields[:lotstkhist_processseq] = chil["gantt_processseq"]
							add_fields[:lotstkhist_packno] = "dummy"
							__send__("proc_fld_r_alloctbls_lotstkhists_self50")   do
								add_fields
							end ##
							based_alloc = {}
							based_alloc[:srctblid] = chil["gantt_id"]
							based_alloc[:destblid] = rec["id"]
							based_alloc[:packqty] = 0
							proc_add_edit_lotstkhist_by_free  add_fields[:lotstkhist_qty_stk] do
								based_alloc
							end
						else
							proc_tbl_edit_arel("lotstkhists",{:qty_stk=>rec["lotstkhist_qty_stk"]},%Q& id = #{rec["id"]} &)
						end
					end
				else
					rec = ActiveRecord::Base.connection.select_one(" select * from r_#{chil["alloc_destblname"]} where id = #{chil["alloc_destblid"]} and opeitm_stktaking_f = '1' ")
					next if rec.nil?
					strsql = "select shelfnos_id  from r_opeitms where itms_id = #{rec["itm_id"]} and locas_id = #{rec["loca_id"]} and processseq = #{chil["gantt_processseq"]} "
					shelfno_id = ActiveRecord::Base.connection.select_value(strsql)
					rec =  proc_decision_id_by_key("lotstkhists","  itms_id = #{rec["itm_id"]} and locas_id = #{rec["loca_id"]}
																and lotno = '#{proc_flg_process_lotno_flg}' and shelfnos_id = #{shelfno_id}
																and processseq = 999  and and processseq = #{chil["gantt_priority"]}
																and packno =  'dummy'")
					add_fields  = {}
					add_fields[:id]  = rec["id"]
					add_fields[:lotstkhist_qty_stk] =   (chil["alloc_qty"] + chil["alloc_qty_stk"]) * -1  + (rec["qty_stk"]||=0)
					if @lotstkhist_classname =~ /_add_/
						add_fields[:lotstkhist_itm_id]  = rec["itm_id"]
						add_fields[:lotstkhist_loca_id] =  rec["loca_id"]
						add_fields[:lotstkhist_prjno_id] =  rec["prjno_id"]
						add_fields[:lotstkhist_processseq] = chil["gantt_processseq"]
						add_fields[:lotstkhist_packno] = "dummy"
						add_fields[:lotstkhist_shelfno_id] = shelfno_id
						__send__("proc_fld_r_alloctbls_lotstkhists_self50")   do
							add_fields
						end ##
						based_alloc = {}
						based_alloc[:srctblid] = chil["gantt_id"]
						based_alloc[:destblid] = rec["id"]
						based_alloc[:packqty] = if proc_flg_process_lotno_flg == "dummy" then 0 else add_fields[:lotstkhist_qty_stk] end
						proc_add_edit_lotstkhist_by_free  add_fields[:lotstkhist_qty_stk] do
							based_alloc
						end
					else
						packqty = if rec["packno"] != "dummy" then rec["lotstkhist_qty_stk"] else 0 end
						proc_tbl_edit_arel("lotstkhists",{:qty_stk=>rec["lotstkhist_qty_stk"],:packqty => packqty},%Q& id = #{rec["id"]} &)
					end
				end
			end
		end
	end
	def proc_get_trngantt_pic_stk(shp,shp_id)  ### shp,dlv
		strsql = %Q& select lot.*,alloc.qty_stk alloc_qty_stk
						from trngantts gantt,alloctbls alloc ,lotstkhists lot,
							(select pgantt.* from trngantts pgantt,alloctbls ,#{shp} shp
									where pgantts.id = srctblid and srctblname = 'trngantts' and destblname = '#{shp}' and destblid = shp.id
									and shp.id = #{shp_id}) pgantt
						where alloc.srctblname = 'trngantts' and gantt.id = alloc.srctblid
						and alloc.destblname = 'lotstkhists' and alloc.destblid = lot.id
						and lot.itms_id = #{@itm_id} and lot.locas_id = #{@loca_id}
						and gantt.orgtblname = pgantt.orgtblname and gantt.orgtblid = pgantt.orgtblid and pgantt.key = substr(gantt.key,1,length(pgantt.key))
						&
		ActiveRecord::Base.connection.select_all(strsql)
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
            command_c[:sio_user_code] = (@sio_user_code ||=0)
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

	def proc_get_pare_trngantts_by_chil_trngantt_id(id) ##
		strsql = "select pare.id from trngantts pare,trngantts chil where pare.orgtblname = chil.orgtblname  and pare.orgtblid = chil.orgtblid  and chil.id = #{id} and
		                             pare.key = substr(chil.key,1,length(pare.key))  "
		ActiveRecord::Base.connection.select_all(strsql)   		###副産物がある
	end

	def proc_get_chil_trngantts_by_pare_trngantt_id(id) ##
		strsql = "select chil.id from trngantts pare,trngantts chil where pare.orgtblname = chil.orgtblname  and pare.orgtblid = chil.orgtblid  and pare.id = #{id} and
		                             chil.id != pare.id and pare.key = substr(chil.key,1,length(pare.key))  and pare.qty > 0 "
		ActiveRecord::Base.connection.select_values(strsql)
	end
	def proc_get_chil_prdpurshps_by_pare_trngantt_id(id) ##
		trns = proc_get_chil_trngantts_by_pare_trngantt_id(id)
		if trns.size > 0
			strsql = "select * from alloctbls where allocfree = 'alloc' and srctblname = 'trngantts' and  srctblid in (#{trns.join(",")}) "
			ActiveRecord::Base.connection.select_all(strsql)
		else
			[]
		end
	end
	def proc_get_chil_prdpurshps_by_pare_prdpurshp(tblname,tblid) ##
		allocs = []
		strsql = "select srctblid from alloctbls where allocfree = 'alloc' and srctblname = 'trngantts' and destblname = '#{tblname}' and destblid = #{tblid} and (qty > 0 or qty_stk > 0)"
		trnids = ActiveRecord::Base.connection.select_values(strsql)
		trnids.each do|trnid|
			allocs.concat(proc_get_chil_prdpurshps_by_pare_trngantt_id(trnid))
		end
		return allocs
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
    def vproc_get_chil_itms(n0,duedate)  ###工程の始まり=前工程の終わり
		rnditms = ActiveRecord::Base.connection.select_all("select * from nditms where opeitms_id = #{n0[:opeitms_id]} and Expiredate > current_date  ")
		if rnditms.size > 0 then
			ngantts = []  ###viewの内容なので　itm_id  loca_id
			mlevel = n0[:mlevel] + 1
			rnditms.each.with_index(1)  do |i,cnt|
				chil_ope = proc_get_opeitms_rec(i["itms_id_nditm"], i["locas_id_nditm"],i["processseq_nditm"])
				if chil_ope.nil?
					chil_ope = proc_get_opeitms_rec(i["itms_id_nditm"],nil,i["processseq_nditm"],999)
				end
				##if chil_ope and i["consumtype"]
				if chil_ope
					##i["processseq_nditm"] += 1 if chil_ope[:locas_id] != i["locas_id_nditm"]
					##if i["locas_id_nditm"] != n0[:locas_id]
					opeitm = proc_get_opeitms_rec(i["itms_id_nditm"], i["locas_id_nditm"],i["processseq_nditm"])
						i["consumtype"] = "con"  if  i["consumtype"] =~ /con|ORD|ACT/
						ngantts << {:seq=>n0[:seq] + sprintf("%03d", cnt),:mlevel=>mlevel,:itms_id=>i["itms_id_nditm"],
								##:prdpurshp=>"shp",
								:prdpurshp=>opeitm["prdpurshp"],
								:processseq=>i["processseq_nditm"],
								:locas_id=> i["locas_id_nditm"],
								:locas_id_to=>n0[:locas_id],:opeitms_id =>chil_ope["id"],
								:priority=>chil_ope["priority"],
								:duedate=>duedate,:duration=>(n0[:duration]||=1),
								:consumtype=>i["consumtype"],:consumauto=>i["consumauto"],
								:autocreate_ord=>chil_ope["autocreate_ord"],:autoord_p=>chil_ope["autoord"],
								:autocreate_inst=>chil_ope["autocreate_inst"],:autocreate_act=>chil_ope["autocreate_act"],
								:parenum=>i["parenum"],:chilnum=>i["chilnum"],:id=>"nditms_"+i["id"].to_s}  ###
					##else
					##	next
					##end
				else
					item_code  = ActiveRecord::Base.connection.select_value("select code from itms where id = #{i["itms_id_nditm"]} ")
					@errmsg = "missng opeitms ... item_code = #{item_code} processseq =  #{i["processseq_nditm"]}"
					raise
				end
			end
		else
			ngantts  = [{}]
		end
		return ngantts
    end

    def vproc_get_pare_itms(n0,duedate)  ###
		strsql = "select * from nditms where itms_id_nditm = #{n0[:itms_id]} and locas_id_nditm = #{n0[:locas_id]} and processseq_nditm = #{n0[:processseq]} and Expiredate > current_date  "
		nditms = ActiveRecord::Base.connection.select_all(strsql)
		if nditms.size > 0 then
			ngantts = []  ###viewの内容なので　itm_id  loca_id
			mlevel = n0[:mlevel] + 1
			nditms.each.with_index(1)  do |i,cnt|
				ope = ActiveRecord::Base.connection.select_one("select * from opeitms where id = #{i["opeitms_id"]} ")
				if ope
				    np= {:duration => i["duration"],:parenum => i["chilnum"],:chilnum => i["parenum"],:prdpurshp => ope["prdpurshp"],:consumtype => i["nditm_consumtype"],
							:consumauto => i["nditm_consumauto"],:opeitms_id => i["opeitms_id"],
							:itms_id => ope["itms_id"],:locas_id => ope["locas_id"],:processseq=>ope["processseq"],:priority=>ope["priority"],
							:seq=>n0[:seq] + sprintf("%03d", cnt),:mlevel=>mlevel,:level=>1,
							:starttime=>duedate,:duration=>(i["duration"]||=1),:duedate=> proc_get_starttime(n0[:duedate] ,(i["duration"]||=1)*-1,"day",nil),
							:id=>"nditms_"+i["id"].to_s}  ###
					ngantts << np
			   else
					logger.debug "logic error opeitms missing  line :#{__LINE_} select * from opeitms where id = #{i["opeitms_id"]} "
					@errmsg =  "logic error opeitms missing  line :#{__LINE_} select * from opeitms where id = #{i["opeitms_id"]} "
					raise
			   end
			end
		else
			ngantts  = [{}]
		end
		return ngantts
    end
	###def vproc_get_ope_id_priority(i,n0)
	### 	strsql = "select id,priority,locas_id from opeitms where itms_id = #{i["itms_id_nditm"]} and locas_id = #{i["locas_id_nditm"]} and processseq = #{i["processseq_nditm"]} and priority = #{n0[:priority]} "
	###		ActiveRecord::Base.connection.select_one(strsql)
	###end
    def vproc_get_prev_process(n0,starttime)  ###工程の始まり=前程の終わり
      rec = ActiveRecord::Base.connection.select_one("select * from opeitms where itms_id = #{n0[:itms_id]} and Expiredate > current_date
																			and Priority = #{n0[:priority]} and processseq < #{n0[:processseq]}  order by   processseq desc")
      if rec
	       ngantts = []
				ngantts << {:seq=>(n0[:seq] + "000"),:mlevel=>n0[:mlevel]+1,:itms_id=>rec["itms_id"],:locas_id=>rec["locas_id"],:opeitms_id=>rec["id"],
							:locas_id_to=>n0[:locas_id],
							:duedate=>starttime,:prdpurshp=>rec["prdpurshp"],:duration=>(rec["duration"]||=1),
							:parenum=>rec["parenum"],:chilnum=>rec["chilnum"],
							:autocreate_ord=>rec["autocreate_ord"],:autocreate_inst=>rec["autocreate_inst"],
							:autoord_p=>rec["autoord_p"],
							:consumtype=>rec["consumtype"],:consumauto=>n0[:consumauto],
							:safestkqty=>rec["safestkqty"],:id=>"opeitms_"+rec["id"].to_s,:priority=>rec["priority"],:processseq=>rec["processseq"],
							:starttime => proc_get_starttime(starttime ,(rec["duration"]||=1),"day",nil)}  ###基準日　期間　タイプ　休日考慮
		else
          ngantts = [{}]
      end
      return ngantts
    end
    def vproc_get_after_process(n0,duedate)  ###工程の始まり=前程の終わり
      rec = ActiveRecord::Base.connection.select_one("select * from opeitms where itms_id = #{n0[:itms_id]} and Expiredate > current_date
																			and Priority = #{n0[:priority]} and processseq > #{n0[:processseq]}  order by   processseq ")
      if rec
	       ngantts = []
           ngantts << {:seq=>(n0[:seq] + "000"),:mlevel=>n0[:mlevel]+1,:itms_id=>rec["itms_id"],:locas_id=>rec["locas_id"],:opeitms_id=>rec["id"],
		   :locas_id_to=>n0[:locas_id],:prdpurshp=>rec["prdpurshp"],:duedate=>proc_get_starttime(duedate,(rec["duration"]||=1)*-1,"day",nil),
		   :duration=>(rec["duration"]||=1),:parenum=>rec["parenum"],:chilnum=>rec["chilnum"],
		   :autocreate_ord=>rec["autocreate_ord"],:autocreate_inst=>rec["autocreate_inst"],:autoord_p=>rec["autoord_p"],
		   :safestkqty=>rec["safestkqty"],:id=>"opeitms_"+rec["id"].to_s,:priority=>rec["priority"],:processseq=>rec["processseq"],
            :starttime => duedate } ##基準日　期間　タイプ　休日考慮
		else
          ngantts = [{}]
      end
      return ngantts
    end
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

    def proc_get_opeitms_rec itms_id,locas_id,processseq = nil,priority = nil  ###
		strsql = %Q& select * from opeitms where itms_id = #{itms_id} #{if locas_id then " and locas_id = " + locas_id.to_s else "" end}
		           and processseq = #{processseq ||= 999}
				   #{if priority then " and priority = " + priority.to_s else "" end}
				   and expiredate > current_date &
		rec = ActiveRecord::Base.connection.select_one(strsql)
        if rec
	        rec
		  else
            logger.debug "error class logic err proc_get_opeitms_rec itms_id = #{itms_id} ,locas_id = #{locas_id}, processseq = #{processseq ||= 999} ,
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
					starttime,duedate = proc_get_item_loca_contents(n0,gantt_reverse)
					tmp = vproc_get_chil_itms(n0,starttime)
					ngantts.concat(tmp) if tmp[0].size > 0
					tmp = vproc_get_prev_process(n0,starttime)
				when /reverse/
					starttime,duedate = proc_get_item_loca_contents(n0,gantt_reverse)
					tmp = vproc_get_pare_itms(n0,duedate)
					ngantts.concat(tmp) if tmp[0].size > 0
					tmp = vproc_get_after_process(n0,duedate)
			end
			ngantts.concat(tmp) if tmp[0].size > 0
	    end
        return ngantts
    end  ##

    def proc_get_item_loca_contents(n0,gantt_reverse)   ##n0[:itms_id] r0[:itms_id]
	    qty = if n0[:seq].size > 4 then (@bgantts[n0[:seq][0..-4]][:qty] ||= 1) else  (@bgantts["000"][:qty] ||= 1) end
	    new_qty = qty.to_f / (n0[:parenum]||=1) * (n0[:chilnum]||=1)
		###:autocreate_ord,:autocreate_instは画面にはセットしない。
		if gantt_reverse =~ /mst$/
			itm = ActiveRecord::Base.connection.select_one("select * from itms where id = #{n0[:itms_id]}  ")
			loca = ActiveRecord::Base.connection.select_one("select * from locas where id = #{n0[:locas_id]}  ")
			bgantt = {:mlevel=>n0[:mlevel],:itm_code=>itm["code"], :itm_name=>itm["name"],:loca_code=>loca["code"],:loca_name=>loca["name"],
								:duration=>(n0[:duration]||=1),:depends=>"",
								 :parenum=>n0[:parenum]||=1,:chilnum=>n0[:chilnum]||=1,:prdpurshp=>n0[:prdpurshp],
								 :consumtype=>n0[:consumtype],:consumauto=>n0[:consumauto],
                                 :id=>n0[:id],:itms_id=>n0[:itms_id],:locas_id=>n0[:locas_id],
								:autocreate_ord=>n0[:autocreate_ord],:autoord_p=>n0[:autoord_p],:autocreate_inst=>n0[:autocreate_inst],
								 :processseq=>n0[:processseq],:priority=>n0[:priority],:qty=>new_qty,:qty_src=>new_qty,:qty_stk=>0,
								:opeitms_id => n0[:opeitms_id]}
		else  ###trngantts insert 用
			bgantt = {:mlevel=>n0[:mlevel],###:itm_code=>itm["code"], :itm_name=>itm["name"],:loca_code=>loca["code"],:loca_name=>loca["name"],
								:duration=>(n0[:duration]||=1),:depends=>"",
								 :parenum=>n0[:parenum]||=1,:chilnum=>n0[:chilnum]||=1,:prdpurshp=>n0[:prdpurshp],
								 :consumtype=>n0[:consumtype],:consumauto=>n0[:consumauto],
                                 :id=>n0[:id],:itms_id=>n0[:itms_id],:locas_id=>n0[:locas_id],
								:autocreate_ord=>n0[:autocreate_ord],:autoord_p=>n0[:autoord_p],:autocreate_inst=>n0[:autocreate_inst],
								 :processseq=>n0[:processseq],:priority=>n0[:priority],:qty=>new_qty,:qty_src=>new_qty,:qty_stk=>0}
		end
		 case gantt_reverse
			when /gantt/
				cgantt = {:duedate=>n0[:duedate],:duedate_est=>n0[:duedate],
									:starttime=>proc_get_starttime(n0[:duedate],(n0[:duration]||=1),"day",nil),
									:starttime_est=>proc_get_starttime(n0[:duedate],(n0[:duration]||=1),"day",nil)}
			when /reverse/
				cgantt = {:starttime=>n0[:starttime],:starttime_est=>n0[:starttime],
									:duedate=>proc_get_starttime(n0[:starttime],(n0[:duration]||=1)*-1,"day",nil),
									:duedate_est=>proc_get_starttime(n0[:starttime],(n0[:duration]||=1)*-1,"day",nil)}
		 end
        bgantt.merge! cgantt
		@bgantts[n0[:seq]] = bgantt
	    @min_time = cgantt[:starttime] if (@min_time||="2099/12/31".to_time) > cgantt[:starttime]
		@max_time = cgantt[:duedate] if (@max_time||=Time.now)  < cgantt[:duedate]
        return cgantt[:starttime],cgantt[:duedate]
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
                       @bgantts[key][:duedate_est]  =   proc_get_starttime(@bgantts[key][:starttime_est], (value[:duration]||=1)*-1,"day",nil)    ###稼働日考慮今なし
                    end
			    end
                if  (@bgantts[key[0..-4]][:starttime_est] ) < @bgantts[key][:duedate_est]
                    @bgantts[key[0..-4]][:starttime_est]  =   @bgantts[key][:duedate_est]   ###稼働日考慮今なし
                    @bgantts[key[0..-4]][:duedate_est] =  proc_get_starttime(@bgantts[key[0..-4]][:starttime_est],@bgantts[key[0..-4]][:duration]*-1,"day",nil)
				    ##p key
				    ##p @bgantts[key]
			    end
            end
        end
        @bgantts.sort.each  do|key,value|  ###topから再計算
		    if key.size > 3
                if  (@bgantts[key[0..-4]][:starttime_est]  ) > @bgantts[key][:duedate_est]
                      @bgantts[key][:duedate_est]  =   @bgantts[key[0..-4]][:starttime_est]    ###稼働日考慮今なし
                      @bgantts[key][:starttime_est] =  proc_get_starttime(@bgantts[key][:duedate_est],(value[:duration]||=1) ,"day",nil)
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
			do_all.each do |dorec|
				if respond_to?(dorec["tblink_codel"])
					__send__(dorec["tblink_codel"],eval(dorec["tblink_hikisu"]))
				else
					proc_crt_def_rubycode({"codel"=> dorec["tblink_codel"],"hikisu"=>dorec["tblink_hikisu"],"rubycode"=>dorec["tblink_rubycode"]})
					__send__(dorec["tblink_codel"],eval(dorec["tblink_hikisu"]))
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
	def proc_save_rec_btch_sub rec
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
					if tbl == "person"
						if @person_rec
							if @person_rec["id"] = val
								trec = @person_rec
							else
								@person_rec = trec = ActiveRecord::Base.connection.select_one("select * from #{"r_" + tbl + "s"} where id = #{val}")
							end
						else
							@person_rec = trec = ActiveRecord::Base.connection.select_one("select * from #{"r_" + tbl + "s"} where id = #{val}")
						end
					else
						trec = ActiveRecord::Base.connection.select_one("select * from #{"r_" + tbl + "s"} where id = #{val}")
					end
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
		return rec
	end
	def proc_save_rec_btch rec
			if @rec_save
				if @rec_save["sio_code"] == rec["sio_code"] and @rec_save["id"] == rec["id"]
					return @rec_save
				else
					@rec_save = proc_save_rec_btch_sub rec
				end
			else
				@rec_save = proc_save_rec_btch_sub rec
			end
			return @rec_save
	end
  def proc_command_before_instance_variable rec
	    if @pare_class == "batch"  ###delayjobからだと必要データが来ない。
				proc_command_instance_variable(proc_save_rec_btch(rec))
			else
				proc_command_instance_variable rec
	    end
  end
  def proc_command_after_instance_variable rec
	    if @pare_class == "batch"  ###delayjobからだと必要データが来ない。
				proc_command_instance_variable(proc_save_rec_btch(rec))
			else
				proc_command_instance_variable rec
			end
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
			if self.to_s != "main"
				logger.debug" error class #{self} #{Time.now}:  $@: #{$@} "
				logger.debug"  error class #{self} :  $!: #{$!} "
			else
				p " error class #{self} #{Time.now}:  $@: #{$@} "
				p "  error class #{self} :  $!: #{$!} "
			end
		end
	end
    def vproc_crt_def_rubycode src_tbl
		strdef = "def #{src_tbl["codel"]}  #{src_tbl["hikisu"]} \n"
		strdef << src_tbl["rubycode"]
	    strdef <<"\n end"
		if self.to_s != "main"
			logger.debug strdef
		else
			p strdef[0..50]
		end
	    eval(strdef)
    end
	def proc_crt_def_tblink codel
		src_tbl  = ActiveRecord::Base.connection.select_one("select * from tblinks where codel = '#{codel}' and expiredate > current_date")
		proc_crt_def_rubycode(src_tbl)
	end
    def proc_crt_def_rubycode(src_tbl)
		strdef = "def #{src_tbl["codel"]}  #{src_tbl["hikisu"]} \n"
		strdef << src_tbl["rubycode"]
		strdef <<"\n end"
		if self.to_s != "main"
			logger.debug strdef
		else
			p strdef[0..50]
		end
		eval(strdef)
		proc_create_tblinkfld_def do
		 " and tblink_codel = '#{src_tbl["codel"]}' "
		end
    end
	def str_init_command_c tbl_dest
	    %Q%
		command_c = {}.with_indifferent_access
		command_c[:sio_session_counter] =   @new_sio_session_counter
		command_c[:sio_recordcount] = 1
		command_c[:sio_user_code] =   @sio_user_code
		command_c[:sio_code] = command_c[:sio_viewname] = @sio_code = "#{tbl_dest}"
		command_c.merge!(yield) if block_given?
		%
	end
	def proc_simple_sio_insert command_c
        ### @src_tbl作成はproc_update_tableで実施
		proc_update_table "command",proc_insert_sio_c(command_c),1
		#####proc_command_c_to_instance command_c  ###@xxxx_yyyy作成
	end
	def str_sio_set tblchop
		%Q%
		command_c[:sio_classname] = (@#{tblchop}_classname ||= @sio_classname)
		proc_simple_sio_insert command_c
	    end
		%
	end
    def proc_create_tblinkfld_def
		strsql = " select * from r_tblinkflds where tblinkfld_expiredate > current_date "
		if block_given?
			strsql << yield
		end
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
						if self.to_s != "main"
							logger.debug streval
						else
							p streval[0..50]
						end
						eval(streval)
					end
					src_screen = rec["pobject_code_scr_src"]
					tblchop = rec["pobject_code_tbl_dest"].chop
					beforeafter = rec["tblink_beforeafter"]
					seqno = rec["tblink_seqno"]
					streval = "def proc_fld_#{src_screen}_#{tblchop}s_#{beforeafter+seqno.to_s}\n"
					p streval
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
			if self.to_s != "main"
				logger.debug streval
			else
				p streval[0..50]
			end
			eval(streval)
		end
    end
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
	def proc_save_alloc_id alloc
		des_cmd = ActiveRecord::Base.connection.select_one("select * from r_#{alloc["destblname"]} where id = #{alloc["destblid"]}")
		if des_cmd.nil?
			logger.debug "error:not found  #{alloc["destblid"]} by alloctbls_id 'select * from r_#{alloc["destblname"]} where id = #{alloc["destblid"]} ' "
			raise   ##logic error
		end
		return des_cmd
	end
	def proc_decide_alloc_inout(alloc)
		des_cmd = proc_save_alloc_id(alloc)
		if respond_to?(%Q&proc_tblink_alloctbls_#{alloc["destblname"]}_inouts_self10&)
			des_cmd["sio_viewname"] = des_cmd["sio_code"] = "r_#{alloc["destblname"]}"
			des_cmd["sio_classname"] = "_add_proc_decide_alloc_inout"
			proc_command_instance_variable(des_cmd)
			if block_given?
					__send__(%Q&proc_tblink_alloctbls_#{alloc["destblname"]}_inouts_self10&,alloc) do
						yield
					end
			else
					__send__(%Q&proc_tblink_alloctbls_#{alloc["destblname"]}_inouts_self10&,alloc)
			end
		end
	end
	def proc_inouts_in_addfield_create alloc
		add_fields = {}
		add_fields[:inout_qty] =  alloc["qty"]
		add_fields[:inout_qty_stk] =  alloc["qty_stk"]
		add_fields[:inout_trngantt_id_inout] = alloc["srctblid"]   ### trngantts_id
		add_fields[:inout_alloctbl_id_inout] = alloc["id"]
		add_fields[:inout_inoutflg] = if block_given? then yield else nil end
		add_fields[:id] = add_fields[:inout_id] = proc_get_nextval("inouts_seq")
		add_fields.merge!( proc_get_pare_from_trn_id(alloc["srctblid"]))
		__send__("proc_fld_alloctbls_#{alloc["destblname"]}_inouts_self10") do
			add_fields
		end
	end

	def proc_get_nextval tbl_seq
		ActiveRecord::Base.uncached() do
			case ActiveRecord::Base.configurations[Rails.env]['adapter']
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
				ActiveRecord::Base.connection.select_all("SELECT attname, typname FROM pg_class, pg_attribute, pg_type WHERE   relkind     = 'r'
												AND relname     ='テーブル名' AND attrelid    = (select relid from pg_stat_all_tables where relname = 'テーブル名')
												AND attnum      > 0    AND pg_type.oid = atttypid;")  ##post
			when /oracle/
				recs = ActiveRecord::Base.connection.select_all("select * from user_tab_columns where  table_name = '#{tblname.upcase}'")  ##oracle
				recs.each do |rec|
					columns[rec["column_name"].downcase] = {:data_type=>rec["data_type"],:data_precision=>rec["data_precision"],:data_scale=>rec["data_scale"],:char_length=>rec["char_length"]}
				end
		end
		return columns
	end
	def proc_get_trg_view_fm_tblname_tblid tblname,srctblname,srctblid  ##レコードが見つからなかったときの処理は親ですること。
		if block_given?
			rec = ActiveRecord::Base.connection.select_one("select * from r_#{tblname} where #{tblname.chop}_tblname = '#{srctblname}' and #{tblname.chop}_tblid = #{srctblid} #{yield}")
		else
			rec = ActiveRecord::Base.connection.select_one("select * from r_#{tblname} where #{tblname.chop}_tblname = '#{srctblname}' and #{tblname.chop}_tblid = #{srctblid}")
		end
		####id = proc_get_nextval "#{tblname}_seq" if id.nil?
		proc_command_instance_variable(rec)
		return rec.with_indifferent_access if rec
	end
	def proc_get_trg_rec_fm_tblname_tblid tblname,srctblname,srctblid  ##レコードが見つからなかったときの処理は親ですること。
			ActiveRecord::Base.connection.select_one(%Q% select * from #{tblname} where tblname = '#{srctblname}' and tblid = #{srctblid} #{if block_given? then yield else "" end}%)
	end
	def proc_get_trg_rec_id_fm_tblname_tblid tblname,srctblname,srctblid
			rec = proc_get_trg_rec_fm_tblname_tblid(tblname,srctblname,srctblid)
			if rec
				rec["id"]
			else
				nil
			end
	end
	def proc_get_rec_fm_tblname_sno tblname,sno　 ##レコードが見つからなかったときの処理は親ですること。
		rec = {}
		rec = ActiveRecord::Base.connection.select_one("select * from #{tblname} where sno = #{sno}")
		if rec
		else
			rec["id"] = nil
		     ###snoはテーブル毎に必ずユニーク
			 return
		end
		rec.with_indifferent_access if rec
	end

	def proc_get_rec_fm_tblname_yield tblname  ##proc_fld_xxxxの中の項目を求める。　 ##レコードが見つからなかったときの処理は親ですること。
		rec = ActiveRecord::Base.connection.select_one("select * from #{tblname} where expiredate > current_date and #{yield}")
		rec.with_indifferent_access if rec
	end
	def proc_get_rec_fm_viewname_yield viewname  ##proc_fld_xxxxの中の項目を求める。　 ##レコードが見つからなかったときの処理は親ですること。
		rec = ActiveRecord::Base.connection.select_one("select * from #{viewname} where #{viewname.split("_")[1].chop}_expiredate > current_date and #{yield}")
		if rec
		  rec.with_indifferent_access
		else
			nil
		end
	end
	def proc_get_allrecs_fm_tblname_yield tblname  ##proc_fld_xxxxの中の項目を求める。　 ##レコードが見つからなかったときの処理は親ですること。
		 ActiveRecord::Base.connection.select_all("select * from #{tblname} where expiredate > current_date and  #{yield}")
		##### recs.with_indifferent_access
	end
	def proc_get_viewrec_from_id tblname,id  ##  ##レコードが見つからなかったときの処理は親ですること。
		rec = ActiveRecord::Base.connection.select_one("select * from r_#{tblname} where id = #{id}")
		return rec.with_indifferent_access if rec
	end
	def proc_get_tblrec_from_id tblname,id  ##  ##レコードが見つからなかったときの処理は親ですること。
		rec = ActiveRecord::Base.connection.select_one("select * from #{tblname} where id = #{id}")
		return rec.with_indifferent_access if rec
	end
	def proc_get_pare_from_trn_id trn_id  ## inoutsのprocessseq　itms_id_pare  品目違いの親を求める。
		inout = {}
		for ii in 1..5 do
			strsql = " select case when pare.itm_id = trn.itm_id then pare.trngantt_processseq else 999 end processseq,
					pare.itm_id itms_id_pare,trn.itm_id itms_id,pare.trngantt_key key,pare.trngantt_id pare_trn_id, pare.trngantt_processseq  processseq_pare
					from r_trngantts trn,r_trngantts pare
					where trn.trngantt_orgtblname = pare.trngantt_orgtblname and trn.trngantt_orgtblid = pare.trngantt_orgtblid
					and pare.trngantt_key =  case length(trn.trngantt_key)      when 3 then  to_char(trn.trngantt_key  - 1,'000')   else   substr(trn.trngantt_key,1,length(trn.trngantt_key) -3)   end
					and trn.id = #{trn_id} "
			rec = ActiveRecord::Base.connection.select_one(strsql)
			if rec
				inout[:inout_itm_id_pare] = rec["itms_id_pare"]
				inout[:inout_processseq_pare] = rec["processseq_pare"]
				break if rec["itms_id_pare"] != rec["itms_id"]
				break if  rec["key"].size < 4
			else
				rec1 = ActiveRecord::Base.connection.select_one("select itms_id,processseq from trngantts where id = #{trn_id}")
				inout[:inout_itm_id_pare] = rec1["itms_id"]
				inout[:inout_processseq_pare] = rec1["processseq"]
				break
			end
			ii += 1
			trn_id = rec["pare_trn_id"]
		end
		return inout
	end
	def proc_decision_id_by_key(tblname,where)
		strsql = %Q& select * from #{tblname} where #{where} for update &
		rec = ActiveRecord::Base.connection.select_one(strsql)
		eval(%Q& if  rec.nil?
					rec = {}
					rec["id"] =  proc_get_nextval("#{tblname}_seq")
					@#{tblname.chop}_classname = "#{tblname}_add_#{where}"[0..49]
					rec["expiredate"] = "2099/12/31".to_date
					rec["created_at"] = Time.now
				else
					### tbllinksでユニークkey チェックをセットする。　複数レコードはエラー
					@#{tblname.chop}_classname  = "#{tblname}_edit_#{where}"[0..49]
				end &)
		eval(%Q& @#{tblname.chop}_id = rec["id"] &)
		rec["updated_at"] = Time.now
		rec["persons_id_upd"] = (@sio_user_code ||=0)
		return rec
	end
	def proc_decision_all_ids_by_key(tblname,where)
		strsql = %Q& select * from #{tblname} where #{where} for update &
		recs = ActiveRecord::Base.connection.select_all(strsql)
		eval(%Q& if  recs.size == 0
					rec[0] = {"id" =>  proc_get_nextval("#{tblname}_seq")}
					@#{tblname.chop}_classname = "#{tblname}_add_#{where}"[0..49]
				else
					@#{tblname.chop}_classname  = "#{tblname}_edit_#{where}"[0..49]
				end &)
		return recs
	end
	def proc_akakuro
		case yield[:table]
		when nil
			raise
		else
			if yield[:tblname]
				add_field = {}
				rec =  proc_get_trg_rec_fm_tblname_tblid(yield[:table],yield[:tblname],yield[:tblid]) do
	            " order by id desc "
				end
				if rec
	    		rec["id"] =  proc_get_nextval("#{yield[:table]}_seq")
					rec["updated_at"] = Time.now
					if rec["qty"]
						rec["qty"] = rec["qty"] * -1
					end
					if rec["qty_stk"]
						rec["qty_stk"] = rec["qty_stk"] * -1
					end
					proc_tbl_add_arel  yield[:table],rec
				end
			end
		end
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
			if pare_rule_price  == "0" and @pare_class != "batch"
				price = proc_blkgetpobj("単価マスタなし","err_msg")
				return {:price=>price.to_s,:amt=>"",:tax=>"",:pricef=>true,:amtf=>true,:contract_price => contract}
			end
			if @pare_class == "batch"
				@errmsg = proc_blkgetpobj("単価マスタなし","err_msg")
				return {:price=>"0",:amt=>"0",:tax=>"0",:pricef=>false,:amtf=>false,:contract_price => "X"}
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
	def proc_create_trngantts_alloctbls_fm_trn trn  ##
		strsql = "select * from alloctbls where
					(srctblname = 'trngantts' and destblname = '#{trn[:tblname]}' and
					destblid = #{trn[:id]} and allocfree in('alloc','free') and (qty_stk + qty) >0 ) or
					(allocfree  = '#{trn[:tblname]}' and allocfreeid = #{trn[:id]}  and (qty_stk + qty) >0 ) "
		crr_allocs = ActiveRecord::Base.connection.select_all(strsql)
		i = 0
		if crr_allocs.size > 0
			allocs = []
			##trn_qty = trn[:qty]
			##trn_qty_stk = trn[:qty_stk]
			crr_allocs.each do |crr_alloc|
				trn[:qty] -= crr_alloc["qty"]
				trn[:qty_stk] -= crr_alloc["qty_stk"]
				if crr_alloc["allocfree"] =~ /alloc|free/
					allocs << crr_alloc.with_indifferent_access
					i += 1
				end
			end
			##allocs[i]["qty"] += trn[:qty] if trn[:qty] >0
			##allocs[i]["qty_stk"] += trn[:qty_stk] if trn[:qty_stk] >0
		end
		return allocs  if i > 0
		tmp_gantt ={:id=>proc_get_nextval("trngantts_seq"),:key=>"000",
				:orgtblname=>trn[:tblname] ,:orgtblid=>trn[:id],:mlevel=>0,
				:prjnos_id=>trn[:prjnos_id],
				:itms_id=>trn[:itms_id],:locas_id=>trn[:locas_id],
				:prdpurshp=>trn[:prdpurshp],:processseq=>trn[:processseq],:priority=>trn[:priority],:shuffle_flg=>trn[:shuffle_flg],
				:starttime=>(trn[:starttime]||=trn[:depdate]),:duedate=>trn[:duedate],
				:parenum=>1,:chilnum=>1,:consumtype=>trn[:consumtype],:autoord_p=>"",
				:consumauto=>"",:qty=>trn[:qty],:qty_stk=>trn[:qty_stk],
				:qty_src=>trn[:qty],:depends=>"",:expiredate=>"2099/12/31".to_date,
				:created_at=>Time.now,:updated_at=>Time.now,:remark=>"proc_create_trngantts_alloctbls_fm_trn gantt",
				:persons_id_upd=>system_person_id}
		proc_tbl_add_arel("trngantts",tmp_gantt)
		### schからord ordから　・・・・を作成時には子部品のtrnganttsは作成しない。　二重手配になる。。
		crr_alloc = {}
		crr_alloc[:srctblname] = "trngantts"
		crr_alloc[:destblname] = trn[:tblname]
		crr_alloc[:srctblid] = tmp_gantt[:id]
		crr_alloc[:destblid] = trn[:id]
		crr_alloc[:qty] = tmp_gantt[:qty]
		crr_alloc[:packqty] = 0
		crr_alloc[:qty_stk] = tmp_gantt[:qty_stk]
		crr_alloc[:allocfree] = "free"
		###  inouts ,
		crr_alloc[:remark] = ""
		proc_alloctbls_update("_add_",crr_alloc)
		return [crr_alloc.with_indifferent_access ]
	end
	def proc_update_gantt_alloc_fm_trn trn,allocs,trn_id = nil    ### allocs:ord等の作成元　ordなら　sch;  instならord
		trn_allocs = proc_create_trngantts_alloctbls_fm_trn(trn)
		##logger.debug"error class trn_alloc:#{trn_allocs}"
		allocs.each do |alloc|
			trn_allocs.each do |trn_alloc|
				case
				when trn_alloc[:qty]  > 0
					trn_alloc[:qty]  = proc_update_base_alloc trn,alloc.with_indifferent_access ,trn_alloc
				when trn_alloc[:qty_stk]  > 0
					trn_alloc[:qty_stk] = proc_update_stk_alloc(trn,alloc.with_indifferent_access ,trn_alloc)[0]  ###[0]:qty_stk [1]:alloc
				end
			end
			##break if trn_alloc[:qty_stk] <= 0 and trn_alloc[:qty] <= 0
		end
	end
	def proc_update_gantt_alloc_fm_acttrn lottrn,alloc,free_qty = nil    ### xxxactからlotstkhistsへ
		##proc_tblink_r_lotstkhists_trngantts_self10 lottrn   ###在庫のtrngantts作成
		proc_decision_id_by_key("trngantts","  orgtblname = 'lotstkhists' and orgtblid = #{lottrn[:id]} and key = '000' ")
		proc_fld_r_lotstkhists_trngantts_self10
		##based_alloc = proc_add_edit_lotstkhist_by_free  lottrn
		based_alloc = proc_update_stk_alloc(lottrn,alloc,proc_add_edit_lotstkhist_by_free(free_qty||=lottrn[:qty_stk]))[1]   ###actからの引当て情報を在庫に引き継ぐ  [0]:trngantt_qty_stk
  end
	def proc_add_alloc_fm_schtrn trn,trngantt_id  ### allocs:ord等の作成元　ordなら　sch;  instならord
	##proc_tblink_mksch_trnganttsから呼ばれる
		str_alloctbl = {}
		new_alloc = {}
		new_alloc[:srctblname] = "trngantts"
		new_alloc[:destblname] = "#{trn[:tblname] }"
		new_alloc[:srctblid] = trngantt_id
		new_alloc[:destblid] = trn[:id]
		new_alloc[:allocfree] = "alloc"
		new_alloc[:qty] = trn[:qty] ### allocs.nilで　trn[:qty] != trngantt_qtyはあり得ない
		new_alloc[:qty_stk] = trn[:qty_stk]
		new_alloc[:packqty] = (trn[:packqty]||=0)
		new_alloc[:srctblid] = trngantt_id
		new_alloc[:updated_at] = Time.now
		alloc_id = proc_create_or_replace_alloc_by_same_tbl(trn,new_alloc)
    end
	def proc_alloc_copy_to_based_alloc(alloc)
		{:id=>alloc["id"],:qty=>alloc["qty"],:srctblname=>alloc["srctblname"],:srctblid=>alloc["srctblid"],:allocfree=>alloc["allocfree"],
						:destblname=>alloc["destblname"],:destblid=>alloc["destblid"],:qty_stk=>(alloc["qty_stk"]||=0),:packqty=>(alloc["packqty"]||=0)}  ###schs,ords,actsにはqty_stkはない。
	end
	def proc_update_base_alloc trn,alloc,new_alloc   ###trn:次のテーブル名　tblid  alloc:旧の引当て
		based_alloc  = {}
		based_alloc[:remark] = "proc_update_base_alloc edit"
		based_alloc[:qty] = if  alloc["qty"] <= trn[:qty] then 0 else alloc["qty"] - trn[:qty] end
		based_alloc[:qty_stk] = 0 ####  based_alloc[:qty] =  0 ###trn[:qty_stk] >0 なら　proc_update_stk_alloc
	    ## 上位ステータスに変更
		based_alloc[:id] =  alloc["id"]
		proc_alloctbls_update("_edit_",based_alloc)
		##
		based_alloc = proc_alloc_copy_to_based_alloc(alloc)
		based_alloc[:qty] = if  alloc["qty"] <= trn[:qty] then alloc["qty"] else trn[:qty] end
		based_alloc[:allocfree] = trn[:tblname]
		based_alloc[:allocfreeid] = trn[:id]
		based_alloc[:remark] = "proc_update_base_alloc add"
		proc_alloctbls_update("_add_",based_alloc)
		if alloc["allocfree"] == "alloc"   ### free のallocはproc_update_gantt_alloc_fm_trnで作成済
			new_alloc[:qty] = if  new_alloc[:qty] <= alloc["qty"] then 0 else  new_alloc[:qty] - alloc["qty"] end
			##proc_tbl_edit_arel("alloctbls", {:qty=>new_alloc[:qty]}," id = #{new_alloc[:id]} ")
			###based_alloc[:remark] = "proc_update_base_alloc alloc['allocfree'] == 'alloc'  edit"
			proc_alloctbls_update("_edit_",{:qty=>new_alloc[:qty],:remark =>"proc_update_base_alloc alloc['allocfree'] == 'alloc'  edit",:id =>new_alloc[:id]} )
			##
			based_alloc[:srctblname] = alloc["srctblname"]  ###=trngantts
			based_alloc[:srctblid] = alloc["srctblid"]
			based_alloc[:destblname] = trn[:tblname]
			based_alloc[:destblid] = trn[:id]
			based_alloc[:allocfree] = "alloc"
			based_alloc[:qty_stk] = 0
			based_alloc[:packqty] = 0
			based_alloc[:qty] = alloc["qty"]
			based_alloc[:remark] = "proc_update_base_alloc alloc['allocfree'] == 'alloc'  add"
			proc_alloctbls_update("_add_",based_alloc)
			##based_alloc[:id] = proc_get_nextval "alloctbls_seq"
			###新規引当て作成
			###   ## 引当てを　schからord  又はordからinst
		end
		return new_alloc[:qty]
		end
	def proc_update_stk_alloc lottrn,alloc,new_alloc   ###trn:次のテーブル、tblid 　alloc:旧のalloc  alloc_qty >0 alloc_qty_stk =0
		###在庫に引きあたることによって子部品の所要が不要になるが引当て変更はschsの時のみおこなう。、
		based_alloc  = {}  ###allocの引当て数減
		qty = based_alloc[:qty] = if lottrn[:qty_stk] >=alloc["qty"] then 0 else alloc["qty"] -  lottrn[:qty_stk] end
		##else
			##if alloc["qty_stk"] > 0
		if alloc["packqty"] > 0
			qty_stk = based_alloc[:qty_stk] = 0
			proc_tbl_edit_arel(alloc["destblname"],{:qty_stk=>0}," id = #{alloc["destblid"]}")
		else
			if	lottrn[:qty_stk] >=alloc["qty_stk"]
				based_alloc[:qty_stk] = 0
				qty_stk = alloc["qty_stk"]
			else
				based_alloc[:qty_stk] =	alloc["qty_stk"] -  lottrn[:qty_stk]
				qty_stk = lottrn[:qty_stk]
			end
			rec = proc_get_rec_fm_tblname_yield(alloc["destblname"]) do
			       " id = #{alloc["destblid"]} "
			end
			if alloc["qty"] >0
				proc_tbl_edit_arel(alloc["destblname"],{:qty=>rec["qty"] - qty_stk}," id = #{alloc["destblid"]} ")
			else
				if alloc["qty_stk"] >0
					proc_tbl_edit_arel(alloc["destblname"],{:qty_stk=>rec["qty_stk"] - qty_stk}," id = #{alloc["destblid"]} ")
				else
					logger.debug" error class #{self} #{Time.now}:  logic eror  line:#{__LINE__} alloc:#{alloc} lottrn:#{lottrn} new_alloc:#{new_alloc}  "
					raise
				end
			end
		end
	    ## 上位ステータスに変更
		based_alloc[:id] =  alloc["id"]
		based_alloc[:remark] = "proc update_stk_alloc edit1 "
		proc_alloctbls_update("_edit_",based_alloc)
		##
		gantt = ActiveRecord::Base.connection.select_one("select * from trngantts where id = #{alloc["srctblid"]}")
		gantt["qty"] -= (alloc["qty"] - based_alloc[:qty])
		##gantt["qty_stk"] -= (alloc["qty_stk"] - based_alloc[:qty_stk])
		##gantt["packqty"] = 0
		gantt["id"] = alloc["srctblid"]
		proc_tbl_edit_arel("trngantts",gantt," id = #{alloc["srctblid"]} ")
		##
		based_alloc = proc_alloc_copy_to_based_alloc(alloc)
		based_alloc[:allocfree] = lottrn[:tblname]
		based_alloc[:allocfreeid] = lottrn[:id]
		based_alloc[:qty] = lottrn[:qty]
		based_alloc[:qty_stk] = lottrn[:qty_stk]
		based_alloc[:remark] = "proc update_stk_alloc_2"
		proc_alloctbls_update("_add_",based_alloc)

		### free_lotstk  から　alloc_lotstkへ
		if alloc["allocfree"] == "alloc" ##
			##if lottrn[:packno] == "dummy"
				new_alloc[:qty_stk] -= (alloc["qty"] +  alloc["qty_stk"])
				proc_alloctbls_update("_edit_",{:qty_stk => new_alloc[:qty_stk],:remark => "proc update_stk_alloc alloc['allocfree'] == alloc add ",:id => new_alloc[:id]})
			##else  ##packqty毎引当てると　戻った時freeができる。
			##	proc_alloctbls_update("_edit_",{:qty_stk => 0,:remark => "proc update_stk_alloc alloc['allocfree'] == alloc add 1 ",:id => new_alloc[:id]})
			##end
			based_alloc = {}
			based_alloc[:srctblname] = alloc["srctblname"]  ###=trngantts
			based_alloc[:srctblid] = alloc["srctblid"]
			based_alloc[:destblname] = lottrn[:tblname]
			based_alloc[:destblid] = lottrn[:id]
			based_alloc[:allocfree] = "alloc"
			based_alloc[:qty] = 0
			###新規引当て作成
			###   ## 引当てを　schからord  又はordからinstへ　
			based_alloc[:remark] = "proc update_stk_alloc alloc['allocfree'] == alloc nill "
			based_alloc[:qty_stk] = (alloc["qty"] + alloc["qty_stk"])
			based_alloc[:packqty] = if lottrn[:packno] == "dummy" then 0 else lottrn[:qty_stk] end
			proc_alloctbls_update(nil,based_alloc)
		end
		return gantt["qty_stk"] ,based_alloc
	end
	def proc_update_pic_dummy_stk_alloc lottrn,alloc,new_alloc   ### alloc:pu,prd schs,ords,insts alloc   new_alloc:picord_alloc
			###  picords  ===>   元のtrnganntsのtblname tblidの構成の下に
			###  pur,prd schs,ords,insts==>  lotstlhistsの構成の下に
		#based_alloc  = {} ###引当履歴作成
	    ## 変更
		#based_alloc[:remark] = "dummy pic stk 1"
		#based_alloc[:allocfree] = "picords"
		#based_alloc[:allocfreeid] = @picord_id
		#based_alloc[:qty] = @picord_qty_stk
		#based_alloc[:qty_stk] = 0
		#based_alloc[:packqty] = 0
		#	based_alloc[:srctblname] = alloc["srctblname"]
  	#based_alloc[:srctblid] = alloc["srctblid"]
		#based_alloc[:destblname] = alloc["destblname"]
		#based_alloc[:destblid] = alloc["destblid"]
		#proc_alloctbls_update("_add_",based_alloc)
		## 変更
		#based_alloc  = {} ###引当て数減
		#based_alloc[:remark] = "dummy pic stk 2"
		#based_alloc[:qty] = alloc["qty"] - @picord_qty_stk
		#based_alloc[:id] = alloc["id"]
		#proc_alloctbls_update("_edit_",based_alloc)
		##
		#based_alloc  = {} ###
		#based_alloc[:remark] = "dummy pic stk 3"
		#based_alloc[:qty] = 0
		#based_alloc[:qty_stk] = @picord_qty_stk
		#based_alloc[:packqty] = 0
		#based_alloc[:destblname] = "picords"
		#based_alloc[:destblid] = @picord_id
		#based_alloc[:srctblname] = alloc["srctblname"]
		#based_alloc[:srctblid] = alloc["srctblid"]
		#based_alloc[:allocfree] = "alloc"
		#proc_alloctbls_update("_add_",based_alloc)
		##
		based_alloc  = {} ###将来の在庫予定
		##strsql = "select * from alloctbls where srctblname = 'trngantts' and destblname = 'lotstkhists' and destblid = #{lottrn[:id]} and allocfree = 'free' "
		##lot_alloc = ActiveRecord::Base.connection.select_one(strsql)
		strsql = "select * from trngantts where id  = #{alloc["srctblid"]}  "
		trn  = ActiveRecord::Base.connection.select_one(strsql)   ###在庫になる前の元のprdpurshpxxxsのtrngantts
		if trn
			tmp = proc_decision_id_by_key("trngantts"," key = '001' and orgtblname = 'lotstkhists' and  orgtblid= #{lottrn[:id]} ")
				if tmp
					tmp_gantt = {:key=>"001",
						:orgtblname=>"lotstkhists" ,:orgtblid=>lottrn[:id],:mlevel=>1,
						:prjnos_id=>trn["prjnos_id"],
						:itms_id=>trn["itms_id"],:locas_id=>trn["locas_id"],
						:prdpurshp=>trn["prdpurshp"],:processseq=>trn["processseq"],:priority=>trn["priority"],:shuffle_flg=>trn["shuffle_flg"],
						:starttime=>trn["starttime"],:duedate=>trn["duedate"],
						:parenum=>1,:chilnum=>1,:consumtype=>trn["consumtype"],:autoord_p=>"",
						:consumauto=>"",:qty=>trn["qty"],:qty_stk=>trn["qty_stk"],
						:qty_src=>trn["qty"],:depends=>"",:expiredate=>"2099/12/31".to_date,
						:created_at=>Time.now,:updated_at=>Time.now,:remark=>"pic dummy stk ",
						:persons_id_upd=>system_person_id}
						##proc_tbl_add_arel("trngantts",tmp_gantt)
						proc_tbl_edit_arel("trngantts",tmp_gantt," id = #{tmp["id"]} ")
				else
					tmp_gantt = {:id=>proc_get_nextval("trngantts_seq"),:key=>"001",
						:orgtblname=>"lotstkhists" ,:orgtblid=>lottrn[:id],:mlevel=>1,
						:prjnos_id=>trn["prjnos_id"],
						:itms_id=>trn["itms_id"],:locas_id=>trn["locas_id"],
						:prdpurshp=>trn["prdpurshp"],:processseq=>trn["processseq"],:priority=>trn["priority"],:shuffle_flg=>trn["shuffle_flg"],
						:starttime=>trn["starttime"],:duedate=>trn["duedate"],
						:parenum=>1,:chilnum=>1,:consumtype=>trn["consumtype"],:autoord_p=>"",
						:consumauto=>"",:qty=>trn["qty"],:qty_stk=>trn["qty_stk"],
						:qty_src=>trn["qty"],:depends=>"",:expiredate=>"2099/12/31".to_date,
						:updated_at=>Time.now,:remark=>"pic dummy stk ",
						:persons_id_upd=>system_person_id}
						##proc_tbl_add_arel("trngantts",tmp_gantt)
						proc_tbl_add_arel("trngantts",tmp_gantt)
				end
		else
			logger.debug " error class line #{__LINE__} ,not found: table_name = 'trngantts' id = #{alloc["srctblid"]} "
			raise
		end
		based_alloc[:remark] = "dummy pic stk 4"
		based_alloc[:qty] = 0
		based_alloc[:qty_stk] = @picord_qty_stk
		based_alloc[:packqty] = 0
		based_alloc[:destblname] = new_alloc["destblname"]
		based_alloc[:destblid] = new_alloc["destblid"]
		based_alloc[:srctblname] = "trngantts"
		based_alloc[:srctblid] = alloc["srctblid"]
		based_alloc[:allocfree] = "alloc"
		proc_alloctbls_update("_add_",based_alloc)
		based_alloc  = {} ###マイナス在庫の履歴作成  picordsが削除された時用
		based_alloc[:remark] = "dummy pic stk 5"
		based_alloc[:qty] = 0
		based_alloc[:qty_stk] = @picord_qty_stk * -1
		based_alloc[:packqty] = 0
		based_alloc[:destblname] = "lotstkhists"
		based_alloc[:destblid] = lottrn[:id]
		based_alloc[:srctblname] = "trngantts"
		based_alloc[:srctblid] = alloc["srctblid"]
		based_alloc[:allocfree] = "picords"
		based_alloc[:allocfreeid] = @picord_id
		proc_alloctbls_update("_add_",based_alloc)
	end
	def proc_chng_sch_to_stk sch,alloc,lot_free   ###trn:次のテーブル、tblid 　alloc:旧のalloc
		###在庫に引きあたることによって子部品の所要が不要になるが引当て変更はschsの時のみおこなう。、
		based_alloc  = {}
		based_alloc[:remark] = "proc_chng_sch_to_stk "
		##based_alloc[:qty] = 0
		qty = based_alloc[:qty] = if lot_free[:qty_stk] >=alloc["qty"] then 0 else  alloc["qty"] - lot_free[:qty_stk]  end
	    ## 上位ステータスに変更
		based_alloc[:id] = alloc["id"]
		based_alloc[:remark] = "proc_chng_sch_to_stk edit"
		proc_alloctbls_update("_edit_",based_alloc)
		##
		gantt = ActiveRecord::Base.connection.select_one("select * from trngantts where id = #{alloc["srctblid"]}")
		gantt["qty"] -= alloc["qty"]
		gantt["qty_stk"] += alloc["qty"]
		proc_tbl_edit_arel("trngantts",gantt," id = #{alloc["srctblid"]} ")
		##gantt["qty_stk"] += trn[:qty_stk]
		##
		##based_alloc[:persons_id_upd] = system_person_id
		#	based_alloc = alloc.with_indifferent_access.dup
		##based_alloc.with_indifferent_access
		based_alloc = proc_alloc_copy_to_based_alloc(alloc)
		based_alloc[:qty] -= qty
		based_alloc[:allocfree] = sch[:tblname]
		based_alloc[:allocfreeid] = sch[:id]
		based_alloc[:remark] = " proc_chng_sch_to_stk add"
		##proc_tbl_add_arel("alloctbls",based_alloc)
		proc_alloctbls_update("_add_",based_alloc)
		### free_lotstk  から　alloc_lotstkへ
		if alloc["allocfree"] == "alloc"##
			lot_free[:qty_stk] = if lot_free[:qty_stk] <= alloc["qty"] then 0 else   lot_free[:qty_stk] -  alloc["qty"] end
			proc_alloctbls_update("_edit_",{:qty_stk => lot_free[:qty_stk],:remark =>" proc_chng_sch_to_stk  alloc['allocfree'] == 'allloc' edit",:id => lot_free[:id]} )
			####
			##based_alloc = {}
			##based_alloc[:srctblname] = alloc["srctblname"]  ###=trngantts
			##based_alloc[:srctblid] = alloc["srctblid"]
			based_alloc[:destblname] = lot_free[:destblname]
			based_alloc[:destblid] = lot_free[:destblid]
			based_alloc[:allocfree] = "alloc"
			based_alloc[:allocfreeid] = nil
			based_alloc[:packqty] = lot_free[:packqty]
			based_alloc[:remark] = " proc_chng_sch_to_stk  alloc['allocfree'] == 'alloc' nil"
			based_alloc[:qty] = alloc["qty"]
			###新規引当て作成
			###   ## 引当てを　schからord  又はordからinstへ　
			proc_alloctbls_update(nil,based_alloc) do
			%Q%	based_alloc[:qty_stk] += based_alloc[:qty]
				based_alloc[:qty] = 0%
			end
		end
		return lot_free[:qty_stk]
	end
	def proc_reverse_alloc tblname,tblid,qty,qty_stk   ###trn:freeのtrn alloc:引当て要求元　freeを引き当てたいalloc  qty:戻す数
		strsql = "select * from alloctbls where allocfree = '#{destblname}' and allocfreeid = #{destblid} order by id desc "
		bases = ActiveRecord::Base.connection.select_all(strsql)
		bases.each do|base|
			reverse = ActiveRecord::Base.connection.select_one("select * from alloctbls where id = #{base["destblid"]}")
			if qty > base["qty"]
				##proc_tbl_edit_arel("alloctbls",{:qty=>reverse["qty"]+ base["qty"]}," id =  #{reverse["id"]} ")
				##proc_tbl_edit_arel("alloctbls",{:qty=>0}," id =  #{base["id"]} ")
				proc_alloctbls_update("_edit_",{:qty=>reverse["qty"]+ base["qty"],:id =>reverse["id"],:remark=>"proc_reverse_alloc1"} )
				proc_alloctbls_update("_edit_",{:qty=>0,:id =>base["id"],:remark=>"proc_reverse_alloc2"} )
				qty -= base["qty"]
			else
				if qty > 0
					proc_alloctbls_update("_edit_",{:qty=>qty + base["qty"],:id =>reverse["id"],:remark=>"proc_reverse_alloc3"} )
					proc_alloctbls_update("_edit_",{:qty=>base["qty"] - qty,:id =>base["id"],:remark=>"proc_reverse_alloc4"} )
					qty = 0
				end
			end
			if qty_stk > base["qty_stk"]
				proc_alloctbls_update("_edit_",{:qty_stk=>reverse["qty_stk"]+ base["qty_stk"],:id =>reverse["id"],:remark=>"proc_reverse_alloc5"} )
				proc_alloctbls_update("_edit_",{:qty_stk=>0,:id =>base["id"],:remark=>"proc_reverse_alloc6"} )
				qty_stk -= base["qty_stk"]
			else
				if  qty_stk >0
					proc_alloctbls_update("_edit_",{:qty_stk=>qty_stk + base["qty_stk"],:id =>reverse["id"],:remark=>"proc_reverse_alloc7"} )
					proc_alloctbls_update("_edit_",{:qty_stk=>base["qty_stk"] - qty_stk,:id =>base["id"],:remark=>"proc_reverse_alloc8"} )
					qty_stk = 0
				end
			end
		end
	end
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
				@opeitm_id = proc_get_opeitms_rec(@itm_id,@loca_id,processseq = nil,priority = nil)["id"]
			else
				logger.debug " error class line #{__LINE__} ,@opeitm_id not found:#{rec} "
				raise
			end
			if @loca_id.nil?
				logger.debug " line #{__LINE__} ,@opeitm_id not found:#{rec} "
			end
		end
		@bgantts["000"] = {:mlevel=>0,
							:opeitms_id=>@opeitm_id,:duration=>0,
							:itms_id=>@itm_id,
							#####:itm_id=>@itm_id,:itm_code=>@itm_code,:itm_name=>@itm_name,
							:locas_id=>@loca_id,
							#####:loca_id=>@loca_id,:loca_code=>@loca_code,:loca_name=>@loca_name,
							:processseq=>999,:priority=>eval("@#{tblchop}_priority||=999"),:prdpurshp=>"",
							:duedate=>eval("@#{tblchop}_duedate"),:starttime=>eval("@#{tblchop}_starttime"),
							:autocreate_ord=>@opeitm_autocreate_ord,:autocreate_inst=>"",:autoord_p=>"",
							:autocreate_act=>"",:autoact_p=>"",
							:qty=>eval("@#{tblchop}_qty"),:qty_src=>eval("@#{tblchop}_qty_src"),:qty_stk=>0,
							:depends=>""}
		@bgantts["000"][:duration] = (@bgantts["000"][:duedate].to_date - @bgantts["000"][:starttime].to_date).to_i
		@bgantts["000"][:duration] = 1 if @bgantts["000"][:duration] < 1
	    ngantts = []
		r0 =  ActiveRecord::Base.connection.select_one("select * from  opeitms where id = #{@bgantts["000"][:opeitms_id]} ")
		if @loca_id_to != r0["locas_id"]
			cnt += 2
			auto_cust = ActiveRecord::Base.connection.select_one("select * from  custrcvplcs where locas_id_custrcvplc = #{@loca_id_to} ")
			if auto_cust.nil?
				logger.debug " line #{__LINE__} ,loca_id_to:#{@loca_id_to}"
				raise
			end
			@bgantts["001"] = {:seq=>"001",:mlevel=>1,
						:itms_id=>@itm_id,
						:locas_id=>@loca_id_to,
						:processseq=>(r0["processseq"]+1),:priority=>r0["priority"],:prdpurshp=>"dlv",
						:autocreate_ord=>auto_cust["autocreate_ord"],:autocreate_inst=>auto_cust["autocreate_inst"],
						:autoord_p=>auto_cust["autoord_p"],
						:duedate=>eval("@#{tblchop}_duedate"),:id=>"001",
						:qty=>eval("@#{tblchop}_qty||=0"),:qty_src=>eval("@#{tblchop}_qty_src"),:qty_stk=>eval("@#{tblchop}_qty_stk||=0"),
						:duration=>proc_get_duration_by_loca(eval("@#{tblchop}_loca_id_fm"),eval("@#{tblchop}_loca_id_to"),nil)[:duration],
					:opeitms_id=>r0["id"]} ###,
						###:subtblid=>"opeitms_"+r0["id"].to_s,:opeitms_id=>r0["id"]}
			@bgantts["001"][:starttime] = proc_get_starttime(@bgantts["001"][:duedate],(@bgantts["001"][:duration]) ,"day",nil)
			ngantts << {:seq=>"002",:mlevel=>2,
					:itms_id=>r0["itms_id"],
					:locas_id=>r0["locas_id"],
					:processseq=>r0["processseq"],:priority=>r0["priority"],:prdpurshp=>"pic",
					:autocreate_ord=>auto_cust["autocreate_ord"],:autocreate_inst=>auto_cust["autocreate_inst"],:shuffle_flg=>r0["shuffle_flg"],
					:autoord_p=>auto_cust["autoord_p"],
					:duedate=>@bgantts["001"][:starttime],:id=>"002",
					:qty=>eval("@#{tblchop}_qty||=0"),:qty_src=>eval("@#{tblchop}_qty_src"),:qty_stk=>eval("@#{tblchop}_qty_stk||=0"),:duration=>(r0["duration"]||=1),
					:opeitms_id=>r0["id"]} ###,
					###:subtblid=>"opeitms_"+r0["id"].to_s,:opeitms_id=>r0["id"]}
		else
            cnt += 1
			ngantts << {:seq=>"001",:mlevel=>1,
					:itms_id=>@itm_id,
					:locas_id=>@loca_id,
					:processseq=>(r0["processseq"]),:priority=>(r0["priority"]),:prdpurshp=>r0["prdpurshp"],
					:autocreate_ord=>r0["autocreate_ord"],:autoord_p=>r0["autoord_p"],:autocreate_inst=>r0["autocreate_inst"],
					:shuffle_flg=>r0["shuffle_flg"],
					:duedate=>eval("@#{tblchop}_duedate"),:id=>"001",
					:qty=>eval("@#{tblchop}_qty"),:qty_src=>eval("@#{tblchop}_qty_src"),:qty_stk=>eval("@#{tblchop}_qty_stk||=0"),
					:duration=>proc_get_duration_by_loca(eval("@#{tblchop}_loca_id_fm"),eval("@#{tblchop}_loca_id_to"),nil)[:duration],
					:opeitms_id=>r0["id"]} ###,
					####:subtblid=>"opeitms_"+r0["id"].to_s,:opeitms_id=>r0["id"]}
		end
        until ngantts.size == 0
            cnt += 1
            ngantts = proc_get_tree_pare_itms_locas ngantts,"gantttrn"
             break if cnt >= 10000
        end
        @bgantts["000"][:starttime] = if @min_time < Time.now then Time.now else @min_time end
        prv_resch_trn  ####再計算
        @bgantts["000"][:duedate] = @bgantts["001"][:duedate]
        @bgantts["000"][:duration] = " #{(@bgantts["000"][:duedate]  - @bgantts["000"][:starttime] ).divmod(24*60*60)[0]}"
	    tmp_gantt = {}
		sio_classname = "trngantts_add_"
        @bgantts.sort.each  do|key,value|   ###依頼されたオーダ等をopeitms,nditmsを使用してgantttableに展開
			tmp_gantt = value.dup
			tmp_gantt.merge!({:id=>proc_get_nextval("trngantts_seq"),:key=>key,
								:orgtblname=>tblchop+"s",:orgtblid=>eval("@#{tblchop}_id"),
								:prjnos_id=>eval("@#{tblchop}_prjno_id"),
								:expiredate=>"2099/12/31".to_date,
								:created_at=>Time.now,:updated_at=>Time.now,:remark=>"auto_created_by perform_mkbttables ",
								:persons_id_upd=>system_person_id})
		    #Trngantt.create tmp_gantt
			tmp_gantt.delete(:seq)
			tmp_gantt.delete(:opeitms_id)
			tmp_gantt.delete(:starttime_est)
			tmp_gantt.delete(:duedate_est)
			proc_tbl_add_arel("trngantts",tmp_gantt)
			proc_create_prdpurshp_alloc(tmp_gantt[:id],sio_classname)
		end
		proc_sch_chil_get(tblchop+"s",eval("@#{tblchop}_id"))
	end
	def proc_get_duration_by_loca(loca_id_fm,loca_id_to,priority)
		{:duration=>1,:transport_id =>ActiveRecord::Base.connection.select_value("select id from transports where code = 'dummy' ")}
	end
	def proc_alloctbls_update(sio_classname,based_alloc)
		if sio_classname.nil?
			strsql = "select id,qty,qty_stk,destblname,	destblid
							from alloctbls where srctblname = '#{based_alloc[:srctblname]}' and srctblid = #{based_alloc[:srctblid]} and
							destblname = '#{based_alloc[:destblname]}' and destblid = #{based_alloc[:destblid]} and
                            allocfree = '#{based_alloc[:allocfree]}'"
			rec = ActiveRecord::Base.connection.select_one(strsql)
			if  rec
				based_alloc[:id] = rec["id"]
				based_alloc[:qty] ||=  rec["qty"]
				based_alloc[:qty_stk] ||= rec["qty_stk"]
				based_alloc[:packqty] ||= rec["packqty"]
				based_alloc[:destblname] ||= rec["destblname"]
				based_alloc[:destblid] ||= rec["destblid"]
				sio_classname = "_edit_"
			else
				sio_classname = "_add_"
				based_alloc[:qty] ||=  0
				based_alloc[:qty_stk] ||= 0
				based_alloc[:packqty] ||= 0
			end
		end
		eval(yield) if block_given?
		based_alloc[:updated_at] = Time.now
		case sio_classname
			when /_add/
				if based_alloc[:allocfree].nil?
					logger.debug"error class #{Time.now}  based_alloc:#{based_alloc} "
                 	raise
				end
				based_alloc[:persons_id_upd] = system_person_id
				based_alloc[:expiredate] = "2099/12/31".to_date
				based_alloc[:created_at] = Time.now
				based_alloc[:id] = proc_get_nextval "alloctbls_seq"
				proc_tbl_add_arel("alloctbls",based_alloc)
				proc_decide_alloc_inout(based_alloc.with_indifferent_access)
			when /_edit_|_delete/
				if based_alloc[:id]
					old_alloc = ActiveRecord::Base.connection.select_one("select * from alloctbls where id = #{based_alloc[:id]} order by updated_at desc")
					old_alloc["qty"] = old_alloc["qty"] * -1
					old_alloc["qty_stk"] = old_alloc["qty_stk"] * -1
					if sio_classname =~ /_delete/
						based_alloc[:qty] = based_alloc[:qty_stk] = 0
					end
					##based_alloc[:id] = old_alloc["id"]
					based_alloc[:srctblname] = old_alloc["srctblname"]
					based_alloc[:srctblid] = old_alloc["srctblid"]
					based_alloc[:destblname] = old_alloc["destblname"]
					based_alloc[:destblid] = old_alloc["destblid"]
					based_alloc[:allocfree] = old_alloc["allocfree"]
					based_alloc[:allocfreeid] = old_alloc["allocfreeid"]
					based_alloc[:persons_id_upd] = system_person_id
					proc_tbl_edit_arel("alloctbls",based_alloc," id = #{old_alloc["id"]}")
					if  old_alloc["qty"] != 0 or  old_alloc["qty_stk"] != 0
						proc_decide_alloc_inout(based_alloc.with_indifferent_access) do
							"rty"
						end
					end
					based_alloc[:qty] = old_alloc["qty"]
					based_alloc[:qty_stk] = old_alloc["qty_stk"]
					###proc_tbl_add_arel("alloctbls",based_alloc)
					proc_decide_alloc_inout(based_alloc.with_indifferent_access)do
					  "rvs"
					end
				else
					logger.debug"error class #{Time.now}  based_alloc:#{based_alloc} "
					raise
				end
		end
	end
	def proc_ord_inst_qty_chng tblname,tblid,qty
		strsql = "select sum(qty) from alloctbls where srctblname = 'trngantts' and
							destblname = '(#{tblname}' and destblid = #{tblid}
							group by srctblname,destblname,destblid for update"

	end
	def proc_create_prdpurshp_alloc(trn_id,sio_classname)  ##
		str_gantt_sch = ActiveRecord::Base.connection.select_one(" select * from r_trngantts where id = #{trn_id} ")
		qty = str_gantt_sch["trngantt_qty"]
		qty_stk = str_gantt_sch["trngantt_qty_stk"]
		str_gantt_sch[:sio_viewname] = "r_trngantts"
		str_gantt_sch[:sio_classname] = sio_classname
		str_gantt_sch[:sio_code] = "r_trngantts"
		proc_command_instance_variable(str_gantt_sch) ### trnganttsはproc_update_tableを使用してない。
		if str_gantt_sch["trngantt_key"] ==  "000"
			alloc= {}
			alloc[:remark] = "proc_create_prdpurshp_alloc . key = '000'"
			alloc[:qty] = @trngantt_qty
			alloc[:qty_stk] = @trngantt_qty_stk
			alloc[:packqty] = 0
			alloc[:srctblname] = "trngantts"
			alloc[:destblname] = @trngantt_orgtblname
			alloc[:srctblid] = @trngantt_id
			alloc[:destblid] = @trngantt_orgtblid
			alloc[:allocfree] = "alloc"
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
	def proc_edit_chil_req_qty_from_trngantts c_alloc,qty ##trn   #proc update_stk_allocで対象のtrnganttのqty_stkは修正済
		###在庫に引きあったとき、その子部品の引当てをなくす  c_alloc実際に在庫にあったalloctbls
		###子部品の完成の前に親か完成すると、子部品のfreeが発生する。 完成とか受入時は子部品のfree移動はしない。(未実施)
		strsql = %Q& select gantt.*,
					alloc.id alloc_id,alloc.qty alloc_qty,alloc.qty_stk alloc_qty_stk,alloc.destblname alloc_destblname,alloc.destblid alloc_destblid,
					trngantt_qty,trngantt_qty_stk,
					case when alloc.destblname like '%schs' then 1
					     when alloc.destblname like '%ords' then 2
						 when alloc.destblname like '%insts' then 3
						 when alloc.destblname like 'lot%' then 5 end tblsortkey   ---在庫は残す
					from r_trngantts gantt inner join  alloctbls alloc
					on alloc.srctblname = 'trngantts' and gantt.id = alloc.srctblid
					where trngantt_orgtblname = '#{c_alloc["trngantt_orgtblname"]}' and trngantt_orgtblid = #{c_alloc["trngantt_orgtblid"]}
					and trngantt_key like  '#{c_alloc["trngantt_key"]}%'
					and (alloc.qty > 0 or alloc.qty_stk > 0)   and alloc.allocfree in('alloc')
					---- and (alloc.destblname like '%schs' or  alloc.destblname like '%ords' or alloc.destblname like '%insts'  or alloc.destblname like 'lot%')
					order by    trngantt_orgtblname, trngantt_orgtblid,trngantt_key,tblsortkey,alloc.destblid
				&
		### trngantt : alloctbl  = 1:n
		gantt_allocs = ActiveRecord::Base.connection.select_all(strsql)
		pre_gantt_id = gantt_allocs[0]["trngantt_id"]  if gantt_allocs[0]
		##save_gantt_id = 0
		##alloc ={}
		newgantt = {}
		pare_gantt ={}
		gantt_allocs.each do |gantt_alloc|
			if  pare_gantt[gantt_alloc["trngantt_key"]].nil?
				pare_gantt[gantt_alloc["trngantt_key"]] = {}
				pare_gantt[gantt_alloc["trngantt_key"]]["qty"] = gantt_alloc["trngantt_qty"]  ### 既に親の残りの必要数はproc_chng_sch_to_stkで計算されている。
			end
			pare_key = if gantt_alloc["trngantt_key"].size > 3 then	gantt_alloc["trngantt_key"][0..-4]	else sprintf("%03d",(gantt_alloc["trngantt_key"].to_i - 1)) end
			if pare_gantt[pare_key]
				new_qty = pare_gantt[pare_key]["qty"] * gantt_alloc["trngantt_chilnum"] / gantt_alloc["trngantt_parenum"]
				if gantt_alloc["trngantt_qty_stk"] >= new_qty
					trngantt_qty = 0
					trngantt_qty_stk = new_qty
				else
					new_qty -= gantt_alloc["trngantt_qty_stk"]
					trngantt_qty = new_qty
					trngantt_qty_stk = gantt_alloc["trngantt_qty_stk"]
				end
				proc_tbl_edit_arel("trngantts",{:qty=>trngantt_qty ,:qty_stk=>trngantt_qty_stk}," id = #{gantt_alloc["trngantt_id"]} ")
				case gantt_alloc["alloc_destblname"]
					when  /schs$/
						proc_alloctbls_update("_edit_",{:qty=>trngantt_qty,:remark=> "proc_edit_from_trngantts",:id =>gantt_alloc["alloc_id"]})
						proc_tbl_edit_arel(gantt_alloc["alloc_destblname"],{:qty=>trngantt_qty}," id = #{gantt_alloc["alloc_destblid"]} ")
					when  /ords$|insts$|lotstkhist/
					proc_alloc_to_free(trngantt_qty,trngantt_qty_stk,gantt_alloc) ###alloc_qty まだ引当てされている数量　　　gantt_allc:freeになる前の引当て情報
				end
			end
		end
	end

	def proc_edit_trngantts_by_prdpurshp_qty tblchop,tblid   #  例えばpurordsのqtyが変更された時callされる。  数量増は認めない。
		strsql = %Q& select sum(qty) maxqty from  alloctbls alloc
					where destblname = '#{tblchop}s'  and   destblid = #{tblid}
					and alloc.qty > 0 and alloc.allocfree in('free','alloc')
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
				proc_alloctbls_update("_edit_",{:qty=>gantt_alloc["alloc_qty"],:id =>gantt_alloc["alloc_id"],:remark=>"proc_edit_trngantts_by_prdpurshp_qty" })
				proc_reverse_alloc(tblchop+"s",tblid,save_qty - qty,0)
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
				newgantt[:qty_stk] = 0
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
				newgantt[:qty_stk] = 0
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
						proc_alloctbls_update("_edit_",{:qty=>qty,:id => alloc["id"],:remrk=>"proc_edit_gantt_alloc_by_trn"})
						proc_reverse_alloc(gantt["trngantt_destblname"],gantt["trngantt_destblid"],alloc["qty"] - qty,0)
						qty = 0
					end
				end
			end
		end
	end
	def proc_update_gantt_schs(gantt,newgantt)
	raise ##使用してない　　使用しているときはqtyとqty_stkを再チェック
	end
	def proc_update_trangantts(id,newgantt,gantt_alloc)  ### id = trngantt_id
		strsql = %Q& select * from opeitms where itms_id = #{gantt_alloc["trngantt_itm_id"]} and locas_id = #{gantt_alloc["trngantt_loca_id"]} and processseq = #{gantt_alloc["trngantt_processseq"]} &
		opeitm = ActiveRecord::Base.connection.select_one(strsql)
		newgantt[:starttime] =  proc_get_starttime(newgantt[:duedate], (opeitm["duration"]||=1),"day",nil)  ###稼働日考慮に  ###starttimeと合わすこと。
		newgantt[:amt] = newgantt[:qty] * (gantt_alloc["trngantt_price"]||=0)
		proc_tbl_edit_arel("trngantts",newgantt," id = #{id} ")
		return
	end
	def proc_alloc_to_free(qty,qty_stk,gantt_alloc)  ###qty,qty_stk まだ引当てされている数量　　　gantt_allc:freeになる前の引当て情報
		strsql = "select alloctbls.* from alloctbls ,trngantts where orgtblname = '#{gantt_alloc["alloc_destblname"]}' and orgtblid =  #{gantt_alloc["alloc_destblid"]}
						 and key = '000' and trngantts.id = srctblid
						and srctblname = 'trngantts' and destblname = '#{gantt_alloc["alloc_destblname"]}'"
		free_alloc =  ActiveRecord::Base.connection.select_one(strsql)
		based_alloc  = {}
		based_alloc[:remark] = "alloc to free "
		based_alloc[:qty_stk] = gantt_alloc["alloc_qty_stk"] - qty_stk   ###free　で残る数
		based_alloc[:qty] = gantt_alloc["alloc_qty"] - qty  ###free　で残る数
		based_alloc[:id] =  gantt_alloc["alloc_id"]
		based_alloc[:remark] = "proc_alloc_to_free edit"
		proc_alloctbls_update("_edit_",based_alloc)
		qty_stk += free_alloc["qty_stk"]
		qty += free_alloc["qty"]
		proc_alloctbls_update("_edit_",{:qty =>qty,:qty_stk=>qty_stk,:id =>free_alloc["id"],:remark => "proc_alloc_to_free not lotstk"})
	end
	def proc_create_or_replace_alloc_by_same_tbl trn,alloc   ###xxxords,xxxinsts,lotstkhistsそのものが数量変更された時 alloc 新しい引当て
		case trn[:sio_classname]
			when /_add_/
				alloc[:remark] = "proc_create_or_replace_alloc_by_same_tbl add"
				proc_alloctbls_update("_add_",alloc)
			when /_edit_|_delete_/
				strsql = %Q& select * from alloctbls where srctblname = 'trngantts' and destblname = '#{alloc[:destblname]}'
							and destblid = #{alloc[:destblid]} order by id desc &
				c_allocs = ActiveRecord::Base.connection.select_all(strsql)
				if c_allocs.size == 0 ##logic error
				   logger.debug "strsql = #{strsql}"
				end
				qty = 0
				qty_stk = 0
				alloc[:qty] = 0 if @sio_classname =~ /_delete_/
				alloc[:qty_stk] = 0 if @sio_classname =~ /_delete_/
				c_allocs.each do |c_alloc|
					if alloc[:qty] < qty + c_alloc["qty"]
						c_alloc["qty"] = if (alloc[:qty] - qty) > 0 then alloc[:qty] - qty  else 0 end
						proc_alloctbls_update("_edit_",{:qty=>c_alloc["qty"],:id => c_alloc["id"],:remark => "proc_create_or_replace_alloc_by_same_tbl 1 "})
						##proc_tbl_edit_arel("alloctbl" ,{:qty=>c_alloc["qty"]}," id = #{c_alloc["id"]}")
						proc_return_alloc c_alloc
					end
					if alloc[:qty_stk] < qty_stk + c_alloc["qty_stk"]
						c_alloc["qty_stk"] = if (alloc[:qty_stk] - qty_stk) > 0 then alloc[:qty_stk] - qty_stk  else 0 end
						proc_alloctbls_update("_edit_",{:qty=>c_alloc["qty_stk"],:id => c_alloc["id"],:remark => "proc_create_or_replace_alloc_by_same_tbl 2 "})
						##proc_tbl_edit_arel("alloctbl" ,{:qty_stk=>c_alloc["qty_stk"]}," id = #{c_alloc["id"]}")
						proc_return_alloc c_alloc
					end
					qty += c_alloc["qty"]
					qty_stk += c_alloc["qty_stk"]
				end
				if alloc[:qty] > qty  ###数量増された時 在庫の増はない。
					strsql = %Q& select alloctbls.id id,alloctbls.qty qty from trngantts,alloctbls where trngantts.orgtblname = '#{alloc[:destblname]}'
									and trngantts.orgtblid = #{alloc[:destblid]} and trngantts.key = '001'
									and alloctbls.srctblname = 'trngantts' and trngantts.id = alloctbls.srctblid
									and alloctbls.destblname = '#{alloc[:destblname]}' and alloctbls.destblid = #{alloc[:destblid]}  &
					free_alloc = ActiveRecord::Base.connection.select_one(strsql)
					proc_alloctbls_update("_edit_",{:qty=>alloc[:qty] - qty + free_alloc["qty"],:id => free_alloc["id"],:remark => "proc_create_or_replace_alloc_by_same_tbl 3 "})
					##proc_tbl_edit_arel("alloctbl" ,{:qty=>alloc[:qty] - qty + free_alloc["qty"]}," id = #{free_alloc["id"]}")
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
		strsql = %Q&  select * from alloctbls where srctblname = '#{c_alloc["destblname"]}' and srctblid = #{c_alloc["destblid"]} and (qty > 0 or qty_stk > 0)
												and destblname = 'alloctbls'　
												and destblid in (select id from alloctbls where srctblname = 'trngantts' and srctblid = #{c_alloc["srctblid"]}
																							and destblname ='#{pre_destblname}')&
		rtn_alloc = ActiveRecord::Base.connection.select_one(strsql)
		if rtn_alloc.nil?
		   logger.debug " logic error"
           logger.debug " strsql = #{strsql}"
		end
		proc_tbl_edit_arel("alloctbl" ,{:qty=>rtn_alloc["qty"] - c_alloc["qty"],:qty_stk=>rtn_alloc["qty_stk"] - c_alloc["qty_stk"]}," id = #{rtn_alloc["destblid"]} " )
		proc_tbl_edit_arel("alloctbl" ,{:qty=>c_alloc["qty"],:qty_stk=>c_alloc["qty_stk"]}," id = #{rtn_alloc["id"]}" )
	end
	def proc_save_trn_of_opeitm trn  ##複数の品目の時、内容が変わってしまうのでsaveした。
		yield
		trn[:sio_classname] = @sio_classname
		if  @opeitm_id   ###pic,dlvは親でprocessseq等をセット
			trn[:prdpurshp] ||= @opeitm_prdpurshp
			trn[:stktaking_f] =@opeitm_stktaking_f
			trn[:packqty] =  if (@opeitm_packqty ||=0) == 0 then 0 else @opeitm_packqty end
			trn[:priority] = @opeitm_priority
			trn[:processseq] = @opeitm_processseq
			trn[:shuffle_flg] = @opeitm_shuffle_flg
			trn[:packno_flg] = @opeitm_packno_flg
		end
		trn[:processseq_pare] = eval("@#{trn[:tblname].chop}_processseq_pare")
		trn[:itms_id] = @itm_id
		trn[:locas_id] = @loca_id
		trn[:locas_id_to] = eval("@#{trn[:tblname].chop}_loca_id_to")
		trn[:id] = eval("@#{trn[:tblname].chop}_id")
		trn[:qty] = eval("@#{trn[:tblname].chop}_qty||=0")
		trn[:qty_stk] = eval("@#{trn[:tblname].chop}_qty_stk||=0")
		trn[:prjnos_id] = eval("@#{trn[:tblname].chop}_prjno_id")
		trn[:starttime] = eval("@#{trn[:tblname].chop}_starttime")
		trn[:depdate] = eval("@#{trn[:tblname].chop}_depdate")
		trn[:lotno] = eval("@#{trn[:tblname].chop}_lotno||='dummy'")
		trn[:packno] = eval("@#{trn[:tblname].chop}_packno||='dummy'")
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
		lot_qty_stk = []
		strsql = " select aprev.destblname destblname ,aprev.destblid destblid,aprev.qty_stk alloc_qty_stk,shp.trngantt_processseq pare_processseq
					from alloctbls aprev,r_trngantts prev,alloctbls ashp, r_trngantts shp
					where aprev.srctblname = 'trngantts' and  aprev.srctblid = prev.trngantt_id
					and ashp.srctblname = 'trngantts' and  ashp.srctblid = shp.trngantt_id
					and prev.trngantt_orgtblname = shp.trngantt_orgtblname and prev.trngantt_orgtblid = shp.trngantt_orgtblid
					and shp.trngantt_key = substr(prev.trngantt_key,1,(length(prev.trngantt_key)-3)) and prev.itm_id = shp.itm_id
					and ashp.destblname = '#{trn[:tblname]}' and ashp.destblid = #{trn[:id]} and aprev.qty_stk >0 "
		prevs =  ActiveRecord::Base.connection.select_all(strsql)
		prevs.each do |prev|
			strsql = %Q& select '#{prev["destblname"]}' tblname,
						#{case  prev["destblname"]
							when "lotstkhists"
								"lotstkhist_lotno lotno,lotstkhist_packno packno,lotstkhist_loca_id locas_id,lotstkhist_itm_id itms_id ,lotstkhist_stktaking_f stktaking_f"
							when /^pic/
								"#{prev["destblname"].chop}_lotno lotno,#{prev["destblname"].chop}_packno packno,#{prev["destblname"].chop}_loca_id locas_id,
								#{prev["destblname"].chop}_itm_id itms_id ,#{prev["destblname"].chop}_stktaking_f stktaking_f "
							else
								"'dummy' lotno,'dummy' packno , opeitm_itm_id itms_id ,sno  "
							end },
						#{prev["alloc_qty_stk"]} qty_stk
						from  r_#{prev["destblname"]} where id = #{prev["destblid"]} &
			lotstk = ActiveRecord::Base.connection.select_one(strsql)
			next if (lotstk["stktaking_f"] == "0" or (lotstk["stktaking_f"].nil?) and  prev["destblname"] =~ /lotstkhists|^pic/)
			lot_qty_stk << [lotstk["lotno"],lotstk["qty_stk"],1,lotstk["tblname"],lotstk["packno"],lotstk["itms_id"],prev["pare_processseq"],lotstk["sno"]]
		end
		return lot_qty_stk
	end
	def sql_proc_chng_lot_to_pic(trn,sql_param)
		" select aprev.alloctbl_id id, alloctbl_srctblname srctblname,alloctbl_destblname destblname,
					alloctbl_srctblid srctblid,alloctbl_destblid destblid,alloctbl_allocfree allocfree,alloctbl_packqty packqty,
					alloctbl_qty qty,alloctbl_qty_stk qty_stk,shp.trngantt_loca_id  shp_loca_id,shp.trngantt_processseq shp_trngantt_processseq,
					ashp.destblname shp_tblname,ashp.destblid shp_tblid
					from r_alloctbls aprev,r_trngantts prev,alloctbls ashp, r_trngantts shp
					where aprev.alloctbl_srctblname = 'trngantts' and  aprev.alloctbl_srctblid = prev.trngantt_id
					and ashp.srctblname = 'trngantts' and  ashp.srctblid = shp.trngantt_id
					and prev.trngantt_orgtblname = shp.trngantt_orgtblname and prev.trngantt_orgtblid = shp.trngantt_orgtblid
					and shp.trngantt_key = substr(prev.trngantt_key,1,(length(prev.trngantt_key)-3)) and prev.itm_id = shp.itm_id
					and ashp.destblname = '#{trn[:tblname]}' and ashp.destblid = #{trn[:id]}
					and #{sql_param}
					and  aprev.alloctbl_allocfree = 'alloc' "
	end
	def proc_already_use_packno(prev,trn)
		proc_alloc_to_sch(prev,0,0)
		free_trn_strwhere = " and trngantt_itm_id = #{@lotstkhist_itm_id} and trngantt_processseq = #{@lotstkhist_processseq}
						and alloctbl_destblname = 'lotstkhists'
						and alloctbl_destblid in(select id from lotstkhists where itms_id = #{@lotstkhist_itm_id}
						and processseq = #{@lotstkhist_processseq}
						and locas_id = #{@lotstkhist_loca_id} and qty_stk >= #{prev["qty_stk"]}) "
		trg_trn_strwhere = " and trngantt_id = #{prev["srctblid"]} and alloctbl_srctblname = 'trngantts' 	"
		proc_free_to_alloc("","",free_trn_strwhere,trg_trn_strwhere)
		strsql = "select * from alloctbls where srctblname = 'trngantts' and srctblid = #{prev["srctblid"]}
								and destblname = 'lotstkhists' and allocfree = 'alloc' and qty_stk = #{prev["qty_stk"]} "
		new_lot = ActiveRecord::Base.connection.select_one(strsql)
		if new_lot
			strsql = %Q& select * from  r_lotstkhists  where id = #{new_lot["destblid"]} &
			proc_command_instance_variable(ActiveRecord::Base.connection.select_one(strsql))
			true
		else   ###一リールが複数に引きあたっているとき　空きがない。
			strsql = "select * from alloctbls where srctblname = 'trngantts' and destblname = '#{trn[:tblname]}' and destblid = #{trn[:id]} "
			rds = ActiveRecord::Base.connection.select_one(strsql)
			ords.each do |ord|
				proc_alloc_to_sch(ord,0,0)
			end
			false
		end
	end
	def proc_chng_lot_to_pic(trn)  ###trn :shpxxxs or dlvxxxs
		lot_qty_stk = []
		prevs =  ActiveRecord::Base.connection.select_all(sql_proc_chng_lot_to_pic(trn," aprev.alloctbl_qty_stk > 0 "))
		tmp_trn ={}
		##realloc = {}
		ary = []
		save_tblname = ""
		save_tblid = save_qty_stk = save_id = 0
		alloc = {}
		prevs.each do |prev|
			strsql = %Q& select * from  r_lotstkhists  where id = #{prev["destblid"]} &
			proc_command_instance_variable(ActiveRecord::Base.connection.select_one(strsql))
			###allocs = []
			alloc = proc_alloc_copy_to_based_alloc(prev)
			proc_decision_id_by_key("picords"," orgtblname = #{prev["shp_tblname"]} and  orgtblid = #{prev["shp_tblid"]} and
												lotno = '#{@lotstkhist_lotno}' and packno =  '#{@lotstkhist_packno}'   and shelfnos_id = #{@lotstkhist_shelfno_id} ")
			if save_tblname != alloc[:destblname] or save_tblid != alloc[:destblid]
				if save_tblname != ""  ###lotstkhists:picords= 1:1
					if  @lotstkhist_packno !~ /dummy/
						if 	@lotstkhist_qty_stk == 0  ###他のallocで使用され、別の場所に移動された。
							next if proc_already_use_packno(prev,trn) == false
						end
						alloc[:packqty] = @lotstkhist_qty_stk
						__send__("proc_fld_alloctbls_lotstkhists_picords_self10") do
								###{:picord_qty_stk=> @lotstkhist_qty_stk,:picord_packqty=> alloc[:packqty]} #
								{:picord_qty_stk=> save_qty_stk,:picord_packqty=> ary[0][:packqty]} #
						end
					else
						__send__("proc_fld_alloctbls_lotstkhists_picords_self10") do
							###{:picord_qty_stk=> prev["qty_stk"],:picord_packqty=> 0}
							{:picord_qty_stk=> save_qty_stk ,:picord_packqty=> 0}
						end
					end
					proc_save_trn_of_opeitm(tmp_trn) do
						tmp_trn[:tblname] = "picords"
					end
					proc_update_gantt_alloc_fm_trn tmp_trn,[alloc] ,nil
					rec =  proc_decision_id_by_key("inouts","  alloctbls_id_inout = #{prev["id"]} and locas_id = #{@picord_loca_id} and
												lotno = '#{@picord_lotno}' and
												-----processseq = #{@picord_processseq}  and
　　　　　　　　　　　　　packno =  '#{@picord_packno}'   and  inoutflg = 'out' ")
					strsql = "select * from alloctbls where srctblname = 'trngantts' and destblname = 'picords' and destblid = #{@picord_id} and allocfree  in('alloc' ,'free') "
					alloc = ActiveRecord::Base.connection.select_one(strsql)
					proc_fld_r_picords_inouts_self10 do
						{:id =>rec["id"],:inout_inoutflg=>"out",:inout_alloctbl_id_inout=>alloc["id"],:inout_trngantt_id_inout=>alloctbl["srctblid"]}
					end
				end
				save_tblname = alloc[:destblname]
				save_tblid = alloc[:destblid]
				save_qty_stk = eval("@#{prev["destblname"].chop}_qty_stk")
				ary =  [alloc]
			else
				ary << alloc
				save_qty_stk += eval("@#{prev["destblname"].chop}_qty_stk")
			end
		end
		if prevs.size > 0
			if  eval("@#{save_tblname.chop}_packno") !~ /dummy/
				if 	@lotstkhist_qty_stk == 0  ###他のallocで使用され、別の場所に移動された。
					if proc_already_use_packno(prevs[-1],trn)
						alloc[:packqty] = eval("@#{save_tblname.chop}_qty_stk")
						__send__("proc_fld_alloctbls_#{alloc[:destblname]}_picords_self10") do
							{:picord_qty_stk=> eval("@#{save_tblname.chop}_qty_stk"),:picord_packqty=> alloc[:packqty]} #
						end
					end
				else
					alloc[:packqty] = eval("@#{save_tblname.chop}_qty_stk")
					__send__("proc_fld_alloctbls_#{alloc[:destblname]}_picords_self10") do
							{:picord_qty_stk=> eval("@#{save_tblname.chop}_qty_stk"),:picord_packqty=> alloc[:packqty]} #
					end
				end
			else
				proc_save_trn_of_opeitm(tmp_trn) do
					tmp_trn[:tblname] = "picords"
				end
				proc_update_gantt_alloc_fm_trn tmp_trn,ary,nil
				rec =  proc_decision_id_by_key("inouts","  alloctbls_id_inout = #{prev["id"]} and  locas_id = #{@picord_loca_id} and
												lotno = '#{@picord_lotno}' and
												----- processseq = #{@picord_processseq}  and
　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　packno =  '#{@picord_packno}'   and
                                               inoutflg = 'out' ")
			  strsql = "select * from alloctbls where srctblname = 'trngantts' and destblname = 'picords' and destblid = #{@picord_id} and allocfree  in('alloc' ,'free') "
				alloc = ActiveRecord::Base.connection.select_one(strsql)
				proc_fld_r_picords_inouts_self10 do
					{:id =>rec["id"],:inout_inoutflg=>"out",:inout_alloctbl_id_inout=>alloc["id"],:inout_trngantt_id_inout=>alloc["srctblid"]}
				end
			end
			#proc_realloc_lotstkhists realloc
			###在庫の時の処理終了
		else
			prevs =  ActiveRecord::Base.connection.select_all(sql_proc_chng_lot_to_pic(trn," aprev.alloctbl_qty > 0 "))
			prevs.each do |prev|
				add_fields = {}
				strsql = %Q& select * from  r_#{prev["destblname"]} where id = #{prev["destblid"]} &
				proc_command_instance_variable(ActiveRecord::Base.connection.select_one(strsql))
				###在庫がないのに出庫のオーダ作成時は、マイナスのfree在庫を発生さす。　　lot指定　packno指定の時は、在庫になった時入った順序で自動消費される。在庫になるまで出庫オーダしないことを勧める。
				rec =  proc_decision_id_by_key("lotstkhists","  itms_id = #{@itm_id} and locas_id = #{prev["shp_loca_id"]}
					and lotno = '#{proc_flg_process_lotno_flg}' and
                         processseq = #{prev["shp_trngantt_processseq"]}  and prjnos_id = #{@prjno_id} and packno =  'dummy'")
			  add_fields[:id]  = rec["id"]
				add_fields[:lotstkhist_qty_stk] =   prev["qty"]*-1 + (rec["qty_stk"]||=0)
				__send__("proc_fld_r_#{prev["destblname"]}_lotstkhists_self60")   do ###alloctbl_destblname
					add_fields
				end ##
				rec =  proc_decision_id_by_key("picords"," orgtblname = '#{prev["shp_tblname"]}' and  orgtblid = #{prev["shp_tblid"]} and
												lotno = '#{@lotstkhist_lotno}' and packno =  '#{@lotstkhist_packno}'   and shelfnos_id = #{@lotstkhist_shelfno_id} ")
				__send__("proc_tblink_alloctbls_#{prev["destblname"]}_picords_self10",prev)
				### purords等のallocをpicordsに変更
				new_alloc =  proc_decision_id_by_key("alloctbls","srctblname = 'trngantts' and srctblid = #{prev["srctblid"]}
													and destblname = 'picords' and destblid = #{@picord_id} ")
				if @alloctbl_classname =~ /_add_/
					new_alloc["qty"] = 0
					new_alloc["qty_stk"] = 0
					new_alloc["destblname"] = "picords"
					new_alloc["destblid"] = @picord_id
				end
				##proc_tblink_r_lotstkhists_trngantts_self10({:id=>add_fields[:id]})
				proc_decision_id_by_key("trngantts","  orgtblname = 'lotstkhists' and orgtblid = #{@lotstkhist_id} and key = '000' ")
				proc_fld_r_lotstkhists_trngantts_self10
				proc_add_edit_lotstkhist_by_free(add_fields[:lotstkhist_qty_stk])
				###  picords  ===>   元のtrnganntsのtblname tblidの構成の下に
				###  pur,prd schs,ords,insts==>  lotstlhistsの構成の下に

				proc_update_pic_dummy_stk_alloc(add_fields,prev,new_alloc)
				##rec =  proc_decision_id_by_key("inouts","  alloctbls_id_inout = #{new_alloc["id"]} and  locas_id = #{@picord_loca_id} and
				##									lotno = '#{@picord_lotno}' and
				##									----- processseq = #{@picord_processseq}  and
        ##　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　　packno =  '#{@picord_packno}'   and
      	##                                         inoutflg = 'out' ")
				##strsql = "select * from alloctbls where srctblname = 'trngantts' and destblname = 'picords' and destblid = #{@picord_id} and allocfree  in('alloc' ,'free') "
				##alloc = ActiveRecord::Base.connection.select_one(strsql)
				##proc_fld_r_picords_inouts_self10 do
				##	{:id =>rec["id"],:inout_inoutflg=>"out",:inout_alloctbl_id_inout=>alloc["id"],:inout_trngantt_id_inout=>alloc["srctblid"]}
				##end
			end
		end
		return
	end

	def proc_shpact_to_lotstk_by_pic(tblname,tblid,pic_alloc)  ###tbl:shp dlv              trn :picact
		allocs = proc_get_allrecs_fm_tblname_yield("alloctbls") do
                   "allocfree = 'alloc' and srctblname = 'trngantts' and destblname = '#{tblname}' and destblid = #{tblid}"
		end
		qty_stk = 0
		proc_command_instance_variable(proc_get_viewrec_from_id(pic_alloc["destblname"],pic_alloc["destblid"]))
		##picact.with_indifferent_access
		qty_stk  +=  @picact_qty_stk
		add_fields  = {}
		rec =  proc_decision_id_by_key("lotstkhists","  itms_id = #{@picact_itm_id} and locas_id = #{@picact_loca_id_to}
	    						and lotno = '#{@picact_lotno}' and
								processseq = #{@picact_processseq}  and prjnos_id = #{@picact_prjno_id} and packno =  '#{@picact_packno}'")
		add_fields[:id]  = rec["id"]
		add_fields[:lotstkhist_qty_stk] = (rec["qty_stk"]||=0) + @picact_qty_stk
		proc_fld_r_picacts_lotstkhists_self10 do
			add_fields
		end
		##proc_alloctbls_update("_edit_",{:id=>,:allocfree=>"done"})   ###alloctblsにはpicxxxはない。
		trn = {}
		proc_save_trn_of_opeitm(trn) do
			trn[:tblname] = "lotstkhists"
		end
		trn[:qty_stk] = @picact_qty_stk
		proc_update_gantt_alloc_fm_trn trn,allocs,nil
	end
	def proc_add_edit_lotstkhist_by_free qty_stk
		if block_given?
			based_alloc = yield.dup
		else
			based_alloc = {}
			based_alloc[:srctblid] = @trngantt_id
			based_alloc[:destblid] = @lotstkhist_id
			based_alloc[:qty_stk] =  0
			based_alloc[:packqty] = if @lotstkhist_packno != "dummy" then @lotstkhist_qty_stk  else 0 end
		end
		based_alloc[:srctblname] = "trngantts"
		based_alloc[:destblname] = "lotstkhists"
		based_alloc[:allocfree] = "free"
		based_alloc[:remark] = "proc_add_edit_lotstkhist_by_free"
		based_alloc[:qty_stk] += qty_stk
		proc_alloctbls_update(nil,based_alloc)   ###nil--->登録削除の自動判定依頼
		return based_alloc
	end
	def proc_act_to_lot trn,tblname
		case trn[:sio_classname]
			when/_add_/
				@lotstkhist_classname = "lotstkhists_add_"
				proc_command_instance_variable(ActiveRecord::Base.connection.select_one("select * from r_#{tblname} where id = #{trn[:id]} "))
				strsql = "select *  from alloctbls where srctblname = 'trngantts' and destblname = '#{tblname}' and destblid = #{trn[:id]}  and qty >0
							and allocfree in('alloc','free') order by allocfree"   ###order by allocfree 引当て分から在庫に充てる
				### qty > 0 --->  自らのtrngantt は除く
				allocs = ActiveRecord::Base.connection.select_all(strsql)
				##qty = trn[:qty] ## @puract_qty 瓶の数又はリールの数
				add_fields = {}
				add_fields[:lotstkhist_lotno] = if eval("@#{tblname.chop}_lotno") then eval("@#{tblname.chop}_lotno") else proc_flg_process_lotno_flg end   ###lotno毎に入力する。lotno毎にpuractsができる。
				add_fields[:lotstkhist_packno] = "dummy"
				packqty = trn[:packqty]
				rec = {}
				lottrn = trn.dup
				allocs.each do |alloc|
					if trn[:packno_flg]  ==  "1"
						until alloc["qty"] <= 0
							if packqty == trn[:packqty]
								add_fields[:lotstkhist_packno] = proc_flg_process_packno_flg(eval("@#{tblname.chop}_opeitm_id"),@lotstkhist_packno)
								rec =  proc_decision_id_by_key("lotstkhists","  itms_id = #{trn[:itms_id]} and locas_id = #{trn[:locas_id_to]}
																and lotno = '#{add_fields[:lotstkhist_lotno]}' and
																processseq = #{trn[:processseq_pare]}  and prjnos_id = #{trn[:prjnos_id]} and packno =  '#{add_fields[:lotstkhist_packno]}'")
								add_fields[:id]  = rec["id"]
								add_fields[:lotstkhist_qty_stk] = packqty
								###proc_crt_def_tblink("proc_tblink_r_#{tblname}_lotstkhists_self30")
								__send__("proc_fld_r_#{tblname}_lotstkhists_self30")   do
                                    add_fields
								end ##
								proc_save_trn_of_opeitm(lottrn) do
									lottrn[:tblname] = "lotstkhists"
								end
								if packqty >= alloc["qty"]
									packqty -= alloc["qty"]
									proc_update_gantt_alloc_fm_acttrn lottrn,alloc.with_indifferent_access,nil
									alloc["qty"] = 0
								else
									alloc_qty = alloc["qty"]
									alloc["qty"] = packqty
									packqty = trn[:packqty]
									proc_update_gantt_alloc_fm_acttrn lottrn,alloc.with_indifferent_access,nil
									alloc["qty"] = alloc_qty - trn[:packqty]
								end
							else  ###一つのリール又は一瓶の引当てが複数になった時
								new_alloc =  proc_decision_id_by_key("alloctbls","srctblname = 'trngantts' and
																	srctblid = (select id from trngantts where orgtblname = 'lotstkhists' and orgtblid = #{rec["id"]}  and key = '000') and
																	destblname = 'lotstkhists' and destblid = #{rec["id"]} ")
								if packqty >= alloc["qty"]
									packqty -= alloc["qty"]
									lottrn[:qty_stk] -= alloc["qty"]
									proc_update_stk_alloc lottrn,alloc.with_indifferent_access,new_alloc.with_indifferent_access
									alloc["qty"] = 0
								else
									sqty = alloc["qty"]
									alloc["qty"] = packqty
									lottrn[:qty_stk] -= alloc["qty"]
									proc_update_stk_alloc lottrn,alloc.with_indifferent_access,new_alloc.with_indifferent_access
									alloc["qty"] = sqty - packqty
									packqty = trn[:packqty]
								end
							end
						end
					else
						if trn[:qty] > 0
							rec =  proc_decision_id_by_key("lotstkhists","  itms_id = #{trn[:itms_id]} and locas_id = #{trn[:locas_id_to]}
												and lotno = '#{add_fields[:lotstkhist_lotno]}' and
												processseq = #{trn[:processseq_pare]}  and prjnos_id = #{trn[:prjnos_id]} and packno =  'dummy'")
							add_fields[:id]  = rec["id"]
							add_fields[:lotstkhist_qty_stk] =   alloc["qty"] + (rec["qty_stk"]||=0)
							__send__("proc_fld_r_#{tblname}_lotstkhists_self30")    do
								add_fields
							end ##
							proc_save_trn_of_opeitm(lottrn) do
								lottrn[:tblname] = "lotstkhists"
							end
						else
							 logger.debug"error class #{self} : #{Time.now}:  line #{__LINE__}  trn:#{trn}  "
							 raise
						end
						proc_update_gantt_alloc_fm_acttrn lottrn,alloc.with_indifferent_access,trn[:qty]  ###trn[:qty]　イッタンｆｒｅｅになる在庫
						lottrn[:qty_stk] = 0   ###在庫の作成は完了
						trn[:qty] -= alloc["qty"]
					end
				end
			when /edit|delete/
		end
	end
	def proc_alloc_to_sch alloc,qty,qty_stk  ###qty,qty_stk  allocとして残る数量
		r_qty = alloc["qty"]
		r_qty += alloc["qty_stk"]
		new_qty = alloc["qty"] + alloc["qty_stk"] - qty - qty_stk
		proc_alloctbls_update("_edit_",{:qty =>qty,:qty_stk=>qty_stk,:id =>alloc["id"],:remark => "proc_alloc_to_sch 1"})
		strsql = "select * from alloctbls where srctblname = 'trngantts' and srctblid = #{alloc["srctblid"]} and destblname like '%schs' "
		schs =  ActiveRecord::Base.connection.select_all(strsql)
		schs.each do   |sch|
			if sch["allocfree"] == "alloc"
				proc_alloctbls_update("_edit_",{:qty =>new_qty ,:id =>sch["id"],:remark => "proc_alloc_to_sch 0"})
			else
				if sch["qty"] >= r_qty
					proc_alloctbls_update("_edit_",{:qty =>sch["qty"] -  r_qty,:id =>sch["id"],:remark => "proc_alloc_to_sch 2"})
					r_qty = 0
				else
					proc_alloctbls_update("_edit_",{:qty =>0,:id =>sch["id"],:remark => "proc_alloc_to_sch 3"})
					r_qty -= sch["qty"]
				end
			end
		end
	end
	def proc_mkord_err rec,mag
		proc_tbl_edit_arel(rec["alloctbl_destblname"],{:remark=>mag}," id = #{rec["alloctbl_destblid"]}")
	end
	def proc_chil_items_auto_shp(tblname,tblid)
		chil_items = {}
		trn_ids = ActiveRecord::Base.connection.select_all("select srctblid from alloctbls where srctblname = 'trngantts' and destblname = '#{tblname}' and destblid = #{tblid} and qty > 0 ")
		trn_ids.each do |tid|
			strsql = "select chil.id chil_id,shp.*,alloc.id alloc_id,alloc.srctblname alloc_srctblname,alloc.srctblid alloc_srctblid,alloc.destblname alloc_destblname,alloc.destblid alloc_destblid
							from trngantts chil,trngantts pare, alloctbls alloc,r_shpschs shp
								where pare.id = #{tid} and chil.orgtblnmae = pare.orgtblname and chil.orgtblid = pare.orgtblid
								and pare.key =  case length(chil.key) when 3 then to_char(chil.key  - 1,'000') else substr(chil.key,1,length(chil.key) -3)   end
								and alloc.srctblname = 'trngantts' and alloc.srctblid = chil.id and alloc.destblname = 'shpschs' and alloc.destblid = shp.id and alloc.qty > 0 "
			items = ActiveRecord::Base.connection.select_all(strsql)
			allocs = []
			items.each do |item|
				if chil_items[item["chil_id"].to_s].nil?
					shp = {}
					item.each do |key,val|
						if key =~ /^shpsch/
							shp[key] = val
						end
					end
				else
					shp["qty"] += item["qty"]
				end
				allocs << {:id=>item["alloc_id"],:srctblname=>item["alloc_srctblname"],:srctblid=>item["alloc_srctblid"],:destblname=>item["alloc_destblname"],:destblid=>item["alloc_destblid"]}
			end
			chil_items[item["chil_id"].to_s] = {:shp=>shp,:allocs=>allocs}
		end
	end
	def proc_custord_chng_dlv_to_dlv(fmpps,fm_id)   ###custordsの引当ての変更
		raise ###   使用してない。
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
						###proc_tbl_edit_arel("alloctbls",alloctbl," id = #{alloctbl["id"]}")
						proc_alloctbls_update("_edit_",alloctbl.with_indifferent_access)
					else
						logger.debug " logic error   オーダー済以下にはできない。"
						logger.debug " 画面でチェック　していること。"
						raise
					end
				else
					alloctbl = {}
						alloctbl[:qty] = custord["qty"]
						alloctbl[:qty_stk] = 0
						alloctbl[:packqty] = 0
						alloctbl[:srctblname] = "custords"
						alloctbl[:destblname] = "dlvschs"
						alloctbl[:srctblid] = custord["id"]
						alloctbl[:destblid] = dlvsch["id"]
						alloctbl[:allocfree] = "dlv"
						proc_alloctbls_update("_add_",alloctbl)
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
						proc_alloctbls_update("_edit_",alloctbl)
					else
						logger.debug " logic error   出荷済数以下にはできない。"
						logger.debug " 画面でチェック　していること。"
						raise
					end
				else
					alloctbl = {}
					alloctbl[:qty] = custinst["qty"]
					alloctbl[:qty_stk] = 0
					alloctbl[:packqty] = 0
					alloctbl[:srctblname] = "custords"   ###srctblname は常に　custords
					alloctbl[:destblname] = "dlvords"
					alloctbl[:srctblid] = custord["id"]
					alloctbl[:destblid] = dlvord["id"]
					alloctbl[:allocfree] = "dlv"
					alloctbl[:remark] = "proc_custord_chng_dlv_to_dlv 3"
					proc_alloctbls_update("_add_",alloctbl)
				end
					###cusords_dlvschs  のqty変更
					strsql = "select * from alloctbls where srctblname = 'custords' and srctblid = #{custord["id"]} and destblname = 'dlvschs' and allocfree = 'dlv' "
					alloctbl = ActiveRecord::Base.connection.select_one(strsql)
					alloctbl["qty"] = custord["qty"] - custinst["qty"]
					alloctbl["qty"] = 0 if alloctbl["qty"] < 0
					proc_alloctbls_update("_edit_",alloctbl)
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
					proc_alloctbls_update("_edit_",alloctbl)
				else
					alloctbl = {}
					alloctbl [:qty] = custacts["qty"]
					alloctbl[:qty_stk] = 0
					alloctbl[:packqty] = 0
					alloctbl[:srctblname] = "custords"   ###srctblname は常に　custords
					alloctbl[:destblname] = "dlvords"
					alloctbl[:srctblid] = custord["id"]
					alloctbl[:destblid] = dlvact["id"]
					alloctbl[:allocfree] = "dlv"
					alloctbl[:remark] = "proc_custord_chng_dlv_to_dlv custacts add"
					proc_alloctbls_update("_add_",alloctbl)
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
					proc_alloctbls_update("_edit_",alloctbl)
		end
	end
	def proc_blk_constrains tbl,colm,type,constraint_name   ###r_blktbsのテーブル　view作成ボタンでblkukysにレコードを追加してないとチェックはできない。
		strsql = ""
		ActiveRecord::Base.uncached() do
			case ActiveRecord::Base.configurations[Rails.env]['adapter']
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
			ActiveRecord::Base.connection.select_all(strsql)
		end
	end
	def proc_blk_get_constrains tbl,type
		strsql = ""
		ActiveRecord::Base.uncached() do
			case ActiveRecord::Base.configurations[Rails.env]['adapter']
				when /post/
					strsql = "SELECT  constraint_name FROM information_schema.table_constraints WHERE table_name = '#{tbl.downcase}'
										and constraint_type = #{case type.upcase when /^U/ then 'UNIQUE' when /^F/ then 'FOREIGN KEY' else '' end } "
				when /oracle/
					strsql = "select constraint_name 	from all_constraints 	where  table_name = '#{tbl.upcase}'  and constraint_type = '#{type[0].upcase}'"
			end
			ActiveRecord::Base.connection.select_values(strsql)
		end
	end
	def proc_sequences_exist seq_name
		case ActiveRecord::Base.configurations[Rails.env]['adapter']
			when /oracle/
				sql = "SELECT 1	FROM user_sequences WHERE sequence_name = '#{seq_name.upcase}' "
			when /post/
				sql = "SELECT 1 FROM pg_class where relname = '#{seq_name.downcase}'"
		end
		ActiveRecord::Base.connection.select_one(sql)
	end
	def proc_no_set code,key
		rec =  proc_decision_id_by_key("notbls","  code = '#{code}' and key = '#{key}'" )
		if @notbl_classname =~ /_add_/
			rec["code"] = code
			rec["key"] = key
			rec["seqno"] = 1
			proc_tbl_add_arel("notbls",rec)
			return 1
		else
			rec["seqno"] += 1
			proc_tbl_edit_arel("notbls",rec," id = #{rec["id"]}")
			return rec["seqno"]
		end
	end
	# Float()で変換できれば数値、例外発生したら違う
	def float_string?(str)
		begin
			if str.class == Fixnum  or str.class == Bignum    or str.class == Float
				true
			else
				Float(str)
				true
			end
		rescue ###ArgumentError
			false
		end
	end
	def date_string?(str)
		begin
			if str.class == Time
				true
			else
				Date.parse(str)
				true
			end
		rescue ###ArgumentError
			false
		end
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
