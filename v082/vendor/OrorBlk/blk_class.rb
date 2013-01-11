class Blkclass
###
### chil_itmを検索後opeitmを検索すると落ちた時がある。
###
  def initialize cmd_ts 
      ## p "a" + Time.now.to_s
      @chk_cmn = [] 
      @cmd_ts = Array.new 
      @cmd_ts = cmd_ts
      const = "C"
      ## 照会のときは　同一seesion_counterは一件のみ　isert,update,deleteは複数件を許す
      ## 一括処理　一括コミット　(一件でもエラーが有ると登録しない)  対応しない。
      ## 個別処理　一括コミット　ＯＫ分のみ登録　同一セッションカウンタ
      ## 個別処理　個別コミット　　個別のセッションカウンタ
      strsql = "where sio_term_id =  '#{@cmd_ts[1]}' and sio_session_id = '#{@cmd_ts[2]}' 
                and sio_session_counter = #{@cmd_ts[3]} and sio_command_response = '#{const}'"
      p "strsql #{strsql}"
      @chk_cmn =  plsql.__send__(@cmd_ts[4]).all(strsql)    
      @loop_itm_id = []
      @tmp_gantt = []
      @tmp_depends = [] 

  end
  def command_r
      command_r = @chk_cmn[0]  
  end  
  def fprnt str
    foo = File.open("blk#{Process::UID.eid.to_s}.log", "a") # 書き込みモード
    foo.puts str
    foo.close
  end 
  def plsql_blk_paging  
    command_r[:id] = nil
    command_r[:sio_command_response] = "R"
