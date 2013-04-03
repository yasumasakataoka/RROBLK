# RorBlk
 module Ror_blk
    def getblkpobj code,ptype     ## fieldsの名前
       return code if  @pare_class == "batch"
       tmp_person =  plsql.r_persons.first(:person_email =>current_user[:email])
       ##  p " current_user[:email] #{current_user[:email]}"
       if tmp_person.nil?
          render :text => "add persons to your email "  and return 
            else
          user_code = tmp_person[:person_code]
       end 
      if code =~ /_ID/ or   code == "ID" then
         oragname = code
        else
         orgname = ""      
         basesql = "select pobjgrp_name from R_POBJGRPS where USERGROUP_CODE = '#{user_code}' and   "
         fstrsql  =  basesql  +  " POBJECT_CODE = '#{code}' and POBJECT_OBJECTTYPE = '#{ptype}' "
         ###  フル項目で指定しているとき
         orgname = plsql.select(:first,fstrsql)[:pobjgrp_name]  unless plsql.select(:first,fstrsql).nil?
         ## p "orgname #{orgname}"
         ## p "code #{code}"
         if orgname.empty? or orgname.nil? then
            orgname = ""
            code.split('_').each do |i|
              fstrsqly =  basesql +  "   POBJECT_CODE = '#{i}' "
              # p pstrsqly
              unless plsql.select(:first,fstrsqly).nil? then   ## tbl name get
                  orgname << plsql.select(:first,fstrsqly)[:pobjgrp_name]
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
  def insert_sio_r tsio_r
      tsio_r[:sio_replay_time] = Time.now
      tsio_r[:sio_command_response] = "R"
      tmp_seq = "SIO_#{tsio_r[:sio_viewname]}_seq"
      tsio_r.each_key do |j_key|  
             tsio_r.delete(j_key) if tsio_r[j_key].nil?
      end
      ## fprnt "class #{self} LINE :#{__LINE__} tsio_r[:sio_viewname] =  #{tsio_r[:sio_viewname]}  command_r #tmp_{to_command_r}  "
      tsio_r[:id] = plsql.__send__(tmp_seq).nextval
      plsql.__send__("SIO_#{tsio_r[:sio_viewname]}").insert tsio_r
  end   ##insert_sio_r  
  def get_show_data screen_code 
     show_cache_key =  "show " + screen_code
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
           show_data[:scriptopt] = set_addbutton(pare_screen)     ### add  button セット script,gear,....
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
	   det_screen.each do |i|  
                ## lable名称はユーザ固有よりセット    editable はtblから持ってくるように将来はする。
                ##    fprnt " i #{i}"
                   tmp_editrules = {}
                   tmp_columns = {}
                   tmp_editrules[:required] = true  if i[:detailfield_indisp] == 1
                   tmp_editrules[:number] = true if i[:detailfield_type] == "NUMBER"
                   tmp_editrules[:date] = true  if i[:detailfield_type] == "DATE"
                   tmp_editrules[:required] = false  if tmp_editrules == {} 
                   tmp_columns[:field] = i[:detailfield_code].downcase
                   tmp_columns[:label] = getblkpobj(i[:detailfield_code],"1") 
                   tmp_columns[:label] ||=  i[:detailfield_code]
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
	show_data =  set_extbutton(pare_screen,show_data,screen_code) 
        show_cache_key =  "show " + screen_code
        Rails.cache.write(show_cache_key,show_data) 
	return show_data
  end    ##set_detai
 
 def set_addbutton pare_screen 
      buttonopt = []
      add_button = plsql.r_buttons.select(:all,"where button_Expiredate > sysdate 
                                            and screen_id = :1",pare_screen)
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
                                            and screen_id = :1",pare_screen)
           t_extbutton = ""
           t_extdiv_id = ""
           k = 0
           rad_screen.each do |i|     ###child tbl name sym
               ### view name set
               hash_key = "#{i[:screen_viewname].downcase}".to_sym 
                  k += 1
                  t_extbutton << %Q|<input type="radio" id="radio#{k.to_s}"  name="nst_radio#{screen_code}"|
                  t_extbutton << %Q| value="#{i[:screen_viewname]};#{i[:screen_viewname_chil]};| ### 親のview
                  t_extbutton << %Q|#{i[:screen_code_chil]};1"/>|  
                  t_extbutton << %Q| <label for="radio#{k.to_s}">  #{getblkpobj(i[:screen_code_chil],"A")} </label> |
                  t_extdiv_id << %Q|<div id="div_#{i[:screen_viewname]}#{i[:screen_viewname_chil]}"> </div>|
      
        end   ### rad_screen.each
	show_data[:extbutton] =  t_extbutton
	show_data[:extdiv_id] =  t_extdiv_id
	return show_data
  end    ## set_extbutton pare_screen  
  def sub_stk_inout(inout,itms_id,locas_id,duedate,qty,amt,expiredate)   ###  推定在庫・在庫修正
      fprnt "LINE #{__LINE__}" 
      ##debugger
      expiredate ||=  Time.parse("2099-12-31 23:59:59")
      case inout.downcase
	   when /$acts/
		dataflg = "acts"
		dataseq =  "0"
	   when /$ins/
		dataflg = "insts"
		dataseq =  "1"
	   when  /$ords/
                 dataflg = "ords"
		dataseq =  "2"
	   when /$plns/
		dataflg = "plns"
		dataseq =  "3"
	   when  /$frcs/
                 dataflg = "frcs"
		dataseq =  "4"
      end
        if /^shp/ =~ inout.downcase then
	   qty = qty * -1
	   amt = amt * -1
	end
        tmp_rec = {}
        tmp_rec[:locas_id] = locas_id
        tmp_rec[:itms_id] = itms_id
	tmp_rec[:dataflg] = dataflg
	tmp_rec[:dataseq] = dataseq
	tmp_rec[:created_at] = Time.now
	tmp_rec[:updated_at] = Time.now
       ##debugger
      rs = plsql.StkHists.all("where dataflg = '#{dataflg}' and itms_id = #{itms_id} and locas_id = #{locas_id} and Expiredate >= to_date('#{duedate.strftime("%Y-%m-%d %H:%M:%S")}','yyyy-mm-dd hh24:mi:ss') and  expiredate <= to_date('#{expiredate.strftime("%Y-%m-%d %H:%M:%S")}','yyyy-mm-dd hh24:mi:ss') order by Expiredate ")
       ##debugger

      if rs.empty? then
	 brs =  plsql.StkHists.first("where dataflg = '#{dataflg}' and itms_id = #{itms_id} and locas_id = #{locas_id} and Expiredate = to_date('#{(duedate - 1).strftime("%Y-%m-%d %H:%M:%S")}','yyyy-mm-dd hh24:mi:ss') ")
	 if brs.nil? then
            tmp_rec[:qty] = 0
	    tmp_rec[:amt] = 0
	    tmp_rec[:expiredate] = duedate - 1
            tmp_rec[:id] = plsql.stkhists_seq.nextval
	    plsql.stkhists.insert tmp_rec
	 end
	  ##debugger

	 tmp_rec[:qty] = qty
	 tmp_rec[:amt] = amt
	 tmp_rec[:expiredate] = expiredate  ##expiredate:パラメータから在庫有効日
	  ##debugger

         tmp_rec[:id] = plsql.stkhists_seq.nextval
	 plsql.stkhists.insert tmp_rec
	  ##debugger

	 rstk_id  =  tmp_rec[:id]
        else
	   rstk_id  =  rs[0][:id]
	   if rs[0][:expiredate]  > duedate then
	      brs =  plsql.StkHists.first("where dataflg = '#{dataflg}' and itms_id = #{itms_id} and locas_id = #{locas_id} and Expiredate = to_date('#{(duedate - 1).strftime("%Y-%m-%d %H:%M:%S")}','yyyy-mm-dd hh24:mi:ss') ")
              if brs.nil?
	         tmp_rec = rs[0]
	         tmp_rec[:expiredate] = duedate  - 1 
                 tmp_rec[:id] = plsql.stkhists.nextval
	         plsql.stkhists.insert tmp_rec
               end
	   end   
	    ##debugger

           rs.each do |i|
	      i[:qty] += qty
	      i[:amt] += amt
	      plsql.stkhists.update(:qty=>i[:qty],:amt=>i[:amt],i[:updated_at]=>Time.now,:where=>{:id=>i[:id]}) 
	   end
	    ##debugger

	    ars = plsql.StkHists.all("where dataflg = '#{dataflg}' and itms_id = #{itms_id} and locas_id = #{locas_id} and expiredate >= to_date('#{expiredate.strftime("%Y-%m-%d %H:%M:%S")}','yyyy-mm-dd hh24:mi:ss') order by Expiredate ")
           if ars.nil?
	      tmp_rec[:qty] = qty
	      tmp_rec[:amt] = amt
	      tmp_rec[:expiredate] = expiredate 
              tmp_rec[:id] = plsql.stkhists.nextval
	      plsql.stkhists.insert tmp_rec
           end
	    ##debugger

      end  ## rs.empty?
      return rstk_id
  end  ##sub_stk
    def   sub_code_to_id  tmp_key
	   ##  fprnt "class #{self} : LINE #{__LINE__} tmp_key #{tmp_key}"
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
        ##  fprnt"class #{self} : LINE #{__LINE__} :  tblname : #{tblname}   strwhere = '#{strwhere}' :: key #{key}"
        aim_id = plsql.__send__(tblname).first(strwhere)
        ## fprnt" aim_id =  '#{aim_id}',"
        add_char = key.split(/_code/,2)[1] ||= ""
        others_tbl_id_isrt[(tblname + "_id" + add_char).to_sym] = aim_id[:id] unless aim_id.nil?
        others_tbl_id_isrt[:sio_message_contents] = "logic err" if aim_id.nil?
        return  others_tbl_id_isrt
  end   ### def sub_get...
##  def str_to_hash
##       tmp_array = command_r[:sio_strsql].split(",")
##       ## fprnt"command_r[:sio_strsql] #{command_r[:sio_strsql]}"
##       ## fprnt"tmp_array #{tmp_array}"
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
    cmdstr = "def process_scrs_#{screen_code} tsio_r " 
    ##debugger
    if   rs[:ymlcode]  then
	    hashdata = []
	    rs[:ymlcode].split(/:to_/).each do |yml|
	      case 
		when yml =~ /^data/ then
                     hashdata << yml 
                when yml =~ /^screen/ then
		     ##debugger
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
		     cmdstr << " do \n data = {} "
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
		### fprnt "create def eval cmdstr = '#{cmdstr}'"
 end

def record_auto tsio_r,to_screen,to_tblname,fields = {}
    begin
    ##debugger
    orgtbl = tsio_r[:sio_viewname].split(/_/,2)[1]
    to_command_r = {} 
    screen_code = to_screen.upcase 
    show_data = get_show_data(screen_code)
    fprnt " LINE #{__LINE__} show_data[:allfields] = '#{show_data[:allfields]}' "
    tsio_r.each do |k,val| 
	key = k.to_s.sub(orgtbl.downcase.chop,to_tblname.downcase.chop)
	j = key.to_sym
	to_command_r[j] = val if key =~ /^sio_/  
	##fprnt " LINE #{__LINE__} j = '#{j}'" 
	to_command_r[j] = val  if  show_data[:allfields].index(j) 
    end
    ##debugger
    yield
    fields.each do |m,n|
	to_command_r[m] = tsio_r[n]  unless n =~ /^sub/   ###項目名を変更してcopy
	to_command_r[m] = n  if n =~ /^sub/               ###サブルーチンから求める。
    end
    to_command_r[:sio_command_response] = "C"
    if to_command_r[:sio_classname] =~ /insert/ then
       to_command_r[:sio_org_tblname]  =  orgtbl
       to_command_r[:sio_classname] = "plsql_blk_copy_insert"
    end	
    to_command_r[:sio_org_tblid]  = tsio_r[:id_tbl] 
    to_command_r[:sio_code]   = screen_code
    to_command_r[:sio_viewname] =  plsql.screens.select(:first,"where EXPIREDATE> sysdate and code = '#{screen_code}' order by EXPIREDATE")[:viewname]
    to_command_r[:id] =  plsql.__send__("SIO_#{to_command_r[:sio_viewname]}_SEQ").nextval
    to_command_r[:sio_session_counter] = plsql.sessioncounters_seq.nextval  ### user_id に変更
    to_command_r[:sio_add_time] = Time.now
    to_command_r.delete(:msg_ok_ng)  ## sioに照会・更新依頼時は更新結果は不要
    ## fprnt " class #{self} : LINE #{__LINE__} sio_\#{ to_command_r[:sio_viewname] } :sio_#{to_command_r[:sio_viewname]}"
    ## fprnt " class #{self} : LINE #{__LINE__} to_command_r #{to_command_r}"
    ##debugger
    plsql.__send__("SIO_#{to_command_r[:sio_viewname]}").insert to_command_r
      rescue
	      debugger
	      plsql.rollback
	      p " error line #{__LINE__}   SIO_#{to_command_r[:sio_viewname]}"
            else
	     plsql.commit 
             dbcud = DbCud.new
             dbcud.perform(to_command_r[:sio_session_counter],"SIO_#{to_command_r[:sio_viewname]}")
  ### エラーが発生した時　6重に登録された。
      end
 end   ## subcopyinsertsio
 def add_tbl_ctlxxxxxx org_tblname,org_tblid,tblname,tblid
     crttblxxxx(org_tblname) unless plsql.user_tables.first(:table_name=>"CTL#{org_tblname}")
     ctl_command_r = {}
     ctl_command_r[:persons_id_upd] = 1    ### 変更者は1で固定値
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
)"|
 end
 
 def strcrtseqxxxxxx
     %Q|create sequence CTLxxxxxx_SEQ|
 end
 def reset_show_data screen_code
      show_cache_key =  "show " + screen_code
      Rails.cache.delete(show_cache_key) if  Rails.cache.exist?(show_cache_key)
  end
  def sub_get_ship_locas itms_id
      rs = plsql.OpeItms.first("where itms_id = '#{itms_id}' and ProcessSeq = (select max(ProcessSeq) from OpeItms where  itms_id = '#{itms_id}' and Expiredate > sysdate ) and Priority = (select max(Priority) from OpeItms where  itms_id = '#{itms_id}' and Expiredate > sysdate ) ")
       if rs then
	  return rs[:locas_id]
         else
          3.times{ fprnt " ERROR Line #{__LINE__} not found locas_id from  OpeItms   where itms_id = #{itms_id}"}
       end
  end
  def sub_get_ship_date fromto,dueday,locas_id_from,locas_id_to
      return dueday
  end
  #### マイナス在庫を補完する
  def sub_stkchktbls prm = {}  ###AUTO create ARVxxxx  prm = tsio_r
	  ##debugger
      case prm[:dataflg].dowmcase
	   when /acts/
		dataflg = "acts"
		dataseq =  "0"
	   when /insts/
		dataflg = "insts"
		dataseq =  "1"
	   when  /ords/
                 dataflg = "ords"
		dataseq =  "2"
	   when /plns/
		dataflg = "plns"
		dataseq =  "3"
	   when  /frcs/
                 dataflg = "frcs"
		dataseq =  "4"
      end
      ###   品目別ロケーション別管理テーブルは必ず存在していること。
      ro = plsql.stkchktbls.first("where itms_id = '#{prm[:itm_id]}' and locas_id = '#{prm[:loca_id]}' and dataflg= '#{prm[:dataflg]}' and Expiredate > sysdate order by Expiredate ")
     if ro then
	### 上位在庫数を求める。
	if dataseq > "0" then
           bqty = 0 ;bamt = 0
           for tmpdataseq in 0..(dataseq.to_i - 1) 
               rx = plsql.stkhists.first("where itms_id = '#{prm[:itm_id]}' and locas_id = '#{prm[:loca_id]}' and dataseq = '#{tmpdataseq.to_s}' and Expiredate > sysdate order by Expiredate desc")
	       bqty += rx[:qty] ;bamt += rx[:amt] if rx
	    end   ## for
         end   ## if dataseq
        rp = plsql.stkhists.all("where itms_id = '#{prm[:itm_id]}' and locas_id = '#{prm[:loca_id]}' and dataflg= '#{prm[:dataflg]}' and Expiredate > sysdate order by Expiredate")
	     command_r = {}
	     command_r[:person_id_upd] =  1  ###########   LOGIN USER  
             command_r[:sio_viewname]  =  "R_ARV#{prm[:dataflg]}".upcase
             command_r[:sio_code]  = command_r[:sio_viewname] 
	     command_r[:sio_term_id] =  "1"
             command_r[:sio_session_id] =  command_r[:sio_viewname]  
             command_r[:sio_command_response] = "C"
             command_r[:sio_org_tblname]  =  prm[:orgtblname]
             command_r[:sio_classname] = "plsql_blk_copy_insert"
	     qty =0
	     dueday = nil
	     if ro[:safestkprd].nil? or  ro[:safestkprd] == 0 then
		rp.each do |i|
		   qty = rp[:qty] + bqty ; amt = rp[:amt] + bamt
		   if (rp[:qty] + bqty) < 0 or (rp[:amt] + bamt) < 0 or (rp[:qty] + bqty)< (ro[:safestkqty] ||= 0) then   ##マイナス在庫又は安全在庫切れ
                      dueday ||= rp[:expiredate] 
		   end
		   newqty = (rp[:qty] + bqty) * -1 if rp[:qty] + bqty < 0 
		   newamt = (rp[:amt] + bamt) * -1 if rp[:amt] + bamt < 0 
		end  ## rp.each
	     end  ###ro[:safestkprd].nil?  ・・・・
	     command_r[:stkhist_id] = sub_stk_inout( command_r[:sio_viewname],prm[:itm_id],prm[:loca_id],prm[:ship_date],qty,amt,nil)
             command_r[:id] =  plsql.__send__("SIO_#{command_r[:sio_viewname]}_SEQ").nextval
	     command_r[:sio_session_counter] = plsql.sessioncounters_seq.nextval  ### user_id に変更
             command_r[:sio_add_time] = Time.now
             plsql.__send__("SIO_#{command_r[:sio_viewname]}").insert command_r
	    plsql.commit 
         else
	      3.times{ fprnt " ERROR Line #{__LINE__} not found .stkchktbls  where LOCAS_id = #{prm[:loca_id]} and itms_id = #{prm[:itm_id]}"}  
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
end   ##module Ror_blk

