# RorBlk
# 2099/12/31を修正する時は　2100/01/01の修正も
 module Ror_blk
    def sub_blkget_grpcode     ## fieldsの名前
       return @pare_class if  @pare_class == "batch"
       tmp_person =  plsql.r_persons.first(:person_email =>current_user[:email])
       ##  p " current_user[:email] #{current_user[:email]}"
       if tmp_person.nil?
          render :text => "add persons to your email "  and return 
            else
          grp_code = tmp_person[:usergroup_code]
       end 
       return grp_code
     end
     def sub_blkgetpobj code,ptype,grp_code 
      if code =~ /_ID/ or   code == "ID" then
         oragname = code
        else
         orgname = ""      
         basesql = "select pobjgrp_name from R_POBJGRPS where USERGROUP_CODE = '#{grp_code}' and   "
         fstrsql  =  basesql  +  " POBJECT_CODE = '#{code}' and POBJECT_OBJECTTYPE = '#{ptype}' "
         ###  フル項目で指定しているとき
         orgname = plsql.select(:first,fstrsql)[:pobjgrp_name]  if plsql.select(:first,fstrsql)
         ## p "orgname #{orgname}"
         ## p "code #{code}"
         if (orgname.empty? or orgname.nil?) and ptype == "1" then
            orgname = ""
            code.split('_').each do |i|
              fstrsqly =  basesql +  "   POBJECT_CODE = '#{i}' "
              # p pstrsqly
                if plsql.select(:first,fstrsqly) then   ## tbl name get
			orgname <<  plsql.select(:first,fstrsqly)[:pobjgrp_name] 
		    else
                        orgname << i
               end   
            end   ## do code. 
         end ## if orgname
            orgname = code if orgname == "" or orgname.nil?
      end  ## if ocde
      return orgname 
  end  ## def getpobj

  def fprnt str
    foo = File.open("blk#{Process::UID.eid.to_s}.log", "a") # 書き込みモード
    foo.puts str
    foo.close
  end   ##fprnt str
  def get_show_data screen_code 
     show_cache_key =  "show " + screen_code +  sub_blkget_grpcode
     ##debugger
     if Rails.cache.exist?(show_cache_key) then
	 ## create_def(screen_code)  unless respond_to?("process_scrs_#{screen_code}")
         show_data = Rails.cache.read(show_cache_key)
     else 
	 ### create_def screen_code
	 show_data = set_detail  screen_code  ## set gridcolumns
     end
     ##debugger
     return show_data
 end  ## get_show_data
 def set_detail screen_code
      show_data = {}
      det_screen = plsql.r_detailfields.all(
                                "where screen_code = '#{screen_code}'
                                 and detailfield_selection = 1 order by detailfield_seqno ")  ###有効日の考慮
                                 
           ## when no_data 該当データ 「r_DetailFields」が無かった時の処理
           if det_screen.empty?
              ###debugger ## textは表示できないのでメッセージの変更要
	      p  "Create DetailFields #{screen_code} by crt_r_view_sql.rb"
              return show_data 
           end   
           ###
           ### pare_screen = det_screen[0][:detailfield_screens_id]
           pare_screen = det_screen[0][:screen_id]
           screen_viewname = det_screen[0][:screen_viewname].upcase
           ###debugger ## 詳細項目セット
	  if pare_screen.nil? then
	     show_data[:scriptopt] = [] 
	    else
	     set_addbutton(pare_screen)
	   end     ### add  button セット script,gear,....
	   gridcolumns = []
           ###  chkの時のみ
           gridcolumns   << {:field => "msg_ok_ng",
                                        :label => "msg",
                                        :width => 37,
                                        :editable =>  false  } 
           allfields = []
           allfields << "msg_ok_ng".to_sym
           alltypes = {} 
	   icnt = 0
	   grp_code = sub_blkget_grpcode
	   det_screen.each do |i|  
                ## lable名称はユーザgroup固有よりセット    editable はtblから持ってくるように将来はする。
                ##fprnt " i #{i}"
                   tmp_editrules = {}
                   tmp_columns = {}
                   tmp_editrules[:required] = true  if i[:detailfield_indisp] == 1
                   tmp_editrules[:number] = true if i[:detailfield_type] == "NUMBER"
                   tmp_editrules[:date] = true  if i[:detailfield_type] == "DATE"
                   tmp_editrules[:required] = false  if tmp_editrules == {} 
                   tmp_columns[:field] = i[:detailfield_code].downcase
                   tmp_columns[:label] = sub_blkgetpobj(i[:detailfield_code],"1",grp_code)  ##"1":項目
                   ### tmp_columns[:label] ||=  i[:detailfield_code]
                   tmp_columns[:hidden] = if i[:detailfield_hideflg] == 1 then true else false end 
                   tmp_columns[:editrules] = tmp_editrules 
                   tmp_columns[:width] = i[:detailfield_width]
                   tmp_columns[:search] = if i[:detailfield_paragraph]  == 0 and  screen_code =~ /^H\d_/   then false else true end
                   if i[:detailfield_editable] == 1 then
		      tmp_columns[:editable] = true
		      tmp_columns[:editoptions] = {:size => i[:detailfield_edoptsize],:maxlength => i[:detailfield_maxlength] ||= i[:detailfield_edoptsize] }
		     else
		      tmp_columns[:editable] = false
		   end
		   tmp_columns[:edittype]  =  i[:detailfield_type]  if  ["textarea","select","checkbox"].index(i[:detailfield_type]) 
		   if i[:detailfield_type] == "SELECT" or  i[:detailfield_type] == "CHECKBOX" then
		      tmp_columns[:editoptions] = {:value => i[:detailfield_value] } 
		   end
		   if i[:detailfield_type] == "textarea" then
		      tmp_columns[:editoptions] =  {:rows =>"#{i[:detailfield_edoptrow]}",:cols =>"#{i[:detailfield_edoptcols]}"}
		   end
                   if  tmp_columns[:editoptions].nil? then  tmp_columns.delete(:editoptions)  end 
                   ## tmp_columns[:edittype]  =  i[:detailfield_type]  if  ["textarea","select","checkbox"].index(i[:detailfield_type]) 
		   ##debugger
                   if  i[:detailfield_rowpos]     then
			if  i[:detailfield_rowpos]  < 999
                            tmp_columns[:formoptions] =  {:rowpos=>i[:detailfield_rowpos] ,:colpos=>i[:detailfield_colpos] }
			    icnt = i[:detailfield_rowpos] if icnt <  i[:detailfield_rowpos] 
		          else
			    tmp_columns[:formoptions] =  {:rowpos=> icnt += 1,:colpos=>1 }
			end
		       else
                           tmp_columns[:formoptions] =  {:rowpos=> icnt += 1,:colpos=>1 }
		   end 	      
		   gridcolumns << tmp_columns 
                   allfields << i[:detailfield_code].downcase.to_sym  
                   alltypes [i[:detailfield_code].downcase.to_sym] =  i[:detailfield_type].downcase 
           end   ## detailfields.each
	   show_data[:allfields] =  allfields  
           show_data[:alltypes]  =  alltypes  
           show_data[:screen_viewname] = screen_viewname.upcase
           show_data[:gridcolumns] = gridcolumns
	  if pare_screen.nil? then 
	     show_data[:extbutton] = ""
	     show_data[:extdiv_id] = "" 
	    else
	      show_data = set_extbutton(pare_screen,show_data,screen_code)
	  end
        show_cache_key =  "show " + screen_code +  sub_blkget_grpcode
        Rails.cache.write(show_cache_key,show_data) 
	return show_data
  end    ##set_detai
 
 def set_addbutton pare_screen 
      buttonopt = []
      add_button = plsql.r_buttons.select(:all,"where button_Expiredate > sysdate 
                                            and button_screen_id = :1",pare_screen)
      unless add_button.empty?
	      add_button.each do |x|
                 tmp_buttonopt = {}
                 tmp_buttonopt[:button_icon] = x[:button_icon]
                 tmp_buttonopt[:button_title] = x[:button_title]
                 tmp_buttonopt[:button_proc] = x[:button_proc]
                 buttonopt << tmp_buttonopt
             end 
	     ##fprnt "class #{self} : LINE #{__LINE__}   buttonopt :#{  buttonopt }"
             ##fprnt "class #{self} : LINE #{__LINE__}  add_button :#{ add_button }"
        end
      return  buttonopt 
  end   ### set_addbutton pare_screen 
  ################

  def set_extbutton pare_screen,show_data,screen_code     ### 子画面用のラジオボ タンセット
      ##debugger
      ### 同じボタンで有効日が>sysdateのデータが複数あると複数ボタンがでる
      rad_screen = plsql.r_chilscreens.select(:all,"where chilscreen_Expiredate > sysdate 
                                            and chilscreen_screen_id = :1",pare_screen)
           t_extbutton = ""
           t_extdiv_id = ""
           k = 0
	   grp_code = sub_blkget_grpcode
           rad_screen.each do |i|     ###child tbl name sym
               ### view name set
               hash_key = "#{i[:screen_viewname].downcase}".to_sym 
                  k += 1
                  t_extbutton << %Q|<input type="radio" id="radio#{k.to_s}"  name="nst_radio#{screen_code}"|
                  t_extbutton << %Q| value="#{i[:screen_viewname]};#{i[:screen_viewname_chil]};| ### 親のview
                  t_extbutton << %Q|#{i[:screen_code_chil]};1"/>|  
                  t_extbutton << %Q| <label for="radio#{k.to_s}">  #{sub_blkgetpobj(i[:screen_code_chil],"A",grp_code)} </label> |   ##"A"画面
                  t_extdiv_id << %Q|<div id="div_#{i[:screen_viewname]}#{i[:screen_viewname_chil]}"> </div>|
      
        end   ### rad_screen.each
	show_data[:extbutton] =  t_extbutton
	show_data[:extdiv_id] =  t_extdiv_id
	return show_data
  end    ## set_extbutton pare_screen  
  def sub_stk_inout(inout,itms_id,locas_id,duedate,qty,amt,expiredate)   ###  推定在庫・在庫修正
     ##fprnt "LINE #{__LINE__}" 
      ##debugger
      expiredate ||=  Time.parse("2099-12-31 23:59:59")
      case inout.upcase
	   when /ACTS$/
		dataflg = "ACTS"
		dataseq =  "0"
	   when /INSTS$/
		dataflg = "INSTS"
		dataseq =  "1"
	   when  /ORDS$/
                 dataflg = "ORDS"
		dataseq =  "2"
	   when /PLNS$/
		dataflg = "PLNS"
		dataseq =  "3"
	   when  /FRCS$/
                 dataflg = "FRCS"
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
  def   sub_code_to_id  tmp_key  ### idとcodeが一対一の時叉はn:1の時この時codeは本日に対して有効であること。
	   ##fprnt "class #{self} : LINE #{__LINE__} tmp_key #{tmp_key}"
           strwhere = "where Expiredate >= SYSDATE  and "
	   sub_command_r  = {}
           tmp_key.sort.each do|key, value|
                 strwhere = "where Expiredate >= SYSDATE  and code = '#{value}'    "
		 sub_command_r.merge! sub_get_main_data(strwhere,key.to_s) 
           end	
           sub_command_r
  end
  ### code + exipredateでユニークであること
  def   sub_get_main_data strwhere,key
        others_tbl_id_isrt = {}
        strwhere = strwhere + " order by  Expiredate"
        tblname = key.split(/_/,2)[0] + "s"
        ##fprnt"class #{self} : LINE #{__LINE__} :  tblname : #{tblname}   strwhere = '#{strwhere}' :: key #{key}"
        aim_id = plsql.__send__(tblname).first(strwhere)
        ##fprnt" aim_id =  '#{aim_id}',"
        add_char = key.split(/_code/,2)[1] ||= ""
        others_tbl_id_isrt[(tblname + "_id" + add_char).to_sym] = aim_id[:id] if aim_id
        others_tbl_id_isrt[:sio_message_contents] = "logic err" if aim_id.nil?
        return  others_tbl_id_isrt
  end   ### def sub_get...
##  def str_to_hash
##       tmp_array = sub_command_r[:sio_strsql].split(",")
##       ##fprnt"sub_command_r[:sio_strsql] #{sub_command_r[:sio_strsql]}"
##       ##fprnt"tmp_array #{tmp_array}"
##       return Hash[*tmp_array]
##  end
##definde_method process_scrs_code do  |tsio_r|
##  record_auto tsio_r,to_screenl,field
###end
#:to_table=>"aaa"
#:field=>{:aaaa=> fa + fb,:bbbb=>xxxx(zzzz)}	
# fa,zzzzはtsio_rのレコード名
### 必須　文法チェックは画面でする。
def create_def_screen screen_code
    cmdstr = ""
    rs = plsql.screens.select(:first,"where EXPIREDATE> sysdate and code = '#{screen_code}' order by code,EXPIREDATE")     
    cmdstr = "def process_scrs_#{screen_code} tsio_r \n"
    cmdstr << " data = {} \n"
    ##debugger
    if   rs[:ymlcode]  then
	    hashdata = []
	    rs[:ymlcode].split(/:to_/).each do |yml|
	      case 
		when yml =~ /^data/ then
		     cmdstr << yml + "  \n"
                     hashdata << yml.split(/=/,2)[0] 
                when yml =~ /^screen/ then
		     ###cmdstr << "\n ##debugger"
		     cmdstr << "\n" + "record_auto tsio_r"
		     to_screen =  yml.split(/:fields/,2)[0].split(/=>/)[1].chop  ##nl,カンマ,スペースをとる
		     to_viewname =  plsql.screens.select(:first,"where EXPIREDATE> sysdate and code = '#{to_screen}' order by code,EXPIREDATE")
		     ##debugger
		     if to_viewname.nil? then p "err line #{__LINE__} to_sceen = #{to_screen} "; raise "error LINE = #{__LINE__} "  end
		     to_tblname = to_viewname[:viewname].split(/_/,2)[1]
		     cmdstr << %Q|,"#{to_screen}","#{to_tblname}"|
	             if  yml.split(/:fields/,2)[1]  then
			 yml_f = yml.split(/:fields/,2)[1] 
			 cmdstr << "," + yml_f.split(/=>/,2)[1].chomp  if  yml_f.split(/=>/,2)[1]
		     end
		     cmdstr << " do \n"
		     hashdata.each do |i|
                         cmdstr << "\n " +  i
		     end
		     cmdstr << "\n end"	    ###block end
	        when yml  =~ /^sub/ then
		     cmdstr << "\n" + yml
	       end	## end case  
	    end ##end yml
    end  ## if
    cmdstr << "\n end"   ##def end
    fprnt "  LINE #{__LINE__} cmdstr = '#{cmdstr}'"
    ###debugger   ### cmdstr << "\n end"   ## endは画面でセット　チェックもすること  画面を作成したほうがよいかも
    eval(cmdstr)
	###fprnt "create def eval cmdstr = '#{cmdstr}'"
 end

def record_auto tsio_r,to_screen,to_tblname,fields
    ##debugger
    fields ||= {}
    orgtbl = tsio_r[:sio_viewname].split(/_/,2)[1]
    to_command_r = {} 
    screen_code = to_screen.upcase 
    show_data = get_show_data(screen_code)
    ##fprnt " LINE #{__LINE__} show_data[:allfields] = '#{show_data[:allfields]}' "
    tsio_r.each do |k,val| 
	key = k.to_s.sub(orgtbl.downcase.chop,to_tblname.downcase.chop)
	j = key.to_sym
	to_command_r[j] = val if key =~ /^sio_/  
	##fprnt " LINE #{__LINE__} j = '#{j}'" 
	to_command_r[j] = val  if  show_data[:allfields].index(j) 
	###to_command_r[:sio_org_tblid] = va if key == "id_tbl"
    end
    ##debugger
    yield
    fields.each do |m,n|
	 to_command_r[m] = tsio_r[n] if n.is_a?(Symbol)
	 to_command_r[m] = n  unless n.is_a?(Symbol)
    end
    to_command_r[:sio_command_response] = "C"
    to_command_r[:sio_org_tblname]  =  orgtbl
    to_command_r[:sio_org_tblid]  = tsio_r[:id] 
    to_command_r[:sio_code]   = screen_code
    to_command_r[:sio_viewname] =  plsql.screens.select(:first,"where EXPIREDATE> sysdate and code = '#{screen_code}' order by EXPIREDATE")[:viewname]
    to_command_r[:sio_classname] = "plsql_blk_copy_insert"  if to_command_r[:sio_classname] =~ /insert/ 
    to_command_r[:id] =  sub_set_chil_tbl_info(to_command_r)  if to_command_r[:sio_classname] =~ /update/ 
    to_command_r[:id] =  sub_set_chil_tbl_info(to_command_r)  if to_command_r[:sio_classname] =~ /delete/ 
    to_command_r[:sio_id] =  plsql.__send__("SIO_#{to_command_r[:sio_viewname]}_SEQ").nextval
    to_command_r[:sio_session_counter] = plsql.sessioncounters_seq.nextval  ### user_id に変更
    to_command_r[:sio_add_time] = Time.now
    to_command_r.delete(:msg_ok_ng)  ## sioに照会・更新依頼時は更新結果は不要
    ##fprnt " class #{self} : LINE #{__LINE__} sio_\#{ to_command_r[:sio_viewname] } :sio_#{to_command_r[:sio_viewname]}"
    fprnt " class #{self} : LINE #{__LINE__} to_command_r #{to_command_r}"
    ##debugger
    plsql.__send__("SIO_#{to_command_r[:sio_viewname]}").insert to_command_r
    ##debugger
     ##plsql.commit 
     dbcud = DbCud.new
     dbcud.perform(to_command_r[:sio_session_counter],"SIO_#{to_command_r[:sio_viewname]}")
  ### エラーが発生した時　6重に登録された。
 end   ## subcopyinsertsio
 def add_tbl_ctlxxxxxx org_tblname,org_tblid,tblname,tblid
     crttblxxxx(org_tblname) unless plsql.user_tables.first(:table_name=>"CTL#{org_tblname}")
     ctl_command_r = {}
     ctl_command_r[:persons_id_upd] = 0    ### 変更者は0で固定値
     ctl_command_r[:created_at] = Time.now
     ctl_command_r[:expiredate] = Time.parse("2099/12/31")
     ctl_command_r[:id] =  plsql.__send__("CTL#{org_tblname}_seq").nextval
     ctl_command_r[:ptblid]  = org_tblid
     ctl_command_r[:ctblname] = tblname
     ctl_command_r[:ctblid] = tblid
     plsql.__send__("CTL#{org_tblname}").insert ctl_command_r
 end
 def crttblxxxx  org_tblname
     ##debugger
     plsql.execute  strcrttblxxxxxx.gsub("xxxxxx",org_tblname)
     plsql.execute  strcrtseqxxxxxx.gsub("xxxxxx",org_tblname)
 end
 def strcrttblxxxxxx
     %Q|CREATE TABLE Ctlxxxxxx
  ( id NUMBER(38)
  ,PTBLID NUMBER(38)
  ,CTBLName VARCHAR(30)
  ,CTBLID NUMBER(38)
  ,Expiredate date
  ,Remark VARCHAR(200)
  ,Persons_id_Upd NUMBER(38)
  ,Update_IP varchar(40)
  ,created_at date
  ,Updated_at date
  , CONSTRAINT Ctlxxxxxx_id_pk PRIMARY KEY (id) 
  , CONSTRAINT Ctlxxxxxx_01_uk  UNIQUE (PTBLID,id)
  , CONSTRAINT Ctlxxxxxx_02_uk  UNIQUE (CTBLName,CTBLID,id)
)|
 end
 
 def strcrtseqxxxxxx
     %Q|create sequence CTLxxxxxx_SEQ|
 end
 def sub_set_chil_tbl_info to_command_r
     strwhere = "where ptblid = #{to_command_r[:sio_org_tblid]} and "
     strwhere << "ctblname = '#{to_command_r[:sio_viewname].split("_")[1]}'  "
     ctbl_id = plsql.__send__("CTL#{to_command_r[:sio_org_tblname]}").first(strwhere)
     if ctbl_id
	return ctbl_id[:ctblid]
      else
	 fprnt " LINE #{__LINE__}  ptblname CTL#{to_command_r[:sio_org_tblname]} ; strwhere = #{strwhere} "
	 raise "error"
     end
 end
 def reset_show_data screen_code
      ##debugger
      show_cache_key =  "show " + screen_code
      Rails.cache.delete_matched(show_cache_key) 
  end
  def sub_get_ship_locas_frm_itm_id itms_id
      rs = plsql.OpeItms.first("where itms_id = #{itms_id} and ProcessSeq = (select max(ProcessSeq) from OpeItms where  itms_id = '#{itms_id}' and Expiredate > sysdate ) and Priority = (select max(Priority) from OpeItms where  itms_id = '#{itms_id}' and Expiredate > sysdate ) ")
       if rs then
	  return rs[:locas_id]
         else
          3.times{ fprnt " ERROR Line #{__LINE__} not found locas_id from  OpeItms   where itms_id = #{itms_id}"}
       end
  end
  def sub_get_ship_locas_frm_itm_code itms_code
      rs = plsql.itms.first("where code = '#{itms_code}'  and Expiredate > sysdate ")
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
       dataflg = prm[:dataflg].upcase
      case dataflg.upcase
	   when "ACTS"
		dataseq =  "0"
	   when  "INSTS"
		dataseq =  "1"
	   when  "ORDS"
		dataseq =  "2"
	   when  "PLNS"
		dataseq =  "3"
	   when "FRCS"
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
	sub_command_r[:stkhist_person_id_upd] =  0  ###########  batch   
	sub_command_r[:person_code_chrg] =  "0"  ###########    batch
        sub_command_r[:sio_viewname]  =  "R_ARV#{dataflg}"
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
	sub_command_r["arv#{dataflg.chop}_stkhist_id".downcase.to_sym] = sub_stk_inout( sub_command_r[:sio_viewname],prm[:itms_id],prm[:locas_id],dueday,newqty,newamt,nil)
        sub_command_r[:sio_id] =  plsql.__send__("SIO_#{sub_command_r[:sio_viewname]}_SEQ").nextval
	sub_command_r[:sio_session_counter] = plsql.sessioncounters_seq.nextval  ### user_id に変更
        sub_command_r[:sio_add_time] = Time.now
	sub_command_r["arv#{dataflg.chop}_isudate".downcase.to_sym] = Time.now
	sub_command_r["arv#{dataflg.chop}_duedate".downcase.to_sym] = dueday
	sub_command_r["arv#{dataflg.chop}_qty".downcase.to_sym] = newqty
	sub_command_r["arv#{dataflg.chop}_amt".downcase.to_sym] = newamt

        plsql.__send__("SIO_#{sub_command_r[:sio_viewname]}").insert sub_command_r
	dbcud = DbCud.new
        dbcud.perform(sub_command_r[:sio_session_counter],"SIO_#{sub_command_r[:sio_viewname]}")
	## plsql.commit 
      else
	      3.times{ fprnt " ERROR Line #{__LINE__} not found .stkchktbls  where LOCAS_id = #{prm[:locas_id]} and itms_id = #{prm[:itms_id]}"}  
     end
  end  ## sub_chk
 
  def sub_dec_pur_prd prm   ##prm = tsio_r
      prd = plsql.prcsecs.first("where locas_id_prcsecs = #{prm[:loca_id]} and expiredate > sysdate ")
      if prd 
	 tblname =  "PRC"
	 else 
	       pur = plsql.dealers.first("where locas_id_dealers = #{prm[:loca_id]} and expiredate > sysdate ")
	       if  pur
		   tblname = "PUR"
	         else 
                    3.times{ fprnt " ERROR Line #{__LINE__} not found locas_id from  PRCSECS OR DEALERS   where LOCAS_id = #{prn[:loca_id]}"}
		    tblbame = ""
		end
        end
       return tblname
  end  ###sub_dec_pur_prd
  def sub_insert_sio_c   ###要求
      char_to_number_data
      ##debugger
      command_r[:sio_viewname]  = plsql.screens.first("where code = '#{screen_code}' and Expiredate > sysdate order by expiredate ")[:viewname]
      person_id_upd =  (command_r[:sio_viewname].split("_")[1].chop.downcase + "_person_id_upd").to_sym  
      command_r[person_id_upd] = plsql.persons.first(:email =>current_user[:email])[:id]  ||= 0   ###########   LOGIN USER  
      command_r[:sio_code]  = screen_code
      command_r[:sio_id] =  plsql.__send__("SIO_#{command_r[:sio_viewname]}_SEQ").nextval
      command_r[:sio_term_id] =  request.remote_ip
      command_r[:sio_session_id] = params[:q]
      command_r[:sio_command_response] = "C"
      command_r[:sio_session_counter] =  command_r[:sio_id]   if command_r[:sio_session_counter].nil?  ##
      command_r[:sio_add_time] = Time.now
      command_r.delete(:msg_ok_ng)  ## sioに照会・更新依頼時は更新結果は不要
      yield
      ### remark とcodeがnumberになっていた。原因不明　2011-09-19
      ##fprnt " class #{self} : LINE #{__LINE__} sio_\#{ sub_command_r[:sio_viewname] } :sio_#{sub_command_r[:sio_viewname]}"
      fprnt " class #{self} : LINE #{__LINE__} command_r  = #{command_r}"
      ##debugger
      plsql.__send__("SIO_#{command_r[:sio_viewname]}").insert command_r
      ### plsql.commit 
##    p Time.now
##      $ts.write(["C",request.remote_ip,params[:q],sub_command_r[:sio_session_counter],"SIO_#{sub_command_r[:sio_viewname]}"])
  end   ## sub_insert_sio_c
  def sub_insert_sio_r sub_command_r   ####回答
      ##char_to_number_data
      ##debugger
       yield
       fprnt " class #{self} : LINE #{__LINE__} sub_command_r  = #{sub_command_r}"
      sub_command_r[:sio_id] =  plsql.__send__("SIO_#{sub_command_r[:sio_viewname]}_SEQ").nextval
      sub_command_r[:sio_command_response] = "R"
      sub_command_r[:sio_add_time] = Time.now
          ##debugger
      plsql.__send__("SIO_#{sub_command_r[:sio_viewname]}").insert sub_command_r
      ###plsql.commit 
  end   ## sub_insert_sio_r 
  def char_to_number_data    ###   
       ##rubyXl マッキントッシュ excel windows excel not perfect
       @date1904 = nil
      show_data[:allfields].each do |i|
	   if command_r[i] then
             case show_data[:alltypes][i]
                  when "date","timestamp(6)" then
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
end   ##module Ror_blk

