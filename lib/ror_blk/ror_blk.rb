# RorBlk
 module Ror_blk
   def getblkpobj code,ptype     ## fieldsの名前
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
         end ## iforgname
            orgname = code if orgname == "" or orgname.nil?
      end  ## if ocde
      return orgname 
  end  ## def getpobj
  def fprnt str
    foo = File.open("blk#{Process::UID.eid.to_s}.log", "a") # 書き込みモード
    foo.puts str
    foo.close
  end   ##fprnt str
  def  sub_getfield
       strfields = []
       command_r.each  do |i,j|
          tmp_field = i.to_s 
          unless  tmp_field =~ /^sio_/  then
             unless  tmp_field == "id_tbl" then
               strfields <<  tmp_field
             end 
          end  ## unless  unless i.to_s =~ /^sio_/ 
       end   ## command_r.each
       strfields =  strfields.join(",") 
       return strfields
  end   ##  sub_getfield

  def plsql_blk_paging  
    command_r[:id] = nil
    #####   strsqlにコーディングしてないときは、viewをしよう
####     strdql はupdate insertには使用できない。
    
	command_r[:sio_strsql] = sub_strsql

    tmp_sql = if command_r[:sio_strsql].nil? then command_r[:sio_viewname]  + " a " else command_r[:sio_strsql] end
          
    strsql = "SELECT * FROM " + tmp_sql
    fprnt "class #{self} : LINE #{__LINE__}  strsql = '#{strsql}"
    tmp_sql << sub_strwhere  if command_r[:sio_search]  == "true"
    tmp_sql << "  order by " +  command_r[:sio_sidx] + " " +  command_r[:sio_sord]  unless command_r[:sio_sidx].nil? or command_r[:sio_sidx] == ""
    cnt_strsql = "SELECT 1 FROM " + tmp_sql 
    fprnt "class #{self} : LINE #{__LINE__}   cnt_strsql = '#{cnt_strsql}'"
    ## debugger
    command_r[:sio_totalcount] =  plsql.select(:all,cnt_strsql).count  
    case  command_r[:sio_totalcount]
    when nil,0   ## 該当データなし
         ## insert_sio_r recodcount,result_f,contents
         contents = "not find record"    ### 将来usergroup毎のメッセージへ
	 command_r[:sio_recordcount] = 0
         command_r[:sio_result_f] = "1"
         command_r[:sio_message_contents] = contents
         insert_sio_r  command_r

    else      
         strsql = "select #{sub_getfield} from (SELECT rownum cnt,a.* FROM #{tmp_sql} ) "
         r_cnt = 0
         strsql  <<    " WHERE  cnt <= #{command_r[:sio_end_record]}  and  cnt >= #{command_r[:sio_start_record]} "
         fprnt " class #{self} : LINE #{__LINE__}   strsql = '#{ strsql}' "
         pagedata = plsql.select(:all, strsql)
         pagedata.each do |j|
           r_cnt += 1
           ##   command_r.merge j なぜかうまく動かない。
           j.each do |j_key,j_val|
             command_r[j_key]   = j_val unless j_key.to_s == "id" ## sioのidとｖｉｅｗのｉｄが同一になってしまう
             command_r[:id_tbl] = j_val if j_key.to_s == "id"
           end  
           ## debugger
             command_r[:sio_recordcount] = r_cnt
             command_r[:sio_result_f] = "0"
             command_r[:sio_message_contents] = nil
           insert_sio_r  command_r
	 end ##    plsql.select(:all, "#{strsql}").each do |j|
    end   ## case
  ### p  "e: " + Time.now.to_s 
  plsql.commit
  end   ###plsql_paging
  def  sub_strwhere
       command_r[:sio_strsql] = sub_strsql
       unless command_r[:sio_strsql].nil? then
          strwhere = unless command_r[:sio_strsql].upcase.split(")")[-1] =~ /WHERE/ then  " WHERE "  else " and " end
          else
           strwhere = " WHERE "
       end
       command_r.each  do |i,j|
          unless i.to_s =~ /^sio_/ then
             unless j.to_s.empty? then             
               tmpwhere = " #{i.to_s} = '#{j}'  AND " 
               tmpwhere = " #{i.to_s} like '#{j}'  AND " if j =~ /^%/ or j =~ /%$/ 
               if j =~ /^<=/  or j =~ /^>=/ then 
                  tmpwhere = " #{i.to_s} #{j}[0..1] '#{j}[2..-1]'  AND "
                else
                if j =~ /^</   or  j =~ /^>/ then 
                   tmpwhere = " #{i.to_s}  #{j}[0]  '#{j}[1..-1]'  AND "
                end  ## else
            end   ## if j
            strwhere << tmpwhere 
           end ## unless empty 
          end  ## unless  unless i.to_s =~ /^sio_/ 
       end   ## command_r.each
       return strwhere[0..-7]
  end   ## sub_strwhere

 def insert_sio_r tmp_sio_record_r
      tmp_sio_record_r[:sio_replay_time] = Time.now
      tmp_sio_record_r[:sio_command_response] = "R"
      tmp_seq = "SIO_#{tmp_sio_record_r[:sio_viewname]}_seq"
      tmp_sio_record_r.each_key do |j_key|  
             tmp_sio_record_r.delete(j_key) if tmp_sio_record_r[j_key].nil?
      end
      fprnt " LINE :#{__LINE__} tmp_sio_record_r[:sio_viewname] =  #{tmp_sio_record_r[:sio_viewname]}  command_r #tmp_{command_r}  "
      tmp_sio_record_r[:id] = plsql.__send__(tmp_seq).nextval
      plsql.__send__("SIO_#{tmp_sio_record_r[:sio_viewname]}").insert tmp_sio_record_r
 end   ##insert_sio_r t
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
	     fprnt "class #{self} : LINE #{__LINE__}   buttonopt :#{  buttonopt }"
             fprnt "class #{self} : LINE #{__LINE__}  add_button :#{ add_button }"
        end
      return  buttonopt 
  end   ### set_addbutton pare_screen 
  ################
  
  def set_detail screen_code
      show_data
      det_screen = plsql.r_detailfields.all(
                                "where screen_code = '#{screen_code}'
                                 and detailfield_selection = 1 order by detailfield_seqno ")  ###有効日の考慮
                                 
           ## when no_data 該当データ 「r_DetailFields」が無かった時の処理
           if det_screen.empty?
              ### debugger ## textは表示できないのでメッセージの変更要
              render :text => "Create DetailFields #{screen_code} by crt_r_view_sql.rb"  and return 
           end   
           ###
           ### pare_screen = det_screen[0][:detailfield_screens_id]
           pare_screen = det_screen[0][:screen_id]
           screen_viewname = det_screen[0][:screen_viewname].upcase
           ## debugger ## 詳細項目セット
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
	   det_screen.each do |i|  
                ## lable名称はユーザ固有よりセット    editable はtblから持ってくるように将来はする。
                   p" i #{i}"
                   tmp_editrules = {}
                   tmp_editrules[:required] = true  if i[:detailfield_indisp] == 1
                   tmp_editrules[:number] = true if i[:detailfield_type] == "NUMBER"
                   tmp_editrules[:date] = true  if i[:detailfield_type] == "DATE"
                   tmp_editrules[:required] = false  if tmp_editrules == {} 
                   tmp_columns[:field] = i[:detailfield_code].downcase
                   tmp_columns[:label] = getblkpobj(i[:detailfield_code],"1")
                   tmp_columns[:hidden] = if i[:detailfield_hideflg] == 1 then true else false end 
                   tmp_columns[:editrules] = tmp_editrules 
                   tmp_columns[:width] = i[:detailfield_width]
                   tmp_columns[:search] = if i[:detailfield_paragraph]  == 0 and  screen_code =~ /^H\d_/   then false else true end
                   tmp_columns[:editable] =  if i[:detailfield_editable] == 1 then true else false end
		   tmp_columns[:editoptions] = if datetextnum.index(i[:detailfield_type]) then {:size => i[:detailfield_edoptsize],:maxlength => i[:detailfield_maxlength],:value => i[:detailfield_value] }  end
		   tmp_columns[:editoptions] = if i[:detailfield_type] == "select" or  i[:detailfield_type] == "checkbox" then  {:value => i[:detailfield_value] } end
		   tmp_columns[:editoptions] = if i[:detailfield_type] == "textarea" then  {:rows => i[:detailfield_edoptrows],:colms => i[:detailfield_colms] } end
                   tmp_columns[:editoptions] = if  tmp_columns[:editoptions].nil? then  {} end 
                   tmp_columns[:formoptions] =  {:rowpos=>i[:detailfield_rowpos] ,:colpos=>i[:detailfield_colpos] } if i[:detailfield_rowpos] <= 99  
                   gridcolumns << tmp_columns 
                   allfields << i[:detailfield_code].downcase.to_sym  
                   alltypes [i[:detailfield_code].downcase.to_sym] =  i[:detailfield_type] 
           end   ## detailfields.each
	   show_data[:allfields] =  allfields  
           show_data[:alltypes]  =  alltypes  
           show_data[:screen_viewname] = screen_viewname.upcase
           show_data[:gridcolumns] = gridcolumns
	   show_data.merge!  set_radiobutton(pare_screen) 
        show_cache_key =  "show " + screen_code.upcase
        Rails.cache.write(show_cache_key,show_data) 
	return show_data
  end    ##set_detai
  def datetextnum
      ["DATE","NUMBER","CHAR","VARCHAR","VARCHAR2","TIMESTAMP(6)"]
  end
  def sub_add_upd_del_setsio tblfields
	   tblfields.each_key do |ii|     ### tblfields  paramsをsio用に変換したもの
           if !tblfields[ii].nil?   and ii.to_s != "id_tbl"   ###   sub_set_fields_from_allfields参照 
              tmp_type = plsql.DETAILFIELDS.first(" where code = '#{ii.to_s.upcase}' and Expiredate > sysdate order by expiredate ") 
          ##  debugger
              tmp_type = unless  tmp_type.nil? then  tmp_type[:type] else "" end
              case tmp_type
              when "DATE","TIMESTAMP(6)" then
                   command_r[ii] = Time.parse(tblfields[ii]) 
              when "NUMBER"
                   command_r[ii] = tblfields[ii].to_f
              else
                   command_r[ii] = tblfields[ii]
              end
           end  ## if    !params[ii].nil?  
           end   ## do |ii|
           render :nothing => true
      show_data =   get_show_data  screen_code
     tmp_isnr = {}
     show_data[:allfields].each do|j|
        tmp_isnr[j] = tmp_params[j]  unless j.to_s  == "id"  ## sioのidとｖｉｅｗのｉｄが同一になってしまう
        tmp_isnr[:id_tbl] = tmp_params[j] if j.to_s == "id"          
    end ##    
    return tmp_isnr
 end  
##definde_method process_scrs_code do  |tmp_sio_record_r|
##  record_auto tmp_sio_record_r,totbl,field
###end
#:to_table=>"aaa"
#:field=>{:aaaa=> fa + fb,:bbbb=>xxxx(zzzz)}	
# fa,zzzzはtmp_sio_record_rのレコード名
### 必須　文法チェックは画面でする。
def create_def
save_code = ""
rs = plsql.r_processscrs.select(:all,"where PROCESSSCR_EXPIREDATE> sysdate order by screen_code,PROCESSSCR_EXPIREDATE")
cmdstr = " def process_scrs_#{r[:screen_code]} tmp_sio_record_rn "
    rs .each do |r|
	 if save_code != r[:screen_code] then
		r[:ymlcode].gsub("\n","").split(/:to_/).each do |yml|
		case 
                when yml =~ /^table/
		     cmdstr << "\n" + "record_auto tmp_sio_record_r,"
	             yml_f = yml.split(/:field/,2)
		     cmdstr  << yml_f[0].split(/=>/) 
		     cmdstr << yml_f[1].split(/=>/)
		when yml  =~ /^subcmd/
		     cmdstr << "\n" + yml.split(/=>/,2)[1] 
		end	
	    end
	    cmdstr << "\n end"
	    eval(cmnstr)
	    save_code = r[:screen_code] 
         end  ## if
    end  ##rs
end
def record_auto tmp_sio_record_r,totbl,fields = {}
    orgtbl = tmp_sio_record_r[:sio_viewname].split(/_/,3)[2].chop
    totbl.chop!
    to_command_r = {} 
    show_data = get_show_data "R_#{totbl.upcase}" 
    tmp_sio_record_r.each do |k,val| 
	key = k.to_s
	j = key.sub(orgtbl,totbl).to_sym
	if key =~ /^sio_/  or show_data[:allfield].key?(j) 
		to_command_r[j] = val if fields[j].nil?
		to_command_r[j] = eval(fields[j]) unless fields[j].nil?
        end
    end
    if to_command_r[:sio_classname] =~ /insert/ then
	to_command_r[:sio_org_tblid]  = to_command_r[:id_tbl] 
        to_command_r[:sio_org_tblname]  =  orgtbl
        to_command_r[:sio_classname] = "plsql_blk_copy_insert"
    end	
    to_command_r[:sio_viewname] = "R_" +  totbl.upcase
    to_command_r[:id] =  plsql.__send__("SIO_#{command_r[:sio_viewname]}_SEQ").nextval
    to_command_r[:sio_session_counter] = plsql.sessioncounters_seq.nextval  ### user_id に変更
    to_command_r[:sio_add_time] = Time.now
    to_command_r.delete(:msg_ok_ng)  ## sioに照会・更新依頼時は更新結果は不要
    fprnt " class #{self} : LINE #{__LINE__} sio_\#{ command_r[:sio_viewname] } :sio_#{command_r[:sio_viewname]}"
    fprnt " class #{self} : LINE #{__LINE__} to_command_r #{to_command_r}"
      ## debugger
    plsql.__send__("SIO_#{command_r[:sio_viewname]}").insert to_command_r
    plsql.commit 
    dbcud = DbCud.new
    dbcud.perform(to_command_r[:sio_session_counter],"SIO_#{to_command_r[:sio_viewname]}")
  end   ## subcopyinsertsio 
 def get_show_data screen_code 
     show_cache_key =  "show " + screen_code
     debugger
     if  Rails.cache.exist?(show_cache_key) then 
         show_data = Rails.cache.read(show_cache_key)
     else 
         show_data = set_detail(screen_code)  ## set @gridcolumns 
     end
     return show_data
  end

end   ##module Ror_blk

 
