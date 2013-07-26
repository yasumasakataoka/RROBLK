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
     def sub_blkgetpobj tcode,ptype
       grp_code =  sub_blkget_grpcode 
      if tcode =~ /_id/ or   tcode == "id" then
         oragname = tcode
        else
         orgname = ""      
         basesql = "select pobjgrp_name from R_POBJGRPS where USERGROUP_CODE = '#{grp_code}' and   "
         fstrsql  =  basesql  +  " POBJECT_TCODE = '#{tcode}' and POBJECT_OBJECTTYPE = '#{ptype}' "
         ###  フル項目で指定しているとき
         orgname = plsql.select(:first,fstrsql)[:pobjgrp_name]  if plsql.select(:first,fstrsql)
         ##p "orgname #{orgname}"
         ##p "tcode #{tcode}"
         if (orgname.empty? or orgname.nil?) and ptype == "view_field" then  ###view項目の時はテーブル項目まで
            orgname = ""
            tcode.split('_').each_with_index do |value,index|
		    fstrsqly =  basesql +  "   POBJECT_TCODE = '#{if index == 0 then value + "s" else value end}'  and POBJECT_OBJECTTYPE = '#{if index == 0 then  'tbl' else 'tbl_field' end}' "
                 ##p fstrsqly 
		 if plsql.select(:first,fstrsqly) then   ## tbl name get
			orgname <<  plsql.select(:first,fstrsqly)[:pobjgrp_name] 
		    else
                        orgname << value
               end   
            end   ## do code. 
         end ## if orgname
            orgname = tcode if orgname == "" or orgname.nil?
      end  ## if ocde
      return orgname 
  end  ## def getpobj

  def fprnt str
    foo = File.open("blk#{Process::UID.eid.to_s}.log", "a") # 書き込みモード
    foo.puts "#{Time.now.to_s}  #{str}"
    foo.close
  end   ##fprnt str
  def get_show_data screen_tcode ,jqgrid_id = ""
     show_cache_key =  "show " + screen_tcode +  sub_blkget_grpcode
     ##debugger
     if Rails.cache.exist?(show_cache_key) then
	 ## create_def(screen_tcode)  unless respond_to?("process_scrs_#{screen_tcode}")
         show_data = Rails.cache.read(show_cache_key)
     else 
	 ### create_def screen_tcode
	 show_data = set_detail  screen_tcode,jqgrid_id  ## set gridcolumns
     end
     ##debugger
     return show_data
 end  ## get_show_data
 def set_detail screen_tcode,jqgrid_id
      show_data = {}
      det_screen = plsql.r_screenfields.all(
                                "where screen_tcode = '#{screen_tcode}'
                                 and screenfield_selection = 1 order by screenfield_seqno ")  ###有効日の考慮
                                 
           ## when no_data 該当データ 「r_screenfields」が無かった時の処理
           if det_screen.empty?
              ###debugger ## textは表示できないのでメッセージの変更要
	      p  "Create screenfields #{screen_tcode} by crt_r_view_sql.rb"
	      ##render :text =>"Create screenfields #{screen_tcode} by crt_r_view_sql.rb" 
	      show_data = nil
              return show_data 
           end   
           ###
           ### pare_screen = det_screen[0][:screenfield_screens_id]
           pare_screen = det_screen[0][:screenfield_screen_id]
           screen_tcode_view = det_screen[0][:screen_tcode_view]
           ###debugger ## 詳細項目セット
	    3.times {p "error screen_id is null "} if pare_screen.nil?
	   set_addbutton(pare_screen)  ### add  button セット script,gear,....
	   gridcolumns = []
           ###  chkの時のみ
           #gridcolumns   << {:field => "msg_ok_ng",
            #                            :label => "msg",
            #                            :width => 37,
            #                            :editable =>  false  } 
           allfields = []
           #allfields << "msg_ok_ng".to_sym
           alltypes = {} 
	   icnt = 0
	   evalstr = ""
	   det_screen.each do |i|  
                ## lable名称はユーザgroup固有よりセット    editable はtblから持ってくるように将来はする。
                ##fprnt " i #{i}"
                   tmp_editrules = {}
                   tmp_columns = {}
                   tmp_editrules[:required] = true  if i[:screenfield_indisp] == 1
                   tmp_editrules[:number] = true if i[:screenfield_type] == "number"
                   tmp_editrules[:date] = true  if i[:screenfield_type] == "date" or i[:screenfield_type]  =~ /^timestamp/
		   tmp_editrules[:required] = false  if tmp_editrules == {} 
                   tmp_columns[:field] = i[:screenfield_tcode]
                   tmp_columns[:label] = sub_blkgetpobj(i[:screenfield_tcode],"view_field")  ##:viewの項目
                   ### tmp_columns[:label] ||=  i[:screenfield_tcode]
                   tmp_columns[:hidden] = if i[:screenfield_hideflg] == 1 then true else false end 
                   tmp_columns[:editrules] = tmp_editrules 
                   tmp_columns[:width] = i[:screenfield_width]
                   tmp_columns[:search] = if i[:screenfield_paragraph]  == 0 and  screen_tcode =~ /^H\d_/   then false else true end 
		   if i[:screenfield_editable] == 1 then
		      tmp_columns[:editable] = true
		      tmp_columns[:editoptions] = {:size => i[:screenfield_edoptsize],:maxlength => i[:screenfield_maxlength] ||= i[:screenfield_edoptsize] }  if i[:screenfield_type] == "text"
		     else
		      tmp_columns[:editable] = false
		   end
		   tmp_columns[:edittype]  =  i[:screenfield_type]  if  ["textarea","select","checkbox","text"].index(i[:screenfield_type]) 
		   if i[:screenfield_type] == "select" or  i[:screenfield_type] == "checkbox" then
		      strselect = sub_get_select_list_value(i[:screenfield_edoptvalue])
		      tmp_columns[:editoptions] = {:value => eval(strselect) } 
		      tmp_columns[:formatter] = "select"
		      tmp_columns[:searchoptions] = {:value => eval(strselect) } 
		   end
		   if i[:screenfield_type] == "textarea" then
		      tmp_columns[:editoptions] =  {:rows =>"#{i[:screenfield_edoptrow]}",:cols =>"#{i[:screenfield_edoptcols]}"}
		   end
                   if  tmp_columns[:editoptions].nil? then  tmp_columns.delete(:editoptions)  end 
                   ## tmp_columns[:edittype]  =  i[:screenfield_type]  if  ["textarea","select","checkbox"].index(i[:screenfield_type]) 
		   ##debugger
                   if  i[:screenfield_rowpos]     then
			if  i[:screenfield_rowpos]  < 999
                            tmp_columns[:formoptions] =  {:rowpos=>i[:screenfield_rowpos] ,:colpos=>i[:screenfield_colpos] }
			    icnt = i[:screenfield_rowpos] if icnt <  i[:screenfield_rowpos] 
		          else
			    tmp_columns[:formoptions] =  {:rowpos=> icnt += 1,:colpos=>1 }
			end
		       else
                           tmp_columns[:formoptions] =  {:rowpos=> icnt += 1,:colpos=>1 }
		   end 	      
		   gridcolumns << tmp_columns 
                   allfields << i[:screenfield_tcode].to_sym  
                   alltypes [i[:screenfield_tcode].to_sym] =  i[:screenfield_type].downcase
		   evalstr << i[:screenfield_rubycode] if i[:screenfield_rubycode] 
           end   ## screenfields.each
	   show_data[:allfields] =  allfields  
           show_data[:alltypes]  =  alltypes  
           show_data[:screen_tcode_view] = screen_tcode_view
           show_data[:gridcolumns] = gridcolumns
           show_data[:evalstr] = evalstr
	   show_data.merge!(set_aftershowform screen_tcode_view,show_data)
           show_data = set_extbutton(pare_screen,show_data,screen_tcode)   ### 子画面用のラジオボ タンセット
        show_data[:pdf]  = set_pdf_item(screen_tcode)
        show_cache_key =  "show " + screen_tcode +  sub_blkget_grpcode
        Rails.cache.write(show_cache_key,show_data) 
	return show_data
  end    ##set_detai
 def sub_get_select_list_value edoptvalue 
     edoptvalue.scan(/'\w*'/).each do |i|
	 j = i.gsub("'","")
	 edoptvalue =  edoptvalue.sub(j,sub_blkgetpobj(j,"fix_char"))
     end
     return edoptvalue
 end 
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
  def set_extbutton pare_screen,show_data,screen_tcode     ### 子画面用のラジオボ タンセット
      ##debugger
      ### 同じボタンで有効日が>sysdateのデータが複数あると複数ボタンがでる
      rad_screen = plsql.r_chilscreens.select(:all,"where chilscreen_Expiredate > sysdate 
                                            and chilscreen_screen_id = :1",pare_screen)
           t_extbutton = ""
           t_extdiv_id = ""
	   grp_code = sub_blkget_grpcode
           rad_screen.each_with_index do |i,k|     ###child tbl name sym
               ### view name set
               hash_key = "#{i[:screen_tcode]}".to_sym 
                  t_extbutton << %Q|<input type="radio" id="radio#{k.to_s}"  name="nst_radio#{screen_tcode}"|
                  t_extbutton << %Q| value="#{i[:screen_tcode]}_div_#{i[:screen_tcode_chil]}_div_| ### 親のview
                  t_extbutton << %Q|#{i[:screen_tcode_chil]}_div_1"/>|  
                  t_extbutton << %Q| <label for="radio#{k.to_s}">  #{sub_blkgetpobj(i[:screen_tcode_chil],"screen")} </label> |   ##"screen"画面
                  t_extdiv_id << %Q|<div id="div_#{i[:screen_tcode]}_div_#{i[:screen_tcode_chil]}"> </div>|
      
        end   ### rad_screen.each
	show_data[:extbutton] =  t_extbutton
	show_data[:extdiv_id] =  t_extdiv_id
	return show_data
  end    ## set_extbutton pare_screen  
  def set_pdf_item screen_tcode
      pdflist = plsql.r_reports.all("where screen_tcode = '#{screen_tcode}' and REPORT_EXPIREDATE >sysdate")
      pdfvalue = ""
      pdflist.each do |i|
	      pdfvalue = i[:report_tcode] + ":" + sub_blkgetpobj(i[:report_tcode],"report") + ";"
      end
      pdfvalue.chop if pdfvalue.size > 0
      return pdfvalue
  end
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
##definde_method process_scrs_code do  |tsio_r|
##  record_auto tsio_r,to_screenl,field
###end
#:to_table=>"aaa"
#:field=>{:aaaa=> fa + fb,:bbbb=>xxxx(zzzz)}	
# fa,zzzzはtsio_rのレコード名
### 必須　文法チェックは画面でする。
def create_def_screen screen_tcode
    cmdstr = ""
    rs = plsql.screens.select(:first,"where EXPIREDATE> sysdate and tcode = '#{screen_tcode}' order by tcode,EXPIREDATE")     
    cmdstr = "def process_scrs_#{screen_tcode} tsio_r \n"
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
		     to_viewname =  plsql.screens.select(:first,"where EXPIREDATE> sysdate and tcode = '#{to_screen}' order by tcode,EXPIREDATE")
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
    ##fprnt "  LINE #{__LINE__} cmdstr = '#{cmdstr}'"
    ###debugger   ### cmdstr << "\n end"   ## endは画面でセット　チェックもすること  画面を作成したほうがよいかも
    eval(cmdstr)
	###fprnt "create def eval cmdstr = '#{cmdstr}'"
 end
def record_auto tsio_r,jqgrid_id,to_tblname,fields
    ##debugger
    fields ||= {}
    orgtbl = tsio_r[:sio_viewname].split(/_/,2)[1]
    to_command_r = {} 
    screen_tcode = to_screen 
    show_data = get_show_data(screen_tcode,jqgrid_id)
    ##fprnt " LINE #{__LINE__} show_data[:allfields] = '#{show_data[:allfields]}' "
    tsio_r.each do |k,val| 
	key = k.to_s.sub(orgtbl.chop,to_tblname.chop)
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
    to_command_r[:sio_code]   = screen_tcode
    to_command_r[:sio_viewname] =  show_data[:screen_tcode_view] 
    to_command_r[:sio_classname] = "plsql_blk_copy_insert"  if to_command_r[:sio_classname] =~ /insert/ 
    to_command_r[:id] =  sub_set_chil_tbl_info(to_command_r)  if to_command_r[:sio_classname] =~ /update/ 
    to_command_r[:id] =  sub_set_chil_tbl_info(to_command_r)  if to_command_r[:sio_classname] =~ /delete/ 
    to_command_r[:sio_id] =  plsql.__send__("SIO_#{to_command_r[:sio_viewname]}_SEQ").nextval
    to_command_r[:sio_session_counter] = plsql.sessioncounters_seq.nextval  ### user_id に変更
    to_command_r[:sio_add_time] = Time.now
    #to_command_r.delete(:msg_ok_ng)  ## sioに照会・更新依頼時は更新結果は不要
    ##fprnt " class #{self} : LINE #{__LINE__} sio_\#{ to_command_r[:sio_viewname] } :sio_#{to_command_r[:sio_viewname]}"
    ##fprnt " class #{self} : LINE #{__LINE__} to_command_r #{to_command_r}"
    ##debugger
    plsql.__send__("SIO_#{to_command_r[:sio_viewname]}").insert to_command_r
    ##debugger
     ##plsql.commit 
     dbcud = DbCud.new
     dbcud.perform(to_command_r[:sio_session_counter],"SIO_#{to_command_r[:sio_viewname]}")
  ### エラーが発生した時　6重に登録された。
 end   ## subcopyinsertsio
 def add_tbl_ctlxxxxxx org_tblname,org_tblid,tblname,tblid
      sort_sql = (org_tblname) unless plsql.user_tables.first(:table_name=>"CTL#{org_tblname}")
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
	 ##fprnt " LINE #{__LINE__}  ptblname CTL#{to_command_r[:sio_org_tblname]} ; strwhere = #{strwhere} "
	 raise "error"
     end
 end
 def reset_show_data screenfield_tcode,tblname
      ##debugger
      case tblname 
	   when "screenfield" then
		screen_tcode = plsql.R_screenfields.first("where screenfield_tcode = '#{screenfield_tcode}' ")[:screen_tcode]
                cache_key =  "show+" + screen_tcode 
		Rails.cache.delete_matched(cache_key) ###delay_jobからcallされるので、grp_codeはbatch
	   when "pobjgrps" then
		cache_key = "listindex" 
		Rails.cache.delete_matched(cache_key) ###delay_jobからcallされるので、grp_codeはbat
		chcache_key =  "show+"
		Rails.cache.delete_matched(cache_key) ###delay_jobからcallされるので、grp_codeはbatch
           else
	        return
      end		
  end
  def sub_get_ship_locas_frm_itm_id itms_id
       ##debugger
      rs = plsql.OpeItms.first("where itms_id = #{itms_id} and ProcessSeq = (select max(ProcessSeq) from OpeItms where  itms_id = #{itms_id} and Expiredate > sysdate ) and Priority = (select max(Priority) from OpeItms where  itms_id = #{itms_id} and Expiredate > sysdate ) ")
       if rs then
	  return rs[:locas_id]
         else
          3.times{ fprnt " ERROR Line #{__LINE__} not found locas_id from  OpeItms   where itms_id = #{itms_id}"}
	  3.times{ p " ERROR Line #{__LINE__} not found locas_id from  OpeItms   where itms_id = #{itms_id}"}
          exit ###画面にメッセージをだす方法 バッチ処理だよ
       end
  end
  def sub_get_ship_locas_frm_itm_code itms_code
      rs = plsql.itms.first("where code = '#{itms_code}'  and Expiredate > sysdate ")
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
	sub_command_r[:stkhist_person_id_upd] =  0  ###########  batch   
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
      prd = plsql.prcsecs.first("where locas_id_prcsecs = #{prm[:loca_id]} and expiredate > sysdate ")
      if prd 
	 tblname =  "prc"
	 else 
	       pur = plsql.dealers.first("where locas_id_dealers = #{prm[:loca_id]} and expiredate > sysdate ")
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
      char_to_number_data command_r
      ##debugger
      command_r[:sio_code]  = screen_tcode
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
      ##char_to_number_data
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
	## is not nul と is null 対応
	  #日付　/ - 固定にしないようにできないか?
       if command_r[:sio_strsql] then
          strwhere = unless command_r[:sio_strsql].downcase.split(")")[-1] =~ /where/ then  " where "  else " and " end
          else
           strwhere = " WHERE "
       end
       fprnt "class #{self} : LINE #{__LINE__} : command_r= '#{command_r}"
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
	  tmpwhere << "  #{viewname.split('_')[1].chop}_person_id_upd =  #{plsql.persons.first(:email =>current_user[:email])[:id] } "
       end
       ##if params[:
       return tmpwhere
  end
  def subpaging  command_r
      ###debugger
      tbldata = []
      command_r[:sio_viewname]  = show_data[:screen_tcode_view] 
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
end   ##module Ror_blk

