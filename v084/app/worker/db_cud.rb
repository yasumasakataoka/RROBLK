class DbCud  < ActionController::Base
 ## @queue = :default
 ## def self.perform(sio_id,sio_view_name)
   def command_r
      @command_r
  end
###  一セッション　一コミットにしたい
  def perform(sio_session_counter,sio_view_name)
      begin
     @command_r = {}
     command_r
       @pare_class = "batch"
      strsql = "where sio_session_counter = #{sio_session_counter} and sio_command_response = 'C'"
      ## fprnt"class #{self} : LINE #{__LINE__} sio_view_name: #{sio_view_name} strsql: #{strsql}"
      chk_cmn =  plsql.__send__(sio_view_name).all(strsql)
      tblname = sio_view_name.split(/_/,3)[2]
      xtblname = tblname.chop
      chk_cmn.each do |i|
	   tmp_key = {}
	   r_cnt = 0
	   to_cr = {}   ###テーブル更新用
           i.each do |j,k|
                j_to_s = j.to_s
	        ## fprnt"class #{self} : LINE #{__LINE__} j_to_s: #{j_to_s} xtblname: #{xtblname}"
	        ###debugger
                if j_to_s.split("_",2)[0] == xtblname then  ##本体の更新
	           ###2013/3/25 追加覚書　 xxxx_id_yyyy   yyyy:自身のテーブルの追加  プラス _idをs_idに
	              to_cr[j_to_s.split(/_/,2)[1].sub("_id","s_id").to_sym] = k  if k  ###org tbl field name
                      to_cr[j_to_s.split(/_/,2)[1].sub("_id","s_id").to_sym] = nil  if k  == '#{nil}'  ##画面項目クリアー
                   else  ### link先のidを求める 自分のテーブル以外の項目は該当テーブルのidを求めるための項目
                         ### 画面では必要項目のみ変更可能にする。
	            unless   j_to_s =~ /(_upd|sio_)/ or k.nil? or j_to_s == "id"   then
                         tkey = xtblname + j_to_s.split("_")[1] + "_id" + if j_to_s.split("_",3)[2] then "_" + j_to_s.split("_",3)[2] else "" end
			 itmp_key[j] = k  if i.key?(tkey.to_sym)  ###mandatory field  
                   end  ## unless j_to_s
                end   ## if j_to_s.
          end ## j,
	  tmp_key.each do |key,value|
	      #if key !~/_code/  then ###chil_screenで必要
	         rvalue = []
                 rvalue=  sub_mandatory_field_to_id(tmp_key,key)  #mandatory fieldからもとめたid優先
                 to_cr.merge! rvalue[0]
	         rvalue.each do |key|
		     tmp_key.delete(key)
		 end
	     #end
	   end
	   ##CODEでユニークにならないテーブルの考慮が漏れている。
	   ##  fprnt"class #{self} : LINE #{__LINE__} sio_view_name: #{sio_view_name} strsql: #{strsql} ****person_id #{i[:person_id_upd]}"
	   to_cr[:persons_id_upd] = i[:sio_user_code]
	   if to_cr[:sio_message_contents].nil?
              to_cr[:ymlcode] = ymlcode(i[:sio_code],to_cr[:ymlcode]) if to_cr[:ymlcode] 
	      case i[:sio_classname]
                when "plsql_blk_insert" then
                    to_cr[:id] = plsql.__send__(tblname + "_seq").nextval
		    to_cr[:created_at] = Time.now
		    to_cr[:updated_at] = Time.now
		    ##fprnt "class #{self} : LINE #{__LINE__} INSERT : to_cr = #{to_cr}"
		    plsql.__send__(tblname).insert to_cr
		    chlctltbl(to_cr) if tblname == "chilscreen"
		when "plsql_blk_update" then
                    to_cr[:where] = {:id => i[:id]}             ##変更分のみ更新
                    ##fprnt "class #{self} : LINE #{__LINE__} update : to_cr = #{to_cr}"
		    ##debugger
                    to_cr[:updated_at] = Time.now
                    plsql.__send__(tblname).update  to_cr
                when "plsql_blk_delete" then 
                    plsql.__send__(tblname).delete(:id => i[:id])
		when "plsql_blk_copy_insert" then   ###画面から新しい画面に
                    to_cr[:id] = plsql.__send__(tblname + "_seq").nextval
		    ##fprnt "class #{self} : LINE #{__LINE__} COPY INSERT : to_cr = #{to_cr}"
		    to_cr[:created_at] = Time.now
		    to_cr[:updated_at] = Time.now
		    plsql.__send__(tblname).insert to_cr
		    add_tbl_ctlxxxxxx i[:sio_org_tblname],i[:sio_org_tblid],tblname,to_cr[:id] 
		when "plsql_blk_chk_insert" then   ##バランスチェック
                    to_cr[:id] = plsql.__send__(tblname + "_seq").nextval
		    to_cr[:created_at] = Time.now
		    to_cr[:updated_at] = Time.now
		    ##fprnt "class #{self} : LINE #{__LINE__} chk INSERT : to_cr = #{to_cr}"
		    plsql.__send__(tblname).insert to_cr
	      end   ## case iud 
	   end
	   r_cnt += 1
	   ##debugger
               command_r = i
	       command_r[:id] = command_r[(xtblname + "_id").to_sym] =  to_cr[:id]   if i[:sio_classname] =~/_insert/
	       command_r[:sio_recordcount] = r_cnt
               command_r[:sio_result_f] = "0"
               command_r[:sio_message_contents] = nil
	       to_cr.each do |i,j| 
	          if i.to_s =~ /s_id/  and i.to_s != "persons_id_upd" then   ###変更は　sio_user_codeを使用
		     newi = (xtblname + "_" + i.to_s.sub("s_id","_id")).to_sym
		     command_r[newi] = j if j
	          end
	        end
	   sub_insert_sio_r   command_r    ## 結果のsio書き込み
	   cmnd_code = "process_scrs_" + i[:sio_code]   ##画面ごとの処理
	   #fprnt " LINE #{__LINE__}  i[:sio_code] = #{i[:sio_code]}  "
	   ##debugger
           create_def_screen  i[:sio_code]   unless respond_to?(cmnd_code)
	    ##fprnt " LINE #{__LINE__}  command_r : #{cmnd_code}   "
	    ##debugger
           __send__(cmnd_code, i[:sio_code],command_r)  #### if respond_to?(cmnd_code)
           ##fprnt " LINE #{__LINE__} i #{i} } "
	   reset_show_data_screen if sio_view_name =~ /screenfields/   ###キャッシュを削除
           reset_show_data_screenlist if tblname = "pobjgrps"   ###キャッシュを削除

      end   ##chk_cmn.each
      rescue
	      plsql.rollback
	      p  $!
	      p  $@
	      p " rescue line #{__LINE__}  sio_view_name = #{sio_view_name} "
	      fprnt  " err object    #{$!}"
	      fprnt  "err line  #{$@}"
	      fprnt " resure line #{__LINE__}  sio_view_name = #{sio_view_name} "

	      ##debugger
            else
	      p "ok  line #{__LINE__}  sio_view_name = #{sio_view_name} "
	      plsql.commit   ### エラーが発生した時　6重に登録された。
     end   ## begin
  end   ##perform
  handle_asynchronously :perform
  def  chlctltbl to_cr    ###自動的に親子テーブルの関係テーブル ctlxxxxを作成
       ###debugger
       pare_code =  plsql.r_screens.first("where id = #{to_cr[:screens_id]}")[:pobject_code_scr]
       chil_code =  plsql.r_screens.first("where id = #{to_cr[:screens_id_chil]}")[:pobject_code_scr]
       allfields = get_show_data(chil_code)[:allfields]
       unless allfields.index((pare_code.split("_")[1] + "_id").to_sym) then
	       crttblxxxx(pare_code.split("_")[1])  if PLSQL::Table.find(plsql, ("ctl" + pare_code.split("_")[1]).to_sym).nil?
       end
  end
  ##definde_method process_scrs_code do  |tsio_r|
