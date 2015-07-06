﻿# RorBlk
# 2099/12/31を修正する時は　2100/01/01の修正も
 module Ror_blkctl    
	Blksdate = Date.today - 1  ##在庫基準日　sch,ord,instのこれ以前の納期は許さない。
	Confirmdate = Date.today + 7  ##在庫基準日　sch,ord,instのこれ以前の納期は許さない。
	Db_adapter = ActiveRecord::Base.configurations[Rails.env]['adapter']
    def sub_blkget_grpcode     ## fieldsの名前
        return @pare_class if  @pare_class == "batch"
        tmp_person =  plsql.r_persons.first(:person_email =>current_user[:email])
        ###p " current_user[:email] #{current_user[:email]}"
        if tmp_person.nil?
           p "add person to his or her email "  
		   raise   ### 別画面に移動する　後で対応
            else
          grp_code = tmp_person[:usrgrp_code]
        end 
        return grp_code
    end
	def proc_blkgetpobj code,ptype
		sub_blkgetpobj code,ptype
	end
    def sub_blkgetpobj code,ptype    ###
        fstrsqly = ""
        grp_code =  sub_blkget_grpcode 
        if code =~ /_id/ or   code == "id" then
            oragname = code
        else
            orgname = ""      
            basesql = "select pobjgrp_name from R_POBJGRPS where POBJGRP_EXPIREDATE > current_date AND USERGROUP_CODE = '#{grp_code}' and   "
            fstrsql  =  basesql  +  " POBJECT_CODE = '#{code}' and POBJECT_OBJECTTYPE = '#{ptype}' "
            ###  フル項目で指定しているとき
            orgname = (plsql.select(:first,fstrsql)[:pobjgrp_name]  if plsql.select(:first,fstrsql))||code
            if orgname == code and ptype == "view_field" then  ###view項目の時はテーブル項目まで
                orgname = ""
                code.split('_').each_with_index do |value,index|
		            fstrsqly =  basesql +  "   POBJECT_CODE = '#{if index == 0 then value + "s" else value end}'  and POBJECT_OBJECTTYPE = '#{if index == 0 then  'tbl' else 'tbl_field' end}' "
		            if plsql.select(:first,fstrsqly) then   ## tbl name get
			            orgname <<  plsql.select(:first,fstrsqly)[:pobjgrp_name]  + "_"
		            else
                        orgname << value + "_"
                    end   
                end   ## do code. 
                orgname.chop!
            end ## if orgname
        end  ## if ocde
        ##fprnt " Line:#{__LINE__} Time:#{Time.now.to_s}  fstrsqly:#{fstrsqly}"
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
            rec = plsql.select(:first,basesql)
            orgcode =  if rec then rec[:pobject_code] else name end			
         end  ## if ocde
      ##fprnt " Line:#{__LINE__} Time:#{Time.now.to_s}  fstrsqly:#{fstrsqly}"
      return orgcode ||= name
    end  ## def getpobj
    def fprnt str
      foo = File.open("#{Rails.root}/log/blk#{Process::UID.eid.to_s}.log", "a") # 書き込みモード
      foo.puts "#{Time.now.to_s}  #{str}"
      foo.close
	  p str
    end   ##fprnt str
    def user_seq_nextval
      ses_cnt_usercode = "userproc_ses_cnt" + @sio_user_code.to_s ###user_code 15char 以下
      unless PLSQL::Sequence.find(plsql,ses_cnt_usercode) then 
             plsql.execute "CREATE SEQUENCE #{ses_cnt_usercode}"
             plsql.execute "CREATE SEQUENCE userproc#{@sio_user_code.to_s}s_seq"
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
              plsql.execute userprocs
      end
      return plsql.__send__(ses_cnt_usercode).nextval 
    end
    def user_parescreen_nextval
        parescreen_cnt_usercode = "parescreen_a" + @sio_user_code.to_s
        unless PLSQL::Sequence.find(plsql,parescreen_cnt_usercode) then 
            plsql.execute "CREATE SEQUENCE #{parescreen_cnt_usercode}"
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
              plsql.execute parescreens
        end
        return plsql.__send__(parescreen_cnt_usercode).nextval 
    end
    def proc_update_table rec,r_cnt0  ##rec = command_c command_rとの混乱を避けるためrecにした。
	    tblname = rec[:sio_viewname].split("_")[1]
        begin 	       
            command_r = rec.dup ###sio_xxxxx の　レスポンス用
            tmp_key = {}
            if  command_r[:sio_message_contents].nil? 
				proc_set_src_tbl  rec ### @src_tblの項目作成
				proc_tblinks(command_r) do 
					"before"
				end if command_r[:sio_classname] =~ /_add_|_edit_|_delete_/ ## rec = command_c = sio_xxxxx
				command_r[:sio_recordcount] = r_cnt0
				if tblname =~ /^mk/   ###mkxxxxは追加のみ
					plsql.__send__(tblname).insert @src_tbl
				else
					case command_r[:sio_classname]
						when /_add_/ 
							plsql.__send__(tblname).insert @src_tbl  
						when /_edit_/ 
							@src_tbl[:where] = {:id => @src_tbl[:id]}             ##変更分のみ更新
							plsql.__send__(tblname).update  @src_tbl
						when  /_delete_/ 
							if tblname =~ /schs$|ords$|insts$|acts$/  ##alloctblにかかわるtrnは削除なし
								@src_tbl[:qty] = 0 if @src_tbl[:qty] 
								@src_tbl[:amt] = 0 if @src_tbl[:amt]
								@src_tbl[:where] = {:id => @src_tbl[:id]}             ##変更分のみ更新
								plsql.__send__(tblname).update  @src_tbl
							else								
								plsql.__send__(tblname).delete(:id => @src_tbl[:id])
							end
							### blkukyの時は　constrainも削除
					end   ## case iud
				end
				proc_tblinks(command_r) do 
					"after"
				end if command_r[:sio_classname] =~ /_add_|_edit_|_delete_/ ## rec = command_c = sio_xxxxx
            end  ##@src_tbl[:sio_message_contents].nil
          rescue
                plsql.rollback
                @sio_result_f = command_r[:sio_result_f] =   "9"  ##9:error 
                command_r[:sio_message_contents] =  "class #{self} : LINE #{__LINE__} $!: #{$!} "    ###evar not defined
                command_r[:sio_errline] =  "class #{self} : LINE #{__LINE__} $@: #{$@} "[0..3999]
                fprnt"class #{self} : LINE #{__LINE__} $@: #{$@} " 
                fprnt"class #{self} : LINE #{__LINE__} $!: #{$!} " 
                fprnt"LINE #{__LINE__} command_r: #{command_r} " 
          else
            @sio_result_f = command_r[:sio_result_f] =  "1"   ## 1 normal end
            command_r[:sio_message_contents] = nil
            command_r[(tblname.chop + "_id").to_sym] =  command_r[:id] = @src_tbl[:id]
			vproc_delayjob_or_optiontbl(tblname,command_r[:id]) if vproc_optiontabl(tblname)
            ##crt_def_tb if  tblname == "blktbs"   
          ensure
            sub_insert_sio_r   command_r    ## 結果のsio書き込み
            ###raise   ### plsql.connection.autocommit = false   ##test 1/19 ok
        end ##begin
        raise if @sio_result_f ==   "9" 
    end
	def vproc_optiontabl tblname
		if tblname =~ /rubycodings|tblink|rplies$|mkschs|mkords|mkinsts|mkacts/ then true else false end
	end
	def vproc_delayjob_or_optiontbl tblname,id	
        case tblname
             when 	/rubycodings|tblinks/
			##undef dummy_def if respond_to?("dummy_def")
				crt_def_all
			when   /mkests|mkschs|mkords|mkinsts/
		        vproc_tbl_mk  tblname,id do 
					case tblname
						when  /mkests|mkschs/
							DbSchs.new
						when  /mkords/
							DbOrds.new
						when  /mkinsts/
							DbInsts.new
						when  /mkacts/
							DbInsts.new
					end
				end
				 ####when   /schs$|ords$|insts$|acts$/				 
			when   /rplies$/ 
				dbrply = DbReplies.new
			    dbrply.perform_setreplys tblname,id,@sio_user_code ###reply のuser_id はinteger 
        end				 					
	end
	def vproc_tbl_mk tblname,id
		str_id = if id then " and id = #{id} " else "" end
	    if tblname == "mkinsts"  then order_by_add = " autocreate_inst, "  else order_by_add = "" end
	    recs = ActiveRecord::Base.connection.select_all("select * from #{tblname} where result_f = '0' #{str_id}  order by #{order_by_add} id")   ##0 未処理
        dbmk = yield
		tbl = {}
		recs.each do |rec|
			tbl[:result_f] = "5"  ## Queueing
			tbl[:where] = {:id =>rec["id"]}
			plsql.__send__(tblname).update tbl
		end
		dbmk.__send__("perform_#{tblname}", recs)
	end	
	def proc_insert_sio_c command_c
		sub_insert_sio_c   command_c
	end
    def sub_insert_sio_c   command_c   ###要求  無限ループにならないこと
        ###command_c = char_to_number_data(command_c) ###画面イメージからデータtypeへ   入口に変更すること
        command_c[:sio_id] =  proc_get_nextval("SIO_#{command_c[:sio_viewname]}_SEQ")
        command_c[:sio_term_id] =  request.remote_ip  if respond_to?("request.remote_ip")  ## batch処理ではrequestはnil　　？？ 
        command_c[:sio_command_response] = "C"
        command_c[:sio_add_time] = Time.now
		command_c = vproc_command_c_dflt_set_fm_rubycoding(command_c) if command_c[:sio_classname] =~ /_add_|_edit_|_delete_/
		begin
			plsql.__send__("SIO_#{command_c[:sio_viewname]}").insert command_c
		rescue
			plsql.rollback
			fprnt " proc_insert_sio_c err   ・・・・・　command_c = #{command_c}"
            fprnt"class #{self} : LINE #{__LINE__} $@: #{$@} " 
            fprnt"class #{self} : LINE #{__LINE__} $!: #{$!} " 	
			raise
		end
    end   ## sub_insert_sio_c	
	#def vproc_command_c_dflt_set_fm_rubycoding command_c  ###rubycodingsは開発環境のみ　引き数はcommand_cで固定
	#	tblnamechop = command_c[:sio_viewname].split("_",2)[1].chop
	#	command_c.each do |key,val|
	#		if val.nil? and  key.to_s =~ /^#{tblnamechop}_/
	#			strsql = %Q& select * from r_rubycodings where pobject_objecttype = 'view_field' 	and  pobject_code = '#{key.to_s}'
	#						and rubycoding_code like '%dflt_for_tbl_set' &
	#			rubycode_view = ActiveRecord::Base.connection.select_one(strsql)
	#			if rubycode_view
	#				dflt_rubycode = rubycode_view["rubycoding_code"] + if rubycode_view["rubycoding_hikisu"] then "," + rubycode_view["rubycoding_hikisu"] else "" end
	#				command_c[key] = __send__(dflt_rubycode)
	#			else
	#				fld_tbl = key.to_s.split("_",2)[1] 
	#				strsql = %Q& select * from r_rubycodings where pobject_objecttype = 'tbl_field' 	and  pobject_code = '#{fld_tbl}'
	#						and rubycoding_code like '%dflt_for_tbl_set' &
	#				rubycode_tbl = ActiveRecord::Base.connection.select_one(strsql)
	#				if rubycode_tbl
	#					dflt_rubycode = rubycode_tbl["rubycoding_code"] + if rubycode_tbl["rubycoding_hikisu"] then "," + rubycode_tbl["rubycoding_hikisu"] else "" end
	#					command_c[key] = __send__(dflt_rubycode)
	#				end
	#			end
	#		end
	#	end
	#	return command_c
	#end	
	def vproc_command_c_dflt_set_fm_rubycoding command_c  ###rubycodingsは開発環境のみ　引き数はcommand_cで固定
		command_r = command_c.dup
		tblnamechop = command_c[:sio_viewname].split("_",2)[1].chop
		command_c.each do |key,val|
			if (val == "" or val.nil?) and  key.to_s =~ /^#{tblnamechop}_/
				def_name = "proc_view_field_#{key.to_s}_dflt_for_tbl_set"
				if respond_to?(def_name)
					command_r[key] = __send__(def_name,command_r)
				else
					fld_tbl = key.to_s.split("_",2)[1]
					def_name = "proc_field_#{fld_tbl}_dflt_for_tbl_set"
					if respond_to?(def_name)
						command_r[key] = __send__(def_name,command_r)
					end
				end
			end
		end
		return command_r
	end
    def sub_userproc_insert command_c
        userproc = {}		
        userproc[:id] = proc_get_nextval("userproc#{@sio_user_code.to_s}s_seq")
		userproc[:session_counter] = command_c[:sio_session_counter]
        userproc[:tblname] = "sio_"+ command_c[:sio_viewname]
        userproc[:cnt] = command_c[:sio_recordcount]
        userproc[:cnt_out] = 0
        userproc[:status] = "request"
        userproc[:created_at] = Time.now
        userproc[:updated_at] = Time.now
        userproc[:persons_id_upd] = ActiveRecord::Base.connection.select_one("select * from persons where code = '0'")["id"]
        userproc[:expiredate] = DateTime.parse("2099/12/31")
        plsql.__send__("userproc#{@sio_user_code.to_s}s").insert userproc
    end
	def proc_userproc_chk_set command_c
		sub_userproc_chk_set command_c
	end
    def sub_userproc_chk_set command_c		
		strwhere = " where tblname = 'sio_#{command_c[:sio_viewname]}' and "
		strwhere << " session_counter = #{command_c[:sio_session_counter]} "
        chkuserproc = plsql.__send__("userproc#{@sio_user_code.to_s}s").first(strwhere)
		if chkuserproc
		    chkuserproc[:cnt] += 1
            chkuserproc[:where] = {:id=>chkuserproc[:id]}			
            plsql.__send__("userproc#{@sio_user_code.to_s}s").update 	chkuserproc		  
		else
		    sub_userproc_insert command_c 
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
        parescreen[:persons_id_upd] = ActiveRecord::Base.connection.select_one("select * from persons where code = '0'")["id"]
        parescreen[:expiredate] = Date.today + 1
        plsql.__send__("parescreen#{@sio_user_code.to_s}s").insert parescreen
    end
    def sub_insert_sio_r command_r   ####レスポンス
        command_r[:sio_id] =  proc_get_nextval("SIO_#{command_r[:sio_viewname]}_SEQ")
        command_r[:sio_command_response] = "R"
        command_r[:sio_add_time] = Time.now
        plsql.__send__("SIO_#{command_r[:sio_viewname]}").insert command_r
    end   ## sub_insert_sio_r 
    def proc_insert_sio_r command_r   ####レスポンス
        sub_insert_sio_r command_r
    end   ## sub_insert_sio_r
    def char_to_number_data command_r   ###excel からのデータ取り込み　根本解決を   
		##rubyXl マッキントッシュ excel windows excel not perfect
		@date1904 = nil
		##command_r[:sio_viewname]||=command_r[:id]
		viewtype = proc_blk_columns("sio_#{command_r[:sio_viewname]}")
		##@show_data[:allfields].each do |i|
		command_c = {}
		viewtype.each do |key,j|
			i = key.to_sym
			if command_r[i] then
				command_c[i] = command_r[i]
				###case @show_data[:alltypes][i]
				case j[:data_type].downcase
					when /date|^timestamp/ then
			        begin
						command_c[i] = Time.parse(command_r[i].gsub(/\W/,"")) if command_r[i].class == String
						command_c[i] = num_to_date(command_r[i])  if command_r[i].class == Fixnum  or command_r[i].class == Float 
			        rescue
                       command_c[i] = Time.now
			        end
					when /number/ then
						command_c[i] = command_r[i].gsub(/,|\(|\)|\\/,"").to_f if command_r[i].class == String
					when /char/
						command_c[i] = command_r[i].to_i.to_s if command_r[i].class == Fixnum
				end  #case show_data
			end  ## if command_r
		end  ## sho_data.each
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
        if  command_c[:sio_strsql]  then   ## 親からの情報があるときは対象外
            tmp_sql =  command_c[:sio_strsql] 
          else
            tmp_str = plsql.r_screens.first("where pobject_code_scr = '#{screen_code}' and screen_Expiredate > current_date order by screen_expiredate ")
            if  tmp_str and  command_c[:sio_search]  == "false" and command_c[:sio_sidx] == "" then
                if tmp_str[:screen_strselect]  then tmp_sql = "(#{tmp_str[:screen_strselect]}" else tmp_sql =  command_c[:sio_viewname]  + " a " end 
                tmp_sql << tmp_str[:screen_strselect] if tmp_str[:screen_strselect]
                tmp_sql << tmp_str[:screen_strwhere] if tmp_str[:screen_strwhere] and  command_c[:sio_search]  == "false"
                tmp_sql << tmp_str[:screen_strgrouporder] if tmp_str[:screen_strgrouporder] 
                tmp_sql << " ) a "  if tmp_str[:screen_strselect]
              else 
                tmp_sql =  command_c[:sio_viewname]  + " a " 
            end
        end
        strsql = "SELECT id FROM " + tmp_sql
        tmp_sql << proc_strwhere(command_c)  if command_c[:sio_search]  == "true"
        sort_sql = ""
        unless command_c[:sio_sidx].nil? or command_c[:sio_sidx] == "" then 
	        sort_sql = " ROW_NUMBER() over (order by " +  command_c[:sio_sidx] + " " +  command_c[:sio_sord]  + " ) " 
	      else
	        sort_sql = "rownum "
        end
        cnt_strsql = "SELECT 1 FROM " + tmp_sql 
        command_c[:sio_totalcount] =  plsql.select(:all,cnt_strsql).count  
        case  command_c[:sio_totalcount]
            when nil,0   ## 該当データなし　　回答
	            contents = "not find record"    ### 将来usergroup毎のメッセージへ
	            command_c[:sio_recordcount] = 0
                command_c[:sio_result_f] = "8"  ## no record
                command_c[:sio_message_contents] = contents
	            all_sub_command_r = []
                sub_insert_sio_r(command_c)
	            all_sub_command_r[0] =  command_c
            else 
                strsql = "select #{sub_getfield} from (SELECT #{sort_sql} cnt,a.* FROM #{tmp_sql} ) "
                r_cnt = 0
                strsql  <<    " WHERE  cnt <= #{command_c[:sio_end_record]}  and  cnt >= #{command_c[:sio_start_record]} "
                #fprnt " class #{self} : LINE #{__LINE__}   strsql = '#{ strsql}' "
                pagedata = plsql.select(:all, strsql)
	            all_sub_command_r  = []
		        command_r = command_c.dup
                pagedata.each do |j|
                    r_cnt += 1
                    ##   command_r.merge j なぜかうまく動かない。
                    j.each do |j_key,j_val|
                        command_r[j_key]   = j_val ## unless j_key.to_s == "id" ## sioのidとｖｉｅｗのｉｄが同一になってしまう
                        ## command_r[:id_tbl] = j_val if j_key.to_s == "id"
                    end  
	                command_r[:sio_recordcount] = r_cnt
                    command_r[:sio_result_f] = "1"
                    command_r[:sio_message_contents] = nil
	                tmp = {}
                    sub_insert_sio_r(command_r)     ###回答
	                tmp.merge! command_r
	                all_sub_command_r <<  tmp   ### all_sub_command_r << command_r にすると以前の全ての配列が最新に変わってしまう
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
		search_key = params.dup
		strwhere = proc_search_key_strwhere search_key,strwhere,@show_data
		##strwhere = proc_search_key_strwhere strwhere,@show_data
	end	
	def proc_search_key_strwhere search_key,strwhere,show_data   ###search key:"xxxx"   not sym
        search_key.each  do |i,j|  ##xparams gridの生
            next if j == ""
			tmpwhere = nil
	        case show_data[:alltypes][i.to_sym]
				when nil
					next
	            when /number/
                    tmpwhere = " #{i} = #{j}     AND " 
		            tmpwhere = " #{i}  #{j[0]}  #{j[1..-1]}      AND "   if j =~ /^</   or  j =~ /^>/ 
		            tmpwhere = " #{i} #{j[0..1]} #{j[2..-1]}      AND "    if j =~ /^<=/  or j =~ /^>=/ 
	            when /^date|^timestamp/
		            case  j.size  
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
	        tmpwhere << "  updperson_code_upd =  '#{plsql.persons.first(:email =>current_user[:email])[:code]}' "
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
      strwhere = "where ptblid = #{next_screen_data[:sio_org_tblid]} and "
      strwhere << "ctblname = '#{next_screen_data[:sio_viewname].split("_")[1]}'  "
      ctbl_id = plsql.__send__("CTL#{next_screen_data[:sio_org_tblname]}").first(strwhere)
      if ctbl_id
	  return ctbl_id[:ctblid]
       else
	  ##fprnt " LINE #{__LINE__}  ptblname CTL#{next_screen_data[:sio_org_tblname]} ; strwhere = #{strwhere} "
	  raise "error"
      end
    end

 
    def sub_get_ship_locas_frm_itm_id itms_id
      rs = plsql.OpeItms.first("where itms_id = #{itms_id} and ProcessSeq = (select max(ProcessSeq) from OpeItms where  itms_id = #{itms_id} and Expiredate > current_date ) 
                               and Priority = (select max(Priority) from OpeItms where  itms_id = #{itms_id} and Expiredate > current_date )  order by expiredate")
       if rs then
	         return rs[:locas_id]
         else
            3.times{ fprnt " ERROR Line #{__LINE__} not found locas_id from  OpeItms   where itms_id = #{itms_id}"}
	        3.times{ p " ERROR Line #{__LINE__} not found locas_id from  OpeItms   where itms_id = #{itms_id}"}
          exit ###画面にメッセージをだす方法 バッチ処理だよ
       end
    end
	
    def proc_get_cons_chil(opeitms_id)  ###工程の始まり=前工程の終わり
		if block_given?
			strwhere = yield
		else
			strwhere = ""
		end
		strsql = "select * from r_nditms where nditm_opeitm_id = #{opeitms_id} #{strwhere}  and nditm_Expiredate > current_date "
		rnditms = ActiveRecord::Base.connection.select_all(strsql)
		return rnditms
    end

    def vproc_get_chil_itms(n0,r0,endtime)  ###工程の始まり=前工程の終わり
		rnditms = ActiveRecord::Base.connection.select_all("select * from nditms where opeitms_id = #{r0[:id]} and Expiredate > current_date order by opeitms_id ")
		if rnditms.size > 0 then
			ngantts = []
			mlevel = n0[:mlevel] + 1
			rnditms.each.with_index(1)  do |i,cnt|
				chilopeitm = ActiveRecord::Base.connection.select_one("select * from opeitms where itms_id = #{i["itms_id_nditm"]} and priority = #{r0[:priority]} and  Expiredate > current_date  order by processseq desc")
				###if chilopeitm then chil_loca = chilopeitm[:opeitms_locas_id]  else chil_loca = 0 end
				if chilopeitm 
					chil_loca = chilopeitm["locas_id"]
					prdpurshp = chilopeitm["prdpurshp"] 
					processseq = chilopeitm["processseq"] 
					priority = chilopeitm["priority"]
					opeitm_id = chilopeitm["id"]
				else
					chil_loca = 0
					prdpurshp = "end"  ###endは使用しなくなった。　後で修正
					processseq = 999
				end
				ngantts << {:seq=>n0[:seq] + sprintf("%03d", cnt),:mlevel=>mlevel,:itm_id=>i["itms_id_nditm"],:prd_pur_shp=>prdpurshp,:safestkqty=>i["safestkqty"],
		               :loca_id=>chil_loca,:loca_id_to=>r0[:locas_id],:opeitm_id =>opeitm_id,
					   :priority=>priority,:processseq=>processseq,
					   :endtime=>endtime,:duration=>chilopeitm["duration"],
					   :nditm_parenum=>i["parenum"],:nditm_chilnum=>i["chilnum"],:id=>"nditms_"+i["id"].to_s}
			end 
		else
			ngantts  = [{}]	   
		end
		return ngantts
    end
    def sub_get_prev_process(n0,r0,endtime)  ###工程の始まり=前工程の終わり
      rec = plsql.opeitms.first("where itms_id = #{r0[:itms_id]} and Expiredate > current_date and Priority = #{r0[:priority]} and processseq < #{r0[:processseq]}  order by   processseq desc")
      if rec
	       ngantts = []
           ngantts << {:seq=>(n0[:seq] + "000"),:mlevel=>n0[:mlevel]+1,:itm_id=>rec[:itms_id],:loca_id=>rec[:locas_id],:opeitm_id=>rec[:id],
		   :loca_id_to=>r0[:locas_id],
		   :endtime=>endtime,:prd_pur_shp=>rec[:prdpurshp],:duration=>rec[:duration],:nditm_parenum=>1,:nditm_chilnum=>1,
		   :safestkqty=>rec[:safestkqty],:id=>"opeitms_"+rec[:id].to_s,:priority=>rec[:priority],:processseq=>rec[:processseq]}
           endtime = endtime - rec[:duration]*24*60*60  ###dayのみ修正要
		else
          ngantts = [{}]		
      end
      return ngantts
    end
    #def sub_get_prev_opeitm p_opeitm  ###
	#"    if  p_opeitm[:itms_id_pare] == p_opeitm[:itms_id] 
    #        strwhere = "where itms_id = #{p_opeitm[:itms_id]} and Expiredate > current_date and Priority = #{p_opeitm[:priority]||= 999} "
    #        strwhere << " and processseq < #{p_opeitm[:processseq]}  order by   processseq desc"
	#	    rec = plsql.opeitms.first(strwhere) 		  
	#	    if rec.nil?
	#	        strwhere = "where itms_id = #{p_opeitm[:itms_id]} and Expiredate > current_date and Priority = #{p_opeitm[:priority]||= 999} "
    #            strwhere << " and processseq = #{p_opeitm[:processseq]}  "
	#	        rec = plsql.opeitms.first(strwhere)
	#	        if rec then rec = {} end
	#	    end
	#	 else  
    #       strwhere = "where itms_id = #{p_opeitm[:itms_id]} and Expiredate > current_date and Priority = #{p_opeitm[:priority]||= 999}  and processseq = 999 "
	#		rec = plsql.opeitms.first(strwhere) 
	#    end
    #    if rec
	#        rec
	#	  else
	#	    if p_opeitm[:chk] == true
	#	       rec 
	#		  else 
    #           p "logic err 	sub_get_prev_opeitm_processseq   p_opeitm:#{p_opeitm} "
    #           raise
    #        end			 
    #    end
	#    return rec
    #end
	
    def sub_get_itm_locas_procssseq_frm_opeitm opeitm_id  ###
       rec = plsql.opeitms.first("where id  = #{opeitm_id} and Expiredate > current_date ")
        if rec
	        rec
		 else
            p "logic err 	sub_get_itm_locas_procssseq_frm_opeitm opeitm_id:#{opeitm_id} "
           raise		  
        end
    end
	
    def sub_get_next_opeitm_processseq_and_loca_id p_opeitm  ###
	    if p_opeitm[:itms_id].nil? or p_opeitm[:priority].nil? or p_opeitm[:processseq].nil? or p_opeitm[:prdpursch].nil? 
	        tmp = plsql.opeitms.first("where id = #{p_opeitm[:opeitms_id]} ")
		    p_opeitm[:itms_id] = tmp[:itms_id]
		    p_opeitm[:locas_id] = tmp[:locas_id]
		    p_opeitm[:priority] = tmp[:priority]
		    p_opeitm[:processseq] = tmp[:processseq]
		    p_opeitm[:prdpursch] = tmp[:prdpursch]
	    end
	    if p_opeitm[:processseq] < 999
	        strwhere = "where itms_id = #{p_opeitm[:itms_id]} and Expiredate > current_date and Priority = #{p_opeitm[:priority]} and processseq > #{p_opeitm[:processseq]}  order by   processseq "
            rec = plsql.opeitms.first(strwhere)
		  else
		    p_opeitm[:prdpursch] = "shp"
			rec = p_opeitm.dup
        end		
        if rec
	        {:processseq=>rec[:processseq],:locas_id=>rec[:locas_id],:itms_id=>rec[:itms_id],:prev_prdpurshp=>p_opeitm[:prdpursch],:nxt_opeitms_id=>rec[:id]}
		 else
            p "logic err 	sub_get_next_opeitm_processseq_and_loca_id   p_opeitm:#{p_opeitm} "	  
            raise		  
        end
    end	
    def sub_get_opeitms_id_fm_itm_processseq_priority p_opeitm  ###
        rec = plsql.opeitms.first("where itms_id = #{p_opeitm[:itms_id]} and Expiredate > current_date and Priority = #{p_opeitm[:priority]||=999} and processseq = #{p_opeitm[:processseq]||=999}  ")
        if rec
	        rec
		  else
            p "logic err 	sub_get_opeitms_id_fm_itm_processseq_priority   p_opeitm:#{p_opeitm} "	  
            raise		  
        end
    end	
    def proc_get_opeitms_id_fm_itm_loca itms_id,locas_id,processseq = nil,priority = nil  ###
		strsql = "select * from opeitms where itms_id = #{itms_id} and locas_id = #{locas_id} 
		           and processseq = #{processseq ||= 999} and priority = #{priority ||= 999} and expiredate > current_date "
		rec = ActiveRecord::Base.connection.select_one(strsql)
        if rec
	        rec
		  else
            fprnt "logic err proc_get_opeitms_id_fm_itm_loca itms_id = #{itms_id} ,locas_id = #{locas_id}, processseq = #{processseq ||= 999} , 
					priority = = #{priority ||= 999} ,expiredate > #{Date.today}"	  
            raise		  
        end
    end
    def proc_get_chrgperson_fm_loca loca_id,prd_pur_shp
        case prd_pur_shp
			when "pur"
	           strsql = "select * from dealers where locas_id_dealer = #{loca_id} and expiredate > current_date"
			else	
			   strsql = "select * from asstwhs where locas_id_asstwh = #{loca_id} and expiredate > current_date"   
	    end	
        chrgperson = ActiveRecord::Base.connection.select_one(strsql)
	    if chrgperson
			chrgperson_id = chrgperson["chrgpersons_id_dflt"]
		else
			chrgperson = ActiveRecord::Base.connection.select_one("select * from r_chrgs where person_code =  'dummy'")
			if chrgperson
				chrgperson_id = chrgperson["id"]
			else 
				fprnt " proc_get_chrgperson_fm_loca  chrgpersons dummy code missing "
				raise
			end
	    end 
	    return chrgperson_id
    end

    def sub_cal_date(loca_id,ops_loca_id,dueday) 
        dueday
    end
    
    def  sub_get_bilcode(loca_id_custs)
         loca_id_custs
    end
        
    def  sub_get_pay_incomming_day(loca_id,dueday)
         dueday
    end
    def sub_get_to_locaid(custord_loca_id,itm_id)
        custord_loca_id
    end  	
    def sub_get_sects_id_fm_locas_id  locas_id
	    sect = plsql.sects.first("where locas_id_sect = #{locas_id||0} ")
		if sect.nil?
	       sect = plsql.r_sects.first("where loca_code_sect =  'dummy'")
	       if sect.nil? then sect_id = 0  else sect_id = sect[:id] end
		  else
		   sect_id = sect[:id]
	    end 
	    return sect_id
	end
	  	
    def sub_get_locas_id_fm_sects_id  sects_id
	    sect = plsql.sects.first("where id = #{sects_id} ")
		if sect.nil?
	       p "err logic err?"
		   raise on
		  else
		   locas_id = sect[locas_id_sect]
	    end 
	    return locas_id
	end
    def proc_get_dealers_id_fm_locas_id  locas_id
	    locas_id ||= 0
	    dealer = plsql.dealers.first("where locas_id_dealer = #{locas_id} ")
		if dealer.nil?
	       p "err logic err?  locas_id:#{locas_id}"
		   raise
		  else
		   dealers_id = dealer[:id]
	    end 
	    return dealers_id
	end
    def sub_get_locas_id_fm_dealers_id  dealers_id
	    dealer = plsql.dealers.first("where id = #{dealers_id} ")
		if dealer.nil?
	       p "err logic err?  dealers_id:#{dealers_id}"
		   raise
		  else
		   locas_id = dealer[:locas_id_dealer]
	    end 
	    return locas_id
	end   
    def proc_get_tree_itms_locas ngantts ### bgantt 表示内容　ngantt treeスタック  itm_idは必須
        ##ngantts[:seq,:mlevel,:loca_id,:itm_id]
        ##@bgantts{seq=>{:itm_code,:itm_name,:loca_code,:loca_name,:mlevel,:nditm_parenum,:nditm_chilnum,:opeitm_duration,:assigs,}}
        n0 = ngantts.shift
	    if n0.size > 0  ###子部品がいなかったとき{}になる。
            r0 =  plsql.opeitms.first("where itms_id = #{n0[:itm_id]}  and processseq = #{n0[:processseq] ||= 999} and priority = #{n0[:priority] ||= 999} and Expiredate > current_date")
            if r0 then
                strtime = vproc_get_contents(n0,r0)
                tmp = vproc_get_chil_itms(n0,r0,strtime)
                ngantts.concat(tmp) if tmp[0].size > 0 
                tmp = sub_get_prev_process(n0,r0,strtime)
                ngantts.concat(tmp) if tmp[0].size > 0 
              else
                vproc_get_contents(n0,{})
                #p "where itms_id = #{n0[:itm_id]} and locas_id = #{n0[:loca_id]} and processseq = #{n0[:processseq]} and priority = #{n0[:priority]} and Expiredate > current_date"
            end
	    end	
        return ngantts
    end  ##  psub_get_itms_locas に登録されたitmsは削除  
    def proc_get_tree_under_opeitm opeitm_id
		ngantts = []
		n0 = {}
		r0 =  plsql.opeitms.first("where id = #{opeitm_id} ")
		n0[:itm_id] = r0[:itms_id]
		n0[:processseq] = r0[:processseq]
		n0[:priority] = r0[:priority]
		n0[:seq] = "000"
		n0[:endtime]  = Time.now
		n0[:mlevel] = 0
		ngantts << n0			
		if r0 then
            strtime = vproc_get_contents(n0,r0)
            tmp = vproc_get_chil_itms(n0,r0,strtime)
            ngantts.concat(tmp) if tmp[0].size > 0 
            tmp = sub_get_prev_process(n0,r0,strtime)
            ngantts.concat(tmp) if tmp[0].size > 0 
         end
        return ngantts
    end

    def vproc_get_contents(n0,r0)   ##
        ##fprnt "n0:#{n0}"
	    ##fprnt "r0:#{r0}"
        bgantt = {}
        itm = plsql.itms.first("where id = #{n0[:itm_id]} ")
	    if n0[:loca_id]
            loca = plsql.locas.first("where id = #{n0[:loca_id]} ")
	       else
	        rec = plsql.opeitms.first("where itms_id = #{r0[:itms_id]} and Expiredate > current_date and Priority = #{r0[:priority]}   order by   processseq desc")
	        loca = plsql.locas.first("where id = #{rec[:locas_id]} ")
        end
	    qty = if n0[:seq].size > 4 then (@bgantts[n0[:seq][0..-4].to_sym][:qty] ||= 1) else  (@bgantts["000".to_sym][:qty] ||= 1) end
	    new_qty = qty / (n0[:nditm_parenum]||=1) * (n0[:nditm_chilnum]||=1)
        bgantt[n0[:seq].to_sym] = {:mlevel=>n0[:mlevel],:itm_code=>itm[:code],:itm_name=>itm[:name],:loca_code=>loca[:code],:loca_name=>loca[:name],:opeitm_duration=>(r0[:duration]||=1),
                                 :assigs=>"",:endtime=>n0[:endtime],:endtime_est=>n0[:endtime],
								 :starttime=>n0[:endtime]-(r0[:duration]||=1)*24*60*60,
								 :starttime_est=>n0[:endtime]-(r0[:duration]||=1)*24*60*60,
								 :depends=>"",
								 :nditm_parenum=>n0[:nditm_parenum]||=1,:nditm_chilnum=>n0[:nditm_chilnum]||=1,:prdpurshp=>r0[:prdpurshp],
                                 :subtblid=>"opeitms_"+r0[:id].to_s,:id=>n0[:id],:opeitm_id=>r0[:id],:itm_id=>r0[:itms_id],:processseq=>r0[:processseq],:qty=>new_qty}
        @bgantts.merge! bgantt
	    @min_time = bgantt[n0[:seq].to_sym][:starttime] if (@min_tim||="2099/12/31".to_time) > bgantt[n0[:seq].to_sym][:starttime]
        return bgantt[n0[:seq].to_sym][:starttime]
    end
    def prv_resch_trn   ##本日を起点に再計算
        dp_id = 1
        @bgantts.sort.each  do|key,value|    ###set dependon
            if key.to_s.size > 3 then
                @bgantts[key.to_s[0..-4].to_sym][:depends] << dp_id.to_s + "," 
            end
            dp_id += 1
        end

        today = Time.now
        @bgantts.sort.reverse.each  do|key,value|  ###計算
		    if key.to_s.size > 3
                if  value[:depends] == ""
		    	    if @bgantts[key][:starttime_est]  <  today
                       @bgantts[key][:starttime_est]  =  today		   
                       @bgantts[key][:endtimeest]  =   @bgantts[key][:starttime_est] + value[:opeitm_duration]*24*60*60    ###稼働日考慮今なし
                    end					  
			    end
                if  (@bgantts[key.to_s[0..-4].to_sym][:starttime_est] ) < @bgantts[key][:endtime_est]
                    @bgantts[key.to_s[0..-4].to_sym][:starttime_est]  =   @bgantts[key][:endtime_est]   ###稼働日考慮今なし
                    @bgantts[key.to_s[0..-4].to_sym][:endtime_est] =  @bgantts[key.to_s[0..-4].to_sym][:starttime_est]  + @bgantts[key.to_s[0..-4].to_sym][:opeitm_duration] *24*60*60
				    ##p key
				    ##p @bgantts[key]
			    end
            end
        end		
        @bgantts.sort.each  do|key,value|  ###topから再計算
		    if key.to_s.size > 3
                if  (@bgantts[key.to_s[0..-4].to_sym][:starttime_est]  ) > @bgantts[key][:endtime_est]  			   
                      @bgantts[key][:endtime_est]  =   @bgantts[key.to_s[0..-4].to_sym][:starttime_est]    ###稼働日考慮今なし
                      @bgantts[key][:starttime_est] =  @bgantts[key][:endtime_est]  - value[:opeitm_duration] *24*60*60
                end					  
            end
        end
        return 
    end    
    def proc_tblinks command_c
	    strsql = " select * from r_tblinks where pobject_code_scr_src = '#{command_c[:sio_code]}' and tblink_expiredate > current_date "
		strsql << " and tblink_beforeafter = '#{yield}' order by tblink_seqno "
        do_all = plsql.select(:all,strsql)
		if do_all.size > 0
			##proc_command_instance_variable(command_c)  ###該当テーブルの処理前に、実施することがあるのでここでは無効。
			##proc_set_src_tbl command_c
			###if command_c[:opeitm_id]
			##proc_opeitm_instance(command_c) 
			###else
				## ###debugger 
			##	@opeitm = nil
			###end
			do_all.each do |dorec|
				if respond_to?(dorec[:tblink_code])
				    __send__(dorec[:tblink_code],eval(dorec[:tblink_hikisu])) 
				else
					fprnt "line #{__LINE__} method missing #{dorec[:tblink_code]}"
					raise
				end
			end
		end
	end 
	def proc_set_src_tbl command_c  ##rec = command_c  
        @src_tbl = {}   ###テーブル更新
		tblnamechop = command_c[:sio_viewname].split("_",2)[1].chop
        command_c.each do |j,k|
            j_to_stbl,j_to_sfld = j.to_s.split("_",2)		    
            if   j_to_stbl == tblnamechop   ##本体の更新
			    if  k 
	                @src_tbl[j_to_sfld.sub("_id","s_id").to_sym] = k 
                    @src_tbl[j_to_sfld.to_sym] = nil  if k  == "\#{nil}"  ##
				end	
            end   ## if j_to_s.
        end ## rec.each		
        @src_tbl[:persons_id_upd] = command_c[:sio_user_code]
        @src_tbl[:updated_at] = Time.now
        @src_tbl[:created_at] = Time.now  if command_c[:sio_classname] =~ /_add_/
	end
    def proc_command_instance_variable command_c
	    command_tmp = {}
	    if @pare_class == "batch"
    	    tblnamechop = command_c[:sio_viewname].split("_")[1].chop
            command_c.each do |key,val|
	            if  key.to_s.split("_")[0] == tblnamechop and key.to_s.split("_")[2] == "id" and val
				    rec = plsql.select(:first,"select * from #{"r_" + key.to_s.split('_')[1]+'s'} where id = #{val}")
				    rec.each do |reckey,recval|
				        command_tmp[reckey] = recval if recval and reckey.to_s != "id"
				    end
				end
	        end
	    end
		show_data = get_show_data(command_c[:sio_code])
		show_data[:allfields].each  do |fld|  ###必要項目のみセット
		    command_c[fld] = command_tmp[fld]  if command_tmp[fld]
		end
		proc_command_c_to_instance command_c
	    return command_c
    end
	def proc_command_c_to_instance command_c ###@xxxxの作成
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
	                str << "@#{key.to_s} = #{val}\n"
	        end
	    end
	    eval(str)
	end
    def undefined
      nil   
    end
    def get_screen_code 
        case
            when params[:jqgrid_id]   then ##disp
               @jqgrid_id   =  params[:jqgrid_id]
	           @screen_code = params[:jqgrid_id]  if params[:jqgrid_id].split('_div_')[1].nil?    ##子画面無
               @screen_code = params[:jqgrid_id].split('_div_')[1]  if params[:jqgrid_id].split('_div_')[1]    ##子画面
            ##when params[:action]  == "index"  then 
            ##   @jqgrid_id  = @screen_code = params[:id]   ## listからの初期画面の時 とcodeを求める時
            when params[:nst_tbl_val] then
               @jqgrid_id   =  params[:nst_tbl_val]
               @screen_code =  params[:nst_tbl_val].split("_div_")[1]  ###chil_scree_code
		    when params[:dump] then  ### import by excel
               @screen_code = @jqgrid_id = params[:dump][:screen_code]
	    end
    end
    def crt_def_all
        eval("def dummy_def \n end")
        crt_defs = plsql.select(:all,"select * from rubycodings where expiredate > current_date")
        crt_defs.each do |src_tbl|
		    vproc_crt_def_rubycode src_tbl
        end
		proc_create_tblinkfld_def
        crt_defs = plsql.select("select * from tblinks where expiredate > current_date")
        crt_defs.each do |src_tbl|
		    vproc_crt_def_rubycode src_tbl
        end	
	end
    def vproc_crt_def_rubycode src_tbl
		if src_tbl[:code]
			strdef = "def #{src_tbl[:code]}  #{src_tbl[:hikisu]} \n" 
		    strdef << src_tbl[:rubycode]
		    strdef <<"\n end"
		    eval(strdef)
			fprnt strdef
		end
    end
	def str_init_command_c tbl_dest
	    %Q%
		command_c = {} 
		command_c[:sio_session_counter] =   @new_sio_session_counter 
		command_c[:sio_recordcount] = 1
		command_c[:sio_user_code] =   @sio_user_code
		command_c[:sio_code] = command_c[:sio_viewname] =  "#{tbl_dest}"
		command_c[:sio_classname] = @sio_classname
		%
	end
	def proc_set_command_c(command_c,view_dest)		
		command_c[:sio_session_counter] =   @new_sio_session_counter 
		command_c[:sio_recordcount] = 1
		command_c[:sio_classname] = @sio_classname
		command_c[:sio_user_code] =   @sio_user_code
		command_c[:sio_code] = command_c[:sio_viewname] =  view_dest
		yield
		return command_c
	end
	def proc_simple_sio_insert command_c
		proc_insert_sio_c    command_c
        ### @src_tbl作成はproc_update_tableで実施
		proc_update_table command_c,1
		proc_command_c_to_instance command_c  ###@xxxx_yyyy作成
	end
	def str_sio_set
		%Q%
			yield(command_c) if block_given?
		end  ###if @sio_classname =~ /_delete_/
		proc_simple_sio_insert command_c
	end
		%
	end
    def proc_create_tblinkfld_def 	
		strsql = " select * from r_tblinkflds where tblinkfld_expiredate > current_date " 
		strsql << " order by pobject_code_scr_src,pobject_code_tbl_dest,tblink_beforeafter,tblink_seqno,tblinkfld_seqno "
	    recs = ActiveRecord::Base.connection.select_all(strsql)
		streval = ""
		tblchop = ""
		src_screen = ""
		beforeafter = ""
		seqno = ""
	    recs.each do |rec| 	
			if src_screen == ""
				src_screen = rec["pobject_code_scr_src"]
				tblchop = rec["pobject_code_tbl_dest"].chop
				beforeafter = rec["tblink_beforeafter"]
				seqno = rec["tblink_seqno"]
				streval = "def proc_fld_#{src_screen}_#{tblchop}s_#{beforeafter+seqno.to_s}\n"
				streval << str_init_command_c("r_#{rec["pobject_code_tbl_dest"]}")
			else
				if src_screen != rec["pobject_code_scr_src"] or 	tblchop != rec["pobject_code_tbl_dest"].chop or
				   beforeafter != rec["tblink_beforeafter"] or seqno != rec["tblink_seqno"]
					streval << str_sio_set
					fprnt streval
				    eval(streval)
					src_screen = rec["pobject_code_scr_src"]
					tblchop = rec["pobject_code_tbl_dest"].chop
					beforeafter = rec["tblink_beforeafter"]
					seqno = rec["tblink_seqno"]
					streval = "def proc_fld_#{src_screen}_#{tblchop}s_#{beforeafter+seqno.to_s}\n"
					streval << str_init_command_c("r_#{rec["pobject_code_tbl_dest"]}")
				end
			end
			if tblchop  ==  rec["pobject_code_fld"].split("_")[-1] and rec["pobject_code_fld"] !~ /_id/   ###tblchop==delm ###ヘッダーと同じものは除く crttblviewscreen
				fld = rec["pobject_code_fld"].sub("s_id","_id")
			else
				fld = tblchop+"_"+rec["pobject_code_fld"].sub("s_id","_id")
			end
			if  rec["tblinkfld_rubycode"] or  rec["pobject_code_fld"] == "id" or  rec["pobject_code_fld"] =~ /_id/
				if rec["pobject_code_fld"] == "id"
					streval << %Q&
		if @sio_classname =~ /_delete_/ 
			command_c[:#{fld}] = #{rec["tblinkfld_rubycode"]} 
			command_c = vproc_delete_rec_contens(command_c)
		else 
			command_c[:#{fld}] = #{rec["tblinkfld_rubycode"]} \n&
				else
					if rec["tblinkfld_rubycode"]
					streval << %Q&
			command_c[:#{fld}] = #{rec["tblinkfld_rubycode"]} \n&
					else
					streval << %Q&
			command_c[:#{fld}] = "missing id " \n&		
					end
				end
			else
				str = vproc_tblinkfld_dflt_set_fm_rubycoding(fld)
				if str
					streval << %Q&
			command_c[:#{fld}] = #{str} &
				else
					streval << %Q&
			command_c[:#{fld}] = "missing id " \n&	if rec["pobject_code_fld"] =~ /_id/		###_id項目は必須
				end
			end
	    end ##
		if recs.size > 0
		    streval << %Q& command_c[(command_c[:sio_viewname].split("_")[1].chop+"_id").to_sym] = command_c[:id] &
			streval << str_sio_set
			eval(streval)
			fprnt streval
		end
    end
	def vproc_delete_rec_contens(command_c)
		ret_rec = command_c.dup
		rec = ActiveRecord::Base.connection.select_one("select * from #{command_c[:sio_viewname]} where id = #{command_c[:id]}")
		rec.each do |key,val|
			ret_rec[key.to_sym] = val if val
		end
		return ret_rec
	end
	def vproc_tblinkfld_dflt_set_fm_rubycoding fld
		dflt_rubycode = nil
		strsql = %Q& select * from r_rubycodings where pobject_objecttype = 'view_field' 	and  pobject_code = '#{fld}'
							and rubycoding_code like '%dflt_for_tbl_set' &
		rubycode_view = ActiveRecord::Base.connection.select_one(strsql)
		if rubycode_view
			dflt_rubycode = rubycode_view["rubycoding_code"] + " " +(rubycode_view["rubycoding_hikisu"]||="" )
		else
			fld_tbl = fld.split("_",2)[1] 
			strsql = %Q& select * from r_rubycodings where pobject_objecttype = 'tbl_field' 	and  pobject_code = '#{fld_tbl}'
					and rubycoding_code like '%dflt_for_tbl_set' &
			rubycode_tbl = ActiveRecord::Base.connection.select_one(strsql)
			if rubycode_tbl
				dflt_rubycode = rubycode_tbl["rubycoding_code"] + " " + (rubycode_tbl["rubycoding_hikisu"]||="")
			end
		end
		return dflt_rubycode
	end
	#def  vproc_tblinkfld_id_set command_c	
	#	if command_c[:sio_classname] =~ /_add_/
	#		command_c[:id] = plsql.__send__("#{command_c[:sio_viewname].split("_")[1]}_seq").nextval
	#		command_c[(command_c[:sio_viewname].split("_")[1].chop+"_id").to_sym] = command_c[:id]
	#		###変更の時は以前のテーブルの内容も返すこと。
	#	end
	#	return command_c
	#end
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
    def proc_opeitm_instance opeitm_flds
	    @opeitm = {}
		opeitm_flds.each do |key,val|
		    @opeitm[key.to_s.split("_",2)[1].to_sym] = val if key.to_s =~ /^opeitm/   ###.to_sをとる
		end
		@opeitm[:minqty] ||= 0
		@opeitm[:maxqty] = 9999999999 if @opeitm[:maxqty] == 0 or @opeitm[:maxqty].nil?
		@opeitm[:opt_fixoterm] = 365 if  @opeitm[:opt_fixoterm] == 0  or @opeitm[:opt_fixoterm].nil?
		@opeitm[:packqty]  = 1 if @opeitm[:packqty] == 0 or @opeitm[:packqty].nil?
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
	def proc_alloc_chng_act_to_lotstk trn
		strsql = %Q& select * from alloctbls where srctblname = 'trngantts'
						and destblname = '#{trn[:tblname]} and destblid = #{trn[:id]}
						and qty > 0 & 
		alloctbls  = ActiveRecord::Base.connection.select_all(strsql)
		lot_qty = @lotstkhist_qty
		alloc = []
		alloctbls.each do |alloctbl|
			case @sio_classname
				when /_add_/
					if alloctbl[:qty] >= lot_qty 
						new_qty = @lotstkhist_qty
						alloctbl[:qty] -= lot_qty
					else 
						new_qty = alloctbl[:qty]
						alloctbl[:qty] -= 0
					end
					Alloctbl.update(alloctbl["id"],new_qty)
					alloc[:srctblname] = alloctbl["srctblname"]
					alloc[:srctblid] = alloctbl["srctblid"]
					alloc[:desttblname] = "lotstkhists"
					alloc[:destblid] = @lotstkhist_id
					alloc[:qty] = new_qty
					alloc[:allocfree] = "alloc"
					alloc[:id] = proc_get_nextval "alloctbls_seq" 
					alloc[:created_at] = Time.now
					alloc[:updated_at] = Time.now
					alloc[:persons_id_upd] = ActiveRecord::Base.connection.select_one("select * from persons where code = '0'")["id"]
					Alloctbl.create alloc
					alloc[:srctblname] = "lotstkhists"
					alloc[:srctblid] = @lotstkhist_id
					alloc[:desttblname] = alloctbl["srctblid"]  ####おかしいよ
					alloc[:destblid] = trn[:id]
					alloc[:id] = proc_get_nextval "alloctbls_seq" 
					Alloctbl.create alloc
				when /_edit_|_delete_/ ###画面でのチェックも必要か
			end
			lot_qty -= new_qty
			break if lot_qty <= 0
		end
		if lot_qty != 0 and  @sio_classname =~ /_add_/
			fprnt "line #{__LINE__} logic error" 
			fprnt " strsql #{strsql}"
			fprnt "@lotstkhist_id #{@lotstkhist_id}"
			raise
		end
		case @sio_classname
			when /_add_/
				pre_gantt ={"id"=>proc_get_nextval("trngantts_seq"),
					"key"=>"000","orgtblname"=>"lotstkhists",:orgtblid=>@lotstkhist_id,
					"mlevel"=>0,"prjnos_id" => @lotstkhist_prjno_id,
					"strdate"=>Date.today,"duedate"=>Date.today,
					"parenum"=>1,"chilnum"=>1,
					"qty"=>@lotstkhist_qty,"prdpurshp"=>"stk",   ###stkは使用しなくなった。
					"processseq"=>@opeitm[:processseq],"opeitms_id"=>@opeitm[:id],
					"expiredate"=>"2099/12/31".to_date,
					"created_at"=>Time.now,"updated_at"=>Time.now,"remark"=>" create from act",
					"persons_id_upd"=>alloc[:persons_id_upd]} 
				Trngantt.create pre_gantt	### sch,ord,inst,act自身のtrngantts
				pre_gantt["id"] = proc_get_nextval "trngantts_seq" 
				pre_gantt["key"] = "001" 
				pre_gantt["mlevel"] = 1 
				Trngantt.create pre_gantt
				strsql = %Q& select sum(alloctbl.qty) qty from alloctbls alloctbl,trngantts trn
							where alloctbl.srctblname = 'trngantts' and trn.id = alloctbl.srctblid and trn.key = '001'
							and trn.orgtblname = '#{trn[:tblname]} and trn.orgtblid = #{trn[:id]} 
							and destblname = "lotstkhists" and destblid =  #{@lotstkhist_id}
							group by alloctbl.srctblname,alloctbl.srctblid,alloctbl.destblname,alloctbl.destblid & 
				free_qty  = ActiveRecord::Base.connection.select_one(strsql)
				alloc[:srctblname] = "trngantts"
				alloc[:srctblid] = pre_gantt["id"]
				alloc[:desttblname] = "lotstkhists"
				alloc[:destblid] = @lotstkhist_id
				alloc[:id] = proc_get_nextval "alloctbls_seq"
				alloc[:qty] = free_qty[:qty]  
				alloc[:allocfree] = "alloc"
				Alloctbl.create alloc
		end
	end
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
	def proc_get_rec_fm_tblname_tblid tblname,srctblname,srctblid
		if @sio_classname =~ /_add_/
			id = proc_get_nextval "#{tblname}_seq"
		else
			if block_given?
				id = ActiveRecord::Base.connection.select_value("select id from #{tblname} where tblname = '#{srctblname}' and tblid = #{srctblid} #{yield}")
			else
				id = ActiveRecord::Base.connection.select_value("select id from #{tblname} where tblname = '#{srctblname}' and tblid = #{srctblid}")
			end
			if rec.nil?
				debugger
			end
		end
		return id
	end
	def proc_get_rec_fm_tblname_sno tblname,sno
		rec = {}
		if @sio_classname =~ /_add_/
			rec["id"] = proc_get_nextval "#{tblname}_seq"
		else  ###snoはテーブル毎に必ずユニーク
			rec = ActiveRecord::Base.connection.select_one("select * from #{tblname} where sno = #{sno}")
			if rec.nil?
				debugger
			end
		end
		return rec
	end
	
	def proc_get_rec_fm_tblname_yield tblname  ##proc_fld_xxxxの中の項目を求める。
		rec = {}
		if @sio_classname =~ /_add_/
			rec["id"] = proc_get_nextval "#{tblname}_seq"
		else  ###snoはテーブル毎に必ずユニーク
			rec = ActiveRecord::Base.connection.select_one("select * from #{tblname} where #{yield}")
			if rec.nil?
				debugger
			end
		end
		return rec
	end
	def proc_get_viewrec_from_id tblname,id  ## 
		rec = ActiveRecord::Base.connection.select_one("select * from r_#{tblname} where id = #{id}")
		if rec.nil?
			fprnt "error not found 'select * from r_#{tblname} where id = #{id} ' "
			rec = {}
		end
		return rec
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
				loca_code = command_c[:loca_code_dealer]
			when /^prd|^shp/
				pricetbl = "asstwhs"
				loca_code = command_c[:loca_code_to]
			when /mkact/
				case command_c[:mkact_prdpurshp]
					when "pur"
						pricetbl = "dealers"
						if command_c[:mkact_sno_inst]
							strsql = "select * from r_purinsts where purinst_sno = '#{command_c[:mkact_sno_inst]}'"
							loca_code = ActiveRecord::Base.connection.select_one(strsql)["loca_code_dealer"]
						else
							if command_c[:mkact_sno_act]
								strsql = "select * from r_puracts where purinst_sno = '#{command_c[:mkact_sno_act]}'"
								loca_code = ActiveRecord::Base.connection.select_one(strsql)["loca_code_dealer"]
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
					when /^prd|^shp/
						contract = "X"  ###単価未定
						expiredate = ""
						return {:price=>"0",:amt=>"0",:tax=>"0",:amtf=>"0",:contract_price => contract}   ##
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
					return {:pricef=>pricef,:amtf=>amtf}
				end
			when "2"	###納期ベース	
				if tblnamechop =~ /inst|ord|sch/
					expiredate = vproc_price_expiredate_set(contract,command_c)	
				else
					return {:pricef=>pricef,:amtf=>amtf}
				end
			when "3","4"				
				expiredate = vproc_price_expiredate_set(contract,command_c)
			when "C","D" ##C : custs テーブルに従う D:dealersテーブルに従う
				case  pricetbl
					when  "custs"
						strsql = "select  * from r_custs 	
								where loca_code_cust =  '#{loca_code}' and cust_expiredate > current_date " 
						pare_contract = ActiveRecord::Base.connection.select_one(strsql)   ###画面のfield
						expiredate = vproc_price_expiredate_set(pare_contract["cust_contract_price"],command_c)
						if expiredate.nil?
							fprnt "line #{__LINE__} strsql #{strsql}"
							raise
						end
						pare_rule_price = pare_contract["cust_rule_price"]
						amtround = pare_contract["pricemst_amtround"]
						amtdecimal = pare_contract["pricemst_amtdecimal"]
					when  "dealers"
						strsql = "select  * from r_dealers 	
									where loca_code_dealer =  '#{loca_code}' and dealer_expiredate > current_date " 
						pare_contract = ActiveRecord::Base.connection.select_one(strsql)   ###画面のfield
						expiredate = vproc_price_expiredate_set(pare_contract["dealer_contract_price"],command_c)
						if expiredate.nil?
							fprnt "line #{__LINE__} strsql #{strsql}"
							raise
						end
						pare_rule_price = pare_contract["dealer_rule_price"]
						amtround = pare_contract["pricemst_amtround"]
						amtdecimal = pare_contract["pricemst_amtdecimal"]
				end
			when "Z"
				expiredate = ""
		end 
		if expiredate.nil?
			fprnt "line #{__LINE__} proc_price_amt :master error ???"
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
				return {:price=>price.to_s,:amt=>"",:tax=>"",:pricef=>pricef,:amtf=>amtf,:contract_price => contract}
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
		return {:price=>price.to_s,:amt=>amt.to_s,:tax=>tax.to_s,:pricef=>pricef,:amtf=>amtf,:contract_price => contract}
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