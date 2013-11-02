# RorBlk
# 2099/12/31を修正する時は　2100/01/01の修正も
 module Ror_blk
    def sub_blkget_grpcode     ## fieldsの名前
       return @pare_class if  @pare_class == "batch"
       tmp_person =  plsql.r_persons.first(:person_email =>current_user[:email])
       ###p " current_user[:email] #{current_user[:email]}"
       if tmp_person.nil?
          render :text => "add persons to your email "  and return 
            else
          grp_code = tmp_person[:usergroup_code]
       end 
       return grp_code
     end
     def sub_blkgetpobj code,ptype
       grp_code =  sub_blkget_grpcode 
      if code =~ /_id/ or   code == "id" then
         oragname = code
        else
         orgname = ""      
         basesql = "select pobjgrp_name from R_POBJGRPS where USERGROUP_CODE = '#{grp_code}' and   "
         fstrsql  =  basesql  +  " POBJECT_CODE = '#{code}' and POBJECT_OBJECTTYPE = '#{ptype}' "
         ###  フル項目で指定しているとき
         orgname = plsql.select(:first,fstrsql)[:pobjgrp_name]  if plsql.select(:first,fstrsql)
         ##p "orgname #{orgname}"
         ##p "code #{code}"
         if (orgname.empty? or orgname.nil?) and ptype == "view_field" then  ###view項目の時はテーブル項目まで
            orgname = ""
            code.split('_').each_with_index do |value,index|
		    fstrsqly =  basesql +  "   POBJECT_CODE = '#{if index == 0 then value + "s" else value end}'  and POBJECT_OBJECTTYPE = '#{if index == 0 then  'tbl' else 'tbl_field' end}' "
                 ##p fstrsqly 
		 if plsql.select(:first,fstrsqly) then   ## tbl name get
			orgname <<  plsql.select(:first,fstrsqly)[:pobjgrp_name] 
		    else
                        orgname << value
               end   
            end   ## do code. 
         end ## if orgname
            orgname = code if orgname == "" or orgname.nil?
      end  ## if ocde
      return orgname 
  end  ## def getpobj

  def fprnt str
    foo = File.open("blk#{Process::UID.eid.to_s}.log", "a") # 書き込みモード
    foo.puts "#{Time.now.to_s}  #{str}"
    foo.close
  end   ##fprnt str
  def sub_stk_inout(inout,itms_id,locas_id,duedate,qty,amt,expiredate)   ###  推定在庫・在庫修正
     ##fprnt "LINE #{__LINE__}" 
      ##debugger
      expiredate ||=  Time.parse("2099-12-31 23:59:59")
      case inout.downcase
	   when /acts$/
		dataflg = "acts"
		dataseq =  "0"
	   when /insts$/
		dataflg = "insts"
		dataseq =  "1"
	   when  /ords$/
                 dataflg = "ords"
		dataseq =  "2"
	   when /plns$/
		dataflg = "plns"
		dataseq =  "3"
	   when  /frcs$/
                 dataflg = "frcs"
		dataseq =  "4"
      end   ### case inout
      if /^shp/ =~ inout.downcase then
	   qty = qty * -1
	   amt = amt * -1
      end  ## if/^shp/
        tmp_rec = {}
        tmp_rec[:locas_id] = locas_id
        tmp_rec[:itms_id] = itms_id
	tmp_rec[:dataflg] = dataflg
	tmp_rec[:dataseq] = dataseq
	tmp_rec[:persons_id_upd] = 0
	tmp_rec[:created_at] = Time.now
	tmp_rec[:updated_at] = Time.now
      ##debugger
      rs = plsql.StkHists.first("where dataflg = '#{dataflg}' and itms_id = #{itms_id} and locas_id = #{locas_id} and strdate = to_date('#{duedate.strftime("%Y-%m-%d %H:%M:%S")}','yyyy-mm-dd hh24:mi:ss') ")
      ##debugger

      if rs.nil? then
	 rsz = plsql.StkHists.first("where dataflg = '#{dataflg}' and itms_id = #{itms_id} and locas_id = #{locas_id} and strdate < to_date('#{duedate.strftime("%Y-%m-%d %H:%M:%S")}','yyyy-mm-dd hh24:mi:ss') and expiredate >= to_date('#{duedate.strftime("%Y-%m-%d %H:%M:%S")}','yyyy-mm-dd hh24:mi:ss')  order by strdate desc")
	 if  rsz.nil?   ### 以前に在庫がないとき
	     rszz = plsql.StkHists.first("where dataflg = '#{dataflg}' and itms_id = #{itms_id} and locas_id = #{locas_id} and  expiredate  = to_date('#{(expiredate  + 1).strftime("%Y-%m-%d %H:%M:%S")}','yyyy-mm-dd hh24:mi:ss') ")
            if rszz.nil?
	        tmp_rec[:qty] = 0
	        tmp_rec[:amt] = 0
	        tmp_rec[:strdate] = expiredate  +1
	        tmp_rec[:expiredate] = expiredate  +1
                tmp_rec[:id] = plsql.stkhists_seq.nextval
	        plsql.stkhists.insert tmp_rec
             end   ###if rszz
	     tmp_rec[:qty] = qty
	     tmp_rec[:amt] = amt
           else  ##rsz	
	     tmp_rec[:qty] = qty + rsz[:qty]
	     tmp_rec[:amt] = amt + rsz[:amt]
	 end ## rsz

	 tmp_rec[:strdate] = duedate  
	 tmp_rec[:expiredate] =expiredate  
         tmp_rec[:id] = plsql.stkhists_seq.nextval
	 plsql.stkhists.insert tmp_rec
	  ##debugger    
          rstk_id  =  tmp_rec[:id]
      else   ##if rs
	 rstk_id  =  rs[:id]
	 rs[:qty] += qty
	 rs[:amt]  += amt
	 plsql.stkhists.update(:qty=>rs[:qty],:amt=>rs[:amt],:updated_at=>Time.now,:where=>{:id=>rs[:id]}) 
      end
      brs =  plsql.StkHists.all("where dataflg = '#{dataflg}' and itms_id = #{itms_id} and locas_id = #{locas_id} and strdate > to_date('#{(duedate).strftime("%Y-%m-%d %H:%M:%S")}','yyyy-mm-dd hh24:mi:ss') and    expiredate>= to_date('#{(duedate).strftime("%Y-%m-%d %H:%M:%S")}','yyyy-mm-dd hh24:mi:ss' ) 
 and expiredate<= to_date('#{expiredate.strftime("%Y-%m-%d %H:%M:%S")}','yyyy-mm-dd hh24:mi:ss' )") 
      brs.each do |i|
	      i[:qty] += qty
	      i[:amt] += amt                  
	      plsql.stkhists.update(:qty=>i[:qty],:amt=>i[:amt],:updated_at=>Time.now,:where=>{:id=>i[:id]}) 
       end
	    ##debugger
       return rstk_id
  end  ##sub_stk
  def   sub_mandatory_field_to_id  tmp_key,pkey  ### idとcodeが一対一の時叉はn:1の時この時codeは本日に対して有効であること。
	   fprnt "class #{self} : LINE #{__LINE__} tmp_key #{tmp_key}"
           strwhere = "where Expiredate >= SYSDATE  "
	   delete_key = []
           tmp_key.sort.each do|key, value|
             if pkey == key or pkey.to_s.sub(pkey.to_s.split("_")[1],"") == key.to_s.sub(key.to_s.split("_")[1],"")
		  strwhere << "  and #{key.to_s.split(/_/)[1]} = '#{value}' " 
		  delete_key << key
	     end
           end	
        strwhere << " order by  Expiredate"
        tblname = pkey.to_s.split(/_/,2)[0] + "s"
        fprnt"class #{self} : LINE #{__LINE__} :  tblname : #{tblname}   strwhere = '#{strwhere}' :: pkey #{pkey}"
        aim_id = plsql.__send__(tblname).first(strwhere)
        fprnt" aim_id =  '#{aim_id}',"
	add_char = ""
        add_char =  ("_" + pkey.to_s.split(/_/,3)[2] ) if pkey.to_s.split(/_/,3)[2] 
         others_tbl_id_isrt = {}
        others_tbl_id_isrt[(tblname + "_id" + add_char).to_sym] = aim_id[:id] if aim_id
        others_tbl_id_isrt[:sio_message_contents] = "logic err" if aim_id.nil?
        return  [others_tbl_id_isrt,delete_key]
  end   ### def sub_get...
  def sub_get_ship_locas_frm_itm_id itms_id
       ##debugger
      rs = plsql.OpeItms.first("where itms_id = #{itms_id} and ProcessSeq = (select max(ProcessSeq) from OpeItms where  itms_id = #{itms_id} and Expiredate > sysdate ) and Priority = (select max(Priority) from OpeItms where  itms_id = #{itms_id} and Expiredate > sysdate )  order by expiredate")
       if rs then
	  return rs[:locas_id]
         else
          3.times{ fprnt " ERROR Line #{__LINE__} not found locas_id from  OpeItms   where itms_id = #{itms_id}"}
	  3.times{ p " ERROR Line #{__LINE__} not found locas_id from  OpeItms   where itms_id = #{itms_id}"}
          exit ###画面にメッセージをだす方法 バッチ処理だよ
       end
  end
  def sub_get_ship_locas_frm_itm_code itms_code
      rs = plsql.itms.first("where code = '#{itms_code}'  and Expiredate > sysdate order by expiredate")
      ###debugger
      if rs then
	  return sub_get_ship_locas_frm_itm_id rs[:id]
         else
          3.times{ fprnt " ERROR Line #{__LINE__} not found itms_id from  Itms   where itms_code = #{itms_code}"}
       end
  end
  def sub_get_ship_date fromto,duedate,locas_id_from,locas_id_to
      return duedate
  end
  #### マイナス在庫を補完する
  #夜間処理・まとめた処理で起動すること
  #
  def sub_stkchktbls prm  ###AUTO create ARVxxxx  prm = tsio_r
	 ##debugger
      prm ||= {}
       dataflg = prm[:dataflg].downcase
      case dataflg.downcase
	   when "acts"
		dataseq =  "0"
	   when  "insts"
		dataseq =  "1"
	   when  "ords"
		dataseq =  "2"
	   when  "plns"
		dataseq =  "3"
	   when "frcs"
		dataseq =  "4"
      end
     ###   品目別ロケーション別管理テーブルは必ず存在していること。
      ##debugger
      ro = plsql.stkchktbls.first("where itms_id = #{prm[:itms_id]} and locas_id = #{prm[:locas_id]} and dataflg= '#{dataflg}' and Expiredate > sysdate order by Expiredate ")
      ##debugger
     if ro then
	### 上位在庫数を求める。
	if dataseq > "0" then
		bqty = 0 ;bamt = 0
           for tmpdataseq in 0..(dataseq.to_i - 1) 
               rx = plsql.stkhists.first("where itms_id = #{prm[:itms_id]} and locas_id = #{prm[:locas_id]} and dataseq = '#{tmpdataseq.to_s}' and Expiredate > sysdate  and  Expiredate < to_date('2100/01/01','yyyy/mm/dd') order by Expiredate desc")
	       bqty += rx[:qty]  if rx;bamt += rx[:amt] if rx
	    end   ## for
         end   ## if dataseq
        rp = plsql.stkhists.all("where itms_id = #{prm[:itms_id]} and locas_id = #{prm[:locas_id]} and dataflg= '#{dataflg}' and Expiredate > sysdate and  Expiredate < to_date('2100/01/01','yyyy/mm/dd') order by strdate")
	sub_command_r = {}
	sub_command_r[:sio_user_code] =  0  ###########  batch   
	sub_command_r[:person_code_chrg] =  "0"  ###########    batch
        sub_command_r[:sio_viewname]  =  "r_arv#{dataflg.downcase}"
        sub_command_r[:sio_code]  = sub_command_r[:sio_viewname] 
	sub_command_r[:sio_term_id] =  "1"
        sub_command_r[:sio_session_id] =  sub_command_r[:sio_viewname]  
        sub_command_r[:sio_command_response] = "C"
        sub_command_r[:sio_org_tblname]  =  prm[:orgtblname]
        sub_command_r[:sio_classname] = "plsql_blk_chk_insert"
	qty = 0;amt = 0
	newqty = 0;newamt = 0
	dueday = nil
	if ro[:safestkprd].nil? or  ro[:safestkprd] == 0 then
	   rp.each do |i|
	      qty = i[:qty] + bqty ; amt = i[:amt] + bamt
	      if qty < 0 or  amt < 0 or qty < (ro[:safestkqty] ||= 0) then   ##マイナス在庫又は安全在庫切れ
                  dueday ||= i[:strdate] 
	      end
	      newqty = qty * -1 if qty < 0 
	      newamt = amt * -1 if amt < 0 
	   end  ## rp.each
	 end  ###ro[:safestkprd].nil?  ・・・・
	    ##debugger
	sub_command_r["arv#{dataflg.chop}_stkhist_id".to_sym] = sub_stk_inout( sub_command_r[:sio_viewname],prm[:itms_id],prm[:locas_id],dueday,newqty,newamt,nil)
        sub_command_r[:sio_id] =  plsql.__send__("SIO_#{sub_command_r[:sio_viewname]}_SEQ").nextval
	sub_command_r[:sio_session_counter] = plsql.sessioncounters_seq.nextval  ### user_id に変更
        sub_command_r[:sio_add_time] = Time.now
	sub_command_r["arv#{dataflg.chop}_isudate".to_sym] = Time.now
	sub_command_r["arv#{dataflg.chop}_duedate".to_sym] = dueday
	sub_command_r["arv#{dataflg.chop}_qty".to_sym] = newqty
	sub_command_r["arv#{dataflg.chop}_amt".to_sym] = newamt

        plsql.__send__("SIO_#{sub_command_r[:sio_viewname]}").insert sub_command_r
	dbcud = DbCud.new
        dbcud.perform(sub_command_r[:sio_session_counter],"SIO_#{sub_command_r[:sio_viewname]}")
	## plsql.commit 
      else
	      3.times{ fprnt " ERROR Line #{__LINE__} not found .stkchktbls  where LOCAS_id = #{prm[:locas_id]} and itms_id = #{prm[:itms_id]}"}  
     end
  end  ## sub_chk
  def sub_dec_pur_prd prm   ##prm = tsio_r
      prd = plsql.prcsecs.first("where locas_id_prcsecs = #{prm[:loca_id]} and expiredate > sysdate order by expiredate")
      if prd 
	 tblname =  "prc"
	 else 
	       pur = plsql.dealers.first("where locas_id_dealers = #{prm[:loca_id]} and expiredate > sysdate  order by expiredate ")
	       if  pur
		   tblname = "pur"
	         else 
                    3.times{ fprnt " ERROR Line #{__LINE__} not found locas_id from  PRCSECS OR DEALERS   where LOCAS_id = #{prn[:loca_id]}"}
		    tblbame = ""
		end
        end
       return tblname
  end  ###sub_dec_pur_prd
  def sub_insert_sio_c   command_r   ###要求
      ##debugger
      command_r = char_to_number_data(command_r)
      command_r[:sio_id] =  plsql.__send__("SIO_#{command_r[:sio_viewname]}_SEQ").nextval
      command_r[:sio_term_id] =  request.remote_ip
      command_r[:sio_session_id] = params[:q]
      command_r[:sio_command_response] = "C"
      command_r[:sio_session_counter] =  command_r[:sio_id]   if command_r[:sio_session_counter].nil?  ##
      command_r[:sio_add_time] = Time.now
      #command_r.delete(:msg_ok_ng)  ## sioに照会・更新依頼時は更新結果は不要
      ### remark とcodeがnumberになっていた。原因不明　2011-09-19
      ##fprnt " class #{self} : LINE #{__LINE__} sio_\#{ sub_command_r[:sio_viewname] } :sio_#{sub_command_r[:sio_viewname]}"
      fprnt " class #{self} : LINE #{__LINE__} command_r  = #{command_r}"
      ##debugger
      plsql.__send__("SIO_#{command_r[:sio_viewname]}").insert command_r
      ### plsql.commit 
##   ###p Time.now
##      $ts.write(["C",request.remote_ip,params[:q],sub_command_r[:sio_session_counter],"SIO_#{sub_command_r[:sio_viewname]}"])
  end   ## sub_insert_sio_c
  def sub_insert_sio_r sub_command_r   ####回答
      ##debugger
      ## fprnt " class #{self} : LINE #{__LINE__} sub_command_r  = #{sub_command_r}"
      sub_command_r[:sio_id] =  plsql.__send__("SIO_#{sub_command_r[:sio_viewname]}_SEQ").nextval
      sub_command_r[:sio_command_response] = "R"
      sub_command_r[:sio_add_time] = Time.now
          ##debugger
      plsql.__send__("SIO_#{sub_command_r[:sio_viewname]}").insert sub_command_r
      return sub_command_r
      ##plsql.commit 
  end   ## sub_insert_sio_r 
  def char_to_number_data command_r   ###   
       ##rubyXl マッキントッシュ excel windows excel not perfect
       @date1904 = nil
       show_data = get_show_data(command_r[:sio_code])
       show_data[:allfields].each do |i|
	   if command_r[i] then
             case show_data[:alltypes][i]
                  when "date","timestamp(6)","timestamp" then
			 begin
                           command_r[i] = Time.parse(command_r[i].gsub(/\W/,"")) if command_r[i].class == String
			   command_r[i] = num_to_date(command_r[i])  if command_r[i].class == Fixnum  or command_r[i].class == Float 
			  rescue
                            command_r[i] = Time.now
			  end
                  when "number" then
                         command_r[i] = command_r[i].gsub(/\W/,"").to_f if command_r[i].class == String
                  when "varchar2","char"
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
    def sub_plsql_blk_paging  command_r
    #####   strsqlにコーディングしてないときは、viewをしよう
####     strdql はupdate insertには使用できない。
    ###  command_r[:sio_strsql] = (select  ・・・・) a
    tmp_sql = if command_r[:sio_strsql].nil? then command_r[:sio_viewname]  + " a " else command_r[:sio_strsql] end
    strsql = "SELECT id FROM " + tmp_sql
    ##fprnt "class #{self} : LINE #{__LINE__}  strsql = '#{strsql}"
    tmp_sql << sub_strwhere(command_r)  if command_r[:sio_search]  == "true"
    sort_sql = ""
    unless command_r[:sio_sidx].nil? or command_r[:sio_sidx] == "" then 
	    sort_sql = " ROW_NUMBER() over (order by " +  command_r[:sio_sidx] + " " +  command_r[:sio_sord]  + " ) " 
	  else
	     sort_sql = "rownum "
    end
    cnt_strsql = "SELECT 1 FROM " + tmp_sql 
    fprnt "class #{self} : LINE #{__LINE__}   sub_strwhere = '#{sub_strwhere(command_r)}'"  if command_r[:sio_search]  == "true"
    ##debugger
    command_r[:sio_totalcount] =  plsql.select(:all,cnt_strsql).count  
    case  command_r[:sio_totalcount]
    when nil,0   ## 該当データなし　　回答
         ## insert_sio_r recodcount,result_f,contents
	 contents = "not find record"    ### 将来usergroup毎のメッセージへ
	 command_r[:sio_recordcount] = 0
         command_r[:sio_result_f] = "1"
         command_r[:sio_message_contents] = contents
	  all_sub_command_r = []
         sub_insert_sio_r(command_r)
	  all_sub_command_r[0] =  command_r
    else 
         show_data = get_show_data(command_r[:sio_code])
         strsql = "select #{sub_getfield(show_data)} from (SELECT #{sort_sql} cnt,a.* FROM #{tmp_sql} ) "
         r_cnt = 0
         strsql  <<    " WHERE  cnt <= #{command_r[:sio_end_record]}  and  cnt >= #{command_r[:sio_start_record]} "
         fprnt " class #{self} : LINE #{__LINE__}   strsql = '#{ strsql}' "
         pagedata = plsql.select(:all, strsql)
	 all_sub_command_r  = []
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
  def  sub_strwhere command_r
       show_data = get_show_data(command_r[:sio_code])
	  #日付　/ - 固定にしないようにできないか?
       if command_r[:sio_strsql] then
          strwhere = unless command_r[:sio_strsql].downcase.split(")")[-1] =~ /where/ then  " where "  else " and " end
          else
           strwhere = " WHERE "
       end
       ##fprnt "class #{self} : LINE #{__LINE__} : command_r= '#{command_r}"
       ###params.each  do |i,j|  ##xparams gridの生
       command_r.each  do |i,j|  ##xparams gridの生
	   ###debugger
           next if j.nil?
	   case show_data[:alltypes][i.to_sym]
	      when "number"
                     tmpwhere = " #{i} = #{j.to_i}     AND " 
		     tmpwhere = " #{i}  #{j[0]}  #{j[1..-1].to_i}      AND "   if j =~ /^</   or  j =~ /^>/ 
		     tmpwhere = " #{i} #{j[0..1]} #{j[2..-1].to_i}      AND "    if j =~ /^<=/  or j =~ /^>=/ 
	       when "date",/^timestamp/
		     js = j.to_s
		     case  js.size  
			when 7
			  tmpwhere = " to_char( #{i},'yyyy-mm') = '#{js}'       AND "  if Date.valid_date?(js.split("-")[0].to_i,js.split("-")[1].to_i,01)
			when 8
			  tmpwhere = " to_char( #{i},'yyyy-mm') #{js[0]} '#{js[1..-1]}'      AND "  if Date.valid_date?(j[1..-1].split("-")[0].to_i,j.split("-")[1].to_i,01)  and ( j =~ /^</   or  j =~ /^>/ )
                        when 9 
			  tmpwhere = " to_char( #{i},'yyyy-mm')  #{j[0..1]} '#{j[2..-1]}'      AND "  if Date.valid_date?(j[1..-1].split("-")[0].to_i,j.split("-")[1].to_i,01)   and (j =~ /^<=/  or j =~ /^>=/ )
			when 10
			  tmpwhere = " to_char( #{i},'yyyy-mm-dd') = '#{j}'       AND "  if Date.valid_date?(j.split("-")[0].to_i,j.split("-")[1].to_i,j.split("-")[2].to_i)
			when 11
			  tmpwhere = " to_char( #{i},'yyyy-mm-dd') #{j[0]} '#{j[1..-1]}'      AND "  if Date.valid_date?(j[1..-1].split("-")[0].to_i,j.split("-")[1].to_i,j.split("-")[2].to_i)  and ( j =~ /^</   or  j =~ /^>/ )
                        when 12 
			  tmpwhere = " to_char( #{i},'yyyy-mm-dd')  #{j[0..1]} '#{j[2..-1]}'      AND "  if Date.valid_date?(j[2..-1].split("-")[0].to_i,j.split("-")[1].to_i,j.split("-")[2].to_i)   and (j =~ /^<=/  or j =~ /^>=/ )
                    end ## j.size  
	       when nil
	       else
                     tmpwhere = " #{i} = '#{j}'         AND "
		     tmpwhere = " #{i}  #{j[0]}  '#{j[1..-1]}'         AND "  if j =~ /^</   or  j =~ /^>/ 
		     tmpwhere = " #{i} #{j[0..1]} '#{j[2..-1]}'       AND "    if j =~ /^<=/  or j =~ /^>=/
		     tmpwhere = " #{i} like '#{j}'     AND " if (j =~ /^%/ or j =~ /%$/ ) 
	       #when  "textarea"
               #       tmpwhere = " #{i.to_s} like '#{j}'     AND " if (j =~ /^%/ or j =~ /%$/ ) 
                end   ##show_data[:alltypes][i]
           tmpwhere = " #{i} #{j}    AND " if  j =~/is\s*null/ or j =~/is\s*not\s*null/ 
	   strwhere << tmpwhere  if  tmpwhere 
        end ### params.each  do |i,j|###
       return strwhere[0..-7]
  end   ## sub_strwhere
  def  sub_pdfwhere viewname,reports_id,command_r
      tmpwhere = sub_strwhere command_r
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
  def subpaging  command_r
      ###debugger
      show_data = get_show_data(command_r[:sio_code])
      tbldata = []
      command_r[:sio_viewname]  = show_data[:screen_code_view] 
      sub_insert_sio_c command_r     ###ページング要求
      rcd = sub_plsql_blk_paging command_r
      rcd.each do |j|
          tmp_data = {}
          show_data[:allfields].each do |k|
             tmp_data[k] = j[k] ## if k_to_s != "id"        ## 2dcのidを修正したほうがいいのかな
             ## tmp_data[k] = rcd[j][:id_tbl] if k_to_s == "id"  ##idは2dcでは必須
             tmp_data[k] = j[k].strftime("%Y-%m-%d") if  show_data[:alltypes][k] == "date" and  !j[k].nil?
             tmp_data[k] = j[k].strftime("%Y-%m-%d %H:%M") if  show_data[:alltypes][k] =~ /^time/ and  !j[k].nil?
          end 
	 tbldata << tmp_data
      end ## for
      return [tbldata,rcd[0][:sio_totalcount]]    ###[データの中身,レコード件数]
  end  ##subpagi
  def  sub_getfield show_data
       show_data[:allfields].join(",").to_s
  end   ##  sub_getfield
  def get_show_data screen_code
     show_cache_key =  "show " + screen_code +  sub_blkget_grpcode
     if Rails.cache.exist?(show_cache_key) then
           show_data = Rails.cache.read(show_cache_key)
          else 
	   show_data = set_detail(screen_code )  ## set gridcolumns
     end
     return show_data
  end
end   ##module Ror_blk

