# RorBlk
# 2099/12/31を修正する時は　2100/01/01の修正も
 module Ror_blkctl    
	Blksdate = Date.today - 1  ##在庫基準日　sch,ord,instのこれ以前の納期は許さない。
	Confirmdate = Date.today + 7  ##在庫基準日　sch,ord,instのこれ以前の納期は許さない。
    def sub_blkget_grpcode     ## fieldsの名前
        return @pare_class if  @pare_class == "batch"
        tmp_person =  plsql.r_persons.first(:person_email =>current_user[:email])
        ###p " current_user[:email] #{current_user[:email]}"
        if tmp_person.nil?
           p "add person to his or her email "  
		   raise   ### 別画面に移動する　後で対応
            else
          grp_code = tmp_person[:usergroup_code]
        end 
        return grp_code
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
      ##debugger ##fprnt " Line:#{__LINE__} Time:#{Time.now.to_s}  fstrsqly:#{fstrsqly}"
      return orgcode ||= name
    end  ## def getpobj
    def fprnt str
      foo = File.open("#{Rails.root}/log/blk#{Process::UID.eid.to_s}.log", "a") # 書き込みモード
      foo.puts "#{Time.now.to_s}  #{str}"
      foo.close
	  p str
    end   ##fprnt str
    def user_seq_nextval sio_user_code 
	  ##debugger
      ses_cnt_usercode = "userproc_ses_cnt" + sio_user_code.to_s ###user_code 15char 以下
      unless PLSQL::Sequence.find(plsql,ses_cnt_usercode) then 
             plsql.execute "CREATE SEQUENCE #{ses_cnt_usercode}"
             plsql.execute "CREATE SEQUENCE userproc#{sio_user_code.to_s}s_seq"
             userprocs = "CREATE TABLE userproc#{sio_user_code.to_s}s
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
                     ,CONSTRAINT userproc#{sio_user_code.to_s}s_id_pk PRIMARY KEY (id)
					 ,CONSTRAINT userproc#{sio_user_code.to_s}s_uk1 UNIQUE(session_counter,tblname)
                      )"					  
              plsql.execute userprocs
      end
      return plsql.__send__(ses_cnt_usercode).nextval 
    end
    def user_parescreen_nextval sio_user_code 
        parescreen_cnt_usercode = "parescreen_a" + sio_user_code.to_s 
        unless PLSQL::Sequence.find(plsql,parescreen_cnt_usercode) then 
            plsql.execute "CREATE SEQUENCE #{parescreen_cnt_usercode}"
            parescreens = "CREATE TABLE parescreen#{sio_user_code.to_s}s
                   ( id numeric(38)
                    ,rcdkey VARCHAR(200)
                     ,strsql VARCHAR(4000)
                     ,ctltbl VARCHAR(4000)
                     ,Persons_id_Upd numeric(38)
                     ,Update_IP varchar(40)
                     ,created_at timestamp(6)
                     ,Expiredate date
                     ,Updated_at timestamp(6)
                     , CONSTRAINT parescreen#{sio_user_code.to_s}s_id_pk PRIMARY KEY (id)
                      )"
              plsql.execute parescreens
        end
        return plsql.__send__(parescreen_cnt_usercode).nextval 
    end
	def proc_insert_sio_c command_c
		sub_insert_sio_c   command_c
	end
    def sub_insert_sio_c   command_c   ###要求  無限ループにならないこと
		proc_tblinks(command_c) do 
			"before"
		end if command_c[:sio_classname] =~ /_add_|_edit_|_delete_/ ## rec = command_c = sio_xxxxx
        command_c = char_to_number_data(command_c) ###画面イメージからデータtypeへ
        command_c[:sio_id] =  plsql.__send__("SIO_#{command_c[:sio_viewname]}_SEQ").nextval
        command_c[:sio_term_id] =  request.remote_ip  if request  ## batch処理ではrequestはnil　　？？ 
        command_c[:sio_command_response] = "C"
        command_c[:sio_add_time] = Time.now
		##fprnt "line #{__LINE__} command_c=#{command_c}"   ##if command_c[:sio_code] == "r_nditms"
        plsql.__send__("SIO_#{command_c[:sio_viewname]}").insert command_c
		proc_tblinks(command_c) do 
			"after"
		end if command_c[:sio_classname] =~ /_add_|_edit_|_delete_/ ## rec = command_c = sio_xxxxx
    end   ## sub_insert_sio_c
    def sub_userproc_insert command_c
        userproc = {}		
        userproc[:id] = plsql.__send__("userproc#{command_c[:sio_user_code].to_s}s_seq").nextval
	    userproc[:session_counter] = command_c[:sio_session_counter]
        userproc[:tblname] = "sio_"+ command_c[:sio_viewname]
        userproc[:cnt] = command_c[:sio_recordcount]
        userproc[:cnt_out] = 0
        userproc[:status] = "request"
        userproc[:created_at] = Time.now
        userproc[:updated_at] = Time.now
        userproc[:persons_id_upd] = 0
        userproc[:expiredate] = DateTime.parse("2099/12/31")
        plsql.__send__("userproc#{command_c[:sio_user_code].to_s}s").insert userproc
    end     
    def sub_userproc_chk_set command_c
	    if PLSQL::Table.find(plsql, "userproc#{command_c[:sio_user_code].to_s}s")
            strwhere = " where tblname = 'sio_#{command_c[:sio_viewname]}' and "
		    strwhere << " session_counter = #{command_c[:sio_session_counter]} "
            chkuserproc = plsql.__send__("userproc#{command_c[:sio_user_code].to_s}s").first(strwhere)
		    if chkuserproc
			    chkuserproc[:cnt] += 1
                chkuserproc[:where] = {:id=>chkuserproc[:id]}			
                plsql.__send__("userproc#{command_c[:sio_user_code].to_s}s").update 	chkuserproc		  
			else
			    sub_userproc_insert command_c 
			end
		else	
			sub_userproc_insert command_c
		end
		@req_userproc = true
    end
    def sub_parescreen_insert hash_rcd
        parescreen = {}
        parescreen[:id] = @ss_id.to_i
        parescreen[:rcdkey] = nil ###   rcdkey
        parescreen[:strsql] = hash_rcd[:strsql]
        parescreen[:ctltbl] = hash_rcd[:ctltbl]
        parescreen[:created_at] = Time.now
        parescreen[:updated_at] = Time.now
        parescreen[:persons_id_upd] = 0
        parescreen[:expiredate] = Date.today + 1
        plsql.__send__("parescreen#{current_user[:id].to_s}s").insert parescreen
    end
    def sub_insert_sio_r command_r   ####レスポンス
       ##fprnt " class #{self} : LINE #{__LINE__} command_r  = #{command_r}"
        command_r[:sio_id] =  plsql.__send__("SIO_#{command_r[:sio_viewname]}_SEQ").nextval
        command_r[:sio_command_response] = "R"
        command_r[:sio_add_time] = Time.now
          ##debugger
        plsql.__send__("SIO_#{command_r[:sio_viewname]}").insert command_r
        return 
      ##plsql.commit 
    end   ## sub_insert_sio_r 
    def char_to_number_data command_r   ###根本解決を   
       ##rubyXl マッキントッシュ excel windows excel not perfect
       @date1904 = nil
	   viewtype = PLSQL::View.find(plsql,command_r[:sio_viewname]).columns
       ##@show_data[:allfields].each do |i|
	   viewtype.each do |i,j|
	     if command_r[i] then
             ###case @show_data[:alltypes][i]
             case j[:data_type].downcase
                  when /date|^timestamp/ then
			        begin
                       command_r[i] = Time.parse(command_r[i].gsub(/\W/,"")) if command_r[i].class == String
			           command_r[i] = num_to_date(command_r[i])  if command_r[i].class == Fixnum  or command_r[i].class == Float 
			        rescue
                       command_r[i] = Time.now
			        end
                  when /number/ then
                        command_r[i] = command_r[i].gsub(/,|\(|\)|\\/,"").to_f if command_r[i].class == String
                  when /char/
                       command_r[i] = command_r[i].to_i.to_s if command_r[i].class == Fixnum
             end  #case show_data
	      end  ## if command_r
       end  ## sho_data.each
     return command_r
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

    def sub_plsql_blk_paging  command_c,screen_code
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
        tmp_sql << proc_strwhere(command_c)  ###if command_c[:sio_search]  == "true"
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
                ## insert_sio_r recodcount,result_f,contents
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
                ##debugger #fprnt " class #{self} : LINE #{__LINE__}   strsql = '#{ strsql}' "
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
                    ##debugger
	                command_r[:sio_recordcount] = r_cnt
                    command_r[:sio_result_f] = "1"
                    command_r[:sio_message_contents] = nil
	                tmp = {}
                    sub_insert_sio_r(command_r)     ###回答
	                ##debugger
	                tmp.merge! command_r
	                all_sub_command_r <<  tmp   ### all_sub_command_r << command_r にすると以前の全ての配列が最新に変わってしまう
	            end  ##pagedata
	            ##    plsql.select(:all, "#{strsql}").each do |j|
        end   ## case
        ###p  "e: " + Time.now.to_s 
        return all_sub_command_r
    end   ##sub_plsql_blk_paging

    def  proc_strwhere command_c
	  #日付　/ - 固定にしないようにできないか?
        if command_c[:sio_strsql] then
          strwhere =  if command_c[:sio_strsql].downcase.split(")")[-1] =~ /where/ then   " and " else  " where "  end
          else
           strwhere = " WHERE "
        end
        ##xparams gridの生 
	    ##if params[:commit] == "Export" then search_key = params[:export].dup else search_key = params.dup end
		##strwhere = proc_search_key_strwhere search_key,strwhere,@show_data
		strwhere = proc_search_key_strwhere strwhere,@show_data
	end	
	def proc_search_key_strwhere strwhere,show_data
        params.each  do |i,j|  ##xparams gridの生
            next if j.nil? or j == ""
	        case show_data[:alltypes][i.to_sym]
	            when "number"
                    tmpwhere = " #{i} = #{j.to_i}     AND " 
		            tmpwhere = " #{i}  #{j[0]}  #{j[1..-1].to_i}      AND "   if j =~ /^</   or  j =~ /^>/ 
		            tmpwhere = " #{i} #{j[0..1]} #{j[2..-1].to_i}      AND "    if j =~ /^<=/  or j =~ /^>=/ 
	            when /date|^timestamp/
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
        end ### params.each  do |i,j|###
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
        ###debugger
        tbldata = []
        command_c[:sio_viewname]  = @show_data[:screen_code_view] 
        sub_insert_sio_c command_c    ###ページング要求
        rcd = sub_plsql_blk_paging command_c,screen_code
        rcd.each do |j|
            tmp_data = {}
            @show_data[:allfields].each do |k|
                tmp_data[k] = j[k] ## if k_to_s != "id"        ## 2dcのidを修正したほうがいいのかな
                ## tmp_data[k] = rcd[j][:id_tbl] if k_to_s == "id"  ##idは2dcでは必須
                tmp_data[k] = j[k].strftime("%Y/%m/%d") if  @show_data[:alltypes][k] == "date" and  !j[k].nil?
                tmp_data[k] = j[k].strftime("%Y/%m/%d %H:%M") if  @show_data[:alltypes][k] =~ /^time/ and  !j[k].nil?
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
        ##debugger
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
	
    def vproc_get_chil_itms(n0,r0,endtime)  ###工程の始まり=前工程の終わり
		rnditms = plsql.nditms.all("where opeitms_id = #{r0[:id]} and Expiredate > current_date order by opeitms_id ")
		if rnditms.size > 0 then
			ngantts = []
			mlevel = n0[:mlevel] + 1
			rnditms.each.with_index(1)  do |i,cnt|
				chilopeitm = plsql.opeitms.first("where itms_id = #{i[:itms_id_nditm]} and priority = #{r0[:priority]} and  Expiredate > current_date  order by processseq desc")
				###if chilopeitm then chil_loca = chilopeitm[:opeitms_locas_id]  else chil_loca = 0 end
				if chilopeitm 
					chil_loca = chilopeitm[:locas_id]
					prdpurshp = chilopeitm[:prdpurshp] 
					processseq = chilopeitm[:processseq] 
					priority = chilopeitm[:priority]
					opeitm_id = chilopeitm[:id]
				else
					chil_loca = 0
					prdpurshp = "end"
					processseq = 999
				end
				ngantts << {:seq=>n0[:seq] + sprintf("%03d", cnt),:mlevel=>mlevel,:itm_id=>i[:itms_id_nditm],:prd_pur_shp=>prdpurshp,:safestkqty=>i[:safestkqty],
		               :loca_id=>chil_loca,:loca_id_to=>r0[:locas_id],:opeitm_id =>opeitm_id,
					   :priority=>priority,:processseq=>processseq,
					   :endtime=>endtime,:duration=>chilopeitm[:duration],
					   :nditm_parenum=>i[:parenum],:nditm_chilnum=>i[:chilnum],:id=>"nditms_"+i[:id].to_s}
			end 
		else
			ngantts  = [{}]	   
		end
		return ngantts
    end

    def sub_get_prev_process(n0,r0,endtime)  ###工程の始まり=前工程の終わり
      ##debugger
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
      ##debugger
      return ngantts
    end
    def sub_get_prev_opeitm p_opeitm  ###
	    if  p_opeitm[:itms_id_pare] == p_opeitm[:itms_id] 
            strwhere = "where itms_id = #{p_opeitm[:itms_id]} and Expiredate > current_date and Priority = #{p_opeitm[:priority]||= 999} "
            strwhere << " and processseq < #{p_opeitm[:processseq]}  order by   processseq desc"
		    rec = plsql.opeitms.first(strwhere) 		  
		    if rec.nil?
		        strwhere = "where itms_id = #{p_opeitm[:itms_id]} and Expiredate > current_date and Priority = #{p_opeitm[:priority]||= 999} "
                strwhere << " and processseq = #{p_opeitm[:processseq]}  "
		        rec = plsql.opeitms.first(strwhere)
		        if rec then rec = {} end
		    end
		 else  
            strwhere = "where itms_id = #{p_opeitm[:itms_id]} and Expiredate > current_date and Priority = #{p_opeitm[:priority]||= 999}  "
            strwhere << " and processseq = 999 "
		    rec = plsql.opeitms.first(strwhere) 
	    end
        if rec
	        rec
		  else
		    if p_opeitm[:chk] == true
		       rec 
			  else 
               p "logic err 	sub_get_prev_opeitm_processseq   p_opeitm:#{p_opeitm} "
               raise
            end			 
        end
	    return rec
    end
	
    def sub_get_itm_locas_procssseq_frm_opeitm opeitm_id  ###
       ##debugger
       rec = plsql.opeitms.first("where id  = #{opeitm_id} and Expiredate > current_date ")
        if rec
	        rec
		 else
            p "logic err 	sub_get_itm_locas_procssseq_frm_opeitm opeitm_id:#{opeitm_id} "
           raise		  
        end
    end
	
    def sub_get_next_opeitm_processseq_and_loca_id p_opeitm  ###
        ##debugger
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
        ##debugger
        rec = plsql.opeitms.first("where itms_id = #{p_opeitm[:itms_id]} and Expiredate > current_date and Priority = #{p_opeitm[:priority]||=999} and processseq = #{p_opeitm[:processseq]||=999}  ")
        if rec
	        rec
		  else
            p "logic err 	sub_get_opeitms_id_fm_itm_processseq_priority   p_opeitm:#{p_opeitm} "	  
            raise		  
        end
    end

	def proc_get_amt qty ,price ,loca_id
	    (qty||=0)*(price||=0)
	end

	def sub_get_price loca_id,itm_id,isudatesym ,duedatesym
	     1
    end	
    def sub_get_chrgperson_fm_loca loca_id,prd_pur_shp
        case prd_pur_shp
	       when "pur"
	           strwhere = "where locas_id_dealer = #{loca_id} and expiredate > current_date"
               chrgperson = plsql.dealers.first(strwhere)
			   chrgperson_id = chrgperson[:chrgpersons_id_dflt] if chrgperson			      
          else	
	           strwhere = "where locas_id_asstwh = #{loca_id} and expiredate > current_date"
               chrgperson = plsql.asstwhs.first(strwhere)	
			   chrgperson_id = chrgperson[:chrgpersons_id_dflt] if chrgperson	   
	    end
	    if chrgperson_id.nil?
	       chrgperson = plsql.r_chrgpersons.first("where person_code =  'dummy'")
	       if chrgperson.nil? then chrgperson_id = 0  else chrgperson_id = chrgperson[:id] end
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
    def sub_get_dealers_id_fm_locas_id  locas_id
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
        ##debugger
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
        ##debugger  ###opeitmsに登録さ
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
     ##debugger
	    strsql = " select * from r_tblinks where pobject_code_scr_src = '#{command_c[:sio_code]}' and tblink_expiredate > current_date "
		strsql << " and tblink_beforeafter = '#{yield}' order by tblink_seqno "
        do_all = plsql.select(:all,strsql)
		if do_all.size > 0
			proc_command_instance_variable(command_c)
			proc_set_src_tbl command_c
			do_all.each do |dorec|
				if respond_to?(dorec[:tblink_code])
				    if dorec[:tblink_hikisu] then __send__(dorec[:tblink_code],eval(dorec[:tblink_hikisu])) else __send__(dorec[:tblink_code]) end
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
				  else	
			        if respond_to?("proc_view_field_#{j.to_s}_dflt")  ###view_field_xxxx_dflt 画面表示
			            @src_tbl[j_to_sfld.sub("_id","s_id").to_sym] =  __send__("proc_view_field_#{j.to_s}_dflt")
					end
				end	
            end   ## if j_to_s.
        end ## rec.each		
        @src_tbl[:persons_id_upd] = command_c[:sio_user_code]
        @src_tbl[:updated_at] = Time.now
        @src_tbl[:created_at] = Time.now  if command_c[:sio_classname] =~ /_add_/
	end
    def proc_command_instance_variable command_c
     ##debugger
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
			      ##debugger
	                str << "@#{key.to_s} = #{val}\n"
	        end
	    end
	    ##debugger
	    eval(str)
	end
    def undefined
      nil   
    end
    def get_screen_code 
      ###debugger ## 画面の項目
        case
            when params[:q]   then ##disp
               @jqgrid_id   =  params[:q]
	           @screen_code = params[:q]  if params[:q].split('_div_')[1].nil?    ##子画面無
               @screen_code = params[:q].split('_div_')[1]  if params[:q].split('_div_')[1]    ##子画面
            when params[:action]  == "index"  then 
               @jqgrid_id  = @screen_code = params[:id]   ## listからの初期画面の時 とcodeを求める時
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
		end
    end
	def str_init_command_c tbl_dest
	    %Q%
		command_c = {} 
		command_c[:sio_session_counter] =   @new_sio_session_counter 
		command_c[:sio_recordcount] = 1
		command_c[:sio_classname] = @sio_classname
		command_c[:sio_user_code] =   @sio_user_code
		command_c[:sio_code] = command_c[:sio_viewname] =  tbl_dest
		command_c  = vproc_tblinkfld_id_set(command_c)	 
		%
	end
	def str_sio_set
		%Q%
		sub_insert_sio_c    command_c
		sub_userproc_chk_set    command_c
		proc_command_c_to_instance command_c
		end
		%
	end
    def proc_create_tblinkfld_def 	
		strsql = " select * from r_tblinkflds where tblinkfld_expiredate > current_date " 
		strsql << " order by pobject_code_scr_src,pobject_code_tbl_dest,tblink_beforeafter,tblink_seqno,tblinkfld_seqno "
	    recs = plsql.select(:all,strsql)
		streval = ""
		tblchop = ""
		src_screen = ""
		beforeafter = ""
		seqno = ""
	    recs.each do |rec| 	
			if src_screen == ""
				src_screen = rec[:pobject_code_scr_src]
				tblchop = rec[:pobject_code_tbl_dest].chop
				beforeafter = rec[:tblink_beforeafter]
				seqno = rec[:tblink_seqno]
				streval = "def proc_fld_#{src_screen}_#{tblchop}s_#{beforeafter+seqno.to_s}\n"
				streval << str_init_command_c("r_#{rec[:pobject_code_tbl_dest]}")
			else
				if src_screen != rec[:pobject_code_scr_src] or 	tblchop != rec[:pobject_code_tbl_dest].chop or
				   beforeafter != rec[:tblink_beforeafter] or seqno != rec[:tblink_seqno]
					streval << str_sio_set
					##fprnt streval
				    eval(streval)
					src_screen = rec[:pobject_code_scr_src]
					tblchop = rec[:pobject_code_tbl_dest].chop
					beforeafter = rec[:tblink_beforeafter]
					seqno = rec[:tblink_seqno]
					streval = "def proc_fld_#{src_screen}_#{tblchop}s_#{beforeafter+seqno.to_s}\n"
					streval << str_init_command_c("r_#{rec[:pobject_code_tbl_dest]}")
				end
			end
	        streval << %Q%	command_c[:#{(tblchop+"_"+rec[:pobject_code_fld].sub("s_id","_id"))}] = #{rec[:tblinkfld_command_c]} \n% if  rec[:tblinkfld_command_c]
	    end ##
		if recs.size > 0
			streval << str_sio_set
			eval(streval)
			###fprnt streval
		end
    end
	def  vproc_tblinkfld_id_set command_c	
		if command_c[:sio_classname] =~ /_add_/
			command_c[:id] = plsql.__send__("#{command_c[:sio_viewname].split("_")[1]}_seq").nextval
			command_c[(command_c[:sio_viewname].split("_")[1].chop+"_id").to_sym] = command_c[:id]
		end
		return command_c
	end
    def vproc_set_fields_from_allfields value ###画面の内容をcommand_rへ
        command_c = {}
        @show_data[:allfields].each do |j|
	        ## nilは params[j] にセットされない。
            command_c[j] = value[j]  if value[j]      
        end ##
        return command_c
    end
	def proc_set_command_c(command_c,view_dest)		
		command_c[:sio_session_counter] =   @new_sio_session_counter 
		command_c[:sio_recordcount] = 1
		command_c[:sio_classname] = @sio_classname
		command_c[:sio_user_code] =   @sio_user_code
		command_c[:sio_code] = command_c[:sio_viewname] =  view_dest
	end
    def proc_opeitm_instance opeitm_flds
	    @opeitm = {}
		opeitm_flds.each do |key,val|
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
end   ##module Ror_blk