# RorBlk
# 2099/12/31を修正する時は　2100/01/01の修正も
 module Ror_blkctl    
	Blksdate = Date.today - 1  ##在庫基準日　sch,ord,instのこれ以前の納期は許さない。
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
    def sub_blkgetpobj code,ptype    ###修正要　full指定しかダメ　　片方しか指定して無いときはテーブルの項目を修正する。
         fstrsqly = ""
         grp_code =  sub_blkget_grpcode 
         if code =~ /_id/ or   code == "id" then
            oragname = code
           else
            orgname = ""      
            basesql = "select pobjgrp_name from R_POBJGRPS where POBJGRP_EXPIREDATE > SYSDATE AND USERGROUP_CODE = '#{grp_code}' and   "
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
    def sub_blkget_code_fm_name name,ptype    ###修正要　full指定しかダメ　　片方しか指定して無いときはテーブルの項目を修正する。
         grp_code =  sub_blkget_grpcode 
         if name =~ /_id/ or   name == "id" then
            orgcode = name
           else
            orgcode = ""      
            basesql = "select POBJECT_CODE  from R_POBJGRPS where POBJGRP_EXPIREDATE > SYSDATE AND USERGROUP_CODE = '#{grp_code}' and   "
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

    def sub_insert_sio_c   command_c   ###要求  無限ループにならないこと
	    if command_c[:sio_classname] =~ /_add_|_edit_|_delete_/ and  command_c[:sio_viewname] !~ /ruby|tblink/ 
		   sub_tblinks_before_sio (command_c) ## rec = command_c = sio_xxxxx
		end
        command_c = char_to_number_data(command_c) ###画面イメージからデータtypeへ
        command_c[:sio_id] =  plsql.__send__("SIO_#{command_c[:sio_viewname]}_SEQ").nextval
        command_c[:sio_term_id] =  request.remote_ip  if request  ## batch処理ではrequestはnil　　？？ 
        command_c[:sio_command_response] = "C"
        command_c[:sio_add_time] = Time.now
		fprnt "line #{__LINE__} command_c=#{command_c}"   ##if command_c[:sio_code] == "r_nditms"
        plsql.__send__("SIO_#{command_c[:sio_viewname]}").insert command_c
		if command_c[:sio_classname] =~ /_add_|_edit_|_delete_/ and  command_c[:sio_viewname] !~ /ruby|tblink/
		    sub_tblinks_after_sio command_c		   ## rec = command_c = sio_xxxxx
	    end
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
		@req_userproc = true
    end
    def sub_parescreen_insert rcdkey,hash_rcd
      parescreen = {}
      parescreen[:id] = @ss_id.to_i
      parescreen[:rcdkey] = rcdkey
      parescreen[:strsql] = hash_rcd[:strsql]
      parescreen[:ctltbl] = hash_rcd[:ctltbl]
      parescreen[:created_at] = Time.now
      parescreen[:updated_at] = Time.now
      parescreen[:persons_id_upd] = 0
      parescreen[:expiredate] = DateTime.parse("2099/12/31")
      plsql.__send__("parescreen#{current_user[:id].to_s}s").insert parescreen
    end
    def sub_insert_sio_r command_r   ####回答
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
       ##show_data = get_show_data(command_r[:sio_code])
       @show_data[:allfields].each do |i|
	     if command_r[i] then
             case @show_data[:alltypes][i]
                  when /date|^timestamp/ then
			        begin
                       command_r[i] = Time.parse(command_r[i].gsub(/\W/,"")) if command_r[i].class == String
			           command_r[i] = num_to_date(command_r[i])  if command_r[i].class == Fixnum  or command_r[i].class == Float 
			        rescue
                       command_r[i] = Time.now
			        end
                  when /number/ then
                        command_r[i] = command_r[i].gsub(/\W/,"").to_f if command_r[i].class == String
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
        tmp_str = plsql.r_screens.first("where pobject_code_scr = '#{screen_code}' and screen_Expiredate > sysdate order by screen_expiredate ")
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
      tmp_sql << sub_strwhere(command_c)  if command_c[:sio_search]  == "true"
      sort_sql = ""
      unless command_c[:sio_sidx].nil? or command_c[:sio_sidx] == "" then 
	    sort_sql = " ROW_NUMBER() over (order by " +  command_c[:sio_sidx] + " " +  command_c[:sio_sord]  + " ) " 
	   else
	    sort_sql = "rownum "
      end
      cnt_strsql = "SELECT 1 FROM " + tmp_sql 
      ##debugger
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
         ##show_data = get_show_data(command_c[:sio_code])
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

    def  sub_strwhere command_c
       ##show_data = get_show_data(command_c[:sio_code])
	  #日付　/ - 固定にしないようにできないか?
       if command_c[:sio_strsql] then
          strwhere =  if command_c[:sio_strsql].downcase.split(")")[-1] =~ /where/ then   " and " else  " where "  end
          else
           strwhere = " WHERE "
       end
       ##fprnt "class #{self} : LINE #{__LINE__} : command_c = '#{command_c}"
       ##xparams gridの生 
	   if params[:commit] == "Export" then search_key = params[:export].dup else search_key = params.dup end
       search_key.each  do |i,j|  ##xparams gridの生
          next if j.nil? or j == ""
	      case @show_data[:alltypes][i.to_sym]
	        when "number"
             tmpwhere = " #{i} = #{j.to_i}     AND " 
		     tmpwhere = " #{i}  #{j[0]}  #{j[1..-1].to_i}      AND "   if j =~ /^</   or  j =~ /^>/ 
		     tmpwhere = " #{i} #{j[0..1]} #{j[2..-1].to_i}      AND "    if j =~ /^<=/  or j =~ /^>=/ 
	        when "date",/^timestamp/
		     js = j.to_s
		     case  js.size  
			    when 7
			        tmpwhere = " to_char( #{i},'yyyy/mm') = '#{js}'       AND "  if Date.valid_date?(js.split("/")[0].to_i,js.split("/")[1].to_i,01)
			    when 8
			        tmpwhere = " to_char( #{i},'yyyy/mm') #{js[0]} '#{js[1..-1]}'      AND "  if Date.valid_date?(j[1..-1].split("/")[0].to_i,j.split("/")[1].to_i,01)  and ( j =~ /^</   or  j =~ /^>/ )
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
		##debugger
       return strwhere[0..-7]
    end   ## sub_strwhere
    def  sub_pdfwhere viewname,reports_id,command_c
      tmpwhere = sub_strwhere command_c
       case  params[:initprnt] 
       when  "1"  then
	    tmpwhere <<  if tmpwhere.size > 1 then " and " else " where " end
	    tmpwhere << "  not exists (select 1 from HisOfRprts x
                                   where tblname = '#{viewname}' and #{viewname.split('_')[1].chop}_id = recordid
				   and reports_id = #{reports_id}) "
       when "2"  then
	    tmpwhere <<  if tmpwhere.size > 1 then " and " else " where " end
	    tmpwhere << "  exists (select 1 from HisOfRprts x
                                   where tblname = '#{viewname}' and #{viewname.split('_')[1].chop}_id = recordid
				   and reports_id = #{reports_id})  "
	    tmpwhere << "and not exists (select 1 from HisOfRprts x
                                   where tblname = '#{viewname}' and #{viewname.split('_')[1].chop}_id = recordid
				   and reports_id = #{reports_id}) and  #{viewname.split('_')[1].chop}_Updated_at < issuedate "
       end 
       if params[:whoupdate] == '1' then
	  tmpwhere <<  if tmpwhere.size > 1 then " and " else " where " end
	  tmpwhere << "  #{viewname.split('_')[1].chop}_person_code_upd =  #{plsql.persons.first(:email =>current_user[:email])[:code] } "
       end
       ##if params[:
       return tmpwhere
    end

    def subpaging  command_c,screen_code
      ###debugger
      ##show_data = get_show_data(command_c[:sio_code])
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
      rs = plsql.OpeItms.first("where itms_id = #{itms_id} and ProcessSeq = (select max(ProcessSeq) from OpeItms where  itms_id = #{itms_id} and Expiredate > sysdate ) 
                               and Priority = (select max(Priority) from OpeItms where  itms_id = #{itms_id} and Expiredate > sysdate )  order by expiredate")
       if rs then
	         return rs[:locas_id]
         else
            3.times{ fprnt " ERROR Line #{__LINE__} not found locas_id from  OpeItms   where itms_id = #{itms_id}"}
	        3.times{ p " ERROR Line #{__LINE__} not found locas_id from  OpeItms   where itms_id = #{itms_id}"}
          exit ###画面にメッセージをだす方法 バッチ処理だよ
       end
    end
	
    def sub_get_chil_itms(n0,r0,endtime)  ###工程の始まり=前工程の終わり
      rnditms = plsql.nditms.all("where opeitms_id = #{r0[:id]} and Expiredate > sysdate order by opeitms_id ")
      if rnditms.size > 0 then
        ngantts = []
        mlevel = n0[:mlevel] + 1
        rnditms.each.with_index(1)  do |i,cnt|
		   ###debugger
		   chilopeitm = plsql.opeitms.first("where itms_id = #{i[:itms_id_nditm]} and priority = #{r0[:priority]} and  Expiredate > sysdate  order by processseq desc")
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
      rec = plsql.opeitms.first("where itms_id = #{r0[:itms_id]} and Expiredate > sysdate and Priority = #{r0[:priority]} and processseq < #{r0[:processseq]}  order by   processseq desc")
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
          strwhere = "where itms_id = #{p_opeitm[:itms_id]} and Expiredate > sysdate and Priority = #{p_opeitm[:priority]||= 999} "
          strwhere << " and processseq < #{p_opeitm[:processseq]}  order by   processseq desc"
		  rec = plsql.opeitms.first(strwhere) 		  
		  if rec.nil?
		     strwhere = "where itms_id = #{p_opeitm[:itms_id]} and Expiredate > sysdate and Priority = #{p_opeitm[:priority]||= 999} "
             strwhere << " and processseq = #{p_opeitm[:processseq]}  "
		     rec = plsql.opeitms.first(strwhere)
		     if rec then rec = {} end
		  end
		 else  
          strwhere = "where itms_id = #{p_opeitm[:itms_id]} and Expiredate > sysdate and Priority = #{p_opeitm[:priority]||= 999}  "
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
      rec = plsql.opeitms.first("where id  = #{opeitm_id} and Expiredate > sysdate ")
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
	        strwhere = "where itms_id = #{p_opeitm[:itms_id]} and Expiredate > sysdate and Priority = #{p_opeitm[:priority]} and processseq > #{p_opeitm[:processseq]}  order by   processseq "
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
      rec = plsql.opeitms.first("where itms_id = #{p_opeitm[:itms_id]} and Expiredate > sysdate and Priority = #{p_opeitm[:priority]||=999} and processseq = #{p_opeitm[:processseq]||=999}  ")
      if rec
	       rec
		else
          p "logic err 	sub_get_opeitms_id_fm_itm_processseq_priority   p_opeitm:#{p_opeitm} "	  
          raise		  
      end
    end

	def sub_get_amt qty ,price ,loca_id,prd_pur_shp
	    (qty||=0)*(price||=0)
	end

	def sub_get_price loca_id,itm_id,isudatesym ,duedatesym
	     1
    end	
    def sub_get_chrgperson_fm_loca loca_id,prd_pur_shp
        case prd_pur_shp
	       when "pur"
	           strwhere = "where locas_id_dealer = #{loca_id} and expiredate > sysdate"
               chrgperson = plsql.dealers.first(strwhere)
			   chrgperson_id = chrgperson[:chrgpersons_id_dflt] if chrgperson			      
          else	
	           strwhere = "where locas_id_asstwh = #{loca_id} and expiredate > sysdate"
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
	def sub_select_column_for_sio_insert command_c,tblname
	    new_command_c = {}
	    colms = PLSQL::Table.find(plsql, tblname).column_names
		colms.each do |colm|
		    new_command_c[colm] = command_c[colm]
		end
		return new_command_c
	end   
   def psub_get_itms_locas ngantts ### bgantt 表示内容　ngantt treeスタック  itm_idは必須
     ##ngantts[:seq,:mlevel,:loca_id,:itm_id]
     ##@bgantts{seq=>{:itm_code,:itm_name,:loca_code,:loca_name,:mlevel,:nditm_parenum,:nditm_chilnum,:opeitm_duration,:assigs,}}
     n0 = ngantts.shift
     ##debugger
	 if n0.size > 0  ###子部品がいなかったとき{}になる。
        r0 =  plsql.opeitms.first("where itms_id = #{n0[:itm_id]}  and processseq = #{n0[:processseq] ||= 999} and priority = #{n0[:priority] ||= 999} and Expiredate > sysdate")
        if r0 then
           strtime = psub_get_contents(n0,r0)
           tmp = sub_get_chil_itms(n0,r0,strtime)
           ngantts.concat(tmp) if tmp.size > 0 
           tmp = sub_get_prev_process(n0,r0,strtime)
           ngantts.concat(tmp) if tmp.size > 0 
        else
           psub_get_contents(n0,{})
          #p "where itms_id = #{n0[:itm_id]} and locas_id = #{n0[:loca_id]} and processseq = #{n0[:processseq]} and priority = #{n0[:priority]} and Expiredate > sysdate"
        end
	 end	
     return ngantts
   end  ##  psub_get_itms_locas に登録されたitmsは削除

   def psub_get_contents(n0,r0)   ##
     ##fprnt "n0:#{n0}"
	 ##fprnt "r0:#{r0}"
     bgantt = {}
     ##debugger  ###opeitmsに登録さ
     itm = plsql.itms.first("where id = #{n0[:itm_id]} ")
	 if n0[:loca_id]
        loca = plsql.locas.first("where id = #{n0[:loca_id]} ")
	  else
	    rec = plsql.opeitms.first("where itms_id = #{r0[:itms_id]} and Expiredate > sysdate and Priority = #{r0[:priority]}   order by   processseq desc")
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
   
    def sub_tblinks_before_sio command_c
		command_c = sub_command_instance_variable(command_c)
     ##debugger
	    strsql = " select * from r_tblinks where pobject_code_scr_src = '#{command_c[:sio_viewname]}' and tblink_expiredate > sysdate "
		strsql << " and tblink_beforeafter like 'before%' and tblink_beforeafter like '%sio' order by tblink_seqno "
        do_all = plsql.select(:all,strsql)
	    do_all.each do |doba|
		    case doba[:tblink_beforeafter]
			    when "before_sio"
	                sub_do_tblinks(doba,command_c)	
			    when "before_self_sio"	
		            strsql = " select * from r_rubycodings where pobject_objecttype = 'screen' and pobject_code = '#{doba[:pobject_code_scr_src]}' and rubycoding_expiredate > sysdate" 
		            do_tbls = plsql.select(:all,strsql)
			        do_tbls.each do |do_tbl|
			            __send__(do_tbl[:rubycoding_code], command_c ) 
			        end
		    end
	    end
    end 
	
    def sub_tblinks_before command_c
		command_c = sub_command_instance_variable(command_c)
	    strsql = " select * from r_tblinks where  pobject_code_scr_src = '#{command_c[:sio_viewname]}' and tblink_expiredate > sysdate "
		strsql << " and (tblink_beforeafter = 'before' or tblink_beforeafter = 'before_self') order by tblink_seqno "
        do_all = plsql.select(:all,strsql)
	    do_all.each do |doba|
		    case doba[:tblink_beforeafter]
			    when "before"
	                sub_do_tblinks(doba,command_c)	
			    when "before_self"	
		            strsql = " select * from r_rubycodings where pobject_objecttype = 'screen' and pobject_code = '#{doba[:pobject_code_scr_src]}' and rubycoding_expiredate > sysdate" 
		            do_tbls = plsql.select(:all,strsql)
			        do_tbls.each do |do_tbl|
			            __send__(do_tbl[:rubycoding_code], command_c ) 
			        end
		    end
	    end
		return command_c
    end 
	
     def sub_tblinks_after_sio command_c
     ##debugger
	    strsql = " select * from r_tblinks where  pobject_code_scr_src = '#{command_c[:sio_viewname]}' and tblink_expiredate > sysdate "
		strsql << " and tblink_beforeafter like 'after%' and tblink_beforeafter like '%sio'  order by tblink_seqno  "
        do_all = plsql.select(:all,strsql)
	    do_all.each do |doba|
		    case doba[:tblink_beforeafter]
			    when "after_sio"
	                sub_do_tblinks(doba,command_c)	
			    when "after_self_sio"	
		            strsql = " select * from r_rubycodings where pobject_objecttype = 'screen' and pobject_code = '#{doba[:pobject_code_scr_src]}' and rubycoding_expiredate > sysdate" 
		            do_tbls = plsql.select(:all,strsql)
			        do_tbls.each do |do_tbl|
			            __send__(do_tbl[:rubycoding_code], command_c ) 
			        end
		    end
	    end
    end 
	
    def sub_tblinks_after command_c
	    strsql = " select * from r_tblinks where pobject_code_scr_src = '#{command_c[:sio_viewname]}' and tblink_expiredate > sysdate  "
		strsql << " and (tblink_beforeafter = 'after' or tblink_beforeafter = 'after_self') order by tblink_seqno "
        do_all = plsql.select(:all,strsql)		
		command_c = sub_command_instance_variable( command_c )
	    do_all.each do |doba|
		    case doba[:tblink_beforeafter]
			    when "after"
	                sub_do_tblinks(doba,command_c)	
			    when "after_self"	
		            strsql = " select * from r_rubycodings where pobject_objecttype = 'screen' and pobject_code = '#{doba[:pobject_code_scr_src]}' and rubycoding_expiredate > sysdate" 
		            do_tbls = plsql.select(:all,strsql)
			        do_tbls.each do |do_tbl|
			            __send__(do_tbl[:rubycoding_code], command_c ) 
			        end
		    end
	    end
    end 
 
    def sub_do_tblinks doba,command_c
        strsql = "select * from r_tblinkkys where pobject_code_scr_src = '#{doba[:pobject_code_scr_src]}' and pobject_code_tbl_dest = '#{doba[:pobject_code_tbl_dest]}' "
	    strsql << " and tblink_beforeafter = '#{doba[:tblink_beforeafter]}'  and tblink_seqno = '#{doba[:tblink_seqno]}' "
	    upd_tblinkkys = plsql.select(:all,strsql)
	    tbln = doba[:pobject_code_tbl_dest]
	    strsqlx = "select * from #{tbln}  where "
	    upd_tblinkkys.each do |updk|
            strsqlx << " #{updk[:pobject_code_fld]} = '#{eval(updk[:tblinkky_command_c])}'   and"		 
	    end
		if upd_tblinkkys.size < 1
           	fprnt " tblink key missing line:#{__LINE__} doba #{doba} "	
			fprnt " tblink key missing  line:#{__LINE__} key record nothing "
			raise
		end
	    ##debugger
	    @target_rec =  plsql.select(:first,strsqlx[0..-5]) 
	    case @target_rec
	    when nil
		    case command_c[:sio_classname]
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
		    case command_c[:sio_classname]
			     when /_add_/
				     fprnt "err line#{__LINE__} same key exists tbln:#{tbln}  -->strsqlx:#{strsqlx[0..-5]} "
					 raise
				 when /_edit_/
				 when /_delete_/
			end			
	    end
	    command_c = {} 
        command_c[:sio_session_counter] =   @new_sio_session_counter ##
		command_c[:sio_recordcount] = 1
        command_c[:sio_classname] = @sio_classname + "_batch"
        command_c[:id] = @id 
	    command_c[:sio_code] = "r_#{tbln}" 
	    command_c[:sio_viewname] = "r_#{tbln}"
        command_c = sub_set_target_rec( command_c ,doba)
	    @show_data = get_show_data(command_c[:sio_code])  ##char_to_number_dataとともに見直し]]
	     ##fprnt "__LINE__ #{__LINE__} command_c #{command_c} " ##debugger
	    command_c[:sio_user_code] =   @sio_user_code ##
	    sub_insert_sio_c    command_c 
	    sub_userproc_chk_set    command_c
    end
	
	def sub_set_src_tbl command_c  ##rec = command_c
        @src_tbl = {}   ###テーブル更新
		tblnamechop = command_c[:sio_viewname].split("_",2)[1].chop
        command_c.each do |j,k|
            j_to_stbl,j_to_sfld = j.to_s.split("_",2)		    
            if   j_to_stbl == tblnamechop   ##本体の更新
	            @src_tbl[j_to_sfld.sub("_id","s_id").to_sym] = k  if k  ###org tbl field name
                @src_tbl[j_to_sfld.to_sym] = nil  if k  == "\#{nil}"  ##
            end   ## if j_to_s.
        end ## rec.each
	end

    def sub_command_instance_variable command_c
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
	    return command_c
    end
    def sub_set_target_rec command_c ,doba
        tblchop = command_c[:sio_viewname].split("_")[1].chop + "_"
        @target_rec.each do |key,val|
	       command_c[(tblchop+key.to_s.sub("s_id","_id")).to_sym] = val if val 
	    end
	    strwhere = "where pobject_code_scr_src = '#{doba[:pobject_code_scr_src]}' and pobject_code_tbl_dest = '#{doba[:pobject_code_tbl_dest]}' " 
	    strwhere << " and tblink_beforeafter = '#{doba[:tblink_beforeafter]}'  and tblink_seqno = '#{doba[:tblink_seqno]}'  "
		strwhere << " order by pobject_code_view_src,pobject_code_tbl_dest,tblinkfld_seqno "
	    target_flds = plsql.r_tblinkflds.all(strwhere)
		streval = ""
	    target_flds.each do |tfld| 	
		    ##fprnt  " tblinkflds line:#{__LINE__}   tfld[:tblinkfld_command_c] #{tfld[:tblinkfld_command_c]} "
	        command_c[(tblchop+tfld[:pobject_code_fld].sub("s_id","_id")).to_sym] = eval(tfld[:tblinkfld_command_c]) if  tfld[:tblinkfld_command_c]
	    end
	    return command_c
    end
    def undefined
      nil   
    end
end   ##module Ror_blk