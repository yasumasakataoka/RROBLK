# RorBlk
# 2099/12/31を修正する時は　2100/01/01の修正も
 module Ror_blkctl
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

  def fprnt str
    foo = File.open("blk#{Process::UID.eid.to_s}.log", "a") # 書き込みモード
    foo.puts "#{Time.now.to_s}  #{str}"
    foo.close
  end   ##fprnt str
  def user_seq_nextval sio_user_code 
      ses_cnt_usercode = "sesseq_a" + sio_user_code.to_s 
      unless PLSQL::Sequence.find(plsql,ses_cnt_usercode) then 
             plsql.execute "CREATE SEQUENCE #{ses_cnt_usercode}"
             userprocs = "CREATE TABLE userproc#{sio_user_code.to_s}s
                   ( id numeric(38)
                    ,tblname VARCHAR(30)
                     ,status VARCHAR(20)
                     ,cnt numeric(38)
                     ,Persons_id_Upd numeric(38)
                     ,Update_IP varchar(40)
                     ,created_at timestamp(6)
                     ,Expiredate date
                     ,Updated_at timestamp(6)
                     , CONSTRAINT userproc#{sio_user_code.to_s}s_id_pk PRIMARY KEY (id)
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

  def sub_insert_sio_c   command_c   ###要求
      ##debugger
      command_c = char_to_number_data(command_c)
      command_c[:sio_id] =  plsql.__send__("SIO_#{command_c[:sio_viewname]}_SEQ").nextval
      command_c[:sio_term_id] =  request.remote_ip
      command_c[:sio_session_id] = params[:q]
      command_c[:sio_command_response] = "C"
      command_c[:sio_add_time] = Time.now
      #command_c.delete(:msg_ok_ng)  ## sioに照会・更新依頼時は更新結果は不要
      ### remark とcodeがnumberになっていた。原因不明　2011-09-19
       plsql.__send__("SIO_#{command_c[:sio_viewname]}").insert command_c
  end   ## sub_insert_sio_c
  def sio_copy_insert req_command_c
      rshow_data = get_show_data(req_command_c[:sio_code])
      new_command_c = {}
      new_command_c[:sio_org_tblname] = req_command_c[:sio_viewname].split("_")[1]
      new_command_c[:sio_org_tblid] = req_command_c[:id]
      rshow_data[:allfields].each do |i|
           new_command_c[i] = req_command_c[i] if req_command_c[i] 
      end
      req_command_c.each_key do |i|
           new_command_c[i] = req_command_c[i] if i.to_s =~ /^sio/
      end
      new_command_c[:sio_id] =  plsql.__send__("SIO_#{req_command_c[:sio_viewname]}_SEQ").nextval
      #####new_command_c[:id] = plsql.__send__("#{req_command_c[:sio_viewname].split('_')[1]}_seq").nextval   矛盾
      #### insertの時idの関係が有る時があるとの無条件にセットできない。
      new_command_c[:id] = plsql.__send__("#{req_command_c[:sio_viewname].split('_')[1]}_seq").nextval  if new_command_c[:id].nil?
      sym_id = (req_command_c[:sio_viewname].split('_')[1].chop+"_id").to_sym
      new_command_c[sym_id] = new_command_c[:id]
      ##fprnt " class #{self} : LINE #{__LINE__} new_command_c  = #{new_command_c}"  ##debugger
      plsql.__send__("SIO_#{req_command_c[:sio_viewname]}").insert new_command_c
  end
  def sub_userproc_insert command_c
      userproc = {}
      userproc[:id] = command_c[:sio_session_counter]
      userproc[:tblname] = "sio_"+ command_c[:sio_viewname]
      userproc[:cnt] = command_c[:sio_recordcount]
      userproc[:status] = "request"
      userproc[:created_at] = Time.now
      userproc[:updated_at] = Time.now
      userproc[:persons_id_upd] = 0
      userproc[:expiredate] = DateTime.parse("2099/12/31")
      plsql.__send__("userproc#{command_c[:sio_user_code].to_s}s").insert userproc
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
  def sub_insert_sio_r sub_command_r   ####回答
      ##debugger
      ##fprnt " class #{self} : LINE #{__LINE__} sub_command_r  = #{sub_command_r}"
      sub_command_r[:sio_id] =  plsql.__send__("SIO_#{sub_command_r[:sio_viewname]}_SEQ").nextval
      sub_command_r[:sio_command_response] = "R"
      sub_command_r[:sio_add_time] = Time.now
          ##debugger
      plsql.__send__("SIO_#{sub_command_r[:sio_viewname]}").insert sub_command_r
      return 
      ##plsql.commit 
  end   ## sub_insert_sio_r 
  def char_to_number_data command_r   ###   
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
        command_c[:sio_result_f] = "1"
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
           command_r[:sio_result_f] = "0"
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

 def sub_sioxx sio,chk_cmn     ###2014/07/12使用してない。
     tblname = sio.split(/_/,3)[2]
     chk_cmn.each do |rec|
         tmp_key = {}
         r_cnt = 0
         to_cr = {}   ###テーブル更新用
         rec.each do |j,k|
             j_to_s = j.to_s
             ##fprnt"class #{self} : LINE #{__LINE__} j_to_s: #{j_to_s} tblname.chop: #{tblname.chop}"
	     ##debugger
             if   j_to_s.split("_")[0] == tblname.chop then  ##本体の更新
	          ###2013/3/25 追加覚書　 xxxx_id_yyyy   yyyy:自身のテーブルの追加  プラス _idをs_idに
	          to_cr[j_to_s.split(/_/,2)[1].sub("_id","s_id").to_sym] = k  if k  ###org tbl field name
                  to_cr[j_to_s.split(/_/,2)[1].sub("_id","s_id").to_sym] = nil  if k  == '#{nil}'  ##画面項目クリアー
                     else  ### link先のidを求める 自分のテーブル以外の項目は該当テーブルのidを求めるための項目
                        ### 画面では必要項目のみ変更可能にする。
	                unless   j_to_s =~ /(_upd|sio_)/ or k.nil? or j_to_s == "id"   then
                                 ###debugger
                                 tkey = tblname.chop + "_" + j_to_s.split("_")[0] + "_id" + if j_to_s.split("_",3)[2] then "_" + j_to_s.split("_",3)[2] else "" end
			         tmp_key[j] = k  if rec.key?(tkey.to_sym) and k ###mandatory field  
                        end  ## unless j_to_s
                   end   ## if j_to_s.
             end ## j,
	     tmp_key.each do |key,value|  ##code等から別テーブルのidを求める。
	           #if key !~/_code/  then ###chil_screenで必要
	           rvalue = []
                   rvalue=  sub_mandatory_field_to_id(tmp_key,key)  #mandatory fieldからもとめたid優先
                   to_cr.merge! rvalue[0]
	           rvalue[1].each do |delkey|  ##すでにセットしたテーブルからは項目を除く
		     tmp_key.delete(delkey)
		   end
	     end  ### tmp_key.each do |key,value|
	      ##fprnt"class #{self} : LINE #{__LINE__} sio_view_name: #{sio_view_name} strsql: #{strsql} ****person_id #{rec[:person_id_upd]}"
	      to_cr[:persons_id_upd] = rec[:sio_user_code]
	      if to_cr[:sio_message_contents].nil?
		        to_cr[:updated_at] = Time.now
	          case rec[:sio_classname]
                    when  /_insert_/ then
                          ##to_cr[:id] = plsql.__send__(tblname + "_seq").nextval
		                      ##fprnt "class #{self} : LINE #{__LINE__} INSERT : to_cr = #{to_cr}"
                          to_cr[:created_at] = Time.now                 
		                      plsql.__send__(tblname).insert to_cr
		                      chlctltbl(to_cr) if tblname == "chilscreens"
		                when /_update_/ then
                          to_cr[:where] = {:id => rec[:id]}             ##変更分のみ更新
                          ##fprnt "class #{self} : LINE #{__LINE__} update : to_cr = #{to_cr}"
		                      ##debugger
                         to_cr[:updated_at] = Time.now
                         plsql.__send__(tblname).update  to_cr
                   when  /_delete_/ then 
                         plsql.__send__(tblname).delete(:id => rec[:id])
	          end   ## case iud 
	      end  ##to_cr[:sio_message_contents].nil?

	      r_cnt += 1
	         ##debugger 
           command_r = {}
           command_r = rec
           command_r[:sio_recordcount] = r_cnt
           command_r[:sio_result_f] = "0"
           command_r[:sio_message_contents] = nil
           to_cr.each do |i,j| 
              if i.to_s =~ /s_id/  and i.to_s != "persons_id_upd" then   ###変更は　sio_user_codeを使用
		             newi = (tblname.chop + "_" + i.to_s.sub("s_id","_id")).to_sym
		             command_r[newi] = j if j
              end
           command_r[i] = j if i == :id
           end
           command_r[(command_r[:sio_viewname].split("_")[1].chop + "_id").to_sym] =  command_r[:id]
	         sub_insert_sio_r   command_r    ## 結果のsio書き込み
           ##fprnt " LINE #{__LINE__} i #{i} } "
           end  ##chk_cmn.each
	         reset_show_data_screen if sio =~ /screenfields|chilscreens/   ###キャッシュを削除
           reset_show_data_screenlist if tblname == "pobjgrps"   ###キャッシュを削除
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
end   ##module Ror_blk