#####   strsqlにコーディングしてないときは、viewをしよう
####     strdql はupdate insertには使用できない。
    tmp_sql = if command_r[:sio_strsql].nil? then command_r[:sio_viewname]  + " a " else command_r[:sio_strsql] end
          
    strsql = "SELECT * FROM " + tmp_sql
    fprnt " #{__LINE__}  strsql = '#{strsql}"
    tmp_sql << sub_strwhere(command_r)  if command_r[:sio_search]  == "true"     
    tmp_sql << "  order by " +  command_r[:sio_sidx] + " " +  command_r[:sio_sord]  unless command_r[:sio_sidx].nil?   

    cnt_strsql = "SELECT 1 FROM " + tmp_sql 
    fprnt " #{__LINE__}  cnt_strsql = '#{cnt_strsql}'"
    command_r[:sio_totalcount] =  plsql.select(:all,cnt_strsql).count  
    case  command_r[:sio_totalcount]
    when nil,0   ## 該当データなし
         ## insert_command_r recodcount,result_f,contents
         contents = "not find record"    ### 将来usergroup毎のメッセージへ
         insert_command_r 0,"1",contents
    else      
         strsql = "select #{sub_getfield(command_r)} from (SELECT rownum cnt,a.* FROM #{tmp_sql} ) "
         r_cnt = 0
         strsql  <<    " WHERE  cnt <= #{command_r[:sio_end_record]}  and  cnt >= #{command_r[:sio_start_record]} "
         fprnt "  strsql = '#{ strsql}' "
         pagedata = plsql.select(:all, strsql)
         pagedata.each do |j|
           r_cnt += 1
           ##   command_r.merge j なぜかうまく動かない。
           j.each do |j_key,j_val|
             command_r[j_key]   = j_val unless j_key.to_s == "id" ## sioのidとｖｉｅｗのｉｄが同一になってしまう
             command_r[:id_tbl] = j_val if j_key.to_s == "id"
           end  
           insert_command_r r_cnt,"0",nil
         end ##    plsql.select(:all, "#{strsql}").each do |j|
    end   ## case
  p  "e: " + Time.now.to_s 
  end   ###plsql_paging
  def  sub_strwhere  command_r
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

  def  sub_getfield  command_r
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

  def plsql_blk_insert  
  ###  r_XXXX のviewのみに対応　実際には　XXXXのテーブルにINSERT    
    p "insert x-0 : " + Time.now.to_s  
    sub_chk_cmd "insert"
  end   ###plsql_blk_insrt
  
  def plsql_blk_update  
  ###  r_XXXX のviewのみに対応　実際には　XXXXのテーブルをupdate 
  ###  xxxの項目には　_idを除いて全てセットされていること。nilもそのままセットされる。
  ###  idも必ずセット。バッチの時はupadte用ファイルを渡すときに、idもセットする。
  ###  バッチupdateでは、ｉｄを変更せず内容を修正
  ### p "update y-0" + Time.now.to_s
  sub_chk_cmd "update"
 ###     p  "e" + Time.now.to_s 
  end   ###plsql_blk_update
  
  ## 削除
   def plsql_blk_delete 
  ###  r_XXXX のviewのみに対応
   p "delete y-0" + Time.now.to_s
   
   sub_chk_cmd "delete"
  end   ###plsql_blk_delete 

    ### update deleteでも共通で使用できるようにする。　@chk_cmn.each do |i|
  def sub_chk_cmd iud
    r_cnt = 0
    command_r[:id] = nil
    command_r[:sio_command_response] = "R"
    fprnt " #{__LINE__}  @chk_cmn = '#{@chk_cmn}' "
    tblname = @chk_cmn[0][:sio_viewname].split(/_/)[1].chop  ### sは取る。
    @chk_cmn.each do |i|
      r_cnt += 1
      tmp_isrt = {}
      tmp_key = {}
      i.each do |j,k|
        j_to_s = j.to_s
        if j_to_s.split(/_/,2)[0] == tblname then  ##本体の更新
           tmp_isrt[j_to_s.split(/_/,2)[1].to_sym] = k  unless k.nil?
          else  ### link先のidを求める
	  if   j_to_s =~ /(_upd|sio_)/ or k.nil?  then
             else
               tmp_key[j] = k  
          end  ## unless j_to_s
        end   ## if j_to_s.
      end ## i
      tmp_isrt = sub_code_to_id(tmp_key,tmp_isrt) unless  tmp_key == {}
      tblname = tblname + "s"
      fprnt "tblname  = '#{tblname}' ,tmp_key = #{tmp_key} ,tmp_isrt = #{tmp_isrt}  "
      case iud
         when "insert" then
            tmp_isrt[:id] = plsql.__send__(tblname + "_seq").nextval
            tmp_isrt[:persons_id_upd] = command_r[:sio_user_code]
            tmp_isrt[:created_at] = Time.now
            plsql.__send__(tblname).insert tmp_isrt
          when "update" then
            tmp_isrt[:updated_at] = Time.now
            tmp_isrt[:persons_id_upd] = command_r[:sio_user_code]
            tmp_isrt[:where] = {:id => i[:id_tbl]}
            fprnt  "update : tmp_isrt = #{tmp_isrt}"
            plsql.__send__(tblname).update  tmp_isrt
          when "delete" then 
            plsql.__send__(tblname).delete(:id => i[:id_tbl])
         end 
         insert_command_r 0,"0",nil
    end ##@chk    
 ###     p  "e" + Time.now.to_s 
  end   ### sub_chk_cmd
  def   sub_code_to_id  tmp_key,tmp_isrt
           ##save_key tblname + [_] +  item_name
           fprnt "tmp_key #{tmp_key}"
           strwhere = "where Expiredate >= SYSDATE  and "
           save_key = ""
           tmp_key.sort.each do|key, value|
                if  key.to_s.split(/_/)[0] != save_key.split(/_/)[0] and save_key != ""
                    tmp_isrt.merge! sub_get_main_data(strwhere,save_key)
                    strwhere = "where Expiredate >= SYSDATE  and "
                end
                save_key = key.to_s
                strwhere <<   key.to_s.split(/_/)[1] + " = '#{value}'  and "       
            end 
         tmp_isrt.merge! sub_get_main_data(strwhere,save_key)
         return   tmp_isrt
  end
  ### code + exipredateでユニークであること
  def   sub_get_main_data strwhere,save_key
             tmp_isrt = {}
             strwhere = strwhere[0..-5] + " order by  Expiredate"
             tblname = save_key.to_s.split(/_/,2)[0] + "s"    
             fprnt " tblname : #{tblname}   strwhere = '#{strwhere}'"
             aim_id = plsql.__send__(tblname).first(strwhere)
             fprnt "#{__LINE__}  aim_id =  '#{aim_id}',"
             tblsym = tblname + "_id" 
             tmp_sym = save_key.to_s.split(/_/,3)[2]    ###識別子にテーブルがセットされた時
             unless tmp_sym.nil?  ## 原則2つめの「_」の後はテーブル名
