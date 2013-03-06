class DbCud  < ActionController::Base
 ## @queue = :default
 ## def self.perform(sio_id,sio_view_name)
  def perform(sio_id,sio_view_name)
      begin
      strsql = "where sio_session_counter = #{sio_id} and sio_command_response = 'C'"
      ## fprnt"class #{self} : LINE #{__LINE__} sio_view_name: #{sio_view_name} strsql: #{strsql}"
      @chk_cmn =  plsql.__send__(sio_view_name).all(strsql)
      tblname = sio_view_name.split(/_/,3)[2]
      xtblname = tblname.downcase.chop
      @chk_cmn.each do |i|
	   tmp_key = {}
	   r_cnt = 0
	   to_command_r = {}
           i.each do |j,k|
                j_to_s = j.to_s
		 ## fprnt"class #{self} : LINE #{__LINE__} j_to_s: #{j_to_s} xtblname: #{xtblname}"
	        ###debugger
                if j_to_s.split(/_/,2)[0] == xtblname then  ##本体の更新
                   to_command_r[j_to_s.split(/_/,2)[1].to_sym] = k  unless k.nil?  ###org tbl field name
                   else  ### link先のidを求める
	           if   j_to_s =~ /(_upd|sio_|id_tbl)/ or k.nil? or j_to_s == "id"  or j_to_s =~ /^sio_/ then
                        else
                        tmp_key[j] = k  if j_to_s =~ /(_code)/  ##tmp_key[j] = other tablename+_+fielfname+_+shikibetushi  <-- value
                   end  ## unless j_to_s
                end   ## if j_to_s.
           end ## i
           to_command_r.merge! sub_code_to_id(tmp_key)
	   ##  fprnt"class #{self} : LINE #{__LINE__} sio_view_name: #{sio_view_name} strsql: #{strsql} ****person_id #{i[:person_id_upd]}"
	   to_command_r[:persons_id_upd] = i[:person_id_upd]
           to_command_r[:created_at] = Time.now
	   case i[:sio_classname]
                when "plsql_blk_insert" then
                    to_command_r[:id] = plsql.__send__(tblname + "_seq").nextval
		    fprnt "class #{self} : LINE #{__LINE__} INSERT : to_command_r = #{to_command_r}"
		    plsql.__send__(tblname).insert to_command_r
                when "plsql_blk_update" then
                    to_command_r[:where] = {:id => i[:id_tbl]}
                    fprnt "class #{self} : LINE #{__LINE__} update : to_command_r = #{to_command_r}"
                    plsql.__send__(tblname).update  to_command_r
                when "plsql_blk_delete" then 
                    plsql.__send__(tblname).delete(:id => i[:id_tbl])
		when "plsql_blk_copy_insert" then
                    to_command_r[:id] = plsql.__send__(tblname + "_seq").nextval
		    plsql.__send__(tblname).insert to_command_r
		    add_tbl_ctlxxxxxx i[:sio_org_tblname],i[:sio_org_tblid],tblname,to_command_r[:id] 
           end   ## case iud 
	   r_cnt += 1
	   tmp_sio_record_r = {}
	   tmp_sio_record_r = i
	   tmp_sio_record_r[:id_tbl] =  to_command_r[:id] 
	   tmp_sio_record_r[:sio_recordcount] = r_cnt
           tmp_sio_record_r[:sio_result_f] = "0"
           tmp_sio_record_r[:sio_message_contents] = nil
	   insert_sio_r  tmp_sio_record_r   ## 結果のsio書き込み
	   cmnd_code = "process_scrs_" + i[:sio_code]   ##画面ごとの処理
	   ## debugger
              create_def  i[:sio_code]   unless respond_to?(cmnd_code)
              __send__(cmnd_code, tmp_sio_record_r)   if respond_to?(cmnd_code)
           ###	   fprnt " LINE #{__LINE__} cmnd_code : #{cmnd_code} "
	   reset_show_data(i[:screen_code]) if tblname.upcase == "DETAILFIELDS"
      end   ##chk_cmn.each
      rescue
	      plsql.rollback
	      p " error line #{__LINE__} "
            else
	      plsql.commit   ### エラーが発生した時　6重に登録された。
      
     end   ## begin
  end   ##perform
  handle_asynchronously :perform
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
##definde_method process_scrs_code do  |tmp_sio_record_r|
##  record_auto tmp_sio_record_r,to_screenl,field
###end
#:to_table=>"aaa"
#:field=>{:aaaa=> fa + fb,:bbbb=>xxxx(zzzz)}	
# fa,zzzzはtmp_sio_record_rのレコード名
### 必須　文法チェックは画面でする。
def create_def screen_code
    cmdstr = ""
    rs = plsql.screens.select(:first,"where EXPIREDATE> sysdate and code = '#{screen_code}' order by code,EXPIREDATE")
    ##debugger
    if   rs[:ymlcode]  then
	    rs[:ymlcode].split(/:to_/).each do |yml|
	      case 
                when yml =~ /^screen/ then
		     ## debugger
		     cmdstr = "def process_scrs_#{rs[:code]} tmp_sio_record_r " +  "\n" + "record_auto tmp_sio_record_r,"
		     to_screen =  yml.split(/:fields/,2)[0].split(/=>/)[1].chomp  
		     to_viewname = plsql.screens.select(:first,"where EXPIREDATE> sysdate and code = '#{to_screen}' order by code,EXPIREDATE")[:viewname]
		     to_tblname = to_viewname.split(/_/,2)[1]
		     cmdstr << %Q|"#{to_screen}","#{to_tblname}",|
	             if  yml.split(/:fields/,2)[1]  then
			 yml_f = yml.split(/:fields/,2)[1] 
                          if  yml_f.split(/=>/,2)[1]  then
			      cmdstr << yml_f.split(/=>/,2)[1]
			  end
		     end
	        when yml  =~ /^subcmd/ then
		     cmdstr << "\n" + yml.split(/=>/,2)[1] 
	       end	## end case  
	    end ##end yml
	    unless  cmdstr == "" then 
		fprnt " cmdstr = '#{cmdstr}'"
		### debugger   ### cmdstr << "\n end"   ## endは画面でセット　チェックもすること  画面を作成したほうがよいかも
	        eval(cmdstr)
		fprnt "create def eval cmdstr = '#{cmdstr}'"
            end
    end  ## if
