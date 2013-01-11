class Blkclass
######
  def initialize cmd_ts 
      ## p "a" + Time.now.to_s
      @chk_cmn = [] 
      @cmd_ts = Array.new 
      @cmd_ts = cmd_ts
      const = "C"
      ## isert,update,deleteは複数件を許す
      ## 一括処理　一括コミット　(一件でもエラーが有ると登録しない)  対応しない。
      ## 個別処理　一括コミット　ＯＫ分のみ登録　同一セッションカウンタ
      ## 個別処理　個別コミット　　個別のセッションカウンタ
      fprnt " @cmd_ts[4]  #{@cmd_ts[4]}"
      strsql = "where sio_term_id =  '#{@cmd_ts[1]}' and sio_session_id = '#{@cmd_ts[2]}' 
                and sio_session_counter = #{@cmd_ts[3]} and sio_command_response = '#{const}'"
      fprnt "strsql #{strsql}"
      @chk_cmn =  plsql.__send__(@cmd_ts[4]).all(strsql)
  end
  def fprnt str
    foo = File.open("blk#{Process::UID.eid.to_s}#{@cmd_ts[4]}.log", "a") # 書き込みモード
    foo.puts str
    foo.close
  end 

  def plsql_blk_insert  
  ###  r_XXXX のviewのみに対応　実際には　XXXXのテーブルにINSERT    
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
       sub_chk_cmd "delete"
  end   ###plsql_blk_delete 

    ### update deleteでも共通で使用できるようにする。　@chk_cmn.each do |i|
  def sub_chk_cmd iud
    r_cnt = 0
    fprnt " #{__LINE__}  @chk_cmn = '#{@chk_cmn}' "
    tblname = @chk_cmn[0][:sio_viewname].split(/_/)[1].chop  ### sは取る。
    @chk_cmn.each do |i|   ##複数レコードの処理
      r_cnt += 1
      tmp_isrt = {}
      tmp_key = {}
      i.each do |j,k|
        j_to_s = j.to_s
        if j_to_s.split(/_/,2)[0] == tblname then  ##本体の更新
           tmp_isrt[j_to_s.split(/_/,2)[1].to_sym] = k  unless k.nil?  ###org tbl field name
          else  ### link先のidを求める
	  if   j_to_s =~ /(_upd|sio_)/ or k.nil?  then
             else
               tmp_key[j] = k  ##tmp_key[j] = other tablename+_+fielfname+_+shikibetushi  <-- value
          end  ## unless j_to_s
        end   ## if j_to_s.
      end ## i
      tmp_isrt = sub_code_to_id(tmp_key,tmp_isrt) unless  tmp_key == {}
      tblname = tblname + "s"
      fprnt "tblname  = '#{tblname}' ,tmp_key = #{tmp_key} ,tmp_isrt = #{tmp_isrt}  "
      case iud
         when "insert" then
            tmp_isrt[:id] = plsql.__send__(tblname + "_seq").nextval
            tmp_isrt[:persons_id_upd] = i[:sio_user_code]
            tmp_isrt[:created_at] = Time.now
            plsql.__send__(tblname).insert tmp_isrt
          when "update" then
            tmp_isrt[:updated_at] = Time.now
            tmp_isrt[:persons_id_upd] = i[:sio_user_code]
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
                save_key = key.to_s   ## tblname fieldname other tbl name
                strwhere <<   key.to_s.split(/_/)[1] + " = '#{value}'  and "
            end	
         tmp_isrt.merge! sub_get_main_data(strwhere,save_key)
         return   tmp_isrt
  end
  ### code + exipredateでユニークであること
  def   sub_get_main_data strwhere,save_key
        others_tbl_id_isrt = {}
        strwhere = strwhere[0..-5] + " order by  Expiredate"
        tblname = save_key.split(/_/,2)[0] + "s"
        fprnt " tblname : #{tblname}   strwhere = '#{strwhere}'"
        aim_id = plsql.__send__(tblname).first(strwhere)
        fprnt "#{__LINE__}  aim_id =  '#{aim_id}',"
        others_tbl_id_isrt[save_key.to_sym] = aim_id[:id] unless aim_id.nil?
        others_tbl_id_isrt[:sio_message_contents] = "logic err" if aim_id.nil?
        return  others_tbl_id_isrt
  end   ### def sub_get...
##  def str_to_hash
##       tmp_array = command_r[:sio_strsql].split(",")
##       fprnt "command_r[:sio_strsql] #{command_r[:sio_strsql]}"
##       fprnt "tmp_array #{tmp_array}"
##       return Hash[*tmp_array]
##  end 
 def insert_command_r recordcount,result_f,contents
      command_r = {}
      command_r[:sio_command_response] = "R"
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