###              if  ["upd","chrg","from","to","time","pretime","lttime","pare","chil"].member?(tmp_sym) then
   ####                tblsym << "_" + tmp_sym 
   ####              else
                   wherekey = tblname +  "_id_"  + save_key.to_s.split(/_/,3)[2] 
                   strwhere = "where #{wherekey} = #{aim_id[:id]} "
                   fprnt "#{__LINE__}  aim_id =  '#{aim_id}' tmp_sym = '#{tmp_sym}' strwhere= '#{strwhere}'  "
                   aim_id = plsql.__send__(tmp_sym ).first(strwhere)
                   tblsym = tmp_sym + "_id" unless  aim_id.nil?
                   tblsym << "_" + tmp_sym  if  aim_id.nil?
  ####             end
             end
             tmp_isrt[tblsym.to_sym] = aim_id[:id] unless aim_id.nil?
             tmp_isrt[:sio_message_contents] = "logic err" if aim_id.nil?
        return tmp_isrt
  end   ### def sub_get...
##  def str_to_hash
##       tmp_array = command_r[:sio_strsql].split(",")
##       fprnt "command_r[:sio_strsql] #{command_r[:sio_strsql]}"
##       fprnt "tmp_array #{tmp_array}"
##       return Hash[*tmp_array]
##  end 
  def pre_grpv     ### group viewを作るための準備
       ## view_name =   str_to_hash["screen_viewname"] 
       view_name = command_r[:screen_viewname]
       ## puts "#{__LINE__}  command_r #{ command_r }" 
       if view_name =~ /^R_/ then
             for i in 1..9
                 grpview = "H" + i.to_s + "_" + view_name[2..-1]
                 view_chk = plsql.R_DETAILFIELDS.first("where screen_viewname = '#{grpview}'")
                 if view_chk.nil? then break end
             end
             if view_chk.nil? then
                crt_view = plsql.R_DETAILFIELDS.all("where screen_viewname = '#{view_name}'")
                screen_id = plsql.screens_seq.nextval 
                ###  Hx_
                proc_screendata  screen_id,grpview
                crt_view.each do |i|
                    proc_crtview i,screen_id,grpview  
                end
                ###  Dx_ 
                screen_id = plsql.screens_seq.nextval 
                grpview = "D" + grpview[1..-1]
                proc_screendata  screen_id,grpview
                crt_view.each do |i|
                    proc_crtview i,screen_id,""
                end
                plsql.execute("create or replace view #{grpview} as select * from #{view_name}")
               else  ## 
                puts " #{__LINE__}  error"
                insert_command_r 0,"1"," Logic error #{__LINE__}"
              end  ### view_chk.empty?
          else
            puts " #{__LINE__}  error "
            insert_command_r 0,"1"," Logic error #{__LINE__}"
       end 
        insert_command_r 0,"0",nil
  end
  def proc_screendata  screen_id,grpview
       x = {}
       x[:id] = screen_id
       x[:code] = grpview
       x[:viewname] = grpview
       x[:expiredate] = Time.parse("2099/12/31")
       x[:remark] =" auto pre group view field"
       x[:persons_id_upd] = command_r[:sio_user_code]
       x[:created_at] = Time.now
       x[:updated_at] = Time.now
       fprnt " #{__LINE__}  x = #{x}"
       plsql.SCREENS.delete(:viewname => grpview.upcase)
       plsql.SCREENS.insert x
  end  ## proc_screendata

  def proc_crtview  i,screen_id,grpview
      x = {}
      i.each_key do |j|
          if j.to_s =~ /^detailfield/ then       
             char_key = j.to_s.split("_",2)[1]
             sym_key  = char_key.to_sym
             x[sym_key] = i[j]
             if char_key == "code" then 
                if i[j].split("_")[0] == grpview[3..-2] then
                   x[sym_key] << "_" + grpview[0..1]
                end
             end   ###
          end
       end
       x[:id] =   plsql.DETAILFIELDS_seq.nextval 
       x[:screens_id] = screen_id        
       x[:selection] = 0
       x[:expiredate] = Time.parse("2099/12/31")
       x[:remark] = " auto pre group view field"
       x[:persons_id_upd] = command_r[:sio_user_code]
       x[:created_at] = Time.now
       x[:updated_at] = Time.now
       fprnt " 302 x = #{x}"
       plsql.DETAILFIELDS.insert x
  end  ## proc_crtview
  def crt_grpv     ### group viewの作成 r_screenが呼ばれるのず条件
      ### view_name =   str_to_hash["screen_viewname"] 
      ### puts "　#{__LINE__}  view_name  #{ view_name }" 
       #####   テーブルから持ってくるようにする。
      str_select = " select min(id) id,"
      str_group  = "group by "
      ### str_where  = "" ###group ではwhere　項目はひとつ以上必須　画面でチェック
      view_name = command_r[:screen_viewname]
      view_chk = plsql.R_DETAILFIELDS.all("where screen_viewname = '#{view_name }'")
      if view_name =~ /^H\d_/ then
         unless view_chk.nil? then
                dscreen_id = plsql.SCREENS.first("where viewname = 'D#{view_name[1..-1]}'")[:id] 
                view_chk.each do |i|
                    if i[:detailfield_selection] == 1 then
                       str_select <<  i[:detailfield_code] + ","
                       str_group <<  i[:detailfield_code] + ","
                          plsql.DETAILFIELDS.update(:hideflg => 1,:where =>{:screens_id =>dscreen_id,:code => i[:code]})
                      else
                          plsql.DETAILFIELDS.delete(:id => i[:id])
                     end
                     ### if i[:detailfield_paragraph] == 1 then  ### 条件選択が出来てない
                     ###　　str_where << " and "  unless str_where == "
                     ###　　str_where << " where " if str_where == ""
                     ###   str_where 
                     ### end
                end
               else  ## 
                puts " #{__LINE__}  error"
              end  ### view_chk.empty?
          else
            puts "  #{__LINE__}   error view_name #{view_name} "
       end 
        p "error select=1 nothing" if  str_select == "select min(id) id,"  ##処理中止
        str_select.chop!
        str_select << " FROM R#{view_name[2..-1]}   "
        str_group.chop!
       fprnt "str_select = '#{str_select}' str_group = '#{str_group}' view_name = '#{view_name}' "
       plsql.SCREENS.update(:strselect=>str_select,:strgrouporder =>str_group,:where=>{:viewname=>view_name})

    crt_sio_tbl  view_name,view_chk
    
    insert_command_r 0,"0",nil
  end

def crt_sio_tbl  tblnamex ,view_chk
     tsqlstr =  "CREATE TABLE " + "SIO_" + tblnamex   + " (\n" 
     tsqlstr <<  "          id numeric(38)  CONSTRAINT " +  "SIO_" + tblnamex   + "_id_pk PRIMARY KEY \n"
     tsqlstr <<  "          ,sio_user_code numeric(38)\n"
     tsqlstr <<  "          ,sio_Term_id varchar(30)\n"
     tsqlstr <<  "          ,sio_session_id varchar(256)\n"
     tsqlstr <<  "          ,sio_Command_Response char(1)\n"
     tsqlstr <<  "          ,sio_session_counter numeric(38)\n"
     tsqlstr <<  "          ,sio_classname varchar(30)\n" 
     tsqlstr <<  "          ,sio_viewname varchar(30)\n"
     tsqlstr <<  "          ,sio_strsql varchar(4000)\n"
     tsqlstr <<  "          ,sio_totalcount numeric(38)\n"
     tsqlstr <<  "          ,sio_recordcount numeric(38)\n"
     tsqlstr <<  "          ,sio_start_record numeric(38)\n"
     tsqlstr <<  "          ,sio_end_record numeric(38)\n"
     tsqlstr <<  "          ,sio_sord varchar(256)\n"
     tsqlstr <<  "          ,sio_search varchar(10)\n"
     tsqlstr <<  "          ,sio_sidx varchar(256)\n"
     tsqlstr  <<            sio_fields(view_chk)
     tsqlstr <<  "          ,sio_add_time date\n"
     tsqlstr <<  "          ,sio_replay_time date\n"
     tsqlstr <<  "          ,sio_result_f char(1)\n"
     tsqlstr <<  "          ,sio_message_code char(10)\n"
     tsqlstr <<  "          ,sio_message_contents varchar(256)\n"
     tsqlstr <<  "          ,sio_chk_done char(1)\n"
     tsqlstr <<  ")\n"
      chk_tbl = plsql.USER_TABLES.first("where  table_name = 'SIO_#{tblnamex}'")
    
     plsql.execute  " drop table SIO_#{tblnamex} \n" unless chk_tbl.nil?
     fprnt "str = '#{tsqlstr}'"
     plsql.execute tsqlstr

     tsqlstr =  " CREATE INDEX SIO_#{tblnamex}_uk1 \n"
     tsqlstr << "  ON SIO_#{tblnamex}(sio_user_code,sio_session_id) \n"
     tsqlstr << "  TABLESPACE USERS  STORAGE (INITIAL 20K  NEXT 20k  PCTINCREASE 75)"     
    plsql.execute tsqlstr

    seq_name =  "SIO_#{tblnamex}_SEQ"
    chk_seq = plsql.USER_SEQUENCES.first("where  sequence_name = '#{seq_name}'")
    plsql.execute "create sequence #{seq_name}"  if chk_seq.nil? 