end
def record_auto tmp_sio_record_r,to_screen,to_tblname,fields = {}
    begin
    orgtbl = tmp_sio_record_r[:sio_viewname].split(/_/,2)[1]
    to_command_r = {} 
    screen_code = to_screen.upcase 
    show_data = get_show_data(screen_code)
    fprnt " LINE #{__LINE__} show_data[:allfields] = '#{show_data[:allfields]}' "
    tmp_sio_record_r.each do |k,val| 
	key = k.to_s.sub(orgtbl.downcase.chop,to_tblname.downcase.chop)
	j = key.to_sym
	to_command_r[j] = val if key =~ /^sio_/  
	fprnt " LINE #{__LINE__} j = '#{j}'" 
	to_command_r[j] = val  if  show_data[:allfields].index(j) 
    end
    fields.each do |m,n|
	to_command_r[m] = tmp_sio_record_r[n]
    end
    to_command_r[:sio_command_response] = "C"
    if to_command_r[:sio_classname] =~ /insert/ then
       to_command_r[:sio_org_tblname]  =  orgtbl
       to_command_r[:sio_classname] = "plsql_blk_copy_insert"
    end	
    to_command_r[:sio_org_tblid]  = tmp_sio_record_r[:id_tbl] 
    to_command_r[:sio_code]   = screen_code
    to_command_r[:sio_viewname] =  plsql.screens.select(:first,"where EXPIREDATE> sysdate and code = '#{screen_code}' order by EXPIREDATE")[:viewname]
    to_command_r[:id] =  plsql.__send__("SIO_#{to_command_r[:sio_viewname]}_SEQ").nextval
    to_command_r[:sio_session_counter] = plsql.sessioncounters_seq.nextval  ### user_id に変更
    to_command_r[:sio_add_time] = Time.now
    to_command_r.delete(:msg_ok_ng)  ## sioに照会・更新依頼時は更新結果は不要
    ## fprnt " class #{self} : LINE #{__LINE__} sio_\#{ to_command_r[:sio_viewname] } :sio_#{to_command_r[:sio_viewname]}"
    ## fprnt " class #{self} : LINE #{__LINE__} to_command_r #{to_command_r}"
      ## debugger
    plsql.__send__("SIO_#{to_command_r[:sio_viewname]}").insert to_command_r
      rescue
	      plsql.rollback
	      p " error line #{__LINE__} "
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
     ## debugger
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
 end ## class

