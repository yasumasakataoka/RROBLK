class DbCud
  @queue = :default
  def self.perform(sio_id,sio_view_name)
      strsql = "where sio_session_counter = #{sio_id} and sio_command_response = 'C'"
      fprnt "class #{self} : LINE #{__LINE__} strsql #{strsql}"
      @chk_cmn =  plsql.__send__(sio_view_name).all(strsql)
      @chk_cmn.each do |i|
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
           case i[:sio_classname]
                when "plsql_blk_insert" then
                    tmp_isrt[:id] = plsql.__send__(tblname + "_seq").nextval
                    tmp_isrt[:persons_id_upd] = i[:sio_user_code]
                    tmp_isrt[:created_at] = Time.now
                    plsql.__send__(tblname).insert tmp_isrt
                when "plsql_blk_update" then
                    tmp_isrt[:updated_at] = Time.now
                    tmp_isrt[:persons_id_upd] = i[:sio_user_code]
                    tmp_isrt[:where] = {:id => i[:id_tbl]}
                    ### fprnt  "update : tmp_isrt = #{tmp_isrt}"
                    plsql.__send__(tblname).update  tmp_isrt
                when "plsql_blk_delete" then 
                    plsql.__send__(tblname).delete(:id => i[:id_tbl])
                end   ## case iud 
           insert_command_r do
	       command_r[:sio_recordcount] = r_cnt
               command_r[:sio_result_f] = "0"
               command_r[:sio_message_contents] = nil
           end 
      end   ##chk_cmn.each 
      plsql.commit
  end   ## self
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
        fprnt " aim_id =  '#{aim_id}',"
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
end ## class 