end #crt_sio_tbl 

def sio_fields view_chk
     strsql = " ,"
      view_chk.each do |i|
         jj = i[:detailfield_code]
         jj <<  "_tbl" if jj == "ID"
         strsql << jj + " " + i[:detailfield_type] + " "
         strsql << "(" +  i[:detailfield_length].to_s + ") " if i[:detailfield_type] =~ /CHAR/
         if i[:detailfield_type] == "NUMBER" then
             spr = i[:detailfield_dataprecision].to_s
             ssc = i[:detailfield_datascale].to_s
             strsql << "(" +  spr + "," + ssc + ") " if spr =~ /[0..9]/    
         end
         strsql << "," 
      end   ## view_chk.each do |i|
    return strsql.chop
 end


## drt 1:順方向　2:逆方向  k_dir:指示ファイル区分 k_start 日、週、時間  @cnt_id = 1
 def set_pre_process wh_key,tmp_seq,tmp_cnt  ## 前工程のセット
     strsql = "where itm_id = #{wh_key[0]}  and opeitm_priority =   #{wh_key[1]} 
               and opeitm_process_seq = (select max(process_seq)
               from  opeitms b where b.itms_id =  #{wh_key[0]}
                and opeitm_priority =  #{wh_key[1]} 
                and   b.process_seq  <  #{tmp_seq} )" 
     p " strsql = #{strsql} "
     opeitms = plsql.r_opeitms.all(strsql)
     unless opeitms.nil?  or opeitms.empty? then
       opeitms.each do |i|
         @cnt_id += 1
         @tmp_depends[tmp_cnt] = ",depends:{id : "  if  @tmp_depends[tmp_cnt].nil?
         @tmp_depends[tmp_cnt]  << "#{@cnt_id.to_s} ," 
         @loop_itm_id << {@cnt_id => [nil,i[:opeitm_priority],i[:opeitm_process_seq],i[:id]]}  
       end  ###  opeitms.each do |i|
      end ##  unless opeitms.nil?  or opeitms.empty? then
 end  ###  def set_pre_process 
 def set_chil_ref j,tmp_cnt  ### j:親のopeitm_id
     ### 有効日以上　最小有効日のものをセットするように変更要
     strsql = " where opeitm_id = #{j} and chilitm_Expiredate > sysdate order by itm_code_chil "
     tmp_r_chilitms = plsql.r_chilitms.all(strsql)
     tmp_r_chilitms.each do |k|
       @cnt_id += 1
       @tmp_depends[tmp_cnt] = " ,depends:{id: "  if @tmp_depends[tmp_cnt].nil?
       @tmp_depends[tmp_cnt] << "#{@cnt_id} ,"   ###親に自分をセット
       @loop_itm_id << {@cnt_id => [nil,k[:opeitm_priority_chil],k[:opeitm_process_seq_chil],k[:opeitm_id_chil]]}
     end  ###  tmp_r_chilitms = 
     ### p "yyy  @loop_itm_id #{@loop_itm_id}" 
     ###  depend data set
     unless @tmp_depends[tmp_cnt].nil? then
       @tmp_depends[tmp_cnt].chop! 
       @tmp_depends[tmp_cnt] << "}}]}"
      else 
       @tmp_depends[tmp_cnt] = "}]}"
     end
 end  ## def set_chil_ref
 def insert_command_r recordcount,result_f,contents
      command_r[:sio_recordcount] = recordcount
      command_r[:sio_result_f] = result_f
      command_r[:sio_message_contents] = contents
      command_r[:sio_replay_time] = Time.now
      tmp_seq = "#{@cmd_ts[4]}_seq"
      command_r.each_key do |j_key|  ##cbol 対策
             command_r.delete(j_key) if command_r[j_key].nil?
      end
      command_r[:id] = plsql.__send__(tmp_seq).nextval
      fprnt "@cmd_ts[4] =  #{@cmd_ts[4]}  command_r #{command_r}  "
      plsql.__send__(@cmd_ts[4]).insert command_r
 end
rescue Exception => e
  p e.backtrace
  p "blk error"  # => "unhandled exception"

end ## class 