##  record_auto tsio_r,to_screenl,field
###end
#:to_table=>"aaa"
#:field=>{:aaaa=> fa + fb,:bbbb=>xxxx(zzzz)}	
# fa,zzzzはtsio_rのレコード名
### 必須　文法チェックは画面でする。
def create_def_screen from_screen_code
    cmdstr = ""
    rs = plsql.r_screens.first("where screen_expiredate > sysdate and pobject_code_scr= '#{from_screen_code}' order by screen_expiredate") ##***  
    cmdstr = "def process_scrs_#{from_screen_code} from_screen_code,from_screen_data \n"
    cmdstr <<   rs[:ymlcode] if rs[:ymlcode]
    cmdstr << "\n end"   ##def end
    ##fprnt "  LINE #{__LINE__} cmdstr = '#{cmdstr}'"
    ###debugger   ### cmdstr << "\n end"   ## endは画面でセット　チェックもすること  画面を作成したほうがよいかも
    eval(cmdstr)
	###fprnt "create def eval cmdstr = '#{cmdstr}'"
end
def record_auto from_screen_code,from_screen_data,next_screen_code,frmf,nxtf
    ##debugger
    next_screen_data = {}  
    ##fprnt " LINE #{__LINE__} show_data[:allfields] = '#{show_data[:allfields]}' "
    from_screen_data.each do |k,val| 
	key = k.to_s.sub(frmf,nxtf)
	j = key.to_sym
	next_screen_data[j] = val if key =~ /^sio_/  
	##fprnt " LINE #{__LINE__} j = '#{j}'" 
	next_screen_data[j] = val  if  show_data[:allfields].index(j) 
	next_screen_data[j] = val  if  key.split("_")[1] = "code"
	###next_screen_data[:sio_org_tblid] = va if key == "id_tbl"
    end
    ##debugger
    yield
    next_screen_data[:sio_command_response] = "C"
    next_screen_data[:sio_org_tblname]  =  orgtbl
    next_screen_data[:sio_org_tblid]  = tsio_r[:id] 
    next_screen_data[:sio_code]   = screen_code
    next_screen_data[:sio_viewname] =  show_data[:screen_code_view] 
    next_screen_data[:sio_classname] = "plsql_blk_copy_insert"  if next_screen_data[:sio_classname] =~ /insert/ 
    next_screen_data[:id] =  sub_set_chil_tbl_info(next_screen_data)  if next_screen_data[:sio_classname] =~ /update/ 
    next_screen_data[:id] =  sub_set_chil_tbl_info(next_screen_data)  if next_screen_data[:sio_classname] =~ /delete/ 
    next_screen_data[:sio_id] =  plsql.__send__("SIO_#{next_screen_data[:sio_viewname]}_SEQ").nextval
    next_screen_data[:sio_session_counter] = plsql.sessioncounters_seq.nextval  ### user_id に変更
    next_screen_data[:sio_add_time] = Time.now
    #next_screen_data.delete(:msg_ok_ng)  ## sioに照会・更新依頼時は更新結果は不要
    ##fprnt " class #{self} : LINE #{__LINE__} sio_\#{ next_screen_data[:sio_viewname] } :sio_#{next_screen_data[:sio_viewname]}"
    ##fprnt " class #{self} : LINE #{__LINE__} next_screen_data #{next_screen_data}"
    ##debugger
    plsql.__send__("SIO_#{next_screen_data[:sio_viewname]}").insert next_screen_data
    ##debugger
     ##plsql.commit 
     dbcud = DbCud.new
     dbcud.perform(next_screen_data[:sio_session_counter],"SIO_#{next_screen_data[:sio_viewname]}")
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
 def ymlcode from_screen_code,strymlcode
     cmdstr = ""
     cmdstr = "data = {}  #auto create\n"  + cmdstr if cmdstr !~ /data = {} /
     cmdstr =  "next_screen_data = {} #auto create\n" + cmdstr if cmdstr !~ /next_screen_data = {} /
     strymlcode.split(/\n/).each do |yml|
          if   yml =~ /call_next_screen .* do/ then
               next_screen_code = yml.split("call_next_screen")[1].split(" do ")[0] 
               next_allfields = get_show_data(next_screen_code)[:allfields]
          end
      end
      from_allfields = get_show_data(from_screen_code)[:allfields]
      strymlcode.split(/\n/).each do |yml|
          if   yml =~ /call_next_screen .* do/ then
               cmdstr << "record_auto #{from_screen_code},from_screen_data,"
               cmdstr << next_screen_code +  " #change call_next_screen_...._do \n"
	     else
               nyml = yml
               yml.split(/\s|=|>|</).each do |field|
                   if field then
                      nyml = yml.sub(field," next_screen_datai[:#{field}] ") if next_allfields.index(field.to_sym)
                      nyml = yml.sub(field," from_screen_datai[:#{field}] ") if from_allfields.index(field.to_sym)
                   end
               end #do 
               cmdstr << nyml + if nyml.size > yml.size then " #change_to screen_data \n"  else " \n" end
	     end	## end if yml =~ /call_  
      end ##end do to_cr
  end  ## 
  def reset_show_data_screen
      cache_key =  "show" 
      Rails.cache.delete_matched(cache_key) ###delay_jobからcallされるので、grp_codeはbatch
  end
  def reset_show_data_screenlist   ###casheは消えるけどうまくいかない　2013/11/2
      ##debugger
      cache_key = "listindex" 
      Rails.cache.delete_matched(cache_key) ###delay_jobからcallされるので、grp_codeはbat
      chcache_key =  "show+"
      Rails.cache.delete_matched(cache_key) ###delay_jobからcallされるので、grp_codeはbatch
  end
end ## class
